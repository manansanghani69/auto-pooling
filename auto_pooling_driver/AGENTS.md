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

## SOLID principles (always follow)
All code written in this project must adhere to SOLID principles. These are non-negotiable design guidelines that ensure maintainability, testability, and scalability.

### S - Single Responsibility Principle
Every class, widget, or function should have one clear responsibility. If a class does multiple things, split it.

**Example (correct):**
```dart
// Good: Each class has a single, clear responsibility
class UserRepository {
  Future<User> getUser(String id) async {
    // Only handles data fetching
    final response = await _apiClient.get('/users/$id');
    return User.fromJson(response.data);
  }
}

class UserValidator {
  bool isValidEmail(String email) {
    // Only handles validation logic
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class UserBloc extends Bloc<UserEvent, UserState> {
  // Only handles state management and business logic coordination
  UserBloc({required this.repository, required this.validator});
  
  void _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    final result = await repository.getUser(event.userId);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }
}
```

**Example (incorrect):**
```dart
// Bad: Class does too many things
class UserManager {
  Future<User> getUser(String id) async { /* data fetching */ }
  bool isValidEmail(String email) { /* validation */ }
  void updateUI(User user) { /* UI updates */ }
  void saveToCache(User user) { /* caching */ }
}
```

### O - Open/Closed Principle
Classes should be open for extension but closed for modification. Use abstraction and inheritance to add new features without changing existing code.

**Example (correct):**
```dart
// Good: Abstract base allows extension without modification
abstract class PaymentProcessor {
  Future<PaymentResult> processPayment(PaymentRequest request);
}

class CreditCardProcessor extends PaymentProcessor {
  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    // Credit card specific logic
    return PaymentResult.success();
  }
}

class PayPalProcessor extends PaymentProcessor {
  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    // PayPal specific logic
    return PaymentResult.success();
  }
}

// Adding new payment methods doesn't require modifying existing code
class CryptoProcessor extends PaymentProcessor {
  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    // Crypto specific logic
    return PaymentResult.success();
  }
}
```

**Example (incorrect):**
```dart
// Bad: Adding new payment types requires modifying existing class
class PaymentProcessor {
  Future<PaymentResult> processPayment(PaymentRequest request, String type) async {
    if (type == 'credit_card') {
      // credit card logic
    } else if (type == 'paypal') {
      // paypal logic
    } else if (type == 'crypto') { // Have to modify this method every time
      // crypto logic
    }
  }
}
```

### L - Liskov Substitution Principle
Subclasses must be substitutable for their base classes without breaking functionality. Don't override methods in ways that violate expected behavior.

**Example (correct):**
```dart
// Good: Subtypes maintain base class contract
abstract class DataSource {
  Future<List<Product>> getProducts();
}

class RemoteDataSource implements DataSource {
  @override
  Future<List<Product>> getProducts() async {
    final response = await _apiClient.get('/products');
    return response.data.map((json) => Product.fromJson(json)).toList();
  }
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Product>> getProducts() async {
    final jsonList = await _cacheManager.getCachedProducts();
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }
}

// Can use either data source interchangeably
class ProductRepository {
  ProductRepository(this._dataSource);
  final DataSource _dataSource;
  
  Future<List<Product>> getProducts() => _dataSource.getProducts();
}
```

**Example (incorrect):**
```dart
// Bad: Subtype violates base class contract
abstract class DataSource {
  Future<List<Product>> getProducts();
}

class BrokenDataSource implements DataSource {
  @override
  Future<List<Product>> getProducts() async {
    throw UnimplementedError(); // Violates expected behavior
  }
}
```

### I - Interface Segregation Principle
Don't force classes to implement interfaces they don't use. Create smaller, focused interfaces instead of large, monolithic ones.

**Example (correct):**
```dart
// Good: Small, focused interfaces
abstract class Readable {
  Future<String> read();
}

abstract class Writable {
  Future<void> write(String data);
}

abstract class Deletable {
  Future<void> delete();
}

// Classes implement only what they need
class FileReader implements Readable {
  @override
  Future<String> read() async {
    // Read implementation
  }
}

class FileWriter implements Writable {
  @override
  Future<void> write(String data) async {
    // Write implementation
  }
}

class FileManager implements Readable, Writable, Deletable {
  @override
  Future<String> read() async { /* ... */ }
  
  @override
  Future<void> write(String data) async { /* ... */ }
  
  @override
  Future<void> delete() async { /* ... */ }
}
```

