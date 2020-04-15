import 'package:flutter/material.dart';

class BoardingPassData {
  String passengerName;
  Airport origin;
  Airport destination;
  Duration duration;
  String boardingTime;
  DateTime departs;
  DateTime arrives;
  String gate;
  int zone;
  String seat;
  String flightClass;
  String flightNumber;

  BoardingPassData({
    this.passengerName,
    this.origin,
    this.destination,
    this.duration,
    this.boardingTime,
    this.departs,
    this.arrives,
    this.gate,
    this.zone,
    this.seat,
    this.flightClass,
    this.flightNumber,
  });
}

class Airport {
  String code;
  String city;

  Airport({this.city, this.code});
}

class Duration {
  int hours;
  int minutes;

  Duration({this.hours, this.minutes});

  @override
  String toString() {
    return '\t${hours}H ${minutes}M';
  }
}

class DemoData {
  List<BoardingPassData> _boardingPasses = [
    BoardingPassData(
        passengerName: 'Ms. Jane Doe', // "Owned by"
        origin: Airport(
            code: 'YEG',
            city:
                'Edmonton'), // code : snapshot.data.userName, city: parkingInfo: snapshot.data.email
        destination: Airport(
            code: 'LAX',
            city:
                'Los Angeles'), // code: parkingInfo.id , city: parkingInfo.title
        duration: Duration(
            hours: 3, minutes: 30), //Duration(minute: report.lifetime.toInt)
        boardingTime: "Parkinglot Info",
        departs:
            DateTime(2019, 10, 17, 23, 45), // DateTime.parse(report.dateTime)
        arrives: DateTime(2019, 10, 18, 02,
            15), //(DateTime.parse(report.dateTime).add(Duration(minute: report.lifetime))
        gate: '50', // report.lifetime.toString
        zone: 3, //report.availability
        seat: '12A', //report.score
        flightClass: 'Economy', //report.imageName
        flightNumber: 'AC237'), //report.id
    BoardingPassData(
        passengerName: 'Ms. Jane Doe',
        origin: Airport(code: 'YYC', city: 'Calgary'),
        destination: Airport(code: 'YOW', city: 'Ottawa'),
        duration: Duration(hours: 3, minutes: 50),
        boardingTime: "Parkinglot Info",
        departs: DateTime(2019, 10, 17, 23, 45),
        arrives: DateTime(2019, 10, 18, 02, 15),
        gate: '22',
        zone: 1,
        seat: '17C',
        flightClass: 'Economy',
        flightNumber: 'AC237'),
    BoardingPassData(
        passengerName: 'Ms. Jane Doe',
        origin: Airport(code: 'YEG', city: 'Edmonton'),
        destination: Airport(code: 'MEX', city: 'Mexico'),
        duration: Duration(hours: 4, minutes: 15),
        boardingTime: "Parkinglot Info",
        departs: DateTime(2019, 10, 17, 23, 45),
        arrives: DateTime(2019, 10, 18, 02, 15),
        gate: '30',
        zone: 2,
        seat: '22B',
        flightClass: 'Economy',
        flightNumber: 'AC237'),
    BoardingPassData(
        passengerName: 'Ms. Jane Doe',
        origin: Airport(code: 'YYC', city: 'Calgary'),
        destination: Airport(code: 'YOW', city: 'Ottawa'),
        duration: Duration(hours: 3, minutes: 50),
        boardingTime: "Parkinglot Info",
        departs: DateTime(2019, 10, 17, 23, 45),
        arrives: DateTime(2019, 10, 18, 02, 15),
        gate: '22',
        zone: 1,
        seat: '17C',
        flightClass: 'Economy',
        flightNumber: 'AC237'),
  ];

  get boardingPasses => _boardingPasses;

  getBoardingPass(int index) {
    return _boardingPasses.elementAt(index);
  }
}
