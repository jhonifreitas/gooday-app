import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:gooday/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    return MaterialApp(
      title: 'Gooday',
      routes: Routes.routes,
      initialRoute: Routes.initalRoute,
      locale: const Locale('br'),
      theme: _theme(),
    );
  }

  ThemeData _theme() {
    return ThemeData(
      useMaterial3: true,
      dialogBackgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      colorSchemeSeed: const Color(0xFF115AA7),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: const ListTileThemeData(textColor: Colors.black),
      cardTheme: const CardTheme(
          color: Colors.white, surfaceTintColor: Colors.transparent),
      progressIndicatorTheme:
          ProgressIndicatorThemeData(linearTrackColor: Colors.grey.shade400),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF115AA7),
        ),
        titleMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF115AA7),
        ),
        titleSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF115AA7),
        ),
      ),
    );
  }
}
