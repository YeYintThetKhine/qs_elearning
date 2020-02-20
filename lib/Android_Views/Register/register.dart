import 'package:flutter/material.dart';
import '../../ThemeColors/colors.dart';
import 'package:http/http.dart' as http;
import '../URL/url.dart';
import 'dart:convert';
import '../../Model/model.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('REGISTER'),
        ),
        body: Registry());
  }
}

class Registry extends StatefulWidget {
  
  @override
  _RegistryState createState() => _RegistryState();
}

class _RegistryState extends State<Registry> {

  var errorResponse;
  String errorType;
  String errorMessage;

  static const List<String> deparments = [
    'CB Insurance',
    'CB Bank',
    'CB Securities',
  ];
  static const List<String> deptlist = [
    "Actuarial & Product",
    "Admin",
    "Agency",
    "Bancassurance",
    "Audit",
    "Claim",
    "Finance",
    "IT & Graphic",
    "Underwriting",
    "HR",
    "Other"
  ];

  static const List<String> branchlist = [
    "Yangon",
    "Mandalay",
    "Naypyidaw",
    "Bago Division",
    "Ayeyarwaddy Division",
    "Magwe Division",
    "Sagaing Division",
    "Thaninthayi Division",
    "Mon State",
    "Kayin State",
    "Rakhine State",
    "Kayah State",
    "Shan State",
    "Chin State",
    "Kachin State",
    "Other"
  ];

  String dept = deptlist[0];
  String department = deparments[0];
  String branch = branchlist[0];
  TextStyle _labelStyle = TextStyle(
    color: const Color(0xFF302B7E),
  );
  bool _loading = false;

  GlobalKey<FormState> _regFormKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();
  TextEditingController _positionController = TextEditingController();

