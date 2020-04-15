import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../provider/reportProvider/report_provider.dart';
import 'package:provider/provider.dart';
import '../../Navigation/navigation.dart';
import '../../routing/route_names.dart';
import '../../locator.dart';
import '../../provider/reportProvider/report.dart';

class FlightBarcode extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  final Report report;

  FlightBarcode(this.report);
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: OutlineButton(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            hoverColor: Colors.red[300],
            child: Text('Delete this report'),
            onPressed: () async {
              await Provider.of<ReportsProvider>(context)
                  .deleteReport(report)
                  .whenComplete(() => {
                        _navigationService.navigateTo(ReportRoute),
                      });
            },
          ),
        ),
      );
}
