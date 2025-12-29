# AGENTS.md

This file defines how agents must operate in this repo. Follow it strictly.

## Non-negotiable agent rules
- Scope control: do only what the user explicitly asked for. No refactors, formatting changes, dependency updates, or extra files unless requested.
- Non-API completion: when APIs are not provided, implement all app-side functionality that does not depend on them.
- Plan first: propose a short plan and review it with the user before implementing. If the plan must change, stop and re-confirm.
- Ask questions: if requirements are missing, unclear, or a big decision is needed, ask before coding.
- Say no when required: if the request is impossible, unsafe, or conflicts with these rules, state that clearly and ask for direction.
- Prefer permanent fixes: solve root causes, not symptoms. Avoid quick patches or bandaids.
- Keep logic readable: prefer simple control flow, small methods, and clear naming. Do not overcomplicate logic.
- Never use setState

## Project structure (strict)
Do not invent new layout conventions. Follow the existing structure:
- `lib/presentation/` feature modules (UI + BLoC + data/domain when needed).
- `lib/core/` cross-cutting concerns (errors, DI, deep links, analytics, usecase base).
- `lib/services/` app-level services (auth, notifications, remote config, theme, subscriptions).
- `lib/shared_pref/` shared preferences wrapper and keys.
- `lib/utils/` utilities (env, cache manager, helpers).
- `lib/widgets/` reusable UI widgets.
- `lib/common/` shared theme/text styles.
- `lib/constants/` app-wide constants.
- `lib/routes.dart` routing config; `lib/routes.gr.dart` is generated.
- `lib/gen/` generated assets/fonts; do not edit by hand.

Generated files to avoid editing directly:
- `lib/routes.gr.dart`
- `lib/gen/assets.gen.dart`
- `lib/gen/fonts.gen.dart`

### Feature module layout (example: Home)
`lib/presentation/home/` shows the expected feature shape:
- `bloc/` for events, states, and BLoC logic
- `data/` for datasources, models, repositories
- `domain/` for entities, repository interfaces, usecases
- `widgets/` for feature-specific widgets
- `constants/` for feature constants
- `home_screen.dart` as the entry screen

Mirror this layout for new features unless told otherwise.

## UI composition and widget structure (multi-screen login flow reference)
How UI should be written in this project:
- Build each screen as a small `@RoutePage()` widget and a separate body widget.
- Decompose screens into small widgets under `feature/widgets/` folders; **every visible UI fragment (even tiny pieces) must live in its own `StatelessWidget` with a `const` constructor**. Inline widget trees or anonymous builders are not allowed beyond the top-level scaffold/body glue.
- Treat this decomposition rule as absolute—any code that does not follow it must be rewritten before merging. No exceptions.
- Use `StatelessWidget` by default and `const` constructors where possible.
- Use `StatefulWidget` only when local state is needed (controllers, focus nodes).
- Prefer `const` layout widgets (`SizedBox`, `Padding`) and `static const` for repeated values.
- Use `SafeArea` and `SingleChildScrollView` for form screens.
- Use `context.localization`, `AppTextStyles`, and theme extension colors for text and UI styling.
Reference: the multi-screen login flow in `lib/presentation/login/screens/` and `lib/presentation/signup/screens/`.

Example (screen composition from `lib/presentation/login/screens/login_with_phone_number/login_with_phone_number_screen.dart`):
```dart
@RoutePage()
class LoginWithPhoneNumberScreen extends StatefulWidget {
  static const kHorizontalPadding = 16.0;

  @override
  State<LoginWithPhoneNumberScreen> createState() =>
      _LoginWithPhoneNumberScreenState();
}

class LoginWithPhoneNumberBody extends StatelessWidget {
  const LoginWithPhoneNumberBody({required this.isFromDeleteAccount, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: LoginWithPhoneNumberScreen.kHorizontalPadding,
        ),
        child: const Column(
          children: [
            SizedBox(height: 10),
            HeadingWelcomeWidget(),
            SizedBox(height: 30),
            PhoneNumberTextField(),
            SizedBox(height: 30),
            SendOTPButton(),
            SizedBox(height: 20),
            LoginOptionsDivider(),
            SizedBox(height: 20),
            MoreLoginOptionsButton(),
          ],
        ),
      ),
    );
  }
}
```

