// lib/src/features/dashboard/presentation/screens/main_app_screen.dart

import 'package:flutter/material.dart';
import 'package:health_ai_app/src/features/dashboard/presentation/screens/today_tab.dart'; // We will create this
import 'package:health_ai_app/src/features/profile/presentation/screens/profile_tab.dart'; // We will create this

// We've renamed DashboardScreen to MainAppScreen to better reflect its purpose.
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  // State to keep track of the selected tab index
  int _selectedIndex = 0;

  // A list of the widgets (tabs) to be displayed
  static const List<Widget> _widgetOptions = <Widget>[
    TodayTab(), // Our current dashboard
    Text('Plan Tab (Coming Soon)'), // Placeholder for the second tab
    ProfileTab(), // The new profile screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // The BottomNavigationBar
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
