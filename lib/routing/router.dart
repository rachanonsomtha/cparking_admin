import 'package:c_admin/view/reportView/reportDetail/report_detail.dart';
import './route_names.dart';
import '../view/welcomeView/cparkingDetails/cparkingDetails.dart';
import '../view/reportView/report_view.dart';
import '../view/userView/user_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../extensions/string_extensions.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  print('generateRoute: ${settings.name}');
  var routingData = settings.name.getRoutingData; // Get the routing Data

  switch (routingData.route) {
    case HomeRoute:
      return _getPageRoute(CparkingDetails(), settings);
    case ReportRoute:
      return _getPageRoute(ReportOverViewScreen(), settings);
    case UserRoute:
      return _getPageRoute(UserView(), settings);
    case ReportDetail:
      return _getPageRoute(ReportDetailView(), settings);
    default:
      return _getPageRoute(CparkingDetails(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings setting) {
  return MaterialPageRoute(
    builder: (context) => child,
    settings: setting,
  );
}