Example (use `StatefulWidget` only for local UI state, from `lib/presentation/login/screens/login_with_phone_number/widgets/phone_number_text_field.dart`):
```dart
class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({super.key});

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  late TextEditingController _phoneInputController;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _phoneInputController.dispose();
    _debouncer.cancel();
    super.dispose();
  }
}
```

Example (styling and localization from the same widget):
```dart
Text(
  context.localization.mobile_number,
  style: AppTextStyles.p3Medium.copyWith(
    color: context.currentTheme.textNeutralPrimary,
  ),
),
```

Example (side effects with `BlocListener`, from
`lib/presentation/login/screens/login_with_phone_number/login_with_phone_number_screen.dart`):
```dart
child: BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    if (state is NavigateToOTPScreenState &&
        state.phoneOTPVerificationId.isNotEmpty) {
      context.pushRoute(
        PhoneNumberOTPRoute(
          loginBloc: context.read<LoginBloc>(),
          isFromDeleteAccount: isFromDeleteAccount,
        ),
      );
    }
  },
  child: const Column(
    children: [
      SizedBox(height: 10),
      HeadingWelcomeWidget(),
      SizedBox(height: 30),
      PhoneNumberTextField(),
      SizedBox(height: 30),
      SendOTPButton(),
    ],
  ),
),
```

## State management (BLoC)
Use BLoC with events/states under each feature. Prefer `context.select` over passing state through widget constructors.
How BLoC code should be written:
- Register event handlers in a `_setupEventListener()` method and keep one handler per event.
- Keep handlers short, readable, and optimized for clarity (avoid deep nesting).
- Emit state changes using `copyWith` where possible; prefer early returns.
- Use `ResultFuture` + `fold` to handle success/failure paths.

Example (from `lib/presentation/home/home_screen.dart`):
```dart
return BlocProvider<HomeBloc>(
  create: (_) => HomeBloc(getProducts: sl())..add(const GetTopProductDataEvent()),
  child: const HomeScreenWrapper(),
);
```

Example (from `lib/presentation/home/bloc/home_bloc.dart`):
```dart
on<GetTopProductDataEvent>(_onGetTopProductDataEvent);

final result = await _getProducts();
result.fold(
  (failure) =>
      emit(AuthenticationError(state, errorMessage: failure.errorMessage)),
  (topProducts) =>
      emit(TopProductsLoadedState(state, topProducts: topProducts)),
);
```

Example (from `lib/presentation/home/home_screen.dart`):
```dart
final int currentIndex = context.select<HomeBloc, int>(
  (bloc) => bloc.state.currentBottomNavIndex,
);
```

## Dependency injection (GetIt)
All dependencies are registered in `lib/core/services/injection_container.dart`. Only add registrations when requested.
How to use DI in code:
- Call `configureDependencies(...)` in `lib/initialize_app.dart` before `runApp`.
- Resolve dependencies with `sl<T>()` inside BLoCs, services, or widgets.

Example:
```dart
final sl = GetIt.instance;

Future<void> configureDependencies({ ... }) async {
  sl.registerLazySingleton<FirebaseAuth>(
    () => firebaseAuth ?? FirebaseAuth.instance,
  );

  final cacheManager = CacheManager();
  await cacheManager.initialize();
  sl.registerSingleton<CacheManager>(cacheManager);

  final pinnedDio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
  _registerDioInterceptor(pinnedDio);
  sl<CacheManager>().attachCacheInterceptor(pinnedDio);

  sl
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl()),
    )
    ..registerLazySingleton<Dio>(() => pinnedDio);
}
```

