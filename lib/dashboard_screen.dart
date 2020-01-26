import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import './break.dart';
import './activity_card.dart';

class DashboardScreen extends StatefulWidget {
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final meetings = <Courses>[];
  final breaks = <Break>[];



  @override
  void initState() {
    super.initState();
    getAllCourses();

  }
  getAllCourses() async{
      var response = await http.post(globals.mainURL+'/getcourses', body: {'userID': globals.userID});
      // print(response.body);
      if(response.statusCode == 200){
        final resp = json.decode(response.body);
        if(resp['status'] != "success"){
          print( "Error ");
        }
        resp['msg'].asMap().forEach((index, value) => {
        
          _addCourses(newActivityName: value['name'], newClassNumber: value['classNumber'], newProfessor: value['professor'],
          newSection: value['section'], start: (new DateTime.fromMillisecondsSinceEpoch(value['time']['start']['seconds'] * 1000)), end: (new DateTime.fromMillisecondsSinceEpoch(value['time']['end']['seconds'] * 1000)))
        });    

      }

  }

  void _uploadCourse({
    DateTime start,
    DateTime end,
    String newClassNumber,
    String newActivityName,
    String newProfessor,
    String newSection,
  })async{
    var response = await http.post(globals.mainURL+'/newcourse', body: {
      'userID': globals.userID,
      'name': newActivityName,
      'classNumber': newClassNumber,
      'professor': newProfessor,
      'section': newSection,
      'start': start.toIso8601String(),
      'end': end.toIso8601String()
    });
    // print(response.body);
    if(response.statusCode == 200){
      final resp = json.decode(response.body);
      if(resp['status'] != "success"){
        print( "Error ");
      }
      _addCourses(
        newActivityName:
            classNameController.text,
        newClassNumber:
            classNumberController.text,
        newProfessor:
            professorController.text,
        newSection: sectionController.text,
        start: DateTime.parse(yearController.text + '-' + monthController.text + 
          '-' + dayController.text +' ' + timeStartController.text),
        end: DateTime.parse(yearController.text +'-' + monthController.text + 
          '-' +dayController.text +' ' +timeEndController.text)
      );
      print("DONE");
      }
  }
  void _addCourses({
    DateTime start,
    DateTime end,
    String newClassNumber,
    String newActivityName,
    String newProfessor,
    String newSection,
  }) {
    final Courses newCourse = Courses(
        classNumber: newClassNumber,
        activityName: newActivityName,
        professor: newProfessor,
        section: newSection,
        from: start,
        to: end,
        background: const Color(0xFF0F8644),
        isAllDay: false);
    setState(() {
      meetings.add(newCourse);
    });

    for (var time in meetings) {
      DateTime breakStart = time.to;
      for (var checkTime in meetings) {
        if (checkTime.to != breakStart) {
          breaks.add(Break(breakStart, checkTime.from));
          _reOrgBreaks();
        }
      }
    }
  }

  void _reOrgBreaks() {
    DateTime now = DateTime.now();
    Duration closestBreak = breaks[0].start.difference(now);
    Break initBreak = breaks[0];

    for (var i = 0; i < breaks.length; i++) {
      if (breaks[i].start.difference(now).inMinutes < closestBreak.inMinutes &&
          breaks[i].start.difference(now).inMinutes > 0) {
        closestBreak = breaks[i].start.difference(now);
        breaks[0] = breaks[i];
        breaks[i] = initBreak;
        initBreak = breaks[0];
      }
    }
  }

  final classNumberController = TextEditingController();
  final classNameController = TextEditingController();
  final professorController = TextEditingController();
  final sectionController = TextEditingController();
  final timeStartController = TextEditingController();
  final timeEndController = TextEditingController();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'BookEd',
          ),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 350,
                child: SfCalendar(
                    headerHeight: 40,
                    view: CalendarView.day,
                    dataSource: MeetingDataSource(meetings),
                    timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: 8,
                      endHour: 22,
                    )),
              ),
              breaks.isNotEmpty
                  ? Text(
                      'You have ' +
                          breaks[0].breakTime().inHours.toString() +
                          ':' +
                          ((breaks[0].breakTime().inMinutes -
                                      (breaks[0].breakTime().inHours * 60) <
                                  10
                              ? '0' +
                                  (breaks[0].breakTime().inMinutes -
                                          (breaks[0].breakTime().inHours * 60))
                                      .toString()
                              : (breaks[0].breakTime().inMinutes -
                                      (breaks[0].breakTime().inHours * 60))
                                  .toString())) +
                          ' available on your next break.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'You have no breaks available.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              Container(
                  margin: EdgeInsets.all(20.0),
                  height: 200.0,
                  width: 200.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ActivityCard('W and G\'s', 'Cresccent Street'),
                      ActivityCard('A\&W\'s', 'Maisonneuve Street'),
                      ActivityCard('Subway', 'JMSB'),
                      ActivityCard('Burger Bar', 'Cresccent Street'),
                      ActivityCard('McDonald\'s', 'Sainte-Catherine Street'),
                    ],
                  ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 16,
                      child: Container(
                          height: 400.0,
                          width: 360.0,
                          child: ListView(children: <Widget>[
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                "New Class",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 20),
                            _userInput(
                                name: 'Course Number ex: ECON 201',
                                textController: classNumberController),
                            _userInput(
                                name: 'Course Name ex: Microeconomics',
                                textController: classNameController),
                            _userInput(
                                name: 'Professor ex: Aiman Hanna',
                                textController: professorController),
                            _userInput(
                                name: 'Section ex: AA',
                                textController: sectionController),
                            _userInput(
                                name: 'Start Time ex: 11:30',
                                textController: timeStartController),
                            _userInput(
                                name: 'End Time ex: 14:20',
                                textController: timeEndController),
                            _userInput(
                                name: 'Date ex: 06',
                                textController: dayController),
                            _userInput(
                                name: 'Month ex: 01',
                                textController: monthController),
                            _userInput(
                                name: 'Year ex: 2020',
                                textController: yearController),
                            Container(
                              width: 250,
                              margin: EdgeInsets.only(bottom: 20),
                              child: FlatButton(
                                child: Text('Submit'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                onPressed: () {
                                  _uploadCourse(
                                              newActivityName:
                                                  classNameController.text,
                                              newClassNumber:
                                                  classNumberController.text,
                                              newProfessor:
                                                  professorController.text,
                                              newSection: sectionController.text,
                                              start: DateTime.parse(
                                                  yearController.text +
                                                      '-' +
                                                      monthController.text +
                                                      '-' +
                                                      dayController.text +
                                                      ' ' +
                                                      timeStartController.text),
                                              end: DateTime.parse(
                                                  yearController.text +
                                                      '-' +
                                                      monthController.text +
                                                      '-' +
                                                      dayController.text +
                                                      ' ' +
                                                      timeEndController.text));
                                },
                              ),
                            )
                          ])));
                },
              );
            }));
  }
}

Widget _userInput({String name, TextEditingController textController}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: <Widget>[
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(labelText: name),
          controller: textController,
        ),
      ],
    ),
  );
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  List<Courses> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  String getSubject(int index) {
    return source[index].classNumber + ": \n" + source[index].activityName;
  }

  String getClassNumber(int index) {
    return source[index].classNumber;
  }

  String getProfessor(int index) {
    return source[index].professor;
  }

  String getSection(int index) {
    return source[index].section;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }
}

class Courses {
  Courses(
      {this.activityName,
      this.classNumber,
      this.professor,
      this.section,
      this.from,
      this.to,
      this.background,
      this.isAllDay});

  String activityName;
  String classNumber;
  String professor;
  String section;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
