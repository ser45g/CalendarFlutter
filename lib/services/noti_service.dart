import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService{
  static final notificationPlugin = FlutterLocalNotificationsPlugin();


  static bool _isInitialized =false;

  static bool get isInitialized => _isInitialized;


  Future<void> initNotification()async{
    if(_isInitialized)
      return;

    notificationPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    tz.initializeTimeZones();
    final String currentTimeZone= await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    //android setup

    const initSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");

    //ios setup

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,

    );

    //init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS
    );

    //init the plugin
    await notificationPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {

    }, onDidReceiveBackgroundNotificationResponse: (NotificationResponse details){

    });
    _isInitialized=true;
  }

  NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails("calendar_channel_id", "CalendarAndNotes"
          ,channelDescription:"CalendarAndNotesChannel",
        importance: Importance.max,
        priority: Priority.high,

      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({int id =0, String? title, String? body})async{
    print("is init");


    return await notificationPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> periodicNotifications({int id =0, String? title, String? body}){
    return notificationPlugin.periodicallyShow(id, title, body, RepeatInterval.everyMinute, notificationDetails(),androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<void> scheduleNotification({int id =0, String? title, String? body,
    required DateTime time
     })async{
    tz.initializeTimeZones();

    print(await notificationPlugin.getActiveNotifications()??'nothing');

    var scheduleTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: 1));

    print(id);
    
    print("notify");
    print(scheduleTime);
    return await notificationPlugin.zonedSchedule(id,
        title,
        body,
        payload: "hello",
       tz.TZDateTime.from(time,tz.local),
        notificationDetails(),

        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
  }

}