import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auto_pooling/common/theme/app_themes_data.dart';
import 'package:auto_pooling/core/usecase/result.dart';
import 'package:auto_pooling/presentation/auth/auth_otp_screen.dart';
import 'package:auto_pooling/presentation/auth/auth_screen.dart';
import 'package:auto_pooling/presentation/auth/bloc/auth_bloc.dart';
import 'package:auto_pooling/presentation/auth/bloc/auth_state.dart';
import 'package:auto_pooling/presentation/auth/domain/entities/auth_entity.dart';
import 'package:auto_pooling/presentation/auth/domain/repositories/auth_repository.dart';
import 'package:auto_pooling/presentation/auth/domain/usecases/auth_usecase.dart';
import 'package:auto_pooling/presentation/auth/widgets/auth_otp_widgets.dart';
import 'package:auto_pooling/presentation/home/home_screen.dart';
import 'package:auto_pooling/presentation/notifications/notifications_screen.dart';
import 'package:auto_pooling/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:auto_pooling/presentation/onboarding/bloc/onboarding_event.dart';
import 'package:auto_pooling/presentation/onboarding/constants/onboarding_constants.dart';
import 'package:auto_pooling/presentation/onboarding/widgets/onboarding_widgets.dart';
import 'package:auto_pooling/presentation/payments/payments_screen.dart';
import 'package:auto_pooling/presentation/profile/profile_screen.dart';
import 'package:auto_pooling/presentation/ride_request/ride_request_screen.dart';
import 'package:auto_pooling/presentation/ride_tracking/ride_tracking_screen.dart';
import 'package:auto_pooling/presentation/splash/splash_screen.dart';

const Size _goldenSize = Size(390, 844);
const String _phoneNumber = '9999012345';
const String _otp = '1234';

