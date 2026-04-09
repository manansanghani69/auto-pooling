import 'package:auto_pooling_driver/presentation/onboarding/data/models/driver_onboarding_profile_model.dart';
import 'package:auto_pooling_driver/services/api_client.dart';

abstract class DriverOnboardingRemoteDataSource {
  Future<DriverOnboardingProfileModel> getDriverProfile({
    required String accessToken,
  });

  Future<DriverOnboardingProfileModel> createDriverProfile({
    required String accessToken,
    required String fullName,
    required String address,
    required String vehicleType,
    required String vehicleRegistrationNumber,
    required int passengerCapacity,
    String? gender,
  });
}

class DriverOnboardingRemoteDataSourceImpl
    implements DriverOnboardingRemoteDataSource {
  const DriverOnboardingRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<DriverOnboardingProfileModel> createDriverProfile({
    required String accessToken,
    required String fullName,
    required String address,
    required String vehicleType,
    required String vehicleRegistrationNumber,
    required int passengerCapacity,
    String? gender,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'name': fullName,
      'residentail_address': address,
      'vehical_type': vehicleType,
      'vehical_registration_no': vehicleRegistrationNumber,
      'passenger_capacity': passengerCapacity,
    };

    if (gender != null && gender.isNotEmpty) {
      body['gender'] = gender;
    }

    final Map<String, dynamic> response = await _apiClient.post(
      '/v1/profile/driver/create-user',
      body: body,
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    return DriverOnboardingProfileModel.fromJson(response);
  }

  @override
  Future<DriverOnboardingProfileModel> getDriverProfile({
    required String accessToken,
  }) async {
    final Map<String, dynamic> response = await _apiClient.get(
      '/v1/profile',
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    return DriverOnboardingProfileModel.fromJson(response);
  }
}
