import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moodle_test/Android_Views/Dashboard/drawer.dart';
import 'package:moodle_test/Android_Views/URL/url.dart';
import 'package:moodle_test/Model/user.dart';
import 'package:moodle_test/Model/event.dart';
import 'package:moodle_test/ThemeColors/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html;
import 'package:moodle_test/Android_Views/Auto_Logout_Method.dart';

class CalendarEventView extends StatefulWidget {
  @override
  _CalendarEventViewState createState() => _CalendarEventViewState();
}

class _CalendarEventViewState extends State<CalendarEventView>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AnimationController _controller;
  Map<DateTime, List> _events = Map();
  Map<DateTime, List> _visibleEvents = Map();
  DateFormat _eventDTformat = DateFormat('yyyy M d');
  DateTime _selectedDay;
  List _selectedEvents;
  bool _loading = true;

  countertimer(){
  AutoLogoutMethod.autologout.counter(context);
  }

  @override
  void initState() {
    super.initState();
    countertimer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _selectedDay = DateTime.now();
    _getEvents();
    _controller.forward();
  }

  _getEvents() async {
    List<Event> eventList = [];
    var eventUrl = '$urlLink/$token/events/';
    await http.get(eventUrl).then((response) {
      var events = json.decode(response.body);
      for (var event in events['events']) {
        var date = event['timestart'];
        date = DateTime.fromMillisecondsSinceEpoch(date * 1000);
        date = _eventDTformat.format(date);
        var dateList = date.split(' ');
        Event evnt = Event(
          name: event['name'],
          coursename: event['course']['fullname'],
          type: event['eventtype'],
          description: event['description'],
          location: event['location'],
          timestart: date,
        );
        _events[DateTime(
          int.parse(dateList[0]),
          int.parse(dateList[1]),
          int.parse(dateList[2]),
        )] = [evnt];
        eventList.add(evnt);
      }
    });
    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _visibleEvents = Map.fromEntries(
        _events.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(Duration(days: 1))) &&
              entry.key.isBefore(last.add(Duration(days: 1))),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: countertimer,
    child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: mBlue,
      appBar: AppBar(
        title: Text(
          'Events',
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          icon: Image.asset(
            'images/menu.png',
            width: 24.0,
            color: mWhite,
          ),
        ),
      ),
      drawer: drawer(currentUser, context),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 2.0,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TableCalendar(
                  locale: 'en_US',
                  rowHeight: 40.0,
                  events: _visibleEvents,
                  initialCalendarFormat: CalendarFormat.month,
                  formatAnimation: FormatAnimation.slide,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  availableGestures: AvailableGestures.all,
                  availableCalendarFormats: {
                    CalendarFormat.month: '',
                    CalendarFormat.week: '',
                  },
                  calendarStyle: CalendarStyle(
                    weekdayStyle: TextStyle().copyWith(color: Colors.white),
                    outsideDaysVisible: false,
                    weekendStyle:
                        TextStyle().copyWith(color: Color(0xFFFFB75B)),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle().copyWith(color: Colors.white),
                    weekendStyle:
                        TextStyle().copyWith(color: Color(0xFFFFB75B)),
                  ),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                    titleTextStyle:
                        TextStyle(color: Colors.white, fontSize: 16.0),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, _) {
                      return FadeTransition(
                        opacity:
                            Tween(begin: 0.0, end: 1.0).animate(_controller),
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color.fromRGBO(255, 255, 255, 0.25),
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle().copyWith(
                                  fontSize: 16.0, color: Color(0xFFFFB75B)),
                            ),
                          ),
                        ),
                      );
                    },
                    todayDayBuilder: (context, date, _) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: Color(0xFFFFB75B),
                              style: BorderStyle.solid,
                              width: 1.0),
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle()
                                .copyWith(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      );
                    },
                    markersBuilder: (context, date, events, holidays) {
                      final children = <Widget>[];

                      if (events.isNotEmpty) {
                        children.add(
                          Positioned(
                            bottom: 0,
                            child: _buildEventsMarker(date, events),
                          ),
                        );
                      }
                      return children;
                    },
                  ),
                  onDaySelected: (date, events) {
                    _onDaySelected(date, events);
                    _controller.forward(from: 0.0);
                  },
                  onVisibleDaysChanged: _onVisibleDaysChanged,
                ),
                Expanded(
                  child: _buildEventList(),
                ),
              ],
            ),
    )
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFFB75B),
      ),
      width: 6.0,
      height: 6.0,
    );
  }

  Widget _buildEventList() {
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 24.0, left: 24.0, bottom: 16.0),
              child: Text(
                'Events',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: mBlue,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _selectedEvents
                    .map(
                      (event) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5.0,
                              offset: Offset(0.0, 0.0),
                              spreadRadius: 0.5,
                              color: Color.fromRGBO(223, 234, 237, 0.75),
                            )
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: Text(
                                html.parse(event.name).body.text.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color.fromRGBO(0, 51, 118, .65),
                                  size: 16.0,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 4.0, bottom: 8.0, left: 6.0),
                                  child: Text(
                                    event.location,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      height: 1.15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ));
  }
}
