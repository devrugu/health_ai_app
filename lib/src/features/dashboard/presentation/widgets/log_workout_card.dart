// lib/src/features/dashboard/presentation/widgets/log_workout_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/workout/presentation/screens/log_workout_screen.dart'; // Import the new screen

class LogWorkoutCard extends StatelessWidget {
  const LogWorkoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      // FIX 1 & 2: Use the new surfaceContainerHighest and withAlpha properties.
      color: theme.colorScheme.surfaceContainerHighest
          .withAlpha(128), // approx 0.5 opacity
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
                      // FIX 3: Use withAlpha here as well.
                      color: theme.colorScheme.onSurface
                          .withAlpha(178), // approx 0.7 opacity
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
                    builder: (context) => const LogWorkoutScreen(),
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
