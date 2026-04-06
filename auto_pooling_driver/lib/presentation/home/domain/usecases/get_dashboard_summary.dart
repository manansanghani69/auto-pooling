import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/home/domain/entities/dashboard_summary.dart';
import 'package:auto_pooling_driver/presentation/home/domain/repositories/home_repository.dart';

class GetDashboardSummary {
  const GetDashboardSummary({required HomeRepository repository})
      : _repository = repository;

  final HomeRepository _repository;

  ResultFuture<DashboardSummary> call() {
    return _repository.getDashboardSummary();
  }
}
