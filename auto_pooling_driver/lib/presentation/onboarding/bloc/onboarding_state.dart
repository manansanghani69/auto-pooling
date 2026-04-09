part of 'onboarding_bloc.dart';

enum OnboardingLoadStatus { initial, loading, success, failure }

enum OnboardingSubmissionStatus { initial, loading, success, failure }

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
    this.statusRefreshStatus = OnboardingLoadStatus.initial,
    this.failure,
    this.feedbackMessage,
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
  final OnboardingLoadStatus statusRefreshStatus;
  final Failure? failure;
  final String? feedbackMessage;

  bool get isProfileLoading =>
      profileLoadStatus == OnboardingLoadStatus.loading;

  bool get isSubmittingProfile =>
      profileSubmissionStatus == OnboardingSubmissionStatus.loading;

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
    OnboardingLoadStatus? statusRefreshStatus,
    Failure? failure,
    String? feedbackMessage,
    bool clearGender = false,
    bool clearDateOfBirth = false,
    bool clearFailure = false,
    bool clearFeedbackMessage = false,
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
      statusRefreshStatus: statusRefreshStatus ?? this.statusRefreshStatus,
      failure: clearFailure ? null : failure ?? this.failure,
      feedbackMessage: clearFeedbackMessage
          ? null
          : feedbackMessage ?? this.feedbackMessage,
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
    statusRefreshStatus,
    failure,
    feedbackMessage,
  ];
}
