import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'asana/asana_screen.dart';
import 'studio/studio_screen.dart';
import 'record/record_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeScreen(),
    const AsanaScreen(),
    const StudioScreen(),
    const RecordScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF23252B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '아사나',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: '요가원',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: '수련',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
} 