// lib/src/features/workout/presentation/screens/log_workout_screen.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart';
import 'package:health_ai_app/src/features/workout/domain/exercise.dart';
import 'package:health_ai_app/src/features/workout/domain/workout_models.dart';

class LogWorkoutScreen extends StatefulWidget {
  final double userWeightKg;
  const LogWorkoutScreen({super.key, required this.userWeightKg});

  @override
  State<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  // State for the list of exercises fetched from Firestore
  List<Exercise>? _exerciseLibrary;
  // State for the form
  Exercise? _selectedExercise;
  double _durationInMinutes = 30;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    final exercises = await DatabaseService().getExerciseLibrary();
    if (mounted) {
      setState(() {
        _exerciseLibrary = exercises;
      });
    }
  }

  double get _caloriesBurned {
    if (_selectedExercise == null) return 0;
    // Standard MET-based formula
    return _selectedExercise!.metValue *
        3.5 *
        widget.userWeightKg /
        200 *
        _durationInMinutes;
  }

  bool get _isFormValid => _selectedExercise != null && _durationInMinutes > 0;

  void _submitLog() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final log = WorkoutLog(
      exerciseName: _selectedExercise!.name,
      category: _selectedExercise!.category,
      metValue: _selectedExercise!.metValue,
      durationInMinutes: _durationInMinutes.round(),
      caloriesBurned: _caloriesBurned,
    );

    try {
      await DatabaseService().logWorkout(log);
      navigator.pop(true);
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
      appBar: AppBar(title: const Text('Log a Workout')),
      // Show a loading spinner while the exercise library is being fetched
      body: _exerciseLibrary == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Exercise', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Exercise>(
                    initialValue: _selectedExercise,
                    hint: const Text('Select an exercise'),
                    isExpanded: true,
                    // Populate the dropdown with items from our fetched library
                    items: _exerciseLibrary!.map((Exercise exercise) {
                      return DropdownMenuItem<Exercise>(
                        value: exercise,
                        child: Text(exercise.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedExercise = value;
                      });
                    },
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 32),
                  Text('Duration', style: theme.textTheme.titleLarge),
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
                    divisions: 36,
                    label: '${_durationInMinutes.round()} min',
                    onChanged: (value) =>
                        setState(() => _durationInMinutes = value),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Estimated Burn: ${_caloriesBurned.toStringAsFixed(0)} kcal',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 48),
        child: ElevatedButton(
          onPressed: (_isFormValid && !_isLoading) ? _submitLog : null,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Add Workout to Log'),
        ),
      ),
    );
  }
}
