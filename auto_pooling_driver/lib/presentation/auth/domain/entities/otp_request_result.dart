import 'package:equatable/equatable.dart';

class OtpRequestResult extends Equatable {
  const OtpRequestResult({required this.expiresInSeconds, this.debugOtp});

  final int expiresInSeconds;
  final String? debugOtp;

  @override
  List<Object?> get props => <Object?>[expiresInSeconds, debugOtp];
}
