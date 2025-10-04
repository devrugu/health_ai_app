// lib/src/features/dashboard/presentation/widgets/log_workout_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/workout/presentation/screens/log_workout_screen.dart'; // Import the new screen

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
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // --- UPDATED BUTTON LOGIC ---
            ElevatedButton(
              onPressed: () {
                // Navigate to the LogWorkoutScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LogWorkoutScreen(),
                    // This makes the screen slide up from the bottom, a common UX pattern for forms.
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
