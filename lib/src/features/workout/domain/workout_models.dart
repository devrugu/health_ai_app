// lib/src/features/workout/domain/workout_models.dart

// We can reuse the preference enum for the type of workout.
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';

// An enum for the intensity of the workout.
enum WorkoutIntensity {
  low,
  medium,
  high,
}

// A class to hold all the details of a logged workout.
class WorkoutLog {
  final ExercisePreference type;
  final int durationInMinutes;
  final WorkoutIntensity intensity;

  WorkoutLog({
    required this.type,
    required this.durationInMinutes,
    required this.intensity,
  });
}
