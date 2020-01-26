import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SfCalendar(
            headerHeight: 40,
            view: CalendarView.day,
            dataSource: MeetingDataSource(_getDataSource()),
            timeSlotViewSettings: TimeSlotViewSettings(
              startHour: 8,
              endHour: 22,
            )
            
          )
        ],
       
      ),
    );
  }

  
}

 List<Courses> _getDataSource() {
    final meetings = <Courses>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Courses(
          classNumber: "MATH 201", 
          activityName: "Operating Systems",
          professor: "Aiman Hanna",
          section: "AA",
          from: startTime, 
          to: endTime, 
          background: const Color(0xFF0F8644), 
          isAllDay: false)
          );
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

  String getClassNumber(int index){
    return source[index].classNumber;
  }

  String getProfessor(int index){
    return source[index].professor;
  }

  String getSection(int index){
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
  Courses({this.activityName, this.classNumber, this.professor, this.section, this.from, this.to, this.background, this.isAllDay});

  String activityName;
  String classNumber;
  String professor;
  String section;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}