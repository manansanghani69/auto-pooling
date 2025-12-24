import 'api_exception.dart';

class APIFailure {
  final String errorMessage;
  final int statusCode;

  const APIFailure({
    required this.errorMessage,
    required this.statusCode,
  });

  factory APIFailure.fromException(APIException exception) {
    return APIFailure(
      errorMessage: exception.message,
      statusCode: exception.statusCode,
    );
  }
}
