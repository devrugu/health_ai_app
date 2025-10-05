// lib/src/features/dashboard/presentation/widgets/daily_summary_card.dart

import 'package:flutter/material.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Summary",
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // A row for the main metrics
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BuildMetric(
                  value: '1,850',
                  unit: 'kcal',
                  label: 'Calories',
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                ),
                _BuildMetric(
                  value: '120',
                  unit: 'g',
                  label: 'Protein',
                  icon: Icons.egg,
                  iconColor: Colors.lightBlue,
                ),
                _BuildMetric(
                  value: '150',
                  unit: 'g',
                  label: 'Carbs',
                  icon: Icons.rice_bowl,
                  iconColor: Colors.amber,
                ),
                _BuildMetric(
                  value: '60',
                  unit: 'g',
                  label: 'Fat',
                  icon: Icons.water_drop, // Placeholder icon
                  iconColor: Colors.greenAccent,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Helper widget to build each metric item consistently
// Converted to a private stateless widget for better practice and const correctness
class _BuildMetric extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _BuildMetric({
    required this.value,
    required this.unit,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          // FIX 3: Use withAlpha here as well.
          backgroundColor: iconColor.withAlpha(51), // approx 0.2 opacity
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' $unit',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
