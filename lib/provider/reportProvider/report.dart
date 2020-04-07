import 'package:flutter/foundation.dart';

class Report with ChangeNotifier {
  @required
  final String id;
  @required
  final String userName;
  @required
  final int lifeTime;
  @required
  final String imageUrl;
  @required
  final String dateTime;
  bool isPromoted;
  int score;
  @required
  int availability;
  @required
  final String loc;
  final String imgName;

  Report({
    @required this.id,
    @required this.userName,
    @required this.lifeTime,
    @required this.imageUrl,
    @required this.dateTime,
    this.isPromoted = false,
    this.score = 0,
    @required this.availability,
    @required this.loc,
    this.imgName,
  });
}
