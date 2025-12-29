abstract class AuthEvent {
  const AuthEvent();
}

class AuthStartedEvent extends AuthEvent {
  const AuthStartedEvent();
}

class AuthPhoneNumberChangedEvent extends AuthEvent {
  final String phoneNumber;

  const AuthPhoneNumberChangedEvent({required this.phoneNumber});
}

class AuthOtpChangedEvent extends AuthEvent {
  final String otp;

  const AuthOtpChangedEvent({required this.otp});
}

class AuthRequestOtpEvent extends AuthEvent {
  const AuthRequestOtpEvent();
}

class AuthVerifyOtpEvent extends AuthEvent {
  const AuthVerifyOtpEvent();
}

class AuthLogoutRequestedEvent extends AuthEvent {
  const AuthLogoutRequestedEvent();
}

class AuthOtpTimerStartedEvent extends AuthEvent {
  const AuthOtpTimerStartedEvent();
}

class AuthOtpTimerTickedEvent extends AuthEvent {
  final int secondsRemaining;

  const AuthOtpTimerTickedEvent({required this.secondsRemaining});
}
