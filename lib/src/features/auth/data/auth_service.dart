// lib/src/features/auth/data/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // --- EMAIL & PASSWORD ---
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Exception: ${e.message}');
      }
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Exception: ${e.message}');
      }
      return null;
    }
  }

  // --- GOOGLE SIGN-IN ---
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // The authenticate() method throws an exception if the user cancels.
      // The result is non-nullable.
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // --- THIS IS THE FIX ---
      // We no longer need or have access to the accessToken.
      // The idToken is sufficient for Firebase to create the credential.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Exception during Google Sign-In: ${e.message}');
      }
      return null;
    } on GoogleSignInException catch (e) {
      // This will catch the cancellation exception.
      if (kDebugMode) {
        print('Google Sign-In Exception: ${e.code}');
      }
      return null;
    }
  }

  // --- PHONE SIGN-IN ---
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  // --- SIGN OUT ---
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _firebaseAuth.signOut();
  }
}
