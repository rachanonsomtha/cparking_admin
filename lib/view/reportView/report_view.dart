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
  bool _isInit = true;
  bool _isLoading = false;
  List<Report> reports;
  List<DataRow> reportDataRowList;
  bool sort = true;
  bool _dialVisible = true;

  bool _today;
  bool _week;
  bool _all = true;

  int columnIndex;
  List<DataRow> forSortingreport;
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    sort = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ReportsProvider>(context).fetchReport().whenComplete(() {
        reports = Provider.of<ReportsProvider>(context).reports;
        // print(reportDataRowList);
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    setState(() {
      _isInit = false;
    });

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> _fetchReport(BuildContext context, String name) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ReportsProvider>(context).fetchReport().then((_) {
      reports = Provider.of<ReportsProvider>(context).reports;
    }).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
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
    if (col == 1) {
      if (ascending) {
        reports.sort((a, b) =>
            DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
      } else {
        reports.sort((a, b) =>
            DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));
      }
    }
  }

  DataTable dataBody() {
    return DataTable(
      sortColumnIndex: 1,
      sortAscending: sort,
      // showCheckboxColumn: true,
      columns: [
        DataColumn(
          label: Text('Rep.id'),
        ),
        DataColumn(
          label: Text('Date'),
          onSort: (columnIndex, ascending) {
            setState(() {
              sort = !sort;
            });
            onSortColumn(columnIndex, ascending);
          },
        ),
        DataColumn(
          label: Text('Time'),
        ),
        DataColumn(
          label: Text('Location'),
        ),
        DataColumn(
          numeric: true,
          label: Text('Availability'),
        )
      ],
      rows: reports
          .map(
            (report) => DataRow(
              onSelectChanged: (b) {
                // print(report.id);
                _navigationService.navigateToWithData(ReportDetail, report.id);
                //navigate to report detail screen
              },
              cells: [
                DataCell(
                  Text(report.id.toString()),
                ),
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
    final report = Provider.of<ReportsProvider>(context);
    var count = report.reportCount;

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      // drawer: AppDrawer(),
      body: count == 0 && !_isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'There\'s no report now',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).accentColor,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            )
          : _isLoading
              ? Center(
                  child: Text(
                  'loading..',
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // Container(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: <Widget>[
                      //       OutlineButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12)),
                      //         color: Colors.black87,
                      //         hoverColor: Colors.orange[100],
                      //         onPressed: () {},
                      //         child: Text(
                      //           'Today',
                      //           style: TextStyle(
                      //             fontFamily: 'Open Sans',
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //       ),
                      //       OutlineButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12)),
                      //         color: Colors.black87,
                      //         hoverColor: Colors.orange[100],
                      //         onPressed: () {},
                      //         child: Text(
                      //           'This Week',
                      //           style: TextStyle(
                      //             fontFamily: 'Open Sans',
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //       ),
                      //       OutlineButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12)),
                      //         color: Colors.black87,
                      //         hoverColor: Colors.orange[100],
                      //         onPressed: () {},
                      //         child: Text(
                      //           'All Time',
                      //           style: TextStyle(
                      //             fontFamily: 'Open Sans',
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: dataBody(),
                      ),
                    ],
                  ),
                ),
    );
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
