import 'package:flutter/material.dart';
import 'package:moodle_test/Android_Views/Dashboard/drawer.dart';
import 'package:moodle_test/Model/user.dart';
import 'package:moodle_test/ThemeColors/colors.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';
import 'package:moodle_test/DB/db_lesson.dart';
import '../../Model/user.dart';
import '../OfflineLesson/offline_lesson_detail.dart';
import '../../DrawerTheme/drawerdetect.dart';

class OfflineLesson extends StatefulWidget {

  @override
  _OfflineLessonState createState() => _OfflineLessonState();
}

class _OfflineLessonState extends State<OfflineLesson> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _loading = true;
  List downloadedlesson;

  counter_timer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  _getDownloadedLesson() async{
    await LessonDatabaseProvider.db.getLessonWithUserId(currentUser.id).then((value) {
      setState(() {
        downloadedlesson = value;
      });
      print(downloadedlesson[0].id);
    }).then((value) {
      setState(() {
        _loading = false;
      });
      print('completed with value $value');
      }, onError: (error) {
      setState(() {
        _loading = false;
      });
        print('completed with error $error');
      });
  }

  @override
  void initState() {
    super.initState();
    currentPage = 'offline_lesson';
    _getDownloadedLesson();
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
          'Lesson Offline',
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
          :downloadedlesson.length == 0
          ?Center(
              child: Text("There is no lesson downloaded",
                style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: downloadedlesson.length, 
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                OfflineLessonDetail(id:downloadedlesson[index].id),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom:15),
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/quiz.png',
                                  color: Colors.white70,
                                  width: 18.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-130,
                                  padding: EdgeInsets.only(left:5),
                                  child:Text(downloadedlesson[index].title,
                                    style: TextStyle(color:Colors.white),
                                  )
                                ),
                              ]
                            ),
                          ),
                          Container(
                            width: 50.0,
                            height: 35.0,
                            margin: EdgeInsets.only(bottom:15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(5.0),
                              border: Border.all(
                                width: 1.0,
                                color: Colors.red,
                              ),
                            ),
                            child: FlatButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () async{
                                await LessonDatabaseProvider.db.deleteLessonDetailWithId(downloadedlesson[index].id);
                                setState(() {
                                  _loading = true;
                                });
                                await LessonDatabaseProvider.db.deleteLessonWithId(downloadedlesson[index].id);
                                await _getDownloadedLesson();
                                counter_timer();
                              },
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
    )
    );
  }
}
