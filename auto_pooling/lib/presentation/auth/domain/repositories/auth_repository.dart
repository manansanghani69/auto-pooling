import '../../../../core/usecase/result.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<OtpRequestEntity> requestOtp({required String phoneNumber});

  ResultFuture<VerifyOtpEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String role,
  });

  ResultFuture<LogoutEntity> logout();
}
