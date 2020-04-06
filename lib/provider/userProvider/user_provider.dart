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

  List<UserData> getUsersData() {
    return users;
  }

  Future<int> getUserCount() async {
    var data =
        await http.get("https://cparking-ecee0.firebaseio.com/users.json");
    var jsonData = json.decode(data.body) as Map;
    return jsonData.length;
  }

  Future<List<UserData>> getUsers() async {
    users = [];
    var data =
        await http.get("https://cparking-ecee0.firebaseio.com/users.json");

    var jsonData = json.decode(data.body) as Map<String, dynamic>;
    UserData user;
    jsonData.forEach((key, value) {
      var decodeData = value['profile'] as Map<String, dynamic>;
      if (decodeData != null)
        decodeData.forEach((key, data) {
          print(data['email']);
          user = UserData(
            id: key,
            email: data['email'],
            profileImageUrl: data['profileImageUrl'],
            userName: data['userName'],
            score: data['score'],
            verified: data['verified'],
            reports: [],
          );
        });
      var decodeReportList = value['reportsId'] as Map<String, dynamic>;
      if (decodeReportList != null)
        decodeReportList.forEach((key, reportId) {
          user.reports.add(
            reportId.toString(),
          );
        });
      users.add(user);
    });

    return users;
  }

  Future<List<Report>> getReportsFromUserId(List<String> userReportList) async {
    try {
      var data =
          await http.get("https://cparking-ecee0.firebaseio.com/reports.json");

      final decodeData = json.decode(data.body) as Map<String, dynamic>;
      if (decodeData == null) return null;
      List<Report> reports = [];
      decodeData.forEach((reportId, reportData) {
        if ((userReportList.contains(reportId)))
          reports.add(
            Report(
              id: reportId,
              userName: reportData['userName'],
              imageUrl: reportData['imageUrl'],
              lifeTime: reportData['lifeTime'],
              score: reportData['score'],
              dateTime: reportData['dateTime'].toString(),
              availability: reportData['availability'],
              loc: reportData['loc'],
              imgName: reportData['imgName'],
            ),
          );
      });
      return reports;
    } catch (error) {
      throw (error);
    }
  }
}
