import '../../../../core/usecase/result.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  const ProfileRepository();

  ResultFuture<ProfileEntity> getProfile();

  ResultFuture<ProfileEntity> updateProfile({
    required String name,
    String? email,
    String? gender,
  });
}
