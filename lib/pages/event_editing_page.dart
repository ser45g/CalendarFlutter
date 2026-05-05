import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/db/database_provider.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/pages/main_page.dart';
import '../models/Event.dart';
import '../utils.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({this.event, this.currentSelectedDate, super.key});
  final Event? event;
  final DateTime? currentSelectedDate;
  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {

  late DateTime fromDate;
  late DateTime toDate;
  late bool isAllDay=false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey= GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    super.dispose();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.event == null){

      DateTime date ;
      if(widget.currentSelectedDate!=null){
        date = widget.currentSelectedDate!;
        Duration duration = Duration(hours:DateTime.now().hour,
            minutes: DateTime.now().minute );
        //print(duration);
        date = date.add(duration);
        //print(date);
      }else{
        date = DateTime.now();
      }

      fromDate = date;
      toDate = date.add(Duration(hours: 2));


    }else{
      final event = widget.event!;
      titleController.text=event.title;
      fromDate=event.from;
      toDate=event.to;
    }
  }
  Future pickFromDateTime({required bool pickDate}) async{
    final date = await pickDateTime(fromDate,pickDate:pickDate);
    if(date == null)
      return;
    if(date.isAfter(toDate)){
      toDate= DateTime(date.year,date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() {
      fromDate=date;
    });
  }
  Future pickToDateTime({required bool pickDate}) async{
    final date = await pickDateTime(toDate,pickDate:pickDate,
      firstDate: pickDate?fromDate:null,);
    if(date == null)
      return;

    setState(() {
      toDate=date;
    });
  }

  void saveForm(){
    print("save form");
    final isValid= _formKey.currentState!.validate();
    final isEditing = widget.event!=null;
    if(isValid){
      final event = Event(title:titleController.text,
        from: fromDate,
        to:toDate,
        description: descriptionController.text,
        isAllDay: isAllDay,
        id: isEditing?widget.event!.id:null
      );
      print(isEditing);
      if(isEditing){
        print("update");
        DatabaseProvider.db.updateEvent(event);
      }else{
        DatabaseProvider.db.addEvent(event);
      }

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return MainPage();
      }),(Route<dynamic> route) => false);
    }
  }
  
  Future<DateTime?> pickDateTime(DateTime initialDate,
  {required bool pickDate,
      DateTime? firstDate}) async {
    if (pickDate){
      final date = await showDatePicker(context: context,
          initialDate: initialDate, firstDate: firstDate??DateTime(2015,8),
      lastDate: DateTime(2101));
      if(date==null)
        return null;
      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    }else{
      final timeOfDay = await showTimePicker(context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate));
      if(timeOfDay==null)
        return null;
      final date =
        DateTime(initialDate.year, initialDate.month,initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: (){
          Navigator.pop(context);
        },),
        actions: [
          TextButton(onPressed: (){
            print("save");
            return saveForm();
          }, child: Row(children: [
            Icon(Icons.done, size: 30,),
            Text(context.localizations.save, style: TextStyle(fontSize: 18),)
          ],))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.localizations.title,textAlign: TextAlign.end, style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, ), ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField( decoration: InputDecoration(border: OutlineInputBorder(),
                  hintText: context.localizations.addTitleHint),
                  controller: titleController,
                  validator: (title)=>title!=null&&title.isEmpty?
                  context.localizations.titleCannotBeEmpty:
                  null,
                  onFieldSubmitted: (_){

                },),
              ),
              SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.localizations.from,textAlign: TextAlign.end, style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, ), ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                          child: ListTile(title:
                          Text(Utils.toDate(fromDate,context)),
                          trailing: Icon(Icons.arrow_drop_down),

                            onTap: ()=>pickFromDateTime(pickDate:true),
                        )
                      ),
                      Expanded(child: ListTile(title:
                        Text(Utils.toTime(fromDate,context)),
                        trailing: Icon(Icons.arrow_drop_down),
                        onTap: ()=>pickFromDateTime(pickDate: false),
                      )
                      ),

                    ],
                  ),
                  Text(context.localizations.to,textAlign: TextAlign.end, style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, ), ),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: ListTile(title:
                          Text(Utils.toDate(toDate,context)),
                            trailing: Icon(Icons.arrow_drop_down),
                            onTap: ()=>pickToDateTime(pickDate:true),
                          )
                      ),
                      Expanded(child: ListTile(title:
                      Text(Utils.toTime(toDate,context)),
                        trailing: Icon(Icons.arrow_drop_down),
                        onTap: ()=>pickToDateTime(pickDate: false),
                      )
                      ),

                    ],
                  )
                ],
              ),
              CheckboxListTile(value: isAllDay, onChanged: (value){
                setState(() {
                  isAllDay=value??false;

                });
              },title: Text(context.localizations.isAllDay),),
              
              Text(context.localizations.description,textAlign: TextAlign.end, style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, ), ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(maxLines: null, minLines: 5, decoration: InputDecoration(border: OutlineInputBorder(),
                    hintText: context.localizations.addDescriptionHint),
                  controller: descriptionController,

                  onFieldSubmitted: (_){

                  },),
              ),
            ],
          ),
        ),
      )
    );
  }
}
