// lib/src/features/onboarding/presentation/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import the animation package
import 'package:health_ai_app/src/features/onboarding/presentation/screens/onboarding_details_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(), // Pushes content to the center

              // The .animate() extension comes from the flutter_animate package.
              const Icon(
                Icons.fitness_center,
                size: 80,
              )
                  .animate()
                  .fade(duration: 500.ms) // Fade in over 500 milliseconds
                  .scale(delay: 200.ms), // Then scale up, with a 200ms delay

              const SizedBox(height: 32),
              const Text(
                'Welcome to Your Health AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .fadeIn(
                      delay: 500.ms, duration: 400.ms) // Fade in after the icon
                  .slideY(begin: 0.2, end: 0), // Slide up slightly as it fades

              const SizedBox(height: 16),
              const Text(
                'Let\'s start your personalized journey to a healthier you. We\'ll ask a few questions to tailor your plan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),

              const Spacer(), // Pushes the button towards the bottom
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    // A more elegant page transition
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const OnboardingDetailsScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                child: const Text('Get Started'),
              )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 400.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 20), // Some padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
