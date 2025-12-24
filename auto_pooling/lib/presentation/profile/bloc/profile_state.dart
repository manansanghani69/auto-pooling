enum ProfileStatus {
  initial,
}

class ProfileState {
  final ProfileStatus status;

  const ProfileState({required this.status});

  factory ProfileState.initial() =>
      const ProfileState(status: ProfileStatus.initial);

  ProfileState copyWith({ProfileStatus? status}) {
    return ProfileState(status: status ?? this.status);
  }
}
