// lib/main.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a seed color based on your screenshots (a soft lavender/purple)
    final seedColor = Colors.deepPurple.shade100;

    return MaterialApp(
      title: 'Health AI App',
      // The overall theme of the application
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,

        // Define the theme for all ElevatedButton widgets
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: seedColor, // Button background color
            foregroundColor: Colors.black, // Button text/icon color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Softer corners
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Define the theme for all OutlinedButton widgets
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: BorderSide(color: Colors.grey.shade300), // Border color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ).copyWith(
            // Specific style for when the button is selected
            // We will use this to show feedback to the user
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return seedColor.withOpacity(0.8);
                }
                return null; // Use the default background
              },
            ),
          ),
        ),

        // Define the theme for all text input fields
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: seedColor, width: 2),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
