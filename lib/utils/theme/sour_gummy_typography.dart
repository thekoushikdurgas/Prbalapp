import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// **SourGummyTypography** - Comprehensive typography utility for SourGummy fonts
///
/// **Purpose**: Provides easy access to all SourGummy font variations with predefined styles
///
/// **Features**:
/// - Complete SourGummy font family management
/// - Predefined styles for different use cases
/// - Theme-aware text colors
/// - Responsive font sizing with ScreenUtil
/// - Font weight and style variations
/// - Letter spacing and line height optimization
///
/// **Usage**:
/// ```dart
/// Text(
///   'Hello World',
///   style: SourGummyTypography.displayLarge(context),
/// )
///
/// Text(
///   'Button Text',
///   style: SourGummyTypography.button(context, color: Colors.white),
/// )
/// ```
class SourGummyTypography {
  // =================== FONT FAMILY CONSTANTS ===================

  /// Primary SourGummy font family for standard text
  static const String primary = ThemeManager.fontFamilyPrimary;

  /// SourGummy Expanded for headings and emphasis
  static const String expanded = ThemeManager.fontFamilyExpanded;

  /// SourGummy SemiExpanded for subheadings and titles
  static const String semiExpanded = ThemeManager.fontFamilySemiExpanded;

  // =================== DISPLAY STYLES ===================

