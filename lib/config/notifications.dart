import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  static const _androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  static const _initSettings = InitializationSettings(android: _androidSettings);
  static const _androidDetails = AndroidNotificationDetails(
    'task_channel',
    'Task Notifications',
    channelDescription: 'Channel for task reminders',
    importance: Importance.max,
    priority: Priority.high,
  );
  static const _notificationDetails = NotificationDetails(android: _androidDetails);

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      var timeZoneName = await FlutterTimezone.getLocalTimezone();
      timeZoneName = timeZoneName == 'Asia/Calcutta' || timeZoneName.isEmpty ? 'Asia/Kolkata' : timeZoneName;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      print('Timezone error: $e, defaulting to Asia/Kolkata');
    }
    await _plugin.initialize(_initSettings);
  }

  Future<bool> _requestExactAlarmPermission(BuildContext? context) async {
    if (await Permission.scheduleExactAlarm.isGranted) {
      return true;
    }
    final status = await Permission.scheduleExactAlarm.request();
    if (status.isGranted) {
      return true;
    }
    if (context != null && status.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text('Please enable exact alarm permissions in settings to schedule task reminders.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate, {
    BuildContext? context,
  }) async {
    if (await _requestExactAlarmPermission(context)) {
      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      print('Exact alarm permission denied, notification not scheduled.');
    }
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}