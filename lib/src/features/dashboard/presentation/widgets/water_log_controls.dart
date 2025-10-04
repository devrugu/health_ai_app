// lib/src/features/dashboard/presentation/widgets/water_log_controls.dart

import 'package:flutter/material.dart';

class WaterLogControls extends StatelessWidget {
  final int waterConsumedMl;
  final int waterGoalMl;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const WaterLogControls({
    super.key,
    required this.waterConsumedMl,
    required this.waterGoalMl,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canRemove = waterConsumedMl > 0;
    // --- CHANGE: The '+' button can now always be used ---
    // final canAdd = waterConsumedMl < waterGoalMl; <-- This line is removed

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.5),
            foregroundColor: theme.colorScheme.onErrorContainer,
          ),
          iconSize: 20,
          onPressed: canRemove ? onRemove : null,
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(width: 24),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$waterConsumedMl',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              TextSpan(
                text: ' / ${waterGoalMl}ml',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: Colors.green.shade800.withOpacity(0.7),
            foregroundColor: Colors.green.shade200,
          ),
          iconSize: 20,
          onPressed: onAdd, // No longer checks `canAdd`
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