Resolve dependencies with `sl<T>()` (see `lib/presentation/home/home_screen.dart` and `lib/presentation/login/bloc/login_bloc.dart`).

Example usage (from `lib/presentation/login/bloc/login_bloc.dart`):
```dart
final FirebaseAuthService _firebaseAuthService = sl();
```

Example usage (from `lib/initialize_app.dart`):
```dart
await configureDependencies(
  firebaseAuth: firebaseAuth,
  firebaseAuthService: firebaseAuthService,
  dio: dio,
);
```

## Networking and error handling
`Dio` is configured in DI with SSL pinning and auth interceptors in `lib/core/services/injection_container.dart`.
Use `APIException` and `APIFailure` with `ResultFuture` for repository results.
How to use it:
- Remote datasources perform the HTTP call and throw `APIException` on non-200 responses.
- Repositories catch `APIException` and map to `APIFailure`.
- BLoCs use the usecase/repository result and `fold` to emit states.

Example (from `lib/presentation/home/data/repositories/product_repository_impl.dart`):
```dart
try {
  final List<ProductModel> result = await _remoteDatasource.getProducts();
  return Right(result);
} on APIException catch (e) {
  return Left(APIFailure.fromException(e));
}
```

Example (remote datasource from `lib/presentation/home/data/datasources/product_remote_data_source.dart`):
```dart
final response = await _dio.get(
  kGetProductEndpoint,
  options: sl<CacheManager>().defaultCacheOptions.toOptions(),
);

if (response.statusCode != 200) {
  throw APIException(
    message: response.data,
    statusCode: response.statusCode ?? 500,
  );
}
```

## Model serialization (required)
- All models in `lib/**/data/models/` must use `json_serializable`.
- Include `@JsonSerializable`, `fromJson`/`toJson`, and `part '*.g.dart'`; do not hand-roll JSON parsing in models.

## API caching (optional)
Caching is opt-in. Only use it when asked.
`CacheManager` lives in `lib/utils/cache_manager.dart` and is attached to `Dio`.
How to use it:
- Add cache options to specific API calls when caching is required.
- Use `noCacheOptions()` or `customCacheOptions(...)` to override defaults.

Example (from `lib/presentation/home/data/datasources/product_remote_data_source.dart`):
```dart
final response = await _dio.get(
  kGetProductEndpoint,
  options: sl<CacheManager>().defaultCacheOptions.toOptions(),
);
```

Use `sl<CacheManager>().noCacheOptions()` or `customCacheOptions(...)` if you need to override caching behavior.

## Routing (AutoRoute)
Routes are defined in `lib/routes.dart` and generated into `lib/routes.gr.dart`. Do not edit generated routes directly.
How to use it:
- Annotate screens with `@RoutePage()`.
- Add the route to the list in `lib/routes.dart`.
- Navigate using `context.pushRoute(...)` or `context.router.push(...)`.

Example (from `lib/routes.dart`):
```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => _getRoutes();
}
```

Screens must be annotated with `@RoutePage()`.

Example (from `lib/presentation/home/home_screen.dart`):
```dart
@RoutePage()
class HomeScreen extends StatelessWidget { ... }
```

Navigation examples:
- `context.pushRoute(const WishlistRoute());` (see `lib/presentation/empty_screens/empty_view_screens.dart`)
- `context.router.push(const EditAddressRoute());` (see `lib/presentation/checkout/widget/shipping_address.dart`)

Use `rootNavigatorKey` from `lib/main.dart` for navigation outside widget context.

## Authentication (common)
Authentication is handled by `FirebaseAuthService` in `lib/services/firebase_auth_services.dart`.
It is registered in DI and used in BLoCs (e.g., `lib/presentation/login/bloc/login_bloc.dart`).
How to use it:
- Call auth methods inside BLoC handlers and emit states based on success or error.
- Use the `onError` callback to map errors into BLoC events or UI messages.

