# Firebase Setup Guide

이 문서는 현재 Flutter 프로젝트에 Firebase Authentication과 Cloud Firestore를 단계적으로 붙이기 위한 작업 가이드입니다.

## 현재 상태

- FlutterFire 설정 파일 `lib/firebase_options.dart`가 존재합니다.
- `pubspec.yaml`에 Firebase 기본 패키지가 추가되어 있습니다.
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
- `lib/main.dart`에서 Firebase 초기화 코드가 들어가 있습니다.
- 현재 로그인 화면은 UI 중심이며, 각 로그인 버튼에 실제 Firebase 로그인 로직은 아직 연결되지 않았습니다.

## 1. Firebase 프로젝트 확인

Firebase Console에서 현재 앱이 연결된 프로젝트가 맞는지 확인합니다.

- Console: https://console.firebase.google.com/
- 현재 설정 파일 기준 projectId: `captsone-test`
- 프로젝트 이름이 의도한 이름인지 확인합니다. `captsone`이 오타라면 새 프로젝트 또는 설정 재생성을 고려합니다.

확인할 항목:

- Android 앱 등록 여부
- iOS 앱 등록 여부
- Web 앱 등록 여부
- macOS/Windows를 실제 지원할지 여부
- `google-services.json` 또는 플랫폼별 설정 파일이 최신인지 여부

## 2. Firebase 패키지 추가

프로젝트 루트에서 실행합니다.

```bash
flutter pub add firebase_core firebase_auth cloud_firestore
```

패키지 역할:

- `firebase_core`: Firebase 앱 초기화와 공통 연결
- `firebase_auth`: 이메일, Google, Apple 등 로그인
- `cloud_firestore`: Firestore 데이터베이스 읽기/쓰기

패키지 추가 후 확인합니다.

```bash
flutter pub get
flutter analyze
```

## 3. FlutterFire 설정 확인

Firebase 프로젝트와 Flutter 앱 연결 정보는 FlutterFire CLI로 생성합니다.

```bash
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
```

이 명령으로 보통 다음 파일이 생성 또는 갱신됩니다.

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- iOS/macOS 관련 Firebase 설정 파일

새 플랫폼을 추가하거나 Firebase 제품을 새로 붙이면 `flutterfire configure`를 다시 실행하는 것이 좋습니다.

공식 문서:

- https://firebase.google.com/docs/flutter/setup

## 4. 앱 시작 시 Firebase 초기화

`lib/main.dart`에서 앱 실행 전에 Firebase를 초기화합니다.

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CareTrackerApp());
}
```

중요한 순서:

```dart
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(...);
runApp(...);
```

이 순서를 지키지 않으면 Firebase 플러그인 초기화 전에 앱이 실행되어 런타임 오류가 날 수 있습니다.

## 5. Firebase Console에서 Authentication 활성화

Firebase Console에서 Authentication을 켭니다.

경로:

```text
Firebase Console > Build > Authentication > Sign-in method
```

처음에는 이메일/비밀번호 로그인을 먼저 켜는 것을 추천합니다.

추천 순서:

1. Email/Password
2. Google
3. Apple
4. Kakao

이메일 로그인이 가장 단순해서 Firebase 연결 문제와 UI 문제를 분리해서 확인하기 좋습니다.

공식 문서:

- https://firebase.google.com/docs/auth/flutter/start

## 6. 로그인 상태 라우팅 설계

Firebase Auth는 현재 로그인 상태를 스트림으로 제공합니다.

기본 구조:

```dart
FirebaseAuth.instance.authStateChanges()
```

권장 라우팅:

- `user == null`: 로그인 화면
- `user != null`: 홈 화면

예상 구조:

```text
lib/
  screens/
    login_screen.dart
    home_screen.dart
  auth/
    auth_gate.dart
    auth_service.dart
```

`AuthGate`는 로그인 여부에 따라 화면을 고르는 역할을 맡기고, `LoginScreen`은 버튼과 입력 UI에 집중시키는 것이 좋습니다.

## 7. 이메일 로그인부터 구현

가장 먼저 붙일 기능:

- 회원가입
- 로그인
- 로그아웃
- 에러 메시지 표시

사용할 Firebase Auth API:

```dart
FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);

FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);

