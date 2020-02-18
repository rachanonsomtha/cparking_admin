import 'package:c_admin/routing/route_names.dart';
import 'package:flutter/material.dart';
import './navigation_item.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 80,
            child: Text(
              'C-Parking',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NavBarItem(
                'Reports',
                ReportRoute,
              ),
              SizedBox(
                width: 60,
              ),
              NavBarItem(
                'Users',
                UserRoute,
              ),
            ],
          )
        ],
      ),
    );
  }
}
