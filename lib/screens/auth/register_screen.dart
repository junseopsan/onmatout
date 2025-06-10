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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const String usernameLabel = '아이디';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String checkUsernameBtn = '중복확인';
  static const String registerBtn = 'Sign Up';
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
          backgroundColor: const Color(0xFF181A20),
          appBar: AppBar(
            backgroundColor: const Color(0xFF181A20),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              '계정 설정',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: usernameLabel,
                              labelStyle: const TextStyle(color: Colors.white70),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorText: _isUsernameChecked && !_isUsernameAvailable
                                  ? usernameNotAvailableMsg
                                  : null,
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? requiredFieldMsg : null,
                            onChanged: (_) {
                              setState(() {
                                _isUsernameChecked = false;
                                _isUsernameAvailable = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () => _checkUsername(viewModel),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(checkUsernameBtn),
                        ),
                      ],
                    ),
                    if (_isUsernameChecked && _isUsernameAvailable)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          usernameAvailableMsg,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: (_isUsernameChecked && _isUsernameAvailable)
                          ? Column(
                              key: const ValueKey('fields'),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: emailLabel,
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white24),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return requiredFieldMsg;
                                    }
                                    if (!value.contains('@')) {
                                      return '올바른 이메일 형식이 아닙니다.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _passwordController,
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: passwordLabel,
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white24),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return requiredFieldMsg;
                                    }
                                    if (value.length < 6) {
                                      return '비밀번호는 6자 이상이어야 합니다.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: confirmPasswordLabel,
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white24),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.white54,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return requiredFieldMsg;
                                    }
                                    if (value != _passwordController.text) {
                                      return passwordNotMatchMsg;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                if (viewModel.errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      viewModel.errorMessage!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
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
                                    onPressed: viewModel.isLoading ? null : () => _register(viewModel),
                                    child: viewModel.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Text(registerBtn, style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
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