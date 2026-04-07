import 'package:auto_pooling_driver/presentation/auth/constants/auth_constants.dart';
import 'package:auto_pooling_driver/presentation/auth/data/models/driver_profile_model.dart';
import 'package:auto_pooling_driver/presentation/auth/data/models/otp_request_result_model.dart';
import 'package:auto_pooling_driver/presentation/auth/data/models/verified_driver_auth_model.dart';
import 'package:auto_pooling_driver/services/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<OtpRequestResultModel> requestOtp({required String phoneNumber});

  Future<VerifiedDriverAuthModel> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  });

  Future<DriverProfileModel> getDriverProfile({
    required String accessToken,
    required bool isNewUser,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<DriverProfileModel> getDriverProfile({
    required String accessToken,
    required bool isNewUser,
  }) async {
    final Map<String, dynamic> response = await _apiClient.get(
      '/v1/profile',
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    return DriverProfileModel.fromJson(response, isNewUser: isNewUser);
  }

  @override
  Future<OtpRequestResultModel> requestOtp({
    required String phoneNumber,
  }) async {
    final Map<String, dynamic> response = await _apiClient.post(
      '/v1/auth/request-otp',
      body: <String, dynamic>{'phone': phoneNumber},
    );

    return OtpRequestResultModel.fromJson(response);
  }

  @override
  Future<VerifiedDriverAuthModel> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    final Map<String, dynamic> response = await _apiClient.post(
      '/v1/auth/verify-otp',
      body: <String, dynamic>{
        'phone': phoneNumber,
        'otp': otpCode,
        'role': AuthConstants.driverRole,
      },
    );

    return VerifiedDriverAuthModel.fromJson(response);
  }
}
