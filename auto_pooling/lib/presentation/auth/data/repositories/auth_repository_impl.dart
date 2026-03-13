import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/api_failure.dart';
import '../../../../core/usecase/result.dart';
import '../../../../shared_pref/pref_keys.dart';
import '../../../../shared_pref/prefs.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<OtpRequestEntity> requestOtp({
    required String phoneNumber,
  }) async {
    try {
      final result =
          await _remoteDataSource.requestOtp(phoneNumber: phoneNumber);
      return Result.success(result.toEntity());
    } on APIException catch (exception) {
      return Result.failure(APIFailure.fromException(exception));
    } catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  ResultFuture<VerifyOtpEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String role,
  }) async {
    try {
      final result = await _remoteDataSource.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
        role: role,
      );
      await _persistAuth(result);
      return Result.success(result.toEntity());
    } on APIException catch (exception) {
      return Result.failure(APIFailure.fromException(exception));
    } catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  ResultFuture<LogoutEntity> logout() async {
    try {
      final refreshToken = await Prefs.getString(PrefKeys.refreshToken) ?? '';
      if (refreshToken.isEmpty) {
        return const Result.failure(
          APIFailure(
            errorMessage: 'Missing refresh token',
            statusCode: 400,
          ),
        );
      }
      final result =
          await _remoteDataSource.logout(refreshToken: refreshToken);
      await _clearAuth();
      return Result.success(result.toEntity());
    } on APIException catch (exception) {
      return Result.failure(APIFailure.fromException(exception));
    } catch (exception) {
      return Result.failure(exception);
    }
  }

  Future<void> _persistAuth(VerifyOtpModel result) async {
    if (result.tokens.accessToken.isNotEmpty) {
      await Prefs.setString(PrefKeys.authToken, result.tokens.accessToken);
    }
    if (result.tokens.refreshToken.isNotEmpty) {
      await Prefs.setString(PrefKeys.refreshToken, result.tokens.refreshToken);
    }
    if (result.user.id.isNotEmpty) {
      await Prefs.setString(PrefKeys.riderId, result.user.id);
    }
    if (result.user.name.isNotEmpty) {
      await Prefs.setString(PrefKeys.profileName, result.user.name);
    }
  }

  Future<void> _clearAuth() async {
    await Prefs.remove(PrefKeys.authToken);
    await Prefs.remove(PrefKeys.refreshToken);
    await Prefs.remove(PrefKeys.riderId);
    await Prefs.remove(PrefKeys.profileName);
    await Prefs.remove(PrefKeys.profileEmail);
    await Prefs.remove(PrefKeys.profileGender);
  }
}
