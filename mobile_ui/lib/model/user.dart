
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_ui/model/calendar_item.dart';
import 'package:uuid/uuid.dart';

class User {
  final String username;
  final String email;
  final String password;
  final String id;
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password, 

     });
  Map<String, dynamic> toMap() {
    
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password
    };
  }
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}