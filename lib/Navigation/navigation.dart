import 'package:c_admin/provider/userProvider/user.dart';
import 'package:flutter/material.dart';
import '../provider/reportProvider/report.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Future<dynamic> navigateTo(String routeName) {
  //   return navigatorKey.currentState.pushNamed(routeName);
  // }

  Future<dynamic> navigateToWithData(String routeName, String id) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: id);
  }

  Future<dynamic> navigateToWithUserData(String routeName, UserData id) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: id);
  }

  Future<dynamic> navigateToWithReportData(String routeName, Report report) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: report);
  }

  void pop() {
    return navigatorKey.currentState.pop();
  }

  Future<dynamic> navigateTo(
    String routeName,
  ) {
    // if (queryParams != null) {
    //   routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    // }
    return navigatorKey.currentState.pushNamed(routeName);
  }
}
