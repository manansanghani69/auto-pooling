import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations();

  static AppLocalizations of(BuildContext context) => const AppLocalizations();

  String get appTitle => 'AutoPool';

  String get splashTitle => 'AutoPool';

  String get splashTaglinePrefix => 'Ride together.';

  String get splashTaglineEmphasis => 'Pay less.';

  String get splashFooter => 'Made for India';

  String get onboardingSkip => 'Skip';

  String get onboardingContinue => 'Continue';

  String get onboardingPageOneTitle => 'Smart Savings with Autopool';

  String get onboardingPageOneSubtitle =>
      'Stop paying for empty seats. Share your ride with verified commuters and cut your monthly travel expenses in half.';

  String get onboardingPageTwoTitle => 'Track Every Mile';

  String get onboardingPageTwoSubtitle =>
      'Experience peace of mind with live GPS tracking. Share your route instantly for a safer ride home.';

  String get onboardingPageThreeTitle => 'Verified for Your Safety';

  String get onboardingPageThreeSubtitle =>
      'We perform strict background checks on every driver and vehicle. Commute with confidence knowing you are in safe hands.';

  String get onboardingBadgeSavedLabel => 'Saved';

  String get onboardingBadgeSavedValue => 'Rs 4,500';

  String get onboardingBadgeYourRide => 'Your Ride';

  String get onboardingBadgeYourRideValue => '2 mins away';

  String get onboardingBadgeVerifiedLabel => 'Verified Drivers';

  String get onboardingBadgeVerifiedValues => 'Safe Ride';

  String get authTitle => 'Authentication';

  String get authSubtitle => 'Sign in and manage your rider profile.';

  String get authPhoneTitlePrefix => 'Let\'s get you\n';

  String get authPhoneTitleHighlight => 'moving';

  String get authPhoneSubtitle =>
      'We\'ll send a verification code to your phone number to continue.';

  String get authPhoneCodeLabel => 'Code';

  String get authPhoneCountryCode => '+91';

  String get authPhoneNumberLabel => 'Mobile Number';

  String get authPhoneNumberHint => '98700XXXX';

  String get authPhoneNumberEmptyError => 'Enter your mobile number';

  String get authPhoneNumberInvalidError =>
      'Enter a valid 10-digit mobile number';

  String get authGetOtpButton => 'Get OTP';

  String get authOtpTitle => 'Verification';

  String get authOtpSubtitle => 'Enter the 4-digit code sent to';

  String get authOtpPhoneExample => '+91 99990 12345';

  String get authOtpEditAction => 'Edit';

  String get authOtpResendPrefix => 'Resend code in ';

  String get authOtpResendTime => '00:24';

  String get authOtpResendAction => 'Resend code';

  String get authOtpVerifyButton => 'Verify';

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
