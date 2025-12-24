enum RideTrackingStatus {
  initial,
}

class RideTrackingState {
  final RideTrackingStatus status;

  const RideTrackingState({required this.status});

  factory RideTrackingState.initial() =>
      const RideTrackingState(status: RideTrackingStatus.initial);

  RideTrackingState copyWith({RideTrackingStatus? status}) {
    return RideTrackingState(status: status ?? this.status);
  }
}
