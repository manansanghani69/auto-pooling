abstract class SplashEvent {
  const SplashEvent();
}

class SplashStartedEvent extends SplashEvent {
  const SplashStartedEvent();
}

class SplashRetryRequestedEvent extends SplashEvent {
  const SplashRetryRequestedEvent();
}
