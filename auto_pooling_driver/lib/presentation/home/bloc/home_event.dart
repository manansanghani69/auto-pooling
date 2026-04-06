import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class HomeStartedEvent extends HomeEvent {
  const HomeStartedEvent();
}

class HomeRetryRequestedEvent extends HomeEvent {
  const HomeRetryRequestedEvent();
}
