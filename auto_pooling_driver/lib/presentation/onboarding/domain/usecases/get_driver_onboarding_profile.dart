import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/entities/driver_onboarding_profile.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/repositories/driver_onboarding_repository.dart';

class GetDriverOnboardingProfile {
  const GetDriverOnboardingProfile({
    required DriverOnboardingRepository repository,
  }) : _repository = repository;

  final DriverOnboardingRepository _repository;

  ResultFuture<DriverOnboardingProfile> call() {
    return _repository.getDriverProfile();
  }
}
