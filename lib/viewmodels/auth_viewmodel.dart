import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  // 아이디 중복확인
  Future<bool> checkUsername(String username) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final available = await _authService.isUsernameAvailable(username);
      return available;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 회원가입
  Future<bool> signUp(String username, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      currentUser = await _authService.signUp(
        username: username,
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 로그인
  Future<bool> signIn(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      currentUser = await _authService.signInWithUsername(
        username: username,
        password: password,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _authService.signOut();
    currentUser = null;
    notifyListeners();
  }
} 