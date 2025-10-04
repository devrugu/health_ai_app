// lib/src/features/dashboard/presentation/widgets/water_tracker_card.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_log_controls.dart';

class WaterTrackerCard extends StatefulWidget {
  const WaterTrackerCard({super.key});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  // --- STATE VARIABLES ---
  // These will be dynamic in the future, based on user's goal.
  final int _glassesGoal = 8; // e.g., 8 glasses
  final double _goalInLiters = 2.0;

  // This is the core state variable that will be updated.
  int _glassesConsumed = 0;

  // --- STATE METHODS ---
  void _addGlass() {
    // setState is crucial. It tells Flutter to rebuild the widget with the new state.
    if (_glassesConsumed < _glassesGoal) {
      setState(() {
        _glassesConsumed++;
      });
    }
  }

  void _removeGlass() {
    if (_glassesConsumed > 0) {
      setState(() {
        _glassesConsumed--;
      });
    }
  }

  // Helper to calculate the progress for the bar
  double get _progress => _glassesConsumed / _glassesGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.opacity_rounded, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  "Water Intake",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Goal: $_goalInLiters L", // Use our state variable
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  "${(_progress * 100).toInt()}%",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // The progress bar will now update automatically based on _progress
            LinearProgressIndicator(
              value: _progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
              backgroundColor: theme.colorScheme.surface,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            const SizedBox(height: 24),
            // Our new interactive controls
            WaterLogControls(
              glassesConsumed: _glassesConsumed,
              glassesGoal: _glassesGoal,
              onAdd: _addGlass, // Pass the method to the child widget
              onRemove: _removeGlass, // Pass the method to the child widget
            ),
          ],
        ),
      ),
    );
  }
}