**Example (incorrect):**
```dart
// Bad: Monolithic interface forces unnecessary implementations
abstract class FileOperations {
  Future<String> read();
  Future<void> write(String data);
  Future<void> delete();
  Future<void> compress();
  Future<void> encrypt();
}

class SimpleFileReader implements FileOperations {
  @override
  Future<String> read() async { /* actual implementation */ }
  
  // Forced to implement methods it doesn't need
  @override
  Future<void> write(String data) async => throw UnimplementedError();
  
  @override
  Future<void> delete() async => throw UnimplementedError();
  
  @override
  Future<void> compress() async => throw UnimplementedError();
  
  @override
  Future<void> encrypt() async => throw UnimplementedError();
}
```

### D - Dependency Inversion Principle
High-level modules should not depend on low-level modules. Both should depend on abstractions. This is enforced through our dependency injection setup.

**Example (correct):**
```dart
// Good: Depends on abstraction (interface), not concrete implementation
abstract class AuthRepository {
  Future<ResultFuture<User>> login(String email, String password);
  Future<ResultFuture<void>> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  @override
  Future<ResultFuture<User>> login(String email, String password) async {
    // Implementation details
  }
  
  @override
  Future<ResultFuture<void>> logout() async {
    // Implementation details
  }
}

// BLoC depends on abstraction, not concrete class
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}); // Depends on interface
  
  final AuthRepository authRepository; // Not AuthRepositoryImpl
}

// Dependency injection configuration
sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ),
);
```

**Example (incorrect):**
```dart
// Bad: Direct dependency on concrete implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() {
    // Creates concrete dependency directly - can't be tested or swapped
    _repository = AuthRepositoryImpl(
      remoteDataSource: FirebaseAuthDataSource(),
      localDataSource: SharedPrefsDataSource(),
    );
  }
  
  late final AuthRepositoryImpl _repository; // Concrete class, not interface
}
```

### SOLID in widget composition
Widgets should also follow SOLID principles, especially Single Responsibility:

**Example (correct):**
```dart
// Good: Each widget has a single, clear purpose
class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});
  final Product product;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ProductImage(imageUrl: product.imageUrl),
          ProductTitle(title: product.title),
          ProductPrice(price: product.price),
          AddToCartButton(productId: product.id),
        ],
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({required this.imageUrl, super.key});
  final String imageUrl;
  
  @override
  Widget build(BuildContext context) {
    // Only responsible for displaying image
    return CachedNetworkImage(imageUrl: imageUrl);
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({required this.price, super.key});
  final double price;
  
  @override
  Widget build(BuildContext context) {
    // Only responsible for formatting and displaying price
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: AppTextStyles.h3Bold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}
```

**Example (incorrect):**
```dart
// Bad: Widget does too many things
class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});
  final Product product;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Image loading logic inline
          FutureBuilder<ui.Image>(
            future: _loadImage(product.imageUrl),
            builder: (context, snapshot) { /* complex logic */ },
          ),
          // Price calculation and formatting inline
          Builder(
            builder: (context) {
              final discount = product.discount ?? 0;
              final finalPrice = product.price * (1 - discount);
              final formattedPrice = '\$${finalPrice.toStringAsFixed(2)}';
              return Text(formattedPrice); // Mixed responsibilities
            },
          ),
          // Cart logic inline
          ElevatedButton(
            onPressed: () {
              // Inline cart logic instead of delegating
              context.read<CartBloc>().add(AddToCartEvent(product.id));
              ScaffoldMessenger.of(context).showSnackBar(/* ... */);
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
```

