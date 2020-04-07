import 'package:c_admin/provider/userProvider/user_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/reportProvider/report_provider.dart';
import '../../provider/reportProvider/report.dart';
import 'package:flutter/material.dart';
import '../../loader/color_loader3.dart';
import '../../Navigation/navigation.dart';
import '../../routing/route_names.dart';
import '../../locator.dart';

class ReportOverViewScreen extends StatefulWidget {
  static const routeName = '/report-view';

  @override
  _ReportOverViewScreenState createState() => _ReportOverViewScreenState();
}

class _ReportOverViewScreenState extends State<ReportOverViewScreen> {
  List<Report> reports;
  List<DataRow> reportDataRowList;
  bool sort = true;

  int columnIndex;
  List<DataRow> forSortingreport;
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    sort = false;
    // TODO: implement initState
    super.initState();
  }

  // calculate displayed lifetime bar for sorting
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

  onSortColumn(int col, bool ascending) {
    if (col == 3) {
      if (ascending) {
        reports.sort((a, b) =>
            DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
      } else {
        reports.sort((a, b) =>
            DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));
      }
    }

    if (col == 6) {
      if (ascending) {
        reports.sort((a, b) => a.availability.compareTo(b.availability));
      } else {
        reports.sort((a, b) => b.availability.compareTo(a.availability));
      }
    }
  }

  DataTable dataBody(List<Report> reports) {
    return DataTable(
      showCheckboxColumn: false,
      columnSpacing: 60,
      sortAscending: sort,
      sortColumnIndex: 6,
      columns: [
        DataColumn(
          label: Text('Rep.pic'),
        ),
        DataColumn(
          label: Text('Rep.id'),
        ),
        DataColumn(
          label: Text('Owned by'),
        ),
        DataColumn(
          label: Text('Date'),
        ),
        DataColumn(
          label: Text('Time'),
        ),
        DataColumn(
          label: Text('Location'),
        ),
        DataColumn(
          onSort: (columnIndex, ascending) {
            setState(() {
              sort = !sort;
            });
            onSortColumn(columnIndex, ascending);
          },
          numeric: true,
          label: Text('Availability'),
        )
      ],
      rows: reports
          .map(
            (report) => DataRow(
              onSelectChanged: (b) {
                // print(report.id);
                _navigationService.navigateToWithReportData(
                    ReportDetail, report);
                // print(report.id);
                //navigate to report detail screen
              },
              cells: [
                DataCell(
                  Image.network(
                    report.imageUrl,
                  ), // Text(report.id.toString()),
                ),
                DataCell(
                  Text(report.id.toString()), // Text(report.id.toString()),
                ),
                DataCell(Text(
                  report.userName,
                )),
                DataCell(
                  Text(
                      '${DateTime.parse(report.dateTime).day}/${DateTime.parse(report.dateTime).month}/${DateTime.parse(report.dateTime).year}'),
                ),
                DataCell(
                  Text(
                      '${DateTime.parse(report.dateTime).hour}:${DateTime.parse(report.dateTime).minute.toString().padLeft(2, '0')}'),
                ),
                DataCell(
                  Text(
                    report.loc,
                  ),
                ),
                DataCell(
                  Text(
                    report.availability.toString(),
                  ),
                )
              ],
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locId = ModalRoute.of(context).settings.arguments as String;
    print(locId);

    return Scaffold(
        backgroundColor: Colors.indigo[50],
        // drawer: AppDrawer(),
        body: FutureBuilder(
          future: locId != null
              ? Provider.of<ReportsProvider>(context, listen: false)
                  .getReportsFromUserLoc(locId)
              : Provider.of<ReportsProvider>(context, listen: false)
                  .getReportsAll(),
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: dataBody(snapshot.data),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const _primaryValue = 0x829Fd9;

  static const MaterialColor blue = const MaterialColor(
    _primaryValue,
    const <int, Color>{
      50: const Color(0xFFe0e0e0),
      100: const Color(0xFFb3b3b3),
      200: const Color(0xFF808080),
      300: const Color(0xFF4d4d4d),
      400: const Color(0xFF262626),
      500: const Color.fromRGBO(130, 159, 217, 100),
      600: const Color(0xFF000000),
      700: const Color(0xFF000000),
      800: const Color(0xFF000000),
      900: const Color(0xFF000000),
    },
  );
}
