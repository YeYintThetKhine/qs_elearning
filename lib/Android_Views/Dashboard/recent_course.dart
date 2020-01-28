import 'package:flutter/material.dart';
import 'package:moodle_test/Android_Views/Category/course_view.dart';
import '../../ThemeColors/colors.dart';
import '../../Model/model.dart';
import 'package:html/parser.dart' as html;
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget recentCourse(
    BuildContext context, Course recentcourse, bool noRecent, String token) {
  return InkWell(
    onTap: () {
      if (recentcourse == null) {
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseEnroll(
              course: recentcourse,
            ),
          ),
        );
      }
    },
    child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Recent Course',
                  style: TextStyle(
                      color: mBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: noRecent == false
              ? Row(
                  children: <Widget>[
                    Container(
                      width: 75.0,
                      height: 75.0,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new NetworkImage(recentcourse.courseImgURL),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.black26,
                          width: 2.5,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              recentcourse.courseName,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 8.0, bottom: 8.0),
                            child: Text(
                              html.parse(recentcourse.courseDesc).body.text,
                              maxLines: 4,
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 16.0, height: 1.25),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 12.0),
                            child: new LinearPercentIndicator(
                              width: 175.0,
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 3.5,
                              trailing: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Chip(
                                  backgroundColor: Colors.deepOrangeAccent,
                                  label: Text(
                                    recentcourse.progress.toStringAsFixed(1) +
                                        "%",
                                    style: TextStyle(color: mWhite),
                                  ),
                                ),
                              ),
                              percent: recentcourse.progress.toDouble() / 100,
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              backgroundColor: Colors.white54,
                              progressColor: Colors.deepOrangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'No Recent Course',
                    style: TextStyle(color: Colors.black26, fontSize: 20.0),
                  ),
                ),
        ),
      ],
    ),
  );
}
