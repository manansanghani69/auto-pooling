abstract class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingPageChangedEvent extends OnboardingEvent {
  final int index;

  const OnboardingPageChangedEvent({required this.index});
}
