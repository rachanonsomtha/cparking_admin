import 'package:provider/provider.dart';
import '../../provider/reportProvider/report_provider.dart';
import '../../provider/reportProvider/report.dart';
import '../reportView/reportItem/report_item.dart';
import 'package:flutter/material.dart';

class ReportOverViewScreen extends StatefulWidget {
  static const routeName = '/report-view';

  @override
  _ReportOverViewScreenState createState() => _ReportOverViewScreenState();
}

class _ReportOverViewScreenState extends State<ReportOverViewScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  List<Report> reports;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ReportsProvider>(context).fetchReport().then((_) {
        reports = Provider.of<ReportsProvider>(context).reports;
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
    Provider.of<ReportsProvider>(context).fetchReport().then((_) {
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
                  child: Text('Color loading3'),
                )
              : Container(
                  height: 600,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (_, index) => ChangeNotifierProvider.value(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ReportItem(
                                // report.reports[index].userName,
                                // report.reports[index].lifeTime,
                                // report.reports[index].dateTime.toString(),
                                // report.reports[index].imageUrl,
                                // report.reports[index].availability,
                                // report.reports[index].isPromoted,
                                // report.reports[index].score,
                                ),
                            Divider(),
                          ],
                        ),
                        value: reports[index],
                      ),
                    ),
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
