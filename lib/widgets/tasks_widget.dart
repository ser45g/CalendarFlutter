
import 'package:flutter/material.dart';
import 'package:test_app/extensions/context_extension.dart';
import '../models/Event.dart';
import '../pages/event_viewing_page.dart';
import '../utils.dart';

class TasksWidget extends StatelessWidget {
  TasksWidget({required this.selectedDayOfEvent,
    required this.events,required this.selectedEvents,super.key});
  final DateTime selectedDayOfEvent;
  final List<Event>? selectedEvents;
  final List<Event>? events;

  @override
  Widget build(BuildContext context) {
          print("widget rebuild");
          if(selectedEvents?.isEmpty??true){
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.localizations.noEventsFound,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,color: Colors.red),),
              ),
            );
          }


          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text("${context.localizations.eventsFor} ${Utils.toDate(selectedDayOfEvent, context)}",style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),


                ...selectedEvents!.map((myEvents){
                  //print(myEvents.to.isBefore(DateTime.now()));
                  return Container(
                    padding: const EdgeInsets.all(2.0),
                    margin: const EdgeInsets.all(5.0),

                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0,),
                        borderRadius: BorderRadius.all(Radius.elliptical(8,8))
                    ),
                    child: ListTile(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return EventViewingPage(event: myEvents);
                      }));
                    },
                      title:  Row(children: [
                        Expanded(child: Text(context.localizations.eventTasksWidget, style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.bold),),),
                        Expanded(flex:2,child: Text(myEvents.title))
                      ],),
                      subtitle: Column(
                        children: [
                          SizedBox(height: 12,),
                          Row(children: [
                            Expanded(child: Text(context.localizations.isDone, style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold),),),
                            Expanded(flex:2,child: Row(
                              children: [
                                Row(children: [
                                  Center(child:
                                  myEvents.to.isBefore(DateTime.now())? const Icon(Icons.done,
                                    color: Colors.teal,):
                                  Icon(Icons.timelapse_outlined),),
                                  SizedBox(width: 8,),
                                  Center(child: Text(myEvents.to.isBefore(DateTime.now())?context.localizations.done:context.localizations.waiting))
                                ],),

                              ],
                            ))
                          ],),
                          SizedBox(height: 12,),
                          Row(children: [
                            Expanded(child: Text(context.localizations.from, style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold),),),
                            Expanded(flex:2,child: Text(Utils.toDateTime(myEvents.from,context)))
                          ],),
                          SizedBox(height: 12,),
                          Row(children: [
                            Expanded(child: Text(context.localizations.to,style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold),),),
                            Expanded(flex:2,child: Text(Utils.toDateTime(myEvents.to,context)))
                          ],),

                          SizedBox(height: 12,)
                        ],
                      ),
                    ),
                  );}),

                SizedBox(height: 50,)
              ],
            ),
          );


  }
}
