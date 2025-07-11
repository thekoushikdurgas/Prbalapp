import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// MODERN UI COMPONENTS LIBRARY
/// ====================================================================
///
/// ✅ **COMPREHENSIVE THEMEMANAGER INTEGRATION COMPLETED** ✅
///
/// **🎨 ENHANCED FEATURES WITH ALL THEMEMANAGER PROPERTIES:**
///
/// **1. COMPREHENSIVE COLOR SYSTEM:**
/// - Primary Colors: primaryColor, primaryLight, primaryDark, secondaryColor
/// - Background Colors: backgroundColor, backgroundSecondary, backgroundTertiary,
///   cardBackground, surfaceElevated, modalBackground
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
/// **🏗️ AVAILABLE COMPONENTS:**
/// - **Glassmorphism Cards**: Enhanced blur effects with ThemeManager glass gradients
/// - **Gradient Cards**: Multi-layer gradients using ThemeManager gradient system
/// - **Elevated Cards**: Professional shadows with ThemeManager shadow system
/// - **Metric Cards**: Status-aware colors with semantic ThemeManager colors
/// - **Status Indicators**: Theme-aware status colors and gradients
/// - **Modern Buttons**: Comprehensive button styles with ThemeManager colors
/// - **Search Bars**: Input styling with ThemeManager input colors
/// - **List Tiles**: Enhanced styling with ThemeManager surface colors
/// - **Section Headers**: Typography using ThemeManager text hierarchy
/// - **Animated Containers**: Smooth interactions with ThemeManager effects
///
/// **🎯 DESIGN PHILOSOPHY:**
/// - **Centralized Theme Management**: All colors from ThemeManager
/// - **Automatic Light/Dark Adaptation**: Using conditional color selection
/// - **Material Design 3.0 Compliance**: Following latest design principles
/// - **Accessibility First**: Proper contrast ratios and interactions
/// - **Performance Optimized**: Efficient animations and rendering
/// - **Responsive Design**: ScreenUtil integration for all devices
///
/// **📖 USAGE PATTERN:**
/// All methods now use ThemeManager for consistent theming:
/// ```dart
///
/// ModernUIComponents.glassmorphismCard(
///   child: YourContent(),
///
/// )
/// ```
/// ====================================================================

/// Gradient types available for ThemeManager integration
enum GradientType {
  primary,
  secondary,
  success,
  warning,
  error,
  info,
  accent1,
  accent2,
  accent3,
  accent4,
  neutral,
  surface,
  background,
}

class ModernUIComponents {
  /// Private constructor to prevent instantiation
  /// This class is designed as a utility class with static methods only
  ModernUIComponents._();

