import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../Model/model.dart';

class ModuleVideo extends StatefulWidget {
  final token;
  final module;
  ModuleVideo({this.module, this.token});
  @override
  _ModuleVideoState createState() =>
      _ModuleVideoState(module: module, token: token);
}

class _ModuleVideoState extends State<ModuleVideo> {
  Module module;
  String token;
  _ModuleVideoState({this.module, this.token});
  VideoPlayerController _controller;
  var loading = true;
  Icon toggleIcon = Icon(Icons.play_arrow);
  var _opacity = 0.0;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    super.initState();
    _controller = VideoPlayerController.network(module.url + '&token=$token')
      ..initialize().then((_) {
        setState(() {
          loading = true;
        });
      });
  }

  @override
  dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF383838),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return SizedBox.expand(
              child: _controller.value.initialized
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _opacity = _opacity == 0.0 ? 1.0 : 0.0;
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          children: [
                            VideoPlayer(_controller),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 250),
                                    opacity: _opacity,
                                    child: _opacity == 1.0
                                        ? VideoProgressIndicator(
                                            _controller,
                                            colors: VideoProgressColors(
                                                playedColor: Colors.amber),
                                            allowScrubbing: true,
                                          )
                                        : Container()),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 250),
                                    opacity: _opacity,
                                    child: _opacity == 1.0
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_controller
                                                    .value.isPlaying) {
                                                  toggleIcon =
                                                      Icon(Icons.play_arrow);
                                                  _controller.pause();
                                                } else {
                                                  toggleIcon =
                                                      Icon(Icons.pause);
                                                  _controller.play();
                                                }
                                              });
                                            },
                                            color: Colors.white,
                                            icon: toggleIcon,
                                            iconSize: 48.0,
                                          )
                                        : Container()),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 250),
                                    opacity: _opacity,
                                    child: _opacity == 1.0
                                        ? IconButton(
                                            onPressed: () {
                                              setState(
                                                () {
                                                  SystemChrome
                                                      .setPreferredOrientations([
                                                    DeviceOrientation
                                                        .portraitUp,
                                                  ]);
                                                },
                                              );
                                            },
                                            color: Colors.white,
                                            icon: Icon(Icons.fullscreen_exit),
                                            iconSize: 24.0,
                                          )
                                        : Container()),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 250),
                                    opacity: _opacity,
                                    child: _opacity == 1.0
                                        ? IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            color: Colors.white,
                                            icon: Icon(Icons.chevron_left),
                                            iconSize: 24.0,
                                          )
                                        : Container()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.amber),
                      ),
                    ),
            );
          } else {
            return Center(
              child: _controller.value.initialized
                  ? Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            child: AnimatedOpacity(
                                duration: Duration(milliseconds: 250),
                                opacity: _opacity,
                                child: _opacity == 1.0
                                    ? IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.white,
                                        icon: Icon(Icons.chevron_left),
                                        iconSize: 24.0,
                                      )
                                    : Container()),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _opacity = _opacity == 0.0 ? 1.0 : 0.0;
                              });
                            },
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Stack(
                                children: [
                                  VideoPlayer(_controller),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: AnimatedContainer(
                                      padding: EdgeInsets.all(8.0),
                                      duration: Duration(milliseconds: 250),
                                      child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 250),
                                          opacity: _opacity,
                                          child: _opacity == 1.0
                                              ? Text(
                                                  _controller.value.duration
                                                      .toString()
                                                      .substring(
                                                        0,
                                                        _controller
                                                            .value.duration
                                                            .toString()
                                                            .indexOf('.'),
                                                      ),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : Container()),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 250),
                                      child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 250),
                                          opacity: _opacity,
                                          child: _opacity == 1.0
                                              ? VideoProgressIndicator(
                                                  _controller,
                                                  colors: VideoProgressColors(
                                                      playedColor:
                                                          Colors.amber),
                                                  allowScrubbing: true,
                                                )
                                              : Container()),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 250),
                                      child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 250),
                                          opacity: _opacity,
                                          child: _opacity == 1.0
                                              ? IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_controller
                                                          .value.isPlaying) {
                                                        toggleIcon = Icon(
                                                            Icons.play_arrow);
                                                        _controller.pause();
                                                      } else {
                                                        toggleIcon =
                                                            Icon(Icons.pause);
                                                        _controller.play();
                                                      }
                                                    });
                                                  },
                                                  color: Colors.white,
                                                  icon: toggleIcon,
                                                  iconSize: 48.0,
                                                )
                                              : Container()),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 250),
                                      child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 250),
                                          opacity: _opacity,
                                          child: _opacity == 1.0
                                              ? IconButton(
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        SystemChrome
                                                            .setPreferredOrientations([
                                                          DeviceOrientation
                                                              .landscapeLeft,
                                                          DeviceOrientation
                                                              .landscapeRight,
                                                        ]);
                                                      },
                                                    );
                                                  },
                                                  color: Colors.white,
                                                  icon: Icon(Icons.fullscreen),
                                                  iconSize: 24.0,
                                                )
                                              : Container()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.amber),
                      ),
                    ),
            );
          }
        },
      ),
    );
  }
}
