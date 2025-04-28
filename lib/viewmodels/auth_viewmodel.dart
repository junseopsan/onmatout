import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _supabase.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<void> sendOtp(String phone) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _supabase.auth.signInWithOtp(
        phone: phone,
        data: {'phone': phone},
      );
    } catch (e) {
      _errorMessage = '인증번호 발송에 실패했습니다. 다시 시도해주세요.';
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _supabase.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );

      if (response.user == null) {
        throw Exception('인증에 실패했습니다');
      }

      // 사용자 프로필이 없으면 생성
      final existingProfile = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (existingProfile == null) {
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'phone': phone,
          'nickname': '사용자${phone.substring(phone.length - 4)}',
        });
      }
    } catch (e) {
      _errorMessage = '인증에 실패했습니다. 다시 시도해주세요.';
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(String nickname) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (currentUser == null) {
        throw Exception('로그인이 필요합니다');
      }

      await _supabase
          .from('profiles')
          .update({'nickname': nickname})
          .eq('id', currentUser!.id);
    } catch (e) {
      _errorMessage = '프로필 업데이트에 실패했습니다. 다시 시도해주세요.';
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _supabase.auth.signOut();
    } catch (e) {
      _errorMessage = '로그아웃에 실패했습니다. 다시 시도해주세요.';
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 