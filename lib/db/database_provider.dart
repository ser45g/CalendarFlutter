import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Event.dart';
import '../models/Note.dart';

class DatabaseProvider{
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();
  static Database? _database = null;
  Future<Database?> get database async{
    if(_database != null)
      return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async{
    //dev only
    //await deleteDatabase(join(await getDatabasesPath(),"db.db"));
    return await openDatabase(join(await getDatabasesPath(),"db.db"),
    onCreate: (db, version)async{
      await db.execute('''
      create table events (
        id integer primary key autoincrement,
        title text,
        description text,
        fromDate date,
        toDate date,
        backgroundColor integer,
        isAllDay integer
      );
      ''');
      await db.execute('''
      create table notes (
        id integer primary key autoincrement,
        title text,
        content text,
        date_created date,
        date_last_updated date 
      );
      ''');
    },version: 1);
  }


  addEvent(Event event) async {
    final db = await database;

    db!.insert("events", event.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  }

  Future<int?> deleteEvent(int id)async{
    final db = await database;
    int count = await db!.rawDelete("delete from events where id=?",[id]);
    return count;
  }

  updateEvent(Event event)async{

    final db = await database;
    var map = event.toMap();
    db!.rawUpdate("update events set title= ?, description= ?, fromDate= ?, toDate = ? where id= ?;",
        [map["title"], map["description"], map["fromDate"], map["toDate"],map["id"]]);

    //db!.update("events", event.toMap());
  }

 findEventsOfDate(DateTime date)async{
    final db = await database;
    final res =
      await db!.rawQuery("select * from events where date(?) >= date(events.fromDate) and date(?) <= date(events.toDate) ",[date.toIso8601String(),date.toIso8601String()]);

    if(res.length==0)
      return [];
    else{
      var resultMap = res.toList();
      return resultMap.isNotEmpty? resultMap:[];
    }
  }

  getEvents()async{
    final db = await database;

    var res = await db!.query("events");
    if(res.length==0)
      return null;
    else{
      var resultMap = res.toList();
      return resultMap.isNotEmpty? resultMap:null;

    }
  }
  //---------------------------------------------------------//
  addNote(Note note) async{
    final db = await database;
    db!.insert("notes", note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<int?> deleteNote(int id) async{
    final db = await database;

    int count = await db!.rawDelete("delete from notes where id=?",[id]);
    return count;
  }
  updateNote(Note note) async{
    final db = await database;
    //print(note.toMap());
    var map = note.toMap();
    db!.rawUpdate("update notes set title= ?, content= ?, date_created= ?, date_last_updated= ? where id= ?;",
        [map["title"], map["content"], map["date_created"], map["date_last_updated"],map["id"]]);
    //db!.update("notes", note.toMap());
  }

   getNotes() async {
    final db = await database;

    var res = await db!.query("notes");
    if(res.length==0)
      return null;
    else{
      var resultMap = res.toList();
      return resultMap.isNotEmpty? resultMap:null;
    }
  }
}