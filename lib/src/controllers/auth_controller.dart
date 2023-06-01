import 'package:firebase_auth/firebase_auth.dart';

import 'package:gooday/src/models/user_model.dart';
import 'package:gooday/src/providers/user_provider.dart';

class AuthController {
  // SIGN IN
  Future<void> signInGoogle() async {
    await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());

    // _createUser(fbUser);
  }

  Future<void> signInFacebook() async {
    await FirebaseAuth.instance.signInWithProvider(FacebookAuthProvider());

    // _createUser(fbUser);
  }

  Future<void> signInApple() async {
    final fbUser =
        await FirebaseAuth.instance.signInWithProvider(AppleAuthProvider());

    _createUser(fbUser);
  }

  Future<void> signInEmail(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  // REGISTER
  Future<void> registerWithEmail(String email, String password) async {
    final fbUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await _createUser(fbUser);
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  Future<String?> fetchUser() async {
    final fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser == null) return null;

    return fbUser.uid;
  }

  Future<void> _createUser(UserCredential credential) async {
    final user = UserModel(
      authId: credential.user!.uid,
      name: credential.user!.displayName ?? '',
      email: credential.user!.email ?? '',
      image: credential.user!.photoURL,
      phone: credential.user!.phoneNumber,
    );
    await UserProvider().add(user);
  }
}
