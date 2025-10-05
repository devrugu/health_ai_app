// lib/src/features/onboarding/presentation/widgets/goal_selection_step.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';

class GoalSelectionStep extends StatelessWidget {
  final Goal? selectedGoal;
  final Function(Goal) onSelection;

  const GoalSelectionStep({
    super.key,
    required this.selectedGoal,
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
          const Text('What is your primary goal?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          Text(
                  'We will create a personalized plan to help you achieve it.', // <-- Not a const
                  textAlign: TextAlign.center,
                  // --- CORRECTED ---
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(178)))
              .animate()
              .fadeIn(delay: 300.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 48),
          ...Goal.values.asMap().entries.map((entry) {
            final index = entry.key;
            final goal = entry.value;
            final isSelected = selectedGoal == goal;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: OutlinedButton(
                onPressed: () => onSelection(goal),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade800,
                      width: 1.5),
                ),
                child: Text(
                  _getTextForGoal(goal),
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

  String _getTextForGoal(Goal goal) {
    switch (goal) {
      case Goal.loseWeight:
        return 'Lose Weight';
      case Goal.gainWeight:
        return 'Gain Weight';
      case Goal.buildMuscle:
        return 'Build Muscle';
      case Goal.getFit:
        return 'Get Fit & Healthy';
    }
  }
}
