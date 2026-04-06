import 'package:auto_pooling_driver/presentation/home/data/models/dashboard_summary_model.dart';

abstract class HomeLocalDataSource {
  Future<DashboardSummaryModel> getDashboardSummary();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const DashboardSummaryModel(
      activeTrips: 4,
      completedTrips: 18,
      todayEarnings: 1860,
    );
  }
}
