import 'package:flutter/material.dart';

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
/// - User Management API: /api/v1/users/
/// - Booking API: /api/v1/bookings/
/// - Payment API: /api/v1/payments/
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

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      'statusCode': statusCode,
      'time': time.toIso8601String(),
      if (errors != null) 'errors': errors,
      if (debugInfo != null) '_debug': debugInfo,
    };
  }

  @override
  String toString() {
    return 'ApiResponse<$T>(success: $success, statusCode: $statusCode, message: "$message", hasData: ${data != null})';
  }
}
