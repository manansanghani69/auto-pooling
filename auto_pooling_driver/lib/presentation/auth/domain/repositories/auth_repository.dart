import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/otp_request_result.dart';

abstract class AuthRepository {
  ResultFuture<OtpRequestResult> requestOtp({required String phoneNumber});

  ResultFuture<DriverSession> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  });
}
