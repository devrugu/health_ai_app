// lib/src/features/onboarding/presentation/widgets/goal_selection_step.dart

import 'package:flutter/material.dart';

class GoalSelectionStep extends StatelessWidget {
  const GoalSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'What is your primary goal?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'We will create a personalized plan to help you achieve it.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 48),

          // Buttons for each goal
          OutlinedButton(onPressed: () {}, child: const Text('Lose Weight')),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: () {}, child: const Text('Gain Weight')),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: () {}, child: const Text('Build Muscle')),
           const SizedBox(height: 16),
          OutlinedButton(onPressed: () {}, child: const Text('Get Fit & Healthy')),
        ],
      ),
    );
  }
}