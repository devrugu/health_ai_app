// lib/src/features/database/domain/daily_log.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_ai_app/src/features/workout/domain/workout_models.dart';

class DailyLog {
  final DateTime date;
  final int waterConsumedMl;
  final Set<String> mealsEaten;
  final WorkoutLog? workout;

  DailyLog({
    required this.date,
    this.waterConsumedMl = 0,
    this.mealsEaten = const {},
    this.workout,
  });

  // UPDATED: toFirestore method is now complete.
  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date), // Use Firestore's Timestamp for dates
      'waterConsumedMl': waterConsumedMl,
      'mealsEaten': mealsEaten.toList(),
      'workout': workout?.toFirestore(),
    };
  }

  // NEW: A factory to create a DailyLog from a Firestore document.
  factory DailyLog.fromFirestore(Map<String, dynamic> data) {
    return DailyLog(
      date: (data['date'] as Timestamp).toDate(),
      waterConsumedMl: data['waterConsumedMl'] ?? 0,
      // Convert the list from Firestore back into a Set.
      mealsEaten: Set<String>.from(data['mealsEaten'] ?? []),
      // We will implement workout fetching later.
      workout: null,
    );
  }
}