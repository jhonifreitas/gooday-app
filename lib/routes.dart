import 'package:gooday/screens/home.dart';
import 'package:gooday/screens/auth/login.dart';
import 'package:gooday/screens/betty/intro.dart';
import 'package:gooday/screens/betty/config.dart';
import 'package:gooday/screens/intro/screen_1.dart';
import 'package:gooday/screens/intro/screen_2.dart';
import 'package:gooday/screens/intro/screen_3.dart';
import 'package:gooday/screens/betty/form/all.dart';
import 'package:gooday/screens/betty/form/food.dart';
import 'package:gooday/screens/auth/new_password.dart';
import 'package:gooday/screens/betty/form/health.dart';
import 'package:gooday/screens/auth/register/form.dart';
import 'package:gooday/screens/betty/form/fitness.dart';
import 'package:gooday/screens/betty/form/education.dart';
import 'package:gooday/screens/auth/forgot_password.dart';
import 'package:gooday/screens/auth/register/anamnesis.dart';

class Routes {
  static const initalRoute = '/';

  static final routes = {
    '/': (context) => const HomeScreen(),
    '/auth/entrar': (context) => const AuthLoginScreen(),
    '/auth/esqueci-senha': (context) => const AuthForgotPasswordScreen(),
    '/auth/nova-senha': (context) => const AuthNewPasswordScreen(),
    '/auth/cadastrar': (context) => const AuthRegisterScreen(),
    '/auth/cadastrar/anamnese': (context) =>
        const AuthRegisterAnamnesisScreen(),
    '/introducao/1': (context) => const IntroScreen1(),
    '/introducao/2': (context) => const IntroScreen2(),
    '/introducao/3': (context) => const IntroScreen3(),
    '/betty/introducao': (context) => const BettyIntroScreen(),
    '/betty/config': (context) => const BettyConfigScreen(),
    '/betty/config/todos': (context) => const BettyFormAllScreen(),
    '/betty/config/saude': (context) => const BettyFormHealthScreen(),
    '/betty/config/alimentacao': (context) => const BettyFormFoodScreen(),
    '/betty/config/exercicio': (context) => const BettyFormFitnessScreen(),
    '/betty/config/educacao': (context) => const BettyFormEducationScreen(),
  };
}
