// lib/src/features/dashboard/presentation/widgets/log_workout_card.dart

import 'package:flutter/material.dart';

class LogWorkoutCard extends StatelessWidget {
  const LogWorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon for visual representation
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.tertiaryContainer,
              child: Icon(
                Icons.directions_run_rounded,
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            // Text content
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
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // The action button
            ElevatedButton(
              onPressed: () {
                // In the next step, this will open a new screen.
                print("Log Workout button pressed!");
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
