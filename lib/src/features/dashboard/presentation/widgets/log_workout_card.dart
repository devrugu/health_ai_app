// lib/src/features/dashboard/presentation/widgets/log_workout_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/workout/presentation/screens/log_workout_screen.dart';

class LogWorkoutCard extends StatelessWidget {
  // NEW: Add a field to accept the user's weight
  final double userWeightKg;

  const LogWorkoutCard({
    super.key,
    required this.userWeightKg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.tertiaryContainer,
              child: Icon(
                Icons.directions_run_rounded,
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Did you exercise today?",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Log your workout to keep your plan accurate.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(178),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    // UPDATED: Pass the userWeightKg to the LogWorkoutScreen
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
      ),
    );
  }
}
