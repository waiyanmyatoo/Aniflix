import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 6);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff001030),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //color: Colors.red,
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'ANIFLIX',
                style: TextStyle(
                  fontFamily: 'Bebas Neue',
                  fontSize: 45.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 1.2),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Color(0xff001030),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
