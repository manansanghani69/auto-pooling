import 'package:equatable/equatable.dart';

enum FailureType {
  cache,
  validation,
  unauthorized,
  forbidden,
  network,
  server,
  unexpected,
}

abstract class Failure extends Equatable {
  const Failure({required this.type, this.message, this.debugMessage});

  final FailureType type;
  final String? message;
  final String? debugMessage;

  @override
  List<Object?> get props => <Object?>[type, message, debugMessage];
}

class CacheFailure extends Failure {
  const CacheFailure({super.debugMessage}) : super(type: FailureType.cache);
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message, super.debugMessage})
    : super(type: FailureType.validation);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message, super.debugMessage})
    : super(type: FailureType.unauthorized);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.message, super.debugMessage})
    : super(type: FailureType.forbidden);
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message, super.debugMessage})
    : super(type: FailureType.network);
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, super.debugMessage})
    : super(type: FailureType.server);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message, super.debugMessage})
    : super(type: FailureType.unexpected);
}
