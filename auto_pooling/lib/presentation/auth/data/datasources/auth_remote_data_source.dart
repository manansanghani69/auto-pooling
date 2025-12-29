import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/services/api_client.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<OtpRequestModel> requestOtp({required String phoneNumber});

  Future<VerifyOtpModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String role,
  });

  Future<LogoutModel> logout({required String refreshToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String _requestOtpEndpoint = '/v1/auth/request-otp';
  static const String _verifyOtpEndpoint = '/v1/auth/verify-otp';
  static const String _logoutEndpoint = '/v1/auth/logout';

  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<OtpRequestModel> requestOtp({required String phoneNumber}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        _requestOtpEndpoint,
        data: {'phone': phoneNumber},
      );
      _ensureSuccess(response);
      final data = _extractData(response);
      return OtpRequestModel.fromJson(data);
    } on DioException catch (error) {
      throw APIException(
        message: _dioErrorMessage(error),
        statusCode: error.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<VerifyOtpModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String role,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        _verifyOtpEndpoint,
        data: {
          'phone': phoneNumber,
          'otp': otp,
          'role': role,
        },
      );
      _ensureSuccess(response);
      final data = _extractData(response);
      return VerifyOtpModel.fromJson(data);
    } on DioException catch (error) {
      throw APIException(
        message: _dioErrorMessage(error),
        statusCode: error.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<LogoutModel> logout({required String refreshToken}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        _logoutEndpoint,
        requiresAuth: true,
        data: {'refreshToken': refreshToken},
      );
      _ensureSuccess(response);
      final data = _extractData(response);
      return LogoutModel.fromJson(data);
    } on DioException catch (error) {
      throw APIException(
        message: _dioErrorMessage(error),
        statusCode: error.response?.statusCode ?? 500,
      );
    }
  }

  void _ensureSuccess(Response response) {
    if (response.statusCode == 200) {
      return;
    }
    throw APIException(
      message: _extractErrorMessage(response),
      statusCode: response.statusCode ?? 500,
    );
  }

  Map<String, dynamic> _extractData(Response response) {
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final data = payload['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
    }
    throw APIException(
      message: 'Invalid response format',
      statusCode: response.statusCode ?? 500,
    );
  }

  String _extractErrorMessage(Response response) {
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final Object? message =
          payload['message'] ?? payload['error'] ?? payload['status'];
      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }
    }
    return response.statusMessage ?? 'Request failed';
  }

  String _dioErrorMessage(DioException error) {
    final response = error.response;
    if (response != null) {
      return _extractErrorMessage(response);
    }
    return error.message ?? 'Network error';
  }
}
