// lib/src/features/dashboard/presentation/widgets/water_tracker_card.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/cup_size_selector.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_log_controls.dart';

class WaterTrackerCard extends StatefulWidget {
  const WaterTrackerCard({super.key});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  final int _waterGoalMl = 2500;
  int _waterConsumedMl = 0;

  final List<int> _cupSizes = const [250, 330, 500];
  late int _selectedCupSize;

  @override
  void initState() {
    super.initState();
    _selectedCupSize = _cupSizes.first;
  }

  void _addWater() {
    setState(() {
      // --- CHANGE 1: REMOVED THE LIMIT ---
      // The min() function has been removed to allow exceeding the goal.
      _waterConsumedMl = _waterConsumedMl + _selectedCupSize;
    });
  }

  void _removeWater() {
    setState(() {
      _waterConsumedMl = max(0, _waterConsumedMl - _selectedCupSize);
    });
  }

  void _onCupSizeChanged(int newSize) {
    setState(() {
      _selectedCupSize = newSize;
    });
  }

  // Progress is now capped at 1.0 for the VISUAL bar only.
  // The actual data (_waterConsumedMl) can go higher.
  double get _visualProgress => min(1.0, _waterConsumedMl / _waterGoalMl);
  // We need the actual progress for the percentage text.
  double get _actualProgress => _waterConsumedMl / _waterGoalMl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalInLiters = (_waterGoalMl / 1000).toStringAsFixed(1);

    // --- CHANGE 2: VISUAL REWARD ---
    // Determine the color of the progress bar based on whether the goal is met.
    final isGoalMet = _waterConsumedMl >= _waterGoalMl;
    final progressColor = isGoalMet ? Colors.green.shade400 : Colors.blueAccent;

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
                Icon(Icons.opacity_rounded,
                    color: progressColor), // Icon color also updates
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
                  // Use the actual progress for the percentage text
                  "${(_actualProgress * 100).toInt()}%",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Use an AnimatedContainer for a smooth color change transition
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _visualProgress,
                  backgroundColor: theme.colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CupSizeSelector(
              cupSizes: _cupSizes,
              selectedSize: _selectedCupSize,
              onSizeSelected: _onCupSizeChanged,
            ),
            const SizedBox(height: 12),
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
