import 'package:flutter/material.dart';

abstract class CalendarItem {
  DateTime getStartTime();
  DateTime getEndTime();
  String getTitle();
  Color getColor();
}