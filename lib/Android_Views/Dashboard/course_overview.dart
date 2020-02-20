import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../Model/model.dart';
import '../../ThemeColors/colors.dart';
import 'package:moodle_test/Android_Views/Category/course_view.dart';
import 'package:connectivity/connectivity.dart';

  String eventtype="initial";
  int index;
  List _courseListTwo;

  showAlertDialog(String title, String message,context) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.pop(context);
          _connectionCheck(context);
        }, child: Text('Try again'))
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => alertDialog
    );
  }

  _connectionCheck(context) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      if(eventtype == "courselist"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseEnroll(
              course: _courseListTwo[index],
            ),
          ),
        );
      }
    } 
    else if(connectivityResult == ConnectivityResult.none){
      print("here");
      showAlertDialog('Mobile Connection Lost', 'Please connect to your wifi or turn on mobile data and try again',context);
    }
  }

Widget courseOverViewWidget(List<Course> _courseList, String token) {

  return ListView.builder(
    itemCount: _courseList.length,
    itemBuilder: (context, index) {
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: mBlue,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0.05,
                  color: Colors.black12,
                )
              ],
              image: DecorationImage(
                image: NetworkImage(
                    _courseList[index].courseImgURL + '?token=$token'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Color.fromRGBO(255, 255, 255, 0.9), BlendMode.srcOver),
              ),
            ),
            width: 250.0,
            child: InkWell(
              onTap: () {
                eventtype="courselist";
                index=index;
                _courseListTwo=_courseList;
                _connectionCheck(context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _courseList[index].courseName,
                      style: TextStyle(
                        color: mBlue,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            color: mBlue,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 3.5,
                          animation: true,
                          percent: _courseList[index].progress.toDouble() / 100,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: mBlue,
                          backgroundColor: Color.fromRGBO(0, 0, 0, 0.15),
                          center: Text(
                            _courseList[index].progress.toStringAsFixed(1) +
                                '%',
                            style: TextStyle(color: mBlue, fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
    scrollDirection: Axis.horizontal,
  );
}
