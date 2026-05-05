import 'package:flutter/material.dart' ;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/pages/calendar_page.dart';
import 'package:test_app/pages/notes_page.dart';
import 'package:test_app/pages/settings_page.dart';
import 'package:test_app/services/app_theme_mode_service.dart';
import 'package:test_app/value_notifiers/value_notifier.dart';
import 'package:test_app/widgets/main_page_navbar_widget.dart';

import '../l10n/l10n.dart';
import '../streams/general_stream.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<Widget> pages=[CalendarPage(),NotesPage()];

  @override
  Widget build(BuildContext context) {
    //print(context.localizations.localeName);
    return
       Scaffold(
        appBar: AppBar(
          title: Text(context.localizations.mainPageTitle),
          actions: [
            IconButton(onPressed: () async {
              //SharedPreferences prefs = await SharedPreferences.getInstance();
              //isDarkModeNotifier.value=!isDarkModeNotifier.value;
              AppThemeModeService.toggleMode();

            },
          icon: ValueListenableBuilder(valueListenable: isDarkModeNotifier, builder:
          (context,isDark,child){
            return Icon(isDark?Icons.dark_mode_outlined:Icons.light_mode_outlined);
          })),
           IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return SettingsPage();
              }));
           }, icon: Icon(Icons.settings))

                //icon: ValueListenableBuilder(child: Icon(Icons.dark_mode_outlined)))
          ],
        ),
        body: ValueListenableBuilder(valueListenable: selectedPageNotifier,
            builder: (context, selectedPage, child){
              return pages.elementAt(selectedPage);
            }),
        bottomNavigationBar: MainPageNavbarWidget(),
    );
  }
}