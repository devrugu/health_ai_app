// lib/src/features/dashboard/presentation/widgets/daily_summary_card.dart

import 'package:flutter/material.dart';

class DailySummaryCard extends StatelessWidget {
  final int calorieTarget;
  final int proteinTarget;
  final int carbsTarget;
  final int fatTarget;

  const DailySummaryCard({
    super.key,
    required this.calorieTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Summary",
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // UPDATED: Use the new parameters
                _BuildMetric(
                  value: calorieTarget.toString(),
                  unit: 'kcal',
                  label: 'Calories',
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                ),
                _BuildMetric(
                  value: proteinTarget.toString(),
                  unit: 'g',
                  label: 'Protein',
                  icon: Icons.egg_rounded,
                  iconColor: Colors.lightBlue,
                ),
                _BuildMetric(
                  value: carbsTarget.toString(),
                  unit: 'g',
                  label: 'Carbs',
                  icon: Icons.rice_bowl_rounded,
                  iconColor: Colors.amber,
                ),
                _BuildMetric(
                  value: fatTarget.toString(),
                  unit: 'g',
                  label: 'Fat',
                  icon: Icons.water_drop_rounded,
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
          backgroundColor: iconColor.withAlpha(51),
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
