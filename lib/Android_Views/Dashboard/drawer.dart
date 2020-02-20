import 'package:flutter/material.dart';
import 'package:moodle_test/Android_Views/Dashboard/dashboard.dart';
import '../../Model/model.dart';
import '../../ThemeColors/colors.dart';
import '../LandingPage/landing_page.dart';
import '../Event/event_calendar.dart';
import '../Category/category_list.dart';
import '../Settings/settings.dart';
import '../Help/help.dart';
import 'package:moodle_test/DB/db.dart';
import 'package:connectivity/connectivity.dart';
import '../../Model/user.dart';



  String eventtype="initial";

  showAlertDialog(String title, String message,context) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.pop(context);
          _connectionCheck(context);
        }, child: Text('Try again'))
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => alertDialog
    );
  }

  _connectionCheck(context) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      if(eventtype == "dashboard"){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DashBoard()));
      }
      else if(eventtype == "categories"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CategoryList(),
          ),
        );
      }
      else if(eventtype == "events"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                CalendarEventView(),
          ),
        );
      }
      else if(eventtype == "help"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                Help(),
          ),
        );
      }
      else if(eventtype == "setting"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                Setting(),
          ),
        );
      }
    } else if(connectivityResult == ConnectivityResult.mobile && connectivityResult == ConnectivityResult.wifi){
      if(eventtype == "dashboard"){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DashBoard()));
      }
      else if(eventtype == "categories"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CategoryList(),
          ),
        );
      }
      else if(eventtype == "events"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                CalendarEventView(),
          ),
        );
      }
      else if(eventtype == "help"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                Help(),
          ),
        );
      }
      else if(eventtype == "setting"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                Setting(),
          ),
        );
      }
    } 
    else{
      showAlertDialog('Mobile Connection Lost', 'Please connect to your wifi or turn on mobile data and try again',context);
    }
  }

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
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          image: new DecorationImage(
                            image: new NetworkImage(
                                    currentUser.imgUrl + '?token=$token'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        ),
                        // child: Image.asset(
                        //   'images/placeholder.png',
                        //   fit: BoxFit.cover,
                        //   height: 52.0,
                        // )
                        ),
                  ),
                  ListTile(
                    onTap: (){
                      eventtype="dashboard";
                      _connectionCheck(context);
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
                      eventtype="categories";
                      _connectionCheck(context);
                    },
                  ),
                  ListTile(
                    onTap: () {
                      eventtype="events";
                      _connectionCheck(context);
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
                  ListTile(
                    onTap: () {
                      eventtype="help";
                      _connectionCheck(context);
                    },
                    title: Text(
                      "Help",
                      style: TextStyle(
                        color: mWhite,
                      ),
                    ),
                    leading: Icon(
                      Icons.help,
                      color: mWhite,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      eventtype="setting";
                      _connectionCheck(context);
                    },
                    title: Text(
                      "Setting",
                      style: TextStyle(
                        color: mWhite,
                      ),
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: mWhite,
                    ),
                  ),
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
