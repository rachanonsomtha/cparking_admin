import 'package:c_admin/provider/userProvider/user.dart';
import 'package:flutter/material.dart';

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

  Future<dynamic> navigateTo(String routeName,
      {Map<String, String> queryParams}) {
    if (queryParams != null) {
      routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    }
    return navigatorKey.currentState.pushNamed(routeName);
  }
}
