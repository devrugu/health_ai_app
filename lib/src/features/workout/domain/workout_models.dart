// lib/src/features/workout/domain/workout_models.dart

import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';

enum WorkoutIntensity {
  low,
  medium,
  high,
}

class WorkoutLog {
  final ExercisePreference type;
  final int durationInMinutes;
  final WorkoutIntensity intensity;

  WorkoutLog({
    required this.type,
    required this.durationInMinutes,
    required this.intensity,
  });

  // NEW: A method to convert the object to a map for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name, // Save enums as strings
      'durationInMinutes': durationInMinutes,
      'intensity': intensity.name,
    };
  }
}