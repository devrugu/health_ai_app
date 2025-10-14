// lib/src/features/dashboard/presentation/screens/today_tab.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart';
import 'package:health_ai_app/src/features/database/domain/daily_log.dart';
import 'package:health_ai_app/src/features/database/domain/user_profile.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/daily_summary_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/meal_plan_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_tracker_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/workout_summary_card.dart'; // Import new card

class TodayTab extends StatefulWidget {
  final bool isWelcomeMessageVisible;
  final VoidCallback onDismissWelcomeMessage;

  const TodayTab({
    super.key,
    required this.isWelcomeMessageVisible,
    required this.onDismissWelcomeMessage,
  });

  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  UserProfile? _userProfile;
  DailyLog? _dailyLog;
  bool _isLoading = true;
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final profileFuture = _dbService.getUserProfile(user.uid);
    final logFuture = _dbService.getDailyLog();
    final results = await Future.wait([profileFuture, logFuture]);
    if (mounted) {
      setState(() {
        _userProfile = results[0] as UserProfile?;
        _dailyLog = results[1] as DailyLog?;
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
      // ... (fallback UI is unchanged)
      return Scaffold(
        appBar: AppBar(title: const Text("Today's Plan")),
        body: RefreshIndicator(
          onRefresh: _fetchData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 100),
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
    final welcomeMessage = plan.welcomeMessage;
    final initialWater = _dailyLog?.waterConsumedMl ?? 0;
    final initialMeals = _dailyLog?.mealsEaten ?? {};
    final loggedWorkouts = _dailyLog?.workouts ?? [];
    // Safely get user weight, with a default fallback
    final userWeight = (_userProfile!.profileData['weight'] ?? 70.0).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Plan"),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (welcomeMessage.isNotEmpty)
              _WelcomeMessageCard(
                message: welcomeMessage,
                isVisible: widget.isWelcomeMessageVisible,
                onDismiss: widget.onDismissWelcomeMessage,
              ),

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
            WaterTrackerCard(
              waterGoalMl: plan.dailyWaterTargetMl,
              initialConsumedMl: initialWater,
            ),
            const SizedBox(height: 24),

            // THIS IS THE CORRECT IMPLEMENTATION.
            // It uses the new summary card and passes the required data.
            // The old LogWorkoutCard is not used here.
            WorkoutSummaryCard(
              loggedWorkouts: loggedWorkouts,
              userWeightKg: userWeight,
            ),

            const SizedBox(height: 24),
            MealPlanCard(
              meals: plan.initialMealPlan,
              initialEatenMeals: initialMeals,
            ),
          ]
              .animate(interval: 200.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.2),
        ),
      ),
    );
  }
}

// ... (Welcome Message Card is unchanged)
class _WelcomeMessageCard extends StatelessWidget {
  final String message;
  final bool isVisible;
  final VoidCallback onDismiss;

  const _WelcomeMessageCard({
    required this.message,
    required this.isVisible,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SizeTransition(sizeFactor: animation, child: child);
      },
      child: isVisible
          ? Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onDismiss,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    )
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
