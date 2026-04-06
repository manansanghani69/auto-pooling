import 'package:flutter/material.dart';

class AppColorPalette extends ThemeExtension<AppColorPalette> {
  const AppColorPalette({
    required this.backgroundPrimary,
    required this.backgroundSurface,
    required this.textNeutralPrimary,
    required this.textNeutralSecondary,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.strokeSubtle,
    required this.highlightSurface,
  });

  final Color backgroundPrimary;
  final Color backgroundSurface;
  final Color textNeutralPrimary;
  final Color textNeutralSecondary;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color strokeSubtle;
  final Color highlightSurface;

  static const AppColorPalette light = AppColorPalette(
    backgroundPrimary: Color(0xFFF7F2EA),
    backgroundSurface: Color(0xFFFFFFFF),
    textNeutralPrimary: Color(0xFF1D2A24),
    textNeutralSecondary: Color(0xFF5D6B64),
    accentPrimary: Color(0xFF0B6E6D),
    accentSecondary: Color(0xFFE07A5F),
    strokeSubtle: Color(0xFFE2D9CD),
    highlightSurface: Color(0xFFDDF2EE),
  );

  @override
  AppColorPalette copyWith({
    Color? backgroundPrimary,
    Color? backgroundSurface,
    Color? textNeutralPrimary,
    Color? textNeutralSecondary,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? strokeSubtle,
    Color? highlightSurface,
  }) {
    return AppColorPalette(
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      backgroundSurface: backgroundSurface ?? this.backgroundSurface,
      textNeutralPrimary: textNeutralPrimary ?? this.textNeutralPrimary,
      textNeutralSecondary: textNeutralSecondary ?? this.textNeutralSecondary,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      strokeSubtle: strokeSubtle ?? this.strokeSubtle,
      highlightSurface: highlightSurface ?? this.highlightSurface,
    );
  }

  @override
  AppColorPalette lerp(
    covariant ThemeExtension<AppColorPalette>? other,
    double t,
  ) {
    if (other is! AppColorPalette) {
      return this;
    }

    return AppColorPalette(
      backgroundPrimary:
          Color.lerp(backgroundPrimary, other.backgroundPrimary, t) ??
          backgroundPrimary,
      backgroundSurface:
          Color.lerp(backgroundSurface, other.backgroundSurface, t) ??
          backgroundSurface,
      textNeutralPrimary:
          Color.lerp(textNeutralPrimary, other.textNeutralPrimary, t) ??
          textNeutralPrimary,
      textNeutralSecondary:
          Color.lerp(textNeutralSecondary, other.textNeutralSecondary, t) ??
          textNeutralSecondary,
      accentPrimary:
          Color.lerp(accentPrimary, other.accentPrimary, t) ?? accentPrimary,
      accentSecondary:
          Color.lerp(accentSecondary, other.accentSecondary, t) ??
          accentSecondary,
      strokeSubtle:
          Color.lerp(strokeSubtle, other.strokeSubtle, t) ?? strokeSubtle,
      highlightSurface:
          Color.lerp(highlightSurface, other.highlightSurface, t) ??
          highlightSurface,
    );
  }
}
