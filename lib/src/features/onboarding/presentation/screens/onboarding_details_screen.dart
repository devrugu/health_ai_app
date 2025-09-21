// lib/src/features/onboarding/presentation/screens/onboarding_details_screen.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/metric_input_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/activity_level_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/goal_selection_step.dart';

class OnboardingDetailsScreen extends StatefulWidget {
  const OnboardingDetailsScreen({super.key});

  @override
  State<OnboardingDetailsScreen> createState() => _OnboardingDetailsScreenState();
}

class _OnboardingDetailsScreenState extends State<OnboardingDetailsScreen> {
  final PageController _pageController = PageController();
  
  // NEW: A variable to keep track of the current page index
  int _currentPageIndex = 0;

  // NEW: Update the list to include all our new steps
  final List<Widget> _onboardingSteps = [
    const MetricInputStep(),
    const ActivityLevelStep(),
    const GoalSelectionStep(),
  ];

  @override
  void initState() {
    super.initState();
    // NEW: Add a listener to the page controller to update our index variable
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NEW: Determine if the current page is the last one
    final isLastPage = _currentPageIndex == _onboardingSteps.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Details'),
        // NEW: Add a progress indicator in the app bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentPageIndex + 1) / _onboardingSteps.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        // The user can no longer swipe to change pages
        physics: const NeverScrollableScrollPhysics(), 
        children: _onboardingSteps,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 48),
        child: ElevatedButton(
          onPressed: () {
            // NEW: Logic to navigate or finish
            if (isLastPage) {
              // This is the finish button
              print('Onboarding complete!');
              // Later, we will navigate to the main app dashboard here.
            } else {
              // This is the next button
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          // NEW: Change the button text based on the current page
          child: Text(isLastPage ? 'Finish' : 'Next'),
        ),
      ),
    );
  }
}