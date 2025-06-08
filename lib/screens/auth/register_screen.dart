import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isUsernameChecked = false;
  bool _isUsernameAvailable = false;

  static const String usernameLabel = '아이디';
  static const String emailLabel = '이메일';
  static const String passwordLabel = '비밀번호';
  static const String confirmPasswordLabel = '비밀번호 확인';
  static const String checkUsernameBtn = '중복확인';
  static const String registerBtn = '회원가입';
  static const String usernameAvailableMsg = '사용 가능한 아이디입니다.';
  static const String usernameNotAvailableMsg = '이미 사용 중인 아이디입니다.';
  static const String passwordNotMatchMsg = '비밀번호가 일치하지 않습니다.';
  static const String requiredFieldMsg = '필수 입력 항목입니다.';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkUsername(AuthViewModel viewModel) async {
    setState(() {
      _isUsernameChecked = false;
      _isUsernameAvailable = false;
    });
    if (_usernameController.text.isEmpty) return;
    final available = await viewModel.checkUsername(_usernameController.text);
    setState(() {
      _isUsernameChecked = true;
      _isUsernameAvailable = available;
    });
  }

  Future<void> _register(AuthViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isUsernameChecked || !_isUsernameAvailable) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(passwordNotMatchMsg)),
      );
      return;
    }
    final success = await viewModel.signUp(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (success) {
      Navigator.of(context).pop(); // 회원가입 성공 시 로그인 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text(registerBtn)),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: usernameLabel,
                        suffixIcon: TextButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () => _checkUsername(viewModel),
                          child: const Text(checkUsernameBtn),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? requiredFieldMsg : null,
                    ),
                    if (_isUsernameChecked)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: Text(
                          _isUsernameAvailable
                              ? usernameAvailableMsg
                              : usernameNotAvailableMsg,
                          style: TextStyle(
                            color: _isUsernameAvailable ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: emailLabel),
                      validator: (value) =>
                          value == null || value.isEmpty ? requiredFieldMsg : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: passwordLabel),
                      obscureText: true,
                      validator: (value) =>
                          value == null || value.isEmpty ? requiredFieldMsg : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(labelText: confirmPasswordLabel),
                      obscureText: true,
                      validator: (value) =>
                          value == null || value.isEmpty ? requiredFieldMsg : null,
                    ),
                    const SizedBox(height: 24),
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: viewModel.isLoading ? null : () => _register(viewModel),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(registerBtn),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 