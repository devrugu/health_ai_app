// lib/src/features/onboarding/presentation/widgets/metric_input_step.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MetricInputStep extends StatelessWidget {
  final Function(String) onHeightChanged;
  final Function(String) onWeightChanged;

  const MetricInputStep({
    super.key,
    required this.onHeightChanged,
    required this.onWeightChanged,
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
          )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.1, end: 0), // Slide in from the left

          const SizedBox(height: 8),
          const Text(
            'This helps us calculate your needs accurately.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0),

          const SizedBox(height: 48),
          TextField(
            onChanged: onHeightChanged,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              prefixIcon: Icon(Icons.height),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),

          const SizedBox(height: 24),
          TextField(
            onChanged: onWeightChanged,
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
