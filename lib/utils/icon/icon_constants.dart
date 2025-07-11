/*
 * Icon Constants for Prbal Application
 * 
 * This file centralizes all icon references used throughout the application.
 * It provides a single point of access for commonly used icons from both
 * Material Design and custom Prbal icon font.
 * 
 * Categories:
 * - Theme & Settings Icons
 * - Navigation Icons  
 * - Action Icons
 * - Status & Alert Icons
 * - Media & Entertainment Icons
 * - Custom Prbal Icons
 * 
 * Usage Examples:
 * Icon(PrbalIconManager.themeIcon)
 * Icon(PrbalIconManager.errorIcon, color: Colors.red)
 * PrbalIconManager.debugLogIconUsage('theme_icon_used')
 */

import 'package:flutter/material.dart';
import 'prbal_icons.dart'; // Import our custom icon font
import '../theme/theme_manager.dart'; // Import ThemeManager for theme-aware functionality

/// **PrbalIconManager**
///
/// This is the MAIN class for managing all icons in the Prbal application.
/// It centralizes icon resolution, validation, categorization, and search functionality.
///
/// **Features:**
/// - Comprehensive icon mapping from prbal_icons.dart
/// - Category-based icon organization
/// - Smart icon search and suggestions
/// - Theme-aware icon recommendations
/// - Performance optimized with caching
/// - Extensive debug logging
///
/// **Usage:**
/// ```dart
/// final iconManager = PrbalIconManager();
/// final icon = iconManager.getIcon('home');
/// final suggestions = iconManager.searchIcons('house');
/// final validation = iconManager.validateIcon('businness'); // with typo suggestions
/// ```
class PrbalIconManager {
  static final PrbalIconManager _instance = PrbalIconManager._internal();
  factory PrbalIconManager() => _instance;
  PrbalIconManager._internal();

  // Cache for performance
  Map<String, IconData>? _iconCache;
  DateTime? _lastCacheTime;
  static const Duration _cacheValidity = Duration(hours: 1);

  /// ====================================================================
  /// CORE ICON RESOLUTION
  /// ====================================================================

  // =============================================================================
  // DEBUG UTILITIES
  // =============================================================================

  /// Debug function to log icon usage for analytics and optimization
  ///
  /// Call this method when using icons in critical UI components to track
  /// which icons are most frequently used and optimize icon loading.
  ///
  /// Example: PrbalIconManager().debugLogIconUsage('settings_screen_theme_toggle');
  void debugLogIconUsage(String context) {
    debugPrint('🎨 Icon Used: $context | Theme: ${_getCurrentThemeName()}');
  }

  /// Enhanced debug function with ThemeManager context
  void debugLogIconUsageWithTheme(
      BuildContext context, String usageContext, IconData iconData) {
    debugPrint('🎨 Enhanced Icon Usage Log:');
    debugPrint('   Context: $usageContext');
    debugPrint('   Icon: ${iconData.toString()}');
    debugPrint('   Primary Color: ${ThemeManager.of(context).primaryColor}');
    debugPrint('   Background: ${ThemeManager.of(context).backgroundColor}');
  }

