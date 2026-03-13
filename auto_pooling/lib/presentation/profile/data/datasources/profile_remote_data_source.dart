import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/services/api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  const ProfileRemoteDataSource();

  Future<ProfileUserModel> getProfile();

  Future<ProfileUserModel> updateProfile({
    required String name,
    String? email,
    String? gender,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  static const String _profileEndpoint = '/v1/profile';

  final ApiClient _apiClient;

  const ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ProfileUserModel> getProfile() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        _profileEndpoint,
        requiresAuth: true,
      );
      final data = _extractData(response);
      return ProfileResponseModel.fromJson(data).user;
    } on DioException catch (error) {
      throw APIException(
        message: _dioErrorMessage(error),
        statusCode: error.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<ProfileUserModel> updateProfile({
    required String name,
    String? email,
    String? gender,
  }) async {
    try {
      final response = await _apiClient.request<Map<String, dynamic>>(
        _profileEndpoint,
        method: 'PATCH',
        requiresAuth: true,
        data: {
          'name': name,
          'email': email,
          'gender': gender,
        },
      );
      final data = _extractData(response);
      return ProfileResponseModel.fromJson(data).user;
    } on DioException catch (error) {
      throw APIException(
        message: _dioErrorMessage(error),
        statusCode: error.response?.statusCode ?? 500,
      );
    }
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
