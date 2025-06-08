import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('내 프로필')),
      body: user == null
          ? const Center(child: Text('로그인 정보 없음'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('이름'),
                  subtitle: Text(user.userMetadata?['name'] ?? '-'),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('이메일'),
                  subtitle: Text(user.email ?? '-'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('전화번호'),
                  subtitle: Text(user.phone ?? '-'),
                ),
              ],
            ),
    );
  }
} 