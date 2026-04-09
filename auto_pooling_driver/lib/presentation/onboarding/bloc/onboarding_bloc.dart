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
    _setupEventHandlers();
  }

  final GetDriverOnboardingProfile _getDriverOnboardingProfile;
  final CreateDriverProfile _createDriverProfile;
  final AuthSessionService _authSessionService;

  void _setupEventHandlers() {
    on<OnboardingInitializedEvent>(_onInitialized);
    on<OnboardingFullNameChangedEvent>(_onFullNameChanged);
    on<OnboardingDateOfBirthChangedEvent>(_onDateOfBirthChanged);
    on<OnboardingGenderChangedEvent>(_onGenderChanged);
    on<OnboardingAddressChangedEvent>(_onAddressChanged);
    on<OnboardingReferralCodeChangedEvent>(_onReferralChanged);
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
    on<OnboardingStatusRefreshRequestedEvent>(_onStatusRefreshRequested);
    on<OnboardingFeedbackConsumedEvent>(_onFeedbackConsumed);
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
    result.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            profileLoadStatus: OnboardingLoadStatus.failure,
            failure: failure,
          ),
        );
      },
      (DriverOnboardingProfile profile) {
        _saveStatus(profile.onboardingStatus);
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

  Future<void> _onVehicleTypeChanged(
    OnboardingVehicleTypeChangedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        vehicleType: event.vehicleType,
        profileSubmissionStatus: OnboardingSubmissionStatus.initial,
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

    result.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            profileSubmissionStatus: OnboardingSubmissionStatus.failure,
            failure: failure,
          ),
        );
      },
      (DriverOnboardingProfile profile) {
        _saveStatus(profile.onboardingStatus);
        emit(
          state.copyWith(
            phoneNumber: profile.phoneNumber.isNotEmpty
                ? profile.phoneNumber
                : state.phoneNumber,
            onboardingStatus: profile.onboardingStatus,
            profileSubmissionStatus: OnboardingSubmissionStatus.success,
            clearFailure: true,
          ),
        );
      },
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
    result.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            statusRefreshStatus: OnboardingLoadStatus.failure,
            failure: failure,
          ),
        );
      },
      (DriverOnboardingProfile profile) {
        _saveStatus(profile.onboardingStatus);
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

  void _saveStatus(DriverOnboardingStatus onboardingStatus) {
    final DriverSession? session = _authSessionService.currentSession;
    if (session == null) {
      return;
    }

    _authSessionService.saveSession(
      session.copyWith(onboardingStatus: onboardingStatus),
    );
  }
}
