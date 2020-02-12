import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../ThemeColors/colors.dart';
import '../Dashboard/drawer.dart';
// import '../Dashboard/recent_course.dart';
import '../../Model/user.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';
import '../URL/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/model.dart';


class GradeHistoryMore extends StatefulWidget {

  final int courseid;
  final String categoryname;
  final String coursename;

  GradeHistoryMore({this.courseid,this.categoryname,this.coursename});
  @override
  _GradeHistoryMoreState createState() => _GradeHistoryMoreState(courseid:courseid,categoryname:categoryname,coursename:coursename);
}

class _GradeHistoryMoreState extends State<GradeHistoryMore> {
  List<DetailGrades> _quizGradeList = [];
  final int courseid;
  final String categoryname;
  final String coursename;
  bool _loading = false;

  _GradeHistoryMoreState({this.courseid,this.categoryname,this.coursename});

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  

  countertimer(){
  AutoLogoutMethod.autologout.counter(context);
  }

  getFinalQuizResult() async {
    String uid = currentUser.id;
    var response;
    var url = '$urlLink/$token/gradedetail/$courseid/$uid/';
      await http.get(url).then((result) {
        var grades = json.decode(result.body);
        for (var grade in grades['detail']) {
          _quizGradeList.add(DetailGrades(
            itemname: grade['itemname'],
            grade: grade['graderaw'].toString(),
            grademax: grade['grademax'].toString(),
            percentage: grade['percentageformatted'],
          ));
        }
        setState(() {
          _loading = true;
        });
      }).then((value) {
      print('completed with value $value');
      }, onError: (error) {
        print('completed with error $error');
      });
  }

  @override
  void initState() {
    super.initState();
    countertimer();
    getFinalQuizResult();
  }

  @override
  Widget build(BuildContext context) {

  final place_name = ['Great Wall of China', 'Ice-Land', 'Tokyo-Tower', 'Great Wall of China', 'Bangkok', 'Paris', 'Finland'];

  return GestureDetector(
    onTap: countertimer,
    child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: mBlue,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('List of Quiz Grades'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.of(context).pop();
              countertimer();
            },
          )
        ],
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            countertimer();
            _scaffoldKey.currentState.openDrawer();
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
      body: _loading == false
      ?Center(
        child: CircularProgressIndicator(),
      ) 
      :SingleChildScrollView(
        child: OrientationBuilder(
          builder: (context, orient) {
            return Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 15.0,right: 15.0,top:15.0, bottom: 20.0),
                      padding: EdgeInsets.only(
                          left: 15.0,right: 15.0,top:230.0,bottom: 20.0),
                      decoration: _quizGradeList.length == 1
                      ? BoxDecoration(color: mBlue)
                      :BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.0, 0.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                            color: Colors.black12,
                          )
                        ],
                      color: Colors.white60,
                      ),
                      child:ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _quizGradeList.length-1,
                        itemBuilder: (context, index) { 
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 30,
                                  margin: EdgeInsets.only(
                                      left: 15.0,right: 15.0),
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: new BorderRadius.circular(25.0),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          spreadRadius: 2.0,
                                          color: Colors.black12,
                                        )
                                      ],
                                  ),
                                  child: Center(
                                    child: Text((index+2).toString(),
                                      style: TextStyle(color: Colors.white, fontSize: 15.0,fontWeight: FontWeight.bold,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 18.0,
                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(0.0, 1.0),
                                                  blurRadius: 0.0,
                                                  color: Color.fromARGB(125, 0, 0, 255),
                                                ),
                                              ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(_quizGradeList[index+1].itemname,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                        shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(0.0, 0.0),
                                              blurRadius: 10.0,
                                              color: Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            Shadow(
                                              offset: Offset(0.0, 1.0),
                                              blurRadius: 0.0,
                                              color: Color.fromARGB(125, 0, 0, 255),
                                            ),
                                        ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Icon(
                                    Icons.grade,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 3.0),
                                  child: Text(
                                    "Grade - 9/10",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Icon(
                                    Icons.category,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 3.0),
                                  child: Text(
                                    "Category - $categoryname",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  margin: EdgeInsets.only(bottom: 20.0),
                                  child: Icon(
                                    Icons.trending_up,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 3.0),
                                  margin: EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    "Percentage - 100%",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                        }
                      ),
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 15.0,right: 15.0,top:15.0),
                      padding: EdgeInsets.only(
                          left: 15.0,right: 15.0,top:30.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                              color: Colors.black12,
                            )
                          ],
                        color: Colors.indigo[800],
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.only(left:35),
                              child: Text(_quizGradeList[0].itemname,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Icon(
                                  Icons.grade,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 3.0),
                                child: Text(
                                  "Grade - ${_quizGradeList[0].grade} out of ${_quizGradeList[0].grademax}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Icon(
                                  Icons.category,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 3.0),
                                child: Text(
                                  "Category - $categoryname",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Icon(
                                  Icons.trending_up,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 3.0),
                                child: Text(
                                  "Percentage - ${_quizGradeList[0].percentage}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(
                          left: 15.0,right: 15.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                              color: Colors.black12,
                            )
                          ],
                      ),
                      child: Center(
                        child: Text("Latest",
                          style: TextStyle(color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.bold,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    Shadow(
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 2.0,
                                      color: Color.fromARGB(125, 0, 0, 255),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
          }
        ),
      ),
    )
  );
  }
}
