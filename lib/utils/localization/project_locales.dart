import 'package:flutter/material.dart';

/// ProjectLocales - Comprehensive Indian Languages Support Configuration
///
/// This class defines all supported locales for the Prbal app with focus on Indian languages.
/// Each locale includes proper country codes and user-friendly display names.
///
/// **SUPPORTED LANGUAGES:**
/// - English (en-US) - Primary/Default language
/// - Hindi (hi-IN) - National language of India
/// - Bengali (bn-IN) - West Bengal, Bangladesh regions
/// - Telugu (te-IN) - Andhra Pradesh, Telangana
/// - Marathi (mr-IN) - Maharashtra
/// - Tamil (ta-IN) - Tamil Nadu
/// - Gujarati (gu-IN) - Gujarat
/// - Kannada (kn-IN) - Karnataka
/// - Malayalam (ml-IN) - Kerala
/// - Punjabi (pa-IN) - Punjab, Delhi regions
///
/// **FEATURES:**
/// - Easy language addition/removal
/// - Consistent locale formatting (language-COUNTRY)
/// - User-friendly display names
/// - Debug logging for language operations
/// - Proper fallback to English
class ProjectLocales {
  const ProjectLocales._();

  /// Map of supported locales with their display names
  ///
  /// **STRUCTURE:**
  /// - Key: Locale object with language and country codes
  /// - Value: User-friendly display name shown in UI
  ///
  /// **ORDERING:**
  /// English first (default), then Indian languages alphabetically by display name
  static final Map<Locale, String> localesMap = {
    // Primary/Default Language
    const Locale('en', 'US'): 'English', // 🇺🇸

    // Indian Languages (Alphabetical by display name)
    const Locale('bn', 'IN'): 'বাংলা (Bengali)', // 🇮🇳 West Bengal
    const Locale('gu', 'IN'): 'ગુજરાતી (Gujarati)', // 🇮🇳 Gujarat
    const Locale('hi', 'IN'): 'हिन्दी (Hindi)', // 🇮🇳 National Language
    const Locale('kn', 'IN'): 'ಕನ್ನಡ (Kannada)', // 🇮🇳 Karnataka
    const Locale('ml', 'IN'): 'മലയാളം (Malayalam)', // 🇮🇳 Kerala
    const Locale('mr', 'IN'): 'मराठी (Marathi)', // 🇮🇳 Maharashtra
    const Locale('pa', 'IN'): 'ਪੰਜਾਬੀ (Punjabi)', // 🇮🇳 Punjab
    const Locale('ta', 'IN'): 'தமிழ் (Tamil)', // 🇮🇳 Tamil Nadu
    const Locale('te', 'IN'): 'తెలుగు (Telugu)', // 🇮🇳 Andhra Pradesh/Telangana
  };

  /// Get list of supported locales for easy iteration
  ///
  /// **USAGE:**
  /// ```dart
  /// for (final locale in ProjectLocales.supportedLocales) {
  ///   debugPrint('Supported: ${locale.languageCode}-${locale.countryCode}');
  /// }
  /// ```
  static List<Locale> get supportedLocales {
    final locales = localesMap.keys.toList();
    debugPrint('🌐 ProjectLocales: Retrieved ${locales.length} supported locales');
    return locales;
  }

  /// Get display names for dropdown/selection UI
  ///
  /// **USAGE:**
  /// ```dart
  /// final names = ProjectLocales.displayNames;
  /// // Returns: ['English', 'বাংলা (Bengali)', 'ગુજરાતી (Gujarati)', ...]
  /// ```
  static List<String> get displayNames {
    final names = localesMap.values.toList();
    debugPrint('🌐 ProjectLocales: Retrieved ${names.length} display names');
    return names;
  }

