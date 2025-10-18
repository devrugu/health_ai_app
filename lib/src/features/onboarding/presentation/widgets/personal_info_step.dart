// lib/src/features/onboarding/presentation/widgets/personal_info_step.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';

class PersonalInfoStep extends StatelessWidget {
  final TextEditingController ageController;
  final Gender? selectedGender;
  final Function(Gender) onGenderSelected;

  const PersonalInfoStep({
    super.key,
    required this.ageController,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tell us a bit about you',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'This is essential for accurate calorie and macro calculations.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 48),

          // Age Input Field
          TextField(
            controller: ageController,
            decoration: const InputDecoration(
              labelText: 'Age',
              prefixIcon: Icon(Icons.cake_rounded),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 32),

          // Gender Selection
          Text(
            'Gender',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<Gender>(
            segments: const [
              ButtonSegment(value: Gender.male, label: Text('Male')),
              ButtonSegment(value: Gender.female, label: Text('Female')),
            ],
            selected: selectedGender != null ? {selectedGender!} : {},
            onSelectionChanged: (selection) =>
                onGenderSelected(selection.first),
            emptySelectionAllowed: true,
          ),
        ],
      ),
    );
  }
}
