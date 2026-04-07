import 'package:auto_pooling_driver/core/errors/error_reporter.dart';
import 'package:auto_pooling_driver/core/errors/exceptions.dart';
import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/onboarding/data/datasources/driver_onboarding_remote_data_source.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/entities/driver_onboarding_profile.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/repositories/driver_onboarding_repository.dart';
import 'package:auto_pooling_driver/services/auth_session_service.dart';
import 'package:dartz/dartz.dart';

class DriverOnboardingRepositoryImpl implements DriverOnboardingRepository {
  const DriverOnboardingRepositoryImpl({
    required DriverOnboardingRemoteDataSource remoteDataSource,
    required AuthSessionService authSessionService,
    required AppErrorReporter errorReporter,
  }) : _remoteDataSource = remoteDataSource,
       _authSessionService = authSessionService,
       _errorReporter = errorReporter;

  final DriverOnboardingRemoteDataSource _remoteDataSource;
  final AuthSessionService _authSessionService;
  final AppErrorReporter _errorReporter;

  @override
  ResultFuture<DriverOnboardingProfile> createDriverProfile({
    required String fullName,
    required String address,
    required String vehicleType,
    required String vehicleRegistrationNumber,
    required int passengerCapacity,
    String? gender,
  }) async {
    final String? accessToken = _authSessionService.currentSession?.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return const Left<Failure, DriverOnboardingProfile>(
        UnauthorizedFailure(message: 'Please sign in again to continue.'),
      );
    }

    try {
      final DriverOnboardingProfile profile = await _remoteDataSource
          .createDriverProfile(
            accessToken: accessToken,
            fullName: fullName,
            address: address,
            vehicleType: vehicleType,
            vehicleRegistrationNumber: vehicleRegistrationNumber,
            passengerCapacity: passengerCapacity,
            gender: gender,
          );
      return Right<Failure, DriverOnboardingProfile>(profile);
    } on ApiException catch (error) {
      return Left<Failure, DriverOnboardingProfile>(_mapApiFailure(error));
    } on NetworkException catch (error) {
      return Left<Failure, DriverOnboardingProfile>(
        NetworkFailure(message: error.message),
      );
    } catch (error, stackTrace) {
      _errorReporter.recordError(error, stackTrace);
      return Left<Failure, DriverOnboardingProfile>(
        UnexpectedFailure(debugMessage: error.toString()),
      );
    }
  }

  @override
  ResultFuture<DriverOnboardingProfile> getDriverProfile() async {
    final String? accessToken = _authSessionService.currentSession?.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return const Left<Failure, DriverOnboardingProfile>(
        UnauthorizedFailure(message: 'Please sign in again to continue.'),
      );
    }

    try {
      final DriverOnboardingProfile profile = await _remoteDataSource
          .getDriverProfile(accessToken: accessToken);
      return Right<Failure, DriverOnboardingProfile>(profile);
    } on ApiException catch (error) {
      return Left<Failure, DriverOnboardingProfile>(_mapApiFailure(error));
    } on NetworkException catch (error) {
      return Left<Failure, DriverOnboardingProfile>(
        NetworkFailure(message: error.message),
      );
    } catch (error, stackTrace) {
      _errorReporter.recordError(error, stackTrace);
      return Left<Failure, DriverOnboardingProfile>(
        UnexpectedFailure(debugMessage: error.toString()),
      );
    }
  }

  Failure _mapApiFailure(ApiException error) {
    if (error.statusCode == 400) {
      return ValidationFailure(message: error.message);
    }

    if (error.statusCode == 401) {
      return UnauthorizedFailure(message: error.message);
    }

    if (error.statusCode == 403) {
      return ForbiddenFailure(message: error.message);
    }

    if (error.statusCode >= 500) {
      return ServerFailure(message: error.message);
    }

    return UnexpectedFailure(message: error.message);
  }
}
