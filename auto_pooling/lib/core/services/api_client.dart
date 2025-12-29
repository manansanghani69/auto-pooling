import 'dart:convert';

import 'package:dio/dio.dart';

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
  }) {
    return _dio.request<T>(
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
