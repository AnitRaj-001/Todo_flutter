import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  static const _androidSettings = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  static const _initSettings = InitializationSettings(
    android: _androidSettings,
  );
  static const _androidDetails = AndroidNotificationDetails(
    'task_channel',
    'Task Notifications',
    channelDescription: 'Channel for task reminders',
    importance: Importance.max,
    priority: Priority.high,
  );
  static const _notificationDetails = NotificationDetails(
    android: _androidDetails,
  );

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      var timeZoneName = await FlutterTimezone.getLocalTimezone();
      timeZoneName = timeZoneName == 'Asia/Calcutta' || timeZoneName.isEmpty
          ? 'Asia/Kolkata'
          : timeZoneName;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      print('Timezone error: $e, defaulting to Asia/Kolkata');
    }
    await _plugin.initialize(_initSettings);
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      _notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
