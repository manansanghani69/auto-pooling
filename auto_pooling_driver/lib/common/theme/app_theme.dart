import 'package:auto_pooling_driver/common/theme/app_color_palette.dart';
import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    const AppColorPalette palette = AppColorPalette.light;
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: palette.accentPrimary,
      brightness: Brightness.light,
    ).copyWith(
      primary: palette.accentPrimary,
      secondary: palette.accentSecondary,
      surface: palette.backgroundSurface,
      outline: palette.strokeSubtle,
      onSurface: palette.textNeutralPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.backgroundPrimary,
      dividerColor: palette.strokeSubtle,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.backgroundPrimary,
        foregroundColor: palette.textNeutralPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.h1Bold,
        headlineMedium: AppTextStyles.h2Bold,
        bodyLarge: AppTextStyles.p1Medium,
        bodyMedium: AppTextStyles.p2Regular,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.accentPrimary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.accentPrimary,
          foregroundColor: palette.backgroundSurface,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: AppTextStyles.p1Medium,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[palette],
    );
  }
}
