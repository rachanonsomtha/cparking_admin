import 'package:c_admin/provider/userProvider/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../reportProvider/report.dart';

class UserProvider extends ChangeNotifier {
  List<UserData> users = [];

  int get usersCount {
    return users.length;
  }

  Future<List<UserData>> getUsers() async {
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
        print(user);
        users.add(user);
      });
    });

    return users;
  }

  Future<List<Report>> getReportsFromUserId(List<String> userReportList) async {
    try {
      var data =
          await http.get("https://cparking-ecee0.firebaseio.com/reports.json");

      final decodeData = json.decode(data.body) as Map<String, dynamic>;

      List<Report> reports = [];
      decodeData.forEach((reportId, reportData) {
        // print(value['profile']);
        if ((userReportList.contains(reportId)))
          reports.add(Report(
            id: reportId,
            userName: reportData['userName'],
            imageUrl: reportData['imageUrl'],
            lifeTime: reportData['lifeTime'],
            score: reportData['score'],
            dateTime: reportData['dateTime'].toString(),
            availability: reportData['availability'],
            loc: reportData['loc'],
            imgName: reportData['imgName'],
          ));
      });

      return reports;
    } catch (error) {
      throw (error);
    }
  }
}
