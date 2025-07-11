import 'dart:convert';
import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/models/core/api_models.dart';
import 'package:prbal/utils/debug_logger.dart';
// import 'package:prbal/models/core/paginated_response.dart';

/// Core API service for handling HTTP requests to Prbal User Management API
///
/// This service is designed based on the analysis of Prbal API Postman collections
class ApiService {
  // API Configuration based on Postman collection analysis
  static const String _baseUrl =
      'https://q5jskx-8000.csb.app/api/v1'; // CodeSandbox environment
  static const Duration _defaultTimeout = Duration(seconds: 30);

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;
  final Ref? _ref; // Reference to Riverpod container for token refresh

  ApiService({
    String? baseUrl,
    Duration? timeout,
    http.Client? client,
    Ref? ref,
  })  : baseUrl = baseUrl ?? _baseUrl,
        timeout = timeout ?? _defaultTimeout,
        _client = client ?? http.Client(),
        _ref = ref {
    DebugLogger.api('ApiService initialized with base URL: ${this.baseUrl}');
  }

  /// Check if response indicates token expiration
  bool _isTokenExpiredError(http.Response response) {
    if (response.statusCode != 401) return false;

    try {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final code = json['code'] as String?;
      final detail = json['detail'] as String?;
      final message = json['message'] as String?;

      // Check for token expiration indicators
      final isTokenExpired = code == 'token_not_valid' ||
          (detail != null &&
              (detail.contains('token not valid') ||
                  detail.contains('Token is expired') ||
                  detail.contains('Token is invalid'))) ||
          (message != null &&
              (message.contains('token') &&
                  (message.contains('expired') ||
                      message.contains('invalid'))));

      if (isTokenExpired) {
        DebugLogger.auth('Token expiration detected');
      }

      return isTokenExpired;
    } catch (e) {
      DebugLogger.error('Error parsing 401 response: $e');
      return false;
    }
  }

  /// Attempt to refresh token and retry request
  Future<ApiResponse<T>> _handleTokenRefreshAndRetry<T>(
    Future<http.Response> Function() originalRequest,
    T Function(dynamic)? fromJson,
  ) async {
    DebugLogger.auth('Attempting token refresh');

    if (_ref == null) {
      DebugLogger.error('No Riverpod ref available for token refresh');
      return ApiResponse.error(
        message: 'Token expired and no refresh mechanism available',
        statusCode: 401,
      );
    }

    try {
      final refreshSuccess = HiveService.getRefreshToken();

      if (refreshSuccess != null) {
        DebugLogger.auth('Token refresh successful, retrying request');
        final retryResponse = await originalRequest();
        return _parseResponse<T>(retryResponse, fromJson);
      } else {
        DebugLogger.auth('Token refresh failed, clearing session');
        await HiveService.logout();
        return ApiResponse.error(
          message: 'Session expired. Please login again.',
          statusCode: 401,
        );
      }
    } catch (e) {
      DebugLogger.error('Token refresh error: $e');
      return ApiResponse.error(
        message: 'Authentication error. Please login again.',
        statusCode: 401,
      );
    }
  }

  /// Enhanced request wrapper with automatic token refresh
  Future<ApiResponse<T>> _makeRequestWithTokenRefresh<T>(
    Future<http.Response> Function() request,
    T Function(dynamic)? fromJson,
  ) async {
    try {
      final response = await request();

      if (_isTokenExpiredError(response)) {
        return await _handleTokenRefreshAndRetry<T>(request, fromJson);
      }

      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      DebugLogger.error('Request error: $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  /// Convert relative URL to absolute URL
  static String convertToAbsoluteUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    if (url.startsWith('/')) {
      final baseDomain = _baseUrl.replaceAll('/api/v1', '');
      return '$baseDomain$url';
    }

    return url;
  }

  /// Get authorization header with Bearer token
  Map<String, String> _getAuthHeaders([String? token]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Make GET request with automatic token refresh
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    final timer = PerformanceTimer('GET $endpoint');
    DebugLogger.api('GET $endpoint');

    // Use token refresh wrapper for authenticated requests
    if (token != null) {
      final response = await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');
          final finalUri = queryParams != null
              ? uri.replace(queryParameters: queryParams)
              : uri;

          final response = await _client
              .get(finalUri, headers: _getAuthHeaders(token))
              .timeout(timeout);

          return response;
        },
        fromJson,
      );

      timer.finish();
      return response;
    }

    // For non-authenticated requests
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final finalUri =
          queryParams != null ? uri.replace(queryParameters: queryParams) : uri;

      final response = await _client
          .get(finalUri, headers: _getAuthHeaders(token))
          .timeout(timeout);

      timer.finish();
      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      timer.finish();
      DebugLogger.error('GET error: $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  /// Make POST request with automatic token refresh
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    final timer = PerformanceTimer('POST $endpoint');
    DebugLogger.api('POST $endpoint');

    // Use token refresh wrapper for authenticated requests
    if (token != null) {
      final response = await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');
          final jsonBody = body != null ? jsonEncode(body) : null;

          final response = await _client
              .post(uri, headers: _getAuthHeaders(token), body: jsonBody)
              .timeout(timeout);

          return response;
        },
        fromJson,
      );

      timer.finish();
      return response;
    }

