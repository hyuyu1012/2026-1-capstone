import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:capstone/auth/auth_service.dart';
import 'package:capstone/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders brand and social buttons',
      (WidgetTester tester) async {
    // AuthService는 lazy 해석이므로 Firebase 초기화 없이 생성해도 안전하다.
    // (LoginScreen은 빌드 시 authService 메서드를 호출하지 않는다.)
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(authService: AuthService())),
    );
    await tester.pump();

    expect(find.text('안심 케어'), findsOneWidget);
    expect(find.text('카카오로 시작하기'), findsOneWidget);
    expect(find.text('Google로 시작하기'), findsOneWidget);
    expect(find.text('Apple로 시작하기'), findsOneWidget);
    expect(find.text('이메일로 시작하기'), findsOneWidget);
  });
}