FirebaseAuth.instance.signOut();
```

처리해야 할 대표 에러:

- 이메일 형식 오류
- 비밀번호 길이 부족
- 이미 존재하는 이메일
- 사용자 없음
- 비밀번호 불일치
- 네트워크 오류

## 8. Google 로그인 추가

Google 로그인을 붙이려면 Firebase Console에서 Google provider를 활성화합니다.

추가 패키지:

```bash
flutter pub add google_sign_in
```

Android에서 확인할 항목:

- Debug SHA-1 등록
- Release SHA-1 등록
- 필요한 경우 SHA-256 등록
- `google-services.json` 최신화

SHA 값을 등록한 뒤에는 `flutterfire configure`를 다시 실행하거나 설정 파일을 다시 내려받아야 할 수 있습니다.

공식 문서:

- https://firebase.google.com/docs/auth/flutter/federated-auth

## 9. Apple 로그인 추가

Apple 로그인은 iOS 출시를 고려한다면 필요할 가능성이 큽니다.

확인할 항목:

- Apple Developer Program 가입
- Xcode에서 Sign in with Apple capability 추가
- Firebase Console에서 Apple provider 활성화
- 앱 Bundle ID 일치 여부 확인

Apple 로그인은 플랫폼 설정이 많으므로 이메일/Google 로그인이 안정화된 뒤 붙이는 것이 좋습니다.

## 10. Kakao 로그인 전략

Kakao는 Firebase Authentication의 기본 제공 provider가 아닙니다.

선택지는 크게 두 가지입니다.

### 선택지 A: OIDC 사용

Kakao Login은 OpenID Connect를 지원합니다.

확인할 항목:

- Kakao Developers에서 Kakao Login 활성화
- OpenID Connect 활성화
- Redirect URI 설정
- Firebase Authentication with Identity Platform에서 OIDC provider 설정 가능 여부 확인

Kakao OIDC issuer:

```text
https://kauth.kakao.com
```

Kakao 공식 문서:

- https://developers.kakao.com/docs/latest/en/kakaologin/rest-api

### 선택지 B: Custom Token 사용

흐름:

1. Flutter 앱에서 Kakao SDK로 Kakao 로그인
2. Kakao access token 또는 id token을 서버로 전송
3. 서버에서 Kakao 토큰 검증
4. 서버에서 Firebase Admin SDK로 Firebase custom token 생성
5. Flutter 앱에서 `signInWithCustomToken()` 호출

이 방식은 서버 또는 Cloud Functions가 필요하지만, 권한과 사용자 매핑을 더 명확하게 통제할 수 있습니다.

## 11. Firestore 데이터베이스 생성

Firebase Console에서 Firestore를 생성합니다.

경로:

```text
Firebase Console > Build > Firestore Database > Create database
```

초기 개발 중에는 Test mode로 시작할 수 있지만, 실제 배포 전에는 반드시 Security Rules를 잠가야 합니다.

공식 문서:

- https://firebase.google.com/docs/firestore/quickstart

## 12. 사용자 문서 생성

Firebase Auth는 로그인 계정만 관리합니다. 앱에서 필요한 사용자 프로필은 Firestore에 따로 저장하는 것이 좋습니다.

추천 구조:

```text
users/{uid}
  uid
  email
  displayName
  photoUrl
  providerIds
  role
  createdAt
  updatedAt
```

로그인 또는 회원가입 성공 후 `users/{uid}` 문서가 없으면 생성합니다.

예상 코드 흐름:

```dart
final user = FirebaseAuth.instance.currentUser;

await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
```

`createdAt`을 매번 덮어쓰고 싶지 않다면 최초 생성 여부를 먼저 확인하거나 별도 로직으로 분리합니다.

## 13. 앱 데이터 모델 설계

현재 앱 컨셉이 보호자/부모님 케어라면 처음에는 다음 구조가 무난합니다.

```text
users/{uid}

careGroups/{groupId}
  ownerUid
  memberUids
  parentName
  createdAt
  updatedAt

careGroups/{groupId}/dailyRecords/{yyyyMMdd}
  meals
  medicines
  mood
  memo
  checkedBy
  createdAt
  updatedAt
