import 'package:flutter_test/flutter_test.dart';

import 'package:auto_pooling/core/errors/api_failure.dart';
import 'package:auto_pooling/core/usecase/result.dart';
import 'package:auto_pooling/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling/presentation/auth/bloc/auth_event.dart';
import 'package:auto_pooling/presentation/auth/bloc/auth_state.dart';
import 'package:auto_pooling/presentation/auth/domain/entities/auth_entity.dart';
import 'package:auto_pooling/presentation/auth/domain/repositories/auth_repository.dart';
import 'package:auto_pooling/presentation/auth/domain/usecases/auth_usecase.dart';

typedef RequestOtpHandler = ResultFuture<OtpRequestEntity> Function(
  String phoneNumber,
);
typedef VerifyOtpHandler = ResultFuture<VerifyOtpEntity> Function(
  String phoneNumber,
  String otp,
  String role,
);
typedef LogoutHandler = ResultFuture<LogoutEntity> Function();

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    RequestOtpHandler? onRequestOtp,
    VerifyOtpHandler? onVerifyOtp,
    LogoutHandler? onLogout,
  })  : _onRequestOtp = onRequestOtp,
        _onVerifyOtp = onVerifyOtp,
        _onLogout = onLogout;

  final RequestOtpHandler? _onRequestOtp;
  final VerifyOtpHandler? _onVerifyOtp;
  final LogoutHandler? _onLogout;

  int requestOtpCallCount = 0;
  int verifyOtpCallCount = 0;
  int logoutCallCount = 0;

  String? lastRequestPhoneNumber;
  String? lastVerifyPhoneNumber;
  String? lastVerifyOtp;
  String? lastVerifyRole;

  @override
  ResultFuture<OtpRequestEntity> requestOtp({required String phoneNumber}) {
    requestOtpCallCount += 1;
    lastRequestPhoneNumber = phoneNumber;
    final handler = _onRequestOtp;
    if (handler != null) {
      return handler(phoneNumber);
    }
    return Future.value(
      const Result.success(OtpRequestEntity(ok: true, expiresIn: 30)),
    );
  }

  @override
  ResultFuture<VerifyOtpEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String role,
  }) {
    verifyOtpCallCount += 1;
    lastVerifyPhoneNumber = phoneNumber;
    lastVerifyOtp = otp;
    lastVerifyRole = role;
    final handler = _onVerifyOtp;
    if (handler != null) {
      return handler(phoneNumber, otp, role);
    }
    return Future.value(Result.success(_defaultVerifyOtpEntity()));
  }

  @override
  ResultFuture<LogoutEntity> logout() {
    logoutCallCount += 1;
    final handler = _onLogout;
    if (handler != null) {
      return handler();
    }
    return Future.value(const Result.success(LogoutEntity(ok: true)));
  }
}

AuthBloc _buildBloc(FakeAuthRepository repository) {
  return AuthBloc(authUseCase: AuthUseCase(repository: repository));
}

Future<void> _setPhoneNumber(AuthBloc bloc, String phoneNumber) async {
  final expectation = expectLater(
    bloc.stream,
    emits(
      isA<AuthState>().having(
        (state) => state.phoneNumber,
        'phoneNumber',
        phoneNumber,
      ),
    ),
  );
  bloc.add(AuthPhoneNumberChangedEvent(phoneNumber: phoneNumber));
  await expectation;
}

Future<void> _setOtp(AuthBloc bloc, String otp) async {
  final expectation = expectLater(
    bloc.stream,
    emits(
      isA<AuthState>().having(
        (state) => state.otp,
        'otp',
        otp,
      ),
    ),
  );
  bloc.add(AuthOtpChangedEvent(otp: otp));
  await expectation;
}

VerifyOtpEntity _defaultVerifyOtpEntity() {
  return VerifyOtpEntity(
    user: AuthUserEntity(
      id: 'user-1',
      phone: '+1234567890',
      name: 'Test User',
      role: 'rider',
      createdAt: DateTime.utc(2024, 1, 1),
    ),
    tokens: const AuthTokensEntity(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      expiresIn: '3600',
    ),
    isNewUser: false,
  );
}

