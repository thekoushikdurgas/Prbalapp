import 'package:flutter/material.dart';
import 'package:prbal/utils/debug_logger.dart';
import 'package:prbal/models/core/api_models.dart';

/// Centralized error handling system for the Prbal application
///
/// Features:
/// - Standardized error types and handling
/// - Automatic error logging
/// - User-friendly error messages
/// - Recovery suggestions
/// - Performance tracking
class ErrorHandler {
  const ErrorHandler._();

  // =================== ERROR TYPES ===================

  /// Network-related errors
  static const String networkError = 'NETWORK_ERROR';
  static const String timeoutError = 'TIMEOUT_ERROR';
  static const String connectionError = 'CONNECTION_ERROR';

  /// Authentication errors
  static const String authError = 'AUTH_ERROR';
  static const String tokenExpiredError = 'TOKEN_EXPIRED';
  static const String permissionError = 'PERMISSION_ERROR';

  /// API errors
  static const String apiError = 'API_ERROR';
  static const String validationError = 'VALIDATION_ERROR';
  static const String serverError = 'SERVER_ERROR';

  /// Local storage errors
  static const String storageError = 'STORAGE_ERROR';
  static const String cacheError = 'CACHE_ERROR';

  /// Business logic errors
  static const String businessError = 'BUSINESS_ERROR';
  static const String dataError = 'DATA_ERROR';

  /// Generic errors
  static const String unknownError = 'UNKNOWN_ERROR';
  static const String parseError = 'PARSE_ERROR';

  // =================== ERROR HANDLING METHODS ===================

  /// Handle network errors
  static AppError handleNetworkError(dynamic error, [StackTrace? stackTrace]) {
    DebugLogger.error('Network error: $error');

    final errorType = _classifyNetworkError(error);
    final userMessage = _getUserMessage(errorType);
    final recoveryAction = _getRecoveryAction(errorType);

    _logError(errorType, error, stackTrace);

    return AppError(
      type: errorType,
      message: error.toString(),
      userMessage: userMessage,
      recoveryAction: recoveryAction,
      timestamp: DateTime.now(),
      stackTrace: stackTrace,
    );
  }

  /// Handle authentication errors
  static AppError handleAuthError(dynamic error, [StackTrace? stackTrace]) {
    DebugLogger.auth('Authentication error: $error');

    final errorType = _classifyAuthError(error);
    final userMessage = _getUserMessage(errorType);
    final recoveryAction = _getRecoveryAction(errorType);

    _logError(errorType, error, stackTrace);

    return AppError(
      type: errorType,
      message: error.toString(),
      userMessage: userMessage,
      recoveryAction: recoveryAction,
      timestamp: DateTime.now(),
      stackTrace: stackTrace,
    );
  }

  /// Handle API errors
  static AppError handleApiError(ApiResponse response,
      [StackTrace? stackTrace]) {
    DebugLogger.api('API error: ${response.message}');

    final errorType = _classifyApiError(response);
    final userMessage = _getUserMessage(errorType);
    final recoveryAction = _getRecoveryAction(errorType);

    _logError(errorType, response.message, stackTrace);

    return AppError(
      type: errorType,
      message: response.message,
      userMessage: userMessage,
      recoveryAction: recoveryAction,
      timestamp: DateTime.now(),
      statusCode: response.statusCode,
      stackTrace: stackTrace,
    );
  }

  /// Handle storage errors
  static AppError handleStorageError(dynamic error, [StackTrace? stackTrace]) {
    DebugLogger.storage('Storage error: $error');

    const errorType = storageError;
    final userMessage = _getUserMessage(errorType);
    final recoveryAction = _getRecoveryAction(errorType);

    _logError(errorType, error, stackTrace);

    return AppError(
      type: errorType,
      message: error.toString(),
      userMessage: userMessage,
      recoveryAction: recoveryAction,
      timestamp: DateTime.now(),
      stackTrace: stackTrace,
    );
  }

