# 이메일 로그인 구현 보고서

- 작성일: 2026-05-24
- 대상 프로젝트: `capstone` (Flutter / 안심 케어)
- 범위: Firebase 이메일/비밀번호 인증 연결 (가이드 추천 구현 순서 1~6단계)

## 1. 작업 배경

기존 상태에서 로그인 화면은 UI만 완성되어 있었고, 각 로그인 버튼에 실제
Firebase 인증 로직이 연결되어 있지 않았다. 이번 작업에서 이메일/비밀번호
로그인을 실제로 동작하도록 연결하고, 로그인 상태에 따른 화면 분기와 Firestore
사용자 문서 생성, 보안 규칙까지 구성했다.

`docs/firebase_setup_guide.md`의 "17. 추천 구현 순서" 기준 1~6번을 완료했다.

## 2. 구현 결과 요약

| 항목 | 상태 |
| --- | --- |
| Firebase 초기화 유지 | 완료 (기존) |
| AuthGate 추가 | 완료 |
| 이메일 회원가입/로그인 화면 | 완료 |
| 로그인 성공 시 `users/{uid}` 문서 생성 | 완료 |
| 로그아웃 버튼 | 완료 (홈 화면) |
| Firestore Security Rules 작성 | 완료 |
| Google / Apple / Kakao 로그인 | 미구현 (다음 단계) |
| 케어 그룹 / 일일 기록 데이터 모델 | 미구현 (다음 단계) |

## 3. 추가/변경 파일

### 새로 만든 파일

- `lib/auth/auth_service.dart`
  - Firebase Authentication과 Firestore 사용자 문서를 다루는 서비스.
  - 회원가입(`signUpWithEmail`), 로그인(`signInWithEmail`), 로그아웃(`signOut`),
    로그인 상태 스트림(`authStateChanges`) 제공.
  - 로그인/회원가입 성공 시 `users/{uid}` 문서를 보장(`_ensureUserDocument`).
    `createdAt`은 최초 1회만 기록.
  - `FirebaseAuthException` 코드를 한국어 메시지로 변환하는 `authErrorMessage` 제공.
  - Firebase 인스턴스를 생성 시점이 아니라 사용 시점에 lazy하게 해석하여,
    테스트에서 Firebase 초기화 없이도 생성 가능.

- `lib/auth/auth_gate.dart`
  - `authStateChanges()`를 구독하여 화면을 분기하는 진입점.
  - 로딩 중: 스피너 / 비로그인: `LoginScreen` / 로그인: `HomeScreen`.

- `lib/screens/email_login_screen.dart`
  - 이메일/비밀번호 입력 폼. 로그인 모드와 회원가입 모드를 토글로 전환.
  - 클라이언트 입력 검증(이메일 형식, 비밀번호 6자 이상)과 에러 메시지 표시.
  - 기존 디자인 토큰(`AppColors`)과 `AuthButton` 위젯을 재사용.

- `lib/screens/home_screen.dart`
  - 로그인 성공 후 보이는 임시 홈 화면. 로그인 이메일 표시와 로그아웃 버튼.

- `firestore.rules`
  - `users/{uid}`: 본인만 읽기/쓰기.
  - `careGroups/{groupId}`: 멤버만 읽기, 소유자만 생성/수정/삭제.
  - `careGroups/{groupId}/dailyRecords/{recordId}`: 그룹 멤버만 읽기/쓰기.

### 수정한 파일

- `lib/main.dart`
  - 앱 진입 화면을 `LoginScreen`에서 `AuthGate`로 교체.
  - `AuthService`를 생성해 앱 전반에 주입.

- `lib/screens/login_screen.dart`
  - 생성자에서 `authService`를 받도록 변경.
  - "이메일로 시작하기" 버튼을 `EmailLoginScreen`으로 라우팅.

- `test/widget_test.dart`
  - 변경된 생성자에 맞춰 `LoginScreen`을 직접 렌더링하도록 수정.

## 4. 동작 흐름

```text
앱 시작
  main() → Firebase.initializeApp → AuthGate

AuthGate (authStateChanges 구독)
  user == null → LoginScreen
  user != null → HomeScreen

LoginScreen
  "이메일로 시작하기" → EmailLoginScreen

EmailLoginScreen
  회원가입/로그인 성공
    → AuthService가 users/{uid} 문서 보장
    → authStateChanges가 갱신되어 AuthGate가 HomeScreen으로 전환

HomeScreen
  로그아웃 → authStateChanges 갱신 → LoginScreen으로 복귀
```

## 5. 검증 결과

```bash
flutter analyze   # No issues found!
flutter test      # All tests passed! (LoginScreen 렌더링 스모크 테스트)
```

## 6. 사용자(콘솔) 측 선행 작업

코드는 완성되었으나, 실제 로그인 동작을 확인하려면 Firebase Console에서 다음을
먼저 설정해야 한다.

1. Authentication > Sign-in method > **Email/Password 활성화**
2. Firestore Database **생성** (초기 개발은 Test mode, 배포 전 규칙 적용 필수)
   - 미생성 시 `users/{uid}` 문서 저장 단계에서 오류 발생.

설정 후 실행:

```bash
flutter run -d chrome   # 또는 flutter run -d macos
```

회원가입 → 로그인 → 로그아웃 흐름을 확인할 수 있다.

## 7. 참고 사항 / 후속 과제

- `lib/firebase_options.dart`의 projectId가 `captsone-test`로, `capstone`의 오타로
  보인다. 의도한 프로젝트가 맞는지 확인이 필요하다.
- `firestore.rules`는 로컬 파일이며, 실제 적용은 Firebase Console 또는
  `firebase deploy --only firestore:rules`로 배포해야 한다.
- 다음 단계: Google 로그인(SHA 등록 필요) → Apple 로그인 → Kakao 로그인 전략 결정
  → 케어 그룹/일일 기록 데이터 모델 구현.
