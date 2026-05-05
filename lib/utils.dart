import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:test_app/extensions/context_extension.dart';

class Utils{
  static String toDateTime(DateTime dateTime,BuildContext context){
    final date=DateFormat.yMMMEd(context.localizations.localeName).format(dateTime);
    final time = DateFormat.Hm(context.localizations.localeName).format(dateTime);
    return '$date $time';

  }

  static String toDate(DateTime dateTime,BuildContext context){
    final date = DateFormat.yMMMEd(context.localizations.localeName).format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime,BuildContext context){
    final time = DateFormat.Hm(context.localizations.localeName).format(dateTime);
    return '$time';
  }

}