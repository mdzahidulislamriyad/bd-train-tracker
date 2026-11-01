import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'live_map_screen.dart';
import 'history_screen.dart';
import 'rewards_screen.dart';
import 'notifications_screen.dart';
import '../theme/app_theme.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    LiveMapScreen(),
    HistoryScreen(),
    RewardsScreen(),
    NotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "হোম",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me_outlined),
            activeIcon: Icon(Icons.near_me),
            label: "ড্যাশবোর্ড",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: "ইতিহাস",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: "রিওয়ার্ড",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: "বিজ্ঞপ্তি",
          ),
        ],
      ),
    );
  }
}
