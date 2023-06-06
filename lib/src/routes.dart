import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/pages/home_page.dart';
import 'package:gooday/src/pages/splash_page.dart';
import 'package:gooday/src/pages/intro/one_page.dart';
import 'package:gooday/src/pages/intro/two_page.dart';
import 'package:gooday/src/pages/auth/login_page.dart';
import 'package:gooday/src/pages/intro/three_page.dart';
import 'package:gooday/src/pages/betty/intro_page.dart';
import 'package:gooday/src/pages/goodie/list_page.dart';
import 'package:gooday/src/pages/goal/config_page.dart';
import 'package:gooday/src/pages/betty/config_page.dart';
import 'package:gooday/src/pages/profile/user_page.dart';
import 'package:gooday/src/pages/betty/form/all_page.dart';
import 'package:gooday/src/pages/betty/form/food_page.dart';
import 'package:gooday/src/pages/calculator/meal_page.dart';
import 'package:gooday/src/pages/profile/insulin_page.dart';
import 'package:gooday/src/pages/profile/glycemia_page.dart';
import 'package:gooday/src/pages/betty/form/health_page.dart';
import 'package:gooday/src/pages/auth/register/form_page.dart';
import 'package:gooday/src/pages/betty/form/fitness_page.dart';
import 'package:gooday/src/pages/betty/form/education_page.dart';
import 'package:gooday/src/pages/auth/forgot_password_page.dart';
import 'package:gooday/src/pages/profile/reset_password_page.dart';
import 'package:gooday/src/pages/auth/register/anamnesis_page.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/refeicao',
      builder: (context, state) => const MealFormPage(),
    ),
    GoRoute(
      path: '/goodies',
      builder: (context, state) => const GoodieListPage(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const Placeholder(),
      routes: [
        GoRoute(
          path: 'entrar',
          builder: (context, state) => const AuthLoginPage(),
        ),
        GoRoute(
          path: 'esqueci-senha',
          builder: (context, state) => const AuthForgotPasswordPage(),
        ),
        GoRoute(
          path: 'cadastrar',
          builder: (context, state) => const AuthRegisterPage(),
        ),
        GoRoute(
          path: 'cadastrar/anamnese',
          builder: (context, state) => const AuthRegisterAnamnesisPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/introducao',
      builder: (context, state) => const Placeholder(),
      routes: [
        GoRoute(
          path: '1',
          builder: (context, state) => const IntroOnePage(),
        ),
        GoRoute(
          path: '2',
          builder: (context, state) => const IntroTwoPage(),
        ),
        GoRoute(
          path: '3',
          builder: (context, state) => const IntroThreePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) => const UserPage(),
      routes: [
        GoRoute(
          path: 'redefinir-senha',
          builder: (context, state) => const ResetPasswordPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/config',
      builder: (context, state) => const Placeholder(),
      routes: [
        GoRoute(
          path: 'metas',
          builder: (context, state) => const GoalConfigPage(),
        ),
        GoRoute(
          path: 'glicemia',
          builder: (context, state) => const GlycemiaConfigPage(),
        ),
        GoRoute(
          path: 'insulina',
          builder: (context, state) => const InsulinConfigPage(),
        ),
        GoRoute(
          path: 'betty',
          builder: (context, state) => const BettyConfigPage(),
          routes: [
            GoRoute(
              path: 'introducao',
              builder: (context, state) => const BettyIntroPage(),
            ),
            GoRoute(
              path: 'todos',
              builder: (context, state) => const BettyFormAllPage(),
            ),
            GoRoute(
              path: 'saude',
              builder: (context, state) => const BettyFormHealthPage(),
            ),
            GoRoute(
              path: 'alimentacao',
              builder: (context, state) => const BettyFormFoodPage(),
            ),
            GoRoute(
              path: 'exercicio',
              builder: (context, state) => const BettyFormFitnessPage(),
            ),
            GoRoute(
              path: 'educacao',
              builder: (context, state) => const BettyFormEducationPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
