import 'package:equatable/equatable.dart';

enum AuthGateStatus { initial, resolving, resolved }

enum AuthGateRouteTarget {
  login,
  personalDetails,
  documentUpload,
  applicationStatus,
  home,
}

class AuthGateState extends Equatable {
  const AuthGateState({this.status = AuthGateStatus.initial, this.routeTarget});

  final AuthGateStatus status;
  final AuthGateRouteTarget? routeTarget;

  AuthGateState copyWith({
    AuthGateStatus? status,
    AuthGateRouteTarget? routeTarget,
  }) {
    return AuthGateState(
      status: status ?? this.status,
      routeTarget: routeTarget ?? this.routeTarget,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, routeTarget];
}
