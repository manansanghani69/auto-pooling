import 'package:auto_pooling_driver/common/theme/app_color_palette.dart';
import 'package:auto_pooling_driver/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  AppColorPalette get currentTheme =>
      Theme.of(this).extension<AppColorPalette>()!;

  AppLocalizations get localization => AppLocalizations.of(this)!;
}
