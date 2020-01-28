import 'package:flutter/material.dart';
import 'package:moodle_test/Model/model.dart';

showQuizResult(BuildContext context, List<QuizResult> quizResult) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Quiz Result'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Container(
          height: 175.0,
          width: MediaQuery.of(context).size.width - 100.0,
          child: ListView.builder(
            physics: quizResult.length > 1
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            itemCount: quizResult.length,
            itemBuilder: (context, i) {
              return Column(
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
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(quizResult[i].correctAnswer),
                  ),
                ],
              );
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
