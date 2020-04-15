import 'package:c_admin/provider/userProvider/user_provider.dart';
import 'package:flutter/material.dart';
import '../../provider/userProvider/user.dart';
import '../../Navigation/navigation.dart';
import '../../routing/route_names.dart';
import '../../locator.dart';
import '../../provider/reportProvider/report.dart';
import 'package:provider/provider.dart';
import '../../widgets/boarding_pass_card/demo.dart';

class UserView extends StatefulWidget {
  static const routeName = '/user-view';

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<UserData> users = [];
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'All users',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 36,
            fontWeight: FontWeight.w100,
          ),
        ),
        FutureBuilder(
          future:
              Provider.of<UserProvider>(context).getUsers().catchError((error) {
            print(error);
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                    "No user now...",
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: Text(
                    "Loading...",
                  ),
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
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
                      trailing: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Total reports: ${snapshot.data[index].reports.length.toString()}",
                            ),
                            Text(
                              "Score: ${snapshot.data[index].score.toString()}",
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _navigationService.navigateToWithUserData(
                            UserDetail, snapshot.data[index]);
                      },
                    );
                  },
                ),
              );
            }
          },
        )
      ],
    );
  }
}

class UserDetailPage extends StatefulWidget {
  static const routeName = '/user-detail';

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  // List<Report> reports;
  bool sort = true;
  final NavigationService _navigationService = locator<NavigationService>();

  // onSortColumn(int col, bool ascending) {
  //   if (col == 1) {
  //     if (ascending) {
  //       reports.sort((a, b) =>
  //           DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
  //     } else {
  //       reports.sort((a, b) =>
  //           DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));
  //     }
  //   }
  // }

  DataTable dataBody(List<Report> reports) {
    return DataTable(
      showCheckboxColumn: false,
      columns: [
        DataColumn(
          label: Text('Rep.pic'),
        ),
        DataColumn(
          label: Text('Rep.id'),
        ),
        DataColumn(
          label: Text('Date'),
          // onSort: (columnIndex, ascending) {
          //   setState(() {
          //     sort = !sort;
          //   });
          //   onSortColumn(columnIndex, ascending);
          // },
        ),
        DataColumn(
          label: Text('Time'),
        ),
        DataColumn(
          label: Text('Location'),
        ),
        DataColumn(
          numeric: true,
          label: Text('Availability'),
        )
      ],
      rows: reports.reversed
          .map(
            (report) => DataRow(
              onSelectChanged: (b) {
                _navigationService.navigateToWithReportData(
                    ReportDetail, report); //navigate to report detail screen
              },
              cells: [
                DataCell(
                  Image.network(
                    report.imageUrl,
                  ), // Text(report.id.toString()),
                ),
                DataCell(
                  Text(report.id.toString()),
                ),
                DataCell(
                  Text(
                      '${DateTime.parse(report.dateTime).day}/${DateTime.parse(report.dateTime).month}/${DateTime.parse(report.dateTime).year}'),
                ),
                DataCell(
                  Text(
                      '${DateTime.parse(report.dateTime).hour}:${DateTime.parse(report.dateTime).minute.toString().padLeft(2, '0')}'),
                ),
                DataCell(
                  Text(
                    report.loc,
                  ),
                ),
                DataCell(
                  Text(
                    report.availability.toString(),
                  ),
                )
              ],
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as UserData;

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl),
              maxRadius: 60,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${user.userName}",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Email: ${user.email}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
              ),
            ),
            Text(
              "Score: ${user.score.toString()}",
              style: TextStyle(fontSize: 20),
            ),
            StreamBuilder(
              stream: Provider.of<UserProvider>(context)
                  .getReportsFromUserId(user.reports)
                  .catchError((error) {
                print(error);
              }).asStream(),
              builder: (ctx, snapshot) {
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Center(
                      child: Text(
                        "Loading...",
                      ),
                    ),
                  );
                }
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text(
                        "There's no report from this user now...",
                      ),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'User reports',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: dataBody(
                          snapshot.data,
                        ),
                      ),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