final Uint8List _fixtureImageBytes =
    File('web/icons/Icon-192.png').readAsBytesSync();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    HttpOverrides.global = _GoldenHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  group('Splash', () {
    testWidgets('default', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpGolden(
          tester,
          _buildTestApp(
            child: const Scaffold(body: SplashBody()),
          ),
        );

        await _expectGolden(tester, 'goldens/splash_default.png');
      });
    });
  });

  group('Onboarding', () {
    testWidgets('page 1', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpOnboardingPage(
          tester,
          pageIndex: 0,
          goldenPath: 'goldens/onboarding_page_1.png',
        );
      });
    });

    testWidgets('page 2', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpOnboardingPage(
          tester,
          pageIndex: 1,
          goldenPath: 'goldens/onboarding_page_2.png',
        );
      });
    });

    testWidgets('page 3', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpOnboardingPage(
          tester,
          pageIndex: 2,
          goldenPath: 'goldens/onboarding_page_3.png',
        );
      });
    });
  });

  group('Auth phone', () {
    testWidgets('default', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        final TestAuthBloc bloc =
            TestAuthBloc(authUseCase: _buildAuthUseCase());
        addTearDown(bloc.close);

        await _pumpGolden(
          tester,
          _buildTestApp(child: _buildAuthPhoneScaffold(bloc)),
        );

        await _expectGolden(tester, 'goldens/auth_phone_default.png');
      });
    });

    testWidgets('validation error', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        final TestAuthBloc bloc =
            TestAuthBloc(authUseCase: _buildAuthUseCase());
        addTearDown(bloc.close);

        await _pumpGolden(
          tester,
          _buildTestApp(child: _buildAuthPhoneScaffold(bloc)),
        );

        await tester.tap(find.text('Get OTP'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await _expectGolden(tester, 'goldens/auth_phone_validation_error.png');
      });
    });

    testWidgets('requesting otp', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        final TestAuthBloc bloc =
            TestAuthBloc(authUseCase: _buildAuthUseCase());
        bloc.setState(
          AuthState.initial().copyWith(
            status: AuthStatus.requestingOtp,
            lastAction: AuthAction.requestOtp,
            phoneNumber: _phoneNumber,
          ),
        );
        addTearDown(bloc.close);

        await _pumpGolden(
          tester,
          _buildTestApp(child: _buildAuthPhoneScaffold(bloc)),
        );

        await _expectGolden(tester, 'goldens/auth_phone_requesting.png');
      });
    });
  });

  group('Auth otp', () {
    testWidgets('timer running', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        final TestAuthBloc bloc =
            TestAuthBloc(authUseCase: _buildAuthUseCase());
        bloc.setState(
          AuthState.initial().copyWith(
            status: AuthStatus.otpRequested,
            lastAction: AuthAction.requestOtp,
            phoneNumber: _phoneNumber,
            otpSecondsRemaining: 24,
          ),
        );
        addTearDown(bloc.close);

        await _pumpGolden(
          tester,
          _buildTestApp(child: _buildAuthOtpScaffold(bloc)),
        );

        await _expectGolden(tester, 'goldens/auth_otp_timer_running.png');
      });
    });

    testWidgets('timer expired', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        final TestAuthBloc bloc =
            TestAuthBloc(authUseCase: _buildAuthUseCase());
        bloc.setState(
          AuthState.initial().copyWith(
            status: AuthStatus.otpRequested,
            lastAction: AuthAction.requestOtp,
            phoneNumber: _phoneNumber,
            otpSecondsRemaining: 0,
          ),
        );
        addTearDown(bloc.close);

        await _pumpGolden(
          tester,
          _buildTestApp(child: _buildAuthOtpScaffold(bloc)),
        );

        await _expectGolden(tester, 'goldens/auth_otp_timer_expired.png');
      });
    });

    testWidgets('verifying', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        final TestAuthBloc bloc =
            TestAuthBloc(authUseCase: _buildAuthUseCase());
        bloc.setState(
          AuthState.initial().copyWith(
            status: AuthStatus.verifyingOtp,
            lastAction: AuthAction.verifyOtp,
            phoneNumber: _phoneNumber,
            otp: _otp,
            otpSecondsRemaining: 18,
          ),
        );
        addTearDown(bloc.close);

        await _pumpGolden(
          tester,
          _buildTestApp(child: _buildAuthOtpScaffold(bloc)),
        );

        await _expectGolden(tester, 'goldens/auth_otp_verifying.png');
      });
    });

    testWidgets('error', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        final TestAuthBloc bloc =
            TestAuthBloc(authUseCase: _buildAuthUseCase());
        bloc.setState(
          AuthState.initial().copyWith(
            status: AuthStatus.failure,
            lastAction: AuthAction.verifyOtp,
            phoneNumber: _phoneNumber,
            otp: _otp,
            otpSecondsRemaining: 12,
            errorMessage: 'Invalid code',
          ),
        );
        addTearDown(bloc.close);

        await _pumpGolden(
          tester,
          _buildTestApp(child: _buildAuthOtpScaffold(bloc)),
        );

        await _expectGolden(tester, 'goldens/auth_otp_error.png');
      });
    });
  });

  group('Primary screens', () {
    testWidgets('home', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpGolden(
          tester,
          _buildTestApp(child: const HomeScreen()),
        );

        await _expectGolden(tester, 'goldens/home_default.png');
      });
    });

    testWidgets('ride request', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpGolden(
          tester,
          _buildTestApp(child: const RideRequestScreen()),
        );

        await _expectGolden(tester, 'goldens/ride_request_default.png');
      });
    });

    testWidgets('ride tracking', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpGolden(
          tester,
          _buildTestApp(child: const RideTrackingScreen()),
        );

        await _expectGolden(tester, 'goldens/ride_tracking_default.png');
      });
    });

    testWidgets('payments', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpGolden(
          tester,
          _buildTestApp(child: const PaymentsScreen()),
        );

        await _expectGolden(tester, 'goldens/payments_default.png');
      });
    });

    testWidgets('profile', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpGolden(
          tester,
          _buildTestApp(child: const ProfileScreen()),
        );

        await _expectGolden(tester, 'goldens/profile_default.png');
      });
    });

    testWidgets('notifications', (WidgetTester tester) async {
      await _runGoldenTest(tester, () async {
        await _pumpGolden(
          tester,
          _buildTestApp(child: const NotificationsScreen()),
        );

        await _expectGolden(tester, 'goldens/notifications_default.png');
      });
    });
  });
}

