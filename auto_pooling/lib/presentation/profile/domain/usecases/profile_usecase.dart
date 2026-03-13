import '../../../../core/usecase/result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class ProfileUseCase {
  final ProfileRepository _repository;

  const ProfileUseCase({required ProfileRepository repository})
      : _repository = repository;

  ResultFuture<ProfileEntity> getProfile() {
    return _repository.getProfile();
  }

  ResultFuture<ProfileEntity> updateProfile({
    required String name,
    String? email,
    String? gender,
  }) {
    return _repository.updateProfile(
      name: name,
      email: email,
      gender: gender,
    );
  }
}
