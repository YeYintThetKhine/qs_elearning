import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Timer _timer;
  AnimationController _animationController;
  Animation _firstAnimation;
  Animation _secondAnimation;
  Animation _thirdAnimation;
  Animation _fourthOpacity;
  Animation _fourthAnimation;
  Animation _textAnimation;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _firstAnimation = Tween(begin: 0.0, end: 1.0).animate(
      (CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.4, curve: Curves.easeIn),
      )),
    );
    _secondAnimation = Tween(begin: -14.0, end: 14.0).animate(
      (CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 0.5, curve: Curves.easeIn),
      )),
    );
    _thirdAnimation = Tween(begin: -14.0, end: 14.0).animate(
      (CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 0.6, curve: Curves.easeIn),
      )),
    );
    _fourthOpacity = Tween(begin: 0.0, end: 1.0).animate(
      (CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 0.7, curve: Curves.easeIn),
      )),
    );
    _fourthAnimation = Tween(begin: 14.0, end: -14.0).animate(
      (CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 0.7, curve: Curves.easeIn),
      )),
    );
    _textAnimation = Tween(begin: 0.0, end: 1.0).animate(
      (CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.7, 1.0, curve: Curves.easeIn),
      )),
    );
    _animationController.forward();
  }

  _SplashScreenState() {
    _timer = Timer(Duration(seconds: 4), _navigateRoute);
  }
  void _navigateRoute() {
    Navigator.of(context).pushReplacementNamed('/LandingPage');
  }

  Widget _splashContent() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) {
        return Center(
          child: Container(
            child: Transform.translate(
              offset: Offset(_firstAnimation.value * -12.0, 0.0),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _firstAnimation.value,
                child: Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(_fourthAnimation.value, 14.0),
                        child: AnimatedOpacity(
                          opacity: _fourthOpacity.value,
                          duration: Duration(milliseconds: 100),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Color(0xFF339A49),
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            _secondAnimation.value, _thirdAnimation.value),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Color(0xFF2B51A4),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(_secondAnimation.value, -14.0),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Color(0xFFFBE200),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-14.0, -14.0),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Color(0xFFF14924),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(_textAnimation.value * 56.0, 0.0),
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: _textAnimation.value,
                          child: Container(
                            child: Image.asset(
                              'images/insurance.png',
                              alignment: Alignment.bottomCenter,
                              width: 180.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _splashContent());
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
