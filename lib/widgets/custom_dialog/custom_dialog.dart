import 'package:flutter/material.dart';
import '../../provider/reportProvider/report.dart';
import '../../Navigation/navigation.dart';
import '../../locator.dart';
import 'package:provider/provider.dart';
import '../../provider/reportProvider/report_provider.dart';
import '../../routing/route_names.dart';

class CustomDialog extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  final String title, description, buttonText, deleteText;
  final Image image;
  final Report report;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    @required this.deleteText,
    @required this.report,
    this.image,
  });

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          width: 500,
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    hoverColor: Colors.red,
                    onPressed: () async {
                      await Provider.of<ReportsProvider>(context)
                          .deleteReport(report)
                          .whenComplete(() => {
                                _navigationService.navigateTo(ReportRoute),
                              });
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Text(deleteText),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Text(buttonText),
                  ),
                ],
              )
            ],
          ),
        ),
        //...top circlular image part,
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            child: Icon(
              Icons.delete,
            ),
            backgroundColor: Colors.blueAccent,
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
