import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:auto_pooling_driver/presentation/onboarding/constants/onboarding_constants.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/entities/driver_onboarding_profile.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/usecases/create_driver_profile.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/usecases/get_driver_onboarding_profile.dart';
import 'package:auto_pooling_driver/services/auth_session_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required GetDriverOnboardingProfile getDriverOnboardingProfile,
    required CreateDriverProfile createDriverProfile,
    required AuthSessionService authSessionService,
  }) : _getDriverOnboardingProfile = getDriverOnboardingProfile,
       _createDriverProfile = createDriverProfile,
       _authSessionService = authSessionService,
       super(
         OnboardingState(
           phoneNumber: authSessionService.currentSession?.phoneNumber ?? '',
           onboardingStatus:
               authSessionService.currentSession?.onboardingStatus ??
               DriverOnboardingStatus.infoRemaining,
         ),
       ) {
    _setupEventListener();
  }

  final GetDriverOnboardingProfile _getDriverOnboardingProfile;
  final CreateDriverProfile _createDriverProfile;
  final AuthSessionService _authSessionService;

  void _setupEventListener() {
    on<OnboardingInitializedEvent>(_onInitialized);
    on<OnboardingFullNameChangedEvent>(_onFullNameChanged);
    on<OnboardingDateOfBirthChangedEvent>(_onDateOfBirthChanged);
    on<OnboardingGenderChangedEvent>(_onGenderChanged);
    on<OnboardingAddressChangedEvent>(_onAddressChanged);
    on<OnboardingReferralCodeChangedEvent>(_onReferralChanged);
    on<OnboardingDatePickerRequestedEvent>(_onDatePickerRequested);
    on<OnboardingDatePickerConsumedEvent>(_onDatePickerConsumed);
    on<OnboardingPersonalDetailsContinueRequestedEvent>(
      _onPersonalDetailsContinueRequested,
    );
    on<OnboardingVehicleTypeChangedEvent>(_onVehicleTypeChanged);
    on<OnboardingVehicleRegistrationChangedEvent>(
      _onVehicleRegistrationChanged,
    );
    on<OnboardingPassengerCapacityIncrementedEvent>(
      _onPassengerCapacityIncremented,
    );
    on<OnboardingPassengerCapacityDecrementedEvent>(
      _onPassengerCapacityDecremented,
    );
    on<OnboardingProfileSubmittedEvent>(_onProfileSubmitted);
    on<OnboardingDocumentsSubmittedEvent>(_onDocumentsSubmitted);
    on<OnboardingStatusRefreshRequestedEvent>(_onStatusRefreshRequested);
    on<OnboardingFeedbackRequestedEvent>(_onFeedbackRequested);
    on<OnboardingFeedbackConsumedEvent>(_onFeedbackConsumed);
    on<OnboardingNavigationConsumedEvent>(_onNavigationConsumed);
  }

  Future<void> _onInitialized(
    OnboardingInitializedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.isProfileLoading ||
        state.profileLoadStatus == OnboardingLoadStatus.success) {
      return;
    }

    emit(
      state.copyWith(
        profileLoadStatus: OnboardingLoadStatus.loading,
        clearFailure: true,
      ),
    );

    final result = await _getDriverOnboardingProfile();
    await result.fold<Future<void>>(
      (Failure failure) async {
        emit(
          state.copyWith(
            profileLoadStatus: OnboardingLoadStatus.failure,
            failure: failure,
          ),
        );
      },
      (DriverOnboardingProfile profile) async {
        await _saveStatus(
          onboardingStatus: profile.onboardingStatus,
          hasCompletedProfileDetails: _hasCompletedProfileDetails(
            profile.onboardingStatus,
          ),
        );
        emit(
          state.copyWith(
            fullName: profile.name,
            phoneNumber: profile.phoneNumber.isNotEmpty
                ? profile.phoneNumber
                : state.phoneNumber,
            address: profile.residentialAddress,
            gender: profile.gender,
            vehicleType: profile.vehicleType,
            vehicleRegistrationNumber: profile.vehicleRegistrationNumber,
            passengerCapacity: profile.passengerCapacity,
            onboardingStatus: profile.onboardingStatus,
            profileLoadStatus: OnboardingLoadStatus.success,
            clearFailure: true,
          ),
        );
      },
    );
  }

  Future<void> _onFullNameChanged(
    OnboardingFullNameChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        fullName: event.fullName,
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
        showPersonalValidationErrors: false,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onDateOfBirthChanged(
    OnboardingDateOfBirthChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        dateOfBirth: event.dateOfBirth,
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
        showPersonalValidationErrors: false,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onGenderChanged(
    OnboardingGenderChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        gender: event.gender,
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
        showPersonalValidationErrors: false,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onAddressChanged(
    OnboardingAddressChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        address: event.address,
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
        showPersonalValidationErrors: false,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onReferralChanged(
    OnboardingReferralCodeChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(referralCode: event.referralCode, clearFailure: true));
  }

  Future<void> _onDatePickerRequested(
    OnboardingDatePickerRequestedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(datePickerRequestCount: state.datePickerRequestCount + 1),
    );
  }

  Future<void> _onDatePickerConsumed(
    OnboardingDatePickerConsumedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(datePickerRequestCount: 0));
  }

  Future<void> _onPersonalDetailsContinueRequested(
    OnboardingPersonalDetailsContinueRequestedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (!state.canContinuePersonalDetails) {
      emit(
        state.copyWith(
          showPersonalValidationErrors: true,
          failure: const ValidationFailure(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        showPersonalValidationErrors: false,
        navigationTarget: OnboardingNavigationTarget.vehicleDetails,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onVehicleTypeChanged(
    OnboardingVehicleTypeChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        vehicleType: event.vehicleType,
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
        showVehicleValidationErrors: false,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onVehicleRegistrationChanged(
    OnboardingVehicleRegistrationChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        vehicleRegistrationNumber: event.registrationNumber.toUpperCase(),
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
        showVehicleValidationErrors: false,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onPassengerCapacityIncremented(
    OnboardingPassengerCapacityIncrementedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.passengerCapacity >=
        OnboardingConstants.maximumPassengerCapacity) {
      return;
    }

    emit(
      state.copyWith(
        passengerCapacity: state.passengerCapacity + 1,
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
        showVehicleValidationErrors: false,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onPassengerCapacityDecremented(
    OnboardingPassengerCapacityDecrementedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.passengerCapacity <=
        OnboardingConstants.minimumPassengerCapacity) {
      return;
    }

    emit(
      state.copyWith(
        passengerCapacity: state.passengerCapacity - 1,
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
        showVehicleValidationErrors: false,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onProfileSubmitted(
    OnboardingProfileSubmittedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.isSubmittingProfile) {
      return;
    }

    if (!state.canContinuePersonalDetails) {
      emit(
        state.copyWith(
          profileSubmissionStatus: OnboardingSubmissionStatus.failure,
          failure: const ValidationFailure(),
          showPersonalValidationErrors: true,
        ),
      );
      return;
    }

    if (state.vehicleType.trim().isEmpty ||
        state.vehicleRegistrationNumber.trim().isEmpty) {
      emit(
        state.copyWith(
          profileSubmissionStatus: OnboardingSubmissionStatus.failure,
          failure: const ValidationFailure(),
          showVehicleValidationErrors: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        profileSubmissionStatus: OnboardingSubmissionStatus.loading,
        clearFailure: true,
      ),
    );

    final result = await _createDriverProfile(
      fullName: state.fullName.trim(),
      address: state.address.trim(),
      vehicleType: state.vehicleType.trim(),
      vehicleRegistrationNumber: state.vehicleRegistrationNumber.trim(),
      passengerCapacity: state.passengerCapacity,
      gender: state.gender,
    );

    await result.fold<Future<void>>(
      (Failure failure) async {
        emit(
          state.copyWith(
            profileSubmissionStatus: OnboardingSubmissionStatus.failure,
            failure: failure,
          ),
        );
      },
      (DriverOnboardingProfile profile) async {
        await _saveStatus(
          onboardingStatus: profile.onboardingStatus,
          hasCompletedProfileDetails: true,
        );
        emit(
          state.copyWith(
            phoneNumber: profile.phoneNumber.isNotEmpty
                ? profile.phoneNumber
                : state.phoneNumber,
            onboardingStatus: profile.onboardingStatus,
            profileSubmissionStatus: OnboardingSubmissionStatus.success,
            showVehicleValidationErrors: false,
            clearFailure: true,
          ),
        );
      },
    );
  }

  Future<void> _onDocumentsSubmitted(
    OnboardingDocumentsSubmittedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.isSubmittingDocuments) {
      return;
    }

    emit(
      state.copyWith(
        documentsSubmissionStatus: OnboardingSubmissionStatus.loading,
        clearFailure: true,
      ),
    );

    await _saveStatus(
      onboardingStatus: DriverOnboardingStatus.documentsUploaded,
      hasCompletedProfileDetails: true,
    );

    emit(
      state.copyWith(
        onboardingStatus: DriverOnboardingStatus.documentsUploaded,
        documentsSubmissionStatus: OnboardingSubmissionStatus.success,
        navigationTarget: OnboardingNavigationTarget.splash,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onStatusRefreshRequested(
    OnboardingStatusRefreshRequestedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.isRefreshingStatus) {
      return;
    }

    emit(
      state.copyWith(
        statusRefreshStatus: OnboardingLoadStatus.loading,
        clearFailure: true,
      ),
    );

    final result = await _getDriverOnboardingProfile();
    await result.fold<Future<void>>(
      (Failure failure) async {
        emit(
          state.copyWith(
            statusRefreshStatus: OnboardingLoadStatus.failure,
            failure: failure,
          ),
        );
      },
      (DriverOnboardingProfile profile) async {
        await _saveStatus(
          onboardingStatus: profile.onboardingStatus,
          hasCompletedProfileDetails: _hasCompletedProfileDetails(
            profile.onboardingStatus,
          ),
        );
        emit(
          state.copyWith(
            onboardingStatus: profile.onboardingStatus,
            statusRefreshStatus: OnboardingLoadStatus.success,
            clearFailure: true,
          ),
        );
      },
    );
  }

  Future<void> _onFeedbackConsumed(
    OnboardingFeedbackConsumedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(clearFeedbackMessage: true));
  }

  Future<void> _onFeedbackRequested(
    OnboardingFeedbackRequestedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(feedbackMessage: event.message));
  }

  Future<void> _onNavigationConsumed(
    OnboardingNavigationConsumedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(clearNavigationTarget: true));
  }

  Future<void> _saveStatus({
    required DriverOnboardingStatus onboardingStatus,
    required bool hasCompletedProfileDetails,
  }) async {
    final DriverSession? session = _authSessionService.currentSession;
    if (session == null) {
      return;
    }

    await _authSessionService.saveSession(
      session.copyWith(
        onboardingStatus: onboardingStatus,
        hasCompletedProfileDetails: hasCompletedProfileDetails,
      ),
    );
  }

  bool _hasCompletedProfileDetails(DriverOnboardingStatus status) {
    return status == DriverOnboardingStatus.documentsUploaded ||
        status == DriverOnboardingStatus.approved ||
        status == DriverOnboardingStatus.rejected;
  }
}
