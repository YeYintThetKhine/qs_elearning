import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:moodle_test/Android_Views/URL/url.dart';
import '../../ThemeColors/colors.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../Model/model.dart';
import '../Course/module_video.dart';
import '../Course/module_quiz.dart';
import 'package:flutter/services.dart';
import '../Dashboard/drawer.dart';
import '../../Model/user.dart';
import '../../Android_Views/Course/module_lesson.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';

class CourseModules extends StatefulWidget {
  final topic;
  final courseId;

  CourseModules({this.topic, this.courseId});
  @override
  _CourseModulesState createState() =>
      _CourseModulesState(topic: topic, courseId: courseId);
}

class _CourseModulesState extends State<CourseModules> {
  Topic topic;
  String courseId;
  _CourseModulesState({this.topic, this.courseId});

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<QuizAdditionalDetail> _quizDetailList = [];

  int quiznum = 0;

  counter_timer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    counter_timer();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<Topic> getModules() async {
    var modUrl = '$urlLink/$token/course/$courseId/section/${topic.id}/';
    await http.get(modUrl).then((response) async{
      var mods = json.decode(response.body);

    String uid = currentUser.id;
    var quizAdditionalUrl = '$urlLink/$token/quizinfo/course/$courseId/user/$uid/';
    print(quizAdditionalUrl);
    await http.get(quizAdditionalUrl).then((response) {
      var data = json.decode(response.body);
        for (var quiz in data['quiz_info']) {
          _quizDetailList.add(
            QuizAdditionalDetail(
              quizid:quiz['quizid'],
              courseid:quiz['courseid'],
              moduleid:quiz['moduleid'],
              name:quiz['name'],
              timelimit:quiz['timelimit'],
              maxattempts:quiz['maxattempts'],
              usercurrentattempts:quiz['usercurrentattempts'],
            ),
          );
        }
    });

      if (mods[0]['modules'].length > 0) {
        List<Module> _moduleList = [];
        for (var module in mods[0]['modules']) {
          if(module['modname']=="quiz"){
            _moduleList.add(
              Module(
                id: module['id'].toString(),
                instance: module['instance'].toString(),
                moduleType: module['modname'],
                name: module['name'],
                url: module['contents'] != null
                    ? module['contents'][0]['fileurl']
                    : null,
                completeStatus: module['completiondata'] == null
                    ? 0
                    : module['completiondata']['state'],
                completeTime: module['completiondata'] == null
                    ? 0
                    : module['completiondata']['timecompleted'],
                available: module['availabilityinfo'],
                timelimit:_quizDetailList[quiznum].timelimit,
                maxattempts:_quizDetailList[quiznum].maxattempts,
                usercurrentattempts:_quizDetailList[quiznum].usercurrentattempts,
              ),
            );
            quiznum++;
          }
          else{
            _moduleList.add(
              Module(
                id: module['id'].toString(),
                instance: module['instance'].toString(),
                moduleType: module['modname'],
                name: module['name'],
                url: module['contents'] != null
                    ? module['contents'][0]['fileurl']
                    : null,
                completeStatus: module['completiondata'] == null
                    ? 0
                    : module['completiondata']['state'],
                completeTime: module['completiondata'] == null
                    ? 0
                    : module['completiondata']['timecompleted'],
                available: module['availabilityinfo'],
                timelimit:-1,
                maxattempts:-1,
                usercurrentattempts:-1,
              ),
            );
          }
        }
        topic = Topic(
          id: mods[0]['id'].toString(),
          name: mods[0]['name'],
          desc: mods[0]['summary'],
          available: mods[0]['availabilityinfo'],
          modules: _moduleList,
        );
      } else {
        topic = Topic(
          id: mods[0]['id'].toString(),
          name: mods[0]['name'],
          desc: mods[0]['summary'],
          available: mods[0]['availabilityinfo'],
          modules: null,
        );
      }
    });
    return topic;
  }

