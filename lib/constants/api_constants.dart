import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // API Endpoints
  static const String asanasEndpoint = '/asanas';
  static const String routinesEndpoint = '/routines';
  static const String journalsEndpoint = '/journals';
  static const String usersEndpoint = '/users';
  static const String statsEndpoint = '/stats';

  // API Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);

  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
} 