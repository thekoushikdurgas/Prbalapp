import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/services/user_service.dart';

/// **ThemeManager** - Centralized theme management utility
///
/// **Purpose**: Provides easy access to theme-aware colors, gradients, and design tokens
///
/// **Features**:
/// - Automatic light/dark theme detection
/// - Consistent color palette access
/// - Pre-built gradient combinations
/// - Material Design 3.0 compliance
/// - Debug logging for theme operations
/// - Comprehensive SourGummy typography system
class ThemeManager {
  final BuildContext context;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final bool themeManager;

  ThemeManager._(this.context)
      : theme = Theme.of(context),
        colorScheme = Theme.of(context).colorScheme,
        themeManager = Theme.of(context).brightness == Brightness.dark;

  /// Factory constructor to create ThemeManager instance
  factory ThemeManager.of(BuildContext context) {
    return ThemeManager._(context);
  }

  // =================== SOUR GUMMY FONT FAMILY CONSTANTS ===================

  /// Primary SourGummy font family for standard text
  static const String fontFamilyPrimary = 'SourGummy';

  /// SourGummy Expanded for headings and emphasis
  static const String fontFamilyExpanded = 'SourGummy_Expanded';

  /// SourGummy SemiExpanded for subheadings and titles
  static const String fontFamilySemiExpanded = 'SourGummy_SemiExpanded';

  // =================== TYPOGRAPHY SYSTEM ===================

