// lib/src/features/onboarding/presentation/widgets/activity_level_step.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';

class ActivityLevelStep extends StatelessWidget {
  final ActivityLevel? selectedActivityLevel;
  final Function(ActivityLevel) onSelection;

  const ActivityLevelStep({
    super.key,
    required this.selectedActivityLevel,
    required this.onSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('How active are you?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          const Text('This helps us estimate your daily calorie burn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54))
              .animate()
              .fadeIn(delay: 300.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 48),
          ...ActivityLevel.values.asMap().entries.map((entry) {
            final index = entry.key;
            final level = entry.value;
            final isSelected = selectedActivityLevel == level;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: OutlinedButton(
                onPressed: () => onSelection(level),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_getTextForActivityLevel(level)),
                    // Use an AnimatedSwitcher for a smooth icon appearance
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: isSelected
                          ? const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.check_circle, size: 20),
                            )
                          : const SizedBox
                              .shrink(), // Empty box when not selected
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(delay: (400 + index * 100).ms) // Staggered delay
                .slideX(begin: -0.1, end: 0);
          }),
        ],
      ),
    );
  }

  String _getTextForActivityLevel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
    }
  }
}
