import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ONMATOUT',
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
} 