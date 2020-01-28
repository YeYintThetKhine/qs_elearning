import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_test/Android_Views/Course/quiz_result.dart';
import '../../Model/model.dart';
import '../../ThemeColors/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../URL/url.dart';
import 'package:moodle_test/Model/model.dart';

class ModuleQuiz extends StatefulWidget {
  final token;
  final module;

  ModuleQuiz({this.module, this.token});
  @override
  _ModuleQuizState createState() =>
      _ModuleQuizState(module: module, token: token);
}

class _ModuleQuizState extends State<ModuleQuiz> {
  Module module;
  String token;
  _ModuleQuizState({this.module, this.token});

  String quizQuestion = '';
  bool _loading = true;
  List<bool> resultList = [];
  List<Quiz> quizList = [];
  List<QuizAnswer> quizAnsList = [];
  var atmtID = '';
  var questionID = '';
  bool _processing = false;
  bool _check_unfinish_quiz = false;
  int _quizcounter = 0;
  bool _finished = false;
  List<QuizResult> quizResults = [];

  @override
  void initState() {
    super.initState();
    _getQuiz();
  }

  _getQuiz() async {
    var number = 0;
    var url = '$urlLink/$token/quiz/${module.instance}/';
    print(url);
    await http.get(url).then((data) {
      print("passed here 1");
      var result = json.decode(data.body);
      atmtID = result['attempt'].toString();
      print("passed here 3");
      questionID = result['question_id'].toString();
      var totalQuizzes = result['quizs'].length;
      for (var i = 0; i < totalQuizzes; i++) {
        QuizAnswer qa = QuizAnswer(
          id: i.toString(),
          slot: 'slots',
          slotValue: (i + 1).toString(),
          sequencecheck: 'q$questionID:${i + 1}_:sequencecheck',
          sequencecheckValue: '1',
          answer: 'q$questionID:${i + 1}_answer',
          ansValue: '',
        );
        quizAnsList.add(qa);
      }
      for (var quiz in result['quizs']) {
        List<String> quizChoices = [];
        for (var choice in quiz['quizChoices']) {
          quizChoices.add(choice);
        }
        resultList = List<bool>.generate(
          quizChoices.length,
          (index) {
            return false;
          },
        );
        Quiz q = Quiz(
            id: number.toString(),
            qzQuestion: quiz['question'],
            qzType: quiz['type'],
            qzChoices: quizChoices,
            answers: resultList);
        quizList.add(q);
      }
      setState(() {
        _loading = false;
      });
    }).then((value) {
    print('completed with value $value');
  }, onError: (error) {
    print('completed with error $error');
    quizList.clear();
  });
  }

  ansSelected(int index, int i, String qType, String ans) {
    setState(() {
      if (quizList[index].answers[i]) {
        for (var x = 0; x < quizList[index].answers.length; x++) {
          quizList[index].answers[x] = false;
        }
        quizList[index].answers[i] = false;
      } else {
        for (var x = 0; x < quizList[index].answers.length; x++) {
          quizList[index].answers[x] = false;
        }
        quizList[index].answers[i] = true;
        if (qType == 'truefalse' && ans == 'True') {
          quizAnsList[index].ansValue = '1';
        } else if (qType == 'truefalse' && ans == 'False') {
          quizAnsList[index].ansValue = '0';
        } else {
          quizAnsList[index].ansValue = i.toString();
        }
      }
    });
  }

  _processingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
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
                  'Loading...'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  submitQuiz() async {
    _processingDialog();
    setState(() {
      _processing = true;
    });
    var submitUrl = '$urlLink/$token/quiz/save/$atmtID/?';
    var parameter = '';
    for (var i = 0; i < quizAnsList.length; i++) {
      parameter +=
          'sname$i=${quizAnsList[i].slot}&svalue$i=${quizAnsList[i].slotValue}&seqname$i=${quizAnsList[i].sequencecheck}&seqvalue$i=${quizAnsList[i].sequencecheckValue}&ansname$i=${quizAnsList[i].answer}&ansvalue$i=${quizAnsList[i].ansValue}';
    }
    await http.get(submitUrl + parameter).then((response) {
      var msg = json.decode(response.body);
      if (msg['state'] == 'finished') {
        setState(() {
          _processing = false;
          _finished = true;
        });
        getQuizResult();
        setModuleCompleteStatus();
      }
    });
  }

  getQuizResult() async {
    var resultUrl = '$urlLink/$token/quiz/attempt/$atmtID/review/';
    await http.get(resultUrl).then((response) {
      var results = json.decode(response.body);
      for (var result in results) {
        List<String> choices = [];
        for (var choice in result['choices']) {
          choices.add(choice);
        }
        QuizResult qr = QuizResult(
          chose: choices,
          correctAnswer: result['correct answer'],
          question: result['question'],
          choseAnswer: result['chose answer'],
          status: result['status'],
        );
        quizResults.add(qr);
      }
    });
  }

  setModuleCompleteStatus() async {
    var setCompleteUrl = '$urlLink/$token/module/complete/${module.id}/';
    await http.get(setCompleteUrl).then((status) {
      var data = json.decode(status.body);
      if (data['status'] == true) {
        Navigator.of(context).pop();
      }
    });
  }

  finishAttempt() {
    setState(() {
      _check_unfinish_quiz=false;
      _quizcounter=0;
    });
    print("x");
    for (var x = 0; x < quizList.length; x++) {
      for (var y = 0; y < quizList[x].answers.length; y++) {
        if(quizList[x].answers[y] == true) {
          setState(() {
            _check_unfinish_quiz=true;
            _quizcounter++;
          });
        }
      }
    }
    print(_quizcounter);
    if(_quizcounter==quizList.length){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Finish Quiz'),
            content: Text('Are you sure to submit your quiz?'),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: mBlue,
                onPressed: () {
                  Navigator.of(context).pop();
                  submitQuiz();
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
              ),
            ],
          );
        }); 
    }
    else if(_quizcounter!=quizList.length){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text('Warning'),
            content: Text('You still have unanswered question/s in this quiz list. Please finish all the questions and submit again.'),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: mBlue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBlue,
      appBar: AppBar(
        title: Text(
          module.name,
          style: TextStyle(color: Colors.amber),
        ),
        elevation: 0.0,
      ),
      body: _loading == true
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      return Card(
                        color: Colors.white,
                        elevation: 3.6,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.flag,
                                        color: Colors.black38,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        quizList[i].qzQuestion,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 300.0,
                                  child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    itemCount: quizList[i].qzChoices.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: quizList[i].answers[index]
                                              ? Colors.amberAccent
                                              : Color.fromRGBO(0, 0, 0, 0.05),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            if (_finished) {
                                              print('Cannot');
                                            } else {
                                              ansSelected(
                                                i,
                                                index,
                                                quizList[i].qzType,
                                                quizList[i].qzChoices[index],
                                              );
                                            }
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Icon(
                                                  quizList[i].answers[index]
                                                      ? Icons.check_box
                                                      : Icons
                                                          .check_box_outline_blank,
                                                  color: Colors.black54,
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
                                                  child: Text(
                                                    quizList[i]
                                                        .qzChoices[index],
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                            ],
                          ),
                        ),
                      );
                    }, childCount: quizList.length),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: _processing ? Colors.white60 : Colors.amber,
                          onPressed: () {
                            if (_processing == false && _finished == false) {
                              finishAttempt();
                            } else {
                              showQuizResult(context, quizResults);
                            }
                          },
                          child: _finished
                              ? Text(
                                  'View Result',
                                  style: TextStyle(fontSize: 18.0),
                                )
                              : Text(
                                  'Finish',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
