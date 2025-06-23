import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_providers.dart';

/// Standardized API response model based on Prbal API format
/// All Prbal API endpoints return responses in this consistent format:
/// {
///   "message": "Operation result message",
///   "data": { ... actual response data ... },
///   "time": "2024-01-20T15:30:45.123Z",
///   "statusCode": 200
/// }
///
/// This format is used across all endpoints:
/// - Services API: /api/services/services/
/// - Requests API: /api/services/requests/
/// - Categories API: /api/services/categories/
/// - AI Suggestions API: /ai_suggestions/
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final int statusCode;
  final DateTime time;
  final Map<String, dynamic>? errors;
  final Map<String, dynamic>? debugInfo;

  const ApiResponse({
    required this.success,
    this.data,
    required this.message,
    required this.statusCode,
    required this.time,
    this.errors,
    this.debugInfo,
  });

  factory ApiResponse.success({
    required T data,
    required String message,
    int statusCode = 200,
    DateTime? time,
  }) {
    debugPrint('📦 ApiResponse.success: Creating successful response');
    debugPrint('📦 → Status Code: $statusCode');
    debugPrint('📦 → Message: $message');
    debugPrint('📦 → Data Type: ${T.toString()}');
    debugPrint('📦 → Has Data: ${data != null}');

    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
      time: time ?? DateTime.now(),
    );
  }

  factory ApiResponse.error({
    required String message,
    required int statusCode,
    Map<String, dynamic>? errors,
    Map<String, dynamic>? debugInfo,
    DateTime? time,
  }) {
    debugPrint('📦 ApiResponse.error: Creating error response');
    debugPrint('📦 → Status Code: $statusCode');
    debugPrint('📦 → Error Message: $message');
    debugPrint('📦 → Has Error Details: ${errors != null}');
    debugPrint('📦 → Has Debug Info: ${debugInfo != null}');
    if (errors != null) {
      debugPrint('📦 → Error Keys: ${errors.keys.join(', ')}');
    }

    return ApiResponse<T>(
      success: false,
      data: null,
      message: message,
      statusCode: statusCode,
      time: time ?? DateTime.now(),
      errors: errors,
      debugInfo: debugInfo,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    debugPrint('📦 ApiResponse.fromJson: Parsing standardized API response');
    debugPrint('📦 → Raw JSON keys: ${json.keys.join(', ')}');
    debugPrint(
        '📦 → Message: ${json['message'] ?? json['detail'] ?? 'No message'}');

    final statusCode = json['statusCode'] ?? json['status_code'] ?? 200;
    final success = statusCode >= 200 && statusCode < 300;

    debugPrint('📦 → Status Code: $statusCode');
    debugPrint('📦 → Is Success: $success');
    debugPrint('📦 → Response Time: ${json['time'] ?? 'Not provided'}');
    debugPrint('📦 → Has Data Field: ${json['data'] != null}');

    T? parsedData;
    if (success && json['data'] != null && fromJsonT != null) {
      try {
        parsedData = fromJsonT(json['data']);
        debugPrint('📦 → Data parsed successfully to type: ${T.toString()}');
      } catch (e) {
        debugPrint('📦 → Error parsing data: $e');
        debugPrint('📦 → Raw data: ${json['data']}');
      }
    }

    return ApiResponse<T>(
      success: success,
      data: parsedData,
      message: json['message'] ?? json['detail'] ?? 'Unknown response',
      statusCode: statusCode,
      time: json['time'] != null
          ? DateTime.tryParse(json['time']) ?? DateTime.now()
          : DateTime.now(),
      errors: json['errors'],
      debugInfo: json['_debug'],
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;
}

/// Core API service for handling HTTP requests to Prbal User Management API
///
/// This service is designed based on the analysis of Prbal API Postman collections:
///
/// 🔧 SERVICES API (13 endpoints):
/// - List Services, Create Service, Retrieve/Update/Delete Service
/// - Find Nearby Services, Admin View, Trending Services
/// - Get Matching Requests, Filter by Availability, Find Matching Services
/// - Fulfill Service Request
///
/// 📋 REQUESTS API (11 endpoints):
/// - List/Create/Update/Delete Service Requests
/// - My Requests (Customer), Admin View, Recommended Providers
/// - Batch Expire Requests, Cancel Service Request
///
/// 🗂️ CATEGORIES API (Multiple endpoints):
/// - Categories: List, Create, Update, Delete, Statistics
/// - SubCategories: List, Create, Update, Delete
///
/// 🤖 AI SUGGESTIONS API:
/// - AI Suggestions management and generation
/// - Feedback logging and analytics
///
/// All endpoints follow the standardized response format:
/// {message, data, time, statusCode}
class ApiService {
  // API Configuration based on Postman collection analysis
  // static const String _baseUrl = 'http://localhost:8000'; // Local development
  static const String _baseUrl =
      'https://jd8lhn-8000.csb.app/api/v1'; // CodeSandbox environment
  // static const String _baseUrl = 'https://ppppfr-8000.csb.app/api/v1'; // Alternative environment
  static const Duration _defaultTimeout = Duration(seconds: 30);

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;
  final Ref? _ref; // Reference to Riverpod container for token refresh

  ApiService({
    String? baseUrl,
    Duration? timeout,
    http.Client? client,
    Ref? ref, // Optional ref for token refresh functionality
  })  : baseUrl = baseUrl ?? _baseUrl,
        timeout = timeout ?? _defaultTimeout,
        _client = client ?? http.Client(),
        _ref = ref {
    debugPrint('🌐 ApiService: Initializing API service');
    debugPrint('🌐 → Base URL: ${this.baseUrl}');
    debugPrint('🌐 → Request Timeout: ${this.timeout.inSeconds}s');
    debugPrint('🌐 → Has Riverpod Ref: ${_ref != null}');
    debugPrint('🌐 → HTTP Client: ${_client.runtimeType}');
    debugPrint('🌐 ========================================');
    debugPrint('🌐 API ENDPOINT ANALYSIS FROM POSTMAN:');
    debugPrint('🌐 ========================================');
    debugPrint('🌐 🔧 SERVICES ENDPOINTS:');
    debugPrint('🌐   → GET    /services/services/ (List services)');
    debugPrint(
        '🌐   → POST   /services/services/ (Create service - Provider only)');
    debugPrint('🌐   → GET    /services/services/{id}/ (Service details)');
    debugPrint(
        '🌐   → PUT    /services/services/{id}/ (Update service - Owner only)');
    debugPrint(
        '🌐   → PATCH  /services/services/{id}/ (Partial update - Owner only)');
    debugPrint(
        '🌐   → DELETE /services/services/{id}/ (Delete service - Owner only)');
    debugPrint(
        '🌐   → GET    /services/services/nearby/ (Find nearby services)');
    debugPrint(
        '🌐   → GET    /services/services/admin/ (Admin view - Admin only)');
    debugPrint(
        '🌐   → GET    /services/services/trending/ (Trending services)');
    debugPrint(
        '🌐   → GET    /services/services/matching_requests/ (Matching requests - Provider only)');
    debugPrint(
        '🌐   → GET    /services/services/by_availability/ (Filter by availability)');
    debugPrint(
        '🌐   → GET    /services/services/{id}/matching_services/ (Find matching services)');
    debugPrint(
        '🌐   → POST   /services/services/{id}/fulfill_request/ (Fulfill request - Provider only)');
    debugPrint('🌐 📋 REQUESTS ENDPOINTS:');
    debugPrint('🌐   → GET    /services/requests/ (List service requests)');
    debugPrint(
        '🌐   → POST   /services/requests/ (Create request - Customer only)');
    debugPrint('🌐   → GET    /services/requests/{id}/ (Request details)');
    debugPrint(
        '🌐   → PUT    /services/requests/{id}/ (Update request - Owner only)');
    debugPrint(
        '🌐   → PATCH  /services/requests/{id}/ (Partial update - Owner only)');
    debugPrint(
        '🌐   → DELETE /services/requests/{id}/ (Delete request - Owner only)');
    debugPrint(
        '🌐   → GET    /services/requests/my_requests/ (Customer requests - Customer only)');
    debugPrint(
        '🌐   → GET    /services/requests/admin/ (Admin view - Admin only)');
    debugPrint(
        '🌐   → GET    /services/requests/{id}/recommended_providers/ (Recommendations)');
    debugPrint(
        '🌐   → POST   /services/requests/batch_expire/ (Batch expire - Admin only)');
    debugPrint(
        '🌐   → POST   /services/requests/{id}/cancel/ (Cancel request)');
    debugPrint('🌐 🗂️ CATEGORIES ENDPOINTS:');
    debugPrint('🌐   → GET    /services/categories/ (List categories)');
    debugPrint(
        '🌐   → POST   /services/categories/ (Create category - Admin only)');
    debugPrint('🌐   → GET    /services/categories/{id}/ (Category details)');
    debugPrint(
        '🌐   → PUT    /services/categories/{id}/ (Update category - Admin only)');
    debugPrint(
        '🌐   → PATCH  /services/categories/{id}/ (Partial update - Admin only)');
    debugPrint(
        '🌐   → DELETE /services/categories/{id}/ (Delete category - Admin only)');
    debugPrint(
        '🌐   → GET    /services/categories/statistics/ (Category statistics - Admin only)');
    debugPrint('🌐   → GET    /services/subcategories/ (List subcategories)');
    debugPrint(
        '🌐   → POST   /services/subcategories/ (Create subcategory - Admin only)');
    debugPrint(
        '🌐   → GET    /services/subcategories/{id}/ (Subcategory details)');
    debugPrint(
        '🌐   → PUT    /services/subcategories/{id}/ (Update subcategory - Admin only)');
    debugPrint(
        '🌐   → PATCH  /services/subcategories/{id}/ (Partial update - Admin only)');
    debugPrint(
        '🌐   → DELETE /services/subcategories/{id}/ (Delete subcategory - Admin only)');
    debugPrint('🌐 🤖 AI SUGGESTIONS ENDPOINTS:');
    debugPrint(
        '🌐   → GET    /ai_suggestions/suggestions/ (List AI suggestions)');
    debugPrint(
        '🌐   → GET    /ai_suggestions/suggestions/{id}/ (Suggestion details)');
    debugPrint(
        '🌐   → POST   /ai_suggestions/suggestions/{id}/provide_feedback/ (Provide feedback)');
    debugPrint(
        '🌐   → POST   /ai_suggestions/suggestions/generate_service_suggestions/ (Generate suggestions)');
    debugPrint(
        '🌐   → POST   /ai_suggestions/suggestions/suggest_bid_amount/ (Suggest bid amount)');
    debugPrint(
        '🌐   → POST   /ai_suggestions/suggestions/suggest_bid_message/ (Suggest bid message)');
    debugPrint(
        '🌐   → POST   /ai_suggestions/suggestions/suggest_message/ (Suggest message template)');
    debugPrint('🌐   → GET    /ai_suggestions/feedback/ (List feedback logs)');
    debugPrint(
        '🌐   → GET    /ai_suggestions/feedback/{id}/ (Feedback log details)');
    debugPrint('🌐   → POST   /ai_suggestions/feedback/log/ (Log interaction)');
    debugPrint('🌐 ========================================');
    debugPrint('🌐 AUTHENTICATION & PERMISSIONS:');
    debugPrint('🌐   → Customer: Can create requests, view services');
    debugPrint('🌐   → Provider: Can create services, fulfill requests');
    debugPrint('🌐   → Admin: Full access to all endpoints');
    debugPrint('🌐   → Token refresh: Automatic with Riverpod integration');
    debugPrint('🌐 ========================================');
    debugPrint('🌐 RESPONSE FORMAT: {message, data, time, statusCode}');
    debugPrint('🌐 ApiService initialized successfully ✅');
  }

  /// Check if response indicates token expiration
  /// This method analyzes 401 responses to determine if it's due to token expiration
  /// Based on Prbal API error response patterns from Postman collection analysis
  bool _isTokenExpiredError(http.Response response) {
    debugPrint(
        '🔐 ApiService._isTokenExpiredError: Checking for token expiration');
    debugPrint('🔐 → Response Status: ${response.statusCode}');
    debugPrint('🔐 → Response Body Length: ${response.body.length} chars');

    if (response.statusCode != 401) {
      debugPrint('🔐 → Not a 401 response, not a token error');
      return false;
    }

    try {
      final Map<String, dynamic> json = jsonDecode(response.body);
      debugPrint('🔐 → Parsed 401 response JSON');
      debugPrint('🔐 → JSON keys: ${json.keys.join(', ')}');

      final code = json['code'] as String?;
      final detail = json['detail'] as String?;
      final message = json['message'] as String?;

      debugPrint('🔐 → Code: ${code ?? 'null'}');
      debugPrint('🔐 → Detail: ${detail ?? 'null'}');
      debugPrint('🔐 → Message: ${message ?? 'null'}');

      // Check for token expiration indicators based on Prbal API patterns
      final isTokenExpired = code == 'token_not_valid' ||
          (detail != null &&
              (detail.contains('token not valid') ||
                  detail.contains('Token is expired') ||
                  detail.contains('Token is invalid') ||
                  detail.contains('token_not_valid'))) ||
          (message != null &&
              (message.contains('token') &&
                  (message.contains('expired') ||
                      message.contains('invalid') ||
                      message.contains('not valid'))));

      debugPrint('🔐 → Is Token Expired: $isTokenExpired');

      if (isTokenExpired) {
        debugPrint('🔐 → TOKEN EXPIRATION DETECTED! Will attempt refresh...');
      } else {
        debugPrint(
            '🔐 → 401 is not due to token expiration (permissions, etc.)');
      }

      return isTokenExpired;
    } catch (e) {
      debugPrint('🔐 → Error parsing 401 response: $e');
      debugPrint('🔐 → Raw response body: ${response.body}');
      debugPrint('🔐 → Assuming not a token error to be safe');
      return false; // If we can't parse, assume it's not a token error
    }
  }

  /// Attempt to refresh token and retry request
  Future<ApiResponse<T>> _handleTokenRefreshAndRetry<T>(
    Future<http.Response> Function() originalRequest,
    T Function(dynamic)? fromJson,
  ) async {
    debugPrint('🔄 API Service: Attempting token refresh due to expired token');

    if (_ref == null) {
      debugPrint('❌ No Riverpod ref available for token refresh');
      return ApiResponse.error(
        message: 'Token expired and no refresh mechanism available',
        statusCode: 401,
      );
    }

    try {
      // Import the authentication provider here to avoid circular dependencies
      final authNotifier = _ref.read(authenticationStateProvider.notifier);

      // Attempt to refresh the token
      final refreshSuccess = await authNotifier.refreshAccessToken();

      if (refreshSuccess) {
        debugPrint('✅ Token refresh successful, retrying original request');

        // Retry the original request with the new token
        final retryResponse = await originalRequest();
        return _parseResponse<T>(retryResponse, fromJson);
      } else {
        debugPrint('❌ Token refresh failed, redirecting to splash screen');

        // Clear authentication and redirect to splash screen
        await authNotifier.logout();

        return ApiResponse.error(
          message: 'Session expired. Please login again.',
          statusCode: 401,
        );
      }
    } catch (e) {
      debugPrint('❌ Error during token refresh process: $e');

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
      // Make the initial request
      final response = await request();

      // Check if token is expired
      if (_isTokenExpiredError(response)) {
        debugPrint('🔄 Token expired, attempting refresh and retry');
        return await _handleTokenRefreshAndRetry<T>(request, fromJson);
      }

      // Parse and return normal response
      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      debugPrint('❌ Request error: $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  /// Convert relative URL to absolute URL by prepending base domain
  ///
  /// This utility method handles converting relative URLs (starting with /)
  /// to absolute URLs by prepending the base domain from the API service.
  ///
  /// Examples:
  /// - `/media/profile_pictures/image.jpg` -> `https://domain.com/media/profile_pictures/image.jpg`
  /// - `https://example.com/image.jpg` -> `https://example.com/image.jpg` (unchanged)
  static String convertToAbsoluteUrl(String url) {
    // If URL already absolute (contains protocol), return as-is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      debugPrint('🔗 ApiService: URL is already absolute: $url');
      return url;
    }

    // If URL starts with /, prepend base domain (remove /api/v1 suffix)
    if (url.startsWith('/')) {
      final baseDomain = _baseUrl.replaceAll('/api/v1', '');
      final absoluteUrl = '$baseDomain$url';

      debugPrint('🔗 ApiService: Converting relative URL to absolute');
      debugPrint('🔗 Original URL: $url');
      debugPrint('🔗 Absolute URL: $absoluteUrl');

      return absoluteUrl;
    }

    // For other cases, return as-is
    debugPrint('🔗 ApiService: URL format unknown, returning as-is: $url');
    return url;
  }

  /// Analyze endpoint type for better debugging and logging
  /// Provides insights about the API endpoint being called
  void _analyzeEndpointType(String endpoint) {
    debugPrint('🌐 → 🔍 ENDPOINT ANALYSIS:');

    if (endpoint.contains('/services/services/')) {
      debugPrint('🌐   → Type: SERVICES API - Service management operations');
      if (endpoint.contains('/nearby/')) {
        debugPrint('🌐   → Subtype: Location-based service discovery');
      } else if (endpoint.contains('/trending/')) {
        debugPrint('🌐   → Subtype: Trending services analytics');
      } else if (endpoint.contains('/admin/')) {
        debugPrint('🌐   → Subtype: Admin view (requires admin permissions)');
      } else if (endpoint.contains('/matching_requests/')) {
        debugPrint('🌐   → Subtype: Provider matching system');
      }
    } else if (endpoint.contains('/services/requests/')) {
      debugPrint('🌐   → Type: REQUESTS API - Service request management');
      if (endpoint.contains('/my_requests/')) {
        debugPrint('🌐   → Subtype: User-specific requests (customer only)');
      } else if (endpoint.contains('/admin/')) {
        debugPrint('🌐   → Subtype: Admin view (requires admin permissions)');
      } else if (endpoint.contains('/recommended_providers/')) {
        debugPrint('🌐   → Subtype: Provider recommendation system');
      }
    } else if (endpoint.contains('/services/categories/')) {
      debugPrint('🌐   → Type: CATEGORIES API - Category management');
      if (endpoint.contains('/statistics/')) {
        debugPrint('🌐   → Subtype: Category analytics (admin only)');
      }
    } else if (endpoint.contains('/services/subcategories/')) {
      debugPrint('🌐   → Type: SUBCATEGORIES API - Subcategory management');
    } else if (endpoint.contains('/ai_suggestions/')) {
      debugPrint(
          '🌐   → Type: AI SUGGESTIONS API - ML-powered recommendations');
      if (endpoint.contains('/feedback/')) {
        debugPrint('🌐   → Subtype: AI feedback and analytics');
      } else if (endpoint.contains('/generate_service_suggestions/')) {
        debugPrint('🌐   → Subtype: Service recommendation generation');
      } else if (endpoint.contains('/suggest_bid_amount/')) {
        debugPrint('🌐   → Subtype: Bid amount optimization');
      } else if (endpoint.contains('/suggest_bid_message/')) {
        debugPrint('🌐   → Subtype: Bid message generation');
      }
    } else if (endpoint.contains('/auth/')) {
      debugPrint('🌐   → Type: AUTHENTICATION API - User auth operations');
    } else if (endpoint.contains('/users/')) {
      debugPrint('🌐   → Type: USER MANAGEMENT API - User profiles');
    } else if (endpoint.contains('/health/')) {
      debugPrint('🌐   → Type: HEALTH API - System health monitoring');
    } else {
      debugPrint('🌐   → Type: UNKNOWN/CUSTOM ENDPOINT');
    }

    // Analyze URL structure for REST patterns
    final pathSegments =
        endpoint.split('/').where((s) => s.isNotEmpty).toList();
    debugPrint(
        '🌐   → Path Segments: ${pathSegments.length} (${pathSegments.join(' → ')})');

    // Detect UUID patterns in URLs
    final uuidPattern =
        RegExp(r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}');
    if (uuidPattern.hasMatch(endpoint)) {
      debugPrint('🌐   → Contains UUID: Resource-specific operation detected');
    }
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
  ///
  /// 🔍 GET REQUEST ANALYSIS:
  /// - Used for data retrieval operations (read-only)
  /// - Supports query parameters for filtering and pagination
  /// - Automatic token refresh for authenticated requests
  /// - Comprehensive error handling and logging
  ///
  /// 📊 COMMON ENDPOINTS:
  /// - /services/services/ (List services with filters)
  /// - /services/categories/ (Get categories)
  /// - /ai_suggestions/suggestions/ (Get AI suggestions)
  /// - /services/requests/ (List service requests)
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    final startTime = DateTime.now();
    debugPrint('🌐 ApiService.get: ================================');
    debugPrint('🌐 ApiService.get: STARTING GET REQUEST');
    debugPrint('🌐 ApiService.get: ================================');
    debugPrint('🌐 → 📍 Endpoint: $endpoint');
    debugPrint(
        '🌐 → 🔐 Authentication: ${token != null ? 'AUTHENTICATED' : 'PUBLIC'}');
    debugPrint(
        '🌐 → 📋 Query Parameters: ${queryParams?.isNotEmpty == true ? queryParams : 'NONE'}');
    debugPrint('🌐 → ⏰ Request Time: ${startTime.toIso8601String()}');

    // Analyze endpoint type for better debugging
    _analyzeEndpointType(endpoint);

    // Log query parameters analysis
    if (queryParams?.isNotEmpty == true) {
      debugPrint('🌐 → 🔍 QUERY ANALYSIS:');
      queryParams!.forEach((key, value) {
        debugPrint('🌐   → $key: $value');
      });
      debugPrint('🌐   → Total Parameters: ${queryParams.length}');

      // Detect common parameter patterns
      if (queryParams.containsKey('page')) {
        debugPrint(
            '🌐   → 📄 PAGINATION DETECTED: Page ${queryParams['page']}');
      }
      if (queryParams.containsKey('search')) {
        debugPrint('🌐   → 🔎 SEARCH QUERY: "${queryParams['search']}"');
      }
      if (queryParams.containsKey('category')) {
        debugPrint('🌐   → 🗂️ CATEGORY FILTER: ${queryParams['category']}');
      }
      if (queryParams.containsKey('status')) {
        debugPrint('🌐   → 📊 STATUS FILTER: ${queryParams['status']}');
      }
    }

    // Use token refresh wrapper for authenticated requests
    if (token != null) {
      return await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');
          final finalUri = queryParams != null
              ? uri.replace(queryParameters: queryParams)
              : uri;

          debugPrint('📤 GET URL: $finalUri');
          debugPrint('📤 Headers: ${_getAuthHeaders(token)}');

          final response = await _client
              .get(finalUri, headers: _getAuthHeaders(token))
              .timeout(timeout);

          final duration = DateTime.now().difference(startTime).inMilliseconds;
          debugPrint('📥 GET Response (${duration}ms): ${response.statusCode}');
          debugPrint('📥 Response Body: ${response.body}');

          return response;
        },
        fromJson,
      );
    }

    // For non-authenticated requests, use original logic
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final finalUri =
          queryParams != null ? uri.replace(queryParameters: queryParams) : uri;

      debugPrint('📤 GET URL: $finalUri');
      debugPrint('📤 Headers: ${_getAuthHeaders(token)}');

      final response = await _client
          .get(finalUri, headers: _getAuthHeaders(token))
          .timeout(timeout);

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('📥 GET Response (${duration}ms): ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('❌ GET Error (${duration}ms): $e');
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
    final startTime = DateTime.now();
    debugPrint('🌐 API POST Request: $endpoint');

    // Use token refresh wrapper for authenticated requests
    if (token != null) {
      return await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');

          debugPrint('📤 POST URL: $uri');
          debugPrint('📤 Headers: ${_getAuthHeaders(token)}');
          debugPrint('📤 Body: ${body != null ? jsonEncode(body) : 'null'}');

          final response = await _client
              .post(
                uri,
                headers: _getAuthHeaders(token),
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);

          final duration = DateTime.now().difference(startTime).inMilliseconds;
          debugPrint(
              '📥 POST Response (${duration}ms): ${response.statusCode}');
          debugPrint('📥 Response Body: ${response.body}');

          return response;
        },
        fromJson,
      );
    }

    // For non-authenticated requests, use original logic
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      debugPrint('📤 POST URL: $uri');
      debugPrint('📤 Headers: ${_getAuthHeaders(token)}');
      debugPrint('📤 Body: ${body != null ? jsonEncode(body) : 'null'}');

      final response = await _client
          .post(
            uri,
            headers: _getAuthHeaders(token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('📥 POST Response (${duration}ms): ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('❌ POST Error (${duration}ms): $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
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
    final startTime = DateTime.now();
    debugPrint('🌐 API PUT Request: $endpoint');

    // Use token refresh wrapper for authenticated requests
    if (token != null) {
      return await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');

          debugPrint('📤 PUT URL: $uri');
          debugPrint('📤 Headers: ${_getAuthHeaders(token)}');
          debugPrint('📤 Body: ${body != null ? jsonEncode(body) : 'null'}');

          final response = await _client
              .put(
                uri,
                headers: _getAuthHeaders(token),
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);

          final duration = DateTime.now().difference(startTime).inMilliseconds;
          debugPrint('📥 PUT Response (${duration}ms): ${response.statusCode}');
          debugPrint('📥 Response Body: ${response.body}');

          return response;
        },
        fromJson,
      );
    }

    // For non-authenticated requests, use original logic
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      debugPrint('📤 PUT URL: $uri');
      debugPrint('📤 Headers: ${_getAuthHeaders(token)}');
      debugPrint('📤 Body: ${body != null ? jsonEncode(body) : 'null'}');

      final response = await _client
          .put(
            uri,
            headers: _getAuthHeaders(token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('📥 PUT Response (${duration}ms): ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('❌ PUT Error (${duration}ms): $e');
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
    final startTime = DateTime.now();
    debugPrint('🌐 API PATCH Request: $endpoint');

    // Use token refresh wrapper for authenticated requests
    if (token != null) {
      return await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');

          debugPrint('📤 PATCH URL: $uri');
          debugPrint('📤 Headers: ${_getAuthHeaders(token)}');
          debugPrint('📤 Body: ${body != null ? jsonEncode(body) : 'null'}');

          final response = await _client
              .patch(
                uri,
                headers: _getAuthHeaders(token),
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);

          final duration = DateTime.now().difference(startTime).inMilliseconds;
          debugPrint(
              '📥 PATCH Response (${duration}ms): ${response.statusCode}');
          debugPrint('📥 Response Body: ${response.body}');

          return response;
        },
        fromJson,
      );
    }

    // For non-authenticated requests, use original logic
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      debugPrint('📤 PATCH URL: $uri');
      debugPrint('📤 Headers: ${_getAuthHeaders(token)}');
      debugPrint('📤 Body: ${body != null ? jsonEncode(body) : 'null'}');

      final response = await _client
          .patch(
            uri,
            headers: _getAuthHeaders(token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('📥 PATCH Response (${duration}ms): ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('❌ PATCH Error (${duration}ms): $e');
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
    final startTime = DateTime.now();
    debugPrint('🌐 API DELETE Request: $endpoint');

    // Use token refresh wrapper for authenticated requests
    if (token != null) {
      return await _makeRequestWithTokenRefresh<T>(
        () async {
          final uri = Uri.parse('$baseUrl$endpoint');

          debugPrint('📤 DELETE URL: $uri');
          debugPrint('📤 Headers: ${_getAuthHeaders(token)}');

          final response = await _client
              .delete(uri, headers: _getAuthHeaders(token))
              .timeout(timeout);

          final duration = DateTime.now().difference(startTime).inMilliseconds;
          debugPrint(
              '📥 DELETE Response (${duration}ms): ${response.statusCode}');
          debugPrint('📥 Response Body: ${response.body}');

          return response;
        },
        fromJson,
      );
    }

    // For non-authenticated requests, use original logic
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      debugPrint('📤 DELETE URL: $uri');
      debugPrint('📤 Headers: ${_getAuthHeaders(token)}');

      final response = await _client
          .delete(uri, headers: _getAuthHeaders(token))
          .timeout(timeout);

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('📥 DELETE Response (${duration}ms): ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('❌ DELETE Error (${duration}ms): $e');
      return ApiResponse.error(
        message: 'Network error: $e',
        statusCode: 500,
      );
    }
  }

  /// Upload file using multipart form data
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint, {
    required File file,
    required String fieldName,
    Map<String, String>? fields,
    String? token,
    T Function(dynamic)? fromJson,
  }) async {
    final startTime = DateTime.now();
    debugPrint('🌐 API File Upload: $endpoint');

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add authorization header
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add form fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add file
      final multipartFile = await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        contentType: MediaType('image', 'jpeg'), // Default content type
      );
      request.files.add(multipartFile);

      debugPrint('📤 Upload URL: $uri');
      debugPrint('📤 File: ${file.path}');
      debugPrint('📤 Fields: $fields');

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('📥 Upload Response (${duration}ms): ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      return _parseResponse<T>(response, fromJson);
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('❌ Upload Error (${duration}ms): $e');
      return ApiResponse.error(
        message: 'Upload error: $e',
        statusCode: 500,
      );
    }
  }

  /// Parse HTTP response into ApiResponse
  ///
  /// 🔍 RESPONSE PARSING ANALYSIS:
  /// - Handles standardized Prbal API format: {message, data, time, statusCode}
  /// - Supports Django REST framework responses
  /// - Comprehensive error handling and debugging
  /// - JSON and non-JSON response support
  ApiResponse<T> _parseResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    debugPrint('🌐 → 📋 RESPONSE PARSING ANALYSIS:');
    debugPrint(
        '🌐   → Status Code: ${response.statusCode} (${_getStatusCodeCategory(response.statusCode)})');
    debugPrint(
        '🌐   → Content Type: ${response.headers['content-type'] ?? 'unknown'}');
    debugPrint('🌐   → Content Length: ${response.body.length} bytes');
    debugPrint('🌐   → Has Custom Parser: ${fromJson != null}');

    try {
      final Map<String, dynamic> json = jsonDecode(response.body);
      debugPrint('🌐   → JSON Parsing: ✅ SUCCESS');
      debugPrint('🌐   → JSON Keys: ${json.keys.join(', ')}');

      // Analyze response structure
      _analyzeResponseStructure(json);

      // Handle standardized Prbal API response format
      if (json.containsKey('message') || json.containsKey('data')) {
        debugPrint('🌐   → Format: PRBAL STANDARDIZED API RESPONSE');
        debugPrint('🌐   → Message: "${json['message'] ?? 'N/A'}"');
        debugPrint('🌐   → Has Data: ${json['data'] != null}');
        debugPrint('🌐   → Timestamp: ${json['time'] ?? 'N/A'}');
        debugPrint(
            '🌐   → Status Code in Body: ${json['statusCode'] ?? 'N/A'}');

        return ApiResponse.fromJson(json, fromJson);
      }

      // Handle Django REST framework response format
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('🌐   → Format: DJANGO REST FRAMEWORK SUCCESS RESPONSE');

        T? data;
        if (fromJson != null) {
          try {
            data = fromJson(json);
            debugPrint('🌐   → Data Parsing: ✅ SUCCESS');
          } catch (parseError) {
            debugPrint('🌐   → Data Parsing: ❌ ERROR - $parseError');
            debugPrint('🌐   → Raw JSON for debugging: $json');
          }
        }

        return ApiResponse.success(
          data: data as T,
          message: 'Success',
          statusCode: response.statusCode,
        );
      } else {
        debugPrint('🌐   → Format: ERROR RESPONSE');

        // Handle error response with detailed analysis
        final message = json['detail'] ??
            json['message'] ??
            json['error'] ??
            'Unknown error';
        debugPrint('🌐   → Error Message: "$message"');

        // Analyze error structure
        if (json.containsKey('errors')) {
          debugPrint('🌐   → Has Validation Errors: ${json['errors']}');
        }
        if (json.containsKey('code')) {
          debugPrint('🌐   → Error Code: ${json['code']}');
        }

        return ApiResponse.error(
          message: message,
          statusCode: response.statusCode,
          errors: json,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('🌐   → JSON Parsing: ❌ FAILED');
      debugPrint('🌐   → Parse Error: $e');
      debugPrint(
          '🌐   → Response Body (first 200 chars): ${response.body.length > 200 ? '${response.body.substring(0, 200)}...' : response.body}');
      debugPrint(
          '🌐   → Stack Trace (first 3 lines): ${stackTrace.toString().split('\n').take(3).join('\n')}');

      // Analyze response content type for better error messages
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('text/html')) {
        debugPrint('🌐   → Content Type: HTML (possibly error page)');
      } else if (contentType.contains('text/plain')) {
        debugPrint('🌐   → Content Type: Plain text');
      } else {
        debugPrint('🌐   → Content Type: Unknown or binary');
      }

      // Handle non-JSON responses
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('🌐   → Fallback: Treating as successful text response');
        return ApiResponse.success(
          data: response.body as T,
          message: 'Success (non-JSON response)',
          statusCode: response.statusCode,
        );
      } else {
        debugPrint('🌐   → Fallback: Error response with parse failure');
        return ApiResponse.error(
          message: 'Failed to parse response: $e',
          statusCode: response.statusCode,
          debugInfo: {
            'parse_error': e.toString(),
            'response_body': response.body,
            'content_type': contentType,
          },
        );
      }
    }
  }

  /// Get human-readable status code category
  String _getStatusCodeCategory(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return 'SUCCESS';
    if (statusCode >= 300 && statusCode < 400) return 'REDIRECT';
    if (statusCode >= 400 && statusCode < 500) return 'CLIENT_ERROR';
    if (statusCode >= 500) return 'SERVER_ERROR';
    return 'UNKNOWN';
  }

  /// Analyze response structure for debugging
  void _analyzeResponseStructure(Map<String, dynamic> json) {
    debugPrint('🌐   → 🔍 RESPONSE STRUCTURE ANALYSIS:');

    // Check for pagination
    if (json.containsKey('count') && json.containsKey('results')) {
      final count = json['count'];
      final results = json['results'];
      debugPrint('🌐     → PAGINATED RESPONSE: $count total items');
      debugPrint(
          '🌐     → Current Page Results: ${results is List ? results.length : 'unknown'}');
      debugPrint('🌐     → Has Next: ${json['next'] != null}');
      debugPrint('🌐     → Has Previous: ${json['previous'] != null}');
    }

    // Check for data array
    if (json.containsKey('data') && json['data'] is List) {
      final dataList = json['data'] as List;
      debugPrint('🌐     → DATA ARRAY: ${dataList.length} items');
    }

    // Check for nested objects
    if (json.containsKey('data') && json['data'] is Map) {
      final dataMap = json['data'] as Map<String, dynamic>;
      debugPrint('🌐     → DATA OBJECT: ${dataMap.keys.join(', ')}');
    }

    // Check for error indicators
    if (json.containsKey('errors') || json.containsKey('error')) {
      debugPrint('🌐     → ERROR INDICATORS FOUND');
    }

    // Check for metadata
    final metadataKeys = ['timestamp', 'time', 'version', 'request_id'];
    final foundMetadata =
        metadataKeys.where((key) => json.containsKey(key)).toList();
    if (foundMetadata.isNotEmpty) {
      debugPrint('🌐     → METADATA: ${foundMetadata.join(', ')}');
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}

/// Paginated response model for list endpoints
class PaginatedResponse<T> {
  final List<T> results;
  final int count;
  final String? next;
  final String? previous;
  final int page;
  final int pageSize;
  final int totalPages;

  const PaginatedResponse({
    required this.results,
    required this.count,
    this.next,
    this.previous,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final resultsList = json['results'] as List<dynamic>? ?? [];
    final results = resultsList
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    final count = json['count'] ?? json['total_count'] ?? 0;
    final pageSize = json['page_size'] ?? 10;
    final totalPages = json['total_pages'] ?? ((count / pageSize).ceil());
    final page = json['page'] ?? 1;

    return PaginatedResponse<T>(
      results: results,
      count: count,
      next: json['next'],
      previous: json['previous'],
      page: page,
      pageSize: pageSize,
      totalPages: totalPages,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'results': results.map((item) => toJsonT(item)).toList(),
      'count': count,
      'next': next,
      'previous': previous,
      'page': page,
      'page_size': pageSize,
      'total_pages': totalPages,
    };
  }
}