Future<void> _runGoldenTest(
  WidgetTester tester,
  Future<void> Function() body,
) async {
  await body();
}

Future<void> _pumpGolden(WidgetTester tester, Widget app) async {
  await tester.binding.setSurfaceSize(_goldenSize);
  tester.binding.window.devicePixelRatioTestValue = 1.0;
  addTearDown(() {
    tester.binding.window.clearDevicePixelRatioTestValue();
    tester.binding.setSurfaceSize(null);
  });

  await tester.pumpWidget(app);
  await tester.pump();
}

Future<void> _expectGolden(WidgetTester tester, String path) async {
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('../$path'));
}

Future<void> _pumpOnboardingPage(
  WidgetTester tester, {
  required int pageIndex,
  required String goldenPath,
}) async {
  final PageController controller = PageController(initialPage: pageIndex);
  final OnboardingBloc bloc = OnboardingBloc();
  addTearDown(() {
    controller.dispose();
    bloc.close();
  });

  await _pumpGolden(
    tester,
    _buildTestApp(
      child: BlocProvider<OnboardingBloc>.value(
        value: bloc,
        child: Scaffold(
          body: OnboardingBody(
            pageController: controller,
            onContinue: () {},
            onSkip: () {},
          ),
        ),
      ),
    ),
  );

  if (pageIndex != 0) {
    bloc.add(OnboardingPageChangedEvent(index: pageIndex));
    await tester.pump();
    await tester.pump(OnboardingConstants.indicatorAnimationDuration);
  }

  await _expectGolden(tester, goldenPath);
}

Widget _buildTestApp({required Widget child}) {
  return MaterialApp(
    theme: AppThemesData.lightTheme,
    home: child,
  );
}

Widget _buildAuthPhoneScaffold(AuthBloc bloc) {
  return BlocProvider<AuthBloc>.value(
    value: bloc,
    child: const Scaffold(
      body: AuthPhoneBody(),
    ),
  );
}

Widget _buildAuthOtpScaffold(AuthBloc bloc) {
  return BlocProvider<AuthBloc>.value(
    value: bloc,
    child: const Scaffold(
      body: AuthOtpBody(),
      bottomNavigationBar: AuthOtpVerifyButton(),
    ),
  );
}

AuthUseCase _buildAuthUseCase() {
  return AuthUseCase(repository: _StubAuthRepository());
}

class TestAuthBloc extends AuthBloc {
  TestAuthBloc({required super.authUseCase});

  void setState(AuthState state) {
    emit(state);
  }
}

class _StubAuthRepository implements AuthRepository {
  @override
  ResultFuture<OtpRequestEntity> requestOtp({required String phoneNumber}) {
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
    return Future.value(
      Result.success(
        VerifyOtpEntity(
          user: AuthUserEntity(
            id: 'user-id',
            phone: phoneNumber,
            name: 'Test User',
            role: role,
            createdAt: DateTime.utc(2024, 1, 1),
          ),
          tokens: const AuthTokensEntity(
            accessToken: 'access-token',
            refreshToken: 'refresh-token',
            expiresIn: '3600',
          ),
          isNewUser: false,
        ),
      ),
    );
  }

  @override
  ResultFuture<LogoutEntity> logout() {
    return Future.value(const Result.success(LogoutEntity(ok: true)));
  }
}

class _GoldenHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _GoldenHttpClient();
  }
}

class _GoldenHttpClient implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _GoldenHttpRequest();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class _GoldenHttpRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _GoldenHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _GoldenHttpResponse();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class _GoldenHttpResponse extends Stream<List<int>> implements HttpClientResponse {
  final Stream<List<int>> _stream = Stream<List<int>>.fromIterable(
    <List<int>>[_fixtureImageBytes],
  );

  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _fixtureImageBytes.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.decompressed;

  @override
  HttpHeaders get headers => _GoldenHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class _GoldenHttpHeaders implements HttpHeaders {
  @override
  void add(
    String name,
    Object value, {
    bool preserveHeaderCase = false,
  }) {}

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
