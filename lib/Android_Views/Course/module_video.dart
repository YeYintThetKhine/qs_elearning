import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../Model/model.dart';
import 'package:connectivity/connectivity.dart';
import '../URL/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_downloader/image_downloader.dart';
import '../../ThemeColors/colors.dart';

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
  VoidCallback listener;
  var loading = true;
  Icon toggleIcon = Icon(Icons.play_arrow);
  var _opacity = 0.0;

  bool finish = false;

  var subscription;

  var _progress;

  bool videodownloadconfirm = false;

void downloadVideo() async{
  try {
    showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (BuildContext context) {
          return WillPopScope( 
          onWillPop: () async => false,
          child:AlertDialog(
            title: Text('Video Download'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: videodownloadconfirm == false
            ?Text('Do you really download this video?')
            :Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 1.5,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(mBlue),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Downloading...'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
            actions: <Widget>[
              videodownloadconfirm == false
              ?FlatButton(
                onPressed: () async{
                  setState(() {
                    videodownloadconfirm = true;
                  });
                  Navigator.of(context).pop();
                  downloadVideo();
                  var videoId = await ImageDownloader.downloadImage("${module.url + '&token=$token'}");
                  if (videoId == null) {
                    return;
                  }

                  // Below is a method of obtaining saved image information.
                  var fileName = await ImageDownloader.findName(videoId);
                  var path = await ImageDownloader.findPath(videoId);
                  var size = await ImageDownloader.findByteSize(videoId);
                  var mimeType = await ImageDownloader.findMimeType(videoId);
                  
                },
                child: Text('Yes'),
              )
              :Container(),
              videodownloadconfirm == true
              ?FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ImageDownloader.cancel();
                  setState(() {
                    videodownloadconfirm = false;
                  });
                },
                child: Text('Cancle Download'),
              )
              :FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          ),
          );
        });
  } on PlatformException catch (error) {
    print(error);
  }
}

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
    ImageDownloader.callback(onProgressUpdate: (String videoId, int progress) async{
      setState(() {
        _progress = progress;
      });
      if(progress == 100){
        Navigator.of(context).pop();
        setState(() {
          videodownloadconfirm = false;
        });
    showDialog(
        context: (context),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Video Download Successful'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Text('Video downloaded successfully to "Path:Internal storage/Download" folder in your phone'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
      }
      print(_progress);
    });
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        
      }
      else if(result == ConnectivityResult.none){
        subscription.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text('Mobile Connection Lost'),
              content: Text('Please connect to your wifi or turn on mobile data and try again'),
              actions: <Widget>[
                FlatButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ImageDownloader.cancel();
                  setState(() {
                    videodownloadconfirm = false;
                  });
                }, child: Text('OK'))
              ],
            ),
          );
        });
      }
    });
    _controller = VideoPlayerController.network('${module.url}&token=$token')
      ..initialize().then((_) {
        setState(() {
          loading = true;
        });
      });
    listener = () {
      if (_controller.value.initialized) {
        Duration duration = _controller.value.duration;
        Duration position = _controller.value.position;
        if (position > duration ~/ 2) {
          finish  = true;
        }
      }
    };
    _controller
      ..addListener(listener)
      ..setVolume(1.0)
      ..initialize();
    // _controller.play();
  }

  setModuleCompleteStatus() async {
    var setCompleteUrl = '$urlLink/$token/module/complete/${module.id}/';
    await http.get(setCompleteUrl).then((status) {
      var data = json.decode(status.body);
      if (data['status'] == true) {
        Navigator.of(context).pop();
      }
    }).then((value) {
    print('setModuleCompleteStatus completed with value $value');
  }, onError: (error) {
    print('setModuleCompleteStatus completed with error $error');
  });
  }

  @override
  dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ImageDownloader.cancel();
    _controller.pause();
    _controller.dispose();
    if(module.completeStatus == 1){
      print('here');
    }
    else{
      if(finish == true){
        print('false');
        setModuleCompleteStatus();
      }
    }
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
                          alignment: Alignment.topRight,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            child: AnimatedOpacity(
                                duration: Duration(milliseconds: 250),
                                opacity: _opacity,
                                child: _opacity == 1.0
                                    ? IconButton(
                                        onPressed: () {
                                          downloadVideo();
                                        },
                                        color: Colors.white,
                                        icon: Icon(Icons.file_download),
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
