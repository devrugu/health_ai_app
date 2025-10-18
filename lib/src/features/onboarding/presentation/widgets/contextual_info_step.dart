// lib/src/features/onboarding/presentation/widgets/contextual_info_step.dart

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/onboarding/domain/onboarding_models.dart';

class ContextualInfoStep extends StatelessWidget {
  final String? selectedCountry;
  final Budget? selectedBudget;
  final Function(String) onCountrySelected;
  final Function(Budget) onBudgetSelected;

  const ContextualInfoStep({
    super.key,
    this.selectedCountry,
    this.selectedBudget,
    required this.onCountrySelected,
    required this.onBudgetSelected,
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
            'A Little More Context',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'This optional info helps Aura create a plan that truly fits your life.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 48),

          // Country Picker
          Text('Country (Optional)', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  onCountrySelected(country.name);
                },
              );
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.public),
              ),
              child: Text(selectedCountry ?? 'Select your country'),
            ),
          ),
          const SizedBox(height: 32),

          // Budget Selection
          Text('Budget for Groceries (Optional)',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<Budget>(
            segments: const [
              ButtonSegment(
                  value: Budget.budgetConscious, label: Text('Budget')),
              ButtonSegment(value: Budget.average, label: Text('Average')),
              ButtonSegment(value: Budget.flexible, label: Text('Flexible')),
            ],
            selected: selectedBudget != null ? {selectedBudget!} : {},
            onSelectionChanged: (Set<Budget> selection) {
              if (selection.isNotEmpty) {
                onBudgetSelected(selection.first);
              }
            },
            emptySelectionAllowed: true,
            multiSelectionEnabled: false,
          ),
        ],
      ),
    );
  }
}
