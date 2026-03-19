import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String medicineName;
  final String dosage;
  final TimeOfDay time;
  final List<int> days; // 1 = Monday, 7 = Sunday
  final DateTime? date;
  final bool isEnabled;

  Reminder({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.time,
    required this.days,
    this.date,
    this.isEnabled = true,
  });

  Reminder copyWith({
    String? id,
    String? medicineName,
    String? dosage,
    TimeOfDay? time,
    List<int>? days,
    DateTime? date,
    bool? isEnabled,
  }) {
    return Reminder(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      days: days ?? this.days,
      date: date ?? this.date,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'hour': time.hour,
      'minute': time.minute,
      'days': days,
      'date': date?.toIso8601String(),
      'isEnabled': isEnabled,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      medicineName: json['medicineName'],
      dosage: json['dosage'],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      days: List<int>.from(json['days']),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      isEnabled: json['isEnabled'],
    );
  }
}
