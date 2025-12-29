enum AuthStatus {
  initial,
  requestingOtp,
  otpRequested,
  verifyingOtp,
  otpVerified,
  loggingOut,
  logoutSuccess,
  failure,
}

enum AuthAction {
  none,
  requestOtp,
  verifyOtp,
  logout,
}

class AuthState {
  final AuthStatus status;
  final AuthAction lastAction;
  final String phoneNumber;
  final String otp;
  final int otpSecondsRemaining;
  final String errorMessage;

  const AuthState({
    required this.status,
    required this.lastAction,
    required this.phoneNumber,
    required this.otp,
    required this.otpSecondsRemaining,
    required this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(
        status: AuthStatus.initial,
        lastAction: AuthAction.none,
        phoneNumber: '',
        otp: '',
        otpSecondsRemaining: 0,
        errorMessage: '',
      );

  AuthState copyWith({
    AuthStatus? status,
    AuthAction? lastAction,
    String? phoneNumber,
    String? otp,
    int? otpSecondsRemaining,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      lastAction: lastAction ?? this.lastAction,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      otpSecondsRemaining: otpSecondsRemaining ?? this.otpSecondsRemaining,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
