// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Auto Pooling Driver';

  @override
  String get homeTitle => 'Auto Pooling';

  @override
  String get homeHeadline => 'Your driver dashboard is ready.';

  @override
  String get homeSubtitle => 'State management, routing, theming, assets, and code generation are wired into the project baseline.';

  @override
  String get homeLoading => 'Loading dashboard summary...';

  @override
  String get homeErrorTitle => 'Unable to load your dashboard';

  @override
  String get homeErrorDescription => 'Try again in a moment.';

  @override
  String get homeRetryAction => 'Retry';

  @override
  String get homeRefreshAction => 'Refresh summary';

  @override
  String get homeActiveTrips => 'Active trips';

  @override
  String get homeCompletedTrips => 'Completed today';

  @override
  String get homeTodayEarnings => 'Today\'s earnings';

  @override
  String get homeCacheFailure => 'Local dashboard data is unavailable right now.';

  @override
  String get homeUnexpectedFailure => 'Something went wrong while loading the dashboard.';
}
