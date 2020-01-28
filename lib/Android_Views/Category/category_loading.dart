import 'package:flutter/material.dart';

class CategoryLoading extends StatefulWidget {
  createState() => CategoryLoadingState();
}

class CategoryLoadingState extends State<CategoryLoading>
    with SingleTickerProviderStateMixin {
  double height = 225 / 2;
  double width = 250;
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Container(
            height: 25.0,
            width: 125.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: LinearGradient(
                begin: Alignment(gradientPosition.value, 0),
                end: Alignment(-1, 0),
                colors: [Colors.white12, Colors.white24, Colors.white12],
              ),
            ),
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 0.0),
          width: 250.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Color(0xFFF5F5F5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(gradientPosition.value, 0),
                    end: Alignment(-1, 0),
                    colors: [Colors.black12, Colors.black26, Colors.black12],
                  ),
                ),
              ),
              Container(
                height: 25.0,
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                    begin: Alignment(gradientPosition.value, 0),
                    end: Alignment(-1, 0),
                    colors: [Colors.black12, Colors.black26, Colors.black12],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
