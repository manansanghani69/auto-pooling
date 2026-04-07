import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class AuthPhoneNumberChangedEvent extends AuthEvent {
  const AuthPhoneNumberChangedEvent({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<Object?> get props => <Object?>[phoneNumber];
}

class AuthRequestOtpSubmittedEvent extends AuthEvent {
  const AuthRequestOtpSubmittedEvent();
}

class AuthOtpDigitAppendedEvent extends AuthEvent {
  const AuthOtpDigitAppendedEvent({required this.digit});

  final String digit;

  @override
  List<Object?> get props => <Object?>[digit];
}

class AuthOtpDigitRemovedEvent extends AuthEvent {
  const AuthOtpDigitRemovedEvent();
}

class AuthVerifyOtpSubmittedEvent extends AuthEvent {
  const AuthVerifyOtpSubmittedEvent();
}

class AuthResendOtpRequestedEvent extends AuthEvent {
  const AuthResendOtpRequestedEvent();
}

class AuthResendCountdownTickedEvent extends AuthEvent {
  const AuthResendCountdownTickedEvent();
}

class AuthOtpEditPhoneRequestedEvent extends AuthEvent {
  const AuthOtpEditPhoneRequestedEvent();
}
