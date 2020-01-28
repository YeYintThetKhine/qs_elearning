import 'package:flutter/material.dart';
import '../../ThemeColors/colors.dart';
import '../../Clipper/clips.dart';
import 'package:http/http.dart' as http;
import '../URL/url.dart';

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
    if (_regFormKey.currentState.validate()) {
      var email = _emailController.text;
      var username = _usernameController.text;
      var firstName = _nameController.text;
      var lastName = _nameController.text;
      var password = _passwordController.text;
      var pos = _positionController.text;

      var type = department;  

      var branch = branchlist;  
      //api.add_resource(UserEmailSignUp, '/register/<email>/<username>/<firstname>/<lastname>'
                                  // '/<password>/<pos>/<dept>/<type>/<branch>/')
      var url =
          "$urlLink/register/$email/$username/$firstName/$lastName/$password/$pos/$dept/$type/$branch/";
      await http.get(url).then((data) {
        setState(() {
          _loading = false;
          Navigator.of(context).pop();
        });
      });
    } else {
      setState(() {     
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _regFormKey,
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            height: 160,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(
                    height: 125,
                    color: mBlue,
                  ),
                  clipper: CustomClip(),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  //input for Email here
                  TextFormField(
                    controller: _emailController,
                    validator: (data) =>
                        _emailController.text.length == 0 ? 'Required' : null,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText: 'Email is required for verification',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mBlue, width: 2.0))),
                  ),

                  //input for Username here
                  TextFormField(
                    controller: _usernameController,
                    validator: (data) => _usernameController.text.length == 0
                        ? 'Required'
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText: 'This is what you will use to log in',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mBlue, width: 2.0))),
                  ),

                  //input for Name here
                  TextFormField(
                    controller: _nameController,
                    validator: (data) =>
                        _nameController.text.length == 0 ? 'Required' : null,
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText:
                            'This name that will identify you in your courses\nCANNOT BE CHANGED LATER',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mBlue, width: 2.0))),
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
                        alignLabelWithHint: true,
                        labelStyle: _labelStyle,
                        helperText:
                            'Password must contain at least 1 special character, 1 capital letter and 1 number.',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mBlue, width: 2.0))),
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
              padding: EdgeInsets.only(bottom: 2.0))
        ],
      )),
    );
  }
}
