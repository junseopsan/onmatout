import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';

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
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('홈 화면'),
      ),
    );
  }
} 