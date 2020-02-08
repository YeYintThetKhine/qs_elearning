import 'package:flutter/material.dart';
import 'package:moodle_test/ThemeColors/colors.dart';


class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

var dummydata = "Understanding eLearning is simple. eLearning is learning utilizing electronic technologies to access educational curriculum outside of a traditional classroom.  In most cases, it refers to a course, program or degree delivered completely online.There are many terms used to describe learning that is delivered online, via the internet, ranging from Distance Education, to computerized electronic learning, online learning, internet learning and many others. We define eLearning as courses that are specifically delivered via the internet to somewhere other than the classroom where the professor is teaching. It is not a course delivered via a DVD or CD-ROM, video tape or over a television channel. It is interactive in that you can also communicate with your teachers, professors or other students in your class. Sometimes it is delivered live, where you can “electronically” raise your hand and interact in real time and sometimes it is a lecture that has been prerecorded. There is always a teacher or professor interacting /communicating with you and grading your participation, your assignments and your tests. eLearning has been proven to be a successful method of training and education is becoming a way of life for many citizens in North Carolina.";

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBlue,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('About Page',style: TextStyle(color: Colors.amber),),
        automaticallyImplyLeading: true,
      ),
      body:SingleChildScrollView(
        child:Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal:14),
          child: Text(dummydata,textAlign: TextAlign.justify,
                 style: TextStyle(height: 1.5,color: Colors.white,fontSize: 14.0),
          ),
        ),
      )
    );
  }
}