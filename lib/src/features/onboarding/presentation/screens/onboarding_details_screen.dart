// lib/src/features/onboarding/presentation/screens/onboarding_details_screen.dart

import 'package:flutter/foundation.dart';
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

  // --- THIS IS THE FIX ---
  // The 'late final' keywords are removed.
  // The controllers are initialized immediately upon declaration.
  // This guarantees they exist before the build method is ever called.
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // We can keep this for the page count.
  final List<Widget> _onboardingSteps = [
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  void initState() {
    super.initState();
    // The controllers are already initialized, so we just add the listeners here.
    _heightController.addListener(() {
      setState(() {
        _height = double.tryParse(_heightController.text);
      });
    });
    _weightController.addListener(() {
      setState(() {
        _weight = double.tryParse(_weightController.text);
      });
    });

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
    // Disposing is still essential to prevent memory leaks.
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // No changes to _handleNext, _handleBack, or _isCurrentPageValid

  void _handleNext() {
    if (_isCurrentPageValid()) {
      if (_currentPageIndex < _onboardingSteps.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
      } else {
        if (kDebugMode) {
          print(
              'Onboarding complete! Data: Height: $_height, Weight: $_weight, Activity: $_activityLevel, Goal: $_goal, Exercise: $_exercisePreference');
        }
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
      onPopInvokedWithResult: (bool didPop, dynamic result) {
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
        body: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _onboardingSteps.length,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return MetricInputStep(
                  heightController: _heightController,
                  weightController: _weightController,
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
                return Container();
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
