import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_test/ThemeColors/colors.dart';
import 'package:moodle_test/Model/model.dart';
import 'package:moodle_test/Model/user.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../Dashboard/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_test/Android_Views/URL/url.dart';
import '../Course/course_modules.dart';
import 'package:html/parser.dart' as html;
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';

class CourseEnroll extends StatefulWidget {
  final course;
  CourseEnroll({this.course});
  @override
  _CourseEnrollState createState() => _CourseEnrollState(course: course);
}

class _CourseEnrollState extends State<CourseEnroll> {
  Course course;
  _CourseEnrollState({this.course});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> cids = [];
  bool enrolled = false;
  bool loading = true;
  double progress = 0.0;

  counter_timer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  @override
  void initState() {
    super.initState();
    _checkEnrolled(course.id);
    counter_timer();
  }

  _checkEnrolled(int cid) async {
    String uid = currentUser.id;
    var url = '$urlLink/$token/user/$uid/enrolledCourses/';
    await http.get(url).then((result) {
      var courses = json.decode(result.body);
      if (courses == null) {
        setState(() {
          enrolled = false;
          loading = false;
        });
      } else {
        if (courses.length > 0) {
          for (var cos in courses) {
            cids.add(cos['id'].toString());
            if (cid == cos['id']) {
              course = Course(
                id: cos['id'],
                courseName: cos['fullname'],
                courseDesc: cos['summary'],
                courseCategory: cos['category'],
                courseImgURL: cos['overviewfiles'][0]['fileurl'],
                favourite: cos['isfavourite'],
                progress:
                    cos['progress'] == null ? 0.0 : cos['progress'].toDouble(),
              );
              setState(() {
                progress =
                    cos['progress'] == null ? 0.0 : cos['progress'].toDouble();
              });
            }
          }
        } else {
          course = course;
        }
        if (cids.contains(cid.toString())) {
          setState(() {
            enrolled = true;
            loading = false;
          });
        } else {
          setState(() {
            enrolled = false;
            loading = false;
          });
        }
      }
    });
  }

  Future<Course> _getModuleProgress() async {
    Course currentCourse;
    var progressUrl =
        '$urlLink/$token/${currentUser.id}/course/${course.id}/progress/';
    await http.get(progressUrl).then((response) {
      var result = json.decode(response.body);
      currentCourse = Course(
        id: result['id'],
        courseName: result['fullname'],
        courseDesc: result['summary'],
        courseCategory: result['category'],
        courseImgURL: result['overviewfiles'][0]['fileurl'],
        favourite: result['isfavourite'],
        progress:
            result['progress'] == null ? 0.0 : result['progress'].toDouble(),
      );
    });
    return currentCourse;
  }

  Future<List<Topic>> _getCourseModule() async {
    List<Topic> _topicList = [];
    var modUrl = '$urlLink/$token/course/${course.id}/modules/';
    await http.get(modUrl).then((response) {
      var mods = json.decode(response.body);
      for (var topic in mods) {
        if (topic['name'] == 'General') {
          continue;
        } else {
          if (topic['modules'].length > 0) {
            List<Module> _moduleList = [];
            for (var module in topic['modules']) {
              _moduleList.add(
                Module(
                  id: module['id'].toString(),
                  instance: module['instance'].toString(),
                  moduleType: module['modname'],
                  name: module['name'],
                  url: module['contents'] != null
                      ? module['contents'][0]['fileurl']
                      : null,
                  completeStatus: module['completiondata'] == null
                      ? 0
                      : module['completiondata']['state'],
                  completeTime: module['completiondata'] == null
                      ? 0
                      : module['completiondata']['timecompleted'],
                  available: module['availabilityinfo'],
                ),
              );
            }
            _topicList.add(
              Topic(
                id: topic['id'].toString(),
                name: topic['name'],
                desc: topic['summary'],
                available: topic['availabilityinfo'],
                modules: _moduleList,
              ),
            );
          } else {
            _topicList.add(
              Topic(
                id: topic['id'].toString(),
                name: topic['name'],
                desc: topic['summary'],
                available: topic['availabilityinfo'],
                modules: null,
              ),
            );
          }
        }
      }
    });
    return _topicList;
  }

