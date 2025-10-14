// lib/src/features/database/domain/user_profile.dart

import 'package:health_ai_app/src/features/dashboard/domain/meal_plan_models.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final TodaysPlan? todaysPlan;
  // NEW: Add the profile data map
  final Map<String, dynamic> profileData;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.todaysPlan,
    this.profileData = const {}, // Default to an empty map
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    final planData = data['todays_plan'] as Map<String, dynamic>?;
    final TodaysPlan? plan =
        planData != null ? TodaysPlan.fromMap(planData) : null;

    return UserProfile(
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? 'User',
      email: data['email'] ?? '',
      todaysPlan: plan,
      // NEW: Parse the profile data from Firestore
      profileData: data['profileData'] as Map<String, dynamic>? ?? {},
    );
  }
}
