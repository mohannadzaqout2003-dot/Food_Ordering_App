import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  User? _user;
  User? get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _auth.authStateChanges().listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setError(null);
    _setLoading(true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerWithProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
  }) async {
    _setError(null);
    _setLoading(true);

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = cred.user;
      if (user == null) {
        throw Exception('User is null after registration');
      }

      final fullName = lastName.trim().isNotEmpty
          ? '${firstName.trim()} ${lastName.trim()}'
          : firstName.trim();

      await user.updateDisplayName(fullName);

      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'phone': phone.trim(),
        'email': user.email,
        'photoUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _user = _auth.currentUser;
      _setError(null);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String email, String password) async {
    _setError(null);
    _setLoading(true);

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setError(null);
    _setLoading(true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _setLoading(false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      _user = userCred.user;
      _setError(null);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshUser() async {
    try {
      await _auth.currentUser?.reload();
      _user = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing user: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    _user = null;
    _setError(null);
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
