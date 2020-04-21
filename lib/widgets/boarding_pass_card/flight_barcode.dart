import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../provider/reportProvider/report.dart';
import '../custom_dialog/custom_dialog.dart';

class FlightBarcode extends StatelessWidget {
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
            child: Text('Delete this report?'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  deleteText: 'Confirmed',
                  report: report,
                  title: "Delete this report?",
                  description:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  buttonText: "Cancel",
                ),
              );
            },
          ),
        ),
      );
}
