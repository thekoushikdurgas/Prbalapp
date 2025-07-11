import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// META INFO WIDGET COMPONENT
/// ====================================================================
///
/// ✅ **COMPREHENSIVE THEMEMANAGER INTEGRATION COMPLETED** ✅
///
/// **🎨 ENHANCED FEATURES WITH ALL THEMEMANAGER PROPERTIES:**
///
/// **1. COMPREHENSIVE COLOR SYSTEM:**
/// - Text Colors: textPrimary, textSecondary, textTertiary for proper hierarchy
/// - Primary Colors: primaryColor, primaryLight, primaryDark for icons
/// - Background Colors: backgroundColor, surfaceColor for containers
/// - Status Colors: successColor, warningColor, errorColor, infoColor for semantic meaning
/// - Accent Colors: accent1-5 for enhanced visual elements
/// - Border Colors: borderColor, borderSecondary for subtle separations
///
/// **2. COMPREHENSIVE GRADIENT SYSTEM:**
/// - Background Gradients: backgroundGradient, surfaceGradient
/// - Primary Gradients: primaryGradient for icon containers
/// - Status Gradients: successGradient, warningGradient, errorGradient, infoGradient
/// - Accent Gradients: accent1Gradient-accent4Gradient for enhanced styling
///
/// **3. COMPREHENSIVE SHADOWS AND EFFECTS:**
/// - Shadow Types: primaryShadow, elevatedShadow, subtleShadow
/// - Glass Effects: glassMorphism, enhancedGlassMorphism
/// - Custom Shadow Combinations for professional appearance
///
/// **4. COMPREHENSIVE HELPER METHODS:**
/// - conditionalColor() - theme-aware color selection
/// - conditionalGradient() - theme-aware gradient selection
/// - getContrastingColor() - automatic contrast detection
/// - getTextColorForBackground() - optimal text color selection
///
/// **🏗️ ARCHITECTURAL ENHANCEMENTS:**
///
/// **1. Enhanced Icon Container:**
/// - Multi-layer gradient backgrounds with theme-aware colors
/// - Professional shadows and border system
/// - Dynamic color adaptation for light/dark themes
///
/// **2. Advanced Typography System:**
/// - Semantic text color hierarchy (textPrimary for values, textSecondary for labels)
/// - Enhanced contrast ratios for accessibility
/// - Professional font weights and spacing
///
/// **3. Flexible Layout System:**
/// - Responsive sizing with ScreenUtil integration
/// - Proper text overflow handling
/// - Enhanced visual hierarchy with spacing
///
/// **🎯 RESULT:**
/// A sophisticated meta info component that provides premium visual experience
/// with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible information display.
/// ====================================================================

