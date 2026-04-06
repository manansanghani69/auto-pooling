import 'package:equatable/equatable.dart';

enum FailureType { cache, unexpected }

abstract class Failure extends Equatable {
  const Failure({required this.type, this.debugMessage});

  final FailureType type;
  final String? debugMessage;

  @override
  List<Object?> get props => <Object?>[type, debugMessage];
}

class CacheFailure extends Failure {
  const CacheFailure({super.debugMessage}) : super(type: FailureType.cache);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.debugMessage})
      : super(type: FailureType.unexpected);
}
