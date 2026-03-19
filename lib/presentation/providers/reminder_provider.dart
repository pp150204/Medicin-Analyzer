import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/reminder.dart';
import '../../data/repositories/reminder_repository_impl.dart';
import '../../data/services/notification_service.dart';

final reminderRepositoryProvider = Provider((ref) => ReminderRepositoryImpl());
final notificationServiceProvider = Provider((ref) => NotificationService());

final reminderProvider = StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return ReminderNotifier(repository, notificationService);
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  final ReminderRepositoryImpl _repository;
  final NotificationService _notificationService;

  ReminderNotifier(this._repository, this._notificationService) : super([]) {
    loadReminders();
  }

  Future<void> loadReminders() async {
    state = await _repository.getReminders();
  }

  Future<void> addReminder(Reminder reminder) async {
    state = [...state, reminder];
    await _repository.saveReminder(reminder);
    await _notificationService.scheduleReminder(reminder);
  }

  Future<void> updateReminder(Reminder reminder) async {
    // Cancel old notifications first
    final oldReminder = state.firstWhere((r) => r.id == reminder.id);
    await _notificationService.cancelReminder(oldReminder);
    
    // Update state locally
    state = [
      for (final r in state)
        if (r.id == reminder.id) reminder else r
    ];

    await _repository.updateReminder(reminder);
    if (reminder.isEnabled) {
      await _notificationService.scheduleReminder(reminder);
    }
  }

  Future<void> deleteReminder(String id) async {
    final reminder = state.firstWhere((r) => r.id == id);
    await _notificationService.cancelReminder(reminder);
    
    state = state.where((r) => r.id != id).toList();
    await _repository.deleteReminder(id);
  }

  Future<void> toggleReminder(String id) async {
    final index = state.indexWhere((r) => r.id == id);
    if (index != -1) {
      final reminder = state[index];
      final updatedReminder = reminder.copyWith(isEnabled: !reminder.isEnabled);
      
      state = [
        for (final r in state)
          if (r.id == id) updatedReminder else r
      ];

      if (updatedReminder.isEnabled) {
        await _notificationService.scheduleReminder(updatedReminder);
      } else {
        await _notificationService.cancelReminder(reminder);
      }
      
      await _repository.updateReminder(updatedReminder);
    }
  }
}
