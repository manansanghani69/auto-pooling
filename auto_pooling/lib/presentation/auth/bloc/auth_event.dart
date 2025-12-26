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

class AuthOtpTimerStartedEvent extends AuthEvent {
  const AuthOtpTimerStartedEvent();
}

class AuthOtpTimerTickedEvent extends AuthEvent {
  final int secondsRemaining;

  const AuthOtpTimerTickedEvent({required this.secondsRemaining});
}
