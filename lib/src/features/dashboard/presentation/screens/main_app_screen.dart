// lib/src/features/dashboard/presentation/screens/main_app_screen.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/screens/today_tab.dart';
import 'package:health_ai_app/src/features/profile/presentation/screens/profile_tab.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  // NEW: The visibility state now lives here, in the persistent parent state.
  bool _isWelcomeMessageVisible = true;

  // NEW: A callback function to allow the child (TodayTab) to change the state here.
  void _dismissWelcomeMessage() {
    setState(() {
      _isWelcomeMessageVisible = false;
    });
  }

  // UPDATED: The list of widgets can no longer be static const because it now
  // needs to pass the instance variables (_isWelcomeMessageVisible) and
  // instance methods (_dismissWelcomeMessage) down to the TodayTab.

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Rebuild the widget list if the index changes to pass the most recent state
        child: <Widget>[
          TodayTab(
            isWelcomeMessageVisible: _isWelcomeMessageVisible,
            onDismissWelcomeMessage: _dismissWelcomeMessage,
          ),
          const Center(child: Text('Plan Tab (Coming Soon)')),
          const ProfileTab(),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
