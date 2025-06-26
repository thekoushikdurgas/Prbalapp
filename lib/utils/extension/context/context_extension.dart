import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

/// Context Extensions - Enhanced context utilities with comprehensive debugging
///
/// This extension provides additional functionality to the BuildContext
/// including enhanced translation methods with debug logging and validation.
///
/// **FEATURES:**
/// - Enhanced translation methods with debug logging
/// - Translation validation and fallback handling
/// - Locale information retrieval
/// - Performance monitoring for translation operations
/// - Development-time translation usage tracking
extension ContextExtension on BuildContext {
  /// Enhanced translation method with comprehensive debug logging
  ///
  /// **PARAMETERS:**
  /// - key: Translation key (e.g., 'app.name')
  /// - args: Optional arguments for parameterized translations
  /// - fallback: Optional fallback text if translation fails
  ///
  /// **RETURNS:**
  /// - Translated string with fallback support
  ///
  /// **FEATURES:**
  /// - Debug logging for translation requests
  /// - Validation of translation keys
  /// - Performance monitoring
  /// - Fallback handling for missing translations
  ///
  /// **USAGE:**
  /// ```dart
  /// // Simple translation
  /// final title = context.trWithDebug('app.name');
  ///
  /// // With arguments
  /// final message = context.trWithDebug('validation.minLength', args: ['5']);
  ///
  /// // With fallback
  /// final text = context.trWithDebug('unknown.key', fallback: 'Default Text');
  /// ```
  String trWithDebug(String key, {List<String>? args, String? fallback}) {
    final stopwatch = Stopwatch()..start();

    try {
      debugPrint('🌐 Translation: Requesting key "$key"${args != null ? ' with args: $args' : ''}');

      // Attempt translation using Easy Localization
      final translation = args != null ? tr(key, args: args) : tr(key);

      // Check if translation was successful (not returning the key itself)
      if (translation == key) {
        debugPrint('🌐 Translation: ⚠️ Key "$key" not found in current locale');

        if (fallback != null) {
          debugPrint('🌐 Translation: 🔄 Using provided fallback: "$fallback"');
          stopwatch.stop();
          debugPrint('🌐 Translation: ⏱️ Fallback operation: ${stopwatch.elapsedMicroseconds}μs');
          return fallback;
        } else {
          debugPrint('🌐 Translation: ❌ No fallback provided, returning original key');
        }
      } else {
        debugPrint('🌐 Translation: ✅ Successfully translated "$key" → "$translation"');
      }

      stopwatch.stop();
      debugPrint('🌐 Translation: ⏱️ Translation time: ${stopwatch.elapsedMicroseconds}μs');
      return translation;
    } catch (e) {
      stopwatch.stop();
      debugPrint('🌐 Translation: ❌ Error translating "$key": $e');
      debugPrint('🌐 Translation: ⏱️ Error occurred after: ${stopwatch.elapsedMicroseconds}μs');

      if (fallback != null) {
        debugPrint('🌐 Translation: 🔄 Using fallback due to error: "$fallback"');
        return fallback;
      } else {
        debugPrint('🌐 Translation: 🔄 Returning original key due to error');
        return key;
      }
    }
  }

  /// Get current locale information with debug logging
  ///
  /// **RETURNS:**
  /// - Current locale object
  ///
  /// **FEATURES:**
  /// - Debug logging of current locale
  /// - Validation against supported locales
  /// - Locale display name resolution
  ///
  /// **USAGE:**
  /// ```dart
  /// final currentLocale = context.getCurrentLocaleWithDebug();
  /// ```
  Locale getCurrentLocaleWithDebug() {
    try {
      final currentLocale = locale;
      debugPrint('🌐 Context: Current locale: ${currentLocale.languageCode}-${currentLocale.countryCode}');

      // Additional information about the locale
      final displayName = _getLocaleDisplayName(currentLocale);
      debugPrint('🌐 Context: Display name: $displayName');

      return currentLocale;
    } catch (e) {
      debugPrint('🌐 Context: ❌ Error getting current locale: $e');
      debugPrint('🌐 Context: 🔄 Falling back to English locale');
      return const Locale('en', 'US');
    }
  }

  /// Check if current locale is RTL with debug logging
  ///
  /// **RETURNS:**
  /// - true if current locale uses right-to-left text direction
  ///
  /// **USAGE:**
  /// ```dart
  /// final isRTL = context.isRTLWithDebug();
  /// ```
  bool isRTLWithDebug() {
    try {
      final currentLocale = locale;
      final textDirection = Directionality.maybeOf(this);
      final isRTL = textDirection == ui.TextDirection.rtl;

      debugPrint('🌐 Context: Locale ${currentLocale.languageCode} text direction: ${isRTL ? 'RTL' : 'LTR'}');
      return isRTL;
    } catch (e) {
      debugPrint('🌐 Context: ❌ Error determining text direction: $e');
      debugPrint('🌐 Context: 🔄 Defaulting to LTR');
      return false;
    }
  }

