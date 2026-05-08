import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared_pref/pref_keys.dart';
import '../../../shared_pref/prefs.dart';
import '../constants/onboarding_constants.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<OnboardingPageChangedEvent>(_onPageChanged);
    on<OnboardingContinuePressedEvent>(_onContinuePressed);
    on<OnboardingSkipPressedEvent>(_onSkipPressed);
  }

  void _onPageChanged(
    OnboardingPageChangedEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (event.index == state.currentPage) {
      return;
    }
    emit(
      state.copyWith(
        status: OnboardingStatus.ready,
        currentPage: event.index,
        clearRequestedPage: true,
        errorMessage: '',
      ),
    );
  }

  Future<void> _onContinuePressed(
    OnboardingContinuePressedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.currentPage < OnboardingConstants.totalPages - 1) {
      emit(
        state.copyWith(
          status: OnboardingStatus.pageAdvanceRequested,
          requestedPage: state.currentPage + 1,
          errorMessage: '',
        ),
      );
      return;
    }
    await _completeOnboarding(emit);
  }

  Future<void> _onSkipPressed(
    OnboardingSkipPressedEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    await _completeOnboarding(emit);
  }

  Future<void> _completeOnboarding(Emitter<OnboardingState> emit) async {
    if (state.status == OnboardingStatus.completing) {
      return;
    }

    emit(
      state.copyWith(
        status: OnboardingStatus.completing,
        clearRequestedPage: true,
        errorMessage: '',
      ),
    );

    try {
      await Prefs.setBool(PrefKeys.onboardingCompleted, true);
      emit(
        state.copyWith(
          status: OnboardingStatus.completed,
          clearRequestedPage: true,
          errorMessage: '',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          clearRequestedPage: true,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
