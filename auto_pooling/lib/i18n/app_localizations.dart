import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations();

  static AppLocalizations of(BuildContext context) => const AppLocalizations();

  String get appTitle => 'AutoPool';
  String get splashTitle => 'AutoPool';
  String get splashTaglinePrefix => 'Ride together.';
  String get splashTaglineEmphasis => 'Pay less.';
  String get splashFooter => 'Made for India';
  String get authTitle => 'Authentication';
  String get authSubtitle => 'Sign in and manage your rider profile.';
  String get profileTitle => 'Profile';
  String get profileSubtitle => 'View and update rider details.';
  String get rideRequestTitle => 'Ride Request';
  String get rideRequestSubtitle =>
      'Choose pickup, drop, and pooling preference.';
  String get rideTrackingTitle => 'Live Tracking';
  String get rideTrackingSubtitle =>
      'Track driver and ride status in real time.';
  String get paymentsTitle => 'Payments';
  String get paymentsSubtitle => 'Review fares and complete payment.';
  String get notificationsTitle => 'Notifications';
  String get notificationsSubtitle => 'Receive ride updates and alerts.';
  String get scaffoldOnlyCta => 'Scaffold only';
}