Example (from `lib/presentation/login/bloc/login_bloc.dart`):
```dart
final userCredential =
    await _firebaseAuthService.signInWithEmailAndPassword(
  email,
  password,
  onError: (error, {stackTrace}) {
    add(AuthenticationExceptionEvent(errorMessage: error));
  },
);
```

Auth-driven side effects:
- `lib/main.dart` listens to `FirebaseAuth.instance.authStateChanges()` to set up notifications.
- `lib/core/services/injection_container.dart` handles 401/403 by clearing prefs/cache and routing to login.

## Local storage
Use `Prefs` in `lib/shared_pref/prefs.dart` for non-sensitive data.
Use keys from `lib/shared_pref/pref_keys.dart`.
How to use it:
- Initialize prefs in `MainApp.initState()` before accessing values.
- Store and read values using `Prefs.set*` and `Prefs.get*`.

Example (from `lib/services/theme_service.dart`):
```dart
await Prefs.setString(_themeModeKey, mode.name);
final savedMode = await Prefs.getString(_themeModeKey);
```

Example (initialization from `lib/main.dart`):
```dart
@override
void initState() {
  super.initState();
  Prefs.init();
}
```

Secure storage is optional:
`lib/services/secure_storage_service.dart` is not used by default (see its header comment). Only use it if explicitly requested.

## Notifications (common)
`NotificationService` in `lib/services/notification_service.dart` handles FCM and local notifications.
`lib/main.dart` wires it up and listens for notification taps.
How to use it:
- Initialize after authentication (`main.dart` does this on auth state changes).
- Listen to `onNotificationTap` for navigation.

Example (from `lib/main.dart`):
```dart
_notificationSubscription =
    NotificationService.instance.onNotificationTap.listen((payload) {
  _handleNotificationTap(payload);
});
```

## Deep links (optional, implemented)
Deep links are managed by `AppDeepLinkManager` in `lib/core/deep_link/app_deep_link_manager.dart`.
It is initialized in `lib/main.dart` and used in `lib/presentation/initial/initial_screen.dart`.
How to use it:
- Initialize in `main.dart` after the first frame.
- In the initial screen, check for pending deep links and route accordingly.

Example (from `lib/main.dart`):
```dart
WidgetsBinding.instance.addPostFrameCallback((_) async {
  await sl<AppDeepLinkManager>().initializeDeepLink();
});
```

Example (from `lib/presentation/initial/initial_screen.dart`):
```dart
if (deepLinkManager.hasPendingDeepLink) {
  final isDeepLinkHandled =
      await deepLinkManager.handlePendingDeepLink(context);
  if (!isDeepLinkHandled) {
    await context.router.replace(const HomeRoute());
  }
}
```

## Environment, flavors, and SSL pinning
Environment is configured via `.env` and `AppConfig` in `lib/utils/app_flavor_env.dart`.
`lib/initialize_app.dart` loads `.env` before DI.
How to use it:
- Add env values in `.env` and access them via `AppConfig`.
- Load `.env` in `initialize_app.dart` before dependency setup.

Example (from `lib/utils/app_flavor_env.dart`):
```dart
static String get baseUrl {
  switch (appFlavor) {
    case AppFlavor.dev:
      return dotenv.env['DEV_API_BASE_URL'] ?? '';
    case AppFlavor.stage:
      return dotenv.env['STAGE_API_BASE_URL'] ?? '';
    case AppFlavor.prod:
      return dotenv.env['PROD_API_BASE_URL'] ?? '';
  }
}
```

Example (from `lib/initialize_app.dart`):
```dart
await dotenv.load();
```

SSL pinning is enforced in `lib/core/services/injection_container.dart` via `CertificatePinningInterceptor` and `_getCertHash()`.

