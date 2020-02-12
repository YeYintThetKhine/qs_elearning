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

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Category> _categoryList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getCategory();
    AutoLogoutMethod.autologout.counterstartpage(context);
  }

  Future<List<Category>> _getCategory() async {
    setState(() {
      _loading = true;
    });
    _categoryList.clear();
    var url = '$urlLink/$token/category/';
    await http.get(url).then((data) async {
      var categories = json.decode(data.body);
      for (var category in categories) {
        List<Course> courses = [];
        var catid = category['id'];
        var url = '$urlLink/$token/category/$catid/courses/';
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
        });
        _categoryList.add(
          Category(
            id: category['id'],
            name: category['name'],
            desc: category['desc'],
            totalCourse: category['courses'],
            courses: courses,
          ),
        );
      }
      setState(() {
        _loading = false;
      });
    }).then((value) {
    print('completed with value $value');
  }, onError: (error) {
    print('completed with error $error');
    AutoLogoutMethod.autologout.counter(context);
    // _getCategory();
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
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
            AutoLogoutMethod.autologout.counter(context);
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
          ? ListView.builder(
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
          : RefreshIndicator(
              onRefresh: _getCategory,
              child: Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Container(
                            height: 225.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    _categoryList[index].name,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
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
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    CourseEnroll(
                                                        course:
                                                            _categoryList[index]
                                                                .courses[i]),
                                              ),
                                            );
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