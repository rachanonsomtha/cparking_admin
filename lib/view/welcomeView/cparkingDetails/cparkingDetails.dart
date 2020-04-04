import 'package:c_admin/provider/parkingLot/parking_provider.dart';
import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:provider/provider.dart';
import '../../../widgets/fl_chart/bar_chart_1.dart';

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
                        color: const Color.fromRGBO(171, 176, 207, 1),
                      ),
                    ),
                    Text(
                      "${weekDay(_value).toString()}", // change to weekday that selected
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(96, 105, 165, 1),
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
                  activeTrackColor: const Color.fromRGBO(109, 120, 136, 1),
                  inactiveTrackColor: const Color.fromRGBO(109, 120, 136, 1),
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
                  onChangeEnd: (_) {
                    setState(() {
                      showWeekday = true;
                    });
                  },
                  onChanged: (value) {
                    setState(() async {
                      showWeekday = false;
                      _value = value;
                      _meanList = await Provider.of<ParkingLotProvider>(context)
                          .getLotMeanByWeekday(_value.toInt());
                    });
                  },
                  divisions: 4,
                  // label: weekDay(_value).toString(),
                ),
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
                print(index);
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

  Widget sample1(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width * 0.20,
        child: BezierChart(
          bezierChartScale: BezierChartScale.CUSTOM,
          xAxisCustomValues: const [0, 5, 10, 15, 20, 25, 30, 35],
          series: const [
            BezierLine(
              data: const [
                DataPoint<double>(value: 10, xAxis: 0),
                DataPoint<double>(value: 130, xAxis: 5),
                DataPoint<double>(value: 50, xAxis: 10),
                DataPoint<double>(value: 150, xAxis: 15),
                DataPoint<double>(value: 75, xAxis: 20),
                DataPoint<double>(value: 0, xAxis: 25),
                DataPoint<double>(value: 5, xAxis: 30),
                DataPoint<double>(value: 45, xAxis: 35),
              ],
            ),
          ],
          config: BezierChartConfig(
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            backgroundColor: Colors.black,
            snap: false,
          ),
        ),
      ),
    );
  }
}
