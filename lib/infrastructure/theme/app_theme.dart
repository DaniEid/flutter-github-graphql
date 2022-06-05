import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppTheme {
  blueLight,
  blueDark,
}

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.blueLight: ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white70,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.blue,
      cardColor: Colors.blue),
  AppTheme.blueDark: ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.black54,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.white12,
    scaffoldBackgroundColor: Colors.white12,
    primaryColor: Colors.blue[700],
  ),
};
