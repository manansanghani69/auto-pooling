import 'dart:convert';

import 'package:dio/dio.dart';

import '../errors/api_exception.dart';

class ApiClient {
  final Dio _dio;

  const ApiClient(this._dio);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
  }) {
    return request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
  }) {
    return request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  Future<Response<T>> request<T>(
    String path, {
    required String method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
  }) async {
    final response = await _dio.request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        method: method,
        headers: headers,
        extra: {
          'requiresAuth': requiresAuth,
        },
      ),
    );
    _validateResponse(response);
    return response;
  }

  void _validateResponse(Response response) {
    final Map<String, dynamic> payload = _normalizePayload(response);
    final int statusCode = response.statusCode ?? 500;
    final bool httpSuccess = statusCode >= 200 && statusCode < 300;
    final String status =
        payload['status']?.toString().toLowerCase() ?? '';
    final bool statusSuccess = status == 'success' || status == 'ok';
    final int? bodyCode = _toInt(payload['code']);
    final bool codeSuccess =
        bodyCode == null || (bodyCode >= 200 && bodyCode < 300);

    if (httpSuccess && statusSuccess && codeSuccess) {
      return;
    }

    throw APIException(
      message: _extractErrorMessage(payload, response),
      statusCode: bodyCode ?? statusCode,
    );
  }

  Map<String, dynamic> _normalizePayload(Response response) {
    final Object? data = response.data;
    if (data is Map) {
      try {
        final payload = Map<String, dynamic>.from(data);
        (response as Response<dynamic>).data = payload;
        return payload;
      } catch (_) {
        return {'message': data.toString()};
      }
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          (response as Response<dynamic>).data = decoded;
          return decoded;
        }
        return {'message': data};
      } catch (_) {
        return {'message': data};
      }
    }
    if (data == null) {
      return <String, dynamic>{};
    }
    return {'message': data.toString()};
  }

  String _extractErrorMessage(
    Map<String, dynamic> payload,
    Response response,
  ) {
    final Object? message =
        payload['message'] ?? payload['error'] ?? payload['status'];
    if (message != null && message.toString().isNotEmpty) {
      return message.toString();
    }
    return response.statusMessage ?? 'Request failed';
  }

  int? _toInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() accessTokenProvider;

  AuthInterceptor({required this.accessTokenProvider});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final bool requiresAuth = options.extra['requiresAuth'] == true;
    if (!requiresAuth) {
      handler.next(options);
      return;
    }

    final String? accessToken = await accessTokenProvider();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }
}

class ApiLoggerInterceptor extends Interceptor {
  final void Function(String message) logPrint;

  ApiLoggerInterceptor({required this.logPrint});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logPrint(_formatRequest(options));
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logPrint(_formatResponse(response));
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logPrint(_formatError(err));
    handler.next(err);
  }

  String _formatRequest(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.writeln('API REQUEST');
    buffer.writeln(_separator());
    buffer.writeln('METHOD: ${options.method}');
    buffer.writeln('URL: ${options.uri}');
    if (options.headers.isNotEmpty) {
      buffer.writeln('HEADERS: ${_safeJson(options.headers)}');
    }
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('QUERY: ${_safeJson(options.queryParameters)}');
    }
    if (options.data != null) {
      buffer.writeln('BODY: ${_safeJson(options.data)}');
    }
    buffer.writeln(_separator());
    return buffer.toString();
  }

  String _formatResponse(Response response) {
    final buffer = StringBuffer();
    buffer.writeln('API RESPONSE');
    buffer.writeln(_separator());
    buffer.writeln('STATUS: ${response.statusCode}');
    buffer.writeln('URL: ${response.requestOptions.uri}');
    if (response.headers.map.isNotEmpty) {
      buffer.writeln('HEADERS: ${_safeJson(response.headers.map)}');
    }
    if (response.data != null) {
      buffer.writeln('BODY: ${_safeJson(response.data)}');
    }
    buffer.writeln(_separator());
    return buffer.toString();
  }

  String _formatError(DioException error) {
    final buffer = StringBuffer();
    buffer.writeln('API ERROR');
    buffer.writeln(_separator());
    buffer.writeln('TYPE: ${error.type}');
    buffer.writeln('MESSAGE: ${error.message}');
    final response = error.response;
    if (response != null) {
      buffer.writeln('STATUS: ${response.statusCode}');
      buffer.writeln('URL: ${response.requestOptions.uri}');
      if (response.headers.map.isNotEmpty) {
        buffer.writeln('HEADERS: ${_safeJson(response.headers.map)}');
      }
      if (response.data != null) {
        buffer.writeln('BODY: ${_safeJson(response.data)}');
      }
    } else {
      buffer.writeln('URL: ${error.requestOptions.uri}');
    }
    buffer.writeln(_separator());
    return buffer.toString();
  }

  String _separator() => '----------------------------------------';

  String _safeJson(Object? value) {
    if (value == null) {
      return 'null';
    }
    if (value is FormData) {
      return value.fields.toString();
    }
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(value);
    } catch (_) {
      return value.toString();
    }
  }
}