  _showRestricted(String reason) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Restricted'),
            content: Text(html.parse(reason).body.text),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              )
            ],
          );
        });
  }

  _startQuiz(Module module,int timelimit) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Confirm'),
            content: Text('Are you sure to start quiz now?'),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: mBlue,
                onPressed: () {
                  print(timelimit);
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModuleQuiz(
                        module: module,
                        token: token,
                        timelimit: timelimit,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Start',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: mBlue),
                ),
              )
            ],
          );
        });
  }

  _quizAttemptCheckDialog(int maxattempt) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Attempt max out'),
            content: Text('You can only attempt maximum $maxattempt times'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
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
          topic.name,
          style: TextStyle(color: Colors.amber),
        ),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.of(context).pop();
              counter_timer();
            },
          )
        ],
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
            counter_timer();
          },
          icon: Image.asset(
            'images/menu.png',
            width: 24.0,
            color: mWhite,
          ),
        ),
      ),
      drawer: drawer(currentUser, context),
      body: FutureBuilder(
        future: getModules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            Topic topic = snapshot.data;
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                        child: Text(
                          'Description'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        margin: EdgeInsets.only(top: 16.0),
                        child: Html(
                          blockSpacing: 0.0,
                          data: topic.desc,
                          defaultTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            height: 1.25,
                            wordSpacing: 1.25,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Modules'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            if (topic.modules[i].available != null) {
                              _showRestricted(topic.modules[i].available);
                            } else {
                              if (topic.modules[i].moduleType == 'resource') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModuleVideo(
                                      module: topic.modules[i],
                                      token: token,
                                    ),
                                  ),
                                );
                              } else if (topic.modules[i].moduleType ==
                                  'lesson') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModuleLesson(
                                      module: topic.modules[i],
                                    ),
                                  ),
                                );
                              } else {
                                topic.modules[i].usercurrentattempts == topic.modules[i].maxattempts
                                ?_quizAttemptCheckDialog(topic.modules[i].maxattempts)
                                :_startQuiz(topic.modules[i],topic.modules[i].timelimit);
                              }
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.check_circle,
                                    color: topic.modules[i].completeStatus == 1
                                        ? Colors.greenAccent
                                        : Colors.white70,
                                    size: 18.0,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: topic.modules[i].moduleType ==
                                            'resource'
                                        ? Icon(
                                            Icons.ondemand_video,
                                            color: Colors.white70,
                                            size: 18.0,
                                          )
                                        : Image.asset(
                                            'images/quiz.png',
                                            color: Colors.white70,
                                            width: 18.0,
                                          ),
                                  ),
                                  Container(
                                    // width: MediaQuery.of(context).size.width-200,
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      topic.modules[i].name,
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  topic.modules[i].maxattempts == -1
                                  ?Container()
                                  :Container(
                                    margin: EdgeInsets.only(left:10),
                                    child: Row(
                                      children:[
                                        // Container(
                                        //   width: 1,
                                        //   height: 35,
                                        //   margin: EdgeInsets.only(right:5),
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.white,
                                        //     border: Border.all(
                                        //       color: Colors.white,
                                        //       width: 0,
                                        //     ),
                                        //     borderRadius: BorderRadius.circular(5),
                                        //   ),
                                        // ),
                                        // Container(
                                        //   margin: EdgeInsets.only(right:5),
                                        //   color:mBlue,
                                        //   child:Center(
                                        //     child: Text(
                                        //     'Attempt',
                                        //     style: TextStyle(
                                        //         color: Colors.amber,
                                        //         fontSize: 16.0,
                                        //         fontWeight: FontWeight.bold),
                                        //     ),
                                        //   ),
                                        // ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 3),
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                            'Attempt: ${topic.modules[i].usercurrentattempts.toString()}/${topic.modules[i].maxattempts.toString()}',
                                            style: TextStyle(
                                                color: mBlue,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        // Stack(
                                        //   children: <Widget>[
                                        //     Container(
                                        //       margin: EdgeInsets.only(top:10),
                                        //       padding: EdgeInsets.only(left:5,right: 10,top:5,bottom:5),
                                        //       color:mBlue,
                                        //       child:Center(
                                        //         child: Text(
                                        //         'Attempt',
                                        //         style: TextStyle(
                                        //             color: Colors.amber,
                                        //             fontSize: 16.0,
                                        //             fontWeight: FontWeight.bold),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       padding: EdgeInsets.symmetric(vertical: 3,horizontal: 3),
                                        //       margin: EdgeInsets.only(left:65,bottom:25),
                                        //       decoration: BoxDecoration(
                                        //           color: Colors.amber,
                                        //           border: Border.all(
                                        //             color: Colors.white,
                                        //             width: 2,
                                        //           ),
                                        //           borderRadius: BorderRadius.circular(5),
                                        //       ),
                                        //       child: Center(
                                        //         child: Text(
                                        //         '${topic.modules[i].usercurrentattempts.toString()}/${topic.modules[i].maxattempts.toString()}',
                                        //         style: TextStyle(
                                        //             color: mBlue,
                                        //             fontSize: 16.0,
                                        //             fontWeight: FontWeight.bold),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ]
                                    ),
                                    // decoration: BoxDecoration(
                                    //   color: Colors.white,
                                    //   border: Border.all(
                                    //     color: Colors.white,
                                    //     width: 0,
                                    //   ),
                                    //   borderRadius: BorderRadius.circular(5),
                                    // ),
                                    // child: Text(
                                    //   topic.modules[i].maxattempts.toString(),
                                    //   style: TextStyle(
                                    //       color: Colors.white70,
                                    //       fontSize: 16.0),
                                    // ),
                                  ),
                                  topic.modules[i].available == null
                                      ? Container()
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          margin: EdgeInsets.only(left: 16.0),
                                          padding: EdgeInsets.all(6.0),
                                          child: Text(
                                            'Restricted'.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: topic.modules.length,
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    )
    );
  }
}
