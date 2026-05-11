import 'package:auto_pooling_driver/presentation/auth/bloc/auth_gate_event.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_gate_state.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:auto_pooling_driver/services/auth_session_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGateBloc extends Bloc<AuthGateEvent, AuthGateState> {
  AuthGateBloc({required AuthSessionService authSessionService})
    : _authSessionService = authSessionService,
      super(const AuthGateState()) {
    _setupEventListener();
  }

  final AuthSessionService _authSessionService;

  void _setupEventListener() {
    on<AuthGateStartedEvent>(_onAuthGateStartedEvent);
  }

  Future<void> _onAuthGateStartedEvent(
    AuthGateStartedEvent event,
    Emitter<AuthGateState> emit,
  ) async {
    emit(state.copyWith(status: AuthGateStatus.resolving));
    emit(
      state.copyWith(
        status: AuthGateStatus.resolved,
        routeTarget: _resolveRouteTarget(_authSessionService.currentSession),
      ),
    );
  }

  AuthGateRouteTarget _resolveRouteTarget(DriverSession? session) {
    if (session == null || session.accessToken.trim().isEmpty) {
      return AuthGateRouteTarget.login;
    }

    if (session.hasCompletedOnboarding) {
      return AuthGateRouteTarget.home;
    }

    if (!session.hasCompletedProfileDetails) {
      return AuthGateRouteTarget.personalDetails;
    }

    if (session.hasSubmittedDocuments ||
        session.onboardingStatus == DriverOnboardingStatus.unknown) {
      return AuthGateRouteTarget.applicationStatus;
    }

    return AuthGateRouteTarget.documentUpload;
  }
}
