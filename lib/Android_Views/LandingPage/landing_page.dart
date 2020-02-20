import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:moodle_test/ThemeColors/colors.dart';
import '../Register/register.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/model.dart';
import '../URL/url.dart';
import '../../Model/user.dart';
import 'package:moodle_test/Android_Views/Category/category_list.dart';
import 'package:moodle_test/DB/db.dart';
import 'package:connectivity/connectivity.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _signupKey = GlobalKey();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _signingIn = false;
  var subscription;

  accCheck() async{
    await PersonDatabaseProvider.db.getAllPersons().then((value) {
      if(value.length != 0){
              token = value[0].token;
              currentUser = User(
                id: value[0].id,
                name: value[0].name,
                username: value[0].username,
                email: value[0].email,
                imgUrl: value[0].imgUrl,
                department: value[0].department,
                position: value[0].position,
                type: value[0].type,
              );  
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => CategoryList()),
                ModalRoute.withName('/DashBoard')); 
      }
      else{

      }
    }).then((value) {
      print('completed with value $value');
      }, onError: (error) {
        print('completed with error $error');
      });
  }

  accLogin() async {
    if (_signupKey.currentState.validate()) {
      setState(() {
        _signingIn = true;
      });
      var username = _username.text;
      var password = _password.text;
      var response;
      var url = '$urlLink/login/$username/$password/';
      try {
        response = await http.get(url).timeout(
              Duration(seconds: 20),
            );
      } on TimeoutException catch (_) {
        _showTimeOutDialog();
        setState(() {
          _signingIn = false;
        });
      } catch (e) {
        _showTimeOutDialog();
        setState(() {
          _signingIn = false;
        });
      }
      if (response == null || response.statusCode != 200) {
        print('Error');
      } else {
        var data = json.decode(response.body);
        if (data['message'] == 'Invalid') {
          final snackBar = SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Color(0xFFFFFFFF),
            content: Text(
              'Invalid username and password!',
              style: TextStyle(
                color: Color(0xFF302B7E),
              ),
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
          setState(() {
            _signingIn = false;
          });
        } else {
          token = data['token'];
          var getUser = '$urlLink/$token/user/$username/';
          await http.get(getUser).then((userDate) {
            var userData = json.decode(userDate.body);
            currentUser = User(
              id: userData[0]['id'].toString(),
              name: userData[0]['fullname'],
              username: userData[0]['username'],
              email: userData[0]['email'],
              imgUrl: userData[0]['profileimageurl'],
              department: userData[0]['department'],
              position: userData[0]['customfields'][0]['value'],
              type: userData[0]['customfields'][1]['value'],
            );
            //store in sqlite db
            PersonDatabaseProvider.db.deleteAllPersons();
            Person acc = Person();
            acc.token = data['token'];
            print(acc.token);
            acc.id = userData[0]['id'].toString();
            acc.name = userData[0]['fullname'];
            acc.username = userData[0]['username'];
            acc.email = userData[0]['email'];
            acc.imgUrl = userData[0]['profileimageurl'];
            acc.department = userData[0]['department'];
            acc.position = userData[0]['customfields'][0]['value'];
            acc.type = userData[0]['customfields'][1]['value'];
            PersonDatabaseProvider.db.addPersonToDatabase(acc);
            PersonDatabaseProvider.db.getAllPersons().then((value) {
            }
            );
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => CategoryList()),
                ModalRoute.withName('/DashBoard'));
          }).then((value) {
    print('completed with value $value');
  }, onError: (error) {
    print('completed with error $error');
    accLogin();
  });
        }
      }
    }
  }
    @override
  void initState() {
    super.initState();


  subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    // Got a new connectivity status!
  });

    accCheck();
  }

  _showTimeOutDialog() {
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
                    'Looks like the server is taking to long to respond, this can be caused by either poor connectivity or an error with our servers.\nPlease try again in a while',
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
              },
              child: Text(
                'Close',
                style: TextStyle(color: mBlue),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _orientationBuild() {
    return OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? _portraitView(context)
            : _landscapeView(context));
  }

  void navigateRegister(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Register()));
  }

  Widget _options(BuildContext context) {
    var dev = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: mBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )),
        padding: EdgeInsets.only(top: 35.0),
        width: dev.width,
        child: Column(
          children: <Widget>[
            Form(
              key: _signupKey,
              child: Column(
                children: [
                  Container(
                    width: 300.0,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white70),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      controller: _username,
                      validator: (data) => _username.text.length == 0
                          ? 'Please enter username'
                          : null,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.white70),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.white70,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 300.0,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white70),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      controller: _password,
                      obscureText: true,
                      validator: (data) => _password.text.length == 0
                          ? 'Please enter password'
                          : null,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30)),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.white70),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.white70,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 300.0,
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    width: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        accLogin();
                      },
                      child: Center(
                        child: _signingIn == false
                            ? Text(
                                "Login".toUpperCase(),
                              )
                            : Container(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(
                                    Color(0xFF302B7E),
                                  ),
                                ),
                              ),
                      ),
                      color: Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  Container(
                    width: 300.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Do not have a account?',
                          style: TextStyle(
                            color: Color(0xFFF5F5F5),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            navigateRegister(context);
                          },
                          child: Text(
                            "Sign Up".toUpperCase(),
                            style: TextStyle(
                              color: Color(0xFFF5F5F5),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//Portrait
  Widget _portraitView(context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 24.0),
            alignment: Alignment.topCenter,
            height: 250.0,
            child: Stack(
              children: [
                Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: new DecorationImage(
                      image: new AssetImage("images/wallpaper-1.png"),
                      colorFilter: ColorFilter.mode(
                          Color(0xFFFFFFFF).withOpacity(0.75),
                          BlendMode.srcOver),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Container(
                //   alignment: Alignment.center,
                //   child: Image.asset(
                //     'images/insurance.png',
                //     width: 250,
                //     height: 250,
                //   ),
                // )
              ],
            ),
          ),
          _options(context)
        ],
      ),
    );
  }

//Landscape
  Widget _landscapeView(context) {
    return Row(children: <Widget>[
      Image.asset(
        'images/searchbg.jpg',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height,
      ),
      _options(context)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: _orientationBuild(),
    );
  }
}