### Applying SOLID to this codebase
When writing code for this project:
1. **Before creating a class**, ask: "What is its single responsibility?"
2. **Before adding a method**, ask: "Does this belong here, or should it be in a separate class?"
3. **When designing features**, create abstractions (interfaces/abstract classes) first, then implementations
4. **Use dependency injection** for all dependencies - never create instances directly in classes
5. **Keep widgets small** - each widget should do one thing well
6. **Prefer composition over inheritance** - build complex behavior by combining simple pieces
7. **Make dependencies explicit** - pass them through constructors, not hidden in implementations

These principles ensure the codebase remains maintainable as it grows and makes testing straightforward.

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
  sl.registerLazySingleton<CacheManager>(() => cacheManager);

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
}
```

## Routing (AutoRoute)
Use AutoRoute for navigation. Routes live in `lib/routes.dart` (manually edited) and `lib/routes.gr.dart` (generated).
- Add new routes to `lib/routes.dart`, then run `dart run build_runner build --delete-conflicting-outputs`.
- Use `context.pushRoute(...)`, `context.replaceRoute(...)`, `context.popRoute()`, etc.

Example (from `lib/routes.dart`):
```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: LoginWithPhoneNumberRoute.page),
  ];
}
```

Example (from `lib/presentation/login/screens/login_with_phone_number/login_with_phone_number_screen.dart`):
```dart
context.pushRoute(PhoneNumberOTPRoute(
  loginBloc: context.read<LoginBloc>(),
  isFromDeleteAccount: false,
));
```

## Error handling (typed failures)
All repository/usecase methods return `ResultFuture<T>` (a typedef for `Future<Either<Failure, T>>`).
- Define failure types in `lib/core/errors/failures.dart`.
- Handle errors in BLoCs using `.fold` to emit the correct state.

Example (from `lib/presentation/home/bloc/home_bloc.dart`):
```dart
final result = await _getProducts();
result.fold(
  (failure) => emit(AuthenticationError(state, errorMessage: failure.errorMessage)),
  (products) => emit(TopProductsLoadedState(state, topProducts: products)),
);
```

## Localization
Use `context.localization` for user-facing text. Localized strings live in `lib/l10n/app_*.arb` files.
- Do not hardcode user-visible text in widgets; use keys from localization.
- Generate localizations with `flutter gen-l10n` (already configured in `pubspec.yaml`).

Example (from `lib/presentation/login/screens/login_with_phone_number/widgets/heading_welcome_widget.dart`):
```dart
Text(
  context.localization.welcome,
  style: AppTextStyles.h1Bold.copyWith(
    color: context.currentTheme.textNeutralPrimary,
  ),
),
```

## Theming
Use theme extensions for colors and `AppTextStyles` for text styles.
- Colors: `context.currentTheme.textNeutralPrimary`, `context.currentTheme.backgroundSurface`, etc.
- Text styles: `AppTextStyles.h1Bold`, `AppTextStyles.p2Regular`, etc.

Example:
```dart
Container(
  color: context.currentTheme.backgroundPrimary,
  child: Text(
    'Hello',
    style: AppTextStyles.h2Bold.copyWith(
      color: context.currentTheme.textNeutralPrimary,
    ),
  ),
),
```

## Assets and code generation
- Images/icons go in `assets/images/` and `assets/icons/`.
- Register assets in `pubspec.yaml` under `flutter: assets:`.
- Run `dart run build_runner build --delete-conflicting-outputs` to generate `lib/gen/assets.gen.dart`.
- Reference assets with `Assets.images.logo`, `Assets.icons.search`, etc.

Example:
```dart
Image.asset(Assets.images.appLogo.path)
```

## Analytics and tracking
Use `AnalyticsService` for logging events.
Example (from `lib/core/analytics/analytics_service.dart`):
```dart
AnalyticsService.logEvent(AnalyticsEvents.userLoggedIn, parameters: {
  'method': 'phone',
});
```

## Deep links (uni_links)
Handle deep links in `lib/core/services/deep_link_service.dart`.

## App services
- Firebase Auth: `lib/services/firebase_auth_service.dart`
```dart
final authService = sl<FirebaseAuthService>();
final result = await authService.signInWithEmail(email: email, password: password);
```

- Notifications (Firebase Messaging / local notifications):
```dart
final notificationService = sl<NotificationService>();
await notificationService.initialize();
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
- Use `flutter_test`'s `test`/`group`.
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
