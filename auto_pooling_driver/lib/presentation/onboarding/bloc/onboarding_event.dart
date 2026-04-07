part of 'onboarding_bloc.dart';

sealed class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingInitializedEvent extends OnboardingEvent {
  const OnboardingInitializedEvent();
}

class OnboardingFullNameChangedEvent extends OnboardingEvent {
  const OnboardingFullNameChangedEvent({required this.fullName});

  final String fullName;
}

class OnboardingDateOfBirthChangedEvent extends OnboardingEvent {
  const OnboardingDateOfBirthChangedEvent({required this.dateOfBirth});

  final DateTime dateOfBirth;
}

class OnboardingGenderChangedEvent extends OnboardingEvent {
  const OnboardingGenderChangedEvent({required this.gender});

  final String gender;
}

class OnboardingAddressChangedEvent extends OnboardingEvent {
  const OnboardingAddressChangedEvent({required this.address});

  final String address;
}

class OnboardingReferralCodeChangedEvent extends OnboardingEvent {
  const OnboardingReferralCodeChangedEvent({required this.referralCode});

  final String referralCode;
}

class OnboardingVehicleTypeChangedEvent extends OnboardingEvent {
  const OnboardingVehicleTypeChangedEvent({required this.vehicleType});

  final String vehicleType;
}

class OnboardingVehicleRegistrationChangedEvent extends OnboardingEvent {
  const OnboardingVehicleRegistrationChangedEvent({
    required this.registrationNumber,
  });

  final String registrationNumber;
}

class OnboardingPassengerCapacityIncrementedEvent extends OnboardingEvent {
  const OnboardingPassengerCapacityIncrementedEvent();
}

class OnboardingPassengerCapacityDecrementedEvent extends OnboardingEvent {
  const OnboardingPassengerCapacityDecrementedEvent();
}

class OnboardingProfileSubmittedEvent extends OnboardingEvent {
  const OnboardingProfileSubmittedEvent();
}

class OnboardingStatusRefreshRequestedEvent extends OnboardingEvent {
  const OnboardingStatusRefreshRequestedEvent();
}

class OnboardingFeedbackConsumedEvent extends OnboardingEvent {
  const OnboardingFeedbackConsumedEvent();
}
