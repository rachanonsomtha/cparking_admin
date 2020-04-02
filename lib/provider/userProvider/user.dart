import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  // @required
  final String email;
  final String id;
  @required
  final String userName;
  final String profileImageUrl;
  @required
  final int score;
  final int verified;
  List<String> reports;

  UserData({
    this.email,
    this.id,
    this.userName,
    this.profileImageUrl,
    this.score,
    this.verified,
    this.reports,
  });
}
