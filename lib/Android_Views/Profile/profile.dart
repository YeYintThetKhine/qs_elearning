import 'package:flutter/material.dart';
import '../../ThemeColors/colors.dart';
import '../../Clipper/clips.dart';
// import 'package:flutter/services.dart';

class Profile extends StatelessWidget {
  Widget build(BuildContext context) {
    return ProfileX();
  }
}

class ProfileX extends StatefulWidget {
  @override
  _ProfileXState createState() => _ProfileXState();
}

class _ProfileXState extends State<ProfileX> {
  String _infoName;
  String _infoPosition;
  String _infoDepartment;

  @override
  void initState() {
    _infoName = "Sample Name";
    _infoPosition = "Sample Position";
    _infoDepartment = "Sample Department";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          backgroundColor: mBlue,
          title: Text('Profile', style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            indicatorColor: mWhite,
            tabs: [
              Tab(icon:Icon(Icons.check_box,
              color: Colors.white,
              )
              ),
              Tab(icon:Icon(Icons.person,
              color: Colors.white,
              )
              ),
              Tab(icon:Icon(Icons.format_list_bulleted,
              color: Colors.white,
              )
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Text('Harro 1'),
            _profileScreen(context),
            Text('Harro 3')
          ],
        )
      ),
    );
  }

  Widget _profileScreen(BuildContext context){
    return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: mWhite,
                height: 140,
                child: Stack(
                  children: <Widget>[
                    _decoArc(),
                    _profilePic(),
                  ],
                ),
              ),
              //Main contents
              _identity(),
              _currentLearning(context),
             
            ],
          ),
        );
  }

  Widget _decoArc() {
    return ClipPath(
      child: Container(
        color: mBlue,
        height: 125,
      ),
      clipper: CustomClip(),
    );
  }

  Widget _currentLearning(BuildContext context) {
    return Container(
      height: 400.0,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                width: 0.1,
              ),
              bottom: BorderSide(
                width: 0.1,
              ))),
      child: GridView.count(

          padding:
              EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
          childAspectRatio: (MediaQuery.of(context).size.width * 12) /
              (MediaQuery.of(context).size.height * 8),
          shrinkWrap: true,
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.only(left:8.0),
            //   child:_gridCard('Harro'),
            // ),
            // _gridCard('Harro'),
            // _gridCard('Harro'),
            // _gridCard('Harro'),
            // _gridCard('Harro'),
            // _gridCard('Harro'),
            // _gridCard('Harro'),
            // _gridCard('Harro'),
            // _gridCard('Harro'),
            // // Padding(
            //   padding:EdgeInsets.only(right:8.0),
            //   child:_gridCard('Harro'),
            // )
            _gridCard('Hello aksdfjlk lkasdjflkas lsadfjla lasdfjkla ',
                'images/searchbg.jpg', 0),
            _gridCard('Hello', 'images/searchbg.jpg', 0),
            _gridCard('Hello', 'images/searchbg.jpg', 0),
            _gridCard('Hello', 'images/searchbg.jpg', 0),
          ]),
    );
  }

  Widget _gridCard(String text, String imgUrl, int percent) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Material(
        shadowColor: mBlue,
        elevation: 3.0,
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0)),
                  image: DecorationImage(
                      image: AssetImage(imgUrl), fit: BoxFit.cover)),
            ),
            Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 5.0, left: 8.0),
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(text,
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold)))),
                Container(
                  padding: EdgeInsets.only(top: 10.0, right: 2.0),
                  alignment: Alignment.centerRight,
                  child: Text('$percent%', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _identity() {
    return Container(
        padding: EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(_infoName,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Text(_infoPosition),
            ),
            Text(_infoDepartment)
          ],
        ));
  }

  Widget _profilePic() {
    return Container(
      padding: EdgeInsets.only(top: 12.0),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mWhite,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 110,
            height: 110,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('images/searchbg.jpg'),
                  fit: BoxFit.cover,
                )),
          )
        ],
      ),
    );
  }
}
