import 'package:auto_pooling_driver/presentation/auth/domain/entities/driver_session.dart';

abstract class AuthSessionService {
  DriverSession? get currentSession;

  void saveSession(DriverSession session);

  void clearSession();
}

class InMemoryAuthSessionService implements AuthSessionService {
  DriverSession? _currentSession;

  @override
  DriverSession? get currentSession => _currentSession;

  @override
  void clearSession() {
    _currentSession = null;
  }

  @override
  void saveSession(DriverSession session) {
    _currentSession = session;
  }
}
