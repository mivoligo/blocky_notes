import 'package:flutter/material.dart';

enum AppTheme { lightTheme, darkTheme }

final Map<AppTheme, ThemeData> themeData = {
  AppTheme.lightTheme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
  ),
  AppTheme.darkTheme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800],
    scaffoldBackgroundColor: Colors.grey[800],
  )
};
