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
            return GestureDetector(
              onTap: countertimer(),
              child:Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _quizGradeList.length,
                  itemBuilder: (context, index) { 
                    return Stack(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              left: 20.0,right: 10.0,top:0.0, bottom: 15.0),
                          padding: EdgeInsets.only(
                              left: 15.0,top:0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
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
                          color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Container(
                                width: 130,
                                padding: EdgeInsets.only(left:15),
                                child: Center(
                                  child: Text(_quizGradeList[index].itemname,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey[700])),
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  Container(
                                    width: 30,
                                    height: 55,
                                    margin: EdgeInsets.only(
                                      top:35.0,left: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    color: Colors.amber,
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    margin: EdgeInsets.only(left:10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    color: Colors.amber,
                                    ),
                                  ),
                                  Container(
                                    padding:EdgeInsets.symmetric(vertical: 10),
                                    width: 180,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        Center(
                                          child:Container(
                                            padding:EdgeInsets.only(left:30),
                                            child:Text('Grade Info',
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.grey[700])),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            child:Text('Grade - ${_quizGradeList[index].grade}/${_quizGradeList[index].grademax}',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.white)),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            child:Text('Category - $categoryname',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.white)),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            child:Text('Percentage - ${_quizGradeList[index].percentage}',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 30,
                          margin: EdgeInsets.only(
                              top:23.0,left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 20,
                          margin: EdgeInsets.only(
                              top:33.0,left: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          color: mBlue,
                          ),
                          child: Center(
                            child: Text((index+1).toString(), style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            );
          }
        ),
      ),
    )
  );
  }
}
