enum SplashStatus { initial, loading, resolved, failure }

enum SplashDestination { onboarding, auth, profile, home }

class SplashState {
  final SplashStatus status;
  final SplashDestination? destination;
  final String errorMessage;

  const SplashState({
    required this.status,
    required this.destination,
    required this.errorMessage,
  });

  factory SplashState.initial() => const SplashState(
    status: SplashStatus.initial,
    destination: null,
    errorMessage: '',
  );

  SplashState copyWith({
    SplashStatus? status,
    SplashDestination? destination,
    bool clearDestination = false,
    String? errorMessage,
  }) {
    return SplashState(
      status: status ?? this.status,
      destination: clearDestination ? null : destination ?? this.destination,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
