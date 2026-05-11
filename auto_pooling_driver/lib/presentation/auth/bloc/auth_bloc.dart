import 'dart:async';

import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_event.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_state.dart';
import 'package:auto_pooling_driver/presentation/auth/constants/auth_constants.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/otp_request_result.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/usecases/request_driver_otp.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/usecases/verify_driver_otp.dart';
import 'package:auto_pooling_driver/services/auth_session_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RequestDriverOtp requestDriverOtp,
    required VerifyDriverOtp verifyDriverOtp,
    required AuthSessionService authSessionService,
  }) : _requestDriverOtp = requestDriverOtp,
       _verifyDriverOtp = verifyDriverOtp,
       _authSessionService = authSessionService,
       super(const AuthState()) {
    _setupEventListener();
  }

  final RequestDriverOtp _requestDriverOtp;
  final VerifyDriverOtp _verifyDriverOtp;
  final AuthSessionService _authSessionService;
  Timer? _resendTimer;

  void _setupEventListener() {
    on<AuthPhoneNumberChangedEvent>(_onAuthPhoneNumberChangedEvent);
    on<AuthRequestOtpSubmittedEvent>(_onAuthRequestOtpSubmittedEvent);
    on<AuthOtpDigitAppendedEvent>(_onAuthOtpDigitAppendedEvent);
    on<AuthOtpDigitRemovedEvent>(_onAuthOtpDigitRemovedEvent);
    on<AuthVerifyOtpSubmittedEvent>(_onAuthVerifyOtpSubmittedEvent);
    on<AuthResendOtpRequestedEvent>(_onAuthResendOtpRequestedEvent);
    on<AuthResendCountdownTickedEvent>(_onAuthResendCountdownTickedEvent);
    on<AuthOtpEditPhoneRequestedEvent>(_onAuthOtpEditPhoneRequestedEvent);
    on<AuthHelpRequestedEvent>(_onAuthHelpRequestedEvent);
  }

  Future<void> _onAuthPhoneNumberChangedEvent(
    AuthPhoneNumberChangedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final String normalizedPhoneNumber = AuthFormatters.normalizePhoneNumber(
      event.phoneNumber,
    );
    final String trimmedPhoneNumber =
        normalizedPhoneNumber.length > AuthConstants.phoneNumberLength
        ? normalizedPhoneNumber.substring(0, AuthConstants.phoneNumberLength)
        : normalizedPhoneNumber;

    emit(
      state.copyWith(
        phoneNumber: trimmedPhoneNumber,
        requestOtpStatus: AuthSubmissionStatus.initial,
        clearRequestOtpFailure: true,
        clearOnboardingStatus: true,
      ),
    );
  }

  Future<void> _onAuthRequestOtpSubmittedEvent(
    AuthRequestOtpSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isRequestingOtp) {
      return;
    }

    if (state.normalizedPhoneNumber.length != AuthConstants.phoneNumberLength) {
      emit(
        state.copyWith(
          requestOtpStatus: AuthSubmissionStatus.failure,
          requestOtpFailure: const ValidationFailure(),
          clearOnboardingStatus: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        requestOtpStatus: AuthSubmissionStatus.loading,
        verifyOtpStatus: AuthSubmissionStatus.initial,
        otpCode: '',
        clearRequestOtpFailure: true,
        clearVerifyOtpFailure: true,
        clearOnboardingStatus: true,
      ),
    );

    final result = await _requestDriverOtp(
      phoneNumber: state.normalizedPhoneNumber,
    );

    result.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            requestOtpStatus: AuthSubmissionStatus.failure,
            requestOtpFailure: failure,
          ),
        );
      },
      (OtpRequestResult requestResult) {
        emit(
          state.copyWith(
            requestOtpStatus: AuthSubmissionStatus.success,
            requestedPhoneNumber: state.normalizedPhoneNumber,
            otpCode: '',
            verifyOtpStatus: AuthSubmissionStatus.initial,
            clearRequestOtpFailure: true,
            clearVerifyOtpFailure: true,
          ),
        );
        _startResendCountdown(
          expiresInSeconds: requestResult.expiresInSeconds,
          emit: emit,
        );
      },
    );
  }

  Future<void> _onAuthOtpDigitAppendedEvent(
    AuthOtpDigitAppendedEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isVerifyingOtp ||
        state.otpCode.length >= AuthConstants.otpLength) {
      return;
    }

    final String nextDigit = event.digit.trim();
    if (!RegExp(r'^\d$').hasMatch(nextDigit)) {
      return;
    }

    emit(
      state.copyWith(
        otpCode: '${state.otpCode}$nextDigit',
        verifyOtpStatus: AuthSubmissionStatus.initial,
        clearVerifyOtpFailure: true,
      ),
    );
  }

  Future<void> _onAuthOtpDigitRemovedEvent(
    AuthOtpDigitRemovedEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isVerifyingOtp || state.otpCode.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        otpCode: state.otpCode.substring(0, state.otpCode.length - 1),
        verifyOtpStatus: AuthSubmissionStatus.initial,
        clearVerifyOtpFailure: true,
      ),
    );
  }

  Future<void> _onAuthVerifyOtpSubmittedEvent(
    AuthVerifyOtpSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isVerifyingOtp) {
      return;
    }

    if (state.otpCode.length != AuthConstants.otpLength) {
      emit(
        state.copyWith(
          verifyOtpStatus: AuthSubmissionStatus.failure,
          verifyOtpFailure: const ValidationFailure(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        verifyOtpStatus: AuthSubmissionStatus.loading,
        clearVerifyOtpFailure: true,
      ),
    );

    final result = await _verifyDriverOtp(
      phoneNumber: state.activePhoneNumber,
      otpCode: state.otpCode,
    );

    await result.fold<Future<void>>(
      (Failure failure) async {
        emit(
          state.copyWith(
            verifyOtpStatus: AuthSubmissionStatus.failure,
            verifyOtpFailure: failure,
          ),
        );
      },
      (DriverSession session) async {
        _cancelResendTimer();
        await _authSessionService.saveSession(session);
        emit(
          state.copyWith(
            verifyOtpStatus: AuthSubmissionStatus.success,
            onboardingStatus: session.onboardingStatus,
            clearVerifyOtpFailure: true,
          ),
        );
      },
    );
  }

  Future<void> _onAuthHelpRequestedEvent(
    AuthHelpRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(helpDialogRequestCount: state.helpDialogRequestCount + 1),
    );
  }

  Future<void> _onAuthResendOtpRequestedEvent(
    AuthResendOtpRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isResendAvailable || state.activePhoneNumber.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        requestOtpStatus: AuthSubmissionStatus.loading,
        verifyOtpStatus: AuthSubmissionStatus.initial,
        otpCode: '',
        clearRequestOtpFailure: true,
        clearVerifyOtpFailure: true,
      ),
    );

    final result = await _requestDriverOtp(
      phoneNumber: state.activePhoneNumber,
    );

    result.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            requestOtpStatus: AuthSubmissionStatus.failure,
            requestOtpFailure: failure,
          ),
        );
      },
      (OtpRequestResult requestResult) {
        emit(
          state.copyWith(
            requestOtpStatus: AuthSubmissionStatus.success,
            otpCode: '',
            clearRequestOtpFailure: true,
            clearVerifyOtpFailure: true,
          ),
        );
        _startResendCountdown(
          expiresInSeconds: requestResult.expiresInSeconds,
          emit: emit,
        );
      },
    );
  }

  Future<void> _onAuthResendCountdownTickedEvent(
    AuthResendCountdownTickedEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.resendSecondsRemaining <= 1) {
      _cancelResendTimer();
      emit(state.copyWith(resendSecondsRemaining: 0));
      return;
    }

    emit(
      state.copyWith(resendSecondsRemaining: state.resendSecondsRemaining - 1),
    );
  }

  Future<void> _onAuthOtpEditPhoneRequestedEvent(
    AuthOtpEditPhoneRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    _cancelResendTimer();
    emit(
      state.copyWith(
        requestOtpStatus: AuthSubmissionStatus.initial,
        verifyOtpStatus: AuthSubmissionStatus.initial,
        otpCode: '',
        resendSecondsRemaining: 0,
        clearRequestOtpFailure: true,
        clearVerifyOtpFailure: true,
      ),
    );
  }

  void _startResendCountdown({
    required int expiresInSeconds,
    required Emitter<AuthState> emit,
  }) {
    _cancelResendTimer();
    final int normalizedSeconds = expiresInSeconds > 0 ? expiresInSeconds : 30;
    emit(state.copyWith(resendSecondsRemaining: normalizedSeconds));
    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const AuthResendCountdownTickedEvent()),
    );
  }

  void _cancelResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }

  @override
  Future<void> close() {
    _cancelResendTimer();
    return super.close();
  }
}
