class CacheException implements Exception {
  const CacheException(this.message);

  final String message;
}

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;
}

class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;
}
