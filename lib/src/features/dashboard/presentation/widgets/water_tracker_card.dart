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

  // --- THIS IS THE FIX ---
  // We initialize _selectedCupSize with a default value immediately.
  // We remove the 'late' keyword and the assignment from initState.
  int _selectedCupSize = 250;

  // The initState method is no longer needed for this variable.
  // @override
  // void initState() {
  //   super.initState();
  //   _selectedCupSize = _cupSizes.first; // This line is now removed.
  // }

  void _addWater() {
    setState(() {
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

  double get _visualProgress => min(1.0, _waterConsumedMl / _waterGoalMl);
  double get _actualProgress => _waterConsumedMl / _waterGoalMl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalInLiters = (_waterGoalMl / 1000).toStringAsFixed(1);

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
                Icon(Icons.opacity_rounded, color: progressColor),
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
                  "${(_actualProgress * 100).toInt()}%",
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _visualProgress.isNaN ? 0 : _visualProgress,
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
