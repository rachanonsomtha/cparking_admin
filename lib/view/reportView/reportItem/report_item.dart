import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/reportProvider/report.dart';
//rating
import 'dart:math';
import '../../../Navigation/navigation.dart';
import '../../../locator.dart';
import '../../../routing/route_names.dart';

class ReportItem extends StatefulWidget {
  // final report = Provider.of<ReportsProvider>(context, listen: false);

  // ReportItem(
  //   this.userName,
  //   this.lifeTime,
  //   this.dateTime,
  //   this.imageUrl,
  //   this.availability,
  //   this.isPromoted,
  //   this.score,
  // );
  @override
  _ReportItemState createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  String _isanimate = 'go';
  bool _isLoading = false;

// calculate displayed lifetime bar
  double ratioCalculate(DateTime submitTime, Duration lifeTime) {
    DateTime expTime = submitTime.add(lifeTime);

    if ((DateTime.now()).isBefore(expTime)) {
      return ((((DateTime.now()).millisecondsSinceEpoch -
                  expTime.millisecondsSinceEpoch) /
              lifeTime.inMilliseconds))
          .abs();
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('eiei');
    double rating = 2.5;
    final report = Provider.of<Report>(context);
    print(report.imageUrl);
    DateTime dateTime = DateTime.parse(report.dateTime.toString());

    double remainingTime = ratioCalculate(
      DateTime.parse(report.dateTime),
      new Duration(minutes: report.lifeTime),
    );
    // print(dateTime.minute);
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.height / 8,
              child: GestureDetector(
                onTap: () {
                  locator<NavigationService>().navigateTo(ReportDetail);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 8,
                    child: Image.network(
                      report.imageUrl.toString(),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: Text('color loader'),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Availability: ${report.availability}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Time: ${dateTime.hour}:${dateTime.minute}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
