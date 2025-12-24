import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color textNeutralPrimary;
  final Color textNeutralSecondary;
  final Color backgroundPrimary;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.textNeutralPrimary,
    required this.textNeutralSecondary,
    required this.backgroundPrimary,
  });

  static const AppColors light = AppColors(
    primary: Color(0xFF1E40AF),
    secondary: Color(0xFF14B8A6),
    textNeutralPrimary: Color(0xFF111827),
    textNeutralSecondary: Color(0xFF6B7280),
    backgroundPrimary: Color(0xFFF9FAFB),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? textNeutralPrimary,
    Color? textNeutralSecondary,
    Color? backgroundPrimary,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      textNeutralPrimary: textNeutralPrimary ?? this.textNeutralPrimary,
      textNeutralSecondary: textNeutralSecondary ?? this.textNeutralSecondary,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      textNeutralPrimary:
          Color.lerp(textNeutralPrimary, other.textNeutralPrimary, t) ??
              textNeutralPrimary,
      textNeutralSecondary:
          Color.lerp(textNeutralSecondary, other.textNeutralSecondary, t) ??
              textNeutralSecondary,
      backgroundPrimary:
          Color.lerp(backgroundPrimary, other.backgroundPrimary, t) ??
              backgroundPrimary,
    );
  }
}

extension ThemeContext on BuildContext {
  AppColors get currentTheme =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
