import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:test_app/db/database_provider.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/pages/event_editing_page.dart';
import '../data_sources/event_data_source.dart';
import '../models/Event.dart';
import '../utils.dart';
import '../widgets/tasks_widget.dart';
import 'event_viewing_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});



  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  DateTime _focusedDay=DateTime.now();
  DateTime? _selectedDate;


  @override
  void initState() {
    super.initState();
    _selectedDate=_focusedDay;

  }

 getEvents()async{
    final events = await DatabaseProvider.db.getEvents();
    return events;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: FutureBuilder(future: getEvents(),builder: (context,eventData){
        switch (eventData.connectionState){
          case ConnectionState.waiting:{
            return Center(child: CircularProgressIndicator(),);
          }
          case ConnectionState.done:
            {
              List<Map<String,Object?>> eventMap=[];
              if(eventData.data != null){
                eventMap=eventData.data as List<Map<String,Object?>>??[];
              }

              List<Event> events=[];
              for(var i = 0; i <eventMap.length;i++){
                final element = eventMap[i];
                Event myEvent = Event.toEvent(element);
                events.add(myEvent);
              }

              return SingleChildScrollView(
                child: Column(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  children: [
                    SfCalendar(
                      viewNavigationMode: ViewNavigationMode.snap,
                      view: CalendarView.month,
                      initialSelectedDate: DateTime.now(),
                      onSelectionChanged: (args) {
                        _selectedDate = args.date;
                      },
                      cellBorderColor: Colors.blue.withOpacity(0.2),
                      dataSource: EventDataSource(events),
                      onLongPress: (details) async {
                        List<dynamic> eventsDynamicMap = await DatabaseProvider.db.getEvents()??[];

                        List<Map<String,Object?>> eventsMap = eventsDynamicMap.cast<Map<String,Object?>>()??[];
                        print("no error");
                        List<Event> events = eventsMap.map((e)=>Event.toEvent(e)).toList();
                        List<dynamic> selectedEventsDynamicMap =
                          await DatabaseProvider.db.findEventsOfDate(details.date!)??[];
                        List<Map<String,Object?>> selectedEventsMap=selectedEventsDynamicMap.cast<Map<String,Object?>>()??[];
                        List<Event> selectedEvents = selectedEventsMap.map((e)=>Event.toEvent(e)).toList();
                        showModalBottomSheet(context: context,
                            builder: (context) {

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
                                    Text("${context.localizations.eventsFor} ${Utils.toDate(details.date!, context)}",style:
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



                        });
                      },
                    ),
                  ],
                ),
              );
            }
          default:{
              return Center(child: Text("Could not load the necessary data, please contact sergey1pes@gmail.com to get help"),);
            }
        }
      },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return new EventEditingPage(currentSelectedDate: _selectedDate);
        }));
      }, label: Row(
        children: [
          Icon(Icons.add),
          Text(context.localizations.addEvent),
        ],
      ),),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

