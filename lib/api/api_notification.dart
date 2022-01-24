import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ApiNotification {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
    ));
  }

  static Future notificationScheduleDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        icon: 'android_icon',
        importance: Importance.max,
        priority: Priority.max,
        fullScreenIntent: true,
        sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
        largeIcon: DrawableResourceAndroidBitmap('android_icon'),
      ),
      iOS: IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    var android = const AndroidInitializationSettings('android_icon');
    var iOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});
    var settings = InitializationSettings(android: android, iOS: iOS);

    await notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    notifications.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

  Future showScheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    var scheduleNotifDateTime = DateTime.now().add(const Duration(seconds: 5));

    notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleNotifDateTime, tz.local),
      await notificationScheduleDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
