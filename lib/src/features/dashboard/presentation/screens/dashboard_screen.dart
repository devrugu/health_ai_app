// lib/src/features/dashboard/presentation/screens/dashboard_screen.dart

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Dashboard'),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: const Center(
        child: Text(
          'Welcome to the Main App!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
