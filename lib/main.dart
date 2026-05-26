import 'package:flutter/material.dart';

import 'auth/auth_gate.dart';
import 'auth/auth_service.dart';
import 'theme/app_colors.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


// async => 함수 안에서 비동기 작업을 할 수 있게 해줌
void main() async {
  // Flutter 엔진과 위젯 시스템을 준비
  // 앱 실행 전에 비동기 작업을 해야할 때 필요
  WidgetsFlutterBinding.ensureInitialized();

  //await 작업이 끝날 때까지 기다린 뒤 다음줄을 실행하라
  // Firebase 초기화가 끝난 후에 runApp()을 실행하라
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(CareTrackerApp(authService: AuthService()));
}


class CareTrackerApp extends StatelessWidget {
  const CareTrackerApp({super.key, required this.authService});
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '안심 케어',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryNormal,
          primary: AppColors.primaryNormal,
        ),
      ),
      home: AuthGate(authService: authService),
    );
  }
}
