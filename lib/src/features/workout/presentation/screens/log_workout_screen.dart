// lib/src/features/workout/presentation/screens/log_workout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart'; // NEW: Import DatabaseService
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';
import 'package:health_ai_app/src/features/workout/domain/workout_models.dart';

class LogWorkoutScreen extends StatefulWidget {
  const LogWorkoutScreen({super.key});

  @override
  State<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  ExercisePreference? _selectedType;
  double _durationInMinutes = 30;
  WorkoutIntensity _selectedIntensity = WorkoutIntensity.medium;
  // NEW: Add loading state
  bool _isLoading = false;

  bool get _isFormValid => _selectedType != null;

  // --- UPDATED SUBMIT LOGIC ---
  void _submitLog() async {
    // Make the method async
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final log = WorkoutLog(
      type: _selectedType!,
      durationInMinutes: _durationInMinutes.round(),
      intensity: _selectedIntensity,
    );

    try {
      // Call the database service, converting our WorkoutLog object to a map
      await DatabaseService().updateDailyLog({
        'workout': log.toFirestore(),
      });
      // Pop the screen to return to the dashboard
      navigator.pop();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to log workout: ${e.toString()}')),
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Your Workout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (The rest of the UI is unchanged)
            _buildSectionHeader(theme, 'Workout Type'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ExercisePreference.values.map((type) {
                return ChoiceChip(
                  label: Text(_getTextForPreference(type)),
                  selected: _selectedType == type,
                  onSelected: (_) => setState(() => _selectedType = type),
                );
              }).toList(),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),

            const SizedBox(height: 32),

            _buildSectionHeader(theme, 'Duration'),
            const SizedBox(height: 8),
            Text(
              '${_durationInMinutes.round()} minutes',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _durationInMinutes,
              min: 0,
              max: 180,
              divisions: 180 ~/ 5,
              label: '${_durationInMinutes.round()} min',
              onChanged: (value) => setState(() => _durationInMinutes = value),
            ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),

            const SizedBox(height: 32),

            _buildSectionHeader(theme, 'Intensity'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<WorkoutIntensity>(
                segments: const [
                  ButtonSegment(
                      value: WorkoutIntensity.low,
                      label: Text('Low'),
                      icon: Icon(Icons.arrow_downward)),
                  ButtonSegment(
                      value: WorkoutIntensity.medium,
                      label: Text('Medium'),
                      icon: Icon(Icons.drag_handle)),
                  ButtonSegment(
                      value: WorkoutIntensity.high,
                      label: Text('High'),
                      icon: Icon(Icons.arrow_upward)),
                ],
                selected: {_selectedIntensity},
                multiSelectionEnabled: false,
                emptySelectionAllowed: false,
                onSelectionChanged: (selection) {
                  setState(() {
                    _selectedIntensity = selection.first;
                  });
                },
              ),
            ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.1),
          ],
        ),
      ),
      // --- UPDATED SUBMIT BUTTON ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 48),
        child: ElevatedButton(
          // Disable when loading OR when form is invalid
          onPressed: (_isFormValid && !_isLoading) ? _submitLog : null,
          child: _isLoading
              ? const SizedBox(
                  height: 24, width: 24, child: CircularProgressIndicator())
              : const Text('Log Workout'),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ).animate().fadeIn(delay: 200.ms);
  }

  String _getTextForPreference(ExercisePreference preference) {
    switch (preference) {
      case ExercisePreference.cardio:
        return 'Cardio';
      case ExercisePreference.strength:
        return 'Strength';
      case ExercisePreference.flexibility:
        return 'Flexibility';
      case ExercisePreference.mixed:
        return 'Mixed';
    }
  }
}
