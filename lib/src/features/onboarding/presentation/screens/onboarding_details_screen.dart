// lib/src/features/onboarding/presentation/screens/onboarding_details_screen.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/activity_level_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/exercise_preference_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/goal_selection_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/metric_input_step.dart';

class OnboardingDetailsScreen extends StatefulWidget {
  const OnboardingDetailsScreen({super.key});

  @override
  State<OnboardingDetailsScreen> createState() =>
      _OnboardingDetailsScreenState();
}

class _OnboardingDetailsScreenState extends State<OnboardingDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // --- STATE VARIABLES ---
  double? _height;
  double? _weight;
  ActivityLevel? _activityLevel;
  Goal? _goal;
  ExercisePreference? _exercisePreference;

  late final List<Widget> _onboardingSteps; // We keep this for the total count

  @override
  void initState() {
    super.initState();
    // We only need the count here now. The widgets will be built on-the-fly.
    _onboardingSteps = [
      Container(), // Placeholder for MetricInputStep
      Container(), // Placeholder for ActivityLevelStep
      Container(), // Placeholder for GoalSelectionStep
      Container(), // Placeholder for ExercisePreferenceStep
    ];

    _pageController.addListener(() {
      final newIndex = _pageController.page?.round();
      if (newIndex != null && newIndex != _currentPageIndex) {
        setState(() {
          _currentPageIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_isCurrentPageValid()) {
      if (_currentPageIndex < _onboardingSteps.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
      } else {
        print(
            'Onboarding complete! Data: Height: $_height, Weight: $_weight, Activity: $_activityLevel, Goal: $_goal, Exercise: $_exercisePreference');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  void _handleBack() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuad,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  bool _isCurrentPageValid() {
    switch (_currentPageIndex) {
      case 0:
        return _height != null &&
            _height! > 50 &&
            _weight != null &&
            _weight! > 20;
      case 1:
        return _activityLevel != null;
      case 2:
        return _goal != null;
      case 3:
        return _exercisePreference != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPageIndex == _onboardingSteps.length - 1;
    final isPageValid = _isCurrentPageValid();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          title: const Text('Your Details'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: (_currentPageIndex + 1) / _onboardingSteps.length,
            ),
          ),
        ),
        // --- THIS IS THE CORRECTED IMPLEMENTATION ---
        body: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _onboardingSteps.length,
          itemBuilder: (context, index) {
            // By building the widgets here, we ensure they are always created
            // with the most up-to-date state variables.
            switch (index) {
              case 0:
                return MetricInputStep(
                  onHeightChanged: (value) =>
                      setState(() => _height = double.tryParse(value)),
                  onWeightChanged: (value) =>
                      setState(() => _weight = double.tryParse(value)),
                );
              case 1:
                return ActivityLevelStep(
                  selectedActivityLevel: _activityLevel,
                  onSelection: (level) =>
                      setState(() => _activityLevel = level),
                );
              case 2:
                return GoalSelectionStep(
                  selectedGoal: _goal,
                  onSelection: (goal) => setState(() => _goal = goal),
                );
              case 3:
                return ExercisePreferenceStep(
                  selectedPreference: _exercisePreference,
                  onSelection: (preference) =>
                      setState(() => _exercisePreference = preference),
                );
              default:
                return Container(); // Should not happen
            }
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0).copyWith(bottom: 48),
          child: ElevatedButton(
            onPressed: isPageValid ? _handleNext : null,
            child: Text(isLastPage ? 'Finish' : 'Next'),
          ),
        ),
      ),
    );
  }
}