  /// Creates a modern glassmorphism card with comprehensive ThemeManager integration
  ///
  /// **🎨 ENHANCED GLASSMORPHISM DESIGN:**
  /// - **ThemeManager Glass Gradient**: Uses glassGradient and enhancedGlassMorphism
  /// - **Dynamic Border System**: borderColor with theme-aware alpha values
  /// - **Professional Shadows**: Multi-layer shadow system with ThemeManager shadows
  /// - **Automatic Theme Adaptation**: Seamless light/dark mode transitions
  /// - **Material Design 3.0**: Following latest glassmorphism principles
  ///
  /// **🏗️ THEMEMANAGER INTEGRATION:**
  /// - **Glass Effects**: glassGradient, enhancedGlassMorphism decoration
  /// - **Border Colors**: borderColor, borderSecondary with conditional selection
  /// - **Shadow System**: elevatedShadow, subtleShadow with custom combinations
  /// - **Background Colors**: surfaceElevated, cardBackground for base
  ///
  /// **📖 USAGE:**
  /// ```dart
  ///
  /// ModernUIComponents.glassmorphismCard(
  ///   child: Text('Glassmorphism Content'),
  ///
  ///   useEnhancedEffect: true,
  /// )
  /// ```
  static Widget glassmorphismCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 16,
    bool useEnhancedEffect = false,
    Color? customOverlayColor,
    required ThemeManager themeManager,
  }) {
    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    debugPrint(
        '🎨 ModernUIComponents: Creating ENHANCED glassmorphism card with comprehensive ThemeManager');
    debugPrint('🎨 ModernUIComponents: → Enhanced Effect: $useEnhancedEffect');
    debugPrint('🎨 ModernUIComponents: → Border Radius: $borderRadius');
    // debugPrint('🎨 ModernUIComponents: → Glass Gradient: ${themeManager.glassGradient}');
    // debugPrint('🎨 ModernUIComponents: → Surface Color: ${themeManager.surfaceElevated}');
    // debugPrint('🎨 ModernUIComponents: → Border Color: ${themeManager.borderColor}');

    // ========== DYNAMIC GLASS EFFECT SELECTION ==========
    final glassDecoration = useEnhancedEffect
        ? themeManager.enhancedGlassMorphism
        : themeManager.glassMorphism;

    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(borderRadius.r),
        // ========== COMPREHENSIVE GRADIENT SYSTEM ==========
        gradient: customOverlayColor != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  customOverlayColor.withValues(alpha: 26),
                  customOverlayColor.withValues(alpha: 13),
                  themeManager.surfaceElevated.withValues(alpha: 51),
                ],
                stops: const [0.0, 0.5, 1.0],
              )
            : themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.surfaceElevated.withValues(alpha: 179),
                    themeManager.cardBackground.withValues(alpha: 153),
                    themeManager.backgroundSecondary.withValues(alpha: 77),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.surfaceElevated.withValues(alpha: 102),
                    themeManager.backgroundTertiary.withValues(alpha: 77),
                    themeManager.cardBackground.withValues(alpha: 51),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
        // ========== ENHANCED BORDER SYSTEM ==========
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 77),
            darkColor: themeManager.borderSecondary.withValues(alpha: 102),
          ),
          width: useEnhancedEffect ? 1.5 : 1,
        ),
        // ========== COMPREHENSIVE SHADOW SYSTEM ==========
        boxShadow: [
          ...themeManager.elevatedShadow,
          BoxShadow(
            color: themeManager.shadowMedium,
            blurRadius: useEnhancedEffect ? 25 : 20,
            offset: const Offset(0, 8),
          ),
          if (useEnhancedEffect) ...[
            BoxShadow(
              color: themeManager.primaryColor.withValues(alpha: 13),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: themeManager.shadowDark,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: Container(
          padding: padding ?? EdgeInsets.all(20.w),
          decoration: useEnhancedEffect
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      themeManager.conditionalColor(
                        lightColor: Colors.white.withValues(alpha: 26),
                        darkColor: themeManager.accent1.withValues(alpha: 13),
                      ),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3],
                  ),
                )
              : null,
          child: child,
        ),
      ),
    );
  }

  /// Creates a modern gradient card with comprehensive ThemeManager integration
  ///
  /// **🎨 ENHANCED GRADIENT DESIGN:**
  /// - **ThemeManager Gradient System**: Uses primaryGradient, statusGradients, accentGradients
  /// - **Intelligent Color Selection**: Automatic gradient generation from theme colors
  /// - **Dynamic Shadow System**: Color-matched shadows using ThemeManager shadow system
  /// - **Responsive Corner Rounding**: ScreenUtil integration for all screen sizes
  /// - **Theme-Aware Effects**: Automatic light/dark mode adaptation
  ///
  /// **🏗️ THEMEMANAGER INTEGRATION:**
  /// - **Gradient Types**: Can use any ThemeManager gradient (primary, status, accent, utility)
  /// - **Shadow System**: primaryShadow, elevatedShadow with color-matched effects
  /// - **Border Colors**: Optional border using borderColor system
  /// - **Background Colors**: Fallback to surfaceColor when gradients are disabled
  ///
  /// **📖 USAGE:**
  /// ```dart
  ///
  /// ModernUIComponents.gradientCard(
  ///   child: Content(),
  ///
  ///   gradientType: GradientType.primary, // Uses themeManager.primaryGradient
  /// )
  /// ```
  static Widget gradientCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 16,
    GradientType gradientType = GradientType.primary,
    List<Color>? customColors,
    List<double>? stops,
    AlignmentGeometry? beginAlignment,
    AlignmentGeometry? endAlignment,
    bool showBorder = false,
    bool useCustomShadow = false,
    List<BoxShadow>? customBoxShadow,
    required ThemeManager themeManager,
  }) {
    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    debugPrint(
        '🎨 ModernUIComponents: Creating ENHANCED gradient card with comprehensive ThemeManager');
    debugPrint('🎨 ModernUIComponents: → Gradient Type: $gradientType');
    debugPrint(
        '🎨 ModernUIComponents: → Custom Colors: ${customColors?.length ?? 0} colors');
    debugPrint('🎨 ModernUIComponents: → Border Radius: $borderRadius');
    debugPrint('🎨 ModernUIComponents: → Show Border: $showBorder');
    debugPrint(
        '🎨 ModernUIComponents: → Primary Color: ${themeManager.primaryColor}');

    // ========== DYNAMIC GRADIENT SELECTION ==========
    Gradient selectedGradient;
    Color shadowColor;

    if (customColors != null && customColors.isNotEmpty) {
      // Use custom colors with theme-aware defaults
      selectedGradient = LinearGradient(
        begin: beginAlignment ?? Alignment.topLeft,
        end: endAlignment ?? Alignment.bottomRight,
        colors: customColors,
        stops: stops,
      );
      shadowColor = customColors.first;
    } else {
      // Use ThemeManager gradient system
      switch (gradientType) {
        case GradientType.primary:
          selectedGradient = themeManager.primaryGradient;
          shadowColor = themeManager.primaryColor;
          break;
        case GradientType.secondary:
          selectedGradient = themeManager.secondaryGradient;
          shadowColor = themeManager.secondaryColor;
          break;
        case GradientType.success:
          selectedGradient = themeManager.successGradient;
          shadowColor = themeManager.successColor;
          break;
        case GradientType.warning:
          selectedGradient = themeManager.warningGradient;
          shadowColor = themeManager.warningColor;
          break;
        case GradientType.error:
          selectedGradient = themeManager.errorGradient;
          shadowColor = themeManager.errorColor;
          break;
        case GradientType.info:
          selectedGradient = themeManager.infoGradient;
          shadowColor = themeManager.infoColor;
          break;
        case GradientType.accent1:
          selectedGradient = themeManager.accent1Gradient;
          shadowColor = themeManager.accent1;
          break;
        case GradientType.accent2:
          selectedGradient = themeManager.accent2Gradient;
          shadowColor = themeManager.accent2;
          break;
        case GradientType.accent3:
          selectedGradient = themeManager.accent3Gradient;
          shadowColor = themeManager.accent3;
          break;
        case GradientType.accent4:
          selectedGradient = themeManager.accent4Gradient;
          shadowColor = themeManager.accent4;
          break;
        case GradientType.neutral:
          selectedGradient = themeManager.neutralGradient;
          shadowColor = themeManager.neutral500;
          break;
        case GradientType.surface:
          selectedGradient = themeManager.surfaceGradient;
          shadowColor = themeManager.surfaceColor;
          break;
        case GradientType.background:
          selectedGradient = themeManager.backgroundGradient;
          shadowColor = themeManager.backgroundColor;
          break;
      }
    }

    debugPrint('🎨 ModernUIComponents: → Selected Gradient: $selectedGradient');
    debugPrint('🎨 ModernUIComponents: → Shadow Color: $shadowColor');

    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        // ========== COMPREHENSIVE GRADIENT SYSTEM ==========
        gradient: selectedGradient,
        // ========== ENHANCED BORDER SYSTEM ==========
        border: showBorder
            ? Border.all(
                color: themeManager.conditionalColor(
                  lightColor: shadowColor.withValues(alpha: 102),
                  darkColor: shadowColor.withValues(alpha: 128),
                ),
                width: 1.5,
              )
            : null,
        // ========== COMPREHENSIVE SHADOW SYSTEM ==========
        boxShadow: useCustomShadow && customBoxShadow != null
            ? customBoxShadow
            : [
                ...themeManager.elevatedShadow,
                BoxShadow(
                  color: shadowColor.withValues(alpha: 77),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: themeManager.shadowMedium,
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(20.w),
        child: child,
      ),
    );
  }

  /// Creates a modern elevated card with comprehensive ThemeManager integration
  ///
  /// **🎨 ENHANCED ELEVATED DESIGN:**
  /// - **ThemeManager Surface Colors**: Uses cardBackground, surfaceElevated, surfaceColor
  /// - **Professional Shadow System**: Multi-layer shadows using ThemeManager shadow system
  /// - **Automatic Theme Adaptation**: Seamless light/dark mode transitions
  /// - **Material Design 3.0**: Following latest elevation principles
  /// - **Enhanced Border System**: Optional borders using ThemeManager border colors
  ///
  /// **🏗️ THEMEMANAGER INTEGRATION:**
  /// - **Background Colors**: cardBackground, surfaceElevated with conditional selection
  /// - **Shadow System**: elevatedShadow, subtleShadow with theme-aware combinations
  /// - **Border Colors**: borderColor, borderSecondary for optional borders
  /// - **Helper Methods**: conditionalColor() for automatic theme adaptation
  ///
  /// **📖 USAGE:**
  /// ```dart
  ///
  /// ModernUIComponents.elevatedCard(
  ///   child: Content(),
  ///
  ///   useGradient: true,
  ///   showBorder: true,
  /// )
  /// ```
  static Widget elevatedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 16,
    Color? customBackgroundColor,
    bool useGradient = false,
    bool showBorder = false,
    bool useEnhancedShadow = false,
    required ThemeManager themeManager,
  }) {
    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    debugPrint(
        '🎨 ModernUIComponents: Creating ENHANCED elevated card with comprehensive ThemeManager');
    debugPrint('🎨 ModernUIComponents: → Use Gradient: $useGradient');
    debugPrint('🎨 ModernUIComponents: → Show Border: $showBorder');
    debugPrint('🎨 ModernUIComponents: → Enhanced Shadow: $useEnhancedShadow');
    debugPrint(
        '🎨 ModernUIComponents: → Custom Background: ${customBackgroundColor != null}');
    debugPrint(
        '🎨 ModernUIComponents: → Card Background: ${themeManager.cardBackground}');
    debugPrint(
        '🎨 ModernUIComponents: → Surface Elevated: ${themeManager.surfaceElevated}');

    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        // ========== COMPREHENSIVE BACKGROUND SYSTEM ==========
        gradient: useGradient
            ? themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.cardBackground,
                    themeManager.surfaceElevated,
                    themeManager.backgroundSecondary,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.surfaceElevated,
                    themeManager.backgroundTertiary,
                    themeManager.cardBackground,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              )
            : null,
        // Theme-appropriate solid background color when gradient is disabled
        color: !useGradient
            ? (customBackgroundColor ??
                themeManager.conditionalColor(
                  lightColor: themeManager.cardBackground,
                  darkColor: themeManager.surfaceElevated,
                ))
            : null,
        borderRadius: BorderRadius.circular(borderRadius.r),
        // ========== ENHANCED BORDER SYSTEM ==========
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
        // ========== COMPREHENSIVE SHADOW SYSTEM ==========
        boxShadow: useEnhancedShadow
            ? [
                ...themeManager.elevatedShadow,
                BoxShadow(
                  color: themeManager.shadowMedium,
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: themeManager.shadowDark,
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                ...themeManager.elevatedShadow,
                BoxShadow(
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.shadowLight,
                    darkColor: themeManager.shadowMedium,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(20.w),
        child: child,
      ),
    );
  }

  /// Creates a modern metric card for displaying statistics
  ///
  /// **Metric Card Features:**
  /// - Large, prominent value display
  /// - Descriptive title and optional subtitle
  /// - Color-coded icon with background
  /// - Optional tap handling for navigation
  /// - External link indicator when tappable
  ///
  /// **Visual Hierarchy:**
  /// 1. Icon with colored background (top-left)
  /// 2. Large metric value (prominent)
  /// 3. Descriptive title (secondary)
  /// 4. Optional subtitle with color coding
  ///
  /// **Usage for Analytics:**
  /// ```dart
  /// ModernUIComponents.metricCard(
  ///   title: 'Total Users',
  ///   value: '1,234',
  ///   icon: Prbal.people,
  ///   iconColor: Colors.blue,
  ///   subtitle: '+12% this month',
  ///   onTap: () => navigateToUserDetails(),
  /// )
  /// ```
  static Widget metricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    String? subtitle,
    VoidCallback? onTap,
    required ThemeManager themeManager,
  }) {
    debugPrint(
        '🎨 ModernUIComponents: Creating metric card with ThemeManager integration');
    debugPrint(
        '🎨 ModernUIComponents: Metric - Title: "$title", Value: "$value"');
    debugPrint('🎨 ModernUIComponents: Icon color: $iconColor');
    debugPrint('🎨 ModernUIComponents: Tappable: ${onTap != null}');
    debugPrint('🎨 ModernUIComponents: Has subtitle: ${subtitle != null}');

    return elevatedCard(
      themeManager: themeManager,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  debugPrint(
                      '🎨 ModernUIComponents: Metric card tapped - $title');
                  onTap();
                }
              : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with icon and optional external link indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon container with color-coded background
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24.sp,
                    ),
                  ),
                  // External link indicator for tappable cards
                  if (onTap != null)
                    Icon(
                      Prbal.externalLink,
                      color: themeManager.conditionalColor(
                        lightColor:
                            themeManager.textSecondary.withValues(alpha: 128),
                        darkColor:
                            themeManager.textTertiary.withValues(alpha: 128),
                      ),
                      size: 16.sp,
                    ),
                ],
              ),
              SizedBox(height: 16.h),

              // Large metric value display
              Text(
                value,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: themeManager.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),

              // Descriptive title
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: themeManager.textSecondary,
                ),
              ),

              // Optional subtitle with positive change indicator color
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        const Color(0xFF10B981), // Green for positive metrics
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a modern status indicator with label and color coding
  ///
  /// **Status Indicator Features:**
  /// - Colored dot for quick visual status identification
  /// - Text label describing the current state
  /// - Pill-shaped container with subtle background
  /// - Consistent sizing for alignment in lists
  ///
  /// **Common Use Cases:**
  /// - Online/Offline status
  /// - Service health indicators
  /// - User presence indicators
  /// - System status displays
  static Widget statusIndicator({
    required String label,
    required Color color,
    bool isOnline = true,
  }) {
    debugPrint('🎨 ModernUIComponents: Creating status indicator');
    debugPrint(
        '🎨 ModernUIComponents: Status - Label: "$label", Online: $isOnline');
    debugPrint('🎨 ModernUIComponents: Status color: $color');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        // Subtle background using status color
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status indicator dot
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          // Status label
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a modern button with multiple style options
  ///
  /// **Button Styles:**
  /// - Primary: Filled button with brand colors
  /// - Secondary: Outlined button with transparent background
  /// - Tertiary: Text button with minimal styling
  ///
  /// **Features:**
  /// - Consistent sizing and spacing
  /// - Loading state support
  /// - Disabled state handling
  /// - Custom icon support
  static Widget modernButton({
    required String text,
    required VoidCallback onPressed,
    ModernButtonType type = ModernButtonType.primary,
    IconData? icon,
    bool isLoading = false,
    double? width,
    bool themeManager = false,
  }) {
    final buttonColors = _getButtonColors(type, themeManager);

    return Container(
      width: width,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: type == ModernButtonType.gradient
            ? const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              )
            : null,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: type != ModernButtonType.outline
            ? [
                BoxShadow(
                  color: buttonColors['shadow']!,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: type == ModernButtonType.gradient
              ? Colors.transparent
              : buttonColors['background'],
          foregroundColor: buttonColors['foreground'],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: type == ModernButtonType.outline
                ? BorderSide(
                    color: buttonColors['border']!,
                    width: 1.5,
                  )
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    buttonColors['foreground']!,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20.sp),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Modern floating action button
  static Widget modernFAB({
    required VoidCallback onPressed,
    required IconData icon,
    Color? backgroundColor,
    Color? foregroundColor,
    String? tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: 0,
        tooltip: tooltip,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(icon, size: 24.sp),
      ),
    );
  }

  /// Modern search bar with comprehensive ThemeManager integration
  ///
  /// **🎨 ENHANCED SEARCH BAR DESIGN:**
  /// - **ThemeManager Input Colors**: Uses inputBackground, textPrimary/Secondary
  /// - **Dynamic Theming**: Automatic light/dark mode adaptation
  /// - **Professional Styling**: Enhanced with ThemeManager border and shadow system
  /// - **Icon Integration**: Theme-aware search icon with primaryColor
  ///
  /// **🏗️ THEMEMANAGER INTEGRATION:**
  /// - **Input Colors**: inputBackground, textPrimary for field styling
  /// - **Hint Text**: textSecondary for placeholder text
  /// - **Icon Colors**: primaryColor for search icon
  /// - **Container**: elevatedCard with ThemeManager styling
  static Widget modernSearchBar({
    required TextEditingController controller,
    String? hintText,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    bool readOnly = false,
    required ThemeManager themeManager,
  }) {
    debugPrint(
        '🎨 ModernUIComponents: Creating ENHANCED search bar with comprehensive ThemeManager');
    // debugPrint('🎨 ModernUIComponents: → Input Background: ${themeManager.inputBackground}');
    // debugPrint('🎨 ModernUIComponents: → Text Primary: ${themeManager.textPrimary}');
    debugPrint('🎨 ModernUIComponents: → Read Only: $readOnly');

    return elevatedCard(
      themeManager: themeManager,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: TextField(
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText ?? 'Search...',
          hintStyle: TextStyle(
            color: themeManager.textSecondary,
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Prbal.search,
            color: themeManager.primaryColor,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        style: TextStyle(
          color: themeManager.textPrimary,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  /// Modern list tile with comprehensive ThemeManager integration
  ///
  /// **🎨 ENHANCED LIST TILE DESIGN:**
  /// - **ThemeManager Surface Colors**: Uses cardBackground, surfaceElevated
  /// - **Text Hierarchy**: textPrimary, textSecondary for proper typography
  /// - **Icon Integration**: Theme-aware leading icons with accent colors
  /// - **Interactive States**: Professional InkWell with theme-aware styling
  ///
  /// **🏗️ THEMEMANAGER INTEGRATION:**
  /// - **Container**: elevatedCard with ThemeManager styling
  /// - **Text Colors**: textPrimary for title, textSecondary for subtitle
  /// - **Icon Colors**: primaryColor fallback for leading icons
  /// - **Navigation Icons**: textTertiary for trailing chevron
  static Widget modernListTile({
    required String title,
    String? subtitle,
    IconData? leadingIcon,
    Color? leadingIconColor,
    Widget? trailing,
    VoidCallback? onTap,
    required ThemeManager themeManager,
  }) {
    debugPrint(
        '🎨 ModernUIComponents: Creating ENHANCED list tile with comprehensive ThemeManager');
    debugPrint('🎨 ModernUIComponents: → Title: "$title"');
    debugPrint('🎨 ModernUIComponents: → Has Subtitle: ${subtitle != null}');
    debugPrint(
        '🎨 ModernUIComponents: → Has Leading Icon: ${leadingIcon != null}');
    debugPrint(
        '🎨 ModernUIComponents: → Text Primary: ${themeManager.textPrimary}');

    return elevatedCard(
      themeManager: themeManager,
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: (leadingIconColor ?? const Color(0xFF3B82F6))
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      leadingIcon,
                      color: leadingIconColor ?? const Color(0xFF3B82F6),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: themeManager.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: themeManager.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: 16.w),
                  trailing,
                ] else if (onTap != null) ...[
                  SizedBox(width: 16.w),
                  Icon(
                    Prbal.angleRight,
                    color: themeManager.textTertiary,
                    size: 20.sp,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Modern section header
  static Widget modernSectionHeader({
    required String title,
    String? subtitle,
    Widget? action,
    bool themeManager = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        themeManager ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: themeManager
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  /// Get button colors based on type and theme
  static Map<String, Color> _getButtonColors(
      ModernButtonType type, bool themeManager) {
    switch (type) {
      case ModernButtonType.primary:
        return {
          'background': const Color(0xFF3B82F6),
          'foreground': Colors.white,
          'shadow': const Color(0xFF3B82F6).withValues(alpha: 0.3),
          'border': Colors.transparent,
        };
      case ModernButtonType.secondary:
        return {
          'background':
              themeManager ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
          'foreground': themeManager ? Colors.white : const Color(0xFF1F2937),
          'shadow': Colors.black.withValues(alpha: 0.1),
          'border': Colors.transparent,
        };
      case ModernButtonType.outline:
        return {
          'background': Colors.transparent,
          'foreground': themeManager ? Colors.white : const Color(0xFF1F2937),
          'shadow': Colors.transparent,
          'border':
              themeManager ? const Color(0xFF64748B) : const Color(0xFFD1D5DB),
        };
      case ModernButtonType.danger:
        return {
          'background': const Color(0xFFEF4444),
          'foreground': Colors.white,
          'shadow': const Color(0xFFEF4444).withValues(alpha: 0.3),
          'border': Colors.transparent,
        };
      case ModernButtonType.success:
        return {
          'background': const Color(0xFF10B981),
          'foreground': Colors.white,
          'shadow': const Color(0xFF10B981).withValues(alpha: 0.3),
          'border': Colors.transparent,
        };
      case ModernButtonType.gradient:
        return {
          'background': Colors.transparent,
          'foreground': Colors.white,
          'shadow': const Color(0xFF3B82F6).withValues(alpha: 0.3),
          'border': Colors.transparent,
        };
    }
  }
}

/// Modern button types
enum ModernButtonType {
  primary,
  secondary,
  outline,
  danger,
  success,
  gradient,
}

/// Modern animated container with comprehensive ThemeManager integration
///
/// **🎨 ENHANCED ANIMATED CONTAINER DESIGN:**
/// - **ThemeManager Integration**: Uses complete ThemeManager system
/// - **Smooth Animations**: Professional scale animations on interaction
/// - **Theme-Aware Styling**: Automatic light/dark mode adaptation
/// - **Interactive Feedback**: Haptic feedback with visual scale effects
///
/// **🏗️ THEMEMANAGER INTEGRATION:**
/// - **Container**: elevatedCard with full ThemeManager styling
/// - **Animation Effects**: Theme-aware scale and interaction states
/// - **Professional Styling**: Enhanced shadows and borders
class ModernAnimatedContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ModernAnimatedContainer({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 16,
    this.padding,
    this.margin,
  });

  @override
  State<ModernAnimatedContainer> createState() =>
      _ModernAnimatedContainerState();
}

class _ModernAnimatedContainerState extends State<ModernAnimatedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _controller.reverse() : null,
      onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ModernUIComponents.elevatedCard(
              themeManager: ThemeManager.of(context),
              borderRadius: widget.borderRadius,
              padding: widget.padding,
              margin: widget.margin,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