    // For non-authenticated requests
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final jsonBody = body != null ? jsonEncode(body) : null;

      final response = await _client
          .post(uri, headers: _getAuthHeaders(token), body: jsonBody)
          .timeout(timeout);

      timer.finish();
      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      timer.finish();
      DebugLogger.error('POST error: $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  /// Parse HTTP response to ApiResponse
  ApiResponse<T> _parseResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      if (response.body.isEmpty) {
        return ApiResponse.error(
          message: 'Empty response body',
          statusCode: response.statusCode,
        );
      }

      final Map<String, dynamic> json = jsonDecode(response.body);
      return ApiResponse.fromJson(json, fromJson);
    } catch (e) {
      DebugLogger.error('Response parsing error: $e');
      return ApiResponse.error(
        message: 'Failed to parse response: $e',
        statusCode: response.statusCode,
      );
    }
  }

  /// Make PUT request with automatic token refresh
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    final timer = PerformanceTimer('PUT $endpoint');
    DebugLogger.api('PUT $endpoint');

    if (token != null) {
      final response = await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');
          final jsonBody = body != null ? jsonEncode(body) : null;

          final response = await _client
              .put(uri, headers: _getAuthHeaders(token), body: jsonBody)
              .timeout(timeout);

          return response;
        },
        fromJson,
      );

      timer.finish();
      return response;
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final jsonBody = body != null ? jsonEncode(body) : null;

      final response = await _client
          .put(uri, headers: _getAuthHeaders(token), body: jsonBody)
          .timeout(timeout);

      timer.finish();
      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      timer.finish();
      DebugLogger.error('PUT error: $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  /// Make DELETE request with automatic token refresh
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    final timer = PerformanceTimer('DELETE $endpoint');
    DebugLogger.api('DELETE $endpoint');

    if (token != null) {
      final response = await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');
          final response = await _client
              .delete(uri, headers: _getAuthHeaders(token))
              .timeout(timeout);

          return response;
        },
        fromJson,
      );

      timer.finish();
      return response;
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client
          .delete(uri, headers: _getAuthHeaders(token))
          .timeout(timeout);

      timer.finish();
      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      timer.finish();
      DebugLogger.error('DELETE error: $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  /// Make PATCH request with automatic token refresh
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    final timer = PerformanceTimer('PATCH $endpoint');
    DebugLogger.api('PATCH $endpoint');

    if (token != null) {
      final response = await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');
          final jsonBody = body != null ? jsonEncode(body) : null;

          final response = await _client
              .patch(uri, headers: _getAuthHeaders(token), body: jsonBody)
              .timeout(timeout);

          return response;
        },
        fromJson,
      );

      timer.finish();
      return response;
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final jsonBody = body != null ? jsonEncode(body) : null;

      final response = await _client
          .patch(uri, headers: _getAuthHeaders(token), body: jsonBody)
          .timeout(timeout);

      timer.finish();
      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      timer.finish();
      DebugLogger.error('PATCH error: $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  /// Upload file with multipart request
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint, {
    required File file,
    required String fieldName,
    Map<String, String>? additionalFields,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    final timer = PerformanceTimer('UPLOAD $endpoint');
    DebugLogger.api('UPLOAD $endpoint');

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add authorization header
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          contentType: MediaType('application', 'octet-stream'),
        ),
      );

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      timer.finish();
      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      timer.finish();
      DebugLogger.error('Upload error: $e');
      return ApiResponse.error(
        message: 'Upload failed: $e',
        statusCode: 500,
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
