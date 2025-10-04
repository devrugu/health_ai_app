// lib/src/features/onboarding/presentation/screens/onboarding_details_screen.dart

import 'package:flutter/material.dart';
// --- CORRECTED IMPORT PATHS ---
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/metric_input_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/activity_level_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/goal_selection_step.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/screens/dashboard_screen.dart';

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

  // --- LATE INITIALIZED WIDGETS ---
  late final List<Widget> _onboardingSteps;

  @override
  void initState() {
    super.initState();
    _onboardingSteps = [
      MetricInputStep(
        onHeightChanged: (value) =>
            setState(() => _height = double.tryParse(value)),
        onWeightChanged: (value) =>
            setState(() => _weight = double.tryParse(value)),
      ),
      ActivityLevelStep(
        selectedActivityLevel: _activityLevel,
        onSelection: (level) {
          setState(() {
            _activityLevel = level;
          });
        },
      ),
      GoalSelectionStep(
        selectedGoal: _goal,
        onSelection: (goal) {
          setState(() {
            _goal = goal;
          });
        },
      ),
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

  // --- NAVIGATION LOGIC ---
  void _handleNext() {
    if (_isCurrentPageValid()) {
      if (_currentPageIndex < _onboardingSteps.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (Route<dynamic> route) =>
              false, // This predicate always returns false, clearing the stack.
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

  // --- VALIDATION LOGIC ---
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
              backgroundColor: Colors.grey[300],
            ),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _onboardingSteps.length,
          itemBuilder: (context, index) {
            // Rebuild the step widgets with the current state
            if (index == 0) {
              return MetricInputStep(
                onHeightChanged: (value) =>
                    setState(() => _height = double.tryParse(value)),
                onWeightChanged: (value) =>
                    setState(() => _weight = double.tryParse(value)),
              );
            }
            if (index == 1) {
              return ActivityLevelStep(
                selectedActivityLevel: _activityLevel,
                onSelection: (level) => setState(() => _activityLevel = level),
              );
            }
            if (index == 2) {
              return GoalSelectionStep(
                selectedGoal: _goal,
                onSelection: (goal) => setState(() => _goal = goal),
              );
            }
            return Container(); // Should not happen
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
