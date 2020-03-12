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
import 'package:moodle_test/DB/db_lesson.dart';
import '../../Model/user.dart';


class OfflineLessonDetail extends StatefulWidget {
  final id;
  OfflineLessonDetail({this.id});
  @override
  _OfflineLessonDetailState createState() => _OfflineLessonDetailState(id:id);
}

class _OfflineLessonDetailState extends State<OfflineLessonDetail> {
  String id;
  _OfflineLessonDetailState({this.id});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _loading = true;
  List downloadedlessondetail;
  int currentpg = 0;

  counter_timer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  _getDownloadedLessonDetail() async{
    
    // await LessonDatabaseProvider.db.getAllDownloadLessonDetail().then((value) {
    //   // setState(() {
    //   //   downloadedlessondetail = value;
    //   // });
    //   print(value[0].lessonid);
    // }).then((value) {
    //   setState(() {
    //     _loading = false;
    //   });
    //   print('completed with value $value');
    //   }, onError: (error) {
    //     print('completed with error $error');
    //   });
    await LessonDatabaseProvider.db.getLessonDeatailWithId(id).then((value) {
      setState(() {
        downloadedlessondetail = value;
      });
      print(downloadedlessondetail.length);
    }).then((value) {
      setState(() {
        _loading = false;
      });
      print('completed with value $value');
      }, onError: (error) {
        print('completed with error $error');
      });
  }

  @override
  void initState() {
    super.initState();
    _getDownloadedLessonDetail();
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
                      width: MediaQuery.of(context).size.width-48,
                      margin: EdgeInsets.only(top: 8.0),
                      child:Text(
                              '${downloadedlessondetail[currentpg].title}',
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
                        data: downloadedlessondetail[currentpg].content,
                        defaultTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        currentpg == 0
                        ?Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: InkWell(
                            onTap: () {
                              if (currentpg >= 0) {
                                setState(() {
                                  currentpg++;
                                });
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
                              child: Text('Next')
                            ),
                          ),
                        )
                        :Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: InkWell(
                            onTap: () {
                                setState(() {
                                  currentpg--;
                                });
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
                              child: Text('Previous')
                            ),
                          ),
                        ),
                        currentpg == downloadedlessondetail.length -1
                        ?Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
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
                              child: Text('Finish')
                            ),
                          ),
                        )
                        :currentpg == 0
                        ?Container()
                        :Container(
                          margin: EdgeInsets.only(top: 16.0),
                          child: InkWell(
                            onTap: () {
                                setState(() {
                                  currentpg++;
                                });
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
                              child: Text('Next')
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
