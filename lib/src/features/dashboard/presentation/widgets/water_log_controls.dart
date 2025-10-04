// lib/src/features/dashboard/presentation/widgets/water_log_controls.dart

import 'package:flutter/material.dart';

class WaterLogControls extends StatelessWidget {
  final int glassesConsumed;
  final int glassesGoal;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const WaterLogControls({
    super.key,
    required this.glassesConsumed,
    required this.glassesGoal,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Button is disabled if we can't remove more water
    final canRemove = glassesConsumed > 0;
    // Button is disabled if we've already reached the goal
    final canAdd = glassesConsumed < glassesGoal;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // The "Remove" button
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
          ),
          iconSize: 20,
          onPressed: canRemove ? onRemove : null, // Disable if needed
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(width: 24),

        // The text display
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$glassesConsumed',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              TextSpan(
                text: ' / $glassesGoal glasses',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),

        // The "Add" button
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
          ),
          iconSize: 20,
          onPressed: canAdd ? onAdd : null, // Disable if needed
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
