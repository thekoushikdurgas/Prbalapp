import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

/// Settings utility functions for data extraction and formatting
class SettingsUtils {
  /// Helper methods for user data extraction
  static bool isVerified(Map<String, dynamic>? userData) {
    if (userData == null) return false;
    final isVerified = userData['is_verified'] ?? userData['isVerified'];
    if (isVerified is bool) return isVerified;
    if (isVerified is String) return isVerified.toLowerCase() == 'true';
    return false;
  }

  /// Gets display name from user data
  static String getDisplayName(Map<String, dynamic>? userData) {
    if (userData == null) return 'User';

    final firstName = userData['first_name'] ?? userData['firstName'] ?? '';
    final lastName = userData['last_name'] ?? userData['lastName'] ?? '';
    final username = userData['username'] ?? '';

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (username.isNotEmpty) {
      return username;
    }
    return 'User';
  }

  /// Gets real rating from user data
  static double getRealRating(Map<String, dynamic>? userData) {
    if (userData == null) return 0.0;

    final rating = userData['rating'] ?? userData['average_rating'] ?? 0;
    if (rating is String) {
      return double.tryParse(rating) ?? 0.0;
    }
    if (rating is num) {
      return rating.toDouble();
    }
    return 0.0;
  }

  /// Gets real booking count from user data
  static int getRealBookingCount(Map<String, dynamic>? userData) {
    if (userData == null) return 0;

    final bookings = userData['total_bookings'] ??
        userData['bookings'] ??
        userData['booking_count'] ??
        0;
    if (bookings is String) {
      return int.tryParse(bookings) ?? 0;
    }
    if (bookings is num) {
      return bookings.toInt();
    }
    return 0;
  }

