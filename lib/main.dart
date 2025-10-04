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
    // --- KEY CHANGE 1: Use a more saturated seed color ---
    // This gives the theme generator a better starting point for a vibrant palette.
    const seedColor = Colors.deepPurple;

    // Generate our color scheme with dark brightness
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Health AI App',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: colorScheme,
        useMaterial3: true,

        // --- KEY CHANGE 2: Define a specific background color ---
        // A very dark grey is often better than pure black.
        scaffoldBackgroundColor: const Color(0xFF121212),

        // --- KEY CHANGE 3: Explicitly define text styles for contrast ---
        textTheme: Typography.whiteMountainView.apply(
          // Set a bright default color for body text (like subtitles)
          bodyColor: Colors.grey[300],
          // Ensure headlines are pure white
          displayColor: Colors.white,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF121212), // Match scaffold background
          elevation: 0, // Remove shadow for a flatter look
          titleTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ).copyWith(
            // --- KEY CHANGE 4: Style for DISABLED buttons ---
            // Make disabled buttons visually distinct but not invisible.
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.white.withOpacity(0.12);
                }
                return colorScheme.primary;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.white.withOpacity(0.38);
                }
                return colorScheme.onPrimary;
              },
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            // --- KEY CHANGE 5: Brighter border for unselected buttons ---
            side: BorderSide(color: Colors.grey.shade800, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Slightly bolder text
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // No border for a cleaner look
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
