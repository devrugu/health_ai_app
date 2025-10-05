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
          Text(
              'This helps us estimate your daily calorie burn.', // <-- Not a const
              textAlign: TextAlign.center,
              // --- CORRECTED ---
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
              )).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0),
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
                        : Colors.grey.shade800,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _getTextForActivityLevel(level),
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: (400 + index * 100).ms)
                .slideX(begin: -0.1, end: 0);
          }),
        ],
      ),
    );
  }

  String _getTextForActivityLevel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary (little or no exercise)';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active (1-3 days/week)';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active (3-5 days/week)';
      case ActivityLevel.veryActive:
        return 'Very Active (6-7 days/week)';
    }
  }
}
