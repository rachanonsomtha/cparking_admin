import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './parkingLot.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'dart:convert';
import 'package:http/http.dart' as http;

class ParkingLotProvider with ChangeNotifier {
  List<ParkLot> _parkingLots = [
    ParkLot(
      id: '301',
      title: 'ลานจอดบุคคลทั่วไป#1',
      max: 3,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/30%231.jpg?alt=media&token=28ca734c-55b6-480a-a7ea-28a81743fdb4',
      color: Colors.grey,
    ),
    ParkLot(
      id: '302',
      title: 'ลานจอดบุคคลทั่วไป#2',
      max: 10,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/30%232.jpg?alt=media&token=156a6a36-5736-4a6a-b7de-c780dfe1ff92',
      color: Colors.grey,
    ),
    ParkLot(
      id: 'SUR1',
      title: 'ลานจอดอาจารย์โยธา#1',
      max: 10,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/SUR%231.jpg?alt=media&token=2b300451-4815-4787-8a43-1f843c05be12',
      color: Colors.grey,
    ),
    ParkLot(
      id: 'SUR2',
      title: 'ลานจอดบุคคลากรคอมพิวเตอร์#1',
      max: 12,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/SUR%232.jpg?alt=media&token=bfa057bd-045d-4204-b31c-b79c9e6a4aa5',
      color: Colors.grey,
    ),
    ParkLot(
      id: 'FEILD1',
      title: 'ลานจอดสนามฮ้อกกี้#1',
      max: 19,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/FEILD%231.jpg?alt=media&token=a6b92650-99a9-4db9-8c7c-3a361475a8a9',
      color: Colors.grey,
    ),
    ParkLot(
      id: 'VIT1',
      title: 'ลานจอดตึกประลอง#1',
      max: 20,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/VIT%231.jpg?alt=media&token=8d761dac-c294-4b2e-84d3-a99bf10b5261',
      color: Colors.grey,
    ),
    ParkLot(
      id: 'VIT2',
      title: 'ลานจอดตึกประลอง#2',
      max: 15,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/VIT%232.jpg?alt=media&token=9dd573a1-5197-44cc-94d2-a320cc7de883',
      color: Colors.grey,
    ),
  ];

  int setMinute(int time) {
    //Real envi

    int min;
    if (time >= 0) {
      min = 0;
      if (time >= 10) {
        min = 10;
        if (time >= 20) {
          min = 20;
          if (time >= 30) {
            min = 30;
            if (time >= 40) {
              min = 40;
              if (time >= 50) {
                min = 50;
              }
            }
          }
        }
      }
    }

    return min;
  }

  Future<void> getColor() async {
    String url;
    final time = DateTime.now();

    int day = time.weekday;
    int hour = time.hour;
    int minute = setMinute(time.minute);
    if (day >= 6) day = 5;
    if (hour >= 18 || hour <= 6) hour = 17;
    _parkingLots.forEach((lot) async {
      url =
          'https://cparking-ecee0.firebaseio.com/avai/${lot.id}/${day.toString()}/${hour.toString()}/${minute.toString()}.json';
      print(url);
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      double _parkingMax = lot.max;

      lot.color = setColor(int.parse(decodeData['mean']), _parkingMax);
    });
  }

  Color setColor(int avai, double max) {
    double factor;
    Color colorFactor;
    factor = avai / max;
    if (factor >= 0) {
      colorFactor = Colors.red;
      if (factor >= 0.3) {
        colorFactor = Colors.yellow;
        if (factor >= 0.5) {
          colorFactor = Colors.green;
        }
      }
    }

    return colorFactor;
  }

  Future<String> getLocImage(String title) async {
    var imageFile;
    StorageReference ref =
        FirebaseStorage.instance.ref().child('parkingLot/$title.jpg');
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    return url;
  }

  ParkLot findById(String id) {
    return _parkingLots.firstWhere((lot) => lot.id == id);
  }

  List<ParkLot> get parkingLots {
    return [..._parkingLots];
  }

  int get parkingLotsCount {
    return _parkingLots.length;
  }
}