void main() {
  const String phoneNumber = '9999999999';
  const String otp = '1234';
  const String shortOtp = '123';
  const String errorMessage = 'Something went wrong';

  test('initial state has empty values', () {
    final bloc = _buildBloc(FakeAuthRepository());
    addTearDown(bloc.close);

    expect(bloc.state.status, AuthStatus.initial);
    expect(bloc.state.lastAction, AuthAction.none);
    expect(bloc.state.phoneNumber, '');
    expect(bloc.state.otp, '');
    expect(bloc.state.otpSecondsRemaining, 0);
    expect(bloc.state.errorMessage, '');
  });

  test('AuthPhoneNumberChangedEvent updates phone number and clears otp', () async {
    final bloc = _buildBloc(FakeAuthRepository());
    addTearDown(bloc.close);

    await _setOtp(bloc, otp);

    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<AuthState>()
            .having((state) => state.phoneNumber, 'phoneNumber', phoneNumber)
            .having((state) => state.otp, 'otp', '')
            .having((state) => state.errorMessage, 'errorMessage', ''),
      ),
    );

    bloc.add(const AuthPhoneNumberChangedEvent(phoneNumber: phoneNumber));
    await expectation;
  });

  test('AuthOtpChangedEvent updates otp and clears error message', () async {
    final bloc = _buildBloc(FakeAuthRepository());
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<AuthState>()
            .having((state) => state.otp, 'otp', otp)
            .having((state) => state.errorMessage, 'errorMessage', ''),
      ),
    );

    bloc.add(const AuthOtpChangedEvent(otp: otp));
    await expectation;
  });

  test('AuthRequestOtpEvent ignores empty phone number', () async {
    final repository = FakeAuthRepository();
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    bloc.add(const AuthRequestOtpEvent());
    await Future<void>.delayed(Duration.zero);

    expect(repository.requestOtpCallCount, 0);
    expect(bloc.state.status, AuthStatus.initial);
  });

  test('AuthRequestOtpEvent emits request flow and starts timer on success',
      () async {
    final repository = FakeAuthRepository();
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    await _setPhoneNumber(bloc, phoneNumber);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.requestingOtp)
              .having(
                (state) => state.lastAction,
                'lastAction',
                AuthAction.requestOtp,
              )
              .having((state) => state.errorMessage, 'errorMessage', ''),
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.otpRequested)
              .having(
                (state) => state.lastAction,
                'lastAction',
                AuthAction.requestOtp,
              ),
          isA<AuthState>().having(
            (state) => state.otpSecondsRemaining,
            'otpSecondsRemaining',
            30,
          ),
        ],
      ),
    );

    bloc.add(const AuthRequestOtpEvent());
    await expectation;

    expect(repository.requestOtpCallCount, 1);
    expect(repository.lastRequestPhoneNumber, phoneNumber);
  });

  test('AuthRequestOtpEvent emits failure when request fails', () async {
    final repository = FakeAuthRepository(
      onRequestOtp: (_) => Future.value(
        const Result.failure(
          APIFailure(errorMessage: errorMessage, statusCode: 400),
        ),
      ),
    );
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    await _setPhoneNumber(bloc, phoneNumber);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.requestingOtp)
              .having(
                (state) => state.lastAction,
                'lastAction',
                AuthAction.requestOtp,
              ),
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.failure)
              .having(
                (state) => state.lastAction,
                'lastAction',
                AuthAction.requestOtp,
              )
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                errorMessage,
              ),
        ],
      ),
    );

    bloc.add(const AuthRequestOtpEvent());
    await expectation;

    expect(repository.requestOtpCallCount, 1);
  });

  test('AuthVerifyOtpEvent ignores otp with invalid length', () async {
    final repository = FakeAuthRepository();
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    await _setPhoneNumber(bloc, phoneNumber);
    await _setOtp(bloc, shortOtp);

    bloc.add(const AuthVerifyOtpEvent());
    await Future<void>.delayed(Duration.zero);

    expect(repository.verifyOtpCallCount, 0);
    expect(bloc.state.status, AuthStatus.initial);
  });

  test('AuthVerifyOtpEvent emits verify flow on success', () async {
    final repository = FakeAuthRepository(
      onVerifyOtp: (_, __, ___) => Future.value(
        Result.success(_defaultVerifyOtpEntity()),
      ),
    );
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    await _setPhoneNumber(bloc, phoneNumber);
    await _setOtp(bloc, otp);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.verifyingOtp)
              .having(
                (state) => state.lastAction,
                'lastAction',
                AuthAction.verifyOtp,
              ),
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.otpVerified)
              .having(
                (state) => state.lastAction,
                'lastAction',
                AuthAction.verifyOtp,
              ),
        ],
      ),
    );

    bloc.add(const AuthVerifyOtpEvent());
    await expectation;

    expect(repository.verifyOtpCallCount, 1);
    expect(repository.lastVerifyPhoneNumber, phoneNumber);
    expect(repository.lastVerifyOtp, otp);
    expect(repository.lastVerifyRole, 'rider');
  });

  test('AuthVerifyOtpEvent emits failure on error', () async {
    final repository = FakeAuthRepository(
      onVerifyOtp: (_, __, ___) => Future.value(
        const Result.failure(
          APIFailure(errorMessage: errorMessage, statusCode: 401),
        ),
      ),
    );
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    await _setPhoneNumber(bloc, phoneNumber);
    await _setOtp(bloc, otp);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.verifyingOtp)
              .having(
                (state) => state.lastAction,
                'lastAction',
                AuthAction.verifyOtp,
              ),
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.failure)
              .having(
                (state) => state.lastAction,
                'lastAction',
                AuthAction.verifyOtp,
              )
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                errorMessage,
              ),
        ],
      ),
    );

    bloc.add(const AuthVerifyOtpEvent());
    await expectation;

    expect(repository.verifyOtpCallCount, 1);
  });

  test('AuthLogoutRequestedEvent emits logout success', () async {
    final repository = FakeAuthRepository(
      onLogout: () => Future.value(const Result.success(LogoutEntity(ok: true))),
    );
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.loggingOut)
              .having((state) => state.lastAction, 'lastAction', AuthAction.logout),
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.logoutSuccess)
              .having((state) => state.lastAction, 'lastAction', AuthAction.logout),
        ],
      ),
    );

    bloc.add(const AuthLogoutRequestedEvent());
    await expectation;

    expect(repository.logoutCallCount, 1);
  });

  test('AuthLogoutRequestedEvent emits failure on error', () async {
    final repository = FakeAuthRepository(
      onLogout: () => Future.value(
        const Result.failure(
          APIFailure(errorMessage: errorMessage, statusCode: 500),
        ),
      ),
    );
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.loggingOut)
              .having((state) => state.lastAction, 'lastAction', AuthAction.logout),
          isA<AuthState>()
              .having((state) => state.status, 'status', AuthStatus.failure)
              .having((state) => state.lastAction, 'lastAction', AuthAction.logout)
              .having(
                (state) => state.errorMessage,
                'errorMessage',
                errorMessage,
              ),
        ],
      ),
    );

    bloc.add(const AuthLogoutRequestedEvent());
    await expectation;

    expect(repository.logoutCallCount, 1);
  });

  test('AuthOtpTimerTickedEvent updates otpSecondsRemaining', () async {
    final bloc = _buildBloc(FakeAuthRepository());
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<AuthState>().having(
          (state) => state.otpSecondsRemaining,
          'otpSecondsRemaining',
          12,
        ),
      ),
    );

    bloc.add(const AuthOtpTimerTickedEvent(secondsRemaining: 12));
    await expectation;
  });
}