  /// Extra large display text - SourGummy Expanded (64sp)
  static TextStyle displayXL(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: expanded,
      fontSize: 64.sp,
      fontWeight: FontWeight.w800,
      letterSpacing: -1,
      height: 1.1,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Large display text - SourGummy Expanded (57sp)
  static TextStyle displayLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: expanded,
      fontSize: 57.sp,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.25,
      height: 1.12,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Medium display text - SourGummy Expanded (45sp)
  static TextStyle displayMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: expanded,
      fontSize: 45.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.16,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Small display text - SourGummy SemiExpanded (36sp)
  static TextStyle displaySmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: semiExpanded,
      fontSize: 36.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.22,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  // =================== HEADLINE STYLES ===================

  /// Large headline - SourGummy SemiExpanded (32sp)
  static TextStyle headlineLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: semiExpanded,
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.25,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Medium headline - SourGummy SemiExpanded (28sp)
  static TextStyle headlineMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: semiExpanded,
      fontSize: 28.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Small headline - SourGummy Primary (24sp)
  static TextStyle headlineSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  // =================== TITLE STYLES ===================

  /// Large title - SourGummy Primary (22sp)
  static TextStyle titleLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Medium title - SourGummy Primary (16sp)
  static TextStyle titleMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.5,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Small title - SourGummy Primary (14sp)
  static TextStyle titleSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  // =================== BODY STYLES ===================

  /// Large body text - SourGummy Primary (16sp)
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.5,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Medium body text - SourGummy Primary (14sp)
  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Small body text - SourGummy Primary (12sp)
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: color ?? ThemeManager.of(context).textSecondary,
    );
  }

  // =================== LABEL STYLES ===================

  /// Large label - SourGummy Primary (14sp)
  static TextStyle labelLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
      color: color ?? ThemeManager.of(context).textSecondary,
    );
  }

  /// Medium label - SourGummy Primary (12sp)
  static TextStyle labelMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: color ?? ThemeManager.of(context).textSecondary,
    );
  }

  /// Small label - SourGummy Primary (11sp)
  static TextStyle labelSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: color ?? ThemeManager.of(context).textTertiary,
    );
  }

  // =================== SPECIALIZED STYLES ===================

  /// Logo text style - SourGummy Expanded with branding
  static TextStyle logo(BuildContext context,
      {Color? color, double? fontSize}) {
    return TextStyle(
      fontFamily: expanded,
      fontSize: fontSize?.sp ?? 32.sp,
      fontWeight: FontWeight.w800,
      letterSpacing: 2,
      height: 1.2,
      color: color ?? ThemeManager.of(context).primaryColor,
    );
  }

  /// Button text style - SourGummy SemiExpanded
  static TextStyle button(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: semiExpanded,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
      height: 1.2,
      color: color ?? ThemeManager.of(context).textInverted,
    );
  }

  /// Caption style - SourGummy Primary, small and light
  static TextStyle caption(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 10.sp,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.5,
      height: 1.4,
      color: color ?? ThemeManager.of(context).textTertiary,
    );
  }

  /// Card title style - SourGummy SemiExpanded
  static TextStyle cardTitle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: semiExpanded,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.4,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Card subtitle style - SourGummy Primary
  static TextStyle cardSubtitle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.3,
      color: color ?? ThemeManager.of(context).textSecondary,
    );
  }

  /// Overline style - SourGummy Primary, uppercase
  static TextStyle overline(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      height: 1.6,
      color: color ?? ThemeManager.of(context).textTertiary,
    );
  }

  // =================== STATUS STYLES ===================

  /// Success text style
  static TextStyle success(BuildContext context, {double? fontSize}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      height: 1.3,
      color: ThemeManager.of(context).successColor,
    );
  }

  /// Warning text style
  static TextStyle warning(BuildContext context, {double? fontSize}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      height: 1.3,
      color: ThemeManager.of(context).warningColor,
    );
  }

  /// Error text style
  static TextStyle error(BuildContext context, {double? fontSize}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      height: 1.3,
      color: ThemeManager.of(context).errorColor,
    );
  }

  /// Info text style
  static TextStyle info(BuildContext context, {double? fontSize}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      height: 1.3,
      color: ThemeManager.of(context).infoColor,
    );
  }

  // =================== UTILITY METHODS ===================

  /// Get custom TextStyle with SourGummy Primary
  static TextStyle custom({
    required BuildContext context,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    String fontFamily = primary,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: letterSpacing ?? 0.25,
      height: height ?? 1.4,
      color: color ?? ThemeManager.of(context).textPrimary,
    );
  }

  /// Log all available SourGummy typography styles
  static void logAllStyles() {
    debugPrint('🔤 ========= SOUR GUMMY TYPOGRAPHY STYLES =========');
    debugPrint('📱 DISPLAY STYLES:');
    debugPrint('  - displayXL: $expanded | 64sp | w800');
    debugPrint('  - displayLarge: $expanded | 57sp | w800');
    debugPrint('  - displayMedium: $expanded | 45sp | w700');
    debugPrint('  - displaySmall: $semiExpanded | 36sp | w700');

    debugPrint('📰 HEADLINE STYLES:');
    debugPrint('  - headlineLarge: $semiExpanded | 32sp | w700');
    debugPrint('  - headlineMedium: $semiExpanded | 28sp | w600');
    debugPrint('  - headlineSmall: $primary | 24sp | w600');

    debugPrint('🏷️ TITLE STYLES:');
    debugPrint('  - titleLarge: $primary | 22sp | w600');
    debugPrint('  - titleMedium: $primary | 16sp | w600');
    debugPrint('  - titleSmall: $primary | 14sp | w600');

    debugPrint('📝 BODY STYLES:');
    debugPrint('  - bodyLarge: $primary | 16sp | w400');
    debugPrint('  - bodyMedium: $primary | 14sp | w400');
    debugPrint('  - bodySmall: $primary | 12sp | w400');

    debugPrint('🏷️ LABEL STYLES:');
    debugPrint('  - labelLarge: $primary | 14sp | w600');
    debugPrint('  - labelMedium: $primary | 12sp | w500');
    debugPrint('  - labelSmall: $primary | 11sp | w500');

    debugPrint('🎨 SPECIALIZED STYLES:');
    debugPrint('  - logo: $expanded | 32sp | w800');
    debugPrint('  - button: $semiExpanded | 14sp | w600');
    debugPrint('  - caption: $primary | 10sp | w300');
    debugPrint('  - cardTitle: $semiExpanded | 18sp | w600');
    debugPrint('  - cardSubtitle: $primary | 13sp | w400');
    debugPrint('  - overline: $primary | 10sp | w500');

    debugPrint('📊 STATUS STYLES:');
    debugPrint('  - success: $primary | 14sp | w600');
    debugPrint('  - warning: $primary | 14sp | w600');
    debugPrint('  - error: $primary | 14sp | w600');
    debugPrint('  - info: $primary | 14sp | w600');

    debugPrint('🔤 =================================================');
  }
}
