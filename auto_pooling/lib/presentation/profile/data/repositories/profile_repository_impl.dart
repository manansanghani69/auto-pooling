import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/api_failure.dart';
import '../../../../core/usecase/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<ProfileEntity> getProfile() async {
    try {
      final result = await _remoteDataSource.getProfile();
      return Result.success(result.toEntity());
    } on APIException catch (exception) {
      return Result.failure(APIFailure.fromException(exception));
    } catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  ResultFuture<ProfileEntity> updateProfile({
    required String name,
    String? email,
    String? gender,
  }) async {
    try {
      final result = await _remoteDataSource.updateProfile(
        name: name,
        email: email,
        gender: gender,
      );
      return Result.success(result.toEntity());
    } on APIException catch (exception) {
      return Result.failure(APIFailure.fromException(exception));
    } catch (exception) {
      return Result.failure(exception);
    }
  }
}
