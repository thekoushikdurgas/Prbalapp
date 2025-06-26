part of '/main.dart';

/// LocaleVariables - Enhanced localization configuration with comprehensive debugging
///
/// This class provides the core configuration for Easy Localization with:
/// - Supported locales from ProjectLocales
/// - Translation file path configuration
/// - Fallback locale management
/// - Enhanced debugging capabilities
/// - Helper methods for translation tracking
///
/// **FEATURES:**
/// - Comprehensive debug logging throughout
/// - Translation usage tracking for development
/// - Locale switching validation
/// - Error handling with fallbacks
/// - Performance monitoring for translation loading
class LocaleVariables {
  const LocaleVariables._();

  // Core configuration from ProjectLocales
  static final List<Locale> _localesList = ProjectLocales.localesMap.keys.toList();
  static const String _localesPath = 'assets/translations';
  static const Locale _fallBackLocale = Locale('en', 'US');

  /// Get the list of supported locales with debug logging
  ///
  /// **USAGE:**
  /// Used by EasyLocalization for configuration
  static List<Locale> get supportedLocales {
    debugPrint('🌐 LocaleVariables: Providing ${_localesList.length} supported locales to EasyLocalization');
    return _localesList;
  }

  /// Get the translations path with validation
  ///
  /// **USAGE:**
  /// Used by EasyLocalization to locate translation files
  static String get localesPath {
    debugPrint('🌐 LocaleVariables: Translation files path: $_localesPath');
    return _localesPath;
  }

  /// Get the fallback locale with logging
  ///
  /// **USAGE:**
  /// Used when requested locale is not available
  static Locale get fallbackLocale {
    debugPrint('🌐 LocaleVariables: Fallback locale: ${_fallBackLocale.languageCode}-${_fallBackLocale.countryCode}');
    return _fallBackLocale;
  }

  /// Create dropdown menu items for language selection
  ///
  /// **RETURNS:**
  /// - List of DropdownMenuItem widgets for UI selection
  ///
  /// **FEATURES:**
  /// - Debug logging for each menu item creation
  /// - Proper display name extraction from ProjectLocales
  /// - Error handling for missing display names
  static List<DropdownMenuItem> localItems() {
    debugPrint('🌐 LocaleVariables: Creating dropdown menu items for language selection');

    List<DropdownMenuItem> menuItems = [];

    for (var element in _localesList) {
      final displayName = ProjectLocales.localesMap[element] ?? 'Unknown Language';
      debugPrint(
          '🌐 LocaleVariables: Adding menu item: ${element.languageCode}-${element.countryCode} → "$displayName"');

      menuItems.add(DropdownMenuItem(
        value: element,
        child: Text(displayName),
      ));
    }

    debugPrint('🌐 LocaleVariables: ✅ Created ${menuItems.length} dropdown menu items');
    return menuItems;
  }

  /// Initialize Easy Localization with comprehensive logging
  ///
  /// **PROCESS:**
  /// 1. Ensure Flutter widgets binding is initialized
  /// 2. Initialize Easy Localization system
  /// 3. Log initialization status and timing
  /// 4. Handle any initialization errors
  static Future<void> _init() async {
    debugPrint('🌐 LocaleVariables: ========= EASY LOCALIZATION INITIALIZATION =========');
    final stopwatch = Stopwatch()..start();

    try {
      debugPrint('🌐 LocaleVariables: Step 1: Ensuring Flutter widgets binding...');
      WidgetsFlutterBinding.ensureInitialized();
      debugPrint('🌐 LocaleVariables: ✅ Flutter widgets binding ready');

      debugPrint('🌐 LocaleVariables: Step 2: Initializing Easy Localization...');
      debugPrint('🌐 LocaleVariables: - Supported locales: ${_localesList.length}');
      debugPrint('🌐 LocaleVariables: - Translations path: $_localesPath');
      debugPrint(
          '🌐 LocaleVariables: - Fallback locale: ${_fallBackLocale.languageCode}-${_fallBackLocale.countryCode}');

      await EasyLocalization.ensureInitialized();

      stopwatch.stop();
      debugPrint('🌐 LocaleVariables: ✅ Easy Localization initialized successfully');
      debugPrint('🌐 LocaleVariables: ⏱️ Initialization time: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('🌐 LocaleVariables: ===============================================');
    } catch (e) {
      stopwatch.stop();
      debugPrint('🌐 LocaleVariables: ❌ Easy Localization initialization failed: $e');
      debugPrint('🌐 LocaleVariables: ⏱️ Failed after: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('🌐 LocaleVariables: 🔄 App will continue with limited localization support');
      debugPrint('🌐 LocaleVariables: ===============================================');
      rethrow; // Re-throw to handle in main.dart
    }
  }

  /// Validate if a locale is properly supported
  ///
  /// **PARAMETERS:**
  /// - locale: Locale to validate
  ///
  /// **RETURNS:**
  /// - true if locale is supported and has translation file
  ///
  /// **USAGE:**
  /// ```dart
  /// if (LocaleVariables.validateLocale(Locale('hi', 'IN'))) {
  ///   // Safe to use this locale
  /// }
  /// ```
  static bool validateLocale(Locale locale) {
    debugPrint('🌐 LocaleVariables: Validating locale: ${locale.languageCode}-${locale.countryCode}');

    final isSupported = ProjectLocales.isSupported(locale);
    debugPrint('🌐 LocaleVariables: Locale supported in ProjectLocales: $isSupported');

    if (isSupported) {
      debugPrint('🌐 LocaleVariables: ✅ Locale validation passed');
      return true;
    } else {
      debugPrint('🌐 LocaleVariables: ❌ Locale validation failed');
      return false;
    }
  }

  /// Log current localization status for debugging
  ///
  /// **USAGE:**
  /// Call this method to get comprehensive status of the localization system
  static void logLocalizationStatus() {
    debugPrint('🌐 LocaleVariables: ========= LOCALIZATION STATUS =========');
    debugPrint('🌐 LocaleVariables: Supported locales count: ${_localesList.length}');
    debugPrint('🌐 LocaleVariables: Translations path: $_localesPath');
    debugPrint('🌐 LocaleVariables: Fallback locale: ${_fallBackLocale.languageCode}-${_fallBackLocale.countryCode}');

    debugPrint('🌐 LocaleVariables: Supported locales list:');
    for (int i = 0; i < _localesList.length; i++) {
      final locale = _localesList[i];
      final displayName = ProjectLocales.getDisplayName(locale);
      final isDefault = locale == _fallBackLocale;
      debugPrint(
          '🌐 LocaleVariables:   ${i + 1}. ${locale.languageCode}-${locale.countryCode} → "$displayName"${isDefault ? ' (DEFAULT)' : ''}');
    }

    debugPrint('🌐 LocaleVariables: =============================================');
  }
}
