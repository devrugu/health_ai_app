// lib/src/features/dashboard/presentation/screens/dashboard_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart';
import 'package:health_ai_app/src/features/database/domain/user_profile.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/daily_summary_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/log_workout_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/meal_plan_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_tracker_card.dart';

// CONVERTED TO A STATEFUL WIDGET
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // --- STATE VARIABLES ---
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch the user's data when the screen is first loaded
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final profile = await DatabaseService().getUserProfile(user.uid);
    if (mounted) {
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading spinner while data is being fetched
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Determine the name to display
    final String displayName = _userProfile?.displayName ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Plan"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // UPDATED: Display the user's name
          Text(
            "Hello, $displayName!",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 24),
          const DailySummaryCard()
              .animate()
              .fadeIn(delay: 500.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 16),
          const WaterTrackerCard()
              .animate()
              .fadeIn(delay: 700.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 24),

          const LogWorkoutCard()
              .animate()
              .fadeIn(delay: 900.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 24),

          const MealPlanCard()
              .animate()
              .fadeIn(delay: 1100.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
