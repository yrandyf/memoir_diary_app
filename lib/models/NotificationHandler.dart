import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationHandler {
  static final _notificationHandler = FlutterLocalNotificationsPlugin();

  static final onNotifications = BehaviorSubject<String?>();

  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel Id', 'channel Name',
            importance: Importance.high));
  }

  // Show notificaiton with given string and body.
  static Future showNotificaion(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notificationHandler.show(id, title, body, await notificationDetails(),
          payload: payload);

  // android settings
  static final android = AndroidInitializationSettings('icon');
  static final settings = InitializationSettings(android: android);

  //  routing function
  static Future init({bool initScheduled = false}) async {
    tz.initializeTimeZones();
    // when app is closed.
    final details =
        await _notificationHandler.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }

    await _notificationHandler.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
    final name = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(name));
  }

  // Show SCHEDULED notificaiton with given string adn body.
  static Future showScheduledNotificaion({
    int id = 0,
    String? title = 'Reminder to Write Your Diary',
    String? body = 'How was your day?',
    String? payload,
    required TimeOfDay? scheduledDate,
  }) async =>
      _notificationHandler.zonedSchedule(
        id,
        title,
        body,
        _scheduleDaily(Time(scheduledDate!.hour, scheduledDate.minute)),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 9)),
        await notificationDetails(),
        payload: 'sarah.abs',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    if (scheduledDate.isBefore(now)) {
      print('case1');
      return scheduledDate.add(Duration(days: 1));
    } else {
      print('case2');
      return scheduledDate;
    }
    // return scheduledDate.isBefore(now)
    //     ? scheduledDate.add(Duration(days: 1))
    //     : scheduledDate;
  }
}
