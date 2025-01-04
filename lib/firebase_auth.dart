import 'package:firebase_auth/firebase_auth.dart';

// This class handles Firebase Authentication related methods.
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In with email and password
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Show error if login fails
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Login failed',
      );
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}