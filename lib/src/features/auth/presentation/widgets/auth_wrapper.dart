// lib/src/features/auth/presentation/widgets/auth_wrapper.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/auth/data/auth_service.dart';
import 'package:health_ai_app/src/features/auth/presentation/screens/auth_screen.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/screens/welcome_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a StreamBuilder to listen for auth state changes.
    return StreamBuilder<User?>(
      // The stream is provided by our AuthService
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // Show a loading indicator while we're waiting for the auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If the snapshot has data, it means a user is logged in.
        if (snapshot.hasData) {
          // TODO: In the future, check if the user has completed onboarding.
          // For now, we'll send them to the welcome screen.
          return const WelcomeScreen();
        }

        // If there's no data, the user is logged out. Show the AuthScreen.
        return const AuthScreen();
      },
    );
  }
}
