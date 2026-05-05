import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/l10n/l10n.dart';

import 'package:test_app/streams/general_stream.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/value_notifiers/value_notifier.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pages/home_page.dart';
import "package:timezone/data/latest.dart" as tz;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static void setThemeMode(BuildContext context, bool netTheme) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setThemeMode(netTheme);
  }
}

class _MyAppState extends State<MyApp> {

  bool? isDarkStoredPrefs;
  String? languageStoredPrefs;
  Locale? _locale;
  bool? _isDarkThemeMode;

  setLocale(Locale locale) {
    setState(() {
      print("Setting locale");
      _locale = locale;
    });
  }

  setThemeMode(bool isDark){
    setState(() {
      _isDarkThemeMode = isDark;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadPreferences();
  }



  @override
  void dispose() {

    super.dispose();
  }
  /*
  Future loadPreferences() async {
    prefs=await SharedPreferences.getInstance();
    isDarkStoredPrefs=prefs!.getBool("isDark");
    print("isDarkStoredPrefs");
    print(isDarkStoredPrefs);
    languageStoredPrefs=prefs!.getString("language");
    print("language");
    print(languageStoredPrefs);



    if(isDarkStoredPrefs==null){
      final brightness = MediaQuery.of(context).platformBrightness;
      isDarkModeNotifier.value=brightness==Brightness.dark;
    }else{
      isDarkModeNotifier.value=isDarkStoredPrefs!;
    }
    print("Is Dark Mode Notifier");
    print(isDarkModeNotifier.value);
    if(languageStoredPrefs==null){
      languageNotifier.value="en";
    }else{
      languageNotifier.value=languageStoredPrefs!;
    }
    print("Selected Language Notifier");
    print(languageNotifier.value);



  }

   */

  Future<SharedPreferences> loadPrefs()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return prefs;
  }
  @override
  Widget build(BuildContext context) {

      return
             FutureBuilder(
               future: loadPrefs(),
               builder: (context,prefsData) {
                 switch (prefsData.connectionState){
                   case ConnectionState.waiting:{
                     return CircularProgressIndicator();
                   }
                   case ConnectionState.done:{

                     SharedPreferences prefs = prefsData.data!;
                     if(prefs.getString("language")!=null){
                       _locale=Locale(prefs.getString('language')!);
                     }

                     isDarkModeNotifier.value=prefs.getBool("isDark")??true;

                     return ValueListenableBuilder(
                       valueListenable: isDarkModeNotifier,
                        builder: (context, isDark, child){
                         return  MaterialApp(
                         locale: _locale,
                         debugShowCheckedModeBanner: false,
                         title: 'Calendar', theme: ThemeData.light().copyWith(primaryColor: Colors.blue),
                         darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.blue),
                         themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                         home: HomePage(),
                         supportedLocales: L10n.locals,

                         localizationsDelegates: const [
                         GlobalMaterialLocalizations.delegate,
                         GlobalWidgetsLocalizations.delegate,
                         GlobalCupertinoLocalizations.delegate,
                         AppLocalizations.delegate
                         ],

                         );
                 }

                     );
                   }
                   default:{
                     return CircularProgressIndicator();
                   }
                 }




               }
             );




  }
}


