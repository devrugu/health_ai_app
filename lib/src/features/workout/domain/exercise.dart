// lib/src/features/workout/domain/exercise.dart

class Exercise {
  final String name;
  final String category;
  final double metValue; // Metabolic Equivalent of Task

  const Exercise({
    required this.name,
    required this.category,
    required this.metValue,
  });
}

// Our initial library of curated exercises. This can be expanded easily.
const List<Exercise> exerciseLibrary = [
  // Cardio
  Exercise(name: 'Running (Moderate)', category: 'Cardio', metValue: 9.8),
  Exercise(name: 'Cycling (Moderate)', category: 'Cardio', metValue: 7.5),
  Exercise(name: 'Swimming (Freestyle)', category: 'Cardio', metValue: 9.5),
  Exercise(name: 'Jump Rope', category: 'Cardio', metValue: 11.8),

  // Strength
  Exercise(
      name: 'Weightlifting (Vigorous)', category: 'Strength', metValue: 6.0),
  Exercise(name: 'Bodyweight (Vigorous)', category: 'Strength', metValue: 8.0),
  Exercise(
      name: 'Calisthenics (Moderate)', category: 'Strength', metValue: 3.8),

  // Flexibility & Mind
  Exercise(name: 'Yoga (Hatha)', category: 'Flexibility & Mind', metValue: 2.5),
  Exercise(name: 'Stretching', category: 'Flexibility & Mind', metValue: 2.3),
  Exercise(name: 'Pilates', category: 'Flexibility & Mind', metValue: 3.0),
];
