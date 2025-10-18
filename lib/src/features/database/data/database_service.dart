// lib/src/features/database/data/database_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';
import 'package:health_ai_app/src/features/database/domain/user_profile.dart';
import 'package:health_ai_app/src/features/database/domain/daily_log.dart';
import 'package:health_ai_app/src/features/workout/domain/workout_models.dart';
import 'package:health_ai_app/src/features/workout/domain/exercise.dart';

class DatabaseService {
  // Get an instance of the Firestore database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Profile ---
  /// Creates a new user profile document in Firestore after they complete onboarding.
  Future<void> createUserProfile({
    required User user,
    required double height,
    required double weight,
    required int age,
    required Gender gender,
    required ActivityLevel activityLevel,
    required Goal goal,
    required ExercisePreference exercisePreference,
    String? country,
    Budget? budget,
  }) async {
    try {
      final userDocRef = _db.collection('users').doc(user.uid);
      final String? displayName = user.displayName;
      final String? email = user.email;
      final userData = {
        'uid': user.uid,
        'displayName': displayName ?? 'New User',
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'profileData': {
          'height': height,
          'weight': weight,
          'age': age,
          'gender': gender.name,
          'activityLevel': activityLevel.name,
          'goal': goal.name,
          'exercisePreference': exercisePreference.name,
          'country': country,
          'budget': budget?.name,
        }
      };
      await userDocRef.set(userData);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user profile: $e');
      }
      throw Exception('Could not create user profile.');
    }
  }

  Future<bool> doesProfileExist(String uid) async {
    try {
      final userDocRef = _db.collection('users').doc(uid);
      final docSnapshot = await userDocRef.get();
      return docSnapshot.exists;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking for profile: $e');
      }
      // In case of error, we assume profile doesn't exist to be safe.
      return false;
    }
  }

  /// Fetches a user's profile from Firestore and returns it as a UserProfile object.
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final userDocRef = _db.collection('users').doc(uid);
      final docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
        // If the document exists, convert it to a UserProfile object
        return UserProfile.fromFirestore(docSnapshot.data()!);
      } else {
        // If the document doesn't exist, return null
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user profile: $e');
      }
      return null;
    }
  }

  /// Helper to get the document ID for the current day in a 'YYYY-MM-DD' format.
  String _getDailyLogId() {
    final now = DateTime.now();
    // Example: 2025-10-14
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  /// Updates or creates a daily log for the current user.
  /// Uses SetOptions(merge: true) to only update the fields provided,
  /// without overwriting the entire document. This is crucial.
  Future<void> updateDailyLog(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final logId = _getDailyLogId();
    final logDocRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('daily_logs')
        .doc(logId);

    // Add the current date to the data if it's not already there
    data['date'] = FieldValue.serverTimestamp();

    try {
      // Set with merge option will create the document if it doesn't exist,
      // or update it with the new data if it does.
      await logDocRef.set(data, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Error updating daily log: $e');
      }
      throw Exception('Could not update daily log.');
    }
  }

  /// Fetches the daily log for the current day.
  Future<DailyLog?> getDailyLog() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final logId = _getDailyLogId();
    final logDocRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('daily_logs')
        .doc(logId);

    final docSnapshot = await logDocRef.get();
    if (docSnapshot.exists) {
      return DailyLog.fromFirestore(docSnapshot.data()!);
    } else {
      // If no log exists for today, return null
      return null;
    }
  }

  Future<void> logWorkout(WorkoutLog workout) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final logId = _getDailyLogId();
    final logDocRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('daily_logs')
        .doc(logId);

    try {
      final logData = {
        'date': FieldValue.serverTimestamp(),
        'workouts': FieldValue.arrayUnion([workout.toFirestore()])
      };

      await logDocRef.set(logData, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Error logging workout: $e');
      }
      throw Exception('Could not log workout.');
    }
  }

  Future<List<Exercise>> getExerciseLibrary() async {
    try {
      final snapshot = await _db.collection('exercises').get();
      // Map each document to an Exercise object
      return snapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching exercise library: $e');
      }
      return []; // Return an empty list in case of error
    }
  }
}
