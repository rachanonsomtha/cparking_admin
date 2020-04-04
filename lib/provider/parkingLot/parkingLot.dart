import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ParkLot with ChangeNotifier {
  @required
  final String id;
  @required
  final String title;
  @required
  final double max;
  @required
  final String imageUrl;
  List<double> mean;
  Color color;

  ParkLot({
    this.id,
    this.title,
    this.max,
    this.imageUrl,
    this.color,
  });
}