  /// Comprehensive theme validation for icon system
  Map<String, dynamic> validateThemeIntegration(BuildContext context) {
    debugPrint('🔍 PrbalIconManager: Validating theme integration...');

    final validation = <String, dynamic>{
      'themeManagerAvailable': true,
      'primaryColor': ThemeManager.of(context).primaryColor.toString(),
      'backgroundColors': {
        'backgroundColor': ThemeManager.of(context).backgroundColor.toString(),
        'surfaceColor': ThemeManager.of(context).surfaceColor.toString(),
      },
      'textColors': {
        'textPrimary': ThemeManager.of(context).textPrimary.toString(),
        'textSecondary': ThemeManager.of(context).textSecondary.toString(),
        'textTertiary': ThemeManager.of(context).textTertiary.toString(),
      },
      'semanticColors': {
        'successColor': ThemeManager.of(context).successColor.toString(),
        'errorColor': ThemeManager.of(context).errorColor.toString(),
        'warningColor': ThemeManager.of(context).warningColor.toString(),
        'infoColor': ThemeManager.of(context).infoColor.toString(),
      },
      'gradients': {
        'primaryGradient': ThemeManager.of(context).primaryGradient.toString(),
        'surfaceGradient': ThemeManager.of(context).surfaceGradient.toString(),
        'backgroundGradient':
            ThemeManager.of(context).backgroundGradient.toString(),
      },
      'shadows': {
        'subtleShadow': ThemeManager.of(context).subtleShadow.length,
        'elevatedShadow': ThemeManager.of(context).elevatedShadow.length,
        'primaryShadow': ThemeManager.of(context).primaryShadow.length,
      },
      'customFontLoaded': isCustomFontLoaded(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    debugPrint('✅ Theme Integration Validation Complete:');
    debugPrint('   Colors Available: ${validation['semanticColors'].length}');
    debugPrint('   Gradients Available: ${validation['gradients'].length}');
    debugPrint('   Shadows Available: ${validation['shadows'].length}');

    return validation;
  }

  /// Get current theme name for debugging
  String _getCurrentThemeName() {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark
        ? 'dark'
        : 'light';
  }

  /// Get current theme name with context for enhanced debugging
  String getCurrentThemeNameWithContext(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    debugPrint(
        '🎨 PrbalIconManager: Theme context - brightness: ${brightness.name}');
    return brightness == Brightness.dark ? 'dark' : 'light';
  }

  /// Validate if custom Prbal font is loaded (for debugging)
  bool isCustomFontLoaded() {
    try {
      // This will help identify if the custom font is properly loaded
      const testIcon = Icon(Prbal.error);
      debugPrint('✅ Prbal font validation: ${testIcon.icon.toString()}');
      return true;
    } catch (e) {
      debugPrint('❌ Prbal font loading error: $e');
      return false;
    }
  }

  // =============================================================================
  // THEME & SETTINGS ICONS
  // =============================================================================

  /// Theme toggle icon - used in settings and navigation
  /// Material Design: wb_twilight_rounded for theme switching
  static const Icon themeIcon = Icon(Prbal.wbTwighlight);

  /// Localization/Language selection icon
  /// Material Design: language_rounded for language settings
  static const Icon localizationIcon = Icon(Prbal.language);

  /// Settings gear icon - primary settings access
  static const Icon settingsIcon = Icon(Prbal.cogOutline);

  /// Dark mode specific icon
  static const Icon darkModeIcon = Icon(Prbal.wbIncandescent);

  /// Light mode specific icon
  static const Icon lightModeIcon = Icon(Prbal.wbSunny);

  // =============================================================================
  // NAVIGATION ICONS
  // =============================================================================

  /// Home/Dashboard navigation
  static const Icon homeIcon = Icon(Prbal.home);

  /// Explore/Search navigation
  static const Icon exploreIcon = Icon(Prbal.explore2);

  /// Messages/Chat navigation
  static const Icon messagesIcon = Icon(Prbal.message);

  /// Profile/Account navigation
  static const Icon profileIcon = Icon(Prbal.person);

  /// Back navigation
  static const Icon backIcon = Icon(Prbal.arrowBack);

  /// Menu/Drawer toggle
  static const Icon menuIcon = Icon(Prbal.menu);

  // =============================================================================
  // ACTION ICONS
  // =============================================================================

  /// Add/Create new item
  static const Icon addIcon = Icon(Prbal.add);

  /// Edit/Modify existing item
  static const Icon editIcon = Icon(Prbal.edit);

  /// Delete/Remove item
  static const Icon deleteIcon = Icon(Prbal.delete);

  /// Save/Confirm action
  static const Icon saveIcon = Icon(Prbal.save);

  /// Search functionality
  static const Icon searchIcon = Icon(Prbal.search);

  /// Filter/Sort functionality
  static const Icon filterIcon = Icon(Prbal.filter);

  /// Share content
  static const Icon shareIcon = Icon(Prbal.share);

  /// Favorite/Like action
  static const Icon favoriteIcon = Icon(Prbal.favorite);

  /// Download action
  static const Icon downloadIcon = Icon(Prbal.download);

  /// Upload action
  static const Icon uploadIcon = Icon(Prbal.upload);

  // =============================================================================
  // STATUS & ALERT ICONS
  // =============================================================================

  /// Error states and validation failures
  /// Using custom Prbal icon for brand consistency
  static const Icon errorIcon = Icon(Prbal.error);

  /// Warning messages and cautions
  /// Using custom Prbal icon for brand consistency
  static const Icon warningIcon = Icon(Prbal.warning1);

  /// Success states and confirmations
  static const Icon successIcon = Icon(Prbal.checkCircle);

  /// Information and help messages
  static const Icon infoIcon = Icon(Prbal.info);

  /// Notifications and alerts
  /// Using custom Prbal icon for brand consistency
  static const Icon notificationIcon = Icon(Prbal.notificationImportant);

  /// Loading and progress indicators
  static const Icon loadingIcon = Icon(Prbal.hourglassEmpty);

  // =============================================================================
  // MEDIA & ENTERTAINMENT ICONS
  // =============================================================================

  /// Video/Movie content
  /// Using custom Prbal icon for brand consistency
  static const Icon videoIcon = Icon(Prbal.movie);

  /// Audio/Music content
  /// Using custom Prbal icon for brand consistency
  static const Icon audioIcon = Icon(Prbal.musicNote);

  /// Image/Photo content
  static const Icon imageIcon = Icon(Prbal.image);

  /// Camera functionality
  static const Icon cameraIcon = Icon(Prbal.camera);

  /// Gallery/Collection view
  /// Using custom Prbal icon for brand consistency
  static const Icon galleryIcon = Icon(Prbal.collections);

  // =============================================================================
  // COMMUNICATION ICONS
  // =============================================================================

  /// Phone call functionality
  /// Using custom Prbal icon for brand consistency
  static const Icon phoneIcon = Icon(Prbal.call);

  /// Email/Message communication
  /// Using custom Prbal icon for brand consistency
  static const Icon emailIcon = Icon(Prbal.email);

  /// Chat/Messaging
  /// Using custom Prbal icon for brand consistency
  static const Icon chatIcon = Icon(Prbal.chat);

  /// Video call functionality
  /// Using custom Prbal icon for brand consistency
  static const Icon videoCallIcon = Icon(Prbal.videoCall);

  // =============================================================================
  // BUSINESS & FINANCE ICONS
  // =============================================================================

  /// Payment and financial transactions
  /// Using custom Prbal icon for brand consistency
  static const Icon paymentIcon = Icon(Prbal.attachMoney);

  /// Business and corporate features
  /// Using custom Prbal icon for brand consistency
  static const Icon businessIcon = Icon(Prbal.business);

  /// Shopping and commerce
  /// Using custom Prbal icon for brand consistency
  static const Icon shoppingIcon = Icon(Prbal.shoppingBasket);

  /// Analytics and reporting
  /// Using custom Prbal icon for brand consistency
  static const Icon analyticsIcon = Icon(Prbal.barChart);

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  /// Get icon by category for dynamic icon selection
  ///
  /// Useful for programmatically selecting icons based on content type
  /// or user preferences.
  ///
  /// Example: PrbalIconManager().getIconByCategory('error')
  Icon? getIconByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'error':
        debugLogIconUsage('error_category_accessed');
        return errorIcon;
      case 'warning':
        debugLogIconUsage('warning_category_accessed');
        return warningIcon;
      case 'success':
        debugLogIconUsage('success_category_accessed');
        return successIcon;
      case 'info':
        debugLogIconUsage('info_category_accessed');
        return infoIcon;
      case 'home':
        debugLogIconUsage('home_category_accessed');
        return homeIcon;
      case 'settings':
        debugLogIconUsage('settings_category_accessed');
        return settingsIcon;
      default:
        debugPrint('⚠️ Unknown icon category: $category');
        return null;
    }
  }

