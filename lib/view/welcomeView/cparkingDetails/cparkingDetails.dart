import 'package:c_admin/provider/parkingLot/parking_provider.dart';
import 'package:c_admin/provider/reportProvider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/fl_chart/bar_chart_1.dart';
import '../../../widgets/fl_chart/pie_chart.dart';
import '../../../widgets/cards/card_tile.dart';
import '../../../provider/userProvider/user_provider.dart';

class CparkingDetails extends StatefulWidget {
  @override
  _CparkingDetailsState createState() => _CparkingDetailsState();
}

class _CparkingDetailsState extends State<CparkingDetails> {
  double _value = 1;
  bool showWeekday = true;
  List<List<double>> _meanList = [];

  String weekDay(double val) {
    String weekDay;
    switch (val.toInt()) {
      case 1:
        weekDay = 'Monday';
        break;
      case 2:
        weekDay = 'Tuesday';
        break;
      case 3:
        weekDay = 'Wednesday';
        break;
      case 4:
        weekDay = 'Thursday';
        break;
      case 5:
        weekDay = 'Friday';
        break;
    }
    return weekDay;
  }

  Color weekDayColor(double val) {
    Color color;
    switch (val.toInt()) {
      case 1:
        color = Colors.yellow[300];
        break;
      case 2:
        color = Colors.pink;
        break;
      case 3:
        color = Colors.green;
        break;
      case 4:
        color = Colors.orange;
        break;
      case 5:
        color = Colors.blue;
        break;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final parkingLotPvd = Provider.of<ParkingLotProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          showWeekday
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Selected: ", // change to weekday that selected
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "${weekDay(_value).toString()}", // change to weekday that selected
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: weekDayColor(_value),
                      ),
                    )
                  ],
                )
              : SizedBox(
                  height: 1,
                ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color.fromRGBO(109, 120, 136, 0.6),
                  inactiveTrackColor: const Color.fromRGBO(109, 120, 136, 0.6),
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbColor: Colors.indigo,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Slider(
                  min: 1,
                  max: 5,
                  value: _value,
                  onChangeEnd: (_) async {
                    setState(() {
                      showWeekday = true;
                    });
                    _meanList = await Provider.of<ParkingLotProvider>(context)
                        .getLotMeanByWeekday(_value.toInt());
                  },

                  onChanged: (value) {
                    setState(() {
                      showWeekday = false;
                      _value = value;
                    });
                  },
                  divisions: 4,
                  // label: weekDay(_value).toString(),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FutureBuilder(
                    future: Provider.of<UserProvider>(context).getUserCount(),
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
                      } else {
                        return CardTile(
                          iconBgColor: Colors.blueGrey,
                          cardTitle: 'Total users',
                          icon: Icons.person_outline,
                          subText: 'Total users',
                          mainText: snapshot.data.toString(),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  FutureBuilder(
                    future: Provider.of<ReportsProvider>(context)
                        .getAllReportsCount(),
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
                      } else {
                        return CardTile(
                          iconBgColor: Colors.blueGrey,
                          cardTitle: 'Total reports',
                          icon: Icons.select_all,
                          subText: 'All reports',
                          mainText: snapshot.data.toString(),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  FutureBuilder(
                    future: Provider.of<ReportsProvider>(context)
                        .getReportsCountFromToday(),
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
                      } else {
                        return CardTile(
                          iconBgColor: weekDayColor(_value),
                          cardTitle: 'Rep from today',
                          icon: Icons.today,
                          subText: 'Reports from ${weekDay(_value)}',
                          mainText: snapshot.data.toString(),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  FutureBuilder(
                    future: Provider.of<ReportsProvider>(context)
                        .getAllReportsCountFromThisWeek(),
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
                      } else {
                        return CardTile(
                          iconBgColor: Colors.blueGrey,
                          cardTitle: 'Rep from week',
                          icon: Icons.today,
                          subText: 'Reports from this week',
                          mainText: snapshot.data.toString(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 4,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(7, (index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      child: FutureBuilder(
                        future: Provider.of<ParkingLotProvider>(context)
                            .getLotMeanByWeekday(_value.toInt()),
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
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "Loading...",
                                ),
                              ),
                            );
                          } else {
                            return BarChartSample1(
                              parkingLotPvd.parkingLots[index],
                              snapshot.data[index],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // PieChartSample2(),
        ],
      ),
    );

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: <Widget>[
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Text(
    //           'C-PARKING.\nWEB APP',
    //           style: TextStyle(
    //             fontWeight: FontWeight.w800,
    //             fontSize: 80,
    //             height: 0.9,
    //           ),
    //         ),
    //         SizedBox(
    //           height: 30,
    //         ),
    //       ],
    //     ),
    //     SizedBox(
    //       height: 600,
    //       width: 600,
    //       child: Image.asset('assets/images/logo_cpark2.png'),
    //     )
    //   ],
    // ),
  }
}
