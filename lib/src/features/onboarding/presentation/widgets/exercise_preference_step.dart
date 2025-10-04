// lib/src/features/onboarding/presentation/widgets/exercise_preference_step.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';

class ExercisePreferenceStep extends StatelessWidget {
  final ExercisePreference? selectedPreference;
  final Function(ExercisePreference) onSelection;

  const ExercisePreferenceStep({
    super.key,
    required this.selectedPreference,
    required this.onSelection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('What type of exercise do you prefer?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          Text('This helps us recommend suitable activities.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              )).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 48),
          ...ExercisePreference.values.asMap().entries.map((entry) {
            final index = entry.key;
            final preference = entry.value;
            final isSelected = selectedPreference == preference;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: OutlinedButton(
                onPressed: () => onSelection(preference),
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      isSelected ? theme.colorScheme.primaryContainer : null,
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey.shade800,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _getTextForPreference(preference),
                  style: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
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

  String _getTextForPreference(ExercisePreference preference) {
    switch (preference) {
      case ExercisePreference.cardio:
        return 'Cardio (Running, Cycling)';
      case ExercisePreference.strength:
        return 'Strength Training (Weights)';
      case ExercisePreference.flexibility:
        return 'Flexibility & Mind (Yoga, Pilates)';
      case ExercisePreference.mixed:
        return 'A Mix of Everything';
    }
  }
}
