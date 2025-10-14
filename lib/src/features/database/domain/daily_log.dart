// lib/src/features/database/domain/daily_log.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_ai_app/src/features/workout/domain/workout_models.dart';

class DailyLog {
  final DateTime date;
  final int waterConsumedMl;
  final Set<String> mealsEaten;
  // UPDATED: This is now a list of WorkoutLog objects.
  final List<WorkoutLog> workouts;

  DailyLog({
    required this.date,
    this.waterConsumedMl = 0,
    this.mealsEaten = const {},
    this.workouts = const [], // Default to an empty list
  });

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'waterConsumedMl': waterConsumedMl,
      'mealsEaten': mealsEaten.toList(),
      // UPDATED: Convert each WorkoutLog in the list to a map.
      'workouts': workouts.map((workout) => workout.toFirestore()).toList(),
    };
  }

  factory DailyLog.fromFirestore(Map<String, dynamic> data) {
    // NEW: Logic to parse the list of workouts
    List<WorkoutLog> workouts = [];
    if (data['workouts'] != null) {
      workouts = (data['workouts'] as List<dynamic>).map((workoutData) {
        // We need a factory for WorkoutLog as well
        return WorkoutLog.fromMap(workoutData);
      }).toList();
    }

    return DailyLog(
      date: (data['date'] as Timestamp).toDate(),
      waterConsumedMl: data['waterConsumedMl'] ?? 0,
      mealsEaten: Set<String>.from(data['mealsEaten'] ?? []),
      workouts: workouts,
    );
  }
}
