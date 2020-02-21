import 'package:flutter/material.dart';
import '../../ThemeColors/colors.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';
import '../../Model/model.dart';
import 'package:moodle_test/Android_Views/Dashboard/grade_history_more.dart';
import 'package:connectivity/connectivity.dart';

  @override
Widget gradeHistoryWidget(List<GradeByCategory> _categoryQuizList, String token, context) {

  String eventtype="initial";

    countertimer(){
      AutoLogoutMethod.autologout.counter(context);
    }

    return InkWell( 
      onTap: () {

      },
      child:Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 110,
      child: new ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: _categoryQuizList.length,
      itemBuilder: (context, index) {
        return GestureDetector( 
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GradeHistoryMore(
                  categoryname: _categoryQuizList[index].categoryname,
                  courseid:_categoryQuizList[index].courseid,
                  coursename: _categoryQuizList[index].coursename
                ),
              ),
            );
          },
          child: Container(width: 303.0,
                margin: EdgeInsets.only(left:10,right: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      color: Colors.black12,
                    )
                  ],
                color: mBlue,
              ),
              child: Row(
                children: <Widget>[
                  Container(width: 120.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(10.0),bottomLeft:  const Radius.circular(10.0)),
                        color: Colors.white
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left:1.5,top: 1.5,bottom: 1.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: const Radius.circular(10.0),bottomLeft:  const Radius.circular(10.0)),
                        image: new DecorationImage(
                          image: new NetworkImage(
                                  _categoryQuizList[index].gradeCategoryImg + '?token=$token'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    margin: EdgeInsets.only(left:5),  
                    color: Colors.amber,
                  ),
                  Container(
                    width: 175,
                    padding: EdgeInsets.only(left:20,right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: const Radius.circular(10.0),bottomRight:  const Radius.circular(10.0)),
                      color: Colors.white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Text(_categoryQuizList[index].coursename,overflow: TextOverflow.ellipsis,style: TextStyle(color:mBlue ,fontWeight: FontWeight.bold,fontSize: 18)),
                        ),
                        Text('Total Marks: ${_categoryQuizList[index].mark}',style: TextStyle(color:mBlue)),
                      ]
                    ),
                  ),
                ],
              ), 
          ),
        );
      },
    ),
      ),
  );
  }