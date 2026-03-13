import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/auth/data/datasources/auth_remote_data_source.dart';
import '../../presentation/auth/data/repositories/auth_repository_impl.dart';
import '../../presentation/auth/domain/repositories/auth_repository.dart';
import '../../presentation/auth/domain/usecases/auth_usecase.dart';
import '../../presentation/profile/data/datasources/profile_remote_data_source.dart';
import '../../presentation/profile/data/repositories/profile_repository_impl.dart';
import '../../presentation/profile/domain/repositories/profile_repository.dart';
import '../../presentation/profile/domain/usecases/profile_usecase.dart';
import '../../shared_pref/pref_keys.dart';
import '../../shared_pref/prefs.dart';
import '../../utils/app_flavor_env.dart';
import 'api_client.dart';

final sl = GetIt.instance;

Future<void> configureDependencies({
  SharedPreferences? sharedPreferences,
}) async {
  await _configureSharedPreferences(sharedPreferences);
  _configureNetwork();
  _configureAuth();
  _configureProfile();
}

Future<void> _configureSharedPreferences(
  SharedPreferences? sharedPreferences,
) async {
  final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
  if (sl.isRegistered<SharedPreferences>()) {
    sl.unregister<SharedPreferences>();
  }
  sl.registerSingleton<SharedPreferences>(prefs);
}

void _configureNetwork() {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      accessTokenProvider: () => Prefs.getString(PrefKeys.authToken),
    ),
  );
  dio.interceptors.add(
    ApiLoggerInterceptor(
      logPrint: (message) => log(message),
    ),
  );

  if (sl.isRegistered<Dio>()) {
    sl.unregister<Dio>();
  }
  sl.registerSingleton<Dio>(dio);

  if (sl.isRegistered<ApiClient>()) {
    sl.unregister<ApiClient>();
  }
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
}

void _configureAuth() {
  if (sl.isRegistered<AuthRemoteDataSource>()) {
    sl.unregister<AuthRemoteDataSource>();
  }
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  if (sl.isRegistered<AuthRepository>()) {
    sl.unregister<AuthRepository>();
  }
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  if (sl.isRegistered<AuthUseCase>()) {
    sl.unregister<AuthUseCase>();
  }
  sl.registerLazySingleton<AuthUseCase>(
    () => AuthUseCase(repository: sl()),
  );
}

void _configureProfile() {
  if (sl.isRegistered<ProfileRemoteDataSource>()) {
    sl.unregister<ProfileRemoteDataSource>();
  }
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );

  if (sl.isRegistered<ProfileRepository>()) {
    sl.unregister<ProfileRepository>();
  }
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  if (sl.isRegistered<ProfileUseCase>()) {
    sl.unregister<ProfileUseCase>();
  }
  sl.registerLazySingleton<ProfileUseCase>(
    () => ProfileUseCase(repository: sl()),
  );
}
