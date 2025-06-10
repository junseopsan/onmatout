import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../constants/api_constants.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // 아이디 중복확인
  Future<bool> isUsernameAvailable(String username) async {
    final response = await supabase
        .from('profiles')
        .select('id')
        .eq('username', username)
        .maybeSingle();
    return response == null;
  }

  // 이메일 인증(코드 발송)
  Future<void> sendEmailVerification(String email) async {
    // Supabase는 기본적으로 이메일 인증 링크를 발송함
    // 실제 회원가입 시 자동 발송되므로 별도 구현 필요시 추가
    // 예시: await supabase.auth.api.sendMagicLinkEmail(email: email);
  }

  // 회원가입
  Future<UserModel?> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      
      if (response.user == null) {
        throw Exception('회원가입 실패');
      }
      
      // profiles 테이블에 username 업데이트
      await supabase
          .from('profiles')
          .update({'username': username})
          .eq('id', response.user!.id);
      
      // UserModel 변환 예시 (실제 DB 구조에 맞게 수정)
      return UserModel(
        id: response.user!.id,
        username: username,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 로그인 (아이디로 로그인)
  Future<UserModel?> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      // username → email 변환
      final userRow = await supabase
          .from('profiles')
          .select('email')
          .eq('username', username)
          .maybeSingle();
          
      if (userRow == null) {
        throw Exception('존재하지 않는 아이디입니다.');
      }
      
      final email = userRow['email'] as String;
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('로그인 실패');
      }
      
      return UserModel(
        id: response.user!.id,
        username: username,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<UserModel> register(String email, String password, String name) async {
    try {
      final response = await supabase.auth.signUp(
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

      await supabase.from('users').insert(userData);

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
} 