  /// Get themed icon based on current brightness
  ///
  /// Returns appropriate icon variant for current theme mode
  Icon getThemedIcon(
    BuildContext context, {
    required Icon lightIcon,
    required Icon darkIcon,
  }) {
    final brightness = Theme.of(context).brightness;
    final selectedIcon = brightness == Brightness.dark ? darkIcon : lightIcon;

    debugPrint(
        '🎨 PrbalIconManager: getThemedIcon - brightness: ${brightness.name}');
    debugLogIconUsage('themed_icon_${brightness.name}');
    return selectedIcon;
  }

  /// Create theme-aware icon with ThemeManager primary color
  Widget createPrimaryIcon(
    BuildContext context,
    IconData iconData, {
    double? size,
  }) {
    debugPrint(
        '🎨 PrbalIconManager: Creating primary icon with color: ${ThemeManager.of(context).primaryColor}');

    return Icon(
      iconData,
      color: ThemeManager.of(context).primaryColor,
      size: size,
    );
  }

  /// Create theme-aware icon with ThemeManager secondary color
  Widget createSecondaryIcon(
    BuildContext context,
    IconData iconData, {
    double? size,
  }) {
    debugPrint(
        '🎨 PrbalIconManager: Creating secondary icon with text secondary color');

    return Icon(
      iconData,
      color: ThemeManager.of(context).textSecondary,
      size: size,
    );
  }