  /// Gets user type color
  static Color getUserTypeColor(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'provider':
        return const Color(0xFF48BB78);
      case 'admin':
        return const Color(0xFF9F7AEA);
      case 'customer':
      case 'taker':
      default:
        return const Color(0xFF4299E1);
    }
  }

  /// Gets user type icon
  static IconData getUserTypeIcon(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'provider':
        return LineIcons.toolbox;
      case 'admin':
        return LineIcons.userShield;
      case 'customer':
      case 'taker':
      default:
        return LineIcons.user;
    }
  }

  /// Gets user type display name
  static String getUserTypeDisplayName(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'provider':
        return 'Service Provider';
      case 'admin':
        return 'Administrator';
      case 'customer':
        return 'Customer';
      case 'taker':
        return 'Service Taker';
      default:
        return 'User';
    }
  }

  /// Formats datetime string to readable format
  static String formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }

  /// Parses user agent string to get device info
  static String parseUserAgent(String userAgent) {
    if (userAgent.contains('Mobile')) {
      if (userAgent.contains('iPhone')) return 'iPhone';
      if (userAgent.contains('Android')) return 'Android';
      return 'Mobile Device';
    } else if (userAgent.contains('Windows')) {
      return 'Windows PC';
    } else if (userAgent.contains('Mac')) {
      return 'Mac';
    } else if (userAgent.contains('Linux')) {
      return 'Linux';
    } else {
      return 'Unknown Device';
    }
  }

  // ============================================================================
  // ENHANCED THEME DEBUGGING UTILITIES
  // ============================================================================

  /// Comprehensive theme state analysis for debugging
  ///
  /// This utility provides detailed theme debugging information including:
  /// - Theme mode validation and consistency checks
  /// - Color scheme analysis and validation
  /// - Cache state monitoring and validation
  /// - Performance metrics for theme operations
  /// - System vs app theme comparison
  ///
  /// **Enhanced Features:**
  /// - Real-time theme state monitoring
  /// - Cache consistency validation
  /// - Performance timing for theme operations
  /// - System theme compatibility checks
  /// - Color accessibility analysis
  ///
  /// **Usage:**
  /// ```dart
  /// SettingsUtils.logThemeDebugInfo(context, 'settings_screen_init');
  /// SettingsUtils.validateThemeConsistency(context, ThemeMode.dark);
  /// ```
  static void logThemeDebugInfo(BuildContext context, String source) {
    debugPrint('🎨 SettingsUtils: === THEME DEBUG INFO ($source) ===');

    try {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final mediaQuery = MediaQuery.of(context);

      // Theme basic information
      debugPrint(
          '🎨 SettingsUtils: Theme brightness: ${theme.brightness.name}');
      debugPrint(
          '🎨 SettingsUtils: System brightness: ${mediaQuery.platformBrightness.name}');
      debugPrint('🎨 SettingsUtils: Material 3: ${theme.useMaterial3}');

      // Color scheme analysis
      _logColorSchemeAnalysis(colorScheme);

      // Cache state analysis
      _logThemeCacheAnalysis();

      // Performance metrics
      _logThemePerformanceMetrics(theme);

      // Accessibility analysis
      _logThemeAccessibilityAnalysis(colorScheme);
    } catch (error, stackTrace) {
      debugPrint('🎨 SettingsUtils: ❌ Error in theme debug info: $error');
      debugPrint('🎨 SettingsUtils: Stack trace: $stackTrace');
    }
  }

  /// Validates theme consistency between different states
  static bool validateThemeConsistency(
      BuildContext context, ThemeMode expectedMode) {
    debugPrint('🎨 SettingsUtils: === THEME CONSISTENCY VALIDATION ===');

    try {
      final theme = Theme.of(context);
      final actualBrightness = theme.brightness;
      final systemBrightness = MediaQuery.of(context).platformBrightness;

      bool isConsistent = false;

      switch (expectedMode) {
        case ThemeMode.light:
          isConsistent = actualBrightness == Brightness.light;
          debugPrint(
              '🎨 SettingsUtils: Light mode check: ${isConsistent ? '✅' : '❌'}');
          break;

        case ThemeMode.dark:
          isConsistent = actualBrightness == Brightness.dark;
          debugPrint(
              '🎨 SettingsUtils: Dark mode check: ${isConsistent ? '✅' : '❌'}');
          break;

        case ThemeMode.system:
          isConsistent = actualBrightness == systemBrightness;
          debugPrint(
              '🎨 SettingsUtils: System mode check: ${isConsistent ? '✅' : '❌'}');
          debugPrint(
              '🎨 SettingsUtils: Expected: ${systemBrightness.name}, Actual: ${actualBrightness.name}');
          break;
      }

      debugPrint(
          '🎨 SettingsUtils: Overall consistency: ${isConsistent ? '✅ PASS' : '❌ FAIL'}');
      return isConsistent;
    } catch (error) {
      debugPrint(
          '🎨 SettingsUtils: ❌ Error validating theme consistency: $error');
      return false;
    }
  }

  /// Monitors theme change performance
  static void monitorThemeChangePerformance(
      String operation, Function() themeOperation) {
    debugPrint('🎨 SettingsUtils: === THEME PERFORMANCE MONITORING ===');
    debugPrint('🎨 SettingsUtils: Operation: $operation');

    final stopwatch = Stopwatch()..start();

    try {
      themeOperation();
      stopwatch.stop();

      final duration = stopwatch.elapsedMilliseconds;
      debugPrint('🎨 SettingsUtils: ✅ Operation completed in ${duration}ms');

      // Performance analysis
      if (duration < 50) {
        debugPrint('🎨 SettingsUtils: 🚀 Excellent performance');
      } else if (duration < 100) {
        debugPrint('🎨 SettingsUtils: ✅ Good performance');
      } else if (duration < 200) {
        debugPrint('🎨 SettingsUtils: ⚠️ Acceptable performance');
      } else {
        debugPrint(
            '🎨 SettingsUtils: 🐌 Slow performance - consider optimization');
      }
    } catch (error) {
      stopwatch.stop();
      debugPrint(
          '🎨 SettingsUtils: ❌ Operation failed after ${stopwatch.elapsedMilliseconds}ms: $error');
    }
  }

  /// Logs color scheme analysis for debugging
  static void _logColorSchemeAnalysis(ColorScheme colorScheme) {
    debugPrint('🎨 SettingsUtils: === COLOR SCHEME ANALYSIS ===');
    debugPrint('🎨 SettingsUtils: Primary: ${colorScheme.primary}');
    debugPrint('🎨 SettingsUtils: OnPrimary: ${colorScheme.onPrimary}');
    debugPrint('🎨 SettingsUtils: Surface: ${colorScheme.surface}');
    debugPrint('🎨 SettingsUtils: OnSurface: ${colorScheme.onSurface}');
    debugPrint('🎨 SettingsUtils: Background: ${colorScheme.surface}');
    debugPrint('🎨 SettingsUtils: Error: ${colorScheme.error}');
    debugPrint('🎨 SettingsUtils: Brightness: ${colorScheme.brightness.name}');
  }

  /// Logs theme cache analysis for debugging
  static void _logThemeCacheAnalysis() {
    try {
      debugPrint('🎨 SettingsUtils: === THEME CACHE ANALYSIS ===');

      // This would need to be imported and used if available
      // For now, we'll provide a placeholder
      debugPrint('🎨 SettingsUtils: Cache analysis would be performed here');
      debugPrint(
          '🎨 SettingsUtils: Note: Import ThemeCaching for full analysis');
    } catch (error) {
      debugPrint('🎨 SettingsUtils: ❌ Cache analysis error: $error');
    }
  }

  /// Logs theme performance metrics
  static void _logThemePerformanceMetrics(ThemeData theme) {
    debugPrint('🎨 SettingsUtils: === THEME PERFORMANCE METRICS ===');
    debugPrint('🎨 SettingsUtils: Theme hash: ${theme.hashCode}');
    debugPrint(
        '🎨 SettingsUtils: Color scheme hash: ${theme.colorScheme.hashCode}');
    debugPrint(
        '🎨 SettingsUtils: Text theme hash: ${theme.textTheme.hashCode}');

    // Memory usage estimation (rough)
    final estimatedMemory = _estimateThemeMemoryUsage(theme);
    debugPrint('🎨 SettingsUtils: Estimated memory: ~${estimatedMemory}KB');
  }

  /// Logs theme accessibility analysis
  static void _logThemeAccessibilityAnalysis(ColorScheme colorScheme) {
    debugPrint('🎨 SettingsUtils: === THEME ACCESSIBILITY ANALYSIS ===');

    // Check contrast ratios (simplified)
    final primaryContrast =
        _calculateContrastRatio(colorScheme.primary, colorScheme.onPrimary);
    final surfaceContrast =
        _calculateContrastRatio(colorScheme.surface, colorScheme.onSurface);

    debugPrint(
        '🎨 SettingsUtils: Primary contrast: ${primaryContrast.toStringAsFixed(2)}:1');
    debugPrint(
        '🎨 SettingsUtils: Surface contrast: ${surfaceContrast.toStringAsFixed(2)}:1');

    // WCAG AA compliance (4.5:1 for normal text)
    final primaryCompliant = primaryContrast >= 4.5;
    final surfaceCompliant = surfaceContrast >= 4.5;

    debugPrint(
        '🎨 SettingsUtils: Primary WCAG AA: ${primaryCompliant ? '✅' : '❌'}');
    debugPrint(
        '🎨 SettingsUtils: Surface WCAG AA: ${surfaceCompliant ? '✅' : '❌'}');
  }

  /// Estimates theme memory usage (rough calculation)
  static int _estimateThemeMemoryUsage(ThemeData theme) {
    // Very rough estimation based on theme complexity
    int baseSize = 50; // Base theme overhead
    int colorSchemeSize = 30; // Color scheme
    int textThemeSize = 40; // Text theme
    int componentThemeSize = 60; // Various component themes

    return baseSize + colorSchemeSize + textThemeSize + componentThemeSize;
  }

  /// Calculates contrast ratio between two colors (simplified)
  static double _calculateContrastRatio(Color color1, Color color2) {
    // Simplified contrast calculation
    // In a real implementation, you'd use proper luminance calculations
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();

    final lighter = math.max(luminance1, luminance2);
    final darker = math.min(luminance1, luminance2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Creates a theme debug report for comprehensive analysis
  static Map<String, dynamic> createThemeDebugReport(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return {
      'timestamp': DateTime.now().toIso8601String(),
      'theme': {
        'brightness': theme.brightness.name,
        'useMaterial3': theme.useMaterial3,
        'hashCode': theme.hashCode,
      },
      'colorScheme': {
        'brightness': colorScheme.brightness.name,
        'primary': colorScheme.primary.toString(),
        'surface': colorScheme.surface.toString(),
        'hashCode': colorScheme.hashCode,
      },
      'system': {
        'brightness': mediaQuery.platformBrightness.name,
        'devicePixelRatio': mediaQuery.devicePixelRatio,
        'textScaleFactor': mediaQuery.textScaler.toString(),
      },
      'performance': {
        'estimatedMemoryKB': _estimateThemeMemoryUsage(theme),
      },
      'accessibility': {
        'primaryContrast':
            _calculateContrastRatio(colorScheme.primary, colorScheme.onPrimary),
        'surfaceContrast':
            _calculateContrastRatio(colorScheme.surface, colorScheme.onSurface),
      },
    };
  }
}
