import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moodle_test/Android_Views/Category/category_loading.dart';
import '../../ThemeColors/colors.dart';
import '../Dashboard/drawer.dart';
import '../../Model/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../URL/url.dart';
import '../../Model/model.dart';
import 'package:html/parser.dart' as html;
import 'package:moodle_test/Android_Views/Category/course_view.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';
import 'package:connectivity/connectivity.dart';
import '../../DrawerTheme/drawerdetect.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Category> _categoryList = [];
  bool _loading = true;

  String eventtype="initial";

  showAlertDialog(String title, String message,index,i,context) {

    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.pop(context);
          _connectionCheck(index,i);
        }, child: Text('Try again'))
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => alertDialog
    );
  }

  _connectionCheck(index,i) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      if(eventtype == "coursedetail"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext
                    context) =>
                CourseEnroll(
                    course:_categoryList[index].courses[i]),
          ),
        );
      }
      else if(eventtype == "drawer"){
        _scaffoldKey.currentState.openDrawer();
      }
    } else if(connectivityResult == ConnectivityResult.mobile && connectivityResult == ConnectivityResult.wifi){
      if(eventtype == "coursedetail"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext
                    context) =>
                CourseEnroll(
                    course:_categoryList[index].courses[i]),
          ),
        );
      }
    } 
    else{
      showAlertDialog('Mobile Connection Lost', 'Please connect to your wifi or turn on mobile data and try again',index,i,context);
    }
  }

  @override
  void initState() {
    super.initState();
    currentPage = 'category_list';
    _getCategory();
    AutoLogoutMethod.autologout.counterstartpage(context);
  }

  // Future<List<Category>> _getCategory() async {
  //   // _connectionCheck(0,0);
  //   setState(() {
  //     _loading = true;
  //   });
  //   _categoryList.clear();
  //   var response;
  //   var url = '$urlLink/$token/category/';
  //   await http.get(url).then((data) async {
  //     print(url);
  //     var categories = json.decode(data.body);
  //     for (var category in categories) {
  //       List courses = category['courses'];
  //       _categoryList.add(
  //         Category(
  //           id: category['id'],
  //           name: category['name'],
  //           desc: category['desc'],
  //           totalCourse: category['courses'].length,
  //           courses: courses,
  //         ),
  //       );
  //     }
  //     print(_categoryList[1].courses[0]['courseCategory']);
  //     setState(() {
  //       _loading = false;
  //     });
  //   }).then((value) {
  //   print('completed with value $value');
  // }, onError: (error) async{
  //   print('completed with error $error');
  //   AutoLogoutMethod.autologout.counter(context);
  // });
  //   return _categoryList;
  // }

  Future<List<Category>> _getCategory() async {
    // _connectionCheck(0,0);
    setState(() {
      _loading = true;
    });
    _categoryList.clear();
    var response;
    var url = '$urlLink/$token/category/';
    await http.get(url).then((data) async {
      var categories = json.decode(data.body);
      for (var category in categories) {
        List<Course> courses = [];
        var catid = category['id'];
        var url = '$urlLink/$token/category/$catid/courses/';
        print(url);
        await http.get(url).then((result) {
          var coursedata = json.decode(result.body);
          if (coursedata['courses'].length == 0) {
            print("empty courses");
          } else {
            for (var course in coursedata['courses']) {
              courses.add(
                Course(
                  id: course['id'],
                  courseName: course['fullname'],
                  courseDesc: course['summary'],
                  courseCategory: course['category'],
                  courseImgURL:
                      course['overviewfiles'][0]['fileurl'] + '?token=$token',
                  favourite: course['isfavourite'],
                  progress: course['progress'] != null
                      ? course['progress'].toDouble()
                      : 0.0,
                ),
              );
            }
          }
        }).then((value) {
          print('completed with value $value');
        }, onError: (error) async{
          print('completed with error $error');
          AutoLogoutMethod.autologout.counter(context);
        });

        _categoryList.add(
          Category(
            id: category['id'],
            name: category['name'],
            desc: category['desc'],
            totalCourse: category['courses'].length,
            courses: courses,
          ),
        );
      }
      setState(() {
        _loading = false;
      });
    }).then((value) {
    print('completed with value $value');
  }, onError: (error) async{
    print('completed with error $error');
    AutoLogoutMethod.autologout.counter(context);
  });
    return _categoryList;
  }

  counter_timer(){
    AutoLogoutMethod.autologout.counter(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: counter_timer,
      child:Scaffold(
      backgroundColor: mBlue,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Categories',
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: (){
            setState(() {
              eventtype="drawer";
            });
            AutoLogoutMethod.autologout.counter(context);
            _connectionCheck(0,0);
          },
          icon: Image.asset(
            'images/menu.png',
            width: 24.0,
            color: mWhite,
          ),
        ),
      ),
      drawer: drawer(currentUser, context),
      body: _loading
          ? RefreshIndicator(
            onRefresh: _getCategory,
            child:ListView.builder(
              itemCount: 3,
              itemBuilder: (context, i) {
                return Container(
                  height: 250.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, i) {
                      return CategoryLoading();
                    },
                  ),
                );
              },
            )
          )
          : RefreshIndicator(
              onRefresh: _getCategory,
              child: Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Container(
                            height: 236.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(right:5),
                                        child: Text(
                                          '${_categoryList[index].name}',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20.0),
                                        ),
                                      ),
                                      _categoryList[index].courses.length==0
                                      ?Container()
                                      :Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            width: 1.5,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        child: Text(
                                          '${_categoryList[index].courses.length}',
                                          style: TextStyle(
                                              color: mBlue, fontSize: 15.0, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (context, i) {
                                      var doc = html.parse(_categoryList[index]
                                          .courses[i]
                                          .courseDesc);
                                      return Container(
                                        width: 250.0,
                                        margin: EdgeInsets.only(
                                            left: 8.0,
                                            top: 8.0,
                                            bottom: 8.0,
                                            right: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 24.0,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.25),
                                              offset: Offset(0.0, 6.0),
                                              spreadRadius: -12.0,
                                            )
                                          ],
                                        ),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          onTap: (){
                                            setState(() {
                                              eventtype="coursedetail";
                                            });
                                            _connectionCheck(index,i);
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (BuildContext
                                            //             context) =>
                                            //         CourseEnroll(
                                            //             course:
                                            //                 _categoryList[index]
                                            //                     .courses[i]),
                                            //   ),
                                            // );
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 225.0 / 2,
                                                width: 250.0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(5.0),
                                                    topRight:
                                                        Radius.circular(5.0),
                                                  ),
                                                  child: Image.network(
                                                    _categoryList[index]
                                                        .courses[i]
                                                        .courseImgURL,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 250.0,
                                                margin: EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 4.0,
                                                  left: 8.0,
                                                ),
                                                child: Text(
                                                  _categoryList[index]
                                                      .courses[i]
                                                      .courseName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: mBlue,
                                                      fontSize: 18.0),
                                                ),
                                              ),
                                              Container(
                                                width: 250.0,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 8.0,
                                                ),
                                                child: Text(
                                                  html
                                                      .parse(doc.body.text)
                                                      .documentElement
                                                      .text,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(color: mBlue),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        _categoryList[index].courses.length,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: _categoryList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    )
    );
  }
}