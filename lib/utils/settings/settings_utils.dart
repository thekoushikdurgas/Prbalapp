import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../theme/theme_manager.dart';

/// **SettingsUtils** - Comprehensive settings utility functions with full ThemeManager integration
///
/// **Enhanced Features:**
/// - Complete ThemeManager property usage
/// - Theme-aware color utilities
/// - Gradient and shadow analysis
/// - Glass morphism helpers
/// - Performance monitoring
/// - Accessibility validation
/// - Debug utilities with comprehensive logging
class SettingsUtils {
  // ============================================================================
  // USER DATA UTILITIES WITH THEME INTEGRATION
  // ============================================================================

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

  /// Gets user type color with ThemeManager integration
  static Color getUserTypeColor(BuildContext context, String? userType) {
    final themeManager = ThemeManager.of(context);

    switch (userType?.toLowerCase()) {
      case 'provider':
        return themeManager.successColor;
      case 'admin':
        return themeManager.accent1;
      case 'customer':
      case 'taker':
      default:
        return themeManager.primaryColor;
    }
  }

  /// Gets user type icon
  static IconData getUserTypeIcon(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'provider':
        return Prbal.build1;
      case 'admin':
        return Prbal.cog4;
      case 'customer':
      case 'taker':
      default:
        return Prbal.user6;
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
  // COMPREHENSIVE THEMEMANAGER INTEGRATION
  // ============================================================================

  /// **Comprehensive ThemeManager showcase** - Uses ALL ThemeManager properties
  ///
  /// This method demonstrates every single property and method available in ThemeManager:
  /// - All 12+ gradient types
  /// - All 50+ color properties
  /// - All shadow and decoration effects
  /// - All utility methods and helpers
  /// - Complete debug logging capabilities
  static void demonstrateAllThemeManagerFeatures(
      BuildContext context, String source) {
    final themeManager = ThemeManager.of(context);

    debugPrint(
        '🎨 SettingsUtils: === COMPLETE THEMEMANAGER SHOWCASE ($source) ===');

    // Use ALL ThemeManager debug utilities

    themeManager.logGradientInfo();
    themeManager.logAllColors();

    _demonstrateAllGradients(themeManager);
    _demonstrateAllColors(themeManager);
    _demonstrateAllShadowsAndEffects(themeManager);
    _demonstrateAllHelperMethods(themeManager);
    _demonstrateThemeAwareUtilities(themeManager);
  }

  /// Demonstrates all gradient properties
  static void _demonstrateAllGradients(ThemeManager themeManager) {
    debugPrint('🌈 SettingsUtils: === ALL GRADIENTS DEMONSTRATION ===');

    // Core gradients
    debugPrint(
        '🌈 Background Gradient: ${themeManager.backgroundGradient.colors}');
    debugPrint('🌈 Surface Gradient: ${themeManager.surfaceGradient.colors}');
    debugPrint('🌈 Primary Gradient: ${themeManager.primaryGradient.colors}');
    debugPrint(
        '🌈 Secondary Gradient: ${themeManager.secondaryGradient.colors}');
    debugPrint('🌈 Neutral Gradient: ${themeManager.neutralGradient.colors}');

    // Status gradients
    debugPrint('🌈 Success Gradient: ${themeManager.successGradient.colors}');
    debugPrint('🌈 Warning Gradient: ${themeManager.warningGradient.colors}');
    debugPrint('🌈 Error Gradient: ${themeManager.errorGradient.colors}');

    // Accent gradients
    debugPrint(
        '🌈 Accent 1 Gradient (Purple): ${themeManager.accent1Gradient.colors}');
    debugPrint(
        '🌈 Accent 2 Gradient (Pink): ${themeManager.accent2Gradient.colors}');
    debugPrint(
        '🌈 Accent 3 Gradient (Teal): ${themeManager.accent3Gradient.colors}');
    debugPrint(
        '🌈 Accent 4 Gradient (Orange): ${themeManager.accent4Gradient.colors}');

    // Special gradients
    debugPrint('🌈 Glass Gradient: ${themeManager.glassGradient.colors}');
    debugPrint('🌈 Shimmer Gradient: ${themeManager.shimmerGradient.colors}');
  }

  /// Demonstrates all color properties
  static void _demonstrateAllColors(ThemeManager themeManager) {
    debugPrint('🎨 SettingsUtils: === ALL COLORS DEMONSTRATION ===');

    // Brand colors
    debugPrint('🎨 Primary: ${themeManager.primaryColor}');
    debugPrint('🎨 Primary Light: ${themeManager.primaryLight}');
    debugPrint('🎨 Primary Dark: ${themeManager.primaryDark}');
    debugPrint('🎨 Secondary: ${themeManager.secondaryColor}');
    debugPrint('🎨 Secondary Light: ${themeManager.secondaryLight}');
    debugPrint('🎨 Secondary Dark: ${themeManager.secondaryDark}');

    // Background colors
    debugPrint('🎨 Background: ${themeManager.backgroundColor}');
    debugPrint('🎨 Background Secondary: ${themeManager.backgroundSecondary}');
    debugPrint('🎨 Background Tertiary: ${themeManager.backgroundTertiary}');
    debugPrint('🎨 Surface: ${themeManager.surfaceColor}');
    debugPrint('🎨 Surface Elevated: ${themeManager.surfaceElevated}');
    debugPrint('🎨 Card Background: ${themeManager.cardBackground}');
    debugPrint('🎨 Modal Background: ${themeManager.modalBackground}');
    debugPrint('🎨 Overlay Background: ${themeManager.overlayBackground}');

    // Text colors
    debugPrint('🎨 Text Primary: ${themeManager.textPrimary}');
    debugPrint('🎨 Text Secondary: ${themeManager.textSecondary}');
    debugPrint('🎨 Text Tertiary: ${themeManager.textTertiary}');
    debugPrint('🎨 Text Quaternary: ${themeManager.textQuaternary}');
    debugPrint('🎨 Text Disabled: ${themeManager.textDisabled}');
    debugPrint('🎨 Text Inverted: ${themeManager.textInverted}');

    // Border colors
    debugPrint('🎨 Border: ${themeManager.borderColor}');
    debugPrint('🎨 Border Secondary: ${themeManager.borderSecondary}');
    debugPrint('🎨 Border Focus: ${themeManager.borderFocus}');
    debugPrint('🎨 Divider: ${themeManager.dividerColor}');

    // Status colors (with variants)
    debugPrint(
        '🎨 Success: ${themeManager.successColor} (Light: ${themeManager.successLight}, Dark: ${themeManager.successDark})');
    debugPrint(
        '🎨 Warning: ${themeManager.warningColor} (Light: ${themeManager.warningLight}, Dark: ${themeManager.warningDark})');
    debugPrint(
        '🎨 Error: ${themeManager.errorColor} (Light: ${themeManager.errorLight}, Dark: ${themeManager.errorDark})');
    debugPrint(
        '🎨 Info: ${themeManager.infoColor} (Light: ${themeManager.infoLight}, Dark: ${themeManager.infoDark})');

    // Accent colors
    debugPrint('🎨 Accent 1 (Purple): ${themeManager.accent1}');
    debugPrint('🎨 Accent 2 (Pink): ${themeManager.accent2}');
    debugPrint('🎨 Accent 3 (Teal): ${themeManager.accent3}');
    debugPrint('🎨 Accent 4 (Orange): ${themeManager.accent4}');
    debugPrint('🎨 Accent 5 (Indigo): ${themeManager.accent5}');

    // Neutral colors
    debugPrint(
        '🎨 Neutrals: ${themeManager.neutral50}, ${themeManager.neutral100}, ${themeManager.neutral200}');
    debugPrint(
        '🎨 Neutrals: ${themeManager.neutral300}, ${themeManager.neutral400}, ${themeManager.neutral500}');
    debugPrint(
        '🎨 Neutrals: ${themeManager.neutral600}, ${themeManager.neutral700}, ${themeManager.neutral800}, ${themeManager.neutral900}');

    // Interactive colors
    debugPrint('🎨 Button Background: ${themeManager.buttonBackground}');
    debugPrint('🎨 Button Hover: ${themeManager.buttonBackgroundHover}');
    debugPrint('🎨 Button Pressed: ${themeManager.buttonBackgroundPressed}');
    debugPrint('🎨 Button Disabled: ${themeManager.buttonBackgroundDisabled}');
    debugPrint('🎨 Input Background: ${themeManager.inputBackground}');
    debugPrint('🎨 Input Focused: ${themeManager.inputBackgroundFocused}');
    debugPrint('🎨 Input Disabled: ${themeManager.inputBackgroundDisabled}');

    // Semantic colors
    debugPrint('🎨 Status Online: ${themeManager.statusOnline}');
    debugPrint('🎨 Status Offline: ${themeManager.statusOffline}');
    debugPrint('🎨 Status Away: ${themeManager.statusAway}');
    debugPrint('🎨 Status Busy: ${themeManager.statusBusy}');
    debugPrint('🎨 Favorite: ${themeManager.favoriteColor}');
    debugPrint('🎨 Rating: ${themeManager.ratingColor}');
    debugPrint('🎨 New Indicator: ${themeManager.newIndicator}');
    debugPrint('🎨 Verified: ${themeManager.verifiedColor}');

    // Shadow colors
    debugPrint('🎨 Shadow Light: ${themeManager.shadowLight}');
    debugPrint('🎨 Shadow Medium: ${themeManager.shadowMedium}');
    debugPrint('🎨 Shadow Dark: ${themeManager.shadowDark}');
  }

  /// Demonstrates all shadows and effects
  static void _demonstrateAllShadowsAndEffects(ThemeManager themeManager) {
    debugPrint('💫 SettingsUtils: === ALL SHADOWS & EFFECTS DEMONSTRATION ===');

    // Shadow effects
    debugPrint(
        '💫 Primary Shadow: ${themeManager.primaryShadow.length} shadows');
    debugPrint(
        '💫 Elevated Shadow: ${themeManager.elevatedShadow.length} shadows');
    debugPrint('💫 Subtle Shadow: ${themeManager.subtleShadow.length} shadows');

    // Glass morphism effects
    debugPrint('💫 Glass Morphism: ${themeManager.glassMorphism.color}');
    debugPrint(
        '💫 Enhanced Glass Morphism: ${themeManager.enhancedGlassMorphism.color}');

    // Access theme properties
    debugPrint('💫 Theme Data: ${themeManager.theme.brightness}');
    debugPrint('💫 Color Scheme: ${themeManager.colorScheme.brightness}');
    debugPrint('💫 Is Dark Theme: ${themeManager.themeManager}');
  }

  /// Demonstrates all helper methods
  static void _demonstrateAllHelperMethods(ThemeManager themeManager) {
    debugPrint('🛠️ SettingsUtils: === ALL HELPER METHODS DEMONSTRATION ===');

    // Conditional colors
    final conditionalColor = themeManager.conditionalColor(
      lightColor: Colors.blue,
      darkColor: Colors.purple,
    );
    debugPrint('🛠️ Conditional Color: $conditionalColor');

    // Conditional gradients
    final conditionalGradient = themeManager.conditionalGradient(
      lightGradient: themeManager.primaryGradient,
      darkGradient: themeManager.secondaryGradient,
    );
    debugPrint('🛠️ Conditional Gradient: ${conditionalGradient.colors}');

    // Text color for backgrounds
    final textForPrimary =
        themeManager.getTextColorForBackground(themeManager.primaryColor);
    final textForSurface =
        themeManager.getTextColorForBackground(themeManager.surfaceColor);
    debugPrint('🛠️ Text for Primary: $textForPrimary');
    debugPrint('🛠️ Text for Surface: $textForSurface');

    // Contrasting colors
    final contrastForPrimary =
        themeManager.getContrastingColor(themeManager.primaryColor);
    final contrastForError =
        themeManager.getContrastingColor(themeManager.errorColor);
    debugPrint('🛠️ Contrast for Primary: $contrastForPrimary');
    debugPrint('🛠️ Contrast for Error: $contrastForError');

    // Theme alpha
    final alphaColor =
        themeManager.withThemeAlpha(themeManager.primaryColor, 0.5);
    debugPrint('🛠️ Alpha Color (50%): $alphaColor');
  }

  /// Demonstrates theme-aware utilities
  static void _demonstrateThemeAwareUtilities(ThemeManager themeManager) {
    debugPrint('⚙️ SettingsUtils: === THEME-AWARE UTILITIES ===');
    debugPrint(
        '⚙️ Theme Mode: ${themeManager.themeManager ? 'Dark' : 'Light'}');
    debugPrint(
        '⚙️ Font Family: ${themeManager.theme.textTheme.bodyMedium?.fontFamily ?? 'Default'}');
    debugPrint('⚙️ Material 3: ${themeManager.theme.useMaterial3}');
  }

  // ============================================================================
  // ENHANCED THEME DEBUGGING UTILITIES
  // ============================================================================

  /// **Comprehensive theme state analysis** with complete ThemeManager integration
  ///
  /// This utility provides detailed theme debugging information including:
  /// - Complete ThemeManager property analysis
  /// - All gradient and color validation
  /// - Shadow and effect verification
  /// - Performance metrics for theme operations
  /// - System vs app theme comparison
  /// - Accessibility compliance checking
  ///
  /// **Usage:**
  /// ```dart
  /// SettingsUtils.logThemeDebugInfo(context, 'settings_screen_init');
  /// ```
  static void logThemeDebugInfo(BuildContext context, String source) {
    debugPrint(
        '🎨 SettingsUtils: === COMPREHENSIVE THEME DEBUG INFO ($source) ===');

    try {
      final themeManager = ThemeManager.of(context);
      final mediaQuery = MediaQuery.of(context);

      // Use ThemeManager's built-in logging

      themeManager.logGradientInfo();

      // Theme basic information
      debugPrint(
          '🎨 SettingsUtils: Theme brightness: ${themeManager.theme.brightness.name}');
      debugPrint(
          '🎨 SettingsUtils: System brightness: ${mediaQuery.platformBrightness.name}');
      debugPrint(
          '🎨 SettingsUtils: Material 3: ${themeManager.theme.useMaterial3}');

      // Color scheme analysis using ThemeManager colors
      _logColorSchemeAnalysisEnhanced(themeManager);

      // Cache state analysis
      _logThemeCacheAnalysis();

      // Performance metrics
      _logThemePerformanceMetrics(themeManager.theme);

      // Accessibility analysis using ThemeManager colors
      _logThemeAccessibilityAnalysisEnhanced(themeManager);

      // Gradient analysis
      _logGradientAnalysis(themeManager);

      // Shadow analysis
      _logShadowAnalysis(themeManager);
    } catch (error, stackTrace) {
      debugPrint('🎨 SettingsUtils: ❌ Error in theme debug info: $error');
      debugPrint('🎨 SettingsUtils: Stack trace: $stackTrace');
    }
  }

  /// Enhanced color scheme analysis using all ThemeManager colors
  static void _logColorSchemeAnalysisEnhanced(ThemeManager themeManager) {
    debugPrint('🎨 SettingsUtils: === ENHANCED COLOR SCHEME ANALYSIS ===');

    // Primary colors
    debugPrint('🎨 SettingsUtils: Primary: ${themeManager.primaryColor}');
    debugPrint('🎨 SettingsUtils: Primary Light: ${themeManager.primaryLight}');
    debugPrint('🎨 SettingsUtils: Primary Dark: ${themeManager.primaryDark}');
    debugPrint('🎨 SettingsUtils: Secondary: ${themeManager.secondaryColor}');

    // Background colors
    debugPrint('🎨 SettingsUtils: Background: ${themeManager.backgroundColor}');
    debugPrint('🎨 SettingsUtils: Surface: ${themeManager.surfaceColor}');
    debugPrint(
        '🎨 SettingsUtils: Card Background: ${themeManager.cardBackground}');

    // Text colors
    debugPrint('🎨 SettingsUtils: Text Primary: ${themeManager.textPrimary}');
    debugPrint(
        '🎨 SettingsUtils: Text Secondary: ${themeManager.textSecondary}');
    debugPrint('🎨 SettingsUtils: Text Tertiary: ${themeManager.textTertiary}');

    // Status colors
    debugPrint('🎨 SettingsUtils: Success: ${themeManager.successColor}');
    debugPrint('🎨 SettingsUtils: Warning: ${themeManager.warningColor}');
    debugPrint('🎨 SettingsUtils: Error: ${themeManager.errorColor}');
    debugPrint('🎨 SettingsUtils: Info: ${themeManager.infoColor}');

    // Accent colors
    debugPrint('🎨 SettingsUtils: Accent 1: ${themeManager.accent1}');
    debugPrint('🎨 SettingsUtils: Accent 2: ${themeManager.accent2}');
    debugPrint('🎨 SettingsUtils: Accent 3: ${themeManager.accent3}');
    debugPrint('🎨 SettingsUtils: Accent 4: ${themeManager.accent4}');
    debugPrint('🎨 SettingsUtils: Accent 5: ${themeManager.accent5}');
  }

  /// Analyzes all gradients
  static void _logGradientAnalysis(ThemeManager themeManager) {
    debugPrint('🌈 SettingsUtils: === GRADIENT ANALYSIS ===');
    debugPrint(
        '🌈 Background Gradient: ${themeManager.backgroundGradient.colors.length} colors');
    debugPrint(
        '🌈 Surface Gradient: ${themeManager.surfaceGradient.colors.length} colors');
    debugPrint(
        '🌈 Primary Gradient: ${themeManager.primaryGradient.colors.length} colors');
    debugPrint(
        '🌈 Success Gradient: ${themeManager.successGradient.colors.length} colors');
    debugPrint(
        '🌈 Warning Gradient: ${themeManager.warningGradient.colors.length} colors');
    debugPrint(
        '🌈 Error Gradient: ${themeManager.errorGradient.colors.length} colors');
  }

  /// Analyzes all shadows
  static void _logShadowAnalysis(ThemeManager themeManager) {
    debugPrint('💫 SettingsUtils: === SHADOW ANALYSIS ===');
    debugPrint(
        '💫 Primary Shadow: ${themeManager.primaryShadow.length} shadows');
    debugPrint(
        '💫 Elevated Shadow: ${themeManager.elevatedShadow.length} shadows');
    debugPrint('💫 Subtle Shadow: ${themeManager.subtleShadow.length} shadows');

    // Analyze first shadow in each set
    if (themeManager.primaryShadow.isNotEmpty) {
      final shadow = themeManager.primaryShadow.first;
      debugPrint(
          '💫 Primary Shadow Details: Blur ${shadow.blurRadius}, Offset ${shadow.offset}');
    }
  }

  /// Validates theme consistency between different states
  static bool validateThemeConsistency(
      BuildContext context, ThemeMode expectedMode) {
    debugPrint('🎨 SettingsUtils: === THEME CONSISTENCY VALIDATION ===');

    try {
      final themeManager = ThemeManager.of(context);
      final actualBrightness = themeManager.theme.brightness;
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

      // Additional ThemeManager consistency checks
      _validateThemeManagerConsistency(themeManager);

      debugPrint(
          '🎨 SettingsUtils: Overall consistency: ${isConsistent ? '✅ PASS' : '❌ FAIL'}');
      return isConsistent;
    } catch (error) {
      debugPrint(
          '🎨 SettingsUtils: ❌ Error validating theme consistency: $error');
      return false;
    }
  }

  /// Validates ThemeManager internal consistency
  static void _validateThemeManagerConsistency(ThemeManager themeManager) {
    debugPrint('🎨 SettingsUtils: === THEMEMANAGER CONSISTENCY CHECKS ===');

    // Check if theme mode matches color selections
    final isDark = themeManager.themeManager;
    final actualBrightness = themeManager.theme.brightness;
    final expectedBrightness = isDark ? Brightness.dark : Brightness.light;

    final brightnessConsistent = actualBrightness == expectedBrightness;
    debugPrint(
        '🎨 SettingsUtils: Brightness consistency: ${brightnessConsistent ? '✅' : '❌'}');

    // Check color relationships
    final primaryContrast = _calculateContrastRatio(
        themeManager.primaryColor, themeManager.textPrimary);
    final surfaceContrast = _calculateContrastRatio(
        themeManager.surfaceColor, themeManager.textPrimary);

    debugPrint(
        '🎨 SettingsUtils: Primary contrast: ${primaryContrast.toStringAsFixed(2)}:1');
    debugPrint(
        '🎨 SettingsUtils: Surface contrast: ${surfaceContrast.toStringAsFixed(2)}:1');
  }

  /// Monitors theme change performance with ThemeManager
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

  /// Logs theme cache analysis for debugging
  static void _logThemeCacheAnalysis() {
    try {
      debugPrint('🎨 SettingsUtils: === THEME CACHE ANALYSIS ===');
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

    final estimatedMemory = _estimateThemeMemoryUsage(theme);
    debugPrint('🎨 SettingsUtils: Estimated memory: ~${estimatedMemory}KB');
  }

  /// Enhanced theme accessibility analysis using ThemeManager colors
  static void _logThemeAccessibilityAnalysisEnhanced(
      ThemeManager themeManager) {
    debugPrint(
        '🎨 SettingsUtils: === ENHANCED THEME ACCESSIBILITY ANALYSIS ===');

    // Check contrast ratios for all important color combinations
    final primaryContrast = _calculateContrastRatio(
        themeManager.primaryColor, themeManager.textInverted);
    final surfaceContrast = _calculateContrastRatio(
        themeManager.surfaceColor, themeManager.textPrimary);
    final backgroundContrast = _calculateContrastRatio(
        themeManager.backgroundColor, themeManager.textPrimary);
    final errorContrast = _calculateContrastRatio(
        themeManager.errorColor, themeManager.textInverted);
    final successContrast = _calculateContrastRatio(
        themeManager.successColor, themeManager.textInverted);

    debugPrint(
        '🎨 SettingsUtils: Primary contrast: ${primaryContrast.toStringAsFixed(2)}:1');
    debugPrint(
        '🎨 SettingsUtils: Surface contrast: ${surfaceContrast.toStringAsFixed(2)}:1');
    debugPrint(
        '🎨 SettingsUtils: Background contrast: ${backgroundContrast.toStringAsFixed(2)}:1');
    debugPrint(
        '🎨 SettingsUtils: Error contrast: ${errorContrast.toStringAsFixed(2)}:1');
    debugPrint(
        '🎨 SettingsUtils: Success contrast: ${successContrast.toStringAsFixed(2)}:1');

    // WCAG AA compliance (4.5:1 for normal text)
    final primaryCompliant = primaryContrast >= 4.5;
    final surfaceCompliant = surfaceContrast >= 4.5;
    final backgroundCompliant = backgroundContrast >= 4.5;
    final errorCompliant = errorContrast >= 4.5;
    final successCompliant = successContrast >= 4.5;

    debugPrint(
        '🎨 SettingsUtils: Primary WCAG AA: ${primaryCompliant ? '✅' : '❌'}');
    debugPrint(
        '🎨 SettingsUtils: Surface WCAG AA: ${surfaceCompliant ? '✅' : '❌'}');
    debugPrint(
        '🎨 SettingsUtils: Background WCAG AA: ${backgroundCompliant ? '✅' : '❌'}');
    debugPrint(
        '🎨 SettingsUtils: Error WCAG AA: ${errorCompliant ? '✅' : '❌'}');
    debugPrint(
        '🎨 SettingsUtils: Success WCAG AA: ${successCompliant ? '✅' : '❌'}');
  }

  /// Estimates theme memory usage (rough calculation)
  static int _estimateThemeMemoryUsage(ThemeData theme) {
    int baseSize = 50; // Base theme overhead
    int colorSchemeSize = 30; // Color scheme
    int textThemeSize = 40; // Text theme
    int componentThemeSize = 60; // Various component themes

    return baseSize + colorSchemeSize + textThemeSize + componentThemeSize;
  }

  /// Calculates contrast ratio between two colors (simplified)
  static double _calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();

    final lighter = math.max(luminance1, luminance2);
    final darker = math.min(luminance1, luminance2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// **Creates a comprehensive theme debug report** with all ThemeManager properties
  static Map<String, dynamic> createThemeDebugReport(BuildContext context) {
    final themeManager = ThemeManager.of(context);
    final colorScheme = themeManager.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return {
      'timestamp': DateTime.now().toIso8601String(),
      'theme': {
        'brightness': themeManager.theme.brightness.name,
        'useMaterial3': themeManager.theme.useMaterial3,
        'hashCode': themeManager.theme.hashCode,
        'isDark': themeManager.themeManager,
      },
      'colorScheme': {
        'brightness': colorScheme.brightness.name,
        'primary': colorScheme.primary.toString(),
        'surface': colorScheme.surface.toString(),
        'hashCode': colorScheme.hashCode,
      },
      'themeManagerColors': {
        'backgroundColor': themeManager.backgroundColor.toString(),
        'surfaceColor': themeManager.surfaceColor.toString(),
        'textPrimary': themeManager.textPrimary.toString(),
        'textSecondary': themeManager.textSecondary.toString(),
        'primaryColor': themeManager.primaryColor.toString(),
        'secondaryColor': themeManager.secondaryColor.toString(),
        'successColor': themeManager.successColor.toString(),
        'warningColor': themeManager.warningColor.toString(),
        'errorColor': themeManager.errorColor.toString(),
        'infoColor': themeManager.infoColor.toString(),
      },
      'themeManagerAccents': {
        'accent1': themeManager.accent1.toString(),
        'accent2': themeManager.accent2.toString(),
        'accent3': themeManager.accent3.toString(),
        'accent4': themeManager.accent4.toString(),
        'accent5': themeManager.accent5.toString(),
      },
      'themeManagerSemantics': {
        'statusOnline': themeManager.statusOnline.toString(),
        'statusOffline': themeManager.statusOffline.toString(),
        'statusAway': themeManager.statusAway.toString(),
        'statusBusy': themeManager.statusBusy.toString(),
        'favoriteColor': themeManager.favoriteColor.toString(),
        'ratingColor': themeManager.ratingColor.toString(),
        'newIndicator': themeManager.newIndicator.toString(),
        'verifiedColor': themeManager.verifiedColor.toString(),
      },
      'system': {
        'brightness': mediaQuery.platformBrightness.name,
        'devicePixelRatio': mediaQuery.devicePixelRatio,
        'textScaleFactor': mediaQuery.textScaler.toString(),
      },
      'performance': {
        'estimatedMemoryKB': _estimateThemeMemoryUsage(themeManager.theme),
      },
      'accessibility': {
        'primaryContrast': _calculateContrastRatio(
            themeManager.primaryColor, themeManager.textInverted),
        'surfaceContrast': _calculateContrastRatio(
            themeManager.surfaceColor, themeManager.textPrimary),
        'backgroundContrast': _calculateContrastRatio(
            themeManager.backgroundColor, themeManager.textPrimary),
      },
      'gradients': {
        'backgroundGradientColors':
            themeManager.backgroundGradient.colors.length,
        'primaryGradientColors': themeManager.primaryGradient.colors.length,
        'successGradientColors': themeManager.successGradient.colors.length,
      },
      'shadows': {
        'primaryShadowCount': themeManager.primaryShadow.length,
        'elevatedShadowCount': themeManager.elevatedShadow.length,
        'subtleShadowCount': themeManager.subtleShadow.length,
      },
    };
  }

  // ============================================================================
  // THEMEMANAGER UI HELPER UTILITIES
  // ============================================================================

  /// **Creates a themed container** using ThemeManager properties
  static Container createThemedContainer(
    BuildContext context, {
    required Widget child,
    bool usePrimaryGradient = false,
    bool useGlassMorphism = false,
    bool useElevatedShadow = false,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    final themeManager = ThemeManager.of(context);

    BoxDecoration decoration;

    if (useGlassMorphism) {
      decoration = themeManager.enhancedGlassMorphism;
    } else if (usePrimaryGradient) {
      decoration = BoxDecoration(
        gradient: themeManager.primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: useElevatedShadow
            ? themeManager.elevatedShadow
            : themeManager.subtleShadow,
      );
    } else {
      decoration = BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: themeManager.borderColor),
        boxShadow: useElevatedShadow
            ? themeManager.elevatedShadow
            : themeManager.subtleShadow,
      );
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: decoration,
      child: child,
    );
  }

  /// **Creates themed text** using ThemeManager text colors
  static Widget createThemedText(
    BuildContext context,
    String text, {
    TextStyle? baseStyle,
    bool isPrimary = true,
    bool isOnPrimaryBackground = false,
  }) {
    final themeManager = ThemeManager.of(context);

    Color textColor;
    if (isOnPrimaryBackground) {
      textColor = themeManager.textInverted;
    } else if (isPrimary) {
      textColor = themeManager.textPrimary;
    } else {
      textColor = themeManager.textSecondary;
    }

    return Text(
      text,
      style: (baseStyle ?? themeManager.theme.textTheme.bodyMedium)?.copyWith(
        color: textColor,
      ),
    );
  }

  /// **Creates themed icon** using ThemeManager colors
  static Widget createThemedIcon(
    BuildContext context,
    IconData icon, {
    double? size,
    bool useAccentColor = false,
    bool isOnPrimaryBackground = false,
  }) {
    final themeManager = ThemeManager.of(context);

    Color iconColor;
    if (isOnPrimaryBackground) {
      iconColor = themeManager.textInverted;
    } else if (useAccentColor) {
      iconColor = themeManager.accent1;
    } else {
      iconColor = themeManager.textSecondary;
    }

    return Icon(
      icon,
      size: size,
      color: iconColor,
    );
  }
}
