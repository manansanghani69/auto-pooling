import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/otp_request_result.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/repositories/auth_repository.dart';

class RequestDriverOtp {
  const RequestDriverOtp({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;

  ResultFuture<OtpRequestResult> call({required String phoneNumber}) {
    return _repository.requestOtp(phoneNumber: phoneNumber);
  }
}
