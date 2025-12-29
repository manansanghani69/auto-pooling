import '../../../../core/usecase/result.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _repository;

  const AuthUseCase({required AuthRepository repository})
      : _repository = repository;

  ResultFuture<OtpRequestEntity> requestOtp({
    required String phoneNumber,
  }) {
    return _repository.requestOtp(phoneNumber: phoneNumber);
  }

  ResultFuture<VerifyOtpEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String role,
  }) {
    return _repository.verifyOtp(
      phoneNumber: phoneNumber,
      otp: otp,
      role: role,
    );
  }

  ResultFuture<LogoutEntity> logout() {
    return _repository.logout();
  }
}
