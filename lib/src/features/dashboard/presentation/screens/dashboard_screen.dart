// lib/src/features/dashboard/presentation/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/daily_summary_card.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_tracker_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Plan"),
        automaticallyImplyLeading: false,
      ),
      // We use a ListView to allow scrolling if more cards are added later.
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Greet the user
          Text(
            "Hello, User!", // We can personalize this later
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 24),

          // Add the daily summary card
          const DailySummaryCard()
              .animate()
              .fadeIn(delay: 500.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 16),

          // Add the water tracker card
          const WaterTrackerCard()
              .animate()
              .fadeIn(delay: 700.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0),

          // We will add the meal plan card here in the next step.
        ],
      ),
    );
  }
}
