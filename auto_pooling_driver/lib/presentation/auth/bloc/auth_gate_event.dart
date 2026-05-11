import 'package:equatable/equatable.dart';

abstract class AuthGateEvent extends Equatable {
  const AuthGateEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class AuthGateStartedEvent extends AuthGateEvent {
  const AuthGateStartedEvent();
}
