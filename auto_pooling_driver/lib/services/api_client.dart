import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_pooling_driver/constants/app_constants.dart';
import 'package:auto_pooling_driver/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';

abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers});

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });
}

class HttpApiClient implements ApiClient {
  HttpApiClient();

  static const Duration _requestTimeout = Duration(seconds: 20);
  static const Set<String> _sensitiveKeys = <String>{
    'authorization',
    'accessToken',
    'refreshToken',
    'otp',
  };

  final HttpClient _httpClient = HttpClient();

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) {
    return _send(method: 'GET', path: path, headers: headers);
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    return _send(method: 'POST', path: path, body: body, headers: headers);
  }

  Future<Map<String, dynamic>> _send({
    required String method,
    required String path,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse('${AppConstants.apiBaseUrl}$path');
    _logRequest(method: method, uri: uri, headers: headers, body: body);

    try {
      final HttpClientRequest request = await _httpClient
          .openUrl(method, uri)
          .timeout(_requestTimeout);

      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      headers?.forEach(request.headers.set);

      if (body != null) {
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode(body));
      }

      final HttpClientResponse response = await request.close().timeout(
        _requestTimeout,
      );
      final String responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> responseJson = _decodeResponse(responseBody);

      _logResponse(
        method: method,
        uri: uri,
        statusCode: response.statusCode,
        body: responseJson,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseJson;
      }

      throw ApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(responseJson),
      );
    } on SocketException catch (error) {
      _logFailure(method: method, uri: uri, error: error);
      throw const NetworkException(
        'Unable to reach the server. Check your internet connection and try again.',
      );
    } on HandshakeException catch (error) {
      _logFailure(method: method, uri: uri, error: error);
      throw const NetworkException(
        'Unable to establish a secure connection right now.',
      );
    } on TimeoutException catch (error) {
      _logFailure(method: method, uri: uri, error: error);
      throw const NetworkException(
        'The server took too long to respond. Please try again.',
      );
    } on ApiException catch (error) {
      _logFailure(method: method, uri: uri, error: error);
      rethrow;
    } catch (error) {
      _logFailure(method: method, uri: uri, error: error);
      rethrow;
    }
  }

  Map<String, dynamic> _decodeResponse(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final dynamic decoded = jsonDecode(responseBody);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const ApiException(
      statusCode: 500,
      message: 'Received an unexpected server response.',
    );
  }

  String _extractErrorMessage(Map<String, dynamic> responseJson) {
    final Map<String, dynamic>? error =
        responseJson['error'] as Map<String, dynamic>?;
    final String? message = error?['message']?.toString();
    if (message != null && message.trim().isNotEmpty) {
      return message;
    }

    return 'Something went wrong. Please try again.';
  }

  void _logRequest({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) {
    debugPrint(
      _buildLogBlock(
        title: '[API][REQUEST] $method $uri',
        fields: <String, String>{
          'Headers': _encodeLogValue(_sanitizeMap(headers)),
          'Body': _encodeLogValue(_sanitizeValue(body)),
        },
      ),
    );
  }

  void _logResponse({
    required String method,
    required Uri uri,
    required int statusCode,
    required Map<String, dynamic> body,
  }) {
    debugPrint(
      _buildLogBlock(
        title: '[API][RESPONSE] $method $uri',
        fields: <String, String>{
          'Status': statusCode.toString(),
          'Body': _encodeLogValue(_sanitizeValue(body)),
        },
      ),
    );
  }

  void _logFailure({
    required String method,
    required Uri uri,
    required Object error,
  }) {
    debugPrint(
      _buildLogBlock(
        title: '[API][ERROR] $method $uri',
        fields: <String, String>{'Error': error.toString()},
      ),
    );
  }

  Map<String, dynamic>? _sanitizeMap(Map<String, String>? source) {
    if (source == null) {
      return null;
    }

    return source.map(
      (String key, String value) => MapEntry<String, dynamic>(
        key,
        _isSensitiveKey(key) ? _redactValue(value) : value,
      ),
    );
  }

  dynamic _sanitizeValue(dynamic value, {String? key}) {
    if (value == null) {
      return null;
    }

    if (value is Map<String, dynamic>) {
      return value.map<String, dynamic>(
        (String nestedKey, dynamic nestedValue) => MapEntry<String, dynamic>(
          nestedKey,
          _sanitizeValue(nestedValue, key: nestedKey),
        ),
      );
    }

    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic nestedKey, dynamic nestedValue) => MapEntry<String, dynamic>(
          nestedKey.toString(),
          _sanitizeValue(nestedValue, key: nestedKey.toString()),
        ),
      );
    }

    if (value is List) {
      return value
          .map<dynamic>((dynamic item) => _sanitizeValue(item))
          .toList();
    }

    if (key != null && _isSensitiveKey(key)) {
      return _redactValue(value.toString());
    }

    return value;
  }

  bool _isSensitiveKey(String key) {
    return _sensitiveKeys.contains(key.toLowerCase());
  }

  String _redactValue(String value) {
    if (value.isEmpty) {
      return value;
    }

    return '***REDACTED***';
  }

  String _encodeLogValue(dynamic value) {
    if (value == null) {
      return 'null';
    }

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  }

  String _buildLogBlock({
    required String title,
    required Map<String, String> fields,
  }) {
    final StringBuffer buffer = StringBuffer(title);

    fields.forEach((String label, String value) {
      buffer
        ..writeln()
        ..writeln('$label:')
        ..write(value);
    });

    return buffer.toString();
  }
}
