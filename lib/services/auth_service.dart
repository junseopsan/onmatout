import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../constants/api_constants.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<UserModel> login(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('로그인에 실패했습니다.');
    }

    final userData = await _supabase
        .from('users')
        .select()
        .eq('id', response.user!.id)
        .single();

    return UserModel.fromJson(userData);
  }

  Future<UserModel> register(String email, String password, String name) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('회원가입에 실패했습니다.');
    }

    final userData = {
      'id': response.user!.id,
      'email': email,
      'name': name,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'consecutive_days': 0,
      'total_practice_days': 0,
      'favorite_asanas': [],
      'badges': {},
    };

    await _supabase.from('users').insert(userData);

    return UserModel.fromJson(userData);
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }
} 