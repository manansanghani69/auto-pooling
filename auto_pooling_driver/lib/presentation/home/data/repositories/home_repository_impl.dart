import 'package:auto_pooling_driver/core/errors/error_reporter.dart';
import 'package:auto_pooling_driver/core/errors/exceptions.dart';
import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/home/data/datasources/home_local_data_source.dart';
import 'package:auto_pooling_driver/presentation/home/domain/entities/dashboard_summary.dart';
import 'package:auto_pooling_driver/presentation/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required HomeLocalDataSource localDataSource,
    required AppErrorReporter errorReporter,
  })  : _localDataSource = localDataSource,
        _errorReporter = errorReporter;

  final HomeLocalDataSource _localDataSource;
  final AppErrorReporter _errorReporter;

  @override
  ResultFuture<DashboardSummary> getDashboardSummary() async {
    try {
      final DashboardSummary summary =
          await _localDataSource.getDashboardSummary();
      return Right<Failure, DashboardSummary>(summary);
    } on CacheException catch (error) {
      return Left<Failure, DashboardSummary>(
        CacheFailure(debugMessage: error.message),
      );
    } catch (error, stackTrace) {
      _errorReporter.recordError(error, stackTrace);
      return Left<Failure, DashboardSummary>(
        UnexpectedFailure(debugMessage: error.toString()),
      );
    }
  }
}
