import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case "weak-password":
        return "The password is too weak.";
      case "email-already-in-use":
        return "This email is already in use.";
      case "invalid-email":
        return "The email format is invalid.";
      case "user-not-found":
        return "This email is not registered. Please create a new account.";
      case "wrong-password":
        return "Incorrect password. Please try again.";
      case "network-request-failed":
        return "Check your internet connection.";
      default:
        return "An unexpected error occurred: ${e.message}";
    }
  }
}
