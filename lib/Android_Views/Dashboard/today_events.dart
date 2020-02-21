import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../../ThemeColors/colors.dart';
import '../../Model/model.dart';
import 'package:html/parser.dart' as html;

showDetail(BuildContext context, Event event) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text(event.eventName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                event.courseName,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Text(
              html.parse(event.desc).body.text,
              style: TextStyle(height: 1.25),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: Icon(Icons.location_on),
              title: Text(event.location),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: Icon(Icons.alarm),
              title: Text(
                event.time,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Close",
              style: TextStyle(color: mBlue, fontSize: 16.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

_showBottomSheet(BuildContext context, List<Event> events) {
  showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            color: mBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right:5),
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(24.0, 16.0, 0.0, 8.0),
                        height: 50.0,
                        child: Text(
                          'Today Events',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      events.length == 0
                      ?Container()
                      :Container(
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius:
                              BorderRadius.circular(5.0),
                          border: Border.all(
                            width: 1.5,
                            color: Colors.amber,
                          ),
                        ),
                        child: Text(
                          '${events.length}',
                          style: TextStyle(
                              color: mBlue, fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 8.0, top: 8.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Color(0xFFFFFFFF),
                        size: 16.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: events.length > 0
                    ? ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, i) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: InkWell(
                              onTap: () {
                                showDetail(context, events[i]);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5.0,
                                          spreadRadius: 2.0,
                                          color: Colors.black12,
                                        )
                                      ],
                                      color: Color(0xFFFFFFFF),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          events[i].day,
                                          style: TextStyle(
                                            color: mBlue,
                                            fontSize: 28.0,
                                          ),
                                        ),
                                        Text(
                                          events[i].month,
                                          style: TextStyle(
                                            color: mBlue,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 24.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                            bottom: 6.0,
                                          ),
                                          child: Text(
                                            events[i].eventName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width-130,
                                          padding: EdgeInsets.only(
                                            bottom: 6.0,
                                          ),
                                          child: Text(
                                            events[i].courseName,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.alarm,
                                                size: 14.0,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                events[i].time,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 24.0),
                                                child: Icon(
                                                  Icons.location_on,
                                                  size: 14.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                events[i].location,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/no_event.png',
                            width: 36.0,
                            color: Color(0xFFFFFFFF),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "No Event",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      });
}

Widget todayEvents(List<Event> eventList, bool event, BuildContext context) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(bottom: 8.0),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right:5),
                  child: Text(
                    'Today Events',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                eventList.length == 0
                ?Container()
                :Container(
                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius:
                        BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 1.5,
                      color: Colors.amber,
                    ),
                  ),
                  child: Text(
                    '${eventList.length}',
                    style: TextStyle(
                        color: mBlue, fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  if (eventList.length > 0) {
                    _showBottomSheet(context, eventList);
                  } else {}
                },
                child: eventList.length > 0
                    ? Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 14.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              'More',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    : null)
          ],
        ),
      ),
      event == true
          ? InkWell(
              onTap: () {
                showDetail(context, eventList[0]);
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 0.0),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                          color: Colors.black12,
                        )
                      ],
                      color: Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          eventList[0].day,
                          style: TextStyle(
                            color: mBlue,
                            fontSize: 28.0,
                          ),
                        ),
                        Text(
                          eventList[0].month,
                          style: TextStyle(
                            color: mBlue,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 6.0,
                          ),
                          child: Text(
                            eventList[0].eventName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width-135,
                          padding: EdgeInsets.only(
                            bottom: 6.0,
                          ),
                          child: Text(
                            eventList[0].courseName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.alarm,
                                size: 14.0,
                                color: Colors.white,
                              ),
                              Text(
                                eventList[0].time,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 24.0),
                                child: Icon(
                                  Icons.location_on,
                                  size: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                eventList[0].location,
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              margin: EdgeInsets.only(right: 16.0),
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'images/no_event.png',
                    width: 24.0,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "No Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    ],
  );
}
