import 'package:auto_pooling_driver/presentation/home/domain/entities/dashboard_summary.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.activeTrips,
    required super.completedTrips,
    required super.todayEarnings,
  });
}
