import 'package:gooday/screens/home.dart';
import 'package:gooday/screens/auth/login.dart';
import 'package:gooday/screens/intro/screen_1.dart';
import 'package:gooday/screens/intro/screen_2.dart';
import 'package:gooday/screens/intro/screen_3.dart';
import 'package:gooday/screens/auth/new_password.dart';
import 'package:gooday/screens/auth/register/form.dart';
import 'package:gooday/screens/auth/forgot_password.dart';
import 'package:gooday/screens/auth/register/anamnesis.dart';

class Routes {
  static const initalRoute = '/introducao/1';

  static final routes = {
    '/': (context) => const HomeScreen(),
    '/introducao/1': (context) => const IntroScreen1(),
    '/introducao/2': (context) => const IntroScreen2(),
    '/introducao/3': (context) => const IntroScreen3(),
    '/auth/entrar': (context) => const AuthLoginScreen(),
    '/auth/esqueci-senha': (context) => const AuthForgotPasswordScreen(),
    '/auth/nova-senha': (context) => const AuthNewPasswordScreen(),
    '/auth/cadastrar': (context) => const AuthRegisterScreen(),
    '/auth/cadastrar/anamnese': (context) =>
        const AuthRegisterAnamnesisScreen(),
  };
}
