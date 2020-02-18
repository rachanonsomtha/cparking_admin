import './route_names.dart';
import '../view/welcomeView/cparkingDetails/cparkingDetails.dart';
import '../view/reportView/report_view.dart';
import '../view/userView/user_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  print('generateRoute: ${settings.name}');
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(CparkingDetails());
    case ReportRoute:
      return _getPageRoute(ReportOverViewScreen());
    case UserRoute:
      return _getPageRoute(UserView());
    default:
      return _getPageRoute(CparkingDetails());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}
