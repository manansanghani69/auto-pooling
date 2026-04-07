import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/repositories/auth_repository.dart';

class VerifyDriverOtp {
  const VerifyDriverOtp({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;

  ResultFuture<DriverSession> call({
    required String phoneNumber,
    required String otpCode,
  }) {
    return _repository.verifyOtp(phoneNumber: phoneNumber, otpCode: otpCode);
  }
}