  /// Handle generic errors
  static AppError handleGenericError(dynamic error, [StackTrace? stackTrace]) {
    DebugLogger.error('Generic error: $error');

    const errorType = unknownError;
    final userMessage = _getUserMessage(errorType);
    final recoveryAction = _getRecoveryAction(errorType);

    _logError(errorType, error, stackTrace);

    return AppError(
      type: errorType,
      message: error.toString(),
      userMessage: userMessage,
      recoveryAction: recoveryAction,
      timestamp: DateTime.now(),
      stackTrace: stackTrace,
    );
  }

  // =================== ERROR CLASSIFICATION ===================

  /// Classify network errors
  static String _classifyNetworkError(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('timeout')) return timeoutError;
    if (errorStr.contains('connection')) return connectionError;
    if (errorStr.contains('network')) return networkError;

    return networkError;
  }

  /// Classify authentication errors
  static String _classifyAuthError(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('token') && errorStr.contains('expired')) {
      return tokenExpiredError;
    }
    if (errorStr.contains('permission') || errorStr.contains('unauthorized')) {
      return permissionError;
    }

    return authError;
  }

  /// Classify API errors
  static String _classifyApiError(ApiResponse response) {
    if (response.statusCode >= 500) return serverError;
    if (response.statusCode == 401) return authError;
    if (response.statusCode == 403) return permissionError;
    if (response.statusCode == 422) return validationError;
    if (response.statusCode >= 400) return apiError;

    return unknownError;
  }

  // =================== USER MESSAGES ===================

  /// Get user-friendly error messages
  static String _getUserMessage(String errorType) {
    switch (errorType) {
      case networkError:
        return 'Unable to connect to the server. Please check your internet connection.';
      case timeoutError:
        return 'The request took too long to complete. Please try again.';
      case connectionError:
        return 'Connection failed. Please check your network and try again.';
      case authError:
        return 'Authentication failed. Please log in again.';
      case tokenExpiredError:
        return 'Your session has expired. Please log in again.';
      case permissionError:
        return 'You don\'t have permission to perform this action.';
      case apiError:
        return 'Server error occurred. Please try again later.';
      case validationError:
        return 'Please check your input and try again.';
      case serverError:
        return 'Server is temporarily unavailable. Please try again later.';
      case storageError:
        return 'Unable to save data. Please check your device storage.';
      case cacheError:
        return 'Cache error occurred. Data may be outdated.';
      case businessError:
        return 'Operation failed. Please review your request.';
      case dataError:
        return 'Data processing error. Please try again.';
      case parseError:
        return 'Unable to process server response. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  // =================== RECOVERY ACTIONS ===================

  /// Get recovery action suggestions
  static RecoveryAction? _getRecoveryAction(String errorType) {
    switch (errorType) {
      case networkError:
      case connectionError:
        return RecoveryAction(
          title: 'Check Connection',
          description: 'Verify your internet connection and try again',
          action: RecoveryActionType.retry,
        );
      case timeoutError:
        return RecoveryAction(
          title: 'Retry',
          description:
              'The request timed out. Try again with a stable connection',
          action: RecoveryActionType.retry,
        );
      case authError:
      case tokenExpiredError:
        return RecoveryAction(
          title: 'Log In',
          description: 'Your session has expired. Please log in again',
          action: RecoveryActionType.login,
        );
      case permissionError:
        return RecoveryAction(
          title: 'Contact Support',
          description: 'You need additional permissions for this action',
          action: RecoveryActionType.contactSupport,
        );
      case validationError:
        return RecoveryAction(
          title: 'Check Input',
          description: 'Please review and correct your input',
          action: RecoveryActionType.reviewInput,
        );
      case serverError:
        return RecoveryAction(
          title: 'Try Later',
          description:
              'Server is temporarily unavailable. Please try again later',
          action: RecoveryActionType.waitAndRetry,
        );
      case storageError:
        return RecoveryAction(
          title: 'Check Storage',
          description: 'Check available storage space on your device',
          action: RecoveryActionType.checkStorage,
        );
      default:
        return RecoveryAction(
          title: 'Retry',
          description: 'Please try the operation again',
          action: RecoveryActionType.retry,
        );
    }
  }

  // =================== LOGGING ===================

  /// Log error with context
  static void _logError(String type, dynamic error, StackTrace? stackTrace) {
    DebugLogger.error('Error Type: $type');
    DebugLogger.error('Error Details: $error');

    if (stackTrace != null) {
      final stackLines = stackTrace.toString().split('\n').take(5);
      DebugLogger.error('Stack Trace: ${stackLines.join('\n')}');
    }
  }

  // =================== ERROR DISPLAY ===================

  /// Show error to user with SnackBar
  static void showErrorSnackBar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.userMessage),
        action: error.recoveryAction != null
            ? SnackBarAction(
                label: error.recoveryAction!.title,
                onPressed: () =>
                    _executeRecoveryAction(context, error.recoveryAction!),
              )
            : null,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show error dialog
  static Future<void> showErrorDialog(
      BuildContext context, AppError error) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(error.userMessage),
            if (error.recoveryAction != null) ...[
              const SizedBox(height: 16),
              Text(
                'Suggestion: ${error.recoveryAction!.description}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (error.recoveryAction != null)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _executeRecoveryAction(context, error.recoveryAction!);
              },
              child: Text(error.recoveryAction!.title),
            ),
        ],
      ),
    );
  }

  /// Execute recovery action
  static void _executeRecoveryAction(
      BuildContext context, RecoveryAction action) {
    switch (action.action) {
      case RecoveryActionType.retry:
        // Trigger retry callback if provided
        break;
      case RecoveryActionType.login:
        // Navigate to login screen
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/welcome', (route) => false);
        break;
      case RecoveryActionType.contactSupport:
        // Open support contact
        break;
      case RecoveryActionType.reviewInput:
        // Focus on input validation
        break;
      case RecoveryActionType.waitAndRetry:
        // Show wait message and retry after delay
        break;
      case RecoveryActionType.checkStorage:
        // Show storage settings
        break;
    }
  }
}

