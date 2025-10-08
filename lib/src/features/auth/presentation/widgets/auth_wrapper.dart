// lib/src/features/auth/presentation/widgets/auth_wrapper.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/auth/data/auth_service.dart';
import 'package:health_ai_app/src/features/auth/presentation/screens/auth_screen.dart';
import 'package:health_ai_app/src/features/database/data/database_service.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/screens/main_app_screen.dart';
import 'package:health_ai_app/src/features/onboarding/presentation/screens/welcome_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // User is logged in
        if (snapshot.hasData) {
          final user = snapshot.data!;

          // NEW: Use a FutureBuilder to check if the user has completed onboarding
          return FutureBuilder<bool>(
            future: DatabaseService().doesProfileExist(user.uid),
            builder: (context, profileSnapshot) {
              // While we're checking, show a loading spinner
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              // If the profile exists, go directly to the MainAppScreen
              if (profileSnapshot.data == true) {
                return const MainAppScreen();
              }

              // Otherwise, the user needs to complete onboarding
              return const WelcomeScreen();
            },
          );
        }

        // User is logged out
        return const AuthScreen();
      },
    );
  }
}
