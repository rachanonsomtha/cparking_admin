import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './report.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:firebase_storage/firebase_storage.dart';

class ReportsProvider with ChangeNotifier {
  List<Report> _reports = [];

  List<Report> _userReports = [];

  List<Report> _reportsLoc = [];

  int _lifeTime;

  String authToken;
  String userId;
  Map<String, String> headers = new HashMap();

  // var _showFavourtiesOnly = false;

  ReportsProvider(
    this.authToken,
    this.userId,
    // this._reports,
  );
  //////
  List<Report> get reports {
    return [..._reports];
  }

  int get reportCount {
    return _reports.length;
  }

//////
  List<Report> get userReports {
    return [..._userReports];
  }

  int get userReportCount {
    return _userReports.length;
  }

/////
  List<Report> get locReports {
    return [..._reportsLoc];
  }

  int get locReportsCount {
    return _reportsLoc.length;
  }

  int get lifeTime {
    return _lifeTime;
  }

  bool isOwnedby(Report report) {
    return report.userName == userId ? true : false;
  }

  void removeReport(String id) {
    // final prodIndex = _items.indexWhere((prod) => prod.id == id);
    _reports.removeWhere((rep) => rep.id == id);
    _userReports.removeWhere((rep) => rep.id == id);
    _reportsLoc.removeWhere((rep) => rep.id == id);
    notifyListeners();
  }

  Report findById(String id) {
    return _reports.firstWhere((rep) => rep.id == id);
  }

  Future<void> deleteReport(Report report) async {
    String keyName;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('reports/${report.loc}/${report.imgName}');
    storageReference.delete().then((_) {
      print('delete succesfully');
    }).catchError((_) {
      print(_);
    });
    final url1 =
        'https://cparking-ecee0.firebaseio.com/reports/${report.id}.json';
    try {
      await http.delete(url1, headers: headers).then((_) {
        print('deletion report from user success');
        removeReport(report.id);
        notifyListeners();
      }).then((_) async {
        final url2 =
            'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId.json';

        final response = await http.get(url2);
        final decodeData = json.decode(response.body) as Map<String, dynamic>;
        decodeData.forEach((reportId, reportData) {
          if (reportData == report.id) {
            keyName = reportId;
          }
        });
      }).then((_) async {
        final url3 =
            'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId/$keyName.json';

        await http.delete(url3, headers: headers).then((_) {
          print("delete from reportFolder complete");
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchReport() async {
    final url = 'https://cparking-ecee0.firebaseio.com/reports.json';

    // final favUrl =
    //     'https://cparking-ecee0.firebaseio.com/userPromoted/$userId.json';
    //fetch and decode data

    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) {
        return;
      }
      // final favResponse = await http.get(favUrl);
      // final favData = json.decode(favResponse.body);
      // print(favData);

      final List<Report> loadedProducts = [];
      decodeData.forEach((reportId, reportData) {
        loadedProducts.add(
          Report(
            id: reportId,
            userName: reportData['userName'],
            imageUrl: reportData['imageUrl'],
            lifeTime: reportData['lifeTime'],
            isPromoted: false,
            score: reportData['score'],
            dateTime: reportData['dateTime'].toString(),
            availability: reportData['availability'],
            loc: reportData['loc'],
            imgName: reportData['imgName'],
          ),
        );
        // print(loadedProducts[0].imageUrl);
      });
      _reports = loadedProducts;
      notifyListeners();
      // print(_reports);
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
