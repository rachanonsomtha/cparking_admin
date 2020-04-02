import 'package:flutter/material.dart';
import '../../provider/userProvider/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Navigation/navigation.dart';
import '../../routing/route_names.dart';
import '../../locator.dart';

class UserView extends StatefulWidget {
  static const routeName = '/user-view';

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<UserData> users = [];
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<UserData>> _getUsers() async {
    var data =
        await http.get("https://cparking-ecee0.firebaseio.com/users.json");

    var jsonData = json.decode(data.body) as Map<String, dynamic>;

    jsonData.forEach((key, value) {
      // print(value['profile']);
      var decodeData = value['profile'] as Map<String, dynamic>;
      decodeData.forEach((key, value) {
        UserData user = UserData(
          id: key,
          email: value['email'],
          profileImageUrl: value['profileImageUrl'],
          userName: value['userName'],
          score: value['score'],
          verified: value['verified'],
        );
        users.add(user);
      });
    });

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _getUsers().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text(
                  "Error...",
                ),
              ),
            );
          }
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text(
                  "Loading...",
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data[index].profileImageUrl),
                  ),
                  title: Text(snapshot.data[index].userName),
                  subtitle: Text(snapshot.data[index].email),
                  onTap: () {
                    _navigationService.navigateToWithUserData(
                        UserDetail, snapshot.data[index]);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class UserDetailPage extends StatelessWidget {
  static const routeName = '/user-detail';

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as UserData;

    return Container(
      child: Center(
          child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(user.profileImageUrl),
            maxRadius: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Email: ${user.email}",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Username: ${user.userName}",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Score: ${user.score.toString()}",
            style: TextStyle(fontSize: 20),
          ),
        ],
      )),
    );
  }
}
