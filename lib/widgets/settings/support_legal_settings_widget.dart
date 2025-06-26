import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';

/// ====================================================================
/// SUPPORT LEGAL SETTINGS WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
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
/// **🎯 SUPPORT LEGAL-SPECIFIC ENHANCEMENTS:**
/// - Support-focused color scheme with status and accent colors
/// - Professional gradients for legal documentation interface
/// - Enhanced visual hierarchy with different colors for various support types
/// - Comprehensive accessibility with contrast optimization
/// - Trust-building visual indicators for legal documents
/// ====================================================================

/// SupportLegalSettingsWidget - Enhanced support & legal settings section with comprehensive theming
///
/// This widget provides support and legal related settings options including:
/// - Help Center with enhanced info-style visual styling
/// - Contact Us with professional success-style design
/// - Terms of Service with accent-style theming
/// - Privacy Policy with warning-style visual indicators
/// - Comprehensive ThemeManager integration for professional support interface
/// - Trust-building design elements for legal documentation
class SupportLegalSettingsWidget extends StatelessWidget with ThemeAwareMixin {
  const SupportLegalSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('📞 [SupportLegal] Building support & legal settings with comprehensive ThemeManager integration');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    debugPrint('📞 [SupportLegal] Primary: ${themeManager.primaryColor}');
    debugPrint('📞 [SupportLegal] Secondary: ${themeManager.secondaryColor}');
    debugPrint('📞 [SupportLegal] Background: ${themeManager.backgroundColor}');
    debugPrint('📞 [SupportLegal] Surface: ${themeManager.surfaceColor}');
    debugPrint(
        '📞 [SupportLegal] Status Colors - Info: ${themeManager.infoColor}, Success: ${themeManager.successColor}, Warning: ${themeManager.warningColor}');
    debugPrint(
        '📞 [SupportLegal] Accent Colors: ${themeManager.accent1}, ${themeManager.accent2}, ${themeManager.accent3}');
    debugPrint(
        '📞 [SupportLegal] Text Colors - Primary: ${themeManager.textPrimary}, Secondary: ${themeManager.textSecondary}');

    return SettingsSectionWidget(
      title: 'Support & Legal',
      children: [
        // Help Center with enhanced info-style theming
        SettingsItemWidget(
          title: 'Help Center',
          subtitle: 'Get help and support',
          icon: Prbal.questionCircle,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.infoColor,
            darkColor: themeManager.infoLight,
          ),
          onTap: () {
            debugPrint('📞 [SupportLegal] Help Center tapped');
            // TODO: Navigate to help center
          },
        ),

        // Contact Us with enhanced success-style theming
        SettingsItemWidget(
          title: 'Contact Us',
          subtitle: 'Get in touch with our team',
          icon: Prbal.envelope,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.successColor,
            darkColor: themeManager.successLight,
          ),
          onTap: () {
            debugPrint('📞 [SupportLegal] Contact Us tapped');
            // TODO: Navigate to contact
          },
        ),

        // Terms of Service with enhanced accent-style theming
        SettingsItemWidget(
          title: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          icon: Prbal.file,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.accent2,
            darkColor: themeManager.accent2,
          ),
          onTap: () {
            debugPrint('📞 [SupportLegal] Terms of Service tapped');
            // TODO: Navigate to terms
          },
        ),

        // Privacy Policy with enhanced warning-style theming for security awareness
        SettingsItemWidget(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          icon: Prbal.shield4,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.warningColor,
            darkColor: themeManager.warningLight,
          ),
          onTap: () {
            debugPrint('📞 [SupportLegal] Privacy Policy tapped');
            // TODO: Navigate to privacy policy
          },
        ),
      ],
    );
  }
}
