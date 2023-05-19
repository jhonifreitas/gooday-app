import 'package:flutter/material.dart';

import 'package:gooday/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gooday',
      routes: Routes.routes,
      initialRoute: Routes.initalRoute,
      theme: ThemeData(
        useMaterial3: true,
        dialogBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        colorSchemeSeed: const Color(0xFF115AA7),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF115AA7),
          ),
          titleMedium: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF115AA7),
          ),
        ),
      ),
    );
  }
}
