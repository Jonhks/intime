import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login anónimo (MVP)
  Future<User?> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    return result.user;
  }

  /// Usuario actual
  User? get currentUser => _auth.currentUser;

  /// 🔗 Linkear usuario anónimo con Google
  Future<void> linkWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      clientId:
          '586869914327-7sjh1qicnuo711v06raj1rp4lcg8o2gh.apps.googleusercontent.com',
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User? user = _auth.currentUser;

    if (user == null) {
      final result = await _auth.signInAnonymously();
      user = result.user;
    }

    await user!.linkWithCredential(credential);
  }

  /// 🔗 Linkear usuario anónimo con Email + Password
  Future<void> linkWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    await user.linkWithCredential(credential);
  }

  Future<User> ensureAnonymousUser() async {
    User? user = _auth.currentUser;

    if (user == null) {
      final result = await _auth.signInAnonymously();
      user = result.user!;
    }

    return user;
  }
}
