// lib/src/features/dashboard/presentation/widgets/workout_summary_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/workout/domain/workout_models.dart';
import 'package:health_ai_app/src/features/workout/presentation/screens/log_workout_screen.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final List<WorkoutLog> loggedWorkouts;
  final double userWeightKg;
  // NEW: Add a callback function parameter
  final VoidCallback onWorkoutLogged;

  const WorkoutSummaryCard({
    super.key,
    required this.loggedWorkouts,
    required this.userWeightKg,
    required this.onWorkoutLogged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCaloriesBurned = loggedWorkouts.fold(
      0.0,
      (sum, workout) => sum + workout.caloriesBurned,
    );

    return Card(
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Workouts",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LogWorkoutScreen(userWeightKg: userWeightKg),
                        fullscreenDialog: true,
                      ),
                    );
                    // If the result is true, call the callback function.
                    if (result == true) {
                      onWorkoutLogged();
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Total Burned: ${totalCaloriesBurned.toStringAsFixed(0)} kcal",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(178),
              ),
            ),
            const Divider(height: 24),
            if (loggedWorkouts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("No workouts logged yet for today."),
                ),
              )
            else
              ...loggedWorkouts.map((log) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.fitness_center),
                    title: Text(log.exerciseName),
                    subtitle: Text("${log.durationInMinutes} minutes"),
                    trailing:
                        Text("${log.caloriesBurned.toStringAsFixed(0)} kcal"),
                  )),
          ],
        ),
      ),
    );
  }
}
