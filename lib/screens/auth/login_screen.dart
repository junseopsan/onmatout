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

  bool _obscurePassword = true;
  bool _rememberMe = false;

  static const String usernameLabel = '아이디';
  static const String passwordLabel = 'Password';
  static const String loginBtn = 'Sign In';
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
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF181A20),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Image.asset(
                        'images/onthemat_rm_bg.png',
                        width: 700,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: usernameLabel,
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        fillColor: const Color(0xFF23252B),
                        filled: true,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? requiredFieldMsg : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: passwordLabel,
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        fillColor: const Color(0xFF23252B),
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? requiredFieldMsg : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (v) {
                            setState(() {
                              _rememberMe = v ?? false;
                            });
                          },
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                        ),
                        const Text('Remember me', style: TextStyle(color: Colors.white70)),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password', style: TextStyle(color: Colors.white70)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          children: [
                            Text(
                              viewModel.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            if (viewModel.errorMessage!.contains('존재하지 않는 아이디'))
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/register'),
                                child: const Text('회원가입하기'),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: viewModel.isLoading ? null : () => _login(viewModel),
                        child: viewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(loginBtn, style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: const Text('회원가입', style: TextStyle(color: Colors.white70)),
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