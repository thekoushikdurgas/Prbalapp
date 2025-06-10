import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// API Configuration constants
class ApiConfig {
  // Use different URLs based on environment
  static const String baseUrl =
      'https://391fe935-4d49-4781-be95-ac0773559dcb-00-25e80q0svv2q.riker.replit.dev';
  // static String get baseUrl {
  //   if (kDebugMode) {
  //     // For development - use your computer's IP address instead of localhost
  //     // Replace with your actual IP address when testing on physical device

  //     return 'http://localhost:8000'; // Android emulator default
  //     // return 'http://10.0.2.2:8000'; // Android emulator default
  //     // return 'http://192.168.1.x:8000'; // Replace x with your IP for physical device
  //   } else {
  //     // For production - replace with your actual production API URL
  //     return 'https://your-production-api.com';
  //   }
  // }

  static const String apiVersion = 'v1';
  static String get baseApiUrl => '$baseUrl/api/$apiVersion';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

/// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.success(T? data, {String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(
    String message, {
    Map<String, dynamic>? errors,
    int? statusCode,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }
}

/// Custom exceptions for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => 'ApiException: $message';
}

/// Base API Service class
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late http.Client _client;
  String? _accessToken;
  String? _refreshToken;

  /// Initialize the API service
  void initialize() {
    _client = http.Client();
  }

  /// Set authentication tokens
  void setTokens({String? accessToken, String? refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  /// Get headers with authentication
  Map<String, String> _getHeaders({Map<String, String>? additionalHeaders}) {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);

    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Handle API response and errors
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T? Function(Map<String, dynamic>)? fromJson,
  ) {
    if (kDebugMode) {
      debugPrint('API Response [${response.statusCode}]: ${response.body}');
    }

    try {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Success response
        T? data;
        if (fromJson != null) {
          data = fromJson(responseData);
        }
        return ApiResponse.success(
          data,
          message: responseData['message'] as String?,
          statusCode: response.statusCode,
        );
      } else {
        // Error response
        return ApiResponse.error(
          responseData['message'] ??
              responseData['detail'] ??
              'Unknown error occurred',
          errors: responseData,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Failed to parse response: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    T? Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      var uri = Uri.parse('${ApiConfig.baseApiUrl}$endpoint');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      if (kDebugMode) {
        debugPrint('GET Request: $uri');
        debugPrint('Headers: ${_getHeaders(additionalHeaders: headers)}');
      }

      final response = await _client
          .get(uri, headers: _getHeaders(additionalHeaders: headers))
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Request failed');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T? Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseApiUrl}$endpoint');
      final requestBody = body != null ? json.encode(body) : null;

      if (kDebugMode) {
        debugPrint('POST Request: $uri');
        debugPrint('Headers: ${_getHeaders(additionalHeaders: headers)}');
        debugPrint('Body: $requestBody');
      }

      final response = await _client
          .post(
            uri,
            headers: _getHeaders(additionalHeaders: headers),
            body: requestBody,
          )
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Request failed');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  /// Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T? Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseApiUrl}$endpoint');
      final requestBody = body != null ? json.encode(body) : null;

      if (kDebugMode) {
        debugPrint('PUT Request: $uri');
        debugPrint('Headers: ${_getHeaders(additionalHeaders: headers)}');
        debugPrint('Body: $requestBody');
      }

      final response = await _client
          .put(
            uri,
            headers: _getHeaders(additionalHeaders: headers),
            body: requestBody,
          )
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Request failed');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  /// Generic PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T? Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseApiUrl}$endpoint');
      final requestBody = body != null ? json.encode(body) : null;

      if (kDebugMode) {
        debugPrint('PATCH Request: $uri');
        debugPrint('Headers: ${_getHeaders(additionalHeaders: headers)}');
        debugPrint('Body: $requestBody');
      }

      final response = await _client
          .patch(
            uri,
            headers: _getHeaders(additionalHeaders: headers),
            body: requestBody,
          )
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Request failed');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  /// Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T? Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseApiUrl}$endpoint');

      if (kDebugMode) {
        debugPrint('DELETE Request: $uri');
        debugPrint('Headers: ${_getHeaders(additionalHeaders: headers)}');
      }

      final response = await _client
          .delete(uri, headers: _getHeaders(additionalHeaders: headers))
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Request failed');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  /// Refresh access token
  Future<ApiResponse<Map<String, dynamic>>> refreshAccessToken() async {
    if (_refreshToken == null) {
      return ApiResponse.error('No refresh token available');
    }

    return post<Map<String, dynamic>>(
      '/auth/token/refresh/',
      body: {'refresh': _refreshToken},
      fromJson: (data) => data,
    );
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
