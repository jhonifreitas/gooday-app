import 'package:gooday/screens/home.dart';

import 'package:gooday/screens/intro.dart';
import 'package:gooday/screens/auth/login.dart';
import 'package:gooday/screens/auth/new_password.dart';
import 'package:gooday/screens/auth/register/form.dart';
import 'package:gooday/screens/auth/forgot_password.dart';
import 'package:gooday/screens/auth/register/anamnesis.dart';

class Routes {
  static const initalRoute = '/introducao';

  static final routes = {
    '/': (context) => const HomeScreen(),
    '/introducao': (context) => const IntroScreen(),
    '/auth/entrar': (context) => const AuthLoginScreen(),
    '/auth/esqueci-senha': (context) => const AuthForgotPasswordScreen(),
    '/auth/nova-senha': (context) => const AuthNewPasswordScreen(),
    '/auth/cadastrar': (context) => const AuthRegisterScreen(),
    '/auth/cadastrar/anamnese': (context) =>
        const AuthRegisterAnamnesisScreen(),
  };
}
