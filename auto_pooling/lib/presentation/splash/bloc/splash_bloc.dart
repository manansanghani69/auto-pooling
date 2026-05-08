import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared_pref/pref_keys.dart';
import '../../../shared_pref/prefs.dart';
import '../../../routes.dart';
import '../../../utils/route_resolver.dart';
import '../constants/splash_constants.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.initial()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<SplashStartedEvent>(_onSplashStartedEvent);
    on<SplashRetryRequestedEvent>(_onSplashRetryRequestedEvent);
  }

  Future<void> _onSplashStartedEvent(
    SplashStartedEvent event,
    Emitter<SplashState> emit,
  ) async {
    await _resolveDestination(emit);
  }

  Future<void> _onSplashRetryRequestedEvent(
    SplashRetryRequestedEvent event,
    Emitter<SplashState> emit,
  ) async {
    await _resolveDestination(emit);
  }

  Future<void> _resolveDestination(Emitter<SplashState> emit) async {
    emit(
      state.copyWith(
        status: SplashStatus.loading,
        clearDestination: true,
        errorMessage: '',
      ),
    );

    try {
      await Future<void>.delayed(SplashConstants.navigationDelay);
      
      final destinationRoute = await RouteResolver.resolveNextRoute();
      SplashDestination resolvedDestination = SplashDestination.home;
      if (destinationRoute is OnboardingRoute) {
        resolvedDestination = SplashDestination.onboarding;
      } else if (destinationRoute is AuthRoute) {
        resolvedDestination = SplashDestination.auth;
      } else if (destinationRoute is ProfileRoute) {
        resolvedDestination = SplashDestination.profile;
      }

      emit(
        state.copyWith(
          status: SplashStatus.resolved,
          destination: resolvedDestination,
          errorMessage: '',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: SplashStatus.failure,
          clearDestination: true,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
