enum OnboardingStatus {
  initial,
  ready,
  pageAdvanceRequested,
  completing,
  completed,
  failure,
}

class OnboardingState {
  final OnboardingStatus status;
  final int currentPage;
  final int? requestedPage;
  final String errorMessage;

  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.currentPage = 0,
    this.requestedPage,
    this.errorMessage = '',
  });

  OnboardingState copyWith({
    OnboardingStatus? status,
    int? currentPage,
    int? requestedPage,
    bool clearRequestedPage = false,
    String? errorMessage,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      requestedPage: clearRequestedPage
          ? null
          : requestedPage ?? this.requestedPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
