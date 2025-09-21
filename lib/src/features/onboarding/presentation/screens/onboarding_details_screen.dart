// lib/src/features/onboarding/presentation/screens/onboarding_details_screen.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/metric_input_step.dart'; // Make sure this path is correct

class OnboardingDetailsScreen extends StatefulWidget {
  const OnboardingDetailsScreen({super.key});

  @override
  State<OnboardingDetailsScreen> createState() => _OnboardingDetailsScreenState();
}

class _OnboardingDetailsScreenState extends State<OnboardingDetailsScreen> {
  // A controller to manage the pages in the PageView
  final PageController _pageController = PageController();
  
  // A list of all our question widgets (steps)
  // For now, it only has one step. We will add more later.
  final List<Widget> _onboardingSteps = [
    const MetricInputStep(),
    // We can add more steps here like:
    // const GoalSelectionStep(),
    // const ActivityLevelStep(),
  ];

  @override
  void dispose() {
    _pageController.dispose(); // Clean up the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title in the top bar
        title: const Text('Your Details'),
        // A back button is automatically added by Flutter
      ),
      body: PageView(
        controller: _pageController,
        // This disables swiping. We want users to use the buttons.
        physics: const NeverScrollableScrollPhysics(),
        children: _onboardingSteps,
      ),
      // Bottom navigation bar for the next/finish buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 48),
        child: ElevatedButton(
          onPressed: () {
            // Logic to move to the next page or finish
            print('Next / Finish button pressed');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Next'), // This text will change on the last page
        ),
      ),
    );
  }
}