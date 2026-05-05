import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/db/database_provider.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/pages/event_editing_page.dart';
import 'package:test_app/pages/main_page.dart';

import '../models/Event.dart';
import '../utils.dart';

class EventViewingPage extends StatefulWidget {
  const EventViewingPage({super.key, required this.event});
  final Event event;

  @override
  State<EventViewingPage> createState() => _EventViewingPageState();
}

class _EventViewingPageState extends State<EventViewingPage> {
  final descriptionController= TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descriptionController.text=widget?.event?.description??"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return EventEditingPage(event: widget.event,);
            }));
          }, icon: Icon(Icons.edit)),
          IconButton(onPressed: (){
            if(widget.event.id!=null){
              DatabaseProvider.db.deleteEvent(widget.event.id!);
            }
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
              return MainPage();
            }));
          }, icon: Icon(Icons.delete)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [


          Row(children: [
            Expanded( child: Text(context.localizations.title, style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold),),),
            Expanded(child: Text(widget.event.title, style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w400),))
          ],),

          SizedBox(height: 24,),
          Row(children: [
            Expanded(child: Text(context.localizations.from, style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold),),),
            Expanded(child: Text(Utils.toDateTime(widget.event.from,context)))
          ],),
          SizedBox(height: 20,),
          Row(children: [
            Expanded(child: Text(context.localizations.to,style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold),),),
            Expanded(child: Text(Utils.toDateTime(widget.event.to,context)))
          ],),
          SizedBox(height: 8,),

          CheckboxListTile(value: widget.event.isAllDay,
              onChanged: (bool? value){},
            title: Text(context.localizations.isAllDay),),

          SizedBox(height: 16,),
          Text(context.localizations.description,style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold),),
          SizedBox(height: 4,),
          TextField(maxLines: null, minLines: 5, readOnly: true,
            controller: descriptionController,
            decoration: InputDecoration(border: OutlineInputBorder()),)

        ],
      ),
    );
  }
}
