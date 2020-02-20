import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'dart:async';
import '../userProvider/user.dart';

class UserProvider extends ChangeNotifierProvider {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  // String _userName;

  UserData _userData;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  UserData get userData {
    // print(userData.userName);
    return _userData;
  }

  int get userReportsCount {
    return _userData.reports.length;
  }

  UserData _tempUserData;

  UserData get tempUserData {
    return _tempUserData;
  }

  Future<void> fetchUserDataFromUserId(String userIds) async {
    print(userId);
    final url =
        'https://cparking-ecee0.firebaseio.com/users/$userIds/profile.json';
    try {
      await http.get(url).then((value) {
        final decodeData = json.decode(value.body) as Map<String, dynamic>;
        decodeData.forEach((userId, userData) {
          // print(userData['profileImageUrl']);
          _tempUserData = UserData(
            userName: userData['userName'],
            id: userId,
            score: userData['score'],
            profileImageUrl: userData['profileImageUrl'].toString(),
            reports: [],
          );
        });
      });
    } catch (error) {
      print(error);
    }
  }
}
