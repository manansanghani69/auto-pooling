enum RideRequestStatus {
  initial,
}

class RideRequestState {
  final RideRequestStatus status;

  const RideRequestState({required this.status});

  factory RideRequestState.initial() =>
      const RideRequestState(status: RideRequestStatus.initial);

  RideRequestState copyWith({RideRequestStatus? status}) {
    return RideRequestState(status: status ?? this.status);
  }
}
