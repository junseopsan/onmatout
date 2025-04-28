import 'package:flutter/material.dart';
import 'asana/asana_tab.dart';
import 'journal/journal_tab.dart';
import 'class/class_tab.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    AsanaTab(),
    JournalTab(),
    ClassTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: '아사나',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '수련일지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: '수업',
          ),
        ],
      ),
    );
  }
} 