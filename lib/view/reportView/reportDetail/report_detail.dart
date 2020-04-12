import 'package:c_admin/provider/parkingLot/parking_provider.dart';
import 'package:c_admin/provider/reportProvider/report_provider.dart';
import 'package:c_admin/provider/userProvider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/reportProvider/report.dart';
import '../../../provider/userProvider/user_provider.dart';
import '../../../Navigation/navigation.dart';
import '../../../routing/route_names.dart';
import '../../../locator.dart';

class ReportDetailView extends StatefulWidget {
  @override
  _ReportDetailViewState createState() => _ReportDetailViewState();
}

class _ReportDetailViewState extends State<ReportDetailView> {
  bool _isLoading = false;
  final NavigationService _navigationService = locator<NavigationService>();

  Widget _buildReportPicture(Report report) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(report.imageUrl),
        maxRadius: 200,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Center(
      child: Container(
        width: screenSize.width / 1.2,
        height: 2.0,
        color: Colors.white70,
        margin: EdgeInsets.only(top: 20.0),
      ),
    );
  }

  Widget _buildReportName(Report report) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          'Report',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontFamily: 'Open Sans',
          ),
        ),
        Text(
          report.id,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    ));
  }

  Widget _buildDetail(Report report) {
    DateTime dateTime = DateTime.parse(report.dateTime.toString());

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Parkability : ${report.availability}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
              Text(
                'Date :${dateTime.day}/${dateTime.month}/${dateTime.year}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
              Text(
                'Time :${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final report = ModalRoute.of(context).settings.arguments as Report;
    final parkinglotinfo =
        Provider.of<ParkingLotProvider>(context).findById(report.loc);
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200, // reports picture here
              width: MediaQuery.of(context).size.width,
              color: Colors.indigo,
              child: Container(
                height: screenSize.height / 2.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(report.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Report id: ${report.id}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        'Availability: ${report.availability}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        '${DateTime.parse(report.dateTime).day}/${DateTime.parse(report.dateTime).month}/${DateTime.parse(report.dateTime).year}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        '${DateTime.parse(report.dateTime).hour}:${DateTime.parse(report.dateTime).minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        'Location: ${parkinglotinfo.title}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        'Lifetime: ${report.lifeTime}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w100),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: Provider.of<UserProvider>(context)
                            .getUserDataFromReportId(report.userName),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasError) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "Error...",
                                ),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "Loading...",
                                ),
                              ),
                            );
                          }
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "No data now...",
                                ),
                              ),
                            );
                          } else {
                            return Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () =>
                                      _navigationService.navigateToWithUserData(
                                          UserDetail, snapshot.data),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snapshot.data.profileImageUrl,
                                    ),
                                    maxRadius: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data.email,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      OutlineButton(
                        hoverColor: Colors.red,
                        child: Text('delete this report'),
                        onPressed: () async {
                          await Provider.of<ReportsProvider>(context)
                              .deleteReport(report)
                              .whenComplete(() => {
                                    _navigationService.navigateTo(ReportRoute),
                                  });
                        },
                      )
                    ],
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