  _signUp() async {
    setState(() {
      _loading = true;
    });
    try {
      if (_regFormKey.currentState.validate()){
        setState(() {
          errorType="";
        });
        var email = _emailController.text;
        var username = _usernameController.text;
        var firstName = _nameController.text
            .substring(0, _nameController.text.lastIndexOf(' '));
        var lastName = _nameController.text
            .substring(_nameController.text.lastIndexOf(' '))
            .trim();
        var password = _passwordController.text;
        var pos = _positionController.text;

        var type = department;  

        var branch = branchlist[0];  
        //api.add_resource(UserEmailSignUp, '/register/<email>/<username>/<firstname>/<lastname>'
                                    // '/<password>/<pos>/<dept>/<type>/<branch>/')
        var url =
            "$urlLink/register/$email/$username/$firstName/$lastName/$password/$pos/$dept/$type/$branch/";
        print(url);
        await http.get(url).then((data) {
          errorResponse=json.decode(data.body);

          print(errorResponse);
          if(errorResponse['success'] == false){
            setState(() {
              errorType=errorResponse['warnings'][0]['item'];
              errorMessage=errorResponse['warnings'][0]['message'];
            });
          }
          else if(errorResponse['success'] == true){
            setState(() {
              _loading = false;
            });
            AlertDialog alert = AlertDialog(
              title: Text("Successful"),
              content: Text("Account successfully created"),
              actions: [
                FlatButton(onPressed: ()
                  {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }, 
                  child: Text('Finish'))
              ],
            );

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          }
        }).then((value) {
      print('completed with value $value');
    }, onError: (error) {
      print('completed with error $error');
        setState(() {     
          _loading = false;
        });
    });
      } else {
        setState(() {     
          _loading = false;
        });
      }
    } on RangeError {
      setState(() {
        errorType="fullname";
        errorMessage="Please put space between your name. Example:John Doe";
      });
      print('Exception occurs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _regFormKey,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          // Container(
          //   height: 30,
          //   child: Stack(
          //     children: <Widget>[
          //       ClipPath(
          //         child: Container(
          //           height: 125,
          //           color: mBlue,
          //         ),
          //         clipper: CustomClip(),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  //input for Email here
                  TextFormField(
                    controller: _emailController,
                    validator: (data) =>_emailController.text.length == 0 
                      ? 'Required'
                          : null,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: errorType=='email'?Colors.red:Colors.grey),   
                        ),  
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText: errorType=='email'?
                        '$errorMessage'
                        :'Email is required for verification',
                        helperStyle: TextStyle(color: errorType=='email'?Colors.red:Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: errorType=='email'?Colors.red:mBlue, width: 2.0))),
                  ),

                  //input for Username here
                  TextFormField(
                    controller: _usernameController,
                    validator: (data) => _usernameController.text.length == 0
                        ? 'Required'
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: errorType=='username'?Colors.red:Colors.grey),   
                        ),  
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText: errorType=='username'?
                        '$errorMessage' 
                        :'This is what you will use to log in',
                        helperStyle: TextStyle(color: errorType=='username'?Colors.red:Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: errorType=='username'?Colors.red:mBlue, width: 2.0))),
                  ),

                  //input for Name here
                  TextFormField(
                    controller: _nameController,
                    validator: (data) =>
                        _nameController.text.length == 0 ? 'Required' : null,
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: errorType=='fullname'?Colors.red:Colors.grey),   
                        ), 
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText:errorType=='fullname'
                        ?'$errorMessage'
                        :'This name that will identify you in your courses\nCANNOT BE CHANGED LATER',
                        helperStyle: TextStyle(color: errorType=='fullname'?Colors.red:Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: errorType=='fullname'?Colors.red:mBlue, width: 2.0))),
                  ),

                  //input for Password here
                  TextFormField(
                    controller: _passwordController,
                    validator: (data) => _passwordController.text.length == 0
                        ? 'Required'
                        : null,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: UnderlineInputBorder(      
                        borderSide: BorderSide(color: errorType=='password'?Colors.red:Colors.grey),   
                        ),  
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText:errorType=='password'?
                        '$errorMessage'
                        :'Password must be 8 characters long.',
                        helperStyle: TextStyle(color: errorType=='password'?Colors.red:Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: errorType=='password'?Colors.red:mBlue, width: 2.0))),
                  ),

                  //input for Password again for confirmation
                  TextFormField(
                    controller: _repasswordController,
                    validator: (data) => _repasswordController.text.length == 0
                        ? 'Required'
                        : _passwordController.text != _repasswordController.text
                            ? 'Password does not match'
                            : null,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText: 'Type your password again to confirm',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mBlue, width: 2.0))),
                  ),

                  //input for Position here
                  TextFormField(
                    controller: _positionController,
                    validator: (data) => _positionController.text.length == 0
                        ? 'Required'
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Position',
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText: 'This is your position at work',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mBlue, width: 2.0))),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: DropdownButtonFormField(
                        // isExpanded: true
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Department',
                            helperText: 'This is your department at work',
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 8.0)),
                        items: deptlist.map((item) {
                          return new DropdownMenuItem<String>(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dept = value;
                          });
                        },
                        value: dept,
                      )),
                  //User will choose department here
                  Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: DropdownButtonFormField(
                        // isExpanded: true
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Type',
                            helperText: 'Choose the type of training',
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 8.0)),
                        items: deparments.map((item) {
                          return new DropdownMenuItem<String>(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            department = value;
                          });
                        },
                        value: department,
                      )),
                  Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: DropdownButtonFormField(
                        // isExpanded: true
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Branch',
                            helperText: 'This is your branch of work',
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 8.0)),
                        items: branchlist.map((item) {
                          return new DropdownMenuItem<String>(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            branch = value;
                          });
                        },
                        value: branch,
                      )),
                ],
              )),
          Padding(
              child: IgnorePointer(
                ignoring: _loading == false?false:true, 
                  child: Container(
                      margin: EdgeInsets.all(8.0),
                      height: 50,
                      width: 150,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 3.0,
                        color: mBlue,
                        child: _loading == false
                            ? Text('REGISTER', style: TextStyle(color: mWhite))
                            : CircularProgressIndicator(
                                strokeWidth: 1.5,
                              ),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          _signUp();
                        },
                      )),
              ),
              padding: EdgeInsets.only(bottom: 2.0))
        ],
      )),
    );
  }
}
