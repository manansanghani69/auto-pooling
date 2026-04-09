import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/l10n/app_localizations.dart';

extension FailureX on Failure {
  String resolveMessage(AppLocalizations localization) {
    if (message != null && message!.trim().isNotEmpty) {
      return message!;
    }

    switch (type) {
      case FailureType.cache:
        return localization.homeCacheFailure;
      case FailureType.validation:
        return localization.commonValidationFailure;
      case FailureType.unauthorized:
        return localization.commonUnauthorizedFailure;
      case FailureType.forbidden:
        return localization.commonForbiddenFailure;
      case FailureType.network:
        return localization.commonNetworkFailure;
      case FailureType.server:
        return localization.commonServerFailure;
      case FailureType.unexpected:
        return localization.commonUnexpectedFailure;
    }
  }
}
