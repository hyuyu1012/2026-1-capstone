import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/brand_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _toastLabel;

  void _showToast(String provider) {
    setState(() => _toastLabel = '$provider로 로그인하는 중…');
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      setState(() => _toastLabel = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Expanded(child: Center(child: _BrandMark())),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthButton(
                        label: '카카오로 시작하기',
                        icon: const KakaoIcon(size: 18),
                        backgroundColor: AppColors.kakaoBg,
                        foregroundColor: AppColors.kakaoFg,
                        onPressed: () => _showToast('카카오'),
                      ),
                      const SizedBox(height: 10),
                      AuthButton(
                        label: 'Google로 시작하기',
                        icon: const GoogleIcon(size: 18),
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.labelStrong,
                        borderColor: AppColors.lineNormal,
                        onPressed: () => _showToast('Google'),
                      ),
                      const SizedBox(height: 10),
                      AuthButton(
                        label: 'Apple로 시작하기',
                        icon: const AppleIcon(size: 18),
                        backgroundColor: AppColors.appleBg,
                        foregroundColor: AppColors.appleFg,
                        onPressed: () => _showToast('Apple'),
                      ),
                      const _OrDivider(),
                      AuthButton(
                        label: '이메일로 시작하기',
                        icon: const MailIcon(size: 18),
                        backgroundColor: AppColors.primaryNormal,
                        foregroundColor: Colors.white,
                        elevated: true,
                        onPressed: () {
                          // TODO: EmailLoginScreen으로 라우팅
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(28, 8, 28, 24),
                  child: _TermsFooter(),
                ),
              ],
            ),
            if (_toastLabel != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 96,
                child: Center(child: _Toast(label: _toastLabel!)),
              ),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryNormal,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: AppColors.logoShadow,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const ShieldCheckIcon(size: 32),
        ),
        const SizedBox(height: 18),
        const Text(
          '안심 케어',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.572, // -0.022em * 26px
            color: AppColors.labelStrong,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '부모님의 하루를 함께 챙깁니다.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.labelNeutral,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: _Line()),
          SizedBox(width: 12),
          Text(
            '또는',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.66, // 0.06em * 11px
              color: AppColors.labelAlternative,
            ),
          ),
          SizedBox(width: 12),
          Expanded(child: _Line()),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.lineNeutral);
  }
}

class _TermsFooter extends StatelessWidget {
  const _TermsFooter();

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      fontSize: 10,
      height: 1.55,
      fontWeight: FontWeight.w500,
      color: AppColors.labelAlternative,
    );
    const linkStyle = TextStyle(
      fontSize: 10,
      height: 1.55,
      fontWeight: FontWeight.w600,
      color: AppColors.labelNeutral,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: '계속 진행 시 '),
          TextSpan(
            text: '이용약관',
            style: linkStyle,
            // TODO: 약관 화면 라우팅
          ),
          const TextSpan(text: ' 및 '),
          TextSpan(
            text: '개인정보 처리방침',
            style: linkStyle,
            // TODO: 개인정보 처리방침 화면 라우팅
          ),
          const TextSpan(text: '에 동의합니다.'),
        ],
      ),
    );
  }
}

class _Toast extends StatelessWidget {
  const _Toast({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 8),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.labelStrong,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.065,
          ),
        ),
      ),
    );
  }
}
