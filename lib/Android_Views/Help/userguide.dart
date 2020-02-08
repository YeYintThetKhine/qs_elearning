import 'package:flutter/material.dart';
import 'package:moodle_test/ThemeColors/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Userguide extends StatefulWidget {
  @override
  _UserguideState createState() => _UserguideState();
}

class _UserguideState extends State<Userguide> {
  final imageList = ['images/1.png','images/2.png','images/3.png','images/4.png','images/5.png'];
  
  int currentIndex = 0;
  int initialIndex;
  int length;
  int title;

    @override
  void initState() {
    currentIndex = 0;
    initialIndex = 0;
    length = imageList.length;
    title = initialIndex + 1;
    super.initState();
  }

  onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      title = index + 1;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBlue,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('User Guide',style: TextStyle(color:Colors.amber),),
        automaticallyImplyLeading: true,
      ),
      // Implemented with a PageView, simpler than setting it up yourself
      // You can either specify images directly or by using a builder as in this tutorial
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-120,
            margin: EdgeInsets.only(top:20),
            child: PhotoViewGallery.builder(
              pageController: PageController(initialPage: initialIndex),
              onPageChanged: onPageChanged,
              itemCount: imageList.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: AssetImage(
                    imageList[index],
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                color: mWhite,
              ),
              loadingChild: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right:10),
              width: 90,
              height: 45,
              decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white, //                   <--- border color
                width: 1.5,
              ),
              // boxShadow: [
              //   BoxShadow(
              //     blurRadius: 13.0,
              //     color: Colors.black.withOpacity(.3),
              //     offset: Offset(3.0, 3.0),
              //   ),
              // ],
                color: Colors.amber,
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              ),
              child: Center(
                child: title == length
                  ?Text('$title / $length',style:TextStyle(color:mBlue,fontSize: 17,fontWeight: FontWeight.bold))
                  :Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('$title',style:TextStyle(color:mBlue,fontSize: 20,fontWeight: FontWeight.bold)),
                      Text(' / ',style:TextStyle(color:mBlue,fontSize: 17,fontWeight: FontWeight.bold)),
                      Text('$length',style:TextStyle(color:mBlue,fontSize: 17,fontWeight: FontWeight.bold)),
                    ],
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }
}