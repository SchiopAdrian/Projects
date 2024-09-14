
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ui/model/calendar_item.dart';
import 'package:uuid/uuid.dart';

class Task implements CalendarItem{
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final String id;
  final String idUser;
  bool isSynced;
  bool isDelete;
  bool isUpdated;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.from, 
    required this.to, 
    required this.idUser,
    this.backgroundColor = const Color.fromARGB(255, 135, 3, 3),
    this.isSynced = false,
    this.isDelete = false,
    this.isUpdated = false,
     });
     
  @override
  DateTime getEndTime() {
    return this.to;
  }

  @override
  DateTime getStartTime() {
    return this.from;
  }

  @override
  String getTitle() {
    return this.title;
  }
  @override
  Color getColor() {
    return this.backgroundColor;
  }

  

  Map<String, dynamic> toMap() {
    
    return {
      'id': id,
      'title': title,
      'description': description,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'idUser': idUser,
      'isSynced': isSynced ? 1 : 0,
      'isDelete': isDelete? 1 : 0,
      'isUpdated': isUpdated? 1 :0
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      from: DateTime.parse(map['from']),
      to: DateTime.parse(map['to']),
      idUser: map['idUser'],
      isSynced: true,
      isDelete: false,
      isUpdated: false
    );
  }
}