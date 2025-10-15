// lib/src/features/dashboard/presentation/widgets/workout_summary_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/workout/domain/workout_models.dart';
import 'package:health_ai_app/src/features/workout/presentation/screens/log_workout_screen.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final List<WorkoutLog> loggedWorkouts;
  // We need the user's weight to pass it to the LogWorkoutScreen
  final double userWeightKg;

  const WorkoutSummaryCard({
    super.key,
    required this.loggedWorkouts,
    required this.userWeightKg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Calculate the total calories burned from all logged workouts
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
                // The button to add a new workout
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LogWorkoutScreen(userWeightKg: userWeightKg),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Display the total calories burned
            Text(
              "Total Burned: ${totalCaloriesBurned.toStringAsFixed(0)} kcal",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(178),
              ),
            ),
            const Divider(height: 24),
            // If no workouts are logged, show a prompt. Otherwise, show the list.
            if (loggedWorkouts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("No workouts logged yet for today."),
                ),
              )
            else
              // Create a list of compact tiles for each logged workout
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
