import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/presentation/home/domain/entities/dashboard_summary.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, loaded, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.summary,
    this.failure,
  });

  final HomeStatus status;
  final DashboardSummary? summary;
  final Failure? failure;

  HomeState copyWith({
    HomeStatus? status,
    DashboardSummary? summary,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, summary, failure];
}
