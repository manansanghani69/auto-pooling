enum AuthStatus {
  initial,
}

class AuthState {
  final AuthStatus status;

  const AuthState({required this.status});

  factory AuthState.initial() =>
      const AuthState(status: AuthStatus.initial);

  AuthState copyWith({AuthStatus? status}) {
    return AuthState(status: status ?? this.status);
  }
}
