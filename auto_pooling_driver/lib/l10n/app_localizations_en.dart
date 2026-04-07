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

  @override
  String get commonNetworkFailure => 'Unable to reach the server right now.';

  @override
  String get commonValidationFailure => 'Please review the highlighted information and try again.';

  @override
  String get commonUnauthorizedFailure => 'Your session is no longer valid. Please sign in again.';

  @override
  String get commonForbiddenFailure => 'You do not have access to complete this action.';

  @override
  String get commonServerFailure => 'The server could not process your request right now.';

  @override
  String get commonUnexpectedFailure => 'Something went wrong. Please try again.';

  @override
  String get commonOkAction => 'OK';

  @override
  String get authLoginTitle => 'Welcome, Partner';

  @override
  String get authLoginSubtitle => 'Enter your mobile number to start driving.';

  @override
  String get authCountryLabel => 'Country';

  @override
  String get authMobileNumberLabel => 'Mobile Number';

  @override
  String get authMobileNumberHint => '9876543210';

  @override
  String get authGetOtpAction => 'Get OTP';

  @override
  String get authTermsAgreement => 'By continuing, you agree to our Terms of Service and Privacy Policy.';

  @override
  String get authHelpAction => 'Trouble logging in?';

  @override
  String get authHelpTitle => 'Login help';

  @override
  String get authHelpDescription => 'Double-check your phone number, request a fresh OTP, and try again. If the issue continues, contact the operations team for driver account support.';

  @override
  String get authStatusPendingTitle => 'Verification Pending';

  @override
  String get authStatusPendingDescription => 'Your documents are currently being reviewed. This usually takes up to 24 hours.';

  @override
  String get authStatusInfoRemainingTitle => 'Complete your driver profile';

  @override
  String get authStatusInfoRemainingDescription => 'Finish your profile details and upload the required documents before you can go online.';

  @override
  String get authStatusRejectedTitle => 'Verification rejected';

  @override
  String get authStatusRejectedDescription => 'Your last document review was rejected. Update the details and upload fresh documents to continue.';

  @override
  String get authStatusUnknownTitle => 'Status unavailable';

  @override
  String get authStatusUnknownDescription => 'We could not confirm your onboarding status right now. Please try again in a moment.';

  @override
  String get authOtpTitle => 'Verification';

  @override
  String get authOtpSubtitle => 'Enter the 4-digit code sent to';

  @override
  String get authEditAction => 'Edit';

  @override
  String get authVerifyAction => 'Verify';

  @override
  String get authResendInAction => 'Resend code in';

  @override
  String get authResendAction => 'Resend code';

  @override
  String get onboardingPersonalDetailsTitle => 'Personal Details';

  @override
  String get onboardingVehicleDetailsTitle => 'Vehicle Details';

  @override
  String get onboardingUploadDocumentsTitle => 'Upload Documents';

  @override
  String get onboardingApplicationStatusTitle => 'Application Status';

  @override
  String get onboardingPersonalHeadline => 'Tell us about yourself';

  @override
  String get onboardingPersonalDescription => 'We need these details to verify your identity and keep the community safe.';

  @override
  String get onboardingVehicleHeadline => 'Tell us about your vehicle';

  @override
  String get onboardingVehicleDescription => 'Select the vehicle you will use for rides and add its core details.';

  @override
  String get onboardingDocumentsHeadline => 'Verify your identity';

  @override
  String get onboardingDocumentsDescription => 'Upload support is pending backend integration, but the document checklist is ready.';

  @override
  String get onboardingFullNameLabel => 'Full Name (as per ID)';

  @override
  String get onboardingFullNameHint => 'e.g. Rahul Kumar';

  @override
  String get onboardingDateOfBirthLabel => 'Date of Birth';

  @override
  String get onboardingDateOfBirthHint => 'Select your date of birth';

  @override
  String get onboardingGenderLabel => 'Gender';

  @override
  String get onboardingGenderMaleLabel => 'Male';

  @override
  String get onboardingGenderFemaleLabel => 'Female';

  @override
  String get onboardingGenderOtherLabel => 'Other';

  @override
  String get onboardingAddressLabel => 'Current Residential Address';

  @override
  String get onboardingAddressHint => 'House No, Street, Area, City, Pincode';

  @override
  String get onboardingReferralCodeLabel => 'Referral Code (Optional)';

  @override
  String get onboardingReferralCodeHint => 'Enter code if any';

  @override
  String get onboardingVerifiedLabel => 'Verified';

  @override
  String get onboardingUploadProfilePhotoAction => 'Upload Profile Photo';

  @override
  String get onboardingSaveContinueAction => 'Save & Continue';

  @override
  String onboardingStepProgress(Object step, Object total) {
    return 'Step $step of $total';
  }

  @override
  String get onboardingVehicleTypeLabel => 'Vehicle Type';

  @override
  String get onboardingVehicleTypeHatchback => 'Hatchback';

  @override
  String get onboardingVehicleTypeSedan => 'Sedan';

  @override
  String get onboardingVehicleTypeSuv => 'SUV';

  @override
  String get onboardingVehicleTypeBike => 'Bike';

  @override
  String get onboardingRegistrationNumberLabel => 'Registration Number';

  @override
  String get onboardingRegistrationNumberHint => 'MH 12 AB 1234';

  @override
  String get onboardingAvailableSeatsLabel => 'Available Seats';

  @override
  String get onboardingPassengerCapacityLabel => 'Passenger Capacity';

  @override
  String get onboardingVehiclePhotoTitle => 'Vehicle Photo';

  @override
  String get onboardingVehiclePhotoDescription => 'Add a clear photo of the vehicle you will drive.';

  @override
  String get onboardingUploadVehiclePhotoAction => 'Upload Vehicle Photo';

  @override
  String get onboardingSubmitDocumentsAction => 'Submit Documents';

  @override
  String get onboardingGetHelpAction => 'Having trouble uploading? Get Help';

  @override
  String get onboardingLicenseTitle => 'Driving License';

  @override
  String get onboardingLicenseDescription => 'Front and back side';

  @override
  String get onboardingVehicleRcTitle => 'Vehicle RC';

  @override
  String get onboardingVehicleRcDescription => 'Registration Certificate';

  @override
  String get onboardingUploadLicenseAction => 'Upload License';

  @override
  String get onboardingUploadRcAction => 'Upload RC';

  @override
  String get onboardingPendingLabel => 'Pending';

  @override
  String get onboardingRequiredLabel => 'Required';

  @override
  String get onboardingRefreshStatusAction => 'Refresh Status';

  @override
  String get onboardingSupportAction => 'Need help? Contact Support';

  @override
  String get onboardingSupportPlaceholderMessage => 'Support contact is not wired yet in this build.';

  @override
  String get onboardingDocumentsPlaceholderMessage => 'Document uploads will be enabled once the upload API is available.';

  @override
  String get onboardingPhotoUploadPlaceholderMessage => 'Profile photo upload will be enabled once the upload API is available.';

  @override
  String get onboardingVehiclePhotoPlaceholderMessage => 'Vehicle photo upload will be enabled once the upload API is available.';

  @override
  String get onboardingVehicleSaveSuccess => 'Vehicle details saved.';

  @override
  String get onboardingStatusPendingDescription => 'Thanks for signing up. Our team is reviewing your details and this usually takes 24 to 48 hours.';

  @override
  String get onboardingApprovedTitle => 'You are approved';

  @override
  String get onboardingApprovedDescription => 'Your account is active now. Refreshing this page will take you to the driver dashboard.';

  @override
  String get onboardingStepsLabel => 'ONBOARDING STEPS';

  @override
  String get onboardingTimelineDocumentsTitle => 'Documents Uploaded';

  @override
  String get onboardingTimelineDocumentsDescription => 'License and registration details received.';

  @override
  String get onboardingTimelineReviewTitle => 'Background Check';

  @override
  String get onboardingTimelineReviewDescription => 'Reviewing your submitted onboarding details.';

  @override
  String get onboardingTimelineApprovalTitle => 'Final Approval';

  @override
  String get onboardingTimelineApprovalDescription => 'Account activation and driver access.';

  @override
  String get onboardingCurrentLabel => 'CURRENT';
}
