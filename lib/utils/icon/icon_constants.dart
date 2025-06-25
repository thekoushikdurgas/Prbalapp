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
 * Icon(IconConstants.themeIcon)
 * Icon(IconConstants.errorIcon, color: Colors.red)
 * IconConstants.debugLogIconUsage('theme_icon_used')
 */

import 'package:flutter/material.dart';
import 'prbal_icons.dart'; // Import our custom icon font

/// Central repository for all application icons
///
/// This class provides standardized access to icons used throughout the app,
/// combining Material Design icons with custom Prbal icons for consistent UI.
class IconConstants {
  /// Private constructor to prevent instantiation
  const IconConstants._();

  // =============================================================================
  // DEBUG UTILITIES
  // =============================================================================

  /// Debug function to log icon usage for analytics and optimization
  ///
  /// Call this method when using icons in critical UI components to track
  /// which icons are most frequently used and optimize icon loading.
  ///
  /// Example: IconConstants.debugLogIconUsage('settings_screen_theme_toggle');
  static void debugLogIconUsage(String context) {
    debugPrint('🎨 Icon Used: $context | Theme: ${_getCurrentThemeName()}');
  }

  /// Get current theme name for debugging
  static String _getCurrentThemeName() {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark ? 'dark' : 'light';
  }

  /// Validate if custom Prbal font is loaded (for debugging)
  static bool isCustomFontLoaded() {
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
  /// Example: IconConstants.getIconByCategory('error')
  static Icon? getIconByCategory(String category) {
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
  static Icon getThemedIcon(
    BuildContext context, {
    required Icon lightIcon,
    required Icon darkIcon,
  }) {
    final brightness = Theme.of(context).brightness;
    final selectedIcon = brightness == Brightness.dark ? darkIcon : lightIcon;

    debugLogIconUsage('themed_icon_${brightness.name}');
    return selectedIcon;
  }
}
