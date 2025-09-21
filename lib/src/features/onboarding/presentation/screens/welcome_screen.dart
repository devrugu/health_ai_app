// lib/src/features/onboarding/presentation/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/screens/onboarding_details_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic structure of a visual screen.
    return Scaffold(
      body: SafeArea( // SafeArea keeps our content from being hidden by system notches or bars.
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Add some padding around all content.
          child: Column(
            // mainAxisAlignment positions children vertically. .center places them in the middle.
            mainAxisAlignment: MainAxisAlignment.center, 
            // crossAxisAlignment positions children horizontally. .stretch makes them fill the width.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // An icon to represent the app.
              const Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 32), // A spacer box for vertical distance.

              // The main welcome title.
              const Text(
                'Welcome to Your Health AI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // A short description of the app's purpose.
              const Text(
                'Let\'s start your personalized journey to a healthier you. We\'ll ask a few questions to tailor your plan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48),

              // The main action button to start the onboarding process.
              ElevatedButton(
                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OnboardingDetailsScreen()),
  );
},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}