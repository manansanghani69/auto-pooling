import 'package:auto_pooling_driver/core/errors/error_reporter.dart';
import 'package:auto_pooling_driver/core/services/app_bloc_observer.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_bloc.dart';
import 'package:auto_pooling_driver/presentation/home/data/datasources/home_local_data_source.dart';
import 'package:auto_pooling_driver/presentation/home/data/repositories/home_repository_impl.dart';
import 'package:auto_pooling_driver/presentation/home/domain/repositories/home_repository.dart';
import 'package:auto_pooling_driver/presentation/home/domain/usecases/get_dashboard_summary.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_pooling_driver/services/theme_service.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<AppRouter>()) {
    return;
  }

  sl.registerLazySingleton<AppErrorReporter>(DebugAppErrorReporter.new);
  sl.registerLazySingleton<AppBlocObserver>(
    () => AppBlocObserver(errorReporter: sl()),
  );
  sl.registerLazySingleton<ThemeService>(ThemeServiceImpl.new);
  sl.registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl.new);
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      localDataSource: sl(),
      errorReporter: sl(),
    ),
  );
  sl.registerLazySingleton<GetDashboardSummary>(
    () => GetDashboardSummary(repository: sl()),
  );
  sl.registerFactory<HomeBloc>(() => HomeBloc(getDashboardSummary: sl()));
  sl.registerLazySingleton<AppRouter>(AppRouter.new);
}
