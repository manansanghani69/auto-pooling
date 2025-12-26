import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<OnboardingPageChangedEvent>(_onPageChanged);
  }

  void _onPageChanged(
    OnboardingPageChangedEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (event.index == state.currentPage) {
      return;
    }
    emit(state.copyWith(currentPage: event.index));
  }
}
