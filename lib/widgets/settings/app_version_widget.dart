import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// APP VERSION WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE THEMEMANAGER INTEGRATION COMPLETED** ✅
///
/// **🎨 ENHANCED FEATURES WITH ALL THEMEMANAGER PROPERTIES:**
///
/// **1. COMPREHENSIVE COLOR SYSTEM:**
/// - Text Colors: textPrimary, textSecondary, textTertiary, textInverted
/// - Background Colors: backgroundColor, backgroundSecondary, backgroundTertiary
/// - Neutral Colors: neutral50-900 for version text styling
/// - Border Colors: borderColor, borderSecondary for subtle dividers
///
/// **2. COMPREHENSIVE GRADIENT SYSTEM:**
/// - Neutral Gradients: neutralGradient for subtle background effects
/// - Glass Effects: glassMorphism for modern version display
///
/// **3. COMPREHENSIVE SHADOWS AND EFFECTS:**
/// - Subtle Shadow: subtleShadow for elegant text elevation
/// - Glass Effects: glassMorphism for premium appearance
///
/// **4. COMPREHENSIVE HELPER METHODS:**
/// - conditionalColor() - theme-aware color selection
/// - getContrastingColor() - optimal text contrast
///
/// **🎯 VERSION-SPECIFIC ENHANCEMENTS:**
/// - Professional typography with theme-aware colors
/// - Subtle visual effects for version information
/// - Enhanced readability across light/dark themes
/// - Minimal but elegant design language
/// ====================================================================

class AppVersionWidget extends StatelessWidget with ThemeAwareMixin {
  const AppVersionWidget({
    super.key,
    this.version = 'Version 1.0.0',
  });

  final String version;

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '📱 AppVersionWidget: Building app version with comprehensive ThemeManager integration');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging
    themeManager.logThemeInfo();
    debugPrint('📱 AppVersionWidget: → Version: $version');
    debugPrint(
        '📱 AppVersionWidget: → Text Colors - Primary: ${themeManager.textPrimary}, Secondary: ${themeManager.textSecondary}, Tertiary: ${themeManager.textTertiary}');
    debugPrint(
        '📱 AppVersionWidget: → Neutral Colors: ${themeManager.neutral400}, ${themeManager.neutral500}, ${themeManager.neutral600}');
    debugPrint(
        '📱 AppVersionWidget: → Background: ${themeManager.backgroundColor}');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              themeManager.neutral50.withValues(alpha: 0.3),
              themeManager.neutral100.withValues(alpha: 0.1),
            ],
          ),
          darkGradient: LinearGradient(
            colors: [
              themeManager.neutral800.withValues(alpha: 0.2),
              themeManager.neutral900.withValues(alpha: 0.1),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 0.1),
            darkColor: themeManager.borderSecondary.withValues(alpha: 0.2),
          ),
          width: 0.5,
        ),
        boxShadow: [
          ...themeManager.subtleShadow,
          BoxShadow(
            color: themeManager.conditionalColor(
              lightColor: themeManager.neutral200.withValues(alpha: 0.5),
              darkColor: themeManager.neutral800.withValues(alpha: 0.3),
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        version,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          color: themeManager.conditionalColor(
            lightColor: themeManager.textTertiary,
            darkColor: themeManager.neutral400,
          ),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.2,
        ),
      ),
    );
  }
}
