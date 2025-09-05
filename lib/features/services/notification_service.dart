import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../models/alarm_model.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);

    // Create channel
    const channel = AndroidNotificationChannel(
      'alarm_channel',
      'Alarm Notifications',
      description: 'Alarm notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Schedule alarm
  static Future<void> scheduleAlarm(AlarmModel alarm) async {
    DateTime scheduled = alarm.dateTime;
    if (scheduled.isBefore(DateTime.now())) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      alarm.id,
      'Alarm ⏰',
      'Wake up! Your alarm is ringing!',
      tz.TZDateTime.from(scheduled, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarm Notifications',
          channelDescription: 'Alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel a scheduled alarm
  static Future<void> cancelAlarm(int id) async {
    await _plugin.cancel(id);
  }

  /// Immediate notification for alarm OFF
  static Future<void> showAlarmOffNotification(AlarmModel alarm) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    int offId = alarm.id.remainder(100000) + 90000;

    await _plugin.show(
      offId,
      'Alarm Turned Off ⏰',
      'Your alarm for ${alarm.dateTime.hour.toString().padLeft(2,'0')}:${alarm.dateTime.minute.toString().padLeft(2,'0')} has been turned off.',
      notificationDetails,
    );
  }
}
