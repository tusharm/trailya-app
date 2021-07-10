import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthentication {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChangesStream => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInAnonymously() async {
    final credentials = await _firebaseAuth.signInAnonymously();
    return credentials.user;
  }

  Future<User?> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;

      if (googleAuth.idToken != null) {
        var userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );

        await FirebaseCrashlytics.instance.setUserIdentifier(userCredential.user!.uid);
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERR_MISSING_GOOGLE_TOKEN',
          message: 'Missing Google ID token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERR_USER_ABORTED_SIGNIN',
        message: 'User sign-in aborted',
      );
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
