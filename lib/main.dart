import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_netflix_ui_redesign/screens/home_screen.dart';
import 'package:flutter_netflix_ui_redesign/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      //theme: ThemeData(brightness: Brightness.dark),
      title: 'Flutter Netflix UI Redesign',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
