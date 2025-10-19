// lib/src/features/onboarding/presentation/widgets/story_step.dart

import 'package:flutter/material.dart';

class StoryStep extends StatelessWidget {
  final TextEditingController storyController;

  const StoryStep({super.key, required this.storyController});

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
            'Anything else to share?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Tell Aura about your lifestyle, preferences, or any specific challenges. The more you share, the better your plan will be.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: storyController,
            // Allow for multi-line input
            maxLines: 5,
            decoration: const InputDecoration(
              hintText:
                  "e.g., 'I'm a vegetarian who works night shifts and wants to lose 5kg before my wedding in June. I hate running but enjoy swimming.'",
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
