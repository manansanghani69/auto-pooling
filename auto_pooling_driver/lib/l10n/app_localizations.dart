import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Pooling Driver'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Pooling'**
  String get homeTitle;

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your driver dashboard is ready.'**
  String get homeHeadline;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'State management, routing, theming, assets, and code generation are wired into the project baseline.'**
  String get homeSubtitle;

  /// No description provided for @homeLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard summary...'**
  String get homeLoading;

  /// No description provided for @homeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your dashboard'**
  String get homeErrorTitle;

  /// No description provided for @homeErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Try again in a moment.'**
  String get homeErrorDescription;

  /// No description provided for @homeRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get homeRetryAction;

  /// No description provided for @homeRefreshAction.
  ///
  /// In en, this message translates to:
  /// **'Refresh summary'**
  String get homeRefreshAction;

  /// No description provided for @homeActiveTrips.
  ///
  /// In en, this message translates to:
  /// **'Active trips'**
  String get homeActiveTrips;

  /// No description provided for @homeCompletedTrips.
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get homeCompletedTrips;

  /// No description provided for @homeTodayEarnings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s earnings'**
  String get homeTodayEarnings;

  /// No description provided for @homeCacheFailure.
  ///
  /// In en, this message translates to:
  /// **'Local dashboard data is unavailable right now.'**
  String get homeCacheFailure;

  /// No description provided for @homeUnexpectedFailure.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading the dashboard.'**
  String get homeUnexpectedFailure;

  /// No description provided for @commonNetworkFailure.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the server right now.'**
  String get commonNetworkFailure;

  /// No description provided for @commonValidationFailure.
  ///
  /// In en, this message translates to:
  /// **'Please review the highlighted information and try again.'**
  String get commonValidationFailure;

  /// No description provided for @commonUnauthorizedFailure.
  ///
  /// In en, this message translates to:
  /// **'Your session is no longer valid. Please sign in again.'**
  String get commonUnauthorizedFailure;

  /// No description provided for @commonForbiddenFailure.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to complete this action.'**
  String get commonForbiddenFailure;

  /// No description provided for @commonServerFailure.
  ///
  /// In en, this message translates to:
  /// **'The server could not process your request right now.'**
  String get commonServerFailure;

  /// No description provided for @commonUnexpectedFailure.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonUnexpectedFailure;

  /// No description provided for @commonOkAction.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOkAction;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Partner'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to start driving.'**
  String get authLoginSubtitle;

  /// No description provided for @authCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get authCountryLabel;

  /// No description provided for @authMobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get authMobileNumberLabel;

  /// No description provided for @authMobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'9876543210'**
  String get authMobileNumberHint;

  /// No description provided for @authGetOtpAction.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get authGetOtpAction;

  /// No description provided for @authTermsAgreement.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy.'**
  String get authTermsAgreement;

  /// No description provided for @authHelpAction.
  ///
  /// In en, this message translates to:
  /// **'Trouble logging in?'**
  String get authHelpAction;

  /// No description provided for @authHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Login help'**
  String get authHelpTitle;

  /// No description provided for @authHelpDescription.
  ///
  /// In en, this message translates to:
  /// **'Double-check your phone number, request a fresh OTP, and try again. If the issue continues, contact the operations team for driver account support.'**
  String get authHelpDescription;

  /// No description provided for @authStatusPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get authStatusPendingTitle;

  /// No description provided for @authStatusPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Your documents are currently being reviewed. This usually takes up to 24 hours.'**
  String get authStatusPendingDescription;

  /// No description provided for @authStatusInfoRemainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your driver profile'**
  String get authStatusInfoRemainingTitle;

  /// No description provided for @authStatusInfoRemainingDescription.
  ///
  /// In en, this message translates to:
  /// **'Finish your profile details and upload the required documents before you can go online.'**
  String get authStatusInfoRemainingDescription;

  /// No description provided for @authStatusRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification rejected'**
  String get authStatusRejectedTitle;

  /// No description provided for @authStatusRejectedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your last document review was rejected. Update the details and upload fresh documents to continue.'**
  String get authStatusRejectedDescription;

  /// No description provided for @authStatusUnknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Status unavailable'**
  String get authStatusUnknownTitle;

  /// No description provided for @authStatusUnknownDescription.
  ///
  /// In en, this message translates to:
  /// **'We could not confirm your onboarding status right now. Please try again in a moment.'**
  String get authStatusUnknownDescription;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to'**
  String get authOtpSubtitle;

  /// No description provided for @authEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get authEditAction;

  /// No description provided for @authVerifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerifyAction;

  /// No description provided for @authResendInAction.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get authResendInAction;

  /// No description provided for @authResendAction.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendAction;

  /// No description provided for @onboardingPersonalDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get onboardingPersonalDetailsTitle;

  /// No description provided for @onboardingVehicleDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get onboardingVehicleDetailsTitle;

  /// No description provided for @onboardingUploadDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get onboardingUploadDocumentsTitle;

  /// No description provided for @onboardingApplicationStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Status'**
  String get onboardingApplicationStatusTitle;

  /// No description provided for @onboardingPersonalHeadline.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get onboardingPersonalHeadline;

  /// No description provided for @onboardingPersonalDescription.
  ///
  /// In en, this message translates to:
  /// **'We need these details to verify your identity and keep the community safe.'**
  String get onboardingPersonalDescription;

  /// No description provided for @onboardingVehicleHeadline.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your vehicle'**
  String get onboardingVehicleHeadline;

  /// No description provided for @onboardingVehicleDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the vehicle you will use for rides and add its core details.'**
  String get onboardingVehicleDescription;

  /// No description provided for @onboardingDocumentsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity'**
  String get onboardingDocumentsHeadline;

  /// No description provided for @onboardingDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload support is pending backend integration, but the document checklist is ready.'**
  String get onboardingDocumentsDescription;

  /// No description provided for @onboardingFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name (as per ID)'**
  String get onboardingFullNameLabel;

  /// No description provided for @onboardingFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rahul Kumar'**
  String get onboardingFullNameHint;

  /// No description provided for @onboardingDateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get onboardingDateOfBirthLabel;

  /// No description provided for @onboardingDateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get onboardingDateOfBirthHint;

  /// No description provided for @onboardingGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get onboardingGenderLabel;

  /// No description provided for @onboardingGenderMaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get onboardingGenderMaleLabel;

  /// No description provided for @onboardingGenderFemaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get onboardingGenderFemaleLabel;

  /// No description provided for @onboardingGenderOtherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onboardingGenderOtherLabel;

  /// No description provided for @onboardingAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Residential Address'**
  String get onboardingAddressLabel;

  /// No description provided for @onboardingAddressHint.
  ///
  /// In en, this message translates to:
  /// **'House No, Street, Area, City, Pincode'**
  String get onboardingAddressHint;

  /// No description provided for @onboardingReferralCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Referral Code (Optional)'**
  String get onboardingReferralCodeLabel;

  /// No description provided for @onboardingReferralCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter code if any'**
  String get onboardingReferralCodeHint;

  /// No description provided for @onboardingVerifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get onboardingVerifiedLabel;

  /// No description provided for @onboardingUploadProfilePhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Photo'**
  String get onboardingUploadProfilePhotoAction;

  /// No description provided for @onboardingSaveContinueAction.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get onboardingSaveContinueAction;

  /// No description provided for @onboardingStepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboardingStepProgress(Object step, Object total);

  /// No description provided for @onboardingVehicleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get onboardingVehicleTypeLabel;

  /// No description provided for @onboardingVehicleTypeHatchback.
  ///
  /// In en, this message translates to:
  /// **'Hatchback'**
  String get onboardingVehicleTypeHatchback;

  /// No description provided for @onboardingVehicleTypeSedan.
  ///
  /// In en, this message translates to:
  /// **'Sedan'**
  String get onboardingVehicleTypeSedan;

  /// No description provided for @onboardingVehicleTypeSuv.
  ///
  /// In en, this message translates to:
  /// **'SUV'**
  String get onboardingVehicleTypeSuv;

  /// No description provided for @onboardingVehicleTypeBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get onboardingVehicleTypeBike;

  /// No description provided for @onboardingRegistrationNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Registration Number'**
  String get onboardingRegistrationNumberLabel;

  /// No description provided for @onboardingRegistrationNumberHint.
  ///
  /// In en, this message translates to:
  /// **'MH 12 AB 1234'**
  String get onboardingRegistrationNumberHint;

  /// No description provided for @onboardingAvailableSeatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Seats'**
  String get onboardingAvailableSeatsLabel;

  /// No description provided for @onboardingPassengerCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Passenger Capacity'**
  String get onboardingPassengerCapacityLabel;

  /// No description provided for @onboardingVehiclePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo'**
  String get onboardingVehiclePhotoTitle;

  /// No description provided for @onboardingVehiclePhotoDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a clear photo of the vehicle you will drive.'**
  String get onboardingVehiclePhotoDescription;

  /// No description provided for @onboardingUploadVehiclePhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Upload Vehicle Photo'**
  String get onboardingUploadVehiclePhotoAction;

  /// No description provided for @onboardingSubmitDocumentsAction.
  ///
  /// In en, this message translates to:
  /// **'Submit Documents'**
  String get onboardingSubmitDocumentsAction;

  /// No description provided for @onboardingGetHelpAction.
  ///
  /// In en, this message translates to:
  /// **'Having trouble uploading? Get Help'**
  String get onboardingGetHelpAction;

  /// No description provided for @onboardingLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get onboardingLicenseTitle;

  /// No description provided for @onboardingLicenseDescription.
  ///
  /// In en, this message translates to:
  /// **'Front and back side'**
  String get onboardingLicenseDescription;

  /// No description provided for @onboardingVehicleRcTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle RC'**
  String get onboardingVehicleRcTitle;

  /// No description provided for @onboardingVehicleRcDescription.
  ///
  /// In en, this message translates to:
  /// **'Registration Certificate'**
  String get onboardingVehicleRcDescription;

  /// No description provided for @onboardingUploadLicenseAction.
  ///
  /// In en, this message translates to:
  /// **'Upload License'**
  String get onboardingUploadLicenseAction;

  /// No description provided for @onboardingUploadRcAction.
  ///
  /// In en, this message translates to:
  /// **'Upload RC'**
  String get onboardingUploadRcAction;

  /// No description provided for @onboardingPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get onboardingPendingLabel;

  /// No description provided for @onboardingRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get onboardingRequiredLabel;

  /// No description provided for @onboardingRefreshStatusAction.
  ///
  /// In en, this message translates to:
  /// **'Refresh Status'**
  String get onboardingRefreshStatusAction;

  /// No description provided for @onboardingSupportAction.
  ///
  /// In en, this message translates to:
  /// **'Need help? Contact Support'**
  String get onboardingSupportAction;

  /// No description provided for @onboardingSupportPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Support contact is not wired yet in this build.'**
  String get onboardingSupportPlaceholderMessage;

  /// No description provided for @onboardingDocumentsPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Document uploads will be enabled once the upload API is available.'**
  String get onboardingDocumentsPlaceholderMessage;

  /// No description provided for @onboardingPhotoUploadPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile photo upload will be enabled once the upload API is available.'**
  String get onboardingPhotoUploadPlaceholderMessage;

  /// No description provided for @onboardingVehiclePhotoPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Vehicle photo upload will be enabled once the upload API is available.'**
  String get onboardingVehiclePhotoPlaceholderMessage;

  /// No description provided for @onboardingVehicleSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details saved.'**
  String get onboardingVehicleSaveSuccess;

  /// No description provided for @onboardingStatusPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Thanks for signing up. Our team is reviewing your details and this usually takes 24 to 48 hours.'**
  String get onboardingStatusPendingDescription;

  /// No description provided for @onboardingApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'You are approved'**
  String get onboardingApprovedTitle;

  /// No description provided for @onboardingApprovedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your account is active now. Refreshing this page will take you to the driver dashboard.'**
  String get onboardingApprovedDescription;

  /// No description provided for @onboardingStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'ONBOARDING STEPS'**
  String get onboardingStepsLabel;

  /// No description provided for @onboardingTimelineDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents Uploaded'**
  String get onboardingTimelineDocumentsTitle;

  /// No description provided for @onboardingTimelineDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'License and registration details received.'**
  String get onboardingTimelineDocumentsDescription;

  /// No description provided for @onboardingTimelineReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Background Check'**
  String get onboardingTimelineReviewTitle;

  /// No description provided for @onboardingTimelineReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Reviewing your submitted onboarding details.'**
  String get onboardingTimelineReviewDescription;

  /// No description provided for @onboardingTimelineApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Final Approval'**
  String get onboardingTimelineApprovalTitle;

  /// No description provided for @onboardingTimelineApprovalDescription.
  ///
  /// In en, this message translates to:
  /// **'Account activation and driver access.'**
  String get onboardingTimelineApprovalDescription;

  /// No description provided for @onboardingCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get onboardingCurrentLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
