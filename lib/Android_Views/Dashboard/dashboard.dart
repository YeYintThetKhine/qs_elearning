import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:moodle_test/Android_Views/Dashboard/dashboard_loading.dart';
import '../../ThemeColors/colors.dart';
import '../../Model/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Dashboard/course_overview.dart';
import '../Dashboard/drawer.dart';
// import '../Dashboard/recent_course.dart';
import '../Dashboard/today_events.dart';
import '../Dashboard/grade_history.dart';
import '../URL/url.dart';
import '../../Model/user.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';
import 'package:connectivity/connectivity.dart';


class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Course> _courseList = [];
  List<Event> _eventList = [];
  List<GradeByCategory> _categoryQuizList = [];
  bool _loading = true;
  bool _loading_gradehistory = true;
  bool _noCourse = false;
  bool _noGrade = false;
  bool getRecent = false;
  bool noRecent = false;
  bool _getEvents = false;
  bool _event = true;
  Course recentcourse;

  String eventtype="initial";

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var getCategoryQuiz;

  countertimer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  getQuizMaryByCategory() async {
    String uid = currentUser.id;
    var response;
    var url = '$urlLink/$token/usergrades/$uid';
    try {
      response = await http.get(url).timeout(
        Duration(seconds: 20),
      );
    } catch (e) {

    }
    if (response == null || response.statusCode != 200) {
      print('Error');
    }
    else{
      await http.get(url).then((result) {
        var categoryGrades = json.decode(result.body);
        print(categoryGrades['grades'].length);
          if (categoryGrades['grades'].length == 0) {
            setState(() {
              _noGrade = true;
              _loading_gradehistory = false;
            });
            print(_noGrade);
          } else {
              for (var categoryGrade in categoryGrades['grades']) {
                _categoryQuizList.add(GradeByCategory(
                  categoryname: categoryGrade['categoryname'],
                  coursename: categoryGrade['coursename'],
                  courseid: categoryGrade['courseid'],
                  mark: categoryGrade['mark'],
                  gradeCategoryImg: categoryGrade['imageurl'],
                ));
              }
              setState(() {
                _loading_gradehistory = false;
              });
          }
      }).then((value) {
      print('completed with value $value');
      }, onError: (error) {
        print('completed with error $error');
      });
    }
  }

  showAlertDialog(String title, String message,context) {

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text('Mobile Connection Lost'),
      content: Text(message),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.pop(context);
          _connectionCheck();
        }, child: Text('Try again'))
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => alertDialog
    );
  }

  _connectionCheck() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      if(eventtype == "initial"){

      }
      else if(eventtype == "drawer"){
        _scaffoldKey.currentState.openDrawer();
      }
    } 
    else if(connectivityResult == ConnectivityResult.mobile && connectivityResult == ConnectivityResult.wifi){
      if(eventtype == "initial"){

      }
      else if(eventtype == "drawer"){
        _scaffoldKey.currentState.openDrawer();
      }
    }
    else{
      showAlertDialog('Mobile Connection Lost', 'Please connect to your wifi or turn on mobile data and try again',context);
    }
  }

  

  @override
  void initState() {
    super.initState();
    _connectionCheck();
    _courseOverview();
    _getRecentCourse();
    _getTodayEvents();
    countertimer();
    getQuizMaryByCategory();
  }

  _courseOverview() async {
    String uid = currentUser.id;
    _courseList.clear();
    var url = '$urlLink/$token/user/$uid/enrolledCourses/';
    await http.get(url).then((result) {
      var courses = json.decode(result.body);
      if (courses == null) {
        setState(() {
          _noCourse = true;
          _loading = false;
        });
      } else {
        for (var course in courses) {
          _courseList.add(Course(
            id: course['id'],
            courseName: course['fullname'],
            courseDesc: course['summary'],
            courseCategory: course['category'],
            courseImgURL: course['overviewfiles'][0]['fileurl'],
            favourite: course['isfavourite'],
            progress: course['progress'] == null
                ? 0.0
                : course['progress'].toDouble(),
          ));
        }
        setState(() {
          _noCourse = false;
          _loading = false;
        });
      }
    });
  }

  _getRecentCourse() async {
    String uid = currentUser.id;
    var url = '$urlLink/$token/user/$uid/lastAccessed/';
    await http.get(url).then((result) {
      var recent = json.decode(result.body);
      if (recent['status'] == 'No Course') {
        setState(() {
          getRecent = true;
          noRecent = true;
        });
      } else {
        recentcourse = Course(
          id: recent['id'],
          courseName: recent['fullname'],
          courseDesc: recent['summary'],
          courseCategory: recent['category'],
          courseImgURL: recent['overviewfiles'][0]['fileurl'] + '?token=$token',
          favourite: recent['isfavourite'],
          progress: recent['progress'].toDouble(),
        );
        setState(() {
          getRecent = true;
          noRecent = false;
        });
      }
    });
  }

  _getTodayEvents() async {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    var day = DateTime.now().day;
    var url = '$urlLink/$token/events/date/$year/$month/$day/';
    print(url);
    await http.get(url).then((result) {
      var events = json.decode(result.body);
      if (events['events'].length > 0) {
        for (var event in events['events']) {
          var time =
              (DateTime.fromMillisecondsSinceEpoch(event['timestart'] * 1000)
                  .toString());
          _eventList.add(Event(
            id: event['id'].toString(),
            eventName: event['name'],
            courseName: event['course']['fullname'],
            desc: event['description'],
            time: time.substring(time.indexOf(' '), time.lastIndexOf(':')),
            day: events['date']['mday'].toString(),
            month: events['date']['month'],
            year: events['date']['year'].toString(),
            location: event['location'],
          ));
          setState(() {
            _getEvents = true;
            _event = true;
          });
        }
      } else {
        setState(() {
          _getEvents = true;
          _event = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: countertimer,
    child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: mBlue,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Dashboard'),
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              eventtype="drawer";
            });
            _connectionCheck();
            countertimer();
          },
          icon: Image.asset(
            'images/menu.png',
            width: 24.0,
            color: mWhite,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      drawer: drawer(currentUser, context),
      body: SingleChildScrollView(
        child: OrientationBuilder(
          builder: (context, orient) {
            // var dev = MediaQuery.of(context).size;
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top:16.0,bottom:16.0,left:16.0,right:5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enrolled Course Overview',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    _courseList.length == 0
                    ?Container()
                    :Container(
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius:
                            BorderRadius.circular(5.0),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.amber,
                        ),
                      ),
                      child: Text(
                        '${_courseList.length}',
                        style: TextStyle(
                            color: mBlue, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 175.0,
                  child: _loading == false && _noCourse == false
                      ? courseOverViewWidget(_courseList, token)
                      : _loading == false && _noCourse == true
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xFFF5F5F5),
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: Center(
                                child: Text(
                                  'No Courses',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.35),
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return OverviewLoading();
                              },
                            ),
                ),
                GestureDetector(
                  onTap: countertimer(),
                  child: Column(
                    children:[
                      Row(
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Grade History',
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                          _categoryQuizList.length == 0
                          ?Container()
                          :Container(
                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius:
                                  BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.5,
                                color: Colors.amber,
                              ),
                            ),
                            child: Text(
                              '${_categoryQuizList.length}',
                              style: TextStyle(
                                  color: mBlue, fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      _loading_gradehistory == false &&  _noGrade == false
                      ?Container(
                        child: gradeHistoryWidget(_categoryQuizList,token,context),
                      ): _loading_gradehistory == false &&  _noGrade == true
                      ?Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: mBlue,
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              child: Center(
                                child: Text(
                                  'No Grade History',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                      )
                      :Container(
                        padding: EdgeInsets.only(
                            top: 10.0, left: 32.0, bottom: 10.0, right: 10.0),
                        child: EventLoading(),
                      ),
                    ],
                  ),
                ),
                // getRecent == true
                //     ? Container(
                //         margin: EdgeInsets.symmetric(
                //             vertical: 16.0, horizontal: 16.0),
                //         width: dev.width,
                //         height: 250.0,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(15.0),
                //           color: Color(0xFFFFB75B),
                //           boxShadow: [
                //             BoxShadow(
                //                 offset: Offset(0.0, 0.0),
                //                 blurRadius: 5.0,
                //                 color: Color.fromRGBO(0, 0, 0, 0.2),
                //                 spreadRadius: 2.5)
                //           ],
                //         ),
                //         child: recentCourse(
                //             context, recentcourse, noRecent, token),
                //       )
                //     : RecentLoading(),
                Container(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 32.0, bottom: 10.0, right: 10.0),
                  height: 175.0,
                  child: _getEvents == true
                      ? todayEvents(_eventList, _event, context)
                      : EventLoading(),
                ),
              ],
            );
          },
        ),
      ),
    )
    );
  }
}
