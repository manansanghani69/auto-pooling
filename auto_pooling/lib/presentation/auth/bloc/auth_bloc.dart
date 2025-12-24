import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<AuthStartedEvent>(_onAuthStartedEvent);
  }

  void _onAuthStartedEvent(
    AuthStartedEvent event,
    Emitter<AuthState> emit,
  ) {}
}
