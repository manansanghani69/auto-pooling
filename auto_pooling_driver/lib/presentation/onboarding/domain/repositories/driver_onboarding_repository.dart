import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/entities/driver_onboarding_profile.dart';

abstract class DriverOnboardingRepository {
  ResultFuture<DriverOnboardingProfile> getDriverProfile();

  ResultFuture<DriverOnboardingProfile> createDriverProfile({
    required String fullName,
    required String address,
    required String vehicleType,
    required String vehicleRegistrationNumber,
    required int passengerCapacity,
    String? gender,
  });
}