## Theme and styling
Theme is controlled by `ThemeBloc` (`lib/utils/theme/bloc`) and `ThemeService` (`lib/services/theme_service.dart`).
`AppThemesData` and `AppColors` define base theming.
How to use it:
- Use `ThemeBloc` in `main.dart` to drive `themeMode`.
- Apply `AppTextStyles` and theme colors in widgets.

Example (from `lib/main.dart`):
```dart
return BlocBuilder<ThemeBloc, ThemeState>(
  builder: (context, state) {
    return MaterialApp.router(
      theme: AppThemesData.themeData[AppThemeEnum.LightTheme]!,
      darkTheme: AppThemesData.themeData[AppThemeEnum.DarkTheme]!,
      themeMode: state.themeMode,
```

Use `AppTextStyles` (`lib/common/theme/text_style/app_text_styles.dart`) and `AppColors` (`lib/widgets/styling/app_colors.dart`) for UI consistency.

## Localization (i18n)
Localization lives in `lib/i18n/`. Use the `LocalizationContext` extension.
How to use it:
- In widgets, use `context.localization.*`.
- In BLoCs needing localized strings, pass `AppLocalizations` via the constructor.

Example (from `lib/i18n/localization.dart`):
```dart
extension LocalizationContext on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
```

Use `context.localization.*` in widgets (see `lib/presentation/wishlist/widgets/empty_wishlist_view.dart`).

Example (from `lib/presentation/login/bloc/login_bloc.dart`):
```dart
final AppLocalizations localizations;

LoginBloc({
  required this.localizations,
}) : super(LoginState.initial()) { ... }
```

## Analytics (optional, implemented)
Microsoft Clarity analytics is used via `ClarityRouteObserver` in
`lib/core/clarity_analytics/clarity_route_observer.dart` and
`Clarity.setCurrentScreenName(...)` (see `lib/presentation/home/home_screen.dart`).
How to use it:
- Add `ClarityRouteObserver()` to `MaterialApp.router` observers.
- Call `Clarity.setCurrentScreenName(...)` in screens as needed.

Example (from `lib/main.dart`):
```dart
routerConfig: appRouter.config(
  navigatorObservers: () => [
    ClarityRouteObserver(),
  ],
),
```

Example (from `lib/presentation/home/home_screen.dart`):
```dart
final String screenName = pages[currentIndex].runtimeType.toString();
Clarity.setCurrentScreenName(screenName);
```

## Optional feature modules present in this repo
These features exist but should only be used when requested:
- Biometrics: `lib/services/local_auth_services.dart` and `lib/presentation/biometric_auth/`
- Remote config / force update: `lib/services/remote_config_service.dart` and `lib/presentation/force_update/`
- App tour: `lib/core/services/app_tour_service.dart`
- Subscriptions: `lib/services/subscription_service.dart` and `lib/presentation/subscription/`

Do not add or modify these unless the user asks.

Example usage (only when requested):
- Biometrics (from `lib/presentation/initial/initial_screen.dart`):
```dart
final localAuthService = sl<LocalAuthService>();
final biometricAuthStatus =
    await localAuthService.authenticate(context.localization);
```

- Remote config / force update (from `lib/presentation/initial/initial_screen.dart`):
```dart
final remoteConfig = RemoteConfigService();
final latestAppVersion = getExtendedVersionNumber(
  remoteConfig.getString(kRemoteConfigAppLatestVersionKey),
);
```

- App tour (from `lib/presentation/home/widgets/home_screen_body.dart`):
```dart
final tourCompleted = await AppTourService.isTourCompleted();
if (!tourCompleted && mounted) {
  AppTourService.showTour(
    context: context,
    searchBarKey: _searchBarKey,
    bottomNavKey: widget.bottomNavKey,
  );
}
```

