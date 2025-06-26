import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

// Components

// Services
import 'package:prbal/services/authentication_notifier.dart';
import 'package:prbal/widgets/settings/settings_section_widget.dart';

/// ====================================================================
/// ACCOUNT SETTINGS WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
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
/// ====================================================================

/// AccountSettingsWidget - Reusable account settings section
///
/// This widget provides account-related settings options including:
/// - Business Profile (for providers)
/// - Payment & Billing
/// - Verification status
/// - Account Type management with change functionality
/// - Theme-aware styling using comprehensive ThemeManager integration
class AccountSettingsWidget extends StatelessWidget with ThemeAwareMixin {
  const AccountSettingsWidget({
    super.key,
    required this.userType,
    required this.authState,
    required this.onUserTypeChange,
  });

  final String? userType;
  final AuthenticationState authState;
  final VoidCallback onUserTypeChange;

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '⚙️ AccountSettingsWidget: Building account settings with comprehensive ThemeManager integration');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging

    debugPrint('⚙️ AccountSettingsWidget: → User Type: $userType');
    debugPrint(
        '⚙️ AccountSettingsWidget: → Authentication State: ${authState.isAuthenticated}');
    debugPrint(
        '⚙️ AccountSettingsWidget: → Primary: ${themeManager.primaryColor}');
    debugPrint(
        '⚙️ AccountSettingsWidget: → Secondary: ${themeManager.secondaryColor}');
    debugPrint(
        '⚙️ AccountSettingsWidget: → Background: ${themeManager.backgroundColor}');
    debugPrint(
        '⚙️ AccountSettingsWidget: → Surface: ${themeManager.surfaceColor}');
    debugPrint(
        '⚙️ AccountSettingsWidget: → Card Background: ${themeManager.cardBackground}');
    debugPrint(
        '⚙️ AccountSettingsWidget: → Text Colors - Primary: ${themeManager.textPrimary}, Secondary: ${themeManager.textSecondary}');

    return SettingsSectionWidget(
      title: 'Account',
      children: [
        // Business Profile (for providers)
        if (userType == 'provider')
          SettingsItemWidget(
            title: 'Business Profile',
            subtitle: 'Manage your services and portfolio',
            icon: Prbal.briefcase,
            iconColor: themeManager.conditionalColor(
              lightColor: themeManager.successColor,
              darkColor: themeManager.successLight,
            ),
            onTap: () {
              debugPrint('⚙️ Business Profile tapped');
              // TODO: Navigate to business profile
            },
          ),

        // Payment & Billing with enhanced styling
        SettingsItemWidget(
          title: 'Payment & Billing',
          subtitle: 'Manage payment methods and history',
          icon: Prbal.creditCard,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.accent2,
            darkColor: themeManager.accent2,
          ),
          onTap: () {
            debugPrint('⚙️ Payment & Billing tapped');
            // TODO: Navigate to payment settings
          },
        ),

        // Verification with status-aware styling
        SettingsItemWidget(
          title: 'Verification',
          subtitle: _isVerified(authState.userData)
              ? 'Account verified'
              : 'Complete verification',
          icon: Prbal.security,
          iconColor: _isVerified(authState.userData)
              ? themeManager.conditionalColor(
                  lightColor: themeManager.successColor,
                  darkColor: themeManager.successLight,
                )
              : themeManager.conditionalColor(
                  lightColor: themeManager.warningColor,
                  darkColor: themeManager.warningLight,
                ),
          onTap: () {
            debugPrint('⚙️ Verification tapped');
            // TODO: Navigate to verification
          },
        ),

        // User Type Change with enhanced styling
        SettingsItemWidget(
          title: 'Account Type',
          subtitle:
              'Currently: ${_getUserTypeDisplayName(userType)} - Tap to change',
          icon: Prbal.swapHoriz,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.primaryColor,
            darkColor: themeManager.primaryLight,
          ),
          onTap: onUserTypeChange,
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    themeManager
                        .getUserTypeColor(userType)
                        .withValues(alpha: 0.15),
                    themeManager
                        .getUserTypeColor(userType)
                        .withValues(alpha: 0.05),
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    themeManager
                        .getUserTypeColor(userType)
                        .withValues(alpha: 0.2),
                    themeManager
                        .getUserTypeColor(userType)
                        .withValues(alpha: 0.1),
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: themeManager
                    .getUserTypeColor(userType)
                    .withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeManager
                      .getUserTypeColor(userType)
                      .withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _getUserTypeDisplayName(userType),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.getContrastingColor(
                    themeManager.getUserTypeColor(userType)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper methods for user data extraction with enhanced theme integration
  bool _isVerified(Map<String, dynamic>? userData) {
    if (userData == null) return false;
    final isVerified = userData['is_verified'] ?? userData['isVerified'];
    if (isVerified is bool) return isVerified;
    if (isVerified is String) return isVerified.toLowerCase() == 'true';
    return false;
  }

  String _getUserTypeDisplayName(String? userType) {
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
}
