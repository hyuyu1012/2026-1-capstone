import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'auth_service.dart';

/// 로그인 상태에 따라 보여줄 화면을 고르는 진입점.
///
/// - 로딩 중: 스피너
/// - user == null: 로그인 화면
/// - user != null: 홈 화면
///

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.authService});
  // authService를 통해 파이어베이스 로그인 상태를 확인한다.
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    // StreamBuilder : 비동기를 데이터로 가져올 때 사용, 데이터를 stream 형태로 지속적으로 가져와서 위젯을 추가 또는 삭제할 수 있다.
    // <User?> StreamBuilder는 Stream을 통해 User 혹은 Null을 받을 수 있다.
    return StreamBuilder<User?>(
      // stream은 StreamBuilder의 속성이다.
      // Stream을 보고 있다가 값이 들어오면 화면을 다시 그려준다.
      stream: authService.authStateChanges(),

      // 화면을 만들어주는 함수
      // context 현재 위젯의 위치나 테마 같은 Flutter 정보를 담고 있음
      // snapshot 스트림에서 받은 현재 데이터 상태를 담고 있음
      builder: (context, snapshot) {

        // 로그인 상태를 확인중인지...
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 페이지
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // user = snapshot.data
        final user = snapshot.data;
        // user == null 이면 login_screen
        if (user == null) {
          return LoginScreen(authService: authService);
        }
        // 로그인 성공하면 home_screen
        return HomeScreen(authService: authService);
      },
    );
  }
}
