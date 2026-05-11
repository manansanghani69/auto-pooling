import 'dart:convert';

import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthSessionService {
  DriverSession? get currentSession;

  Future<void> saveSession(DriverSession session);

  Future<void> clearSession();
}

class SharedPreferencesAuthSessionService implements AuthSessionService {
  SharedPreferencesAuthSessionService({required SharedPreferences preferences})
    : _preferences = preferences {
    _currentSession = _readSession();
  }

  static const String _sessionKey = 'driver_session';

  final SharedPreferences _preferences;
  late DriverSession? _currentSession;

  @override
  DriverSession? get currentSession => _currentSession;

  @override
  Future<void> clearSession() async {
    _currentSession = null;
    await _preferences.remove(_sessionKey);
  }

  @override
  Future<void> saveSession(DriverSession session) async {
    _currentSession = session;
    await _preferences.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  DriverSession? _readSession() {
    final String? rawSession = _preferences.getString(_sessionKey);
    if (rawSession == null || rawSession.trim().isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(rawSession);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return DriverSession.fromJson(decoded);
    } catch (_) {
      _preferences.remove(_sessionKey);
      return null;
    }
  }
}
