import 'package:flutter/material.dart';

class OverviewLoading extends StatefulWidget {
  @override
  _OverviewLoadingState createState() => _OverviewLoadingState();
}

class _OverviewLoadingState extends State<OverviewLoading>
    with SingleTickerProviderStateMixin {
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
    return Stack(
      children: [
        Container(
          height: 175.0,
          margin: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xFFF5F5F5),
          ),
          width: 250.0,
        ),
        Container(
          height: 175.0,
          margin: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              begin: Alignment(gradientPosition.value, 0),
              end: Alignment(-1, 0),
              colors: [
                Color.fromRGBO(0, 0, 0, 0.05),
                Color.fromRGBO(0, 0, 0, 0.2),
                Color.fromRGBO(0, 0, 0, 0.05)
              ],
            ),
          ),
          width: 250.0,
        ),
      ],
    );
  }
}

class RecentLoading extends StatefulWidget {
  @override
  _RecentLoadingState createState() => _RecentLoadingState();
}

class _RecentLoadingState extends State<RecentLoading>
    with SingleTickerProviderStateMixin {
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
    return Stack(
      children: [
        Container(
          height: 250.0,
          margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xFFFFB75B),
          ),
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: 250.0,
          margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              begin: Alignment(gradientPosition.value, 0),
              end: Alignment(-1, 0),
              colors: [
                Color.fromRGBO(0, 0, 0, 0.05),
                Color.fromRGBO(0, 0, 0, 0.2),
                Color.fromRGBO(0, 0, 0, 0.05)
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}

class EventLoading extends StatefulWidget {
  @override
  _EventLoadingState createState() => _EventLoadingState();
}

class _EventLoadingState extends State<EventLoading>
    with SingleTickerProviderStateMixin {
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
    return Row(
      children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              begin: Alignment(gradientPosition.value, 0),
              end: Alignment(-1, 0),
              colors: [
                Color.fromRGBO(0, 0, 0, 0.05),
                Color.fromRGBO(0, 0, 0, 0.1),
                Color.fromRGBO(0, 0, 0, 0.05)
              ],
            ),
            color: Color(0xFFFFFFFF),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 24.0,
              ),
              width: 200.0,
              height: 15.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                gradient: LinearGradient(
                  begin: Alignment(gradientPosition.value, 0),
                  end: Alignment(-1, 0),
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.05),
                    Color.fromRGBO(0, 0, 0, 0.1),
                    Color.fromRGBO(0, 0, 0, 0.05)
                  ],
                ),
                color: Color(0xFFFFFFFF),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 24.0,
                top: 8.0,
              ),
              width: 150.0,
              height: 15.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                gradient: LinearGradient(
                  begin: Alignment(gradientPosition.value, 0),
                  end: Alignment(-1, 0),
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.05),
                    Color.fromRGBO(0, 0, 0, 0.1),
                    Color.fromRGBO(0, 0, 0, 0.05)
                  ],
                ),
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
