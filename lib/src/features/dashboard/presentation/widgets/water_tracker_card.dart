// lib/src/features/dashboard/presentation/widgets/water_tracker_card.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart'; // Import DatabaseService
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/cup_size_selector.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/widgets/water_log_controls.dart';

class WaterTrackerCard extends StatefulWidget {
  final int waterGoalMl;
  // NEW: Add the initial consumed value from the daily log
  final int initialConsumedMl;

  const WaterTrackerCard({
    super.key,
    required this.waterGoalMl,
    required this.initialConsumedMl,
  });

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard> {
  // State is now initialized from the widget's parameters
  late int _waterConsumedMl;
  final List<int> _cupSizes = const [250, 330, 500];
  int _selectedCupSize = 250;
  // NEW: Timer to debounce database writes
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Set the initial state from the value passed in
    _waterConsumedMl = widget.initialConsumedMl;
  }

  // NEW: Debounced database update method
  void _updateWaterLogInDatabase() {
    // If a timer is already active, cancel it
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Start a new timer. The database will only be updated after 500ms of no changes.
    // This prevents writing to the database on every single button tap if the user taps quickly.
    _debounce = Timer(const Duration(milliseconds: 500), () {
      DatabaseService().updateDailyLog({'waterConsumedMl': _waterConsumedMl});
    });
  }

  void _addWater() {
    setState(() {
      _waterConsumedMl = _waterConsumedMl + _selectedCupSize;
    });
    _updateWaterLogInDatabase(); // Call the debounced update
  }

  void _removeWater() {
    setState(() {
      _waterConsumedMl = max(0, _waterConsumedMl - _selectedCupSize);
    });
    _updateWaterLogInDatabase(); // Call the debounced update
  }

  void _onCupSizeChanged(int newSize) {
    setState(() {
      _selectedCupSize = newSize;
    });
  }

  @override
  void dispose() {
    // It's crucial to cancel any active timer when the widget is disposed
    _debounce?.cancel();
    super.dispose();
  }

  double get _visualProgress => min(1.0, _waterConsumedMl / widget.waterGoalMl);
  double get _actualProgress => _waterConsumedMl / widget.waterGoalMl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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