import 'package:flutter/material.dart';
import '../../ThemeColors/colors.dart';
import 'package:moodle_test/Android_Views/Dashboard/grade_history_more.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';


Widget gradeHistoryWidget(BuildContext context) {
    countertimer(){
    AutoLogoutMethod.autologout.counter(context);
    }
      return Container(
            margin: EdgeInsets.all(12.0),
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
              color: Color(0xFFFFFFFF),
            ),
            child: InkWell(
              onTap: () {
                countertimer();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Accounting Course Beginner Level".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mBlue,
                        fontSize: 20.0,
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
                          "Grade - 9/10",
                          style: TextStyle(
                            color: mBlue,
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
                          "Category - Banking",
                          style: TextStyle(
                            color: mBlue,
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
                          "Percentage - 100%",
                          style: TextStyle(
                            color: mBlue,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15.0,bottom: 20.0),
                    width: 180,
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
                      color: Colors.amber,
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GradeHistoryMore(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                              Container(
                                child: Text(
                                  "Click for more",
                                  style: TextStyle(
                                    color: mBlue,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Container(
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
}