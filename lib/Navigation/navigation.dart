import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateToWithData(String routeName, String id) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: id);
  }

  bool goBack() {
    return navigatorKey.currentState.pop();
  }
}
