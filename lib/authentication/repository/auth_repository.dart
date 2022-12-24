import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> authenticate({
    String? phoneNumber,
    required String userEmail,
    required String password,
    required bool isLogin,
  }) async {
    try {
      if (isLogin) {
        return await _firebaseAuth.signInWithEmailAndPassword(
          email: userEmail,
          password: password,
        );
      } else {
        return await _firebaseAuth.createUserWithEmailAndPassword(
          email: userEmail,
          password: password,
        );
      }
    } catch (error) {
      rethrow;
    }
  }
}
