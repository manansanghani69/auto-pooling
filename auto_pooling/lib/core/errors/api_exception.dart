class APIException implements Exception {
  final String message;
  final int statusCode;

  const APIException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() =>
      'APIException(statusCode: $statusCode, message: $message)';
}
