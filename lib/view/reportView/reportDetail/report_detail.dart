import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/reportProvider/report_provider.dart';
import '../../../provider/reportProvider/report.dart';

class ReportDetailView extends StatefulWidget {
  @override
  _ReportDetailViewState createState() => _ReportDetailViewState();
}

class _ReportDetailViewState extends State<ReportDetailView> {
  Widget _buildReportPicture(Report report) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      width: 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            report.imageUrl.toString(),
          ),
        ),
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
    final reportId = ModalRoute.of(context).settings.arguments as String;
    final report = Provider.of<ReportsProvider>(context).findById(reportId);
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            _buildReportPicture(report),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.height / 2.5,
                  ),
                  _buildReportName(report),
                  _buildDetail(report),
                  _buildSeparator(screenSize),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.redAccent,
                    onPressed: () {
                      Provider.of<ReportsProvider>(context)
                          .deleteReport(report);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            'Delete report',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
