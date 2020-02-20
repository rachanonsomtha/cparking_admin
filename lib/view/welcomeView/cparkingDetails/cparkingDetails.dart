import 'package:flutter/material.dart';

class CparkingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'C-PARKING.\nWEB APP',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 80,
                  height: 0.9,
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
          SizedBox(
            height: 600,
            width: 600,
            child: Image.asset('assets/images/logo_cpark2.png'),
          )
        ],
      ),
    );
  }
}
