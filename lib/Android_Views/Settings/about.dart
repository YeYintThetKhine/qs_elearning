import 'package:flutter/material.dart';
import 'package:moodle_test/ThemeColors/colors.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';


class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

var course = "Course creation added to web version for admin. Giving access to mobile application for course lessons, quizzes and videos implemented";

var calender = "Calendar event addition added to web version. Giving event information from Calendar implemented";

var message = "Sending messages to students from web version added. Receiving messages from students on web version added";

var grade = "Grade calculation and weighting added to web version. Showing grades according to courses and grade details to mobile application implemented";

class _AboutState extends State<About> {

  countertimer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  @override
  void initState() {
    super.initState();
    countertimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        countertimer();
      },
    child:Scaffold(
      backgroundColor: mBlue,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('About Page',style: TextStyle(color: Colors.amber),),
        automaticallyImplyLeading: true,
      ),
      body:SingleChildScrollView(
        child:Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal:25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                        "E-Learning Version 1.0",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                        "Moodle Version 3.7",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                        "Features",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Text(
                        "Courses",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(course,textAlign: TextAlign.justify,
                 style: TextStyle(height: 1.5,color: Colors.white,fontSize: 14.0),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Text(
                        "Calendar",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(course,textAlign: TextAlign.justify,
                 style: TextStyle(height: 1.5,color: Colors.white,fontSize: 14.0),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Text(
                        "Messages",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(message,textAlign: TextAlign.justify,
                 style: TextStyle(height: 1.5,color: Colors.white,fontSize: 14.0),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Text(
                        "Grades",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(grade,textAlign: TextAlign.justify,
                 style: TextStyle(height: 1.5,color: Colors.white,fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      )
    )
    );
  }
}