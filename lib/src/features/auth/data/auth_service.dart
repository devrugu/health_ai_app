// lib/src/features/auth/data/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Get instances of the Firebase Auth and Google Sign-In services
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream to listen to authentication state changes
  // This is the most important part for our AuthWrapper.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // --- EMAIL & PASSWORD ---

  // Sign up with email and password
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
      // Handle specific errors like 'email-already-in-use'
      print('Firebase Auth Exception: ${e.message}');
      return null;
    }
  }

  // Sign in with email and password
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
      // Handle errors like 'user-not-found' or 'wrong-password'
      print('Firebase Auth Exception: ${e.message}');
      return null;
    }
  }

  // --- GOOGLE SIGN-IN ---
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception during Google Sign-In: ${e.message}');
      return null;
    }
  }

  // --- PHONE SIGN-IN ---

  // Step 1: Send OTP to the user's phone
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

  // Step 2: Sign in with the OTP
  Future<UserCredential> signInWithOtp({
    // Return type is now non-nullable
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      // If successful, this will return the credential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Re-throw the exception to be caught by the UI layer
      // This is crucial for our new UX logic.
      throw Exception(e.message);
    }
  }

  // --- SIGN OUT ---
  Future<void> signOut() async {
    // We need to sign out of both Google and Firebase
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
