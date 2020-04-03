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

  Future<List<UserData>> getUsers() async {
    users = [];
    var data =
        await http.get("https://cparking-ecee0.firebaseio.com/users.json");

    var jsonData = json.decode(data.body) as Map<String, dynamic>;
    UserData user;
    jsonData.forEach((key, value) {
      var decodeData = value['profile'] as Map<String, dynamic>;
      decodeData.forEach((key, value) {
        user = UserData(
          id: key,
          email: value['email'],
          profileImageUrl: value['profileImageUrl'],
          userName: value['userName'],
          score: value['score'],
          verified: value['verified'],
          reports: [],
        );
      });
      var decodeReportList = value['reportsId'] as Map<String, dynamic>;
      decodeReportList.forEach((key, reportId) {
        user.reports.add(
          reportId.toString(),
        );
      });
    });
    users.add(user);

    return users;
  }

  Future<List<Report>> getReportsFromUserId(List<String> userReportList) async {
    try {
      var data =
          await http.get("https://cparking-ecee0.firebaseio.com/reports.json");

      final decodeData = json.decode(data.body) as Map<String, dynamic>;
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
