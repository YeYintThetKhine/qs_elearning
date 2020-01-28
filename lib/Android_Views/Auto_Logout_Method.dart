import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moodle_test/DB/db.dart';
import 'package:moodle_test/Android_Views/LandingPage/landing_page.dart';

class AutoLogoutMethod {
  AutoLogoutMethod._();

  static final AutoLogoutMethod autologout = AutoLogoutMethod._();
    Timer timer;
  void counter(context) {
    print("counter activated!");
    timer.cancel();
    timer = new Timer (Duration(minutes: 20), () {
    PersonDatabaseProvider.db.deleteAllPersons();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
      _showAlertDialog('Timer', 'Logged out due to inactivity',context);
    });
  }

    void counterstartpage(context) {
    print("counter activated!");
    timer = new Timer (Duration(minutes: 20), () {
    PersonDatabaseProvider.db.deleteAllPersons();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
      _showAlertDialog('Timer', 'Logged out due to inactivity',context);
    });
  }

  void _showAlertDialog(String title, String message,context) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
}