import 'package:flutter/material.dart';
import 'asana/asana_tab.dart';
import '../record_screen.dart';
import 'studio/studio_tab.dart';


class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    AsanaTab(),
    RecordScreen(),
    StudioTab(),
    Center(child: Text('프로필')), // ProfileTab()으로 교체 가능
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: '아사나',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '수련',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: '수업',
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