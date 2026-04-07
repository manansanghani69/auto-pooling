import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/entities/driver_onboarding_profile.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/repositories/driver_onboarding_repository.dart';

class CreateDriverProfile {
  const CreateDriverProfile({required DriverOnboardingRepository repository})
    : _repository = repository;

  final DriverOnboardingRepository _repository;

  ResultFuture<DriverOnboardingProfile> call({
    required String fullName,
    required String address,
    required String vehicleType,
    required String vehicleRegistrationNumber,
    required int passengerCapacity,
    String? gender,
  }) {
    return _repository.createDriverProfile(
      fullName: fullName,
      address: address,
      vehicleType: vehicleType,
      vehicleRegistrationNumber: vehicleRegistrationNumber,
      passengerCapacity: passengerCapacity,
      gender: gender,
    );
  }
}
