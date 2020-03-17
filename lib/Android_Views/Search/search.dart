import 'package:flutter/material.dart';
import '../../Model/model.dart';
import '../../ThemeColors/colors.dart';
import '../Dashboard/drawer.dart';
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';
import '../../Model/user.dart';
import '../Category/course_view.dart';


class Search extends StatefulWidget {
  final List<Course> courselist;
  Search({@required this.courselist});
  @override
  SearchState createState() => SearchState(courselist: courselist);
}

class SearchState extends State<Search> with TickerProviderStateMixin {
  final _listKey = GlobalKey<AnimatedListState>();
  AnimationController controller;
  Animation<Offset> offset;
  Animation<Offset> searchoffset;
  List<Course> displaylist = List();
  String keyword;
  TextEditingController keywordController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 560));
    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
        .animate(controller);
    searchoffset = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(controller);
    controller.forward();
    displaylist = courselist;
    AutoLogoutMethod.autologout.counterstartpage(context);
    super.initState();
  }

  final List<Course> courselist;
  SearchState({@required this.courselist}){
    keywordController.addListener((){
      if(keywordController.text.isEmpty){
        setState(() {
          keyword = "";
        displaylist = courselist;
        });
      }
      else{
        setState(() {
          keyword = keywordController.text;
          var temp = List<Course>();
          for(var course in courselist){
            if(course.courseName.toLowerCase().contains(keyword.toLowerCase())){
              temp.add(course);
            }
          }
            displaylist = temp;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
      key: _scaffoldKey,
      drawer: drawer(currentUser, context),
      body: _stackedLayer(),
    ),
    );
  }

  Widget _stackedLayer() {
    return Container(
      child: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            _blueCover(),
            _buildList(),
          ],
        ),
        _searchBox()
      ]),
    );
  }

  Widget _blueCover() {
    return Container(
      decoration: BoxDecoration(
        color: mBlue,
      ),
      height:  MediaQuery.of(context).size.height / 10,
    );
  }

  Widget _searchBox() {
    return SlideTransition(
      position: searchoffset,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 14),
        alignment: Alignment.topCenter,
        child: Container(
          height: 56,
          width: MediaQuery.of(context).size.width / 1.08,
          decoration: BoxDecoration(
              color: mWhite,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.4),
                    offset: Offset(0, 0),
                    blurRadius: 10,
                    spreadRadius: 1)
              ]),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: Icon(Icons.sort),
                    color: mBlue,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 20),
                  child: TextField(
                    controller: keywordController,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 18),
                        border: InputBorder.none,
                        hintText: 'Search'),
                    onChanged: (value) {
                      setState(() {
                        keyword = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.search,
                  color: mBlue,
                  size: 26,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Expanded(
      child: SlideTransition(
          position: offset,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 46, bottom: 6),
            itemBuilder: (context, index) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(30),bottomRight: Radius.circular(20))),
                  elevation: 4,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: InkWell(
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(30),bottomRight:Radius.circular(20)),
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                CourseEnroll(course: displaylist.elementAt(index)),
          ));
                    },
                    child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: Icon(Icons.book,size: 22,color: mYellow,)),
                      Expanded(
                        flex: 4,
                        child: Text(displaylist.elementAt(index).courseName,style: TextStyle(letterSpacing: 1),),
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                // images/wallpaper-1.png
                                image:
                                    displaylist.elementAt(index).courseImgURL ==
                                                null ||
                                            displaylist
                                                    .elementAt(index)
                                                    .courseImgURL ==
                                                ""
                                        ? DecorationImage(
                                            image: AssetImage(
                                                'images/wallpaper-1.png'),
                                            fit: BoxFit.cover)
                                        : DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(displaylist
                                                .elementAt(index)
                                                .courseImgURL)),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20))),
                          ))
                    ],
                  ),
                  ));
            },
            itemCount: displaylist.length,
          )),
    );
  }
}
