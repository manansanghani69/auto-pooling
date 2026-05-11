import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/presentation/auth/constants/auth_constants.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:equatable/equatable.dart';

enum AuthSubmissionStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.phoneNumber = '',
    this.requestedPhoneNumber = '',
    this.otpCode = '',
    this.requestOtpStatus = AuthSubmissionStatus.initial,
    this.verifyOtpStatus = AuthSubmissionStatus.initial,
    this.requestOtpFailure,
    this.verifyOtpFailure,
    this.resendSecondsRemaining = 0,
    this.onboardingStatus,
    this.helpDialogRequestCount = 0,
  });

  final String phoneNumber;
  final String requestedPhoneNumber;
  final String otpCode;
  final AuthSubmissionStatus requestOtpStatus;
  final AuthSubmissionStatus verifyOtpStatus;
  final Failure? requestOtpFailure;
  final Failure? verifyOtpFailure;
  final int resendSecondsRemaining;
  final DriverOnboardingStatus? onboardingStatus;
  final int helpDialogRequestCount;

  bool get isRequestingOtp => requestOtpStatus == AuthSubmissionStatus.loading;

  bool get isVerifyingOtp => verifyOtpStatus == AuthSubmissionStatus.loading;

  bool get canSubmitPhoneNumber =>
      normalizedPhoneNumber.length == AuthConstants.phoneNumberLength &&
      !isRequestingOtp;

  bool get canVerifyOtp =>
      otpCode.length == AuthConstants.otpLength && !isVerifyingOtp;

  bool get isResendAvailable => resendSecondsRemaining == 0 && !isRequestingOtp;

  String get normalizedPhoneNumber =>
      phoneNumber.replaceAll(RegExp(r'\D'), '').trim();

  String get activePhoneNumber =>
      requestedPhoneNumber.isNotEmpty ? requestedPhoneNumber : phoneNumber;

  AuthState copyWith({
    String? phoneNumber,
    String? requestedPhoneNumber,
    String? otpCode,
    AuthSubmissionStatus? requestOtpStatus,
    AuthSubmissionStatus? verifyOtpStatus,
    Failure? requestOtpFailure,
    Failure? verifyOtpFailure,
    int? resendSecondsRemaining,
    DriverOnboardingStatus? onboardingStatus,
    int? helpDialogRequestCount,
    bool clearRequestOtpFailure = false,
    bool clearVerifyOtpFailure = false,
    bool clearOnboardingStatus = false,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      requestedPhoneNumber: requestedPhoneNumber ?? this.requestedPhoneNumber,
      otpCode: otpCode ?? this.otpCode,
      requestOtpStatus: requestOtpStatus ?? this.requestOtpStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      requestOtpFailure: clearRequestOtpFailure
          ? null
          : requestOtpFailure ?? this.requestOtpFailure,
      verifyOtpFailure: clearVerifyOtpFailure
          ? null
          : verifyOtpFailure ?? this.verifyOtpFailure,
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
      onboardingStatus: clearOnboardingStatus
          ? null
          : onboardingStatus ?? this.onboardingStatus,
      helpDialogRequestCount:
          helpDialogRequestCount ?? this.helpDialogRequestCount,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    phoneNumber,
    requestedPhoneNumber,
    otpCode,
    requestOtpStatus,
    verifyOtpStatus,
    requestOtpFailure,
    verifyOtpFailure,
    resendSecondsRemaining,
    onboardingStatus,
    helpDialogRequestCount,
  ];
}
