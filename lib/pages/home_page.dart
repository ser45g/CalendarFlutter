import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/pages/main_page.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/services/localization_service.dart';
import 'package:test_app/services/noti_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //final Locale selectedLocale;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {

  @override
  void initState(){
    super.initState();
    //NotiService().initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            child: Center(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(context.localizations.welcome, textAlign: TextAlign.center, style: TextStyle(fontSize: 24),),
                   Flex(direction:  MediaQuery.sizeOf(context).width>500?
                    Axis.horizontal: Axis.vertical,
                     mainAxisAlignment: MainAxisAlignment.center,


                     children: [
                     Container(
                       constraints: BoxConstraints(maxHeight: 300,maxWidth: 300),
                       padding: const EdgeInsets.all(8.0),
                       child: Lottie.asset("assets/lotties/home.json",repeat: true,reverse: true),
                     ),
                     Column(children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(bottom: 4,right: 12),
                             child: Text(context.localizations.homeLanguage,style: TextStyle(fontSize: 17)),
                           ),

                           DropdownButton(items: [
                             DropdownMenuItem(child: Text("Русский"),value: "ru",),
                             DropdownMenuItem(child: Text("English"),value: 'en',)
                           ],
                               value: LocalizationService.currentLanguage(context),
                               onChanged: (String? value) async {
                                 print(value);
                                 //SharedPreferences prefs = await SharedPreferences.getInstance();
                                 LocalizationService.setLanguage(value,context);
                               }),
                         ],
                       ),
                        ElevatedButton(onPressed: (){
                          NotiService().showNotification(id:Random().nextInt(80),
                          title: "Hello",body: "body");
                        }, child: Text("notify")),
                       ElevatedButton( onPressed: (){
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                           return MainPage();
                         }));
                       },style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent)),
                           child: Text(context.localizations.getStarted,
                             style: TextStyle(fontSize: 20,color: Colors.white),))

                     ],),


                   ],),
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}