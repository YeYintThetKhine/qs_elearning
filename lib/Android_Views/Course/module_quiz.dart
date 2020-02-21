import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_test/Android_Views/Course/quiz_result.dart';
import '../../Model/model.dart';
import '../../ThemeColors/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../URL/url.dart';
import 'package:moodle_test/Model/model.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';
import 'dart:async';
import 'dart:math' as math;

class ModuleQuiz extends StatefulWidget {
  final token;
  final module;
  int timelimit;

  ModuleQuiz({this.module, this.token, this.timelimit});
  @override
  _ModuleQuizState createState() =>
      _ModuleQuizState(module: module, token: token, timelimit: timelimit);
}

class _ModuleQuizState extends State<ModuleQuiz> with TickerProviderStateMixin{
  Module module;
  String token;
  int timelimit;
  _ModuleQuizState({this.module, this.token, this.timelimit});

  String quizQuestion = '';
  bool _loading = true;
  List<bool> resultList = [];
  List<Quiz> quizList = [];
  List<QuizAnswer> quizAnsList = [];
  var atmtID = '';
  var questionID = '';
  bool _processing = false;
  bool _check_unfinish_quiz = false;
  List<int> _unanswered_quizlist = List<int>();
  int _quizpagenumber = 0;
  bool _finished = false;
  List<QuizResult> quizResults = [];

  countertimer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Timer quiztimer;
  void counter(context) {
    if(timelimit == 0){

    }
    else {
      quiztimer = new Timer (Duration(seconds: timelimit), () {
        _showAlertDialog('Time Up', 'You have exceeded the quiz time. Please take the quiz again.',context);
      });
    }
  }