  /// Get display name for a specific locale
  ///
  /// **PARAMETERS:**
  /// - locale: The locale to get display name for
  ///
  /// **RETURNS:**
  /// - Display name if found, fallback to locale string if not found
  ///
  /// **EXAMPLE:**
  /// ```dart
  /// final name = ProjectLocales.getDisplayName(Locale('hi', 'IN'));
  /// // Returns: "हिन्दी (Hindi)"
  /// ```
  static String getDisplayName(Locale locale) {
    final displayName = localesMap[locale] ?? '${locale.languageCode}-${locale.countryCode}';
    debugPrint('🌐 ProjectLocales: Display name for ${locale.languageCode}-${locale.countryCode}: $displayName');
    return displayName;
  }

  /// Check if a locale is supported
  ///
  /// **PARAMETERS:**
  /// - locale: The locale to check
  ///
  /// **RETURNS:**
  /// - true if locale is supported, false otherwise
  ///
  /// **EXAMPLE:**
  /// ```dart
  /// final isSupported = ProjectLocales.isSupported(Locale('hi', 'IN'));
  /// // Returns: true
  /// ```
  static bool isSupported(Locale locale) {
    final supported = localesMap.containsKey(locale);
    debugPrint('🌐 ProjectLocales: Locale ${locale.languageCode}-${locale.countryCode} supported: $supported');
    return supported;
  }

  /// Get default locale (English)
  ///
  /// **RETURNS:**
  /// - Default locale (en-US)
  ///
  /// **USAGE:**
  /// Used as fallback when user's preferred locale is not supported
  static Locale get defaultLocale {
    const locale = Locale('en', 'US');
    debugPrint('🌐 ProjectLocales: Using default locale: ${locale.languageCode}-${locale.countryCode}');
    return locale;
  }

  /// Get locale from language code string
  ///
  /// **PARAMETERS:**
  /// - languageCode: String in format "language-COUNTRY" (e.g., "hi-IN")
  ///
  /// **RETURNS:**
  /// - Matching Locale object or default locale if not found
  ///
  /// **EXAMPLE:**
  /// ```dart
  /// final locale = ProjectLocales.getLocaleFromCode('hi-IN');
  /// // Returns: Locale('hi', 'IN')
  /// ```
  static Locale getLocaleFromCode(String languageCode) {
    debugPrint('🌐 ProjectLocales: Converting language code "$languageCode" to Locale');

    try {
      final parts = languageCode.split('-');
      if (parts.length == 2) {
        final targetLocale = Locale(parts[0], parts[1]);

        // Check if this locale is supported
        if (isSupported(targetLocale)) {
          debugPrint(
              '🌐 ProjectLocales: ✅ Found supported locale: ${targetLocale.languageCode}-${targetLocale.countryCode}');
          return targetLocale;
        } else {
          debugPrint(
              '🌐 ProjectLocales: ⚠️ Locale not supported, using default: ${targetLocale.languageCode}-${targetLocale.countryCode}');
          return defaultLocale;
        }
      } else {
        debugPrint('🌐 ProjectLocales: ❌ Invalid language code format: "$languageCode", using default');
        return defaultLocale;
      }
    } catch (e) {
      debugPrint('🌐 ProjectLocales: ❌ Error parsing language code "$languageCode": $e, using default');
      return defaultLocale;
    }
  }

  /// Log all supported locales for debugging
  ///
  /// **USAGE:**
  /// Call this method during app initialization to see all available locales
  static void logSupportedLocales() {
    debugPrint('🌐 ProjectLocales: ========= SUPPORTED LOCALES =========');
    debugPrint('🌐 ProjectLocales: Total supported languages: ${localesMap.length}');

    int index = 1;
    for (final entry in localesMap.entries) {
      final locale = entry.key;
      final displayName = entry.value;
      final isDefault = locale == defaultLocale;

      debugPrint(
          '🌐 ProjectLocales: $index. ${locale.languageCode}-${locale.countryCode} → "$displayName"${isDefault ? ' (DEFAULT)' : ''}');
      index++;
    }

    debugPrint('🌐 ProjectLocales: =====================================');
  }
}
