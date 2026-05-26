import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../theme/app_colors.dart';

/// 로그인 성공 후 보이는 임시 홈 화면.
/// 이후 케어 그룹/일일 기록 화면으로 확장한다.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.labelStrong,
        title: const Text(
          '안심 케어',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: '로그아웃',
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '로그인 완료 🎉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.labelStrong,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? '이메일 없음',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.labelNeutral,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