  void _showAlertDialog(String title, String message,context) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          }, 
          child: Text('OK'),
        ),
      ],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => alertDialog
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: timelimit),
    );
    countertimer();
    _getQuiz();
  }

  @override
  dispose() {
    super.dispose();
    quiztimer.cancel();
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionListener = ItemPositionsListener.create();

  _getQuiz() async {
    var number = 0;
    var response;
    var url = '$urlLink/$token/quiz/${module.instance}/';
    print(url);
      try {
        response = await http.get(url).then((data) {
          var result = json.decode(data.body);
        });
      } catch (e) {
        print("You can only answer once");
      }
    await http.get(url).then((data) {
      var result = json.decode(data.body);
      atmtID = result['attempt'].toString();
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
            qzType: quiz['tycheckunanswerpe'],
            checkunanswer: true,
            qzChoices: quizChoices,
            answers: resultList);
        quizList.add(q);
      }
      setState(() {
        _loading = false;
      });
    }).then((value) {
    controller.stop(canceled: true);
    controller.reverse(
    from: controller.value == 0.0
        ? 1.0
        : controller.value);
    counter(context);
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

  nextQuiz() async {
    setState(() {
      _quizpagenumber++;
    });
    itemScrollController.scrollTo(
    index: _quizpagenumber,
    duration: Duration(seconds: 1),
    curve: Curves.easeInOutCubic);
  }

  previousQuiz() async {
    setState(() {
      _quizpagenumber--;
    });
    itemScrollController.scrollTo(
    index: _quizpagenumber,
    duration: Duration(seconds: 1),
    curve: Curves.easeInOutCubic);
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
          'sname$i=${quizAnsList[i].slot}&svalue$i=${quizAnsList[i].slotValue}&seqname$i=${quizAnsList[i].sequencecheck}&seqvalue$i=${quizAnsList[i].sequencecheckValue}&ansname$i=${quizAnsList[i].answer}&ansvalue$i=${quizAnsList[i].ansValue}&';
    }
    parameter += 'numofq=${quizAnsList.length}';
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
    }).then((value) {
    print('completed with value $value');
  }, onError: (error) {
    print('completed with error $error');
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
    }).then((value) {
    print('getQuizResult completed with value $value');
  }, onError: (error) {
    print('getQuizResult completed with error $error');
  });
  }

  setModuleCompleteStatus() async {
    var setCompleteUrl = '$urlLink/$token/module/complete/${module.id}/';
    await http.get(setCompleteUrl).then((status) {
      var data = json.decode(status.body);
      if (data['status'] == true) {
        Navigator.of(context).pop();
      }
    }).then((value) {
    print('setModuleCompleteStatus completed with value $value');
  }, onError: (error) {
    print('setModuleCompleteStatus completed with error $error');
  });
  }

  finishAttempt() {
    setState(() {
      _check_unfinish_quiz=false;
      _unanswered_quizlist.clear();
    });
    for (var x = 0; x < quizList.length; x++) {
          setState(() {
            quizList[x].checkunanswer = false;
          });
      for (var y = 0; y < quizList[x].answers.length; y++) {
        if(quizList[x].answers[y] == true) {
          setState(() {
            _check_unfinish_quiz=true;
            quizList[x].checkunanswer = true;
            _unanswered_quizlist.add(x);
          });
        }
      }
    }
    if(_unanswered_quizlist.length==quizList.length){
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
    else if(_unanswered_quizlist.length!=quizList.length){ 
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
    return GestureDetector(
      onTap: (){
        countertimer();
      },
    child:Scaffold(
      backgroundColor: mBlue,
      appBar: AppBar(
        backgroundColor: _loading==false
        ?Colors.white
        :mBlue,
        iconTheme: IconThemeData(
            color: _loading==false
            ?Colors.black
            :Colors.white, //change your color here
          ),
        title: Text(
          module.name,
          style: TextStyle(color: Colors.amber),
        ),
        actions: <Widget>[
          Container(
            height: 5,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              border: Border.all(
                width: 1.5,
                color: Colors.white,
              ),
            ),
            child:Row(
              children:[
                Container(
                  child:Text('Timer: ',
                    style: TextStyle(color:mBlue,fontWeight: FontWeight.bold,fontSize: 18),
                  ),
                ),
                Container(
                  child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return Text(
                          timerString,
                          style: TextStyle(color:mBlue,fontWeight: FontWeight.bold,fontSize: 18),
                        );
                      }),
                ),
              ]
            ), 
          ),
        ],
        elevation: 0.0,
      ),
      body: _loading == true
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : Container(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            height: 80,
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    bottomLeft: const Radius.circular(20.0),
                                    bottomRight: const Radius.circular(20.0))), 
                            child: ScrollablePositionedList.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: quizList.length,
                              itemPositionsListener: itemPositionListener,
                              itemScrollController: itemScrollController,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: <Widget>[
                                    Container(
                                      width: 50,
                                      height: 50,
                                      margin: const EdgeInsets.only(left:15,right:15),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _quizpagenumber == index
                                            ?mBlue
                                            :Colors.white),
                                      child: FlatButton(
                                        onPressed: (){
                                          countertimer();
                                          setState(() {
                                            _quizpagenumber=index;
                                          });
                                        },
                                        child: Center(
                                          child: _quizpagenumber == index
                                            ?Text((index+1).toString(), style: TextStyle(color: Colors.white))
                                            :Text((index+1).toString()),
                                        ),
                                      )
                                    ),
                                    quizList[index].checkunanswer == false
                                    ?Positioned(
                                      right: 0,
                                      top: 0,
                                      child: new Container(
                                        margin: const EdgeInsets.only(left:15,right:15),
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child:Icon(Icons.error,color: Colors.red,),
                                      ),
                                    )
                                    :Container(),
                                  ],
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      return Card(
                        color: Colors.white,
                        elevation: 3.6,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                                        quizList[_quizpagenumber].qzQuestion,
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
                                    itemCount: quizList[_quizpagenumber].qzChoices.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: quizList[_quizpagenumber].answers[index]
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
                                              countertimer();
                                              ansSelected(
                                                _quizpagenumber,
                                                index,
                                                quizList[_quizpagenumber].qzType,
                                                quizList[_quizpagenumber].qzChoices[index],
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
                                                  quizList[_quizpagenumber].answers[index]
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
                                                    quizList[_quizpagenumber]
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
                    }, childCount: 1),
                  ),
                  _quizpagenumber == quizList.length-1
                  ? SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        quizList.length == 1
                        ?Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          child:FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: _processing ? Colors.white60 : Colors.amber,
                            onPressed: () {
                              if (_processing == false && _finished == false) {
                                finishAttempt();
                              } else {
                                countertimer();
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowQuizResult(quizResult:quizResults),
                                  ),
                                );
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
                          )
                        )
                        :Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.0),
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: _processing ? Colors.white60 : Colors.amber,
                                onPressed: () {
                                  countertimer();
                                  previousQuiz();
                                },
                                child: Text(
                                        'Previous',
                                        style: TextStyle(fontSize: 18.0),
                                      )
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.0),
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: _processing ? Colors.white60 : Colors.amber,
                                onPressed: () {
                                  if (_processing == false && _finished == false) {
                                    countertimer();
                                    finishAttempt();
                                  } else {
                                    countertimer();
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ShowQuizResult(quizResult:quizResults),
                                        ),
                                      );
                                    // showQuizResult(context, quizResults);
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
                            ),
                          ]
                        )
                      ],
                    ),
                  )
                  :SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _quizpagenumber == 0
                            ?Container()
                            :Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.0),
                              child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: _processing ? Colors.white60 : Colors.amber,
                              onPressed: () {
                                countertimer();
                                previousQuiz();
                              },
                              child: Text(
                                      'Previous',
                                      style: TextStyle(fontSize: 18.0),
                                    )
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.0),
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                color: _processing ? Colors.white60 : Colors.amber,
                                onPressed: () {
                                  countertimer();
                                  nextQuiz();
                                },
                                child: Text(
                                        'Next',
                                        style: TextStyle(fontSize: 18.0),
                                      )
                              ),
                            ),
                          ]
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}