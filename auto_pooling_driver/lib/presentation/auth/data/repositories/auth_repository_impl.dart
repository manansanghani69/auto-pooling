import 'package:auto_pooling_driver/core/errors/error_reporter.dart';
import 'package:auto_pooling_driver/core/errors/exceptions.dart';
import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/auth/constants/auth_constants.dart';
import 'package:auto_pooling_driver/presentation/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auto_pooling_driver/presentation/auth/data/models/verified_driver_auth_model.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/entities/otp_request_result.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AppErrorReporter errorReporter,
  }) : _remoteDataSource = remoteDataSource,
       _errorReporter = errorReporter;

  final AuthRemoteDataSource _remoteDataSource;
  final AppErrorReporter _errorReporter;

  @override
  ResultFuture<OtpRequestResult> requestOtp({
    required String phoneNumber,
  }) async {
    try {
      final OtpRequestResult result = await _remoteDataSource.requestOtp(
        phoneNumber: phoneNumber,
      );
      return Right<Failure, OtpRequestResult>(result);
    } on ApiException catch (error) {
      return Left<Failure, OtpRequestResult>(_mapApiFailure(error));
    } on NetworkException catch (error) {
      return Left<Failure, OtpRequestResult>(
        NetworkFailure(message: error.message),
      );
    } catch (error, stackTrace) {
      _errorReporter.recordError(error, stackTrace);
      return Left<Failure, OtpRequestResult>(
        UnexpectedFailure(debugMessage: error.toString()),
      );
    }
  }

  @override
  ResultFuture<DriverSession> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final VerifiedDriverAuthModel verification = await _remoteDataSource
          .verifyOtp(phoneNumber: phoneNumber, otpCode: otpCode);

      if (verification.role != AuthConstants.driverRole) {
        return Left<Failure, DriverSession>(
          const UnauthorizedFailure(
            message: 'This phone number is not registered as a driver.',
          ),
        );
      }

      if (verification.accessToken.isEmpty ||
          verification.refreshToken.isEmpty) {
        return Left<Failure, DriverSession>(
          const ServerFailure(
            message: 'Login is temporarily unavailable. Please try again.',
          ),
        );
      }

      final driverProfile = await _remoteDataSource.getDriverProfile(
        accessToken: verification.accessToken,
        isNewUser: verification.isNewUser,
      );

      return Right<Failure, DriverSession>(
        DriverSession(
          userId: verification.userId,
          phoneNumber: verification.phoneNumber.isNotEmpty
              ? verification.phoneNumber
              : phoneNumber,
          accessToken: verification.accessToken,
          refreshToken: verification.refreshToken,
          onboardingStatus: driverProfile.onboardingStatus,
          isNewUser: verification.isNewUser,
        ),
      );
    } on ApiException catch (error) {
      return Left<Failure, DriverSession>(_mapApiFailure(error));
    } on NetworkException catch (error) {
      return Left<Failure, DriverSession>(
        NetworkFailure(message: error.message),
      );
    } catch (error, stackTrace) {
      _errorReporter.recordError(error, stackTrace);
      return Left<Failure, DriverSession>(
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
