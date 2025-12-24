import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

extension LocalizationContext on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this);
}
