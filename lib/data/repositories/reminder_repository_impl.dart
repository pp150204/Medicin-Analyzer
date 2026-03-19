import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  static const String _key = 'medicine_reminders';

  @override
  Future<List<Reminder>> getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Reminder.fromJson(json)).toList();
  }

  @override
  Future<void> saveReminder(Reminder reminder) async {
    final reminders = await getReminders();
    reminders.add(reminder);
    await _saveToPrefs(reminders);
  }

  @override
  Future<void> deleteReminder(String id) async {
    final reminders = await getReminders();
    reminders.removeWhere((r) => r.id == id);
    await _saveToPrefs(reminders);
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    final reminders = await getReminders();
    final index = reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      reminders[index] = reminder;
      await _saveToPrefs(reminders);
    }
  }

  Future<void> _saveToPrefs(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(reminders.map((r) => r.toJson()).toList());
    await prefs.setString(_key, data);
  }
}
