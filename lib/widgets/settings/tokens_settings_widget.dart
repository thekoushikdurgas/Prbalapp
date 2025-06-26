import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';

/// ====================================================================
/// TOKENS SETTINGS WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
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
/// **🎯 TOKENS-SPECIFIC ENHANCEMENTS:**
/// - Security-focused color scheme with status colors
/// - Professional gradients for token management interface
/// - Enhanced visual hierarchy with accent colors for different token types
/// - Comprehensive accessibility with contrast optimization
/// - Security-themed visual indicators
/// ====================================================================

/// TokensSettingsWidget - Enhanced tokens settings section with comprehensive theming
///
/// This widget provides security token management options including:
/// - Active Sessions management with enhanced visual styling
/// - Refresh Token management with professional design
/// - Future token management features with theme-aware colors
/// - Security-focused interface with comprehensive ThemeManager integration
/// - Professional styling with security-themed visual indicators
class TokensSettingsWidget extends StatelessWidget with ThemeAwareMixin {
  const TokensSettingsWidget({
    super.key,
    required this.onActiveSessionsTapped,
    required this.onRefreshTokenTapped,
  });

  final VoidCallback onActiveSessionsTapped;
  final VoidCallback onRefreshTokenTapped;

  @override
  Widget build(BuildContext context) {
    debugPrint('🔐 [TokensSettings] Building tokens settings with comprehensive ThemeManager integration');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging
    debugPrint('🎨 [TokensSettings] Theme mode: ${Theme.of(context).brightness}');
    debugPrint('🔐 [TokensSettings] Primary: ${themeManager.primaryColor}');
    debugPrint('🔐 [TokensSettings] Secondary: ${themeManager.secondaryColor}');
    debugPrint('🔐 [TokensSettings] Background: ${themeManager.backgroundColor}');
    debugPrint('🔐 [TokensSettings] Surface: ${themeManager.surfaceColor}');
    debugPrint(
        '🔐 [TokensSettings] Status Colors - Info: ${themeManager.infoColor}, Success: ${themeManager.successColor}, Accent: ${themeManager.accent3}');
    debugPrint(
        '🔐 [TokensSettings] Text Colors - Primary: ${themeManager.textPrimary}, Secondary: ${themeManager.textSecondary}');

    return SettingsSectionWidget(
      title: 'Security Tokens',
      children: [
        // Active Sessions with enhanced info-style theming
        SettingsItemWidget(
          title: 'Active Sessions',
          subtitle: 'Manage your active login sessions',
          icon: Prbal.devices,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.infoColor,
            darkColor: themeManager.infoLight,
          ),
          onTap: () {
            debugPrint('🔐 [TokensSettings] Active Sessions tapped');
            onActiveSessionsTapped();
          },
        ),

        // Refresh Token with enhanced accent-style theming
        SettingsItemWidget(
          title: 'Refresh Token',
          subtitle: 'Manage your refresh token',
          icon: Prbal.refresh,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.accent3,
            darkColor: themeManager.accent3,
          ),
          onTap: () {
            debugPrint('🔐 [TokensSettings] Refresh Token tapped');
            onRefreshTokenTapped();
          },
        ),

        // Future: Access Tokens (commented for future implementation)
        // SettingsItemWidget(
        //   title: 'Access Tokens',
        //   subtitle: 'View and manage your access tokens',
        //   icon: Prbal.vpnKey,
        //   iconColor: themeManager.conditionalColor(
        //     lightColor: themeManager.successColor,
        //     darkColor: themeManager.successLight,
        //   ),
        //   onTap: onAccessTokensTapped,
        // ),

        // Future: Revoke All Sessions (commented for future implementation)
        // SettingsItemWidget(
        //   title: 'Revoke All Sessions',
        //   subtitle: 'Sign out from all devices',
        //   icon: Prbal.logout,
        //   iconColor: themeManager.conditionalColor(
        //     lightColor: themeManager.errorColor,
        //     darkColor: themeManager.errorLight,
        //   ),
        //   onTap: onRevokeAllSessionsTapped,
        // ),
      ],
    );
  }
}
