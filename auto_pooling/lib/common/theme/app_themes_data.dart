import 'package:flutter/material.dart';

import '../../widgets/styling/app_colors.dart';

class AppThemesData {
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.light.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.light.primary,
      secondary: AppColors.light.secondary,
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      primaryColor: AppColors.light.primary,
      scaffoldBackgroundColor: AppColors.light.backgroundPrimary,
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.light,
      ],
    );
  }
}
