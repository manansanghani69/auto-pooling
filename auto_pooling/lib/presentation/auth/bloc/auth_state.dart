enum AuthStatus {
  initial,
}

class AuthState {
  final AuthStatus status;
  final String phoneNumber;
  final int otpSecondsRemaining;

  const AuthState({
    required this.status,
    required this.phoneNumber,
    required this.otpSecondsRemaining,
  });

  factory AuthState.initial() => const AuthState(
        status: AuthStatus.initial,
        phoneNumber: '',
        otpSecondsRemaining: 0,
      );

  AuthState copyWith({
    AuthStatus? status,
    String? phoneNumber,
    int? otpSecondsRemaining,
  }) {
    return AuthState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpSecondsRemaining: otpSecondsRemaining ?? this.otpSecondsRemaining,
    );
  }
}
