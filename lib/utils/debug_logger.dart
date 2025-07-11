import 'package:flutter/foundation.dart';

/// Centralized debug logger utility for the Prbal application
///
/// This utility provides:
/// - Conditional logging based on build mode
/// - Categorized logging with prefixes
/// - Performance-optimized logging
/// - Easy production control
class DebugLogger {
  static const bool _enableLogging = kDebugMode;

  // Log categories
  static const String _auth = '🔐';
  static const String _api = '🌐';
  static const String _ui = '🎨';
  static const String _navigation = '🧭';
  static const String _storage = '📦';
  static const String _health = '🏥';
  static const String _performance = '⚡';
  static const String _error = '❌';
  static const String _success = '✅';
  static const String _info = '📋';
  static const String _intro = '🎬';
  static const String _user = '👤';
  static const String _debug = '🔍';

  /// Log authentication-related messages
  static void auth(String message) {
    if (_enableLogging) {
      debugPrint('$_auth Auth: $message');
    }
  }

  /// Log API-related messages
  static void api(String message) {
    if (_enableLogging) {
      debugPrint('$_api API: $message');
    }
  }

  /// Log UI-related messages
  static void ui(String message) {
    if (_enableLogging) {
      debugPrint('$_ui UI: $message');
    }
  }

  /// Log navigation-related messages
  static void navigation(String message) {
    if (_enableLogging) {
      debugPrint('$_navigation Navigation: $message');
    }
  }

  /// Log storage-related messages
  static void storage(String message) {
    if (_enableLogging) {
      debugPrint('$_storage Storage: $message');
    }
  }

  /// Log health-related messages
  static void health(String message) {
    if (_enableLogging) {
      debugPrint('$_health Health: $message');
    }
  }

  /// Log performance-related messages
  static void performance(String message) {
    if (_enableLogging) {
      debugPrint('$_performance Performance: $message');
    }
  }

  /// Log error messages
  static void error(String message) {
    if (_enableLogging) {
      debugPrint('$_error Error: $message');
    }
  }

  /// Log success messages
  static void success(String message) {
    if (_enableLogging) {
      debugPrint('$_success Success: $message');
    }
  }

  /// Log general info messages
  static void info(String message) {
    if (_enableLogging) {
      debugPrint('$_info Info: $message');
    }
  }

  /// Log intro/onboarding messages
  static void intro(String message) {
    if (_enableLogging) {
      debugPrint('$_intro Intro: $message');
    }
  }

  /// Log user-related messages
  static void user(String message) {
    if (_enableLogging) {
      debugPrint('$_user User: $message');
    }
  }

  /// Log debug messages
  static void debug(String message) {
    if (_enableLogging) {
      debugPrint('$_debug Debug: $message');
    }
  }

  /// Log with custom prefix
  static void custom(String prefix, String message) {
    if (_enableLogging) {
      debugPrint('$prefix $message');
    }
  }

  /// Log method entry (for debugging complex flows)
  static void methodEntry(String className, String methodName,
      [Map<String, dynamic>? params]) {
    if (_enableLogging) {
      final paramStr = params != null ? ' with params: $params' : '';
      debugPrint('🔍 $className.$methodName() entered$paramStr');
    }
  }

  /// Log method exit (for debugging complex flows)
  static void methodExit(String className, String methodName,
      [dynamic result]) {
    if (_enableLogging) {
      final resultStr = result != null ? ' returning: $result' : '';
      debugPrint('🔍 $className.$methodName() exiting$resultStr');
    }
  }

  /// Log performance timing
  static void timing(String operation, Duration duration) {
    if (_enableLogging) {
      debugPrint('$_performance $operation took ${duration.inMilliseconds}ms');
    }
  }

  /// Log JSON data in a formatted way
  static void json(String label, Map<String, dynamic> data) {
    if (_enableLogging) {
      debugPrint('📊 $label: $data');
    }
  }
}

/// Performance timing utility
class PerformanceTimer {
  final String _operation;
  final DateTime _startTime;

  PerformanceTimer(this._operation) : _startTime = DateTime.now();

  void finish() {
    final duration = DateTime.now().difference(_startTime);
    DebugLogger.timing(_operation, duration);
  }
}
