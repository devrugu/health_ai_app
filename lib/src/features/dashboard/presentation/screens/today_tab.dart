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

  // The logic is the same, but this will now also be called by the refresh indicator
  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    // We don't set loading to true here, because we want the UI to stay visible during a refresh
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_userProfile == null || _userProfile!.todaysPlan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Today's Plan")),
        // NEW: Add a RefreshIndicator here as well
        body: RefreshIndicator(
          onRefresh: _fetchUserProfile,
          child: ListView(
            // This physics ensures the scroll works even when there's only one item
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 100), // Add some spacing for better layout
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "Your personalized plan is being generated. Pull down to refresh.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    final String displayName = _userProfile!.displayName;
    final plan = _userProfile!.todaysPlan!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Plan"),
      ),
      // NEW: Wrap the main ListView in a RefreshIndicator
      body: RefreshIndicator(
        onRefresh: _fetchUserProfile, // Call our fetch method when the user pulls down
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              "Hello, $displayName!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            DailySummaryCard(
              calorieTarget: plan.dailyCalorieTarget,
              proteinTarget: plan.dailyProteinTarget,
              carbsTarget: plan.dailyCarbsTarget,
              fatTarget: plan.dailyFatTarget,
            ),
            const SizedBox(height: 16),
            WaterTrackerCard(waterGoalMl: plan.dailyWaterTargetMl),
            const SizedBox(height: 24),
            const LogWorkoutCard(),
            const SizedBox(height: 24),
            MealPlanCard(meals: plan.initialMealPlan),
          ].animate(interval: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2),
        ),
      ),
    );
  }
}