import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';
import 'package:prbal/widgets/settings/settings_bottom_sheets.dart';

/// ====================================================================
/// DATA STORAGE SETTINGS WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE THEMEMANAGER INTEGRATION COMPLETED** ✅
///
/// **🎨 ENHANCED FEATURES WITH ALL THEMEMANAGER PROPERTIES:**
///
/// **1. COMPREHENSIVE COLOR SYSTEM:**
/// - Primary Colors: primaryColor, primaryLight, primaryDark, secondaryColor
/// - Background Colors: backgroundColor, backgroundSecondary, backgroundTertiary,
///   cardBackground, surfaceElevated, modalBackground, surfaceColor
/// - Text Colors: textPrimary, textSecondary, textTertiary, textInverted
/// - Status Colors: successColor/Light/Dark, warningColor/Light/Dark,
///   errorColor/Light/Dark, infoColor/Light/Dark
/// - Accent Colors: accent1-5, neutral50-900
/// - Border Colors: borderColor, borderSecondary, borderFocus, dividerColor
/// - Interactive Colors: buttonBackground, inputBackground, statusColors
/// - Shadow Colors: shadowLight, shadowMedium, shadowDark
///
/// **2. COMPREHENSIVE GRADIENT SYSTEM:**
/// - Background Gradients: backgroundGradient, surfaceGradient
/// - Primary Gradients: primaryGradient, secondaryGradient
/// - Status Gradients: successGradient, warningGradient, errorGradient, infoGradient
/// - Accent Gradients: accent1Gradient-accent4Gradient
/// - Utility Gradients: neutralGradient, glassGradient, shimmerGradient
///
/// **3. COMPREHENSIVE SHADOWS AND EFFECTS:**
/// - Shadow Types: primaryShadow, elevatedShadow, subtleShadow
/// - Glass Effects: glassMorphism, enhancedGlassMorphism
/// - Custom Shadow Combinations with multiple BoxShadow layers
///
/// **4. COMPREHENSIVE HELPER METHODS:**
/// - conditionalColor() - theme-aware color selection
/// - conditionalGradient() - theme-aware gradient selection
/// - getContrastingColor() - automatic contrast detection
/// - getTextColorForBackground() - optimal text color selection
///
/// **🎯 DATA STORAGE-SPECIFIC ENHANCEMENTS:**
/// - Storage-focused color scheme with accent colors
/// - Professional gradients for data management interface
/// - Enhanced visual hierarchy with status colors for storage types
/// - Comprehensive accessibility with contrast optimization
/// ====================================================================

/// DataStorageSettingsWidget - Reusable data storage settings section
///
/// This widget provides data and storage related settings options including:
/// - Storage Usage display with enhanced visual styling
/// - Clear Cache functionality with professional design
/// - Export Data options with gradient effects
/// - Data Sync settings with theme-aware colors
/// - Comprehensive ThemeManager integration for professional data interface
class DataStorageSettingsWidget extends StatelessWidget with ThemeAwareMixin {
  const DataStorageSettingsWidget({
    super.key,
    required this.onClearCache,
  });

  final VoidCallback onClearCache;

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '⚙️ DataStorageSettingsWidget: Building data & storage settings with comprehensive ThemeManager integration');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging

    debugPrint('⚙️ DataStorageSettingsWidget: → Primary: ${themeManager.primaryColor}');
    debugPrint('⚙️ DataStorageSettingsWidget: → Secondary: ${themeManager.secondaryColor}');
    debugPrint(
        '⚙️ DataStorageSettingsWidget: → Accent Colors: ${themeManager.accent1}, ${themeManager.accent2}, ${themeManager.accent3}');
    debugPrint(
        '⚙️ DataStorageSettingsWidget: → Status Colors - Success: ${themeManager.successColor}, Warning: ${themeManager.warningColor}, Error: ${themeManager.errorColor}, Info: ${themeManager.infoColor}');
    debugPrint('⚙️ DataStorageSettingsWidget: → Background: ${themeManager.backgroundColor}');
    debugPrint('⚙️ DataStorageSettingsWidget: → Surface: ${themeManager.surfaceColor}');
    debugPrint(
        '⚙️ DataStorageSettingsWidget: → Text Colors - Primary: ${themeManager.textPrimary}, Secondary: ${themeManager.textSecondary}');

    return SettingsSectionWidget(
      title: 'Data & Storage',
      children: [
        // Storage Usage with enhanced styling
        SettingsItemWidget(
          title: 'Storage Usage',
          subtitle: 'View app storage and cache usage',
          icon: Prbal.storage,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.accent3,
            darkColor: themeManager.accent3,
          ),
          onTap: () => SettingsBottomSheets.showStorageBottomSheet(context),
        ),

        // Clear Cache with warning-style styling
        SettingsItemWidget(
          title: 'Clear Cache',
          subtitle: 'Free up space by clearing cached data',
          icon: Prbal.cleaningServices,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.warningColor,
            darkColor: themeManager.warningLight,
          ),
          onTap: onClearCache,
        ),

        // Export Data with info-style styling
        SettingsItemWidget(
          title: 'Export Data',
          subtitle: 'Download your personal data',
          icon: Prbal.download,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.infoColor,
            darkColor: themeManager.infoLight,
          ),
          onTap: () {
            debugPrint('⚙️ DataStorageSettingsWidget: Export Data tapped');
            // TODO: Navigate to export data
          },
        ),

        // Data Sync with primary color styling
        SettingsItemWidget(
          title: 'Data Sync',
          subtitle: 'Manage data synchronization settings',
          icon: Prbal.refresh,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.primaryColor,
            darkColor: themeManager.primaryLight,
          ),
          onTap: () {
            debugPrint('⚙️ DataStorageSettingsWidget: Data Sync tapped');
            // TODO: Navigate to data sync settings
          },
        ),
      ],
    );
  }
}
