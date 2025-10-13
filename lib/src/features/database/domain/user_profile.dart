// lib/src/features/database/domain/user_profile.dart

import 'package:health_ai_app/src/features/dashboard/domain/meal_plan_models.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  // NEW: Add the TodaysPlan object
  final TodaysPlan? todaysPlan;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.todaysPlan,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    // Check if the 'todays_plan' map exists in the data and create an object if it does
    final planData = data['todays_plan'] as Map<String, dynamic>?;
    final TodaysPlan? plan =
        planData != null ? TodaysPlan.fromMap(planData) : null;

    return UserProfile(
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? 'User',
      email: data['email'] ?? '',
      todaysPlan: plan,
    );
  }
}
