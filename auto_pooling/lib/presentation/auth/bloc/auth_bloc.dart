import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/api_failure.dart';
import '../domain/usecases/auth_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const int _otpTimerSeconds = 30;
  Timer? _otpTimer;
  final AuthUseCase _authUseCase;

  AuthBloc({required AuthUseCase authUseCase})
      : _authUseCase = authUseCase,
        super(AuthState.initial()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<AuthStartedEvent>(_onAuthStartedEvent);
    on<AuthPhoneNumberChangedEvent>(_onAuthPhoneNumberChangedEvent);
    on<AuthOtpChangedEvent>(_onAuthOtpChangedEvent);
    on<AuthRequestOtpEvent>(_onAuthRequestOtpEvent);
    on<AuthVerifyOtpEvent>(_onAuthVerifyOtpEvent);
    on<AuthLogoutRequestedEvent>(_onAuthLogoutRequestedEvent);
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
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        otp: '',
        errorMessage: '',
      ),
    );
  }

  void _onAuthOtpChangedEvent(
    AuthOtpChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.otp == state.otp) {
      return;
    }
    emit(
      state.copyWith(
        otp: event.otp,
        errorMessage: '',
      ),
    );
  }

  Future<void> _onAuthRequestOtpEvent(
    AuthRequestOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.requestingOtp) {
      return;
    }
    if (state.phoneNumber.isEmpty) {
      return;
    }
    emit(
      state.copyWith(
        status: AuthStatus.requestingOtp,
        lastAction: AuthAction.requestOtp,
        otp: '',
        errorMessage: '',
      ),
    );
    final result =
        await _authUseCase.requestOtp(phoneNumber: state.phoneNumber);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          lastAction: AuthAction.requestOtp,
          errorMessage: _mapFailureMessage(failure),
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            status: AuthStatus.otpRequested,
            lastAction: AuthAction.requestOtp,
            errorMessage: '',
          ),
        );
        add(const AuthOtpTimerStartedEvent());
      },
    );
  }

  Future<void> _onAuthVerifyOtpEvent(
    AuthVerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.verifyingOtp) {
      return;
    }
    if (state.phoneNumber.isEmpty || state.otp.length != 4) {
      return;
    }
    emit(
      state.copyWith(
        status: AuthStatus.verifyingOtp,
        lastAction: AuthAction.verifyOtp,
        errorMessage: '',
      ),
    );
    final result = await _authUseCase.verifyOtp(
      phoneNumber: state.phoneNumber,
      otp: state.otp,
      role: 'rider',
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          lastAction: AuthAction.verifyOtp,
          errorMessage: _mapFailureMessage(failure),
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: AuthStatus.otpVerified,
          lastAction: AuthAction.verifyOtp,
          errorMessage: '',
          user: data.user,
          isNewUser: data.isNewUser,
        ),
      ),
    );
  }

  Future<void> _onAuthLogoutRequestedEvent(
    AuthLogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.loggingOut) {
      return;
    }
    emit(
      state.copyWith(
        status: AuthStatus.loggingOut,
        lastAction: AuthAction.logout,
        errorMessage: '',
      ),
    );
    final result = await _authUseCase.logout();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          lastAction: AuthAction.logout,
          errorMessage: _mapFailureMessage(failure),
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.logoutSuccess,
          lastAction: AuthAction.logout,
          errorMessage: '',
        ),
      ),
    );
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

  String _mapFailureMessage(Object failure) {
    if (failure is APIFailure) {
      return failure.errorMessage;
    }
    return failure.toString();
  }

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }
}
