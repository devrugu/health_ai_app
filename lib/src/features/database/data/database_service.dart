// lib/src/features/database/data/database_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';
import 'package:health_ai_app/src/features/database/domain/user_profile.dart';

class DatabaseService {
  // Get an instance of the Firestore database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Profile ---

  /// Creates a new user profile document in Firestore after they complete onboarding.
  Future<void> createUserProfile({
    required User user,
    required double height,
    required double weight,
    required ActivityLevel activityLevel,
    required Goal goal,
    required ExercisePreference exercisePreference,
  }) async {
    try {
      // Create a reference to a new document in the 'users' collection
      // The document will have the same ID as the authenticated user's UID.
      final userDocRef = _db.collection('users').doc(user.uid);

      // We will also store some basic info from the auth provider
      final String? displayName = user.displayName;
      final String? email = user.email;

      // Create a map of the data we want to save
      final userData = {
        'uid': user.uid,
        'displayName': displayName ?? 'New User',
        'email': email,
        'createdAt':
            FieldValue.serverTimestamp(), // Use server time for consistency
        'profileData': {
          'height': height,
          'weight': weight,
          // Store enums as strings for readability in the database
          'activityLevel': activityLevel.name,
          'goal': goal.name,
          'exercisePreference': exercisePreference.name,
        }
      };

      // Set the data for the new document
      await userDocRef.set(userData);
    } catch (e) {
      // It's good practice to re-throw errors to be handled by the UI
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
      print('Error getting user profile: $e');
      return null;
    }
  }
}
