enum NotificationsStatus {
  initial,
}

class NotificationsState {
  final NotificationsStatus status;

  const NotificationsState({required this.status});

  factory NotificationsState.initial() =>
      const NotificationsState(status: NotificationsStatus.initial);

  NotificationsState copyWith({NotificationsStatus? status}) {
    return NotificationsState(status: status ?? this.status);
  }
}