  courseEnroll() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Confirm'),
            content: Text('Are you sure to enroll ${course.courseName}?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  cids.clear();
                  setState(() {
                    loading = true;
                  });
                  var enrolUrl = '$urlLink/$token/enrol/${course.id}/';
                  print(enrolUrl);
                  await http.get(enrolUrl).then((response) async {
                    var msg = json.decode(response.body);
                    if (msg['status']) {
                      await _checkEnrolled(course.id);
                      await _getCourseModule();
                      setState(() {
                        enrolled = true;
                        loading = false;
                      });
                    } else {
                      await _checkEnrolled(course.id);
                      await _getCourseModule();
                      setState(() {
                        enrolled = false;
                        loading = false;
                      });
                    }
                  }).then((value) {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Course enrollment successful.',
                          style: TextStyle(color: mBlue),
                        ),
                        backgroundColor: Colors.white,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    print('$value');
                  }, onError: (error) async{
                    print('$error');
                    AutoLogoutMethod.autologout.counter(context);
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: mBlue),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: TextStyle(color: mBlue),
                ),
              ),
            ],
          );
        });
  }

  _showRestricted(String condition) {
    showDialog(
        context: (context),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Restricted'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Text(html.parse(condition).body.text),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: counter_timer,
    child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              counter_timer();
              Navigator.of(context).pop();
            },
          )
        ],
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
            counter_timer();
          },
          icon: Image.asset(
            'images/menu.png',
            width: 24.0,
            color: mWhite,
          ),
        ),
      ),
      drawer: drawer(currentUser, context),
      body: Container(
        color: mBlue,
        child: loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 32.0, top: 8.0),
                                      child: Text(
                                        "COURSE",
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 200.0,
                                          padding: EdgeInsets.only(
                                              left: 32.0, top: 8.0),
                                          child: Text(
                                            course.courseName,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 6.0, top: 8.0),
                                            child: course.progress == 100.0
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 14.0,
                                                  )
                                                : null),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 6.0, top: 8.0),
                                          child: course.progress == 100.0
                                              ? Text(
                                                  'Completed'.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                enrolled == false
                                    ? Container(
                                        width: 75.0,
                                        height: 35.0,
                                        margin: EdgeInsets.only(
                                            right: 32.0, top: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            width: 1.0,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        child: FlatButton(
                                          padding: EdgeInsets.all(0.0),
                                          onPressed: () {
                                            courseEnroll();
                                            counter_timer();
                                          },
                                          child: Text(
                                            'Enroll',
                                            style:
                                                TextStyle(color: Colors.amber),
                                          ),
                                        ),
                                      )
                                    : course.progress != 100.0?FutureBuilder(
                                        future: _getModuleProgress(),
                                        builder: (context, snapshot) {
                                          bool waiting = false;
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            waiting = true;
                                          } else {
                                            if (snapshot.data.progress ==
                                                null) {
                                              progress = 0.0;
                                            } else {
                                              progress = snapshot.data.progress;
                                            }
                                          }
                                          return Container(
                                            padding: EdgeInsets.only(
                                                right: 32.0, top: 8.0),
                                            child: CircularPercentIndicator(
                                              radius: 60.0,
                                              lineWidth: 5.0,
                                              animation: true,
                                              percent: waiting
                                                  ? 0.0
                                                  : progress.toDouble() / 100,
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              progressColor: Colors.amber,
                                              backgroundColor: Color.fromRGBO(
                                                  255, 255, 255, 0.15),
                                              center: Text(
                                                waiting
                                                    ? '0.0%'
                                                    : progress.toStringAsFixed(
                                                            1) +
                                                        '%',
                                                style: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                    fontSize: 16.0),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                      :Container(),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 32.0, top: 32.0),
                              child: Text(
                                'Description'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.25,
                                    color: Colors.amber),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 32.0, right: 32.0),
                              child: Html(
                                data: course.courseDesc,
                                defaultTextStyle: TextStyle(
                                  fontSize: 14.0,
                                  height: 1.25,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 32.0, right: 32.0, top: 8.0),
                              child: Text(
                                'Topics'.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  height: 1.25,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: _getCourseModule(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(
                                      Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32.0),
                                child: Center(
                                  child: Text('No Modules'),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      List<Topic> _topicList = snapshot.data;
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 14.0, bottom: 14.0, right: 56.0),
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: enrolled == false
                                    ? Colors.white
                                    : _topicList[i].available == null
                                        ? Colors.white
                                        : Color.fromRGBO(255, 255, 255, 0.5),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (enrolled) {
                                    if (_topicList[i].available == null) {
                                      counter_timer();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CourseModules(
                                            topic: _topicList[i],
                                            courseId: course.id.toString(),
                                          ),
                                        ),
                                      );
                                    } else {
                                      _showRestricted(_topicList[i].available);
                                    }
                                  } else {}
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 32.0),
                                      child: Image.asset(
                                        'images/topic.png',
                                        color: mBlue,
                                        width: 28.0,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0),
                                            child: Text(
                                              _topicList[i].name,
                                              style: TextStyle(color: mBlue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: _topicList.length,
                        ),
                      );
                    },
                  )
                ],
              ),
      ),
    ),
    );
  }
}
