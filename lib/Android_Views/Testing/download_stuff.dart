import 'package:flutter/material.dart';

class Downloader extends StatefulWidget {
  _DownloaderState createState() => _DownloaderState();
}

class _DownloaderState extends State<Downloader> {
  bool wifi=true;

  void _changeDLsetting(dynamic wifiDL){
    setState(() {
      wifi = wifiDL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text('Downloader'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Switch(
              value: wifi,
              onChanged: (wifiDL)=>
                _changeDLsetting(wifiDL)  
            ),  
          ],
        ),
      ),
    );
  }
}