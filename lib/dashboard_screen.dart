import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import './break.dart';

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
    
    for (var time in meetings){
      DateTime breakStart = time.to;
      for(var checkTime in meetings){
        if (checkTime.to != breakStart){
          breaks.add(Break(breakStart, checkTime.from));
        }

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
          title: Text('help'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 400,
              child: SfCalendar(
                
                  headerHeight: 40,
                  view: CalendarView.day,
                  dataSource: MeetingDataSource(meetings),
                  timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 8,
                    endHour: 22,
                  )),
            ),
            breaks.isNotEmpty ? Text(
                                    'You have ' + breaks[0].breakTime().toString() + 'available on your next break. \nHere are some activities we would like to suggest:',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
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
              Container(
                width: 200.0,
                color: Colors.red,
                
              ),
              Container(
                width: 200.0,
                color: Colors.blue,
              ),
              Container(
                width: 200.0,
                color: Colors.green,
              ),
              Container(
                width: 200.0,
                color: Colors.yellow,
              ),
              Container(
                width: 200.0,
                color: Colors.orange,
              ),
            ],
          ),
          )
        ],

        ),
        floatingActionButton:FloatingActionButton(
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
                                        name: 'Date ex: 6',
                                        textController: dayController),
                                    _userInput(
                                        name: 'Month ex: 1',
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
                                          _addCourses(
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
                                  ]
                                )
                              )
                            );
                        },
                      );
                    })
        );
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
