import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;
  String? _errorMessage;

  String formatPhone(String phone) {
    if (phone.startsWith('0')) {
      return '+82' + phone.substring(1);
    }
    return phone;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nicknameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final phone = formatPhone(_phoneController.text);
      await authViewModel.sendOtp(phone);
      setState(() => _isOtpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증번호가 발송되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final phone = formatPhone(_phoneController.text);
      await authViewModel.verifyOtp(phone, _otpController.text);
      await authViewModel.updateProfile(_nicknameController.text);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: '닉네임',
                    hintText: '사용할 닉네임을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '닉네임을 입력해주세요';
                    }
                    if (value.length < 2) {
                      return '닉네임은 2자 이상이어야 합니다';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: '전화번호',
                    hintText: '01012345678',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '전화번호를 입력해주세요';
                    }
                    if (!RegExp(r'^01[0-9]{8,9}').hasMatch(value)) {
                      return '올바른 전화번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_isOtpSent) ...[
                  TextFormField(
                    controller: _otpController,
                    decoration: const InputDecoration(
                      labelText: '인증번호',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '인증번호를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : (_isOtpSent ? _register : _sendOtp),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(_isOtpSent ? '회원가입' : '인증번호 받기'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('이미 계정이 있으신가요? 로그인'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 