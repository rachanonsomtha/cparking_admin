import 'package:c_admin/NavigationBar/navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../centeredView/centered_view.dart';
import '../../Navigation/navigation.dart';
import '../../routing/route_names.dart';
import '../../locator.dart';
import 'package:c_admin/routing/router.dart';

class HomeView extends StatelessWidget {
  static const routeName = '/home-screeen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: CenteredView(
          child: Column(
        children: <Widget>[
          NavigationBar(),
          Expanded(
            child: Navigator(
              key: locator<NavigationService>().navigatorKey,
              onGenerateRoute: generateRoute,
              initialRoute: HomeRoute,
            ),
          ),
        ],
      )),
    );
  }
}

class ReportView {}