  /// Create theme-aware success icon
  Widget createSuccessIcon(
    BuildContext context,
    IconData iconData, {
    double? size,
  }) {
    debugPrint(
        '🎨 PrbalIconManager: Creating success icon with color: ${ThemeManager.of(context).successColor}');

    return Icon(
      iconData,
      color: ThemeManager.of(context).successColor,
      size: size,
    );
  }

  /// Create theme-aware error icon
  Widget createErrorIcon(
    BuildContext context,
    IconData iconData, {
    double? size,
  }) {
    debugPrint(
        '🎨 PrbalIconManager: Creating error icon with color: ${ThemeManager.of(context).errorColor}');

    return Icon(
      iconData,
      color: ThemeManager.of(context).errorColor,
      size: size,
    );
  }

  /// Create theme-aware warning icon
  Widget createWarningIcon(
    BuildContext context,
    IconData iconData, {
    double? size,
  }) {
    debugPrint(
        '🎨 PrbalIconManager: Creating warning icon with color: ${ThemeManager.of(context).warningColor}');

    return Icon(
      iconData,
      color: ThemeManager.of(context).warningColor,
      size: size,
    );
  }

  /// Create theme-aware info icon
  Widget createInfoIcon(
    BuildContext context,
    IconData iconData, {
    double? size,
  }) {
    debugPrint(
        '🎨 PrbalIconManager: Creating info icon with color: ${ThemeManager.of(context).infoColor}');

    return Icon(
      iconData,
      color: ThemeManager.of(context).infoColor,
      size: size,
    );
  }

