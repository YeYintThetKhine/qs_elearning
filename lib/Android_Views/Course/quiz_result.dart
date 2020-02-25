import 'package:flutter/material.dart';
import 'package:moodle_test/Model/model.dart';
import '../../ThemeColors/colors.dart';

import 'package:flutter/cupertino.dart';
import '../../Model/model.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';

class ShowQuizResult extends StatefulWidget {

  List<QuizResult> quizResult;

  ShowQuizResult({this.quizResult});
  @override
  _ShowQuizResultState createState() =>
    _ShowQuizResultState(quizResult: quizResult);
}

class _ShowQuizResultState extends State<ShowQuizResult> {
  List<QuizResult> quizResult;

  _ShowQuizResultState({this.quizResult});

  bool _showhide = false;

  _closeresultlistDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Row(
            children: <Widget>[
              Icon(
                Icons.info,
                color: mBlue,
                size: 36.0,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Are you sure you want to exit from the quiz result page?',
                    style: TextStyle(height: 1.25),
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: TextStyle(color: mBlue),
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
            )
          ],
        );
      },
    );
  }

  //method that allows to show and hide the quiz answers
  showhideQuizAnswer(){
    setState(() {
      _showhide = !_showhide;
    });
  }


  countertimer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  @override
  void initState() {
    super.initState();
    countertimer();
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
          backgroundColor: mBlue,
          iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
          title: Text('Quiz Result'),
          leading: new IconButton(
             icon: new Icon(Icons.arrow_back),
            onPressed: () => _closeresultlistDialog(),
          ),
          elevation: 0.0,
        ),
        body: Container(
          color: mBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
                child:FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.amber,
                  onPressed: () {
                    countertimer();
                    showhideQuizAnswer();
                  },
                  child: 
                  _showhide == false
                    ?Text(
                      'Show Answers',
                      style: TextStyle(fontSize: 18.0),
                    )
                    :Text(
                      'Hide Answers',
                      style: TextStyle(fontSize: 18.0),
                    ),
                )
              ),
              Container(
                height:  MediaQuery.of(context).size.height-171,
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    physics: quizResult.length > 1
                        ? ClampingScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    itemCount: quizResult.length,
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.only(left:10.0, right:10.0, bottom:15.0),
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              'Question ${i + 1}'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: quizResult[i].status == 'Your answer is correct.'
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20.0,
                                      )
                                    : Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 20.0,
                                      ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.symmetric(vertical: 12.0),
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text(
                                  quizResult[i].status.toUpperCase(),
                                  style:
                                      quizResult[i].status == 'Your answer is correct.'
                                          ? TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)
                                          : TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Q : ' + quizResult[i].question,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text('Your choice is: '),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    quizResult[i].choseAnswer.replaceAll('__', ''),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _showhide==false
                          ?Container()
                          :Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(quizResult[i].correctAnswer),
                          ),
                        ],
                      )
                      );
                    },
                  ),
                ), 
              ),
            ],
          ),
        )
        // actions: <Widget>[
        //   FlatButton(
        //     child: Text('Cancel'),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   )
        // ],
    ),
      );
  }
}