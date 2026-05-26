import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication과 Firestore 사용자 문서를 다루는 서비스.
///
/// UI(화면)는 Firebase API를 직접 호출하지 않고 이 서비스만 사용한다.
/// 이렇게 분리하면 나중에 Google/Apple/Kakao 로그인을 추가할 때
/// 화면 코드를 거의 건드리지 않아도 된다.
class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth,
        _firestore = firestore;

  // 생성 시점에 Firebase.instance를 건드리지 않도록 lazy하게 해석한다.
  // (테스트에서 Firebase 초기화 없이 AuthService를 만들 수 있게 한다.)

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  FirebaseAuth get _authInstance => _auth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestoreInstance =>
      _firestore ?? FirebaseFirestore.instance;

  /// 로그인 상태 변화 스트림. AuthGate가 이 값을 구독해 화면을 분기한다.
  Stream<User?> authStateChanges() => _authInstance.authStateChanges();

  /// 현재 로그인된 사용자(없으면 null).
  User? get currentUser => _authInstance.currentUser;

  /// 이메일/비밀번호 회원가입. 성공 시 users/{uid} 문서를 생성한다.
  Future<User> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _authInstance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    await _ensureUserDocument(user);
    return user;
  }

  /// 이메일/비밀번호 로그인. 문서가 없을 수 있으니 보장한다.
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _authInstance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    await _ensureUserDocument(user);
    return user;
  }

  /// 로그아웃.
  Future<void> signOut() => _authInstance.signOut();

  /// users/{uid} 문서가 없으면 생성하고, 있으면 일부 필드만 갱신한다.
  /// createdAt은 최초 1회만 기록되도록 merge 전에 존재 여부를 확인한다.
  Future<void> _ensureUserDocument(User user) async {
    final docRef = _firestoreInstance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    final data = <String, dynamic>{
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'providerIds': user.providerData.map((p) => p.providerId).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (!snapshot.exists) {
      data['createdAt'] = FieldValue.serverTimestamp();
      data['role'] = 'guardian'; // 기본 역할: 보호자
    }

    await docRef.set(data, SetOptions(merge: true));
  }
}

/// FirebaseAuthException 코드를 사용자에게 보여줄 한국어 메시지로 변환한다.
String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return '이메일 형식이 올바르지 않습니다.';
      case 'weak-password':
        return '비밀번호는 6자 이상이어야 합니다.';
      case 'email-already-in-use':
        return '이미 가입된 이메일입니다.';
      case 'user-not-found':
        return '등록되지 않은 이메일입니다.';
      case 'wrong-password':
      case 'invalid-credential':
        return '이메일 또는 비밀번호가 올바르지 않습니다.';
      case 'user-disabled':
        return '비활성화된 계정입니다.';
      case 'network-request-failed':
        return '네트워크 연결을 확인해 주세요.';
      case 'too-many-requests':
        return '잠시 후 다시 시도해 주세요.';
      default:
        return '로그인에 실패했습니다. (${error.code})';
    }
  }
  return '알 수 없는 오류가 발생했습니다.';
}
