import 'package:flutter/material.dart';
import 'package:proyecto_final/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.primaryPurple,
      primaryColor: AppColors.primaryPurple,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        primary: AppColors.primaryPurple,
      ),
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textWhite),
        bodyMedium: TextStyle(color: AppColors.textWhite),
        bodySmall: TextStyle(color: AppColors.textWhite),
      ),
      useMaterial3: true,
    );
  }

  AppTheme._();
}
