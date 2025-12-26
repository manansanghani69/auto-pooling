import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> configureDependencies({
  SharedPreferences? sharedPreferences,
}) async {
  await _configureSharedPreferences(sharedPreferences);
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
