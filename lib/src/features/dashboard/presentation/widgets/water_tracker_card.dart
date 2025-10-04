// lib/src/features/dashboard/presentation/widgets/water_tracker_card.dart

import 'dart:math'; // We need this for the min() and max() functions
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/cup_size_selector.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_log_controls.dart';

class WaterTrackerCard extends StatefulWidget {
  const WaterTrackerCard({super.key});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  // --- STATE VARIABLES (Now using Milliliters) ---
  final int _waterGoalMl = 2500; // 2.5 Liters
  int _waterConsumedMl = 0;

  // State for the cup selector
  final List<int> _cupSizes = const [250, 330, 500];
  late int _selectedCupSize; // 'late' because it's initialized in initState

  @override
  void initState() {
    super.initState();
    // Set the default selected cup size when the widget is first created.
    _selectedCupSize = _cupSizes.first;
  }

  // --- STATE METHODS (Updated for mL) ---
  void _addWater() {
    setState(() {
      // Add the selected cup size, ensuring it doesn't exceed the goal.
      _waterConsumedMl = min(_waterGoalMl, _waterConsumedMl + _selectedCupSize);
    });
  }

  void _removeWater() {
    setState(() {
      // Remove the selected cup size, ensuring it doesn't go below zero.
      _waterConsumedMl = max(0, _waterConsumedMl - _selectedCupSize);
    });
  }

  void _onCupSizeChanged(int newSize) {
    setState(() {
      _selectedCupSize = newSize;
    });
  }

  // Helper to calculate the progress for the bar
  double get _progress => _waterConsumedMl / _waterGoalMl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Convert goal to a string in Liters for display
    final goalInLiters = (_waterGoalMl / 1000).toStringAsFixed(1);

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
                  "Goal: $goalInLiters L",
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
            LinearProgressIndicator(
              value:
                  _progress.isNaN ? 0 : _progress, // Handle potential 0/0 case
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
              backgroundColor: theme.colorScheme.surface,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            const SizedBox(height: 20),

            // Our new cup size selector widget
            CupSizeSelector(
              cupSizes: _cupSizes,
              selectedSize: _selectedCupSize,
              onSizeSelected: _onCupSizeChanged,
            ),
            const SizedBox(height: 12),

            // Our restyled and updated controls
            WaterLogControls(
              waterConsumedMl: _waterConsumedMl,
              waterGoalMl: _waterGoalMl,
              onAdd: _addWater,
              onRemove: _removeWater,
            ),
          ],
        ),
      ),
    );
  }
}
