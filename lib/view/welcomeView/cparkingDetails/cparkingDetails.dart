import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';
import '../../../widgets/fl_chart/bar_chart_1.dart';

class CparkingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: BarChartSample1(),
              ),
            ),
          );
        }),
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
