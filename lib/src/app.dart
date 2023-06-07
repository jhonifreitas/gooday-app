import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:gooday/src/routes.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/controllers/auth_controller.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final user = await AuthController(context).fetchUser();
    if (user == null && context.mounted) context.go('/auth/entrar');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'pt_BR';

    return MaterialApp.router(
      title: 'Gooday',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt')],
      theme: appTheme,
    );
  }
}
