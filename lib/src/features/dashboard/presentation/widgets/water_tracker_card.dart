// lib/src/features/dashboard/presentation/widgets/water_tracker_card.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/cup_size_selector.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_log_controls.dart';

class WaterTrackerCard extends StatefulWidget {
  // NEW: Add a parameter for the goal
  final int waterGoalMl;

  const WaterTrackerCard({super.key, required this.waterGoalMl});

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  // REMOVED: The hardcoded goal is gone
  int _waterConsumedMl = 0;
  final List<int> _cupSizes = const [250, 330, 500];
  int _selectedCupSize = 250;

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
  
  // UPDATED: Use the widget's waterGoalMl parameter
  double get _visualProgress => min(1.0, _waterConsumedMl / widget.waterGoalMl);
  double get _actualProgress => _waterConsumedMl / widget.waterGoalMl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // UPDATED: Use the widget's waterGoalMl parameter
    final goalInLiters = (widget.waterGoalMl / 1000).toStringAsFixed(1);
    
    final isGoalMet = _waterConsumedMl >= widget.waterGoalMl;
    final progressColor = isGoalMet ? Colors.green.shade400 : Colors.blueAccent;

    return Card(
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
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
                  backgroundColor: theme.colorScheme.surfaceContainer,
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
              // UPDATED: Use the widget's waterGoalMl parameter
              waterGoalMl: widget.waterGoalMl,
              onAdd: _addWater,
              onRemove: _removeWater,
            ),
          ],
        ),
      ),
    );
  }
}