  /// Get MediaQuery data for the current context
  ///
  /// **RETURNS:**
  /// - MediaQueryData for the current context
  ///
  /// **USAGE:**
  /// ```dart
  /// final screenSize = context.mediaQuery.size;
  /// ```
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Change locale with comprehensive logging and validation
  ///
  /// **PARAMETERS:**
  /// - newLocale: Locale to switch to
  ///
  /// **FEATURES:**
  /// - Validation before switching
  /// - Comprehensive logging of the switch process
  /// - Error handling with fallbacks
  ///
  /// **USAGE:**
  /// ```dart
  /// await context.changeLocaleWithDebug(Locale('hi', 'IN'));
  /// ```
  Future<void> changeLocaleWithDebug(Locale newLocale) async {
    debugPrint('🌐 Context: ========= LOCALE CHANGE REQUEST =========');
    final stopwatch = Stopwatch()..start();

    try {
      final currentLocale = locale;
      debugPrint('🌐 Context: Current locale: ${currentLocale.languageCode}-${currentLocale.countryCode}');
      debugPrint('🌐 Context: Requested locale: ${newLocale.languageCode}-${newLocale.countryCode}');

      // Check if already using the requested locale
      if (currentLocale == newLocale) {
        debugPrint('🌐 Context: ⚠️ Already using requested locale, no change needed');
        stopwatch.stop();
        debugPrint('🌐 Context: ⏱️ No-op operation: ${stopwatch.elapsedMilliseconds}ms');
        debugPrint('🌐 Context: =========================================');
        return;
      }

      debugPrint('🌐 Context: 🔄 Switching locale...');
      await setLocale(newLocale);

      stopwatch.stop();
      debugPrint('🌐 Context: ✅ Locale changed successfully');
      debugPrint('🌐 Context: ⏱️ Switch operation: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('🌐 Context: New display name: ${_getLocaleDisplayName(newLocale)}');
      debugPrint('🌐 Context: =========================================');
    } catch (e) {
      stopwatch.stop();
      debugPrint('🌐 Context: ❌ Locale change failed: $e');
      debugPrint('🌐 Context: ⏱️ Failed after: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('🌐 Context: 🔄 Staying with current locale');
      debugPrint('🌐 Context: =========================================');
      rethrow; // Re-throw to handle in calling code
    }
  }

  /// Helper method to get display name for a locale
  ///
  /// **PARAMETERS:**
  /// - locale: Locale to get display name for
  ///
  /// **RETURNS:**
  /// - User-friendly display name or fallback string
  String _getLocaleDisplayName(Locale locale) {
    // This would integrate with ProjectLocales if imported
    // For now, provide basic language name mapping
    final languageNames = {
      'en': 'English',
      'hi': 'हिन्दी (Hindi)',
      'bn': 'বাংলা (Bengali)',
      'te': 'తెలుగు (Telugu)',
      'mr': 'मराठी (Marathi)',
      'ta': 'தமிழ் (Tamil)',
      'gu': 'ગુજરાતી (Gujarati)',
      'kn': 'ಕನ್ನಡ (Kannada)',
      'ml': 'മലയാളം (Malayalam)',
      'pa': 'ਪੰਜਾਬੀ (Punjabi)',
    };

    return languageNames[locale.languageCode] ?? '${locale.languageCode}-${locale.countryCode}';
  }

  /// Log current translation context information
  ///
  /// **USAGE:**
  /// Call this method to debug current localization state in any widget
  void logTranslationContext() {
    debugPrint('🌐 Context: ========= TRANSLATION CONTEXT =========');

    try {
      final currentLocale = getCurrentLocaleWithDebug();
      final isRTL = isRTLWithDebug();
      final supportedLocales = EasyLocalization.of(this)?.supportedLocales ?? [];

      debugPrint('🌐 Context: Current locale: ${currentLocale.languageCode}-${currentLocale.countryCode}');
      debugPrint('🌐 Context: Display name: ${_getLocaleDisplayName(currentLocale)}');
      debugPrint('🌐 Context: Text direction: ${isRTL ? 'RTL' : 'LTR'}');
      debugPrint('🌐 Context: Supported locales count: ${supportedLocales.length}');
      debugPrint(
          '🌐 Context: EasyLocalization instance: ${EasyLocalization.of(this) != null ? 'Available' : 'Not Available'}');
    } catch (e) {
      debugPrint('🌐 Context: ❌ Error logging translation context: $e');
    }

    debugPrint('🌐 Context: ========================================');
  }
}

extension MediaQueryExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  double get lowValue => height * 0.01;
  double get normalValue => height * 0.02;
  double get mediumValue => height * 0.04;
  double get highValue => height * 0.1;
  double get introImageTitle => height * 0.65;
}

extension SizedSpaceBoxExtension on BuildContext {
  SizedBox get normalSpace => SizedBox(height: height * 0.1);
}
