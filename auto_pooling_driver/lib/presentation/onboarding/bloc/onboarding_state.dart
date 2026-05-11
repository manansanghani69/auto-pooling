part of 'onboarding_bloc.dart';

enum OnboardingLoadStatus { initial, loading, success, failure }

enum OnboardingSubmissionStatus { initial, loading, success, failure }

enum OnboardingNavigationTarget { vehicleDetails, splash }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.fullName = '',
    this.phoneNumber = '',
    this.address = '',
    this.referralCode = '',
    this.gender,
    this.dateOfBirth,
    this.vehicleType = '',
    this.vehicleRegistrationNumber = '',
    this.passengerCapacity = 3,
    this.onboardingStatus = DriverOnboardingStatus.infoRemaining,
    this.profileLoadStatus = OnboardingLoadStatus.initial,
    this.profileSubmissionStatus = OnboardingSubmissionStatus.initial,
    this.documentsSubmissionStatus = OnboardingSubmissionStatus.initial,
    this.statusRefreshStatus = OnboardingLoadStatus.initial,
    this.failure,
    this.feedbackMessage,
    this.showPersonalValidationErrors = false,
    this.showVehicleValidationErrors = false,
    this.datePickerRequestCount = 0,
    this.navigationTarget,
  });

  final String fullName;
  final String phoneNumber;
  final String address;
  final String referralCode;
  final String? gender;
  final DateTime? dateOfBirth;
  final String vehicleType;
  final String vehicleRegistrationNumber;
  final int passengerCapacity;
  final DriverOnboardingStatus onboardingStatus;
  final OnboardingLoadStatus profileLoadStatus;
  final OnboardingSubmissionStatus profileSubmissionStatus;
  final OnboardingSubmissionStatus documentsSubmissionStatus;
  final OnboardingLoadStatus statusRefreshStatus;
  final Failure? failure;
  final String? feedbackMessage;
  final bool showPersonalValidationErrors;
  final bool showVehicleValidationErrors;
  final int datePickerRequestCount;
  final OnboardingNavigationTarget? navigationTarget;

  bool get isProfileLoading =>
      profileLoadStatus == OnboardingLoadStatus.loading;

  bool get isSubmittingProfile =>
      profileSubmissionStatus == OnboardingSubmissionStatus.loading;

  bool get isSubmittingDocuments =>
      documentsSubmissionStatus == OnboardingSubmissionStatus.loading;

  bool get isRefreshingStatus =>
      statusRefreshStatus == OnboardingLoadStatus.loading;

  bool get canContinuePersonalDetails =>
      fullName.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      gender != null &&
      dateOfBirth != null;

  bool get canSubmitVehicleDetails =>
      canContinuePersonalDetails &&
      vehicleType.trim().isNotEmpty &&
      vehicleRegistrationNumber.trim().isNotEmpty &&
      !isSubmittingProfile;

  String get formattedDateOfBirth {
    final DateTime? value = dateOfBirth;
    if (value == null) {
      return '';
    }

    final String day = value.day.toString().padLeft(2, '0');
    final String month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  OnboardingState copyWith({
    String? fullName,
    String? phoneNumber,
    String? address,
    String? referralCode,
    String? gender,
    DateTime? dateOfBirth,
    String? vehicleType,
    String? vehicleRegistrationNumber,
    int? passengerCapacity,
    DriverOnboardingStatus? onboardingStatus,
    OnboardingLoadStatus? profileLoadStatus,
    OnboardingSubmissionStatus? profileSubmissionStatus,
    OnboardingSubmissionStatus? documentsSubmissionStatus,
    OnboardingLoadStatus? statusRefreshStatus,
    Failure? failure,
    String? feedbackMessage,
    bool? showPersonalValidationErrors,
    bool? showVehicleValidationErrors,
    int? datePickerRequestCount,
    OnboardingNavigationTarget? navigationTarget,
    bool clearGender = false,
    bool clearDateOfBirth = false,
    bool clearFailure = false,
    bool clearFeedbackMessage = false,
    bool clearNavigationTarget = false,
  }) {
    return OnboardingState(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      referralCode: referralCode ?? this.referralCode,
      gender: clearGender ? null : gender ?? this.gender,
      dateOfBirth: clearDateOfBirth ? null : dateOfBirth ?? this.dateOfBirth,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleRegistrationNumber:
          vehicleRegistrationNumber ?? this.vehicleRegistrationNumber,
      passengerCapacity: passengerCapacity ?? this.passengerCapacity,
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      profileLoadStatus: profileLoadStatus ?? this.profileLoadStatus,
      profileSubmissionStatus:
          profileSubmissionStatus ?? this.profileSubmissionStatus,
      documentsSubmissionStatus:
          documentsSubmissionStatus ?? this.documentsSubmissionStatus,
      statusRefreshStatus: statusRefreshStatus ?? this.statusRefreshStatus,
      failure: clearFailure ? null : failure ?? this.failure,
      feedbackMessage: clearFeedbackMessage
          ? null
          : feedbackMessage ?? this.feedbackMessage,
      showPersonalValidationErrors:
          showPersonalValidationErrors ?? this.showPersonalValidationErrors,
      showVehicleValidationErrors:
          showVehicleValidationErrors ?? this.showVehicleValidationErrors,
      datePickerRequestCount:
          datePickerRequestCount ?? this.datePickerRequestCount,
      navigationTarget: clearNavigationTarget
          ? null
          : navigationTarget ?? this.navigationTarget,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    fullName,
    phoneNumber,
    address,
    referralCode,
    gender,
    dateOfBirth,
    vehicleType,
    vehicleRegistrationNumber,
    passengerCapacity,
    onboardingStatus,
    profileLoadStatus,
    profileSubmissionStatus,
    documentsSubmissionStatus,
    statusRefreshStatus,
    failure,
    feedbackMessage,
    showPersonalValidationErrors,
    showVehicleValidationErrors,
    datePickerRequestCount,
    navigationTarget,
  ];
}
