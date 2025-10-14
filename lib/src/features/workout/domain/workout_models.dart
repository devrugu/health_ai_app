// lib/src/features/workout/domain/workout_models.dart

// We no longer need the old enums here.

class WorkoutLog {
  final String exerciseName;
  final String category;
  final double metValue;
  final int durationInMinutes;
  final double caloriesBurned;

  WorkoutLog({
    required this.exerciseName,
    required this.category,
    required this.metValue,
    required this.durationInMinutes,
    required this.caloriesBurned,
  });

  // Convert the object to a map for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'exerciseName': exerciseName,
      'category': category,
      'metValue': metValue,
      'durationInMinutes': durationInMinutes,
      'caloriesBurned': caloriesBurned,
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      exerciseName: map['exerciseName'] ?? '',
      category: map['category'] ?? '',
      metValue: (map['metValue'] ?? 0.0).toDouble(),
      durationInMinutes: map['durationInMinutes'] ?? 0,
      caloriesBurned: (map['caloriesBurned'] ?? 0.0).toDouble(),
    );
  }
}
