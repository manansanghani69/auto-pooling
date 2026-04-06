import 'package:auto_pooling_driver/core/usecase/typedefs.dart';
import 'package:auto_pooling_driver/presentation/home/domain/entities/dashboard_summary.dart';

abstract class HomeRepository {
  ResultFuture<DashboardSummary> getDashboardSummary();
}
