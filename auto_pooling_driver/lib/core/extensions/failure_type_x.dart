import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/l10n/app_localizations.dart';

extension FailureTypeX on FailureType {
  String resolveMessage(AppLocalizations localization) {
    switch (this) {
      case FailureType.cache:
        return localization.homeCacheFailure;
      case FailureType.unexpected:
        return localization.homeUnexpectedFailure;
    }
  }
}
