// lib/src/features/dashboard/presentation/widgets/daily_summary_card.dart

import 'package:flutter/material.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      // Use a slightly different color from the scaffold for emphasis
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric(
                  context,
                  value: '1,850',
                  unit: 'kcal',
                  label: 'Calories',
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                ),
                _buildMetric(
                  context,
                  value: '120',
                  unit: 'g',
                  label: 'Protein',
                  icon: Icons.egg,
                  iconColor: Colors.lightBlue,
                ),
                _buildMetric(
                  context,
                  value: '150',
                  unit: 'g',
                  label: 'Carbs',
                  icon: Icons.rice_bowl,
                  iconColor: Colors.amber,
                ),
                _buildMetric(
                  context,
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

  // Helper widget to build each metric item consistently
  Widget _buildMetric(
    BuildContext context, {
    required String value,
    required String unit,
    required String label,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
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
