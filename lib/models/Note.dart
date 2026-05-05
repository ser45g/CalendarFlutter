import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Note {
  int? id;
  String title;
  String content;
  DateTime date_created;
  DateTime date_last_updated;


  Note( this.title, this.content, this.date_created, this.date_last_updated, {this.id = 0});

  Map<String, dynamic> toMap() {
    var data = id!=null&&id!=0?{
      'id':id,
      'title': title,
      'content':  content ,
      'date_created':  date_created.toIso8601String() ,
      'date_last_updated': date_last_updated.toIso8601String()
    }:{
      'title': title,
      'content':  content ,
      'date_created':  date_created.toIso8601String() ,
      'date_last_updated': date_last_updated.toIso8601String()
    };
    return data;
  }

  static Note toNote(Map<String,dynamic> map){
    String title = map["title"] as String??"";
    int id = map["id"] as int??0;
    String content = map["content"] as String??"";
    DateTime date_created = DateTime.parse(map["date_created"] as String);
    DateTime date_last_updated = DateTime.parse(map["date_last_updated"] as String);

    return Note(title, content, date_created, date_last_updated,id: id);

  }

}