- Subscriptions (from `lib/presentation/subscription/subscription_screen.dart`):
```dart
return SubscriptionBloc(
  localization: context.localization,
  subscriptionService: SubscriptionService(),
)..add(const FetchSubscriptionPackagesEvent());
```

## Testing (only when requested)
Add tests only when the user asks. Follow the patterns below so a module can be built in one shot.

### Unit tests (pure Dart / utils)
- Location: `test/utils/`, `test/presentation/**/bloc/` for pure logic.
- Use `flutter_test`’s `test`/`group`.
- Keep cases small and readable; prefer data-driven expectations.

Example (from `test/utils/extensions/primitive_types_extensions_test.dart`):
```dart
test('hasLetterAndNumber returns true for strings with both letters and numbers', () {
  expect('abc123'.hasLetterAndNumber(), isTrue);
  expect('123abc'.hasLetterAndNumber(), isTrue);
  expect('a1b2c3'.hasLetterAndNumber(), isTrue);
});
```

### BLoC tests (business logic)
- Use `bloc_test` with `mocktail` for dependencies.
- Register mocks in `setUp` and clean DI (`sl.unregister`) before re-registering.
- Keep one expectation per behavior and use predicates for clarity.

Example (from `test/presentation/login/bloc/login_bloc_test.dart`):
```dart
setUp(() {
  mockAuthService = MockFirebaseAuthService();
  l10n = MockAppLocalizations();
  if (sl.isRegistered<FirebaseAuthService>()) sl.unregister<FirebaseAuthService>();
  sl.registerLazySingleton<FirebaseAuthService>(() => mockAuthService);
});

blocTest<LoginBloc, LoginState>(
  'should update phone number in state',
  build: () => LoginBloc(localizations: l10n),
  act: (bloc) => bloc.add(PhoneNumChangeEvent(phoneNumber: '9876543210')),
  expect: () => [
    isA<LoginState>().having(
      (state) => state.phoneNumberLoginState?.phoneNumber,
      'phoneNumber',
      '9876543210',
    ),
  ],
);
```

### Widget tests (non-visual assertions)
- Use `flutter_test` + `BlocProvider` with mock blocs to render widgets.
- Leverage helpers (`tester.runWidgetTest` in `test/test_helpers.dart`) to wrap theme/providers.
- Assert widget presence and interactions, not visuals.

Example (from `test/presentation/login/login_with_phone_number/login_with_phone_number_screen_test.dart`):
```dart
await tester.runWidgetTest(
  child: const LoginWithPhoneNumberScreen(),
);
expect(find.byType(HeadingWelcomeWidget), findsOneWidget);
expect(find.byType(PhoneNumberTextField), findsOneWidget);
```

### Golden tests (visual regression with Alchemist)
- Use `goldenTest` + `GoldenTestGroup` + `createTestScenario` helpers.
- Always set `fileName`, call `precacheImages`, and provide `columnWidthBuilder` (e.g., `FixedColumnWidth(pixel5DeviceWidth)`).
- Test multiple UI states by swapping bloc states/providers.
- Include both light and dark themes when relevant.
- Do not add new goldens unless asked; if asked, update with `flutter test --update-goldens`.

Example (from `test/presentation/home/home_screen_test.dart`):
```dart
testExecutable(() {
  goldenTest(
    'Home page UI test',
    fileName: 'home_screen',
    pumpBeforeTest: precacheImages,
    builder: () {
      final homeBloc = MockHomeBloc();
      when(() => homeBloc.state).thenReturn(
        HomeState.test(topProducts: dummyProductData, filteredProducts: dummyProductData),
      );

      return GoldenTestGroup(
        columnWidthBuilder: (_) => const FixedColumnWidth(pixel5DeviceWidth),
        children: [
          createTestScenario(
            name: 'home_screen Light Theme',
            providers: [BlocProvider<HomeBloc>.value(value: homeBloc)],
            child: const HomeScreenWrapper(),
          ),
          createTestScenario(
            name: 'home_screen Dark Theme',
            providers: [BlocProvider<HomeBloc>.value(value: homeBloc)],
            child: const HomeScreenWrapper(),
            theme: AppThemeEnum.DarkTheme,
          ),
        ],
      );
    },
  );
});
```