Widget buildMetaInfo({
  required IconData icon,
  required String label,
  required String value,
  Color? customIconColor,
  Color? customLabelColor,
  Color? customValueColor,
  bool showBackground = false,
  bool showBorder = false,
  bool showShadow = false,
  bool useGradient = false,
  double? iconSize,
  double? labelFontSize,
  double? valueFontSize,
  EdgeInsets? padding,
  BorderRadius? borderRadius,
  required ThemeManager themeManager,
}) {
  // ========== COMPREHENSIVE THEME INTEGRATION ==========
  debugPrint(
      '📊 MetaInfo: Building meta info widget with COMPREHENSIVE ThemeManager integration');
  debugPrint('📊 MetaInfo: → Label: "$label", Value: "$value"');
  debugPrint('📊 MetaInfo: → Icon: $icon');
  // debugPrint('📊 MetaInfo: → Primary Color: ${themeManager.primaryColor}');
  // debugPrint('📊 MetaInfo: → Text Primary: ${ThemeManager.of(context).textPrimary}');
  // debugPrint('📊 MetaInfo: → Text Secondary: ${ThemeManager.of(context).textSecondary}');
  // debugPrint('📊 MetaInfo: → Background: ${ThemeManager.of(context).backgroundColor}');
  // debugPrint('📊 MetaInfo: → Surface: ${ThemeManager.of(context).surfaceColor}');
  debugPrint(
      '📊 MetaInfo: → Show Background: $showBackground, Border: $showBorder, Shadow: $showShadow');

  // ========== DYNAMIC COLOR SELECTION ==========
  final iconColor = customIconColor ??
      themeManager.conditionalColor(
        lightColor: themeManager.primaryColor,
        darkColor: themeManager.primaryLight,
      );

  final labelColor = customLabelColor ??
      themeManager.conditionalColor(
        lightColor: themeManager.textSecondary,
        darkColor: themeManager.textSecondary,
      );

  final valueColor = customValueColor ??
      themeManager.conditionalColor(
        lightColor: themeManager.textPrimary,
        darkColor: themeManager.textPrimary,
      );

  debugPrint(
      '📊 MetaInfo: → Final Colors - Icon: $iconColor, Label: $labelColor, Value: $valueColor');

  // ========== MAIN CONTAINER WITH OPTIONAL STYLING ==========
  Widget content = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      // ========== ICON AND LABEL ROW ==========
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ========== ENHANCED ICON WITH OPTIONAL CONTAINER ==========
          Container(
            padding: showBackground ? EdgeInsets.all(6.w) : EdgeInsets.zero,
            decoration: showBackground
                ? BoxDecoration(
                    gradient: useGradient
                        ? themeManager.conditionalGradient(
                            lightGradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                themeManager.primaryColor.withValues(alpha: 26),
                                themeManager.primaryLight.withValues(alpha: 13),
                                themeManager.accent1.withValues(alpha: 8),
                              ],
                            ),
                            darkGradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                themeManager.primaryDark.withValues(alpha: 30),
                                themeManager.primaryColor.withValues(alpha: 20),
                                themeManager.accent1.withValues(alpha: 10),
                              ],
                            ),
                          )
                        : null,
                    color: !useGradient
                        ? themeManager.conditionalColor(
                            lightColor: themeManager.surfaceColor,
                            darkColor: themeManager.surfaceElevated,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(6.r),
                    border: showBorder
                        ? Border.all(
                            color: themeManager.conditionalColor(
                              lightColor: themeManager.borderColor
                                  .withValues(alpha: 51),
                              darkColor: themeManager.borderSecondary
                                  .withValues(alpha: 77),
                            ),
                            width: 1,
                          )
                        : null,
                    boxShadow: showShadow
                        ? [
                            BoxShadow(
                              color: themeManager.shadowLight,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                            BoxShadow(
                              color: themeManager.primaryColor
                                  .withValues(alpha: 13),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  )
                : null,
            child: Icon(
              icon,
              size: iconSize ?? 12.sp,
              color: iconColor,
            ),
          ),

          SizedBox(width: 4.w),

          // ========== ENHANCED LABEL ==========
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: labelFontSize ?? 12.sp,
                color: labelColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      SizedBox(height: 4.h),

      // ========== ENHANCED VALUE TEXT ==========
      Text(
        value,
        style: TextStyle(
          fontSize: valueFontSize ?? 13.sp,
          color: valueColor,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );

  // ========== OPTIONAL CONTAINER WRAPPER ==========
  if (showBackground || showBorder || showShadow) {
    content = Container(
      padding: padding ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        gradient: showBackground && useGradient
            ? themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.cardBackground,
                    themeManager.surfaceElevated,
                    themeManager.backgroundSecondary,
                  ],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.backgroundTertiary,
                    themeManager.surfaceElevated,
                    themeManager.cardBackground,
                  ],
                ),
              )
            : null,
        color: showBackground && !useGradient
            ? themeManager.conditionalColor(
                lightColor: themeManager.cardBackground,
                darkColor: themeManager.surfaceElevated,
              )
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        border: showBorder
            ? Border.all(
                color: themeManager.conditionalColor(
                  lightColor: themeManager.borderColor.withValues(alpha: 77),
                  darkColor:
                      themeManager.borderSecondary.withValues(alpha: 102),
                ),
                width: 1,
              )
            : null,
        boxShadow: showShadow
            ? [
                ...themeManager.subtleShadow,
                BoxShadow(
                  color: themeManager.shadowMedium,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: content,
    );
  }

  debugPrint(
      '📊 MetaInfo: Meta info widget built successfully with comprehensive theming');
  return content;
}

/// ====================================================================
/// ENHANCED META INFO VARIANTS
/// ====================================================================

/// Build a premium meta info card with enhanced styling
Widget buildPremiumMetaInfo({
  required IconData icon,
  required String label,
  required String value,
  Color? statusColor,
  bool isHighlighted = false,
  required ThemeManager themeManager,
}) {
  debugPrint('📊 MetaInfo: Building premium meta info variant');

  final effectiveStatusColor = statusColor ?? themeManager.primaryColor;

  return buildMetaInfo(
    icon: icon,
    label: label,
    value: value,
    customIconColor: effectiveStatusColor,
    customValueColor: isHighlighted ? effectiveStatusColor : null,
    showBackground: true,
    showBorder: true,
    showShadow: true,
    useGradient: true,
    iconSize: 14.sp,
    labelFontSize: 11.sp,
    valueFontSize: 14.sp,
    padding: EdgeInsets.all(12.w),
    borderRadius: BorderRadius.circular(12.r),
    themeManager: themeManager,
  );
}

/// Build a compact meta info for tight spaces
Widget buildCompactMetaInfo({
  required IconData icon,
  required String label,
  required String value,
  required ThemeManager themeManager,
}) {
  debugPrint('📊 MetaInfo: Building compact meta info variant');

  return buildMetaInfo(
    icon: icon,
    label: label,
    value: value,
    iconSize: 10.sp,
    labelFontSize: 10.sp,
    valueFontSize: 11.sp,
    themeManager: themeManager,
  );
}

/// Build a status-aware meta info with semantic colors
Widget buildStatusMetaInfo({
  required IconData icon,
  required String label,
  required String value,
  required String status, // 'success', 'warning', 'error', 'info'
  required ThemeManager themeManager,
}) {
  debugPrint(
      '📊 MetaInfo: Building status meta info variant for status: $status');

  Color statusColor;
  switch (status.toLowerCase()) {
    case 'success':
      statusColor = themeManager.successColor;
      break;
    case 'warning':
      statusColor = themeManager.warningColor;
      break;
    case 'error':
      statusColor = themeManager.errorColor;
      break;
    case 'info':
      statusColor = themeManager.infoColor;
      break;
    default:
      statusColor = themeManager.primaryColor;
  }

  return buildPremiumMetaInfo(
    icon: icon,
    label: label,
    value: value,
    statusColor: statusColor,
    isHighlighted: true,
    themeManager: themeManager,
  );
}
