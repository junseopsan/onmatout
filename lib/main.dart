import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'viewmodels/asana_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'services/database_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AsanaViewModel(DatabaseService(Supabase.instance.client)),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ONMATOUT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainTabScreen(),
      },
    );
  }
}

String formatPhone(String phone) {
  // 01012345678 → +821012345678
  if (phone.startsWith('0')) {
    return '+82' + phone.substring(1);
  }
  return phone;
}
