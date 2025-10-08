// lib/src/features/dashboard/presentation/screens/today_tab.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart';
import 'package:health_ai_app/src/features/database/domain/user_profile.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/daily_summary_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/log_workout_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/meal_plan_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_tracker_card.dart';

class TodayTab extends StatefulWidget {
  const TodayTab({super.key});

  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final String displayName = _userProfile?.displayName ?? 'User';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Plan"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            "Hello, $displayName!",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          const DailySummaryCard(),
          const SizedBox(height: 16),
          const WaterTrackerCard(),
          const SizedBox(height: 24),
          const LogWorkoutCard(),
          const SizedBox(height: 24),
          const MealPlanCard(),
        ].animate(interval: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2),
      ),
    );
  }
}
