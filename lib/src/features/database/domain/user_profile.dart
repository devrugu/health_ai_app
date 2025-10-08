// lib/src/features/database/domain/user_profile.dart

// A model class to hold the user's profile data, converted from Firestore.
class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  // We can add the other profile data fields here later when we need them.

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
  });

  // A factory constructor to create a UserProfile from a Firestore document.
  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? 'User',
      email: data['email'] ?? '',
    );
  }
}
