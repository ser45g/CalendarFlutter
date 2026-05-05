import 'dart:ui';

import 'package:flutter/material.dart';

class Event{
  final int? id;
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor=Colors.deepPurple,
    this.isAllDay=false,
    this.id
  });

  static Event toEvent(Map<String,dynamic> map){
    String title = map['title'] as String??"";
    String description = map['description'] as String??"";
    DateTime fromDate= DateTime.parse(map['fromDate'] as String);
    DateTime toDate = DateTime.parse(map['toDate'] as String);
    bool isAllDay = (map['isAllDay'] as int)==0?false:true;
    int id = map['id'] as int??0;
    Color backgroundColor = Color(map['backgroundColor'] as int);
    return Event(title: title,
        description: description, from: fromDate, to: toDate,
        isAllDay: isAllDay,id: id,backgroundColor: backgroundColor);
  }

  Map<String, dynamic> toMap() {
    var data = id!=0?{
      'id':id,
      'title': title,
      'description':  description ,
      'fromDate':  from.toIso8601String() ,
      'toDate': to.toIso8601String(),
      'backgroundColor': backgroundColor.toARGB32(),
      'isAllDay': isAllDay?1:0
    }:{
      'title': title,
      'description':  description ,
      'fromDate':  from.toIso8601String() ,
      'toDate': to.toIso8601String(),
      'backgroundColor': backgroundColor.toARGB32(),
      'isAllDay': isAllDay?1:0
    };
    return data;
  }
}