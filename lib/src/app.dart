import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:gooday/src/routes.dart';
import 'package:gooday/src/common/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gooday',
      routes: Routes.routes,
      initialRoute: Routes.initalRoute,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt')],
      theme: appTheme,
    );
  }
}
