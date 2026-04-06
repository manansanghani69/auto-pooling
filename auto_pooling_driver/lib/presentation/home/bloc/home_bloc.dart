import 'package:auto_pooling_driver/core/errors/failures.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_event.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_state.dart';
import 'package:auto_pooling_driver/presentation/home/domain/entities/dashboard_summary.dart';
import 'package:auto_pooling_driver/presentation/home/domain/usecases/get_dashboard_summary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetDashboardSummary getDashboardSummary})
      : _getDashboardSummary = getDashboardSummary,
        super(const HomeState()) {
    _setupEventListener();
  }

  final GetDashboardSummary _getDashboardSummary;

  void _setupEventListener() {
    on<HomeStartedEvent>(_onHomeStartedEvent);
    on<HomeRetryRequestedEvent>(_onHomeRetryRequestedEvent);
  }

  Future<void> _onHomeStartedEvent(
    HomeStartedEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _loadDashboardSummary(emit);
  }

  Future<void> _onHomeRetryRequestedEvent(
    HomeRetryRequestedEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _loadDashboardSummary(emit);
  }

  Future<void> _loadDashboardSummary(Emitter<HomeState> emit) async {
    if (state.status == HomeStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        status: HomeStatus.loading,
        clearFailure: true,
      ),
    );

    final result = await _getDashboardSummary();
    result.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            failure: failure,
          ),
        );
      },
      (DashboardSummary summary) {
        emit(
          state.copyWith(
            status: HomeStatus.loaded,
            summary: summary,
            clearFailure: true,
          ),
        );
      },
    );
  }
}
