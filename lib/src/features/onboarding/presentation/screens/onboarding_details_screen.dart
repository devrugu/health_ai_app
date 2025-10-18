// lib/src/features/onboarding/presentation/screens/onboarding_details_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/screens/main_app_screen.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/activity_level_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/exercise_preference_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/goal_selection_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/metric_input_step.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/widgets/personal_info_step.dart';

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
  int? _age;
  Gender? _gender;
  ActivityLevel? _activityLevel;
  Goal? _goal;
  ExercisePreference? _exercisePreference;

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;

  final List<Widget> _onboardingSteps = List.generate(5, (_) => Container());

  @override
  void initState() {
    super.initState();
    _heightController.addListener(() =>
        setState(() => _height = double.tryParse(_heightController.text)));
    _weightController.addListener(() =>
        setState(() => _weight = double.tryParse(_weightController.text)));
    _ageController.addListener(
        () => setState(() => _age = int.tryParse(_ageController.text))); // NEW

    _pageController.addListener(() {
      final newIndex = _pageController.page?.round();
      if (newIndex != null && newIndex != _currentPageIndex) {
        setState(() => _currentPageIndex = newIndex);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleNext() async {
    if (!_isCurrentPageValid()) return;

    if (_currentPageIndex < _onboardingSteps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuad,
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Error: Not logged in.')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        await DatabaseService().createUserProfile(
          user: user,
          height: _height!,
          weight: _weight!,
          age: _age!,
          gender: _gender!,
          activityLevel: _activityLevel!,
          goal: _goal!,
          exercisePreference: _exercisePreference!,
        );

        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainAppScreen()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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
      case 0: // Height & Weight
        return _height != null &&
            _height! > 50 &&
            _weight != null &&
            _weight! > 20;
      case 1: // Age & Gender
        return _age != null && _age! > 12 && _gender != null;
      case 2: // Activity Level
        return _activityLevel != null;
      case 3: // Goal
        return _goal != null;
      case 4: // Exercise Preference
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
              icon: const Icon(Icons.arrow_back), onPressed: _handleBack),
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
                    weightController: _weightController);
              case 1:
                return PersonalInfoStep(
                    ageController: _ageController,
                    selectedGender: _gender,
                    onGenderSelected: (gender) =>
                        setState(() => _gender = gender));
              case 2:
                return ActivityLevelStep(
                    selectedActivityLevel: _activityLevel,
                    onSelection: (level) =>
                        setState(() => _activityLevel = level));
              case 3:
                return GoalSelectionStep(
                    selectedGoal: _goal,
                    onSelection: (goal) => setState(() => _goal = goal));
              case 4:
                return ExercisePreferenceStep(
                    selectedPreference: _exercisePreference,
                    onSelection: (preference) =>
                        setState(() => _exercisePreference = preference));
              default:
                return Container();
            }
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0).copyWith(bottom: 48),
          child: ElevatedButton(
            onPressed: (isPageValid && !_isLoading) ? _handleNext : null,
            child: _isLoading && isLastPage
                ? const SizedBox(
                    height: 24, width: 24, child: CircularProgressIndicator())
                : Text(isLastPage ? 'Finish' : 'Next'),
          ),
        ),
      ),
    );
  }
}
