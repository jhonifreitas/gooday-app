import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gooday/src/models/user_model.dart';
import 'package:gooday/src/providers/user_provider.dart';

class AuthController {
  AuthController(this.context);

  final BuildContext context;

  UserProvider get _userProvider => context.read<UserProvider>();

  // SIGN IN
  Future<UserModel?> signInGoogle() async {
    try {
      final fbUser =
          await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());

      final authId = fbUser.user?.uid;

      if (authId != null) {
        await _userProvider.getByAuthId(authId);
        if (_userProvider.data == null) {
          await _createUser(fbUser);
          await _userProvider.getByAuthId(authId);
        }
      }

      return _userProvider.data;
    } catch (e) {
      debugPrint('Error Google: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> signInFacebook() async {
    try {
      final fbUser = await FirebaseAuth.instance
          .signInWithProvider(FacebookAuthProvider());

      final authId = fbUser.user?.uid;

      if (authId != null) {
        await _userProvider.getByAuthId(authId);
        if (_userProvider.data == null) {
          await _createUser(fbUser);
          await _userProvider.getByAuthId(authId);
        }
      }

      return _userProvider.data;
    } catch (e) {
      debugPrint('Error Facebook: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> signInApple() async {
    try {
      final fbUser =
          await FirebaseAuth.instance.signInWithProvider(AppleAuthProvider());
      final authId = fbUser.user?.uid;

      if (authId != null) {
        await _userProvider.getByAuthId(authId);
        if (_userProvider.data == null) {
          await _createUser(fbUser);
          await _userProvider.getByAuthId(authId);
        }
      }

      return _userProvider.data;
    } catch (e) {
      debugPrint('Error Apple: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> signInEmail(String email, String password) async {
    final fbUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final authId = fbUser.user?.uid;

    if (authId != null) {
      await _userProvider.getByAuthId(authId);
    }
    return _userProvider.data;
  }

  // REGISTER
  Future<UserModel?> registerWithEmail(String email, String password) async {
    final fbUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final authId = fbUser.user?.uid;

    if (authId != null) await _createUser(fbUser);

    return _userProvider.data;
  }

  // RESET PASSWORD
  Future<void> sendPasswordReset(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<String> verifyPasswordResetCode(String code) {
    return FirebaseAuth.instance.verifyPasswordResetCode(code);
  }

  Future<void> passwordResetCode(String newPassword, String code) {
    return FirebaseAuth.instance
        .confirmPasswordReset(newPassword: newPassword, code: code);
  }

  Future<void> passwordReset(String newPassword) async {
    return FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
  }

  // SIGN OUT
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  // FETCH USER
  Future<UserModel?> fetchUser() async {
    final authId = FirebaseAuth.instance.currentUser?.uid;
    if (authId != null) await _userProvider.getByAuthId(authId);
    return _userProvider.data;
  }

  // CREATE USER
  Future<void> _createUser(UserCredential credential) {
    final user = UserModel(
      authId: credential.user!.uid,
      name: credential.user!.displayName,
      email: credential.user!.email,
      image: credential.user!.photoURL,
      phone: credential.user!.phoneNumber?.replaceAll('+55', ''),
    );
    return _userProvider.add(user);
  }
}
