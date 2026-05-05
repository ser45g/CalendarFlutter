import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/db/database_provider.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/models/Note.dart';
import 'package:test_app/pages/main_page.dart';
import 'package:test_app/utils.dart';

class DisplayNotePage extends StatefulWidget {
  const DisplayNotePage(this.note,{super.key});
  final Note note;

  @override
  State<DisplayNotePage> createState() => _DisplayNotePageState();
}

class _DisplayNotePageState extends State<DisplayNotePage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isEditable=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    titleController.text= widget.note.title;
    contentController.text= widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    final Note note = widget.note;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.yourNote),
        actions: [
          TextButton(onPressed: () async {
            await DatabaseProvider.db.deleteNote(widget.note.id!);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return MainPage();
            }));
          }, child: Icon(Icons.delete,size: 30,)),

          isEditable==false?TextButton(onPressed: () async {
            setState(() {
              isEditable=true;
            });

          }, child: Row(
            children: [
              Icon(Icons.edit,size: 30,),
              Text(context.localizations.edit,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            ],
          )):TextButton(onPressed: () async {
            print("update");
            await DatabaseProvider.db.updateNote(Note(titleController.text, contentController.text,
                widget.note.date_created, DateTime.now(),id: widget.note.id));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return MainPage();
            }));
          }, child: Row(
            children: [
              Icon(Icons.save_rounded,size: 30,),
              Text(context.localizations.save, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            ],
          ) )

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.localizations.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(height: 6.0,),
              TextField( controller: titleController, readOnly: !isEditable, decoration: InputDecoration(border: OutlineInputBorder()),
            style: TextStyle( fontWeight: FontWeight.normal),),
              SizedBox(height: 10,),
              Text(context.localizations.description,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(height: 6.0,),

              TextField(controller: contentController,minLines: 5, readOnly: !isEditable,  maxLines: null, decoration: InputDecoration(border: OutlineInputBorder()),
                style: TextStyle( fontWeight: FontWeight.normal),),
              SizedBox(height: 5,),
              Text("(${context.localizations.lastUpdatedNote}: ${Utils.toDateTime(note.date_last_updated,context)}, "
                  "${context.localizations.created}: ${Utils.toDateTime(widget.note.date_created, context)})",
                style: TextStyle(color: Colors.deepPurpleAccent), textAlign: TextAlign.center,),

            ],
          ),
        ),
      ),
    );
  }
}
