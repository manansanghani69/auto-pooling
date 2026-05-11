import 'package:auto_pooling_driver/core/errors/error_reporter.dart';
import 'package:auto_pooling_driver/core/services/app_bloc_observer.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_gate_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling_driver/presentation/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auto_pooling_driver/presentation/auth/data/repositories/auth_repository_impl.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/repositories/auth_repository.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/usecases/request_driver_otp.dart';
import 'package:auto_pooling_driver/presentation/auth/domain/usecases/verify_driver_otp.dart';
import 'package:auto_pooling_driver/presentation/home/bloc/home_bloc.dart';
import 'package:auto_pooling_driver/presentation/home/data/datasources/home_local_data_source.dart';
import 'package:auto_pooling_driver/presentation/home/data/repositories/home_repository_impl.dart';
import 'package:auto_pooling_driver/presentation/home/domain/repositories/home_repository.dart';
import 'package:auto_pooling_driver/presentation/home/domain/usecases/get_dashboard_summary.dart';
import 'package:auto_pooling_driver/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling_driver/presentation/onboarding/data/datasources/driver_onboarding_remote_data_source.dart';
import 'package:auto_pooling_driver/presentation/onboarding/data/repositories/driver_onboarding_repository_impl.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/repositories/driver_onboarding_repository.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/usecases/create_driver_profile.dart';
import 'package:auto_pooling_driver/presentation/onboarding/domain/usecases/get_driver_onboarding_profile.dart';
import 'package:auto_pooling_driver/routes.dart';
import 'package:auto_pooling_driver/services/api_client.dart';
import 'package:auto_pooling_driver/services/auth_session_service.dart';
import 'package:auto_pooling_driver/services/theme_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<AppRouter>()) {
    return;
  }

  sl.registerLazySingleton<AppErrorReporter>(DebugAppErrorReporter.new);
  sl.registerLazySingleton<AppBlocObserver>(
    () => AppBlocObserver(errorReporter: sl()),
  );
  sl.registerLazySingleton<ApiClient>(HttpApiClient.new);
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => preferences);
  sl.registerLazySingleton<AuthSessionService>(
    () => SharedPreferencesAuthSessionService(preferences: sl()),
  );
  sl.registerLazySingleton<ThemeService>(ThemeServiceImpl.new);
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), errorReporter: sl()),
  );
  sl.registerLazySingleton<RequestDriverOtp>(
    () => RequestDriverOtp(repository: sl()),
  );
  sl.registerLazySingleton<VerifyDriverOtp>(
    () => VerifyDriverOtp(repository: sl()),
  );
  sl.registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl.new);
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: sl(), errorReporter: sl()),
  );
  sl.registerLazySingleton<DriverOnboardingRemoteDataSource>(
    () => DriverOnboardingRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<DriverOnboardingRepository>(
    () => DriverOnboardingRepositoryImpl(
      remoteDataSource: sl(),
      authSessionService: sl(),
      errorReporter: sl(),
    ),
  );
  sl.registerLazySingleton<GetDashboardSummary>(
    () => GetDashboardSummary(repository: sl()),
  );
  sl.registerLazySingleton<GetDriverOnboardingProfile>(
    () => GetDriverOnboardingProfile(repository: sl()),
  );
  sl.registerLazySingleton<CreateDriverProfile>(
    () => CreateDriverProfile(repository: sl()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      requestDriverOtp: sl(),
      verifyDriverOtp: sl(),
      authSessionService: sl(),
    ),
  );
  sl.registerFactory<AuthGateBloc>(
    () => AuthGateBloc(authSessionService: sl()),
  );
  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      getDriverOnboardingProfile: sl(),
      createDriverProfile: sl(),
      authSessionService: sl(),
    ),
  );
  sl.registerFactory<HomeBloc>(() => HomeBloc(getDashboardSummary: sl()));
  sl.registerLazySingleton<AppRouter>(AppRouter.new);
}
