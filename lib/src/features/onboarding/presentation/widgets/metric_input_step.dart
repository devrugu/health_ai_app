// lib/src/features/onboarding/presentation/widgets/metric_input_step.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MetricInputStep extends StatelessWidget {
  // UPDATED: We now accept controllers instead of callbacks.
  final TextEditingController heightController;
  final TextEditingController weightController;

  const MetricInputStep({
    super.key,
    required this.heightController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'What are your measurements?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          Text(
            'This helps us calculate your needs accurately.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 48),
          TextField(
            // UPDATED: Assign the controller.
            controller: heightController,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              prefixIcon: Icon(Icons.height),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 24),
          TextField(
            // UPDATED: Assign the controller.
            controller: weightController,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              prefixIcon: Icon(Icons.monitor_weight),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1, end: 0),
        ],
      ),
    );
  }
}
