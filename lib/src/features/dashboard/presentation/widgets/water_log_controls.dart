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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          style: IconButton.styleFrom(
            // FIX 1: Use withAlpha
            backgroundColor: theme.colorScheme.errorContainer
                .withAlpha(128), // approx 0.5 opacity
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
                  // FIX 2: Use withAlpha
                  color: theme.colorScheme.onSurface
                      .withAlpha(178), // approx 0.7 opacity
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        IconButton.filled(
          style: IconButton.styleFrom(
            // FIX 3: Use withAlpha
            backgroundColor:
                Colors.green.shade800.withAlpha(178), // approx 0.7 opacity
            foregroundColor: Colors.green.shade200,
          ),
          iconSize: 20,
          onPressed: onAdd,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
