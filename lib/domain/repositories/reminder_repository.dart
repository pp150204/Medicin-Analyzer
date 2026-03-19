import '../models/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getReminders();
  Future<void> saveReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
  Future<void> updateReminder(Reminder reminder);
}
