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
  bool nodataCheck = false;
  bool lessondownloadcheck = false;

  counter_timer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  @override
  void initState() {
    super.initState();
    // LessonDatabaseProvider.db.deletePersonWithId("51");
    getLessonPages();
    accCheck();
    counter_timer();
    _checkDownloadedLesson();
  }

  getLessonDownload() async {
    var url = '$urlLink/$token/dllesson/${module.instance}/';
    print(url);
    showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (BuildContext context) {
          return WillPopScope( 
          onWillPop: () async => false,
          child:AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content:Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 1.5,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(mBlue),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Downloading...'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          ),
          );
        });
    await http.get(url).then((pages) async{
      var datas = json.decode(pages.body);
      print(datas);
      LessonDownload dlesson = LessonDownload();
      dlesson.id = module.id.toString();
      dlesson.userid = currentUser.id;
      dlesson.title = module.name;
      LessonDatabaseProvider.db.addLessonToDatabase(dlesson);
      if(datas['pages'].length != 0){
        for(var data in datas['pages']){
          LessonDetailDownload dlessondetail = LessonDetailDownload();
          dlessondetail.lessonid = module.id.toString();
          print(dlessondetail.lessonid);
          dlessondetail.title = data['page']['title'];
          print(dlessondetail.title);
          dlessondetail.content = data['page']['contents'];
          print(dlessondetail.content);
          LessonDatabaseProvider.db.addLessonDetailToDatabase(dlessondetail);
          print(dlessondetail);
        }
        

      }
      else{

      }
    }).then((value) {
    Navigator.of(context).pop();
    _checkDownloadedLesson();
    print('completed with value $value');
  }, onError: (error) {
    Navigator.of(context).pop();
    print('completed with error $error');
  });
  }

  _checkDownloadedLesson() async{
    await LessonDatabaseProvider.db.getLessonWithUserIdandId(currentUser.id,module.id.toString()).then((value) {
      if(value.length > 0){
        setState(() {
          lessondownloadcheck = true;
        });
      }
    }).then((value) {

      print('completed with value $value');
      }, onError: (error) {
        print('completed with error $error');
      });
  }

  _alreadyDowloaded() async{
    showDialog(
        context: (context),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('This Lesson is already downloaded'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Text('Do you want to replace the old one and download again?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () async{
                  Navigator.of(context).pop();
                  await LessonDatabaseProvider.db.deleteLessonDetailWithId(module.id.toString());
                  setState(() {
                    _loading = true;
                  });
                  await LessonDatabaseProvider.db.deleteLessonWithId(module.id.toString());                  
                  await getLessonDownload();
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        });
  }

  accCheck() async{
    
    await LessonDatabaseProvider.db.getAllDownloadLessonDetail().then((value) {
      print(value[0].lessonid);

    }).then((value) {
      print('completed with value $value');
      }, onError: (error) {
        print('completed with error $error');
      });

    await LessonDatabaseProvider.db.getLessonDeatailWithId("51").then((value) {
      print(value.length);

    }).then((value) {
      print('completed with value $value');
      }, onError: (error) {
        print('completed with error $error');
      });
  }

  getLessonPages() async {
    var url = '$urlLink/$token/lesson/${module.instance}/';
    print(url);
    await http.get(url).then((pages) {
      var data = json.decode(pages.body);
      // if(data == null){
      //   setState(() {
      //     _loading = false;
      //     nodataCheck = true;
      //   });
      // }
        lesson.id = data[0]['page']['id'];
        lesson.title = data[0]['page']['title'];
        lesson.content = data[0]['page']['contents'];
        lesson.nextPage = data[0]['page']['nextpageid'];
        lesson.previousPage = data[0]['page']['prevpageid'];
        setState(() {
          _loading = false;
        });
    }).then((value) {
        setState(() {
          _loading = false;
        });
    print('completed with value $value');
  }, onError: (error) async{
        // setState(() {
        //   _loading = false;
        //   nodataCheck = true;
        // });
    print('completed with error $error');
  });
  }

  chgLessonPage(int pgID) async {
    setState(() {
      _loading = true;
    });
    var nextUrl = '$urlLink/$token/lesson/${module.instance}/page/$pgID/';
    print(nextUrl);
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
          :nodataCheck == true
          ?Center(
            child: Container(
              child: Text('This Lesson is empty',
                style: TextStyle(
                  color:Colors.white, fontSize: 20
                ),
              ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width-130,
                            child: Text(
                              '${lesson.title}',
                              style: TextStyle(color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                          Container(
                            width: 50.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                color: lessondownloadcheck == true? Colors.green:Colors.amber,
                              ),
                            ),
                            child: FlatButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                lessondownloadcheck == true
                                ?_alreadyDowloaded()
                                :getLessonDownload();
                                counter_timer();
                              },
                              child: Icon(
                                Icons.file_download,
                                color: lessondownloadcheck == true? Colors.green:Colors.amber,
                              ),
                            ),
                          ),
                        ],
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
                        showImages: true,
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
