import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LocalizationService{

  static String currentLanguage(BuildContext context){
    final Locale locale = Localizations.localeOf(context);
    print(locale.languageCode);
    return locale.languageCode;
  }

  static void setLanguage(String? language, BuildContext context)async{

    MyApp.setLocale(context, Locale(language??'en'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language", language??'en');
  }
}