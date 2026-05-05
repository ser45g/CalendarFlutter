import 'package:shared_preferences/shared_preferences.dart';

import '../value_notifiers/value_notifier.dart';

class AppThemeModeService{
  static bool isDarkMode(){
    return isDarkModeNotifier.value;
  }

  static void setMode(bool? isDark)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkModeNotifier.value=isDark??true;
    prefs.setBool("isDark", isDarkModeNotifier.value);
  }

  static Future toggleMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkModeNotifier.value=!isDarkModeNotifier.value;
    prefs.setBool("isDark", isDarkModeNotifier.value);
  }
}