Example (multi-state UI, from `test/presentation/login/login_with_phone_number/login_with_phone_number_screen_test.dart`):
```dart
return GoldenTestGroup(
  columnWidthBuilder: (_) => const FixedColumnWidth(pixel5DeviceWidth),
  children: [
    createTestScenario(
      name: 'default phone number state',
      child: const LoginWithPhoneNumberBody(isFromDeleteAccount: false),
      addScaffold: true,
      providers: [BlocProvider<LoginBloc>.value(value: loginBlocEmpty)],
    ),
    createTestScenario(
      name: 'error phone number state',
      child: const LoginWithPhoneNumberBody(isFromDeleteAccount: false),
      addScaffold: true,
      providers: [BlocProvider<LoginBloc>.value(value: loginBlocWithError)],
    ),
  ],
);
```

### Integration / Patrol tests (end-to-end)
- Location: `integration_test/`.
- Use `patrolTest` with `pumpWidgetAndSettle` and real navigation; inject mocks for network/auth as needed.
- Initialize app with `initializeApp(firebaseAuth: mockAuth, dio: mockDio);` before pumping `MainApp`.
- Use `integration_test_keys.dart` for stable selectors.
- Keep scenarios focused and deterministic; avoid network where possible by mocking Dio responses.

Example (from `integration_test/presentation/login/login_screen_test.dart`):
```dart
patrolTest(
  'open app, login with mobile number, verify products are displayed',
  framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
  ($) async {
    final mockFirebaseAuth = MockFirebaseAuth();
    await initializeApp(firebaseAuth: mockFirebaseAuth, dio: mockDio);
    await $.pumpWidgetAndSettle(const MainApp());

    await $(keys.signInPage.mobileNoTextField).enterText('9999988888');
    await $(keys.signInPage.sendOTPButton).tap();
    await $.pumpAndSettle();
    await $(keys.signInPage.otpTextField).waitUntilVisible();
    await $(keys.signInPage.otpTextField).enterText('123456');
    await $.pumpAndSettle();
    expect(find.text('Premium Wireless Headphones'), findsOneWidget);
  },
);
```

Example (email path, same file):
```dart
await initializeApp(firebaseAuthService: mockFirebaseAuthService, dio: mockDio);
await $.pumpWidgetAndSettle(const MainApp());
await $(keys.signInPage.continueWithEmailButton).tap();
await $.pumpAndSettle();
await $(keys.signInPage.emailTextField).enterText('test@example.com');
await $(keys.signInPage.passwordTextField).enterText('password123');
await $(keys.signInPage.loginWithEmailButton).tap();
await $.pumpAndSettle();
expect(find.text('Premium Wireless Headphones'), findsOneWidget);
```

### Test data and helpers
- Use `test/test_helpers.dart` and `test/flutter_test_config.dart` for shared setup (themes, device sizes, precache).
- For API data, use sample responses (e.g., `integration_test/demo_product_response.dart`).
- Mock Firebase/Dio via `integration_test/mock_firebase_auth.dart` and `MockDio` classes.

### Commands (only when requested)
- Unit/widget/bloc: `flutter test`
- Update goldens (when asked): `flutter test --update-goldens`
- Patrol/integration (when asked): `patrol test --target integration_test/app_test.dart --flavor dev --dart-define APP_FLAVOR=dev`

### General testing rules
- Keep tests readable; one assertion path per test.
- Mock external services; avoid real network/auth in tests.
- Use keys from `constants/integration_test_keys.dart` for UI selection.
- Ensure DI is initialized/mocked before pumping widgets.
- Do not generate or commit new goldens unless explicitly requested.
