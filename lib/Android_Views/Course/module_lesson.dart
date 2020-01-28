import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moodle_test/Android_Views/Dashboard/drawer.dart';
import 'package:moodle_test/Android_Views/URL/url.dart';
import 'package:moodle_test/Model/model.dart';
import 'package:moodle_test/Model/user.dart';
import 'package:moodle_test/ThemeColors/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';

class ModuleLesson extends StatefulWidget {
  final module;
  ModuleLesson({this.module});
  @override
  _ModuleLessonState createState() => _ModuleLessonState(module: module);
}

class _ModuleLessonState extends State<ModuleLesson> {
  Module module;
  _ModuleLessonState({this.module});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Lesson lesson = Lesson();
  bool _loading = true;

  counter_timer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  @override
  void initState() {
    super.initState();
    getLessonPages();
    counter_timer();
  }

  getLessonPages() async {
    var url = '$urlLink/$token/lesson/${module.instance}/';
    await http.get(url).then((pages) {
      var data = json.decode(pages.body);
      lesson.id = data[0]['page']['id'];
      lesson.title = data[0]['page']['title'];
      lesson.content = data[0]['page']['contents'];
      lesson.nextPage = data[0]['page']['nextpageid'];
      lesson.previousPage = data[0]['page']['prevpageid'];
      setState(() {
        _loading = false;
      });
    });
  }

  chgLessonPage(int pgID) async {
    setState(() {
      _loading = true;
    });
    var nextUrl = '$urlLink/$token/lesson/${module.instance}/page/$pgID/';
    await http.get(nextUrl).then((data) {
      var jasonType = json.decode(data.body);
      lesson.id = jasonType['page']['id'];
      lesson.title = jasonType['page']['title'];
      lesson.content = jasonType['page']['contents'];
      lesson.nextPage = jasonType['page']['nextpageid'];
      lesson.previousPage = jasonType['page']['prevpageid'];
      setState(() {
        _loading = false;
      });
    });
  }

  dialogLoading() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Center(
                      child: Container(
                        height: 2.5,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation(mBlue),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Loading...'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  setModuleCompleteStatus() async {
    var setCompleteUrl = '$urlLink/$token/module/complete/${module.id}/';
    await http.get(setCompleteUrl).then((status) {
      var data = json.decode(status.body);
      if (data['status'] == true) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    });
  }

  moduleFinish() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Lesson Finish'),
            content: Text('Are you sure to finish this lesson?'),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: mBlue,
                onPressed: () {
                  Navigator.of(context).pop();
                  dialogLoading();
                  setModuleCompleteStatus();
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
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
      backgroundColor: mBlue,
      appBar: AppBar(
        title: Text(
          'Lesson',
          style: TextStyle(color: Colors.amber),
        ),
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
            counter_timer();
            _scaffoldKey.currentState.openDrawer();
          },
          icon: Image.asset(
            'images/menu.png',
            width: 24.0,
            color: mWhite,
          ),
        ),
      ),
      drawer: drawer(currentUser, context),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: Text(
                        lesson.title,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18.0),
                      height: 0.5,
                      color: Colors.amber,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: Html(
                        data: lesson.content,
                        defaultTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        lesson.previousPage == 0
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    counter_timer();
                                    if (lesson.previousPage > 0) {
                                      chgLessonPage(lesson.previousPage);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.amber,
                                    ),
                                    width: 75.0,
                                    height: 35.0,
                                    child: lesson.nextPage >= 0
                                        ? Text('Previous')
                                        : Container(),
                                  ),
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: InkWell(
                            onTap: () {
                              if (lesson.nextPage > 0) {
                                counter_timer();
                                chgLessonPage(lesson.nextPage);
                              } else {
                                counter_timer();
                                moduleFinish();
                              }
                            },
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.amber,
                              ),
                              width: 75.0,
                              height: 35.0,
                              child: lesson.nextPage > 0
                                  ? Text('Next')
                                  : Text('Finish'),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    )
    );
  }
}
