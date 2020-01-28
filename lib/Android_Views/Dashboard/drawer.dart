import 'package:flutter/material.dart';
import 'package:moodle_test/Android_Views/Dashboard/dashboard.dart';
import '../../Model/model.dart';
import '../../ThemeColors/colors.dart';
import '../LandingPage/landing_page.dart';
import '../Event/event_calendar.dart';
import '../Category/category_list.dart';
import 'package:moodle_test/DB/db.dart';

Widget drawer(User user, BuildContext context) {
  _logout() {
    PersonDatabaseProvider.db.deleteAllPersons();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
    );
  }

  return Theme(
    data: ThemeData(canvasColor: Colors.transparent),
    child: Drawer(
      child: Container(
        margin: EdgeInsets.only(top: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          color: mBlue,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: mBlue,
                    ),
                    accountName: Text(
                      user.name.toUpperCase(),
                      style:
                          TextStyle(color: mWhite, fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(
                      user.email,
                      style: TextStyle(color: mWhite),
                    ),
                    currentAccountPicture: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? Colors.blue
                                : Colors.white,
                        child: Image.asset(
                          'images/placeholder.png',
                          fit: BoxFit.cover,
                          height: 52.0,
                        )),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => DashBoard()));
                    },
                    title: Text(
                      "Dashboard",
                      style: TextStyle(
                        color: mWhite,
                      ),
                    ),
                    leading: Icon(
                      Icons.dashboard,
                      color: mWhite,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Categories",
                      style: TextStyle(
                        color: mWhite,
                      ),
                    ),
                    leading: Icon(
                      Icons.category,
                      color: mWhite,
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => CategoryList(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CalendarEventView(),
                        ),
                      );
                    },
                    title: Text(
                      "Events",
                      style: TextStyle(
                        color: mWhite,
                      ),
                    ),
                    leading: Icon(
                      Icons.event_available,
                      color: mWhite,
                    ),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     "Settings",
                  //     style: TextStyle(
                  //       color: mWhite,
                  //     ),
                  //   ),
                  //   leading: Icon(
                  //     Icons.settings,
                  //     color: mWhite,
                  //   ),
                  // ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xFFF5F5F5),
                ),
                child: new ListTile(
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: mBlue,
                    ),
                  ),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: mBlue,
                  ),
                  onTap: () {
                    _logout();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
