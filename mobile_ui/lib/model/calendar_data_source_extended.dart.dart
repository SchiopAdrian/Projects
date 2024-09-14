import 'package:flutter/material.dart';
import 'package:mobile_ui/model/calendar_item.dart';
import 'package:mobile_ui/model/task.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDataSourceExtended extends CalendarDataSource{
  CalendarDataSourceExtended(List<CalendarItem> appointments){
    this.appointments = appointments;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].getStartTime();

  @override
  DateTime getEndTime(int index) => appointments![index].getEndTime();

  @override
  String getSubject(int index) => appointments![index].getTitle();

  @override
  Color getColor(int index) => appointments![index].getColor();
}