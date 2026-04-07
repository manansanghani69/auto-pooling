import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/entities/driver_onboarding_profile.dart';

class DriverOnboardingProfileModel extends DriverOnboardingProfile {
  const DriverOnboardingProfileModel({
    required super.phoneNumber,
    required super.onboardingStatus,
    super.name,
    super.residentialAddress,
    super.vehicleType,
    super.vehicleRegistrationNumber,
    super.passengerCapacity,
    super.gender,
  });

  factory DriverOnboardingProfileModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> user =
        data['user'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return DriverOnboardingProfileModel(
      phoneNumber: user['phone_no']?.toString() ?? '',
      onboardingStatus: _resolveStatus(user['onboarding_status']?.toString()),
      name: user['name']?.toString() ?? '',
      residentialAddress: user['residentail_address']?.toString() ?? '',
      vehicleType: user['vehical_type']?.toString() ?? '',
      vehicleRegistrationNumber:
          user['vehical_registration_no']?.toString() ?? '',
      passengerCapacity:
          int.tryParse(user['passenger_capacity']?.toString() ?? '') ?? 3,
      gender: user['gender']?.toString(),
    );
  }

  static DriverOnboardingStatus _resolveStatus(String? rawStatus) {
    switch (rawStatus) {
      case 'approved':
        return DriverOnboardingStatus.approved;
      case 'documents_uploaded':
        return DriverOnboardingStatus.documentsUploaded;
      case 'info_remaining':
        return DriverOnboardingStatus.infoRemaining;
      case 'rejected':
        return DriverOnboardingStatus.rejected;
      default:
        return DriverOnboardingStatus.unknown;
    }
  }
}
