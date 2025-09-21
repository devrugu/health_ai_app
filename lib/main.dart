// lib/main.dart

import 'package:flutter/material.dart';
import 'src/features/onboarding/presentation/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health AI App',
      theme: ThemeData(
        // Let's define a color scheme for a more modern look
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Set our new WelcomeScreen as the home screen of the app.
      home: const WelcomeScreen(),
    );
  }
}