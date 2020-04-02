import 'package:c_admin/locator.dart';
import 'package:c_admin/provider/userProvider/user_provider.dart';
import 'package:c_admin/view/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/reportProvider/report_provider.dart';
import './view/reportView/report_view.dart';
import './view/userView/user_view.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ReportsProvider(null, null),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'C-Parking',
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Open Sans',
              ),
          primarySwatch: Colors.grey,
        ),
        home: HomeView(),
        routes: {
          HomeView.routeName: (context) => HomeView(),
          ReportOverViewScreen.routeName: (context) => ReportOverViewScreen(),
          UserView.routeName: (context) => UserView(),
        },
      ),
    );
  }
}
