import 'package:flutter/foundation.dart';

class AppConstants {
  const AppConstants._();

  static const double screenHorizontalPadding = 20.0;
  static const double sectionSpacing = 24.0;
  static const double cardRadius = 24.0;
  static const double tileSpacing = 12.0;

  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
  );

  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _apiBaseUrlOverride;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }

    return 'http://localhost:8080';
  }
}
