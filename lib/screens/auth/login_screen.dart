import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/theme_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_view.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
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

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final phone = formatPhone(_phoneController.text);
      await authViewModel.verifyOtp(phone, _otpController.text);
      
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ONMATOUT',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
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
                    if (!RegExp(r'^01[0-9]{8,9}$').hasMatch(value)) {
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
                    onPressed: _isLoading ? null : (_isOtpSent ? _verifyOtp : _sendOtp),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(_isOtpSent ? '로그인' : '인증번호 받기'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 