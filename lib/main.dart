import 'package:flutter/material.dart';
import './Android_Views/LandingPage/splash_screen.dart';
import './Android_Views/LandingPage/landing_page.dart';
import './ThemeColors/colors.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CB Bank',
      theme: ThemeData(
          primaryColor: mBlue,
          scaffoldBackgroundColor: mWhite,
          primaryTextTheme: TextTheme(title: TextStyle(color: mWhite))),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/LandingPage': (BuildContext context) => LandingPage(),
      },
    );
  }
}
