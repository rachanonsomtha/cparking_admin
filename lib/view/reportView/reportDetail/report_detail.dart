import 'package:c_admin/provider/parkingLot/parking_provider.dart';
import 'package:c_admin/provider/userProvider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/reportProvider/report.dart';
import '../../../provider/userProvider/user_provider.dart';
import '../../../Navigation/navigation.dart';
import '../../../locator.dart';
import '../../../widgets/boarding_pass_card/ticket.dart';
import 'dart:math';
import '../../../widgets/boarding_pass_card/demo_data.dart' as boardingModel;

class ReportDetailView extends StatefulWidget {
  @override
  _ReportDetailViewState createState() => _ReportDetailViewState();
}

class _ReportDetailViewState extends State<ReportDetailView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final List<int> _openTickets = [];
  final ScrollController _scrollController = ScrollController();

  _getOpenTicketsBefore(int ticketIndex) {
    // Search all indexes that are smaller to the current index in the list of indexes of open tickets
    return _openTickets.where((int index) => index < ticketIndex).length;
  }

  bool _handleClickedTicket(int clickedTicket) {
    // Scroll to ticket position
    // Add or remove the item of the list of open tickets
    _openTickets.contains(clickedTicket)
        ? _openTickets.remove(clickedTicket)
        : _openTickets.add(clickedTicket);

    // Calculate heights of the open and closed elements before the clicked item
    double openTicketsOffset =
        Ticket.nominalOpenHeight * _getOpenTicketsBefore(clickedTicket);
    double closedTicketsOffset = Ticket.nominalClosedHeight *
        (clickedTicket - _getOpenTicketsBefore(clickedTicket));

    double offset = openTicketsOffset +
        closedTicketsOffset -
        (Ticket.nominalClosedHeight * .5);

    // Scroll to the clicked element
    _scrollController.animateTo(max(0, offset),
        duration: Duration(seconds: 1),
        curve: Interval(.25, 1, curve: Curves.easeOutQuad));
    // Return true to stop the notification propagation
    return true;
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
          child: Container(
        child: FutureBuilder(
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
            if (snapshot.connectionState == ConnectionState.waiting) {
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
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Expanded(
                    child: ListView(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Ticket(
                          report: report,
                          boardingPass: boardingModel.BoardingPassData(
                            passengerName: 'Owned by', // "Owned by"
                            origin: boardingModel.Airport(
                              code: snapshot.data.userName,
                              city: snapshot.data.email,
                            ), // code : snapshot.data.userName, city: parkingInfo: snapshot.data.email
                            destination: boardingModel.Airport(
                              code: parkinglotinfo.id,
                              city: parkinglotinfo.title,
                            ), // code: parkingInfo.id , city: parkingInfo.title
                            duration: boardingModel.Duration(
                              hours: 0,
                              minutes: report.lifeTime.toInt(),
                            ), //Duration(minute: report.lifetime.toInt)
                            boardingTime: "Parkinglot Info",
                            departs: DateTime.parse(report
                                .dateTime), // DateTime.parse(report.dateTime)
                            arrives: DateTime.parse(report.dateTime).add(
                              Duration(minutes: report.lifeTime),
                            ), //(DateTime.parse(report.dateTime).add(Duration(minute: report.lifetime))
                            gate: report.lifeTime
                                .toString(), // report.lifetime.toString
                            zone: report.availability, //report.availability
                            seat: report.score.toString(), //report.score
                            flightClass: report.imgName, //report.imageName
                            flightNumber: report.id,
                          ), //report.id
                          onClick: () => _handleClickedTicket(1),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      )),
    );
  }
}
