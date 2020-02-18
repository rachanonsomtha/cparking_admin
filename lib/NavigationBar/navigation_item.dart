import 'package:flutter/material.dart';
import 'package:c_admin/locator.dart';
import '../Navigation/navigation.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final String routingPath;
  const NavBarItem(
    this.title,
    this.routingPath, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<NavigationService>().navigateTo(routingPath);
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
