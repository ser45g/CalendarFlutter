import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/db/database_provider.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/pages/main_page.dart';
import 'package:test_app/pages/notes_page.dart';

import '../models/Note.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String title="";
  String content="";
  final _formKey= GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();


  addNote(Note note) async {
    var db = await DatabaseProvider.db.addNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.addNote),

        leading: CloseButton(onPressed: (){
          Navigator.pop(context);
        },),
        actions: [
          TextButton(onPressed: (){
            final isValid= _formKey.currentState!.validate();
            if(!isValid)
              return;
            setState(() {
              title=titleController.text;
              content = contentController.text;

              if(content.isEmpty || title.isEmpty)
                return;
              Note note = Note(title, content, DateTime.now(),DateTime.now());
              addNote(note);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                return MainPage();
              }),(Route<dynamic> route) => false);
            });
          }, child: Row(children: [
            Icon(Icons.done, size: 30,),
            Text(context.localizations.save, style: TextStyle(fontSize: 18),)
          ],))
        ],

      ),
      body: Form(
        key: _formKey,
        child: Padding(padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 12.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.localizations.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 6.0,),
            TextFormField(controller: titleController,
              validator: (title)=>title!=null&&title.isEmpty?
                context.localizations.titleCannotBeEmpty:
                null,
              onEditingComplete: (){
              setState(() {});
              }, decoration: InputDecoration(hintText: context.localizations.noteTitleHint, border: OutlineInputBorder()), style: TextStyle( fontWeight: FontWeight.normal),),
            SizedBox(height: 10.0,),
            Text(context.localizations.description,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 6.0,),
            Expanded(child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onEditingComplete: (){
                setState(() {});
                },
              minLines: 6,
              controller: contentController,
              decoration: InputDecoration(hintText: context.localizations.noteDescriptionHint,
                  border: OutlineInputBorder()
              ),
              ))
            ],
          ),
        ),
      ),

    );
  }
}
