import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../domain/models/reminder.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();
    final String timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Initialize notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click if needed
      },
    );
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    if (!reminder.isEnabled) return;

    final now = tz.TZDateTime.now(tz.local);
    
    // For single date reminder
    if (reminder.date != null) {
      final scheduledDate = tz.TZDateTime.from(reminder.date!, tz.local).add(
        Duration(hours: reminder.time.hour, minutes: reminder.time.minute),
      );

      if (scheduledDate.isAfter(now)) {
        await _scheduleMultipleAlerts(reminder, scheduledDate, 0); // 0 as placeholder for "single date"
      }
      return;
    }

    // For recurring reminders
    for (int day in reminder.days) {
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        reminder.time.hour,
        reminder.time.minute,
      );

      // Adjust to the correct weekday
      while (scheduledDate.weekday != day || scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _scheduleMultipleAlerts(reminder, scheduledDate, day);
    }
  }

  Future<void> _scheduleMultipleAlerts(Reminder reminder, tz.TZDateTime targetDate, int day) async {
    final alerts = [
      {'offset': 0, 'label': 'actual', 'id_offset': 0},
      {'offset': 1, 'label': '1 min before', 'id_offset': 1},
      {'offset': 3, 'label': '3 min before', 'id_offset': 2},
      {'offset': 5, 'label': '5 min before', 'id_offset': 3},
    ];

    for (var alert in alerts) {
      final scheduledTime = targetDate.subtract(Duration(minutes: alert['offset'] as int));
      
      // Don't schedule if the time has already passed
      if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) continue;

      final int notificationId = _generateNotificationId(reminder.id, day, alert['id_offset'] as int);
      
      String body = 'Time to take your ${reminder.medicineName} (${reminder.dosage})';
      if (alert['offset'] != 0) {
        body = '${alert['label']} reminder: $body';
      }

      await _notificationsPlugin.zonedSchedule(
        notificationId,
        'Medicine Reminder',
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medicine_reminders_channel',
            'Medicine Reminders',
            channelDescription: 'Notifications for medicine intake',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: reminder.date != null ? null : DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> cancelReminder(Reminder reminder) async {
    // If it was a single date reminder, we still need to cancel its potential alerts
    // Using 0 as the "day" for single date reminders
    for (int i = 0; i < 4; i++) {
      await _notificationsPlugin.cancel(_generateNotificationId(reminder.id, 0, i));
    }

    for (int day in reminder.days) {
      for (int i = 0; i < 4; i++) {
        await _notificationsPlugin.cancel(_generateNotificationId(reminder.id, day, i));
      }
    }
  }

  int _generateNotificationId(String reminderId, int day, int alertOffset) {
    // Unique ID generation per reminder, per day, and per alert type
    return (reminderId.hashCode + (day * 10) + alertOffset).abs();
  }
}
