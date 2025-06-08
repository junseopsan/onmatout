import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  static const String usernameLabel = '아이디';
  static const String passwordLabel = '비밀번호';
  static const String loginBtn = '로그인';
  static const String requiredFieldMsg = '필수 입력 항목입니다.';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(AuthViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) return;
    final success = await viewModel.signIn(
      _usernameController.text,
      _passwordController.text,
    );
    if (success) {
      // TODO: 홈 화면 등으로 이동 (Navigator.pushReplacement 등)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text(loginBtn)),
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
                      decoration: const InputDecoration(labelText: usernameLabel),
                      validator: (value) =>
                          value == null || value.isEmpty ? requiredFieldMsg : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: passwordLabel),
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
                      onPressed: viewModel.isLoading ? null : () => _login(viewModel),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(loginBtn),
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