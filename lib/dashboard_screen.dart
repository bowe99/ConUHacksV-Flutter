import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardScreen extends StatelessWidget {
  final meetings = <Courses>[];
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
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SfCalendar(
              headerHeight: 40,
              view: CalendarView.day,
              dataSource: MeetingDataSource(_getDataSource(meetings)),
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 8,
                endHour: 22,
              )
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Course Name'),
                    //controller: titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Course Number'),
                    //controller: titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Professor'),
                    //controller: titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Section'),
                    //controller: titleController,
                  ),
                  Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: 'Start'),
                        //controller: titleController,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'End'),
                        //controller: titleController,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: 'Day'),
                        //controller: titleController,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Month'),
                        //controller: titleController,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Year'),
                        //controller: titleController,
                      ),
                    ],
                  )
                  

                ],
              ),
            ),
            RaisedButton(
              child: Text('Add Class'),
              onPressed: null ,
            )

        ],
      ),
    );
  }
}

List<Courses> _getDataSource(List<Courses> meetings) {
  return meetings;
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
