import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const int _otpTimerSeconds = 30;
  Timer? _otpTimer;

  AuthBloc() : super(AuthState.initial()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<AuthStartedEvent>(_onAuthStartedEvent);
    on<AuthPhoneNumberChangedEvent>(_onAuthPhoneNumberChangedEvent);
    on<AuthOtpTimerStartedEvent>(_onAuthOtpTimerStartedEvent);
    on<AuthOtpTimerTickedEvent>(_onAuthOtpTimerTickedEvent);
  }

  void _onAuthStartedEvent(
    AuthStartedEvent event,
    Emitter<AuthState> emit,
  ) {}

  void _onAuthPhoneNumberChangedEvent(
    AuthPhoneNumberChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.phoneNumber == state.phoneNumber) {
      return;
    }
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  void _onAuthOtpTimerStartedEvent(
    AuthOtpTimerStartedEvent event,
    Emitter<AuthState> emit,
  ) {
    _otpTimer?.cancel();
    emit(state.copyWith(otpSecondsRemaining: _otpTimerSeconds));

    int remaining = _otpTimerSeconds;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= 1;
      if (remaining <= 0) {
        timer.cancel();
        add(const AuthOtpTimerTickedEvent(secondsRemaining: 0));
        return;
      }
      add(AuthOtpTimerTickedEvent(secondsRemaining: remaining));
    });
  }

  void _onAuthOtpTimerTickedEvent(
    AuthOtpTimerTickedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.secondsRemaining == state.otpSecondsRemaining) {
      return;
    }
    emit(state.copyWith(otpSecondsRemaining: event.secondsRemaining));
  }

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }
}