```

설계 기준:

- 개인 정보는 `users/{uid}`에 둡니다.
- 여러 보호자가 함께 보는 데이터는 `careGroups/{groupId}` 아래에 둡니다.
- 하루 단위 기록은 날짜를 문서 ID로 쓰면 조회와 덮어쓰기가 쉽습니다.
- 실시간 위치처럼 자주 바뀌는 데이터는 Firestore 비용을 고려해서 별도 설계를 검토합니다.

## 14. Firestore Security Rules 작성

Firestore는 클라이언트 앱에서 직접 접근하므로 보안 규칙이 필수입니다.

최소 사용자 문서 규칙:

```text
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth != null
                         && request.auth.uid == uid;
    }
  }
}
```

케어 그룹 예시:

```text
service cloud.firestore {
  match /databases/{database}/documents {
    match /careGroups/{groupId} {
      allow read: if request.auth != null
                  && request.auth.uid in resource.data.memberUids;

      allow create: if request.auth != null
                    && request.auth.uid == request.resource.data.ownerUid;

      allow update, delete: if request.auth != null
                            && request.auth.uid == resource.data.ownerUid;

      match /dailyRecords/{recordId} {
        allow read, write: if request.auth != null
                           && request.auth.uid in get(/databases/$(database)/documents/careGroups/$(groupId)).data.memberUids;
      }
    }
  }
}
```

실제 배포 전에는 규칙을 더 세밀하게 나눠야 합니다.

검토할 항목:

- 사용자가 자기 문서만 수정 가능한가
- 그룹 멤버가 아닌 사용자가 그룹 데이터를 읽을 수 없는가
- 클라이언트가 `role`, `ownerUid`, `memberUids`를 임의로 조작할 수 없는가
- 삭제 권한이 과하게 열려 있지 않은가

## 15. 로컬 테스트 순서

정적 분석:

```bash
flutter analyze
```

위젯 테스트:

```bash
flutter test
```

웹 실행:

```bash
flutter run -d chrome
```

macOS 실행:

```bash
flutter run -d macos
```

현재 `firebase_options.dart`에서 Linux 설정은 없으므로 다음 명령은 실패하는 것이 정상입니다.

```bash
flutter run -d linux
```

## 16. 기능별 확인 체크리스트

Firebase 초기화:

- 앱 실행 시 Firebase 초기화 에러가 없는가
- `flutter analyze`가 통과하는가
- `flutter test`가 통과하는가

Authentication:

- 이메일 회원가입이 되는가
- 이메일 로그인이 되는가
- 로그아웃이 되는가
- 앱 재시작 후 로그인 상태가 유지되는가
- Firebase Console의 Authentication 사용자 목록에 계정이 생성되는가

Firestore:

- 로그인 성공 후 `users/{uid}` 문서가 생성되는가
- 앱에서 Firestore 데이터를 읽을 수 있는가
- 앱에서 Firestore 데이터를 쓸 수 있는가
- 보안 규칙 적용 후 다른 사용자의 `users/{uid}` 문서 접근이 차단되는가

소셜 로그인:

- Google provider가 Firebase Console에서 활성화되어 있는가
- Android SHA-1/SHA-256이 등록되어 있는가
- iOS Bundle ID가 Firebase 설정과 일치하는가
- Apple capability가 켜져 있는가
- Kakao OIDC 또는 Custom Token 전략을 결정했는가

## 17. 추천 구현 순서

1. Firebase 초기화 유지
2. `AuthGate` 추가
3. 이메일 회원가입/로그인 화면 추가
4. 로그인 성공 시 `users/{uid}` 문서 생성
5. 로그아웃 버튼 추가
6. Firestore Security Rules 작성
7. Google 로그인 추가
8. Apple 로그인 추가
9. Kakao 로그인 전략 결정 후 구현
10. 케어 그룹과 일일 기록 데이터 모델 구현

## 참고 링크

- Firebase Flutter setup: https://firebase.google.com/docs/flutter/setup
- Firebase Auth for Flutter: https://firebase.google.com/docs/auth/flutter/start
- Federated sign-in for Flutter: https://firebase.google.com/docs/auth/flutter/federated-auth
- Cloud Firestore quickstart: https://firebase.google.com/docs/firestore/quickstart
- Kakao Login REST API: https://developers.kakao.com/docs/latest/en/kakaologin/rest-api
