import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:trailya/services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});

  final FirebaseAuthentication auth;

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  void dispose() {
    _isLoadingController.close();
  }

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<User?> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}