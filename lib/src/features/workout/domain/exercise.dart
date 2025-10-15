// lib/src/features/workout/domain/exercise.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  final String id;
  final String name;
  final String category;
  final double metValue;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.metValue,
  });

  // Factory to create an Exercise from a Firestore document
  factory Exercise.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Exercise(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      metValue: (data['metValue'] ?? 0.0).toDouble(),
    );
  }
}
