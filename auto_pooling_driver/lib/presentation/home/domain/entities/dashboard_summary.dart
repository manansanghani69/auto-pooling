import 'package:equatable/equatable.dart';

class DashboardSummary extends Equatable {
  const DashboardSummary({
    required this.activeTrips,
    required this.completedTrips,
    required this.todayEarnings,
  });

  final int activeTrips;
  final int completedTrips;
  final int todayEarnings;

  @override
  List<Object> get props => <Object>[
    activeTrips,
    completedTrips,
    todayEarnings,
  ];
}
