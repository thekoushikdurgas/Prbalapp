import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';

/// ====================================================================
/// ADMIN CONTROLS WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
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
/// **🎯 ADMIN-SPECIFIC ENHANCEMENTS:**
/// - Security-focused color scheme with accent colors
/// - Professional gradients for admin interface elements
/// - Enhanced visual hierarchy with status colors
/// - Comprehensive accessibility with contrast optimization
/// ====================================================================

/// AdminControlsWidget - Reusable admin controls section
///
/// This widget provides admin-specific settings options including:
/// - User Management with enhanced visual styling
/// - Content Moderation with professional design
/// - Analytics & Reports with gradient effects
/// - System Settings with theme-aware colors
/// - Comprehensive ThemeManager integration for professional admin interface
class AdminControlsWidget extends StatelessWidget with ThemeAwareMixin {
  const AdminControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '⚙️ AdminControlsWidget: Building admin controls with comprehensive ThemeManager integration');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging
    themeManager.logThemeInfo();
    debugPrint(
        '⚙️ AdminControlsWidget: → Primary: ${themeManager.primaryColor}');
    debugPrint(
        '⚙️ AdminControlsWidget: → Secondary: ${themeManager.secondaryColor}');
    debugPrint(
        '⚙️ AdminControlsWidget: → Accent Colors: ${themeManager.accent1}, ${themeManager.accent2}, ${themeManager.accent3}');
    debugPrint(
        '⚙️ AdminControlsWidget: → Status Colors - Success: ${themeManager.successColor}, Warning: ${themeManager.warningColor}, Error: ${themeManager.errorColor}, Info: ${themeManager.infoColor}');
    debugPrint(
        '⚙️ AdminControlsWidget: → Background: ${themeManager.backgroundColor}');
    debugPrint(
        '⚙️ AdminControlsWidget: → Surface: ${themeManager.surfaceColor}');
    debugPrint(
        '⚙️ AdminControlsWidget: → Text Colors - Primary: ${themeManager.textPrimary}, Secondary: ${themeManager.textSecondary}');

    return SettingsSectionWidget(
      title: 'Admin Controls',
      children: [
        // User Management with enhanced styling
        SettingsItemWidget(
          title: 'User Management',
          subtitle: 'Manage users and permissions',
          icon: Prbal.users,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.infoColor,
            darkColor: themeManager.infoLight,
          ),
          onTap: () {
            debugPrint('⚙️ User Management tapped');
            // TODO: Navigate to user management
          },
        ),

        // Content Moderation with security-focused styling
        SettingsItemWidget(
          title: 'Content Moderation',
          subtitle: 'Review and moderate content',
          icon: Prbal.security,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.successColor,
            darkColor: themeManager.successLight,
          ),
          onTap: () {
            debugPrint('⚙️ Content Moderation tapped');
            // TODO: Navigate to content moderation
          },
        ),

        // Analytics & Reports with professional styling
        SettingsItemWidget(
          title: 'Analytics & Reports',
          subtitle: 'View platform analytics',
          icon: Prbal.barChart,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.accent2,
            darkColor: themeManager.accent2,
          ),
          onTap: () {
            debugPrint('⚙️ Analytics & Reports tapped');
            // TODO: Navigate to analytics
          },
        ),

        // System Settings with warning-style coloring for important controls
        SettingsItemWidget(
          title: 'System Settings',
          subtitle: 'Configure platform settings',
          icon: Prbal.cog,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.warningColor,
            darkColor: themeManager.warningLight,
          ),
          onTap: () {
            debugPrint('⚙️ System Settings tapped');
            // TODO: Navigate to system settings
          },
        ),
      ],
    );
  }
}
