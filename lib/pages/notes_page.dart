import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/db/database_provider.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/models/Note.dart';
import 'package:test_app/pages/add_note.dart';
import 'package:test_app/pages/display_note_page.dart';

import '../utils.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final contentCardMaxLines=5;
  getNotes()async{
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(future: getNotes(), builder: (context, noteData){
        switch(noteData.connectionState){
          case ConnectionState.waiting:{
            return Center(child: CircularProgressIndicator(),);
          }
          case ConnectionState.done:{
            if (noteData.data == null){
              return Center(child: Text(context.localizations.noNotes,
                textAlign: TextAlign.center,
                style: TextStyle(overflow: TextOverflow.visible,
                    fontSize: 18, fontWeight: FontWeight.bold),),);
            }else{
              return Padding(padding: const EdgeInsets.all(8.0), child: ListView.builder(
                itemCount:  (noteData.data as List<Map<String,Object?>>)?.length!??0,
                itemBuilder: (context, index){
                  final List<Map<String,Object?>>? noteList =
                      noteData.data as List<Map<String,Object?>>??null;
                  if(noteList==null)
                    return Card(child: Text("no value"),);
                  var map = noteList[index]??null;
                  if(map==null)
                    return Card(child: Text("no value"),);

                  Note note=Note.toNote(map);
                  return  Container(
                    padding: const EdgeInsets.only(top: 8,bottom: 2,right: 2,left: 2),
                    margin: const EdgeInsets.all(5.0),

                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0,),
                        borderRadius: BorderRadius.all(Radius.elliptical(8,8))
                    ),
                    child:ListTile(
                    title: Text(note.title),
                    subtitle: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(note.content , maxLines: contentCardMaxLines,),
                          note.content.split("\n").length> contentCardMaxLines?Text("..."):Text(""),
                          Text("(${context.localizations.lastUpdatedNote}: ${Utils.toDateTime(note.date_last_updated,context)})",
                          style: TextStyle(color: Colors.deepPurpleAccent),overflow: TextOverflow.ellipsis,),

                        ],
                      ),
                    ),

                    onTap: (){
                      final List<Map<String,Object?>>? noteList =
                          noteData.data as List<Map<String,Object?>>??null;
                      if(noteList==null)
                        return;
                      var map = noteList[index]??null;
                      if(map==null)
                        return;
                      Note note = Note.toNote(map);
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return DisplayNotePage(note);
                      },),);
                    },
                  ),);
                },
              ),);
            }
          }
          default:{
            return Center(child: Text("nothing"),);
          }
        }
      },),
      floatingActionButton: FloatingActionButton.extended(label: Row(
        children: [
          Icon(Icons.add),
          Text(context.localizations.addNote),
        ],
      ),

      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return AddNote();
        }));
      },),
    );

  }
}