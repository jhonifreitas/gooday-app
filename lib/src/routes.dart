import 'package:gooday/src/pages/home_page.dart';
import 'package:gooday/src/pages/auth/login.dart';
import 'package:gooday/src/pages/splash_page.dart';
import 'package:gooday/src/pages/betty/intro.dart';
import 'package:gooday/src/pages/betty/config.dart';
import 'package:gooday/src/pages/intro/one_page.dart';
import 'package:gooday/src/pages/intro/two_page.dart';
import 'package:gooday/src/pages/betty/form/all.dart';
import 'package:gooday/src/pages/betty/form/food.dart';
import 'package:gooday/src/pages/intro/three_page.dart';
import 'package:gooday/src/pages/betty/form/health.dart';
import 'package:gooday/src/pages/profile/goal_page.dart';
import 'package:gooday/src/pages/profile/user_page.dart';
import 'package:gooday/src/pages/goodies/list_page.dart';
import 'package:gooday/src/pages/auth/register/form.dart';
import 'package:gooday/src/pages/betty/form/fitness.dart';
import 'package:gooday/src/pages/calculator/meal_page.dart';
import 'package:gooday/src/pages/betty/form/education.dart';
import 'package:gooday/src/pages/auth/forgot_password.dart';
import 'package:gooday/src/pages/profile/insulin_page.dart';
import 'package:gooday/src/pages/profile/glycemia_page.dart';
import 'package:gooday/src/pages/auth/register/anamnesis.dart';
import 'package:gooday/src/pages/profile/reset_password_page.dart';

class Routes {
  static const initalRoute = '/splash';

  static final routes = {
    '/': (context) => const HomePage(),
    '/splash': (context) => const SplashPage(),
    '/auth/entrar': (context) => const AuthLoginPage(),
    '/auth/esqueci-senha': (context) => const AuthForgotPasswordPage(),
    '/auth/cadastrar': (context) => const AuthRegisterPage(),
    '/auth/cadastrar/anamnese': (context) => const AuthRegisterAnamnesisPage(),
    '/introducao/1': (context) => const IntroOnePage(),
    '/introducao/2': (context) => const IntroTwoPage(),
    '/introducao/3': (context) => const IntroThreePage(),
    '/user': (context) => const UserPage(),
    '/user/redefinir-senha': (context) => const ResetPasswordPage(),
    '/refeicao': (context) => const MealFormPage(),
    '/metas/config': (context) => const GoalConfigPage(),
    '/goodies': (context) => const GoodiesListPage(),
    '/glicemia/config': (context) => const GlycemiaConfigPage(),
    '/insulina/config': (context) => const InsulinConfigPage(),
    '/betty/introducao': (context) => const BettyIntroPage(),
    '/betty/config': (context) => const BettyConfigPage(),
    '/betty/config/todos': (context) => const BettyFormAllPage(),
    '/betty/config/saude': (context) => const BettyFormHealthPage(),
    '/betty/config/alimentacao': (context) => const BettyFormFoodPage(),
    '/betty/config/exercicio': (context) => const BettyFormFitnessPage(),
    '/betty/config/educacao': (context) => const BettyFormEducationPage(),
  };
}