  /// Create styled icon container with ThemeManager surface styling
  Widget createStyledIconContainer(
    BuildContext context,
    IconData iconData, {
    double? iconSize,
    double? containerSize,
    Color? iconColor,
    bool usePrimaryGradient = false,
  }) {
    final effectiveIconColor =
        iconColor ?? ThemeManager.of(context).textPrimary;
    final effectiveContainerSize = containerSize ?? 48.0;
    final effectiveIconSize = iconSize ?? 24.0;

    debugPrint(
        '🎨 PrbalIconManager: Creating styled container with surface styling');

    return Container(
      width: effectiveContainerSize,
      height: effectiveContainerSize,
      decoration: BoxDecoration(
        gradient: usePrimaryGradient
            ? ThemeManager.of(context).primaryGradient
            : ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: ThemeManager.of(context).subtleShadow,
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1.0,
        ),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: usePrimaryGradient ? Colors.white : effectiveIconColor,
          size: effectiveIconSize,
        ),
      ),
    );
  }

  /// Create floating action button style icon with ThemeManager styling
  Widget createFloatingIcon(
    BuildContext context,
    IconData iconData, {
    double? iconSize,
    double? containerSize,
    VoidCallback? onTap,
  }) {
    final effectiveContainerSize = containerSize ?? 56.0;
    final effectiveIconSize = iconSize ?? 28.0;

    debugPrint(
        '🎨 PrbalIconManager: Creating floating icon with primary gradient');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: effectiveContainerSize,
        height: effectiveContainerSize,
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).primaryGradient,
          borderRadius: BorderRadius.circular(effectiveContainerSize / 2),
          boxShadow: ThemeManager.of(context).primaryShadow,
        ),
        child: Center(
          child: Icon(
            iconData,
            color: Colors.white,
            size: effectiveIconSize,
          ),
        ),
      ),
    );
  }

  /// Create status icon with appropriate ThemeManager semantic colors
  Widget createStatusIcon(
    BuildContext context,
    String status,
    IconData iconData, {
    double? size,
  }) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'active':
        statusColor = ThemeManager.of(context).successColor;
        break;
      case 'warning':
      case 'pending':
        statusColor = ThemeManager.of(context).warningColor;
        break;
      case 'error':
      case 'failed':
      case 'inactive':
        statusColor = ThemeManager.of(context).errorColor;
        break;
      case 'info':
      case 'processing':
        statusColor = ThemeManager.of(context).infoColor;
        break;
      default:
        statusColor = ThemeManager.of(context).textSecondary;
    }

    debugPrint(
        '🎨 PrbalIconManager: Creating status icon for "$status" with color: $statusColor');

    return Icon(
      iconData,
      color: statusColor,
      size: size,
    );
  }

  /// ====================================================================
  /// COMPREHENSIVE ICON MAPPING
  /// ====================================================================

  /// Get comprehensive icon map with all available icons
  Map<String, IconData> getComprehensiveIconMap() {
    if (_iconCache != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!).compareTo(_cacheValidity) <
            0) {
      debugPrint(
          '🚀 PrbalIconManager: Using cached icon map (${_iconCache!.length} icons)');
      return _iconCache!;
    }

    debugPrint('🚀 PrbalIconManager: Building comprehensive icon map...');
    final icons = <String, IconData>{};

    // Add all icon categories
    addCoreActionIcons(icons);
    addNavigationIcons(icons);
    addBusinessIcons(icons);
    addTechnologyIcons(icons);
    addCommunicationIcons(icons);
    addMediaIcons(icons);
    addHealthIcons(icons);
    addEducationIcons(icons);
    addFoodIcons(icons);
    addTransportationIcons(icons);
    addHomeIcons(icons);
    addShoppingIcons(icons);
    addWeatherIcons(icons);
    addBrandIcons(icons);
    addUtilityIcons(icons);
    addSocialMediaIcons(icons);
    addDevelopmentIcons(icons);
    addSecurityIcons(icons);
    addSportsIcons(icons);
    addMiscellaneousIcons(icons);

    // Cache the results
    _iconCache = Map<String, IconData>.from(icons);
    _lastCacheTime = DateTime.now();

    debugPrint(
        '🚀 PrbalIconManager: Built comprehensive icon map with ${icons.length} icons');
    return icons;
  }

  /// Get icon by name with comprehensive fallback system
  IconData getIcon(String iconName) {
    debugPrint('🎨 PrbalIconManager.getIcon: Resolving "$iconName"');

    if (iconName.trim().isEmpty) {
      debugPrint(
          '🎨 PrbalIconManager: Empty name, using default database icon');
      return Prbal.database;
    }

    final normalizedName = iconName.toLowerCase().trim();
    final iconMap = getComprehensiveIconMap();

    // Try exact match
    if (iconMap.containsKey(normalizedName)) {
      debugPrint('🎨 PrbalIconManager: ✅ Found exact match for "$iconName"');
      return iconMap[normalizedName]!;
    }

    // Try partial match
    for (final entry in iconMap.entries) {
      if (entry.key.contains(normalizedName) ||
          normalizedName.contains(entry.key)) {
        debugPrint(
            '🎨 PrbalIconManager: ✅ Found partial match "${entry.key}" for "$iconName"');
        return entry.value;
      }
    }

    // Category-based fallback
    final categoryIcon = getCategoryBasedIcon(normalizedName);
    if (categoryIcon != null) {
      debugPrint(
          '🎨 PrbalIconManager: ✅ Found category-based icon for "$iconName"');
      return categoryIcon;
    }

    // Default fallback
    debugPrint(
        '🎨 PrbalIconManager: ⚠️ No match found for "$iconName", using default database icon');
    return Prbal.database;
  }

  /// ====================================================================
  /// ICON SEARCH & SUGGESTIONS
  /// ====================================================================

  /// Search icons with fuzzy matching
  Map<String, IconData> searchIcons(String query) {
    debugPrint('🔍 PrbalIconManager.searchIcons: Searching for "$query"');

    if (query.trim().isEmpty) {
      return getComprehensiveIconMap();
    }

    final normalizedQuery = query.toLowerCase().trim();
    final allIcons = getComprehensiveIconMap();
    final results = <String, IconData>{};

    // Exact matches first
    for (final entry in allIcons.entries) {
      if (entry.key == normalizedQuery) {
        results[entry.key] = entry.value;
      }
    }

    // Partial matches
    for (final entry in allIcons.entries) {
      if (entry.key.contains(normalizedQuery) &&
          !results.containsKey(entry.key)) {
        results[entry.key] = entry.value;
        if (results.length >= 20) break; // Limit results
      }
    }

    debugPrint(
        '🔍 PrbalIconManager: Found ${results.length} matches for "$query"');
    return results;
  }

  /// ====================================================================
  /// ICON VALIDATION
  /// ====================================================================

  /// Validate icon name with detailed feedback
  Map<String, dynamic> validateIconName(String iconName) {
    debugPrint('✅ PrbalIconManager.validateIconName: Validating "$iconName"');

    final result = <String, dynamic>{
      'isValid': false,
      'iconName': iconName,
      'exists': false,
      'suggestions': <String>[],
      'alternatives': <String>[],
      'confidence': 0.0,
    };

    if (iconName.trim().isEmpty) {
      result['suggestions'] = [
        'home',
        'user',
        'settings',
        'search',
        'database'
      ];
      return result;
    }

    final allIcons = getComprehensiveIconMap();
    final normalizedName = iconName.toLowerCase().trim();

    // Check direct existence
    if (allIcons.containsKey(normalizedName)) {
      result['isValid'] = true;
      result['exists'] = true;
      result['confidence'] = 1.0;
      return result;
    }

    // Find suggestions
    final suggestions = <String>[];
    final alternatives = <String>[];

    for (final availableIcon in allIcons.keys) {
      if (availableIcon.contains(normalizedName)) {
        suggestions.add(availableIcon);
      } else if (calculateSimilarity(normalizedName, availableIcon) > 0.6) {
        alternatives.add(availableIcon);
      }
    }

    result['suggestions'] = suggestions.take(5).toList();
    result['alternatives'] = alternatives.take(5).toList();
    result['confidence'] =
        suggestions.isNotEmpty ? 0.8 : (alternatives.isNotEmpty ? 0.6 : 0.0);

    debugPrint('✅ PrbalIconManager: Icon "$iconName" not found');
    debugPrint(
        '✅ PrbalIconManager: Suggestions: ${suggestions.take(3).join(', ')}');

    return result;
  }

  /// ====================================================================
  /// HELPER METHODS
  /// ====================================================================

  /// Get category-based icon fallback
  IconData? getCategoryBasedIcon(String category) {
    final categoryMap = {
      'house': Prbal.home8,
      'home': Prbal.home8,
      'cleaning': Prbal.home8,
      'service': Prbal.wrench,
      'business': Prbal.briefcase,
      'work': Prbal.briefcase,
      'technology': Prbal.laptop,
      'tech': Prbal.laptop,
      'communication': Prbal.message,
      'media': Prbal.movie,
      'health': Prbal.heart,
      'education': Prbal.book,
      'food': Prbal.restaurant,
      'transport': Prbal.drive2,
      'shopping': Prbal.store1,
      'weather': Prbal.rain1,
      'security': Prbal.lock4,
      'sports': Prbal.race,
    };

    for (final entry in categoryMap.entries) {
      if (category.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  /// Calculate string similarity for suggestions
  double calculateSimilarity(String a, String b) {
    if (a == b) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final longer = a.length > b.length ? a : b;
    final shorter = a.length > b.length ? b : a;

    if (longer.isEmpty) return 1.0;

    // Simple similarity calculation
    int matches = 0;
    for (int i = 0; i < shorter.length; i++) {
      if (i < longer.length && shorter[i] == longer[i]) {
        matches++;
      }
    }

    return matches / longer.length;
  }

  /// ====================================================================
  /// ICON CATEGORY MAPPING METHODS
  /// ====================================================================

  /// Add core action icons to the map
  void addCoreActionIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding core action icons');
    icons.addAll({
      'add': Prbal.add1,
      'edit': Prbal.edit,
      'delete': Prbal.delete,
      'save': Prbal.save4,
      'search': Prbal.search6,
      'filter': Prbal.filter,
      'share': Prbal.share,
      'favorite': Prbal.favorite,
      'download': Prbal.download7,
      'upload': Prbal.upload,
      'copy': Prbal.copy4,
      'cut': Prbal.cut1,
      'create': Prbal.create1,
      'finish': Prbal.finish,
      'open': Prbal.open,
      'close': Prbal.close2,
      'print': Prbal.print2,
      'redo': Prbal.redo3,
      'undo': Prbal.undo,
    });
  }

  /// Add navigation icons to the map
  void addNavigationIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding navigation icons');
    icons.addAll({
      'home': Prbal.home8,
      'menu': Prbal.menu,
      'back': Prbal.arrowBack,
      'forward': Prbal.forward7,
      'navigate': Prbal.navigate,
      'explore': Prbal.explore2,
      'go': Prbal.go1,
      'enter': Prbal.enter1,
      'pin': Prbal.pin3,
      'locate': Prbal.locate,
      'point': Prbal.point,
      'direction': Prbal.navigate,
    });
  }

  /// Add business icons to the map
  void addBusinessIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding business icons');
    icons.addAll({
      'briefcase': Prbal.business,
      'business': Prbal.business,
      'work': Prbal.business,
      'office': Prbal.business,
      'pay': Prbal.pay,
      'money': Prbal.attachMoney,
      'shopping': Prbal.shoppingBasket,
      'store': Prbal.store1,
      'analytics': Prbal.barChart,
      'chart': Prbal.barChart,
      'report': Prbal.report1,
      'performance': Prbal.perform,
      'produce': Prbal.produce,
    });
  }

  /// Add technology icons to the map
  void addTechnologyIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding technology icons');
    icons.addAll({
      'laptop': Prbal.laptop,
      'computer': Prbal.laptop,
      'mobile': Prbal.mobile,
      'phone': Prbal.call1,
      'code': Prbal.code5,
      'develop': Prbal.develop,
      'hack': Prbal.hack,
      'power': Prbal.power3,
      'plug': Prbal.plug1,
      'charge': Prbal.charge,
      'connect': Prbal.connect,
      'link': Prbal.link5,
      'merge': Prbal.merge,
    });
  }

  /// Add communication icons to the map
  void addCommunicationIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding communication icons');
    icons.addAll({
      'message': Prbal.message,
      'chat': Prbal.chat,
      'call': Prbal.call1,
      'email': Prbal.email,
      'send': Prbal.send4,
      'reply': Prbal.reply5,
      'ask': Prbal.ask,
      'listen': Prbal.listen,
      'sound': Prbal.sound3,
      'broadcast': Prbal.broadcast,
      'ping': Prbal.ping,
    });
  }

  /// Add media icons to the map
  void addMediaIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding media icons');
    icons.addAll({
      'movie': Prbal.movie,
      'film': Prbal.film4,
      'video': Prbal.movie,
      'music': Prbal.musicNote,
      'audio': Prbal.musicNote,
      'image': Prbal.image,
      'photo': Prbal.photograph,
      'camera': Prbal.camera,
      'gallery': Prbal.collections,
      'record': Prbal.record,
      'pause': Prbal.pause5,
      'play': Prbal.play,
      'stop': Prbal.stop3,
      'rewind': Prbal.rewind1,
    });
  }

  /// Add health icons to the map
  void addHealthIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding health icons');
    icons.addAll({
      'heart': Prbal.heart,
      'health': Prbal.heart,
      'medical': Prbal.medicalServices,
      'hospital': Prbal.localHospital,
      'doctor': Prbal.person,
      'fitness': Prbal.fit,
      'exercise': Prbal.fit,
      'wellness': Prbal.heart,
    });
  }

  /// Add education icons to the map
  void addEducationIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding education icons');
    icons.addAll({
      'book': Prbal.book,
      'education': Prbal.book,
      'school': Prbal.school,
      'learn': Prbal.book,
      'study': Prbal.book,
      'library': Prbal.book,
      'course': Prbal.book,
      'lesson': Prbal.book,
    });
  }

  /// Add food icons to the map
  void addFoodIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding food icons');
    icons.addAll({
      'restaurant': Prbal.restaurant,
      'food': Prbal.restaurant,
      'eat': Prbal.eat,
      'drink': Prbal.drink1,
      'cook': Prbal.cook,
      'bake': Prbal.bake,
      'barbecue': Prbal.barbecue,
      'caffeinate': Prbal.caffeinate,
      'chop': Prbal.chop,
      'dining': Prbal.restaurant, // Using restaurant as fallback for dining
    });
  }

  /// Add transportation icons to the map
  void addTransportationIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding transportation icons');
    icons.addAll({
      'drive': Prbal.drive2,
      'car': Prbal.drive2,
      'airplane': Prbal.airplane,
      'flight': Prbal.airplane,
      'transport': Prbal.drive2,
      'travel': Prbal.airplane,
      'vehicle': Prbal.drive2,
    });
  }

  /// Add home icons to the map
  void addHomeIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding home icons');
    icons.addAll({
      'house': Prbal.home8,
      'home': Prbal.home8,
      'furniture': Prbal.home8, // Using home as fallback for furniture
      'accommodate': Prbal.accommodate,
      'cleaning': Prbal.home8,
      'maintenance': Prbal.home8,
    });
  }

  /// Add shopping icons to the map
  void addShoppingIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding shopping icons');
    icons.addAll({
      'shopping': Prbal.shoppingBasket,
      'store': Prbal.store1,
      'market': Prbal.store1,
      'buy': Prbal.shoppingBasket,
      'purchase': Prbal.shoppingBasket,
      'basket': Prbal.shoppingBasket,
      'cart': Prbal.shoppingBasket,
    });
  }

  /// Add weather icons to the map
  void addWeatherIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding weather icons');
    icons.addAll({
      'rain': Prbal.rain1,
      'weather': Prbal.rain1,
      'sun': Prbal.wbSunny,
      'sunny': Prbal.wbSunny,
      'cloud': Prbal.cloud,
      'storm': Prbal.rain1,
    });
  }

  /// Add brand icons to the map
  void addBrandIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding brand icons');
    icons.addAll({
      'brand': Prbal.star,
      'logo': Prbal.star,
      'badge': Prbal.star,
      'award': Prbal.star,
      'trophy': Prbal.star,
    });
  }

  /// Add utility icons to the map
  void addUtilityIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding utility icons');
    icons.addAll({
      'settings': Prbal.cogOutline,
      'tools': Prbal.wrench,
      'wrench': Prbal.wrench,
      'hammer': Prbal.hammer1,
      'build': Prbal.build1,
      'repair': Prbal.wrench,
      'fix': Prbal.wrench,
      'utility': Prbal.wrench,
    });
  }

  /// Add social media icons to the map
  void addSocialMediaIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding social media icons');
    icons.addAll({
      'social': Prbal.share,
      'share': Prbal.share,
      'like': Prbal.favorite,
      'love': Prbal.love,
      'follow': Prbal.person,
      'connect': Prbal.connect,
      'network': Prbal.connect,
    });
  }

  /// Add development icons to the map
  void addDevelopmentIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding development icons');
    icons.addAll({
      'code': Prbal.code5,
      'develop': Prbal.develop,
      'programming': Prbal.code5,
      'software': Prbal.code5,
      'app': Prbal.code5,
      'debug': Prbal.code5,
      'test': Prbal.code5,
    });
  }

  /// Add security icons to the map
  void addSecurityIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding security icons');
    icons.addAll({
      'lock': Prbal.lock4,
      'security': Prbal.shield,
      'shield': Prbal.shield,
      'protect': Prbal.protect,
      'defend': Prbal.defend,
      'safe': Prbal.lock4,
      'private': Prbal.lock4,
    });
  }

  /// Add sports icons to the map
  void addSportsIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding sports icons');
    icons.addAll({
      'race': Prbal.race,
      'sports': Prbal.race,
      'run': Prbal.race,
      'swim': Prbal.swim,
      'climb': Prbal.climb,
      'game': Prbal.game,
      'play': Prbal.game,
      'compete': Prbal.race,
    });
  }

  /// Add miscellaneous icons to the map
  void addMiscellaneousIcons(Map<String, IconData> icons) {
    debugPrint('🎨 PrbalIconManager: Adding miscellaneous icons');
    icons.addAll({
      'list': Prbal.database,
      'misc': Prbal.database,
      'other': Prbal.database,
      'general': Prbal.database,
      'default': Prbal.database,
      'unknown': Prbal.database,
      'question': Prbal.help,
      'info': Prbal.info,
      'help': Prbal.help,
      'support': Prbal.help,
    });
  }
}
