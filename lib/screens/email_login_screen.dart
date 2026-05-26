import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/brand_icons.dart';

/// 이메일/비밀번호 로그인 + 회원가입 화면.
/// 상단 토글로 로그인 모드와 회원가입 모드를 전환한다.
class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      if (_isSignUp) {
        await widget.authService.signUpWithEmail(
          email: email,
          password: password,
        );
      } else {
        await widget.authService.signInWithEmail(
          email: email,
          password: password,
        );
      }
      // 성공하면 authStateChanges가 AuthGate를 통해 홈으로 보내준다.
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = authErrorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.labelStrong,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isSignUp ? '이메일로 회원가입' : '이메일로 로그인',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.528,
                    color: AppColors.labelStrong,
                  ),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: '이메일',
                  controller: _emailController,
                  hintText: 'example@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return '이메일을 입력해 주세요.';
                    if (!v.contains('@') || !v.contains('.')) {
                      return '이메일 형식이 올바르지 않습니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _LabeledField(
                  label: '비밀번호',
                  controller: _passwordController,
                  hintText: '6자 이상',
                  obscureText: true,
                  validator: (value) {
                    final v = value ?? '';
                    if (v.isEmpty) return '비밀번호를 입력해 주세요.';
                    if (v.length < 6) return '비밀번호는 6자 이상이어야 합니다.';
                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AuthButton(
                  label: _loading
                      ? '처리 중…'
                      : (_isSignUp ? '회원가입' : '로그인'),
                  icon: const MailIcon(size: 18),
                  backgroundColor: AppColors.primaryNormal,
                  foregroundColor: Colors.white,
                  elevated: true,
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => setState(() {
                            _isSignUp = !_isSignUp;
                            _errorMessage = null;
                          }),
                  child: Text(
                    _isSignUp
                        ? '이미 계정이 있나요? 로그인'
                        : '계정이 없나요? 회원가입',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.labelNeutral,
                    ),
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

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.validator,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.labelNormal,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.labelAlternative),
            filled: true,
            fillColor: AppColors.fillNeutral,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.lineNeutral),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryNormal, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
