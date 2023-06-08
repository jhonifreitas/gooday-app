import 'package:flutter/material.dart';

const primaryColor = Color(0xFF115AA7);
const secondaryColor = Color(0xFFF7C006);
const tertiaryColor = Color(0xFF41BBD9);

final appTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: primaryColor,
  dialogBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomSheetTheme:
      const BottomSheetThemeData(surfaceTintColor: Colors.transparent),
  bottomAppBarTheme:
      const BottomAppBarTheme(surfaceTintColor: Colors.transparent),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.transparent),
  listTileTheme: const ListTileThemeData(textColor: Colors.black),
  cardTheme: const CardTheme(
      color: Colors.white, surfaceTintColor: Colors.transparent),
  progressIndicatorTheme:
      ProgressIndicatorThemeData(linearTrackColor: Colors.grey.shade400),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(width: 1, color: Colors.grey.shade400),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
    titleMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
    titleSmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
  ),
);