  /// Get comprehensive typography theme using SourGummy fonts
  static TextTheme _getSourGummyTextTheme(bool isDark) {
    final Color primaryTextColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF111827);
    final Color secondaryTextColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF4B5563);
    final Color tertiaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return TextTheme(
      // Display styles - SourGummy Expanded for maximum impact
      displayLarge: TextStyle(
        fontFamily: fontFamilyExpanded,
        fontSize: 57.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.25,
        height: 1.12,
        color: primaryTextColor,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamilyExpanded,
        fontSize: 45.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.16,
        color: primaryTextColor,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamilySemiExpanded,
        fontSize: 36.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.22,
        color: primaryTextColor,
      ),

      // Headline styles - SourGummy SemiExpanded for structure
      headlineLarge: TextStyle(
        fontFamily: fontFamilySemiExpanded,
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.25,
        color: primaryTextColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamilySemiExpanded,
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
        color: primaryTextColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
        color: primaryTextColor,
      ),

      // Title styles - SourGummy Primary for balance
      titleLarge: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
        color: primaryTextColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
        color: primaryTextColor,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
        color: primaryTextColor,
      ),

      // Label styles - SourGummy Primary for UI elements
      labelLarge: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
        color: secondaryTextColor,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
        color: secondaryTextColor,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        color: tertiaryTextColor,
      ),

      // Body styles - SourGummy Primary for readability
      bodyLarge: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        color: primaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        color: primaryTextColor,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: secondaryTextColor,
      ),
    );
  }

  /// Get custom typography styles for specific use cases
  TextStyle get customHeadingXL => TextStyle(
        fontFamily: fontFamilyExpanded,
        fontSize: 64.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.1,
        color: textPrimary,
      );

  TextStyle get customHeadingLogo => TextStyle(
        fontFamily: fontFamilyExpanded,
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        height: 1.2,
        color: primaryColor,
      );

  TextStyle get customButtonText => TextStyle(
        fontFamily: fontFamilySemiExpanded,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        height: 1.2,
        color: textInverted,
      );

  TextStyle get customCaption => TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 10.sp,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.5,
        height: 1.4,
        color: textTertiary,
      );

  TextStyle get customCardTitle => TextStyle(
        fontFamily: fontFamilySemiExpanded,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
        color: textPrimary,
      );

  TextStyle get customCardSubtitle => TextStyle(
        fontFamily: fontFamilyPrimary,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.3,
        color: textSecondary,
      );

  // =================== THEME DATA CREATION ===================

  /// Create light theme data compatible with ThemeManager system
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: fontFamilyPrimary, // Set default font family
        textTheme: _getSourGummyTextTheme(false),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF10B981),
          surface: Color(0xFFFFFFFF),
          error: Color(0xFFDC2626),
          onPrimary: Color(0xFFFFFFFF),
          onSecondary: Color(0xFFFFFFFF),
          onSurface: Color(0xFF111827),
          onError: Color(0xFFFFFFFF),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFFFFFFF),
          foregroundColor: const Color(0xFF111827),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: fontFamilySemiExpanded,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFFFF),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 2,
            textStyle: TextStyle(
              fontFamily: fontFamilySemiExpanded,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          labelStyle: TextStyle(
            fontFamily: fontFamilyPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            fontFamily: fontFamilyPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
        ),
      );

  /// Create dark theme data compatible with ThemeManager system
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: fontFamilyPrimary, // Set default font family
        textTheme: _getSourGummyTextTheme(true),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
          error: Color(0xFFEF4444),
          onPrimary: Color(0xFFFFFFFF),
          onSecondary: Color(0xFFFFFFFF),
          onSurface: Color(0xFFF1F5F9),
          onError: Color(0xFFFFFFFF),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E293B),
          foregroundColor: const Color(0xFFF1F5F9),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: fontFamilySemiExpanded,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F5F9),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 4,
            textStyle: TextStyle(
              fontFamily: fontFamilySemiExpanded,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E293B),
          labelStyle: TextStyle(
            fontFamily: fontFamilyPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            fontFamily: fontFamilyPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
          ),
        ),
      );

  // =================== BACKGROUND GRADIENTS ===================

  /// Primary background gradient for screens
  LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: themeManager
            ? [const Color(0xFF0F0F23), const Color(0xFF1A1A2E)]
            : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
      );

  /// Surface gradient for cards and containers
  LinearGradient get surfaceGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
            : [const Color(0xFFFFFFFF), const Color(0xFFF8FAFC)],
      );

  /// Primary accent gradient
  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]
            : [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
      );

  /// Secondary accent gradient
  LinearGradient get secondaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFF06D6A0), const Color(0xFF048A81)]
            : [const Color(0xFF10B981), const Color(0xFF059669)],
      );

  /// Success gradient for positive actions
  LinearGradient get successGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFF10B981), const Color(0xFF059669)]
            : [const Color(0xFF22C55E), const Color(0xFF16A34A)],
      );

  /// Warning gradient for attention-grabbing elements
  LinearGradient get warningGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFFEAB308), const Color(0xFFCA8A04)]
            : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      );

  /// Error gradient for error states
  LinearGradient get errorGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
            : [const Color(0xFFF87171), const Color(0xFFEF4444)],
      );

  /// Info gradient for informational elements
  LinearGradient get infoGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFF3B82F6), const Color(0xFF2563EB)]
            : [const Color(0xFF60A5FA), const Color(0xFF3B82F6)],
      );

  /// Neutral gradient for subtle elements
  LinearGradient get neutralGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFF334155), const Color(0xFF1E293B)]
            : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
      );

  /// Accent gradient 1 - Purple
  LinearGradient get accent1Gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]
            : [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)],
      );

  /// Accent gradient 2 - Pink
  LinearGradient get accent2Gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFFEC4899), const Color(0xFFDB2777)]
            : [const Color(0xFFF472B6), const Color(0xFFEC4899)],
      );

  /// Accent gradient 3 - Teal
  LinearGradient get accent3Gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFF06D6A0), const Color(0xFF0D9488)]
            : [const Color(0xFF2DD4BF), const Color(0xFF14B8A6)],
      );

  /// Accent gradient 4 - Orange
  LinearGradient get accent4Gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [const Color(0xFFFF6B35), const Color(0xFFEA580C)]
            : [const Color(0xFFFF8C42), const Color(0xFFFF6B35)],
      );

  /// Glass gradient for glass morphism effects
  LinearGradient get glassGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: themeManager
            ? [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ]
            : [
                Colors.white.withValues(alpha: 0.8),
                Colors.white.withValues(alpha: 0.4),
              ],
      );

  /// Shimmer gradient for loading states
  LinearGradient get shimmerGradient => LinearGradient(
        begin: Alignment(-1.0, -2.0),
        end: Alignment(1.0, 2.0),
        colors: themeManager
            ? [
                const Color(0xFF334155),
                const Color(0xFF475569),
                const Color(0xFF334155),
              ]
            : [
                const Color(0xFFE2E8F0),
                const Color(0xFFF1F5F9),
                const Color(0xFFE2E8F0),
              ],
        stops: const [0.0, 0.5, 1.0],
      );

  // =================== TEXT THEME ===================

  /// Access to theme text styles
  TextTheme get textTheme => theme.textTheme;

  // =================== COLORS ===================

  /// Primary brand color
  Color get primaryColor => colorScheme.primary;

  /// Secondary brand color
  Color get secondaryColor => colorScheme.secondary;

  /// Background color
  Color get backgroundColor => themeManager ? const Color(0xFF0F0F23) : const Color(0xFFFAFAFA);

  /// Surface color
  Color get surfaceColor => colorScheme.surface;

  // =================== TEXT COLORS ===================

  /// Primary text color - highest contrast
  Color get textPrimary => themeManager ? const Color(0xFFF1F5F9) : const Color(0xFF111827);

  /// Secondary text color - medium contrast
  Color get textSecondary => themeManager ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280);

  /// Tertiary text color - low contrast
  Color get textTertiary => themeManager ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF);

  /// Quaternary text color - subtle hints
  Color get textQuaternary => themeManager ? const Color(0xFF64748B) : const Color(0xFFD1D5DB);

  /// Disabled text color
  Color get textDisabled => themeManager ? const Color(0xFF475569) : const Color(0xFFE5E7EB);

  /// Inverted text color - for use on primary/dark backgrounds
  Color get textInverted => themeManager ? const Color(0xFF111827) : const Color(0xFFF1F5F9);

  // =================== BACKGROUND COLORS ===================

  /// Secondary background color
  Color get backgroundSecondary => themeManager ? const Color(0xFF1A1A2E) : const Color(0xFFF8FAFC);

  /// Tertiary background color
  Color get backgroundTertiary => themeManager ? const Color(0xFF16213E) : const Color(0xFFE2E8F0);

  /// Card background color
  Color get cardBackground => themeManager ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);

  /// Elevated surface color
  Color get surfaceElevated => themeManager ? const Color(0xFF334155) : const Color(0xFFF9FAFB);

  /// Modal background color
  Color get modalBackground => themeManager ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);

  /// Overlay background color
  Color get overlayBackground =>
      themeManager ? Colors.black.withValues(alpha: 0.7) : Colors.black.withValues(alpha: 0.5);

  // =================== BORDER COLORS ===================

  /// Primary border color
  Color get borderColor => themeManager ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

  /// Secondary border color - lighter
  Color get borderSecondary => themeManager ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6);

  /// Focus border color
  Color get borderFocus => themeManager ? const Color(0xFF8B5CF6) : const Color(0xFF6366F1);

  /// Divider color
  Color get dividerColor => themeManager ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6);

  /// Success color - green
  Color get transparent => themeManager ? const Color(0x00000000) : const Color(0x00000000);
  // =================== STATUS COLORS ===================

  /// Success color - green
  Color get successColor => themeManager ? const Color(0xFF10B981) : const Color(0xFF059669);

  /// Success light variant
  Color get successLight => themeManager ? const Color(0xFF34D399) : const Color(0xFF10B981);

  /// Success dark variant
  Color get successDark => themeManager ? const Color(0xFF047857) : const Color(0xFF065F46);

  /// Warning color - yellow/orange
  Color get warningColor => themeManager ? const Color(0xFFEAB308) : const Color(0xFFD97706);

  /// Warning light variant
  Color get warningLight => themeManager ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);

  /// Warning dark variant
  Color get warningDark => themeManager ? const Color(0xFFA16207) : const Color(0xFF92400E);

  /// Error color - red
  Color get errorColor => themeManager ? const Color(0xFFEF4444) : const Color(0xFFDC2626);

  /// Error light variant
  Color get errorLight => themeManager ? const Color(0xFFF87171) : const Color(0xFFEF4444);

  /// Error dark variant
  Color get errorDark => themeManager ? const Color(0xFFB91C1C) : const Color(0xFF991B1B);

  /// Info color - blue
  Color get infoColor => themeManager ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);

  /// Info light variant
  Color get infoLight => themeManager ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);

  /// Info dark variant
  Color get infoDark => themeManager ? const Color(0xFF1D4ED8) : const Color(0xFF1E40AF);

  // =================== ACCENT COLORS ===================

  /// Accent color 1 - Purple
  Color get accent1 => themeManager ? const Color(0xFF8B5CF6) : const Color(0xFF7C3AED);

  /// Accent color 2 - Pink
  Color get accent2 => themeManager ? const Color(0xFFEC4899) : const Color(0xFFDB2777);

  /// Accent color 3 - Teal
  Color get accent3 => themeManager ? const Color(0xFF06D6A0) : const Color(0xFF0D9488);

  /// Accent color 4 - Orange
  Color get accent4 => themeManager ? const Color(0xFFFF6B35) : const Color(0xFFEA580C);

  /// Accent color 5 - Indigo
  Color get accent5 => themeManager ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);

  // =================== NEUTRAL COLORS ===================

  /// Neutral 50
  Color get neutral50 => themeManager ? const Color(0xFF64748B) : const Color(0xFFFAFAFA);

  /// Neutral 100
  Color get neutral100 => themeManager ? const Color(0xFF475569) : const Color(0xFFF5F5F5);

  /// Neutral 200
  Color get neutral200 => themeManager ? const Color(0xFF334155) : const Color(0xFFEEEEEE);

  /// Neutral 300
  Color get neutral300 => themeManager ? const Color(0xFF1E293B) : const Color(0xFFE0E0E0);

  /// Neutral 400
  Color get neutral400 => themeManager ? const Color(0xFF0F172A) : const Color(0xFFBDBDBD);

  /// Neutral 500
  Color get neutral500 => themeManager ? const Color(0xFF0F172A) : const Color(0xFF9E9E9E);

  /// Neutral 600
  Color get neutral600 => themeManager ? const Color(0xFF475569) : const Color(0xFF757575);

  /// Neutral 700
  Color get neutral700 => themeManager ? const Color(0xFF64748B) : const Color(0xFF616161);

  /// Neutral 800
  Color get neutral800 => themeManager ? const Color(0xFF94A3B8) : const Color(0xFF424242);

  /// Neutral 900
  Color get neutral900 => themeManager ? const Color(0xFFCBD5E1) : const Color(0xFF212121);

  // =================== INTERACTIVE COLORS ===================

  /// Button background - default state
  Color get buttonBackground => themeManager ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  /// Button background - hover state
  Color get buttonBackgroundHover => themeManager ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

  /// Button background - pressed state
  Color get buttonBackgroundPressed => themeManager ? const Color(0xFF1E293B) : const Color(0xFF94A3B8);

  /// Button background - disabled state
  Color get buttonBackgroundDisabled => themeManager ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

  /// Input field background
  Color get inputBackground => themeManager ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);

  /// Input field background - focused
  Color get inputBackgroundFocused => themeManager ? const Color(0xFF334155) : const Color(0xFFFAFAFA);

  /// Input field background - disabled
  Color get inputBackgroundDisabled => themeManager ? const Color(0xFF0F172A) : const Color(0xFFF5F5F5);

  // =================== BRAND COLORS ===================

  /// Primary brand color variants
  Color get primaryLight => themeManager ? const Color(0xFFA78BFA) : const Color(0xFF8B5DFF);
  Color get primaryDark => themeManager ? const Color(0xFF6D28D9) : const Color(0xFF5B21B6);
  Color get onPrimaryColor => themeManager ? const Color(0xFFF1F5F9) : const Color(0xFF111827);

  /// Secondary brand color variants
  Color get secondaryLight => themeManager ? const Color(0xFF34D399) : const Color(0xFF34D399);
  Color get secondaryDark => themeManager ? const Color(0xFF047857) : const Color(0xFF047857);

  // =================== SEMANTIC COLORS ===================

  /// Online/Active status
  Color get statusOnline => themeManager ? const Color(0xFF10B981) : const Color(0xFF22C55E);

  /// Offline/Inactive status
  Color get statusOffline => themeManager ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);

  /// Away status
  Color get statusAway => themeManager ? const Color(0xFFF59E0B) : const Color(0xFFEAB308);

  /// Busy/Do not disturb status
  Color get statusBusy => themeManager ? const Color(0xFFEF4444) : const Color(0xFFDC2626);

  /// Favorite/Like color
  Color get favoriteColor => themeManager ? const Color(0xFFFF6B9D) : const Color(0xFFE91E63);

  /// Rating/Star color
  Color get ratingColor => themeManager ? const Color(0xFFFBBF24) : const Color(0xFFEAB308);

  /// New/Unread indicator
  Color get newIndicator => themeManager ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);

  /// Verified badge color
  Color get verifiedColor => themeManager ? const Color(0xFF10B981) : const Color(0xFF059669);

  // =================== SHADOW COLORS ===================

  /// Light shadow color
  Color get shadowLight =>
      themeManager ? Colors.black.withValues(alpha: 0.1) : Colors.grey.shade200.withValues(alpha: 0.5);

  /// Medium shadow color
  Color get shadowMedium =>
      themeManager ? Colors.black.withValues(alpha: 0.2) : Colors.grey.shade300.withValues(alpha: 0.7);

  /// Dark shadow color
  Color get shadowDark =>
      themeManager ? Colors.black.withValues(alpha: 0.3) : Colors.grey.shade400.withValues(alpha: 0.9);

  // =================== SHADOWS AND EFFECTS ===================

  /// Primary shadow
  List<BoxShadow> get primaryShadow => [
        BoxShadow(
          color: (themeManager ? Colors.black : Colors.grey.shade300).withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  /// Elevated shadow
  List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: (themeManager ? Colors.black : Colors.grey.shade400).withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Subtle shadow for minimal elevation
  List<BoxShadow> get subtleShadow => [
        BoxShadow(
          color: (themeManager ? Colors.black : Colors.grey.shade200).withValues(alpha: 0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  /// Glass morphism effect
  BoxDecoration get glassMorphism => BoxDecoration(
        color: (themeManager ? Colors.white : Colors.black).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (themeManager ? Colors.white : Colors.black).withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (themeManager ? Colors.black : Colors.grey.shade300).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// Enhanced glass morphism with stronger effects
  BoxDecoration get enhancedGlassMorphism => BoxDecoration(
        color: (themeManager ? Colors.white : Colors.black).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (themeManager ? Colors.white : Colors.black).withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: elevatedShadow,
      );

  // =================== CONDITIONAL COLORS ===================

  /// Get color based on theme mode
  Color conditionalColor({
    required Color lightColor,
    required Color darkColor,
  }) {
    return themeManager ? darkColor : lightColor;
  }

  /// Get gradient based on theme mode
  LinearGradient conditionalGradient({
    required LinearGradient lightGradient,
    required LinearGradient darkGradient,
  }) {
    return themeManager ? darkGradient : lightGradient;
  }

  // =================== HELPER METHODS ===================

  /// Get theme-aware text color for backgrounds
  Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : Colors.white;
  }

  /// Get contrasting color for better readability
  Color getContrastingColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }

  /// Apply alpha to any color while maintaining theme consistency
  Color withThemeAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }

  /// Get color for user type
  Color getUserTypeColor(UserType userType) {
    switch (userType) {
      case UserType.provider:
        return themeManager ? successColor : successLight;
      case UserType.customer:
        return themeManager ? infoColor : infoLight;
      case UserType.admin:
        return themeManager ? warningColor : warningLight;
    }
  }
  // =================== DEBUG UTILITIES ===================

  /// Log current theme information
  void logThemeInfo() {
    debugPrint('🎨 ThemeManager: Current theme mode: ${themeManager ? 'dark' : 'light'}');
    debugPrint('🎨 ThemeManager: Primary color: ${primaryColor.toString()}');
    debugPrint('🎨 ThemeManager: Secondary color: ${secondaryColor.toString()}');
    debugPrint('🎨 ThemeManager: Background color: ${backgroundColor.toString()}');
  }

  /// Log gradient information for debugging
  void logGradientInfo() {
    debugPrint('🌈 ThemeManager Gradients:');
    debugPrint('  === CORE GRADIENTS ===');
    debugPrint('  - Primary: ${primaryGradient.colors}');
    debugPrint('  - Secondary: ${secondaryGradient.colors}');
    debugPrint('  - Background: ${backgroundGradient.colors}');
    debugPrint('  - Surface: ${surfaceGradient.colors}');
    debugPrint('  - Neutral: ${neutralGradient.colors}');

    debugPrint('  === STATUS GRADIENTS ===');
    debugPrint('  - Success: ${successGradient.colors}');
    debugPrint('  - Warning: ${warningGradient.colors}');
    debugPrint('  - Error: ${errorGradient.colors}');
    debugPrint('  - Info: ${infoGradient.colors}');

    debugPrint('  === ACCENT GRADIENTS ===');
    debugPrint('  - Accent 1 (Purple): ${accent1Gradient.colors}');
    debugPrint('  - Accent 2 (Pink): ${accent2Gradient.colors}');
    debugPrint('  - Accent 3 (Teal): ${accent3Gradient.colors}');
    debugPrint('  - Accent 4 (Orange): ${accent4Gradient.colors}');

    debugPrint('  === SPECIAL GRADIENTS ===');
    debugPrint('  - Glass: ${glassGradient.colors}');
    debugPrint('  - Shimmer: ${shimmerGradient.colors}');
  }

  /// Log all color information
  void logAllColors() {
    debugPrint('🎨 ThemeManager Color Palette:');
    debugPrint('  === BRAND COLORS ===');
    debugPrint('  - Primary: $primaryColor');
    debugPrint('  - Primary Light: $primaryLight');
    debugPrint('  - Primary Dark: $primaryDark');
    debugPrint('  - Secondary: $secondaryColor');
    debugPrint('  - Secondary Light: $secondaryLight');
    debugPrint('  - Secondary Dark: $secondaryDark');

    debugPrint('  === BACKGROUND COLORS ===');
    debugPrint('  - Background: $backgroundColor');
    debugPrint('  - Background Secondary: $backgroundSecondary');
    debugPrint('  - Background Tertiary: $backgroundTertiary');
    debugPrint('  - Surface: $surfaceColor');
    debugPrint('  - Surface Elevated: $surfaceElevated');
    debugPrint('  - Card Background: $cardBackground');
    debugPrint('  - Modal Background: $modalBackground');

    debugPrint('  === TEXT COLORS ===');
    debugPrint('  - Text Primary: $textPrimary');
    debugPrint('  - Text Secondary: $textSecondary');
    debugPrint('  - Text Tertiary: $textTertiary');
    debugPrint('  - Text Quaternary: $textQuaternary');
    debugPrint('  - Text Disabled: $textDisabled');
    debugPrint('  - Text Inverted: $textInverted');

    debugPrint('  === BORDER COLORS ===');
    debugPrint('  - Border: $borderColor');
    debugPrint('  - Border Secondary: $borderSecondary');
    debugPrint('  - Border Focus: $borderFocus');
    debugPrint('  - Divider: $dividerColor');

    debugPrint('  === STATUS COLORS ===');
    debugPrint('  - Success: $successColor (Light: $successLight, Dark: $successDark)');
    debugPrint('  - Warning: $warningColor (Light: $warningLight, Dark: $warningDark)');
    debugPrint('  - Error: $errorColor (Light: $errorLight, Dark: $errorDark)');
    debugPrint('  - Info: $infoColor (Light: $infoLight, Dark: $infoDark)');

    debugPrint('  === ACCENT COLORS ===');
    debugPrint('  - Accent 1 (Purple): $accent1');
    debugPrint('  - Accent 2 (Pink): $accent2');
    debugPrint('  - Accent 3 (Teal): $accent3');
    debugPrint('  - Accent 4 (Orange): $accent4');
    debugPrint('  - Accent 5 (Indigo): $accent5');

    debugPrint('  === SEMANTIC COLORS ===');
    debugPrint('  - Status Online: $statusOnline');
    debugPrint('  - Status Offline: $statusOffline');
    debugPrint('  - Status Away: $statusAway');
    debugPrint('  - Status Busy: $statusBusy');
    debugPrint('  - Favorite: $favoriteColor');
    debugPrint('  - Rating: $ratingColor');
    debugPrint('  - New Indicator: $newIndicator');
    debugPrint('  - Verified: $verifiedColor');

    debugPrint('  === INTERACTIVE COLORS ===');
    debugPrint('  - Button Background: $buttonBackground');
    debugPrint('  - Button Hover: $buttonBackgroundHover');
    debugPrint('  - Button Pressed: $buttonBackgroundPressed');
    debugPrint('  - Button Disabled: $buttonBackgroundDisabled');
    debugPrint('  - Input Background: $inputBackground');
    debugPrint('  - Input Focused: $inputBackgroundFocused');
    debugPrint('  - Input Disabled: $inputBackgroundDisabled');
  }

  /// Log comprehensive typography information for debugging
  void logTypographyInfo() {
    debugPrint('🔤 ======== SOUR GUMMY TYPOGRAPHY DEBUG ========');
    debugPrint('🔤 Primary Font Family: $fontFamilyPrimary');
    debugPrint('🔤 Expanded Font Family: $fontFamilyExpanded');
    debugPrint('🔤 SemiExpanded Font Family: $fontFamilySemiExpanded');
    debugPrint('🔤 Theme Default Font: ${theme.textTheme.bodyMedium?.fontFamily ?? 'System Default'}');
    debugPrint(
        '🔤 Display Large: ${theme.textTheme.displayLarge?.fontFamily} - ${theme.textTheme.displayLarge?.fontSize}sp');
    debugPrint(
        '🔤 Headline Large: ${theme.textTheme.headlineLarge?.fontFamily} - ${theme.textTheme.headlineLarge?.fontSize}sp');
    debugPrint('🔤 Title Large: ${theme.textTheme.titleLarge?.fontFamily} - ${theme.textTheme.titleLarge?.fontSize}sp');
    debugPrint('🔤 Body Large: ${theme.textTheme.bodyLarge?.fontFamily} - ${theme.textTheme.bodyLarge?.fontSize}sp');
    debugPrint('🔤 Label Large: ${theme.textTheme.labelLarge?.fontFamily} - ${theme.textTheme.labelLarge?.fontSize}sp');
    debugPrint('🔤 Custom Heading XL: ${customHeadingXL.fontFamily} - ${customHeadingXL.fontSize}sp');
    debugPrint('🔤 Custom Logo: ${customHeadingLogo.fontFamily} - ${customHeadingLogo.fontSize}sp');
    debugPrint('🔤 Custom Button: ${customButtonText.fontFamily} - ${customButtonText.fontSize}sp');
    debugPrint('🔤 =============================================');
  }

  /// Log all typography styles with their properties
  void logAllTypographyStyles() {
    debugPrint('🔤 ========= ALL SOUR GUMMY TYPOGRAPHY STYLES =========');

    // Display styles
    debugPrint('📱 DISPLAY STYLES (SourGummy Expanded):');
    debugPrint(
        '  - Display Large: ${theme.textTheme.displayLarge?.fontFamily} | ${theme.textTheme.displayLarge?.fontSize}sp | ${theme.textTheme.displayLarge?.fontWeight}');
    debugPrint(
        '  - Display Medium: ${theme.textTheme.displayMedium?.fontFamily} | ${theme.textTheme.displayMedium?.fontSize}sp | ${theme.textTheme.displayMedium?.fontWeight}');
    debugPrint(
        '  - Display Small: ${theme.textTheme.displaySmall?.fontFamily} | ${theme.textTheme.displaySmall?.fontSize}sp | ${theme.textTheme.displaySmall?.fontWeight}');

    // Headline styles
    debugPrint('📰 HEADLINE STYLES (SourGummy SemiExpanded):');
    debugPrint(
        '  - Headline Large: ${theme.textTheme.headlineLarge?.fontFamily} | ${theme.textTheme.headlineLarge?.fontSize}sp | ${theme.textTheme.headlineLarge?.fontWeight}');
    debugPrint(
        '  - Headline Medium: ${theme.textTheme.headlineMedium?.fontFamily} | ${theme.textTheme.headlineMedium?.fontSize}sp | ${theme.textTheme.headlineMedium?.fontWeight}');
    debugPrint(
        '  - Headline Small: ${theme.textTheme.headlineSmall?.fontFamily} | ${theme.textTheme.headlineSmall?.fontSize}sp | ${theme.textTheme.headlineSmall?.fontWeight}');

    // Title styles
    debugPrint('🏷️ TITLE STYLES (SourGummy Primary):');
    debugPrint(
        '  - Title Large: ${theme.textTheme.titleLarge?.fontFamily} | ${theme.textTheme.titleLarge?.fontSize}sp | ${theme.textTheme.titleLarge?.fontWeight}');
    debugPrint(
        '  - Title Medium: ${theme.textTheme.titleMedium?.fontFamily} | ${theme.textTheme.titleMedium?.fontSize}sp | ${theme.textTheme.titleMedium?.fontWeight}');
    debugPrint(
        '  - Title Small: ${theme.textTheme.titleSmall?.fontFamily} | ${theme.textTheme.titleSmall?.fontSize}sp | ${theme.textTheme.titleSmall?.fontWeight}');

    // Body styles
    debugPrint('📝 BODY STYLES (SourGummy Primary):');
    debugPrint(
        '  - Body Large: ${theme.textTheme.bodyLarge?.fontFamily} | ${theme.textTheme.bodyLarge?.fontSize}sp | ${theme.textTheme.bodyLarge?.fontWeight}');
    debugPrint(
        '  - Body Medium: ${theme.textTheme.bodyMedium?.fontFamily} | ${theme.textTheme.bodyMedium?.fontSize}sp | ${theme.textTheme.bodyMedium?.fontWeight}');
    debugPrint(
        '  - Body Small: ${theme.textTheme.bodySmall?.fontFamily} | ${theme.textTheme.bodySmall?.fontSize}sp | ${theme.textTheme.bodySmall?.fontWeight}');

    // Label styles
    debugPrint('🏷️ LABEL STYLES (SourGummy Primary):');
    debugPrint(
        '  - Label Large: ${theme.textTheme.labelLarge?.fontFamily} | ${theme.textTheme.labelLarge?.fontSize}sp | ${theme.textTheme.labelLarge?.fontWeight}');
    debugPrint(
        '  - Label Medium: ${theme.textTheme.labelMedium?.fontFamily} | ${theme.textTheme.labelMedium?.fontSize}sp | ${theme.textTheme.labelMedium?.fontWeight}');
    debugPrint(
        '  - Label Small: ${theme.textTheme.labelSmall?.fontFamily} | ${theme.textTheme.labelSmall?.fontSize}sp | ${theme.textTheme.labelSmall?.fontWeight}');

    // Custom styles
    debugPrint('🎨 CUSTOM SOUR GUMMY STYLES:');
    debugPrint(
        '  - Custom Heading XL: ${customHeadingXL.fontFamily} | ${customHeadingXL.fontSize}sp | ${customHeadingXL.fontWeight}');
    debugPrint(
        '  - Custom Logo: ${customHeadingLogo.fontFamily} | ${customHeadingLogo.fontSize}sp | ${customHeadingLogo.fontWeight}');
    debugPrint(
        '  - Custom Button: ${customButtonText.fontFamily} | ${customButtonText.fontSize}sp | ${customButtonText.fontWeight}');
    debugPrint(
        '  - Custom Caption: ${customCaption.fontFamily} | ${customCaption.fontSize}sp | ${customCaption.fontWeight}');
    debugPrint(
        '  - Custom Card Title: ${customCardTitle.fontFamily} | ${customCardTitle.fontSize}sp | ${customCardTitle.fontWeight}');
    debugPrint(
        '  - Custom Card Subtitle: ${customCardSubtitle.fontFamily} | ${customCardSubtitle.fontSize}sp | ${customCardSubtitle.fontWeight}');

    debugPrint('🔤 ====================================================');
  }
}

/// **ThemeAwareMixin** - Mixin for easy theme access in StatefulWidgets
///
/// **Usage**:
/// ```dart
/// class MyWidget extends StatefulWidget with ThemeAwareMixin {
///   @override
///   Widget build(BuildContext context) {
///     final themeManager = ThemeManager.of(context);
///     return Container(color: themeManager.primaryColor);
///   }
/// }
/// ```
mixin ThemeAwareMixin {
  /// Get ThemeManager instance
  ThemeManager getThemeManager(BuildContext context) => ThemeManager.of(context);

  /// Quick access to theme-aware colors
  Color themeColor(BuildContext context, {required Color light, required Color dark}) {
    return ThemeManager.of(context).conditionalColor(
      lightColor: light,
      darkColor: dark,
    );
  }

  /// Quick access to theme-aware gradients
  LinearGradient themeGradient(BuildContext context, {required LinearGradient light, required LinearGradient dark}) {
    return ThemeManager.of(context).conditionalGradient(
      lightGradient: light,
      darkGradient: dark,
    );
  }
}

// /// **ThemeManagerDemo** - Comprehensive demo widget showcasing all ThemeManager capabilities
// ///
// /// This widget demonstrates every feature of ThemeManager including:
// /// - All gradient types (primary, secondary, background, surface, success, warning, error)
// /// - Glass morphism effects (regular and enhanced)
// /// - Shadow effects (primary, elevated, subtle)
// /// - Conditional colors and theme-aware styling
// /// - Text colors for different backgrounds
// /// - Status colors and semantic styling
// /// - Debug logging and theme state tracking
// class ThemeManagerDemo extends StatelessWidget with ThemeAwareMixin {
//   const ThemeManagerDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeManager = ThemeManager.of(context);

//     // Comprehensive debug logging

//     themeManager.logGradientInfo();
//     themeManager.logAllColors();

//     return Scaffold(
//       backgroundColor: themeManager.backgroundColor,
//       appBar: AppBar(
//         title: Text(
//           'ThemeManager Demo',
//           style: TextStyle(color: themeManager.textPrimary),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(gradient: themeManager.primaryGradient),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Gradient Showcase
//             _buildSection( 'Gradients', [
//               _buildGradientCard( 'Primary', themeManager.primaryGradient),
//               _buildGradientCard( 'Secondary', themeManager.secondaryGradient),
//               _buildGradientCard( 'Background', themeManager.backgroundGradient),
//               _buildGradientCard( 'Surface', themeManager.surfaceGradient),
//               _buildGradientCard( 'Success', themeManager.successGradient),
//               _buildGradientCard( 'Warning', themeManager.warningGradient),
//               _buildGradientCard( 'Error', themeManager.errorGradient),
//               _buildGradientCard( 'Info', themeManager.infoGradient),
//             ]),

//             const SizedBox(height: 24),

//             // Glass Morphism Showcase
//             _buildSection( 'Glass Morphism', [
//               Container(
//                 height: 100,
//                 decoration: themeManager.glassMorphism,
//                 child: Center(
//                   child: Text(
//                     'Regular Glass Morphism',
//                     style: TextStyle(color: themeManager.textPrimary, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 height: 100,
//                 decoration: themeManager.enhancedGlassMorphism,
//                 child: Center(
//                   child: Text(
//                     'Enhanced Glass Morphism',
//                     style: TextStyle(color: themeManager.textPrimary, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ]),

//             const SizedBox(height: 24),

//             // Shadow Effects Showcase
//             _buildSection( 'Shadow Effects', [
//               _buildShadowCard( 'Primary Shadow', themeManager.primaryShadow),
//               _buildShadowCard( 'Elevated Shadow', themeManager.elevatedShadow),
//               _buildShadowCard( 'Subtle Shadow', themeManager.subtleShadow),
//             ]),

//             const SizedBox(height: 24),

//             // Color Showcase
//             _buildSection( 'Colors', [
//               _buildColorRow( [
//                 ('Primary', themeManager.primaryColor),
//                 ('Secondary', themeManager.secondaryColor),
//                 ('Success', themeManager.successColor),
//                 ('Warning', themeManager.warningColor),
//               ]),
//               _buildColorRow( [
//                 ('Error', themeManager.errorColor),
//                 ('Info', themeManager.infoColor),
//                 ('Border', themeManager.borderColor),
//                 ('Divider', themeManager.dividerColor),
//               ]),
//             ]),

//             const SizedBox(height: 24),

//             // Text Colors Showcase
//             _buildSection( 'Text Colors', [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: themeManager.surfaceColor,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: themeManager.borderColor),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Primary Text',
//                         style: TextStyle(color: themeManager.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
//                     Text('Secondary Text', style: TextStyle(color: themeManager.textSecondary, fontSize: 14)),
//                     Text('Tertiary Text', style: TextStyle(color: themeManager.textTertiary, fontSize: 12)),
//                   ],
//                 ),
//               ),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(ThemeManager  String title, List<Widget> children) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: themeManager.textPrimary,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         ...children,
//       ],
//     );
//   }

//   Widget _buildGradientCard(ThemeManager  String name, LinearGradient gradient) {
//     return Container(
//       height: 80,
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: themeManager.primaryShadow,
//       ),
//       child: Center(
//         child: Text(
//           name,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildShadowCard(ThemeManager  String name, List<BoxShadow> shadows) {
//     return Container(
//       height: 80,
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: themeManager.surfaceColor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: shadows,
//       ),
//       child: Center(
//         child: Text(
//           name,
//           style: TextStyle(
//             color: themeManager.textPrimary,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildColorRow(ThemeManager  List<(String, Color)> colors) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: colors.map((colorData) {
//           final (name, color) = colorData;
//           return Expanded(
//             child: Container(
//               height: 60,
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: themeManager.subtleShadow,
//               ),
//               child: Center(
//                 child: Text(
//                   name,
//                   style: TextStyle(
//                     color: themeManager.getContrastingColor(color),
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
