import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/injection_container.dart';

class Prefs {
  static SharedPreferences get _prefs => sl<SharedPreferences>();

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}
