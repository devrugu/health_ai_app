// lib/src/features/onboarding/presentation/widgets/activity_level_step.dart

import 'package:flutter/material.dart';

class ActivityLevelStep extends StatelessWidget {
  const ActivityLevelStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'How active are you?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This helps us estimate your daily calorie burn.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 48),

          // We will use OutlinedButtons for selection.
          // In a later step, we'll make them selectable.
          OutlinedButton(
            onPressed: () {},
            child: const Text('Sedentary (little or no exercise)'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Lightly Active (1-3 days/week)'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Moderately Active (3-5 days/week)'),
          ),
           const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Very Active (6-7 days/week)'),
          ),
        ],
      ),
    );
  }
}