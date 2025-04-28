import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/asana_viewmodel.dart';
import 'asana/asana_list_screen.dart';
import 'routine/routine_list_screen.dart';
import 'journal/journal_list_screen.dart';
import 'stats/stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ONMATOUT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: 로그아웃 구현
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(
            context,
            '아사나',
            Icons.fitness_center,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AsanaListScreen(),
              ),
            ),
          ),
          _buildMenuCard(
            context,
            '루틴',
            Icons.list_alt,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RoutineListScreen(),
              ),
            ),
          ),
          _buildMenuCard(
            context,
            '일지',
            Icons.book,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JournalListScreen(),
              ),
            ),
          ),
          _buildMenuCard(
            context,
            '통계',
            Icons.bar_chart,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatsScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 