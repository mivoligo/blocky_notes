import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeData: themeData[AppTheme.lightTheme]!));

  final String _isDarkModeKey = 'isDarkMode';

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = await prefs.getBool(_isDarkModeKey) ?? true;
    emit(
      ThemeState(
        themeData: isDarkMode
            ? themeData[AppTheme.darkTheme]!
            : themeData[AppTheme.lightTheme]!,
      ),
    );
  }

  Future<void> updateTheme({required bool isDarkMode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
    emit(
      ThemeState(
        themeData: isDarkMode
            ? themeData[AppTheme.darkTheme]!
            : themeData[AppTheme.lightTheme]!,
      ),
    );
  }
}