// =================== ERROR MODELS ===================

/// Application error model
class AppError {
  final String type;
  final String message;
  final String userMessage;
  final RecoveryAction? recoveryAction;
  final DateTime timestamp;
  final int? statusCode;
  final StackTrace? stackTrace;

  const AppError({
    required this.type,
    required this.message,
    required this.userMessage,
    this.recoveryAction,
    required this.timestamp,
    this.statusCode,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppError(type: $type, message: $message, statusCode: $statusCode)';
  }
}

/// Recovery action model
class RecoveryAction {
  final String title;
  final String description;
  final RecoveryActionType action;
  final VoidCallback? callback;

  const RecoveryAction({
    required this.title,
    required this.description,
    required this.action,
    this.callback,
  });
}

/// Recovery action types
enum RecoveryActionType {
  retry,
  login,
  contactSupport,
  reviewInput,
  waitAndRetry,
  checkStorage,
}

// =================== ERROR HANDLING EXTENSIONS ===================

/// Extension for Future error handling
extension FutureErrorHandling<T> on Future<T> {
  /// Handle errors with standardized error handling
  Future<T> handleErrors({
    String? context,
    Function(AppError)? onError,
  }) async {
    try {
      return await this;
    } catch (error, stackTrace) {
      final appError = ErrorHandler.handleGenericError(error, stackTrace);

      if (onError != null) {
        onError(appError);
      } else {
        DebugLogger.error('Unhandled error in $context: $appError');
      }

      rethrow;
    }
  }
}

/// Extension for BuildContext error handling
extension ContextErrorHandling on BuildContext {
  /// Show error with standardized handling
  void showError(AppError error, {bool useDialog = false}) {
    if (useDialog) {
      ErrorHandler.showErrorDialog(this, error);
    } else {
      ErrorHandler.showErrorSnackBar(this, error);
    }
  }
}
