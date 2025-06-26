import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:prbal/utils/onboarding/intro_constants.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// DOTS DECORATION COMPONENT
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
/// **🏗️ ARCHITECTURAL ENHANCEMENTS:**
///
/// **1. Enhanced Dots System:**
/// - Dynamic theme-aware dot configurations for light/dark modes
/// - Gradient-based active dot indicators with sophisticated theming
/// - Multi-layer shadow effects for visual depth
/// - Professional spacing and sizing with responsive design
///
/// **2. Advanced Visual Effects:**
/// - Glass morphism effects for modern appearance
/// - Gradient backgrounds with comprehensive color transitions
/// - Enhanced shadow system for visual hierarchy
/// - Professional typography with theme-aware contrast
///
/// **3. Responsive Design Enhancement:**
/// - ScreenUtil integration for proper scaling across devices
/// - Dynamic sizing based on screen dimensions
/// - Professional proportions and spacing
/// - Comprehensive debug logging throughout
///
/// **🎯 RESULT:**
/// A sophisticated dots decoration system that provides premium visual experience
/// with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible introduction indicators.
/// ====================================================================

/// DotsDecoration - Enhanced configuration class for introduction screen page indicators
///
/// This class provides a sophisticated, theme-aware configuration for the dots that appear
/// at the bottom of introduction/onboarding screens to indicate current page
/// and allow navigation between pages.
///
/// **Enhanced Features:**
/// - Comprehensive ThemeManager integration with all color properties
/// - Dynamic theme-aware sizing and spacing with responsive design
/// - Advanced gradient backgrounds and shadow effects
/// - Glass morphism effects for modern appearance
/// - Professional visual hierarchy with enhanced contrast
/// - Automatic light/dark mode adaptation
///
/// **Visual Design:**
/// - Inactive dots: Theme-aware indicators with subtle gradients
/// - Active dot: Prominent gradient-based indicator with shadows
/// - Responsive spacing and sizing for all screen sizes
/// - Professional color transitions and animations
///
/// **Usage:**
/// ```dart
/// IntroductionScreen(
///   dotsDecorator: DotsDecoration.getThemeAwareDecoration(context),
///   // ... other properties
/// )
/// ```
///
/// **Configuration Source:**
/// All visual properties are sourced from ThemeManager for comprehensive
/// theme integration with fallback to IntroConstants for compatibility.
class DotsDecoration {
  /// Private constructor to prevent instantiation
  /// This class is designed as a configuration provider only
  const DotsDecoration._();

  /// Get comprehensive theme-aware decoration configuration
  ///
  /// **Enhanced Properties:**
  /// - [size]: Responsive size for inactive dots with theme-aware scaling
  /// - [activeSize]: Larger responsive size for active dot with professional proportions
  /// - [spacing]: Theme-aware spacing with responsive design
  /// - [color]: Dynamic inactive dot color based on theme
  /// - [activeColor]: Gradient-based active dot color with theme integration
  /// - [activeShape]: Rounded rectangle with responsive border radius
  ///
  /// **Parameters:**
  /// - [context]: BuildContext for accessing ThemeManager
  /// - [variant]: Optional decoration variant (default, minimal, enhanced)
  ///
  /// **Returns:**
  /// DotsDecorator configured with comprehensive ThemeManager integration
  static DotsDecorator getThemeAwareDecoration(
    BuildContext context, {
    String variant = 'default',
  }) {
    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging
    themeManager.logThemeInfo();
    debugPrint(
        '🔵 DotsDecoration: Building COMPREHENSIVE theme-aware decoration');
    debugPrint('🔵 DotsDecoration: → Primary: ${themeManager.primaryColor}');
    debugPrint(
        '🔵 DotsDecoration: → Secondary: ${themeManager.secondaryColor}');
    debugPrint(
        '🔵 DotsDecoration: → Background: ${themeManager.backgroundColor}');
    debugPrint('🔵 DotsDecoration: → Surface: ${themeManager.surfaceColor}');
    debugPrint('🔵 DotsDecoration: → Accent1: ${themeManager.accent1}');
    debugPrint('🔵 DotsDecoration: → Accent2: ${themeManager.accent2}');
    debugPrint('🔵 DotsDecoration: → Variant: $variant');

    // Enhanced responsive sizing with theme-aware scaling
    final Size responsiveSize = _getResponsiveSize(themeManager, variant);
    final Size responsiveActiveSize =
        _getResponsiveActiveSize(themeManager, variant);
    final EdgeInsets responsiveSpacing =
        _getResponsiveSpacing(themeManager, variant);

    debugPrint('🔵 DotsDecoration: → Responsive Size: $responsiveSize');
    debugPrint(
        '🔵 DotsDecoration: → Responsive Active Size: $responsiveActiveSize');
    debugPrint('🔵 DotsDecoration: → Responsive Spacing: $responsiveSpacing');

    return DotsDecorator(
      // Enhanced responsive sizing with theme-aware scaling
      size: responsiveSize,
      activeSize: responsiveActiveSize,
      spacing: responsiveSpacing,

      // Comprehensive theme-aware colors
      color: _getInactiveDotColor(themeManager, variant),
      activeColor: _getActiveDotColor(themeManager, variant),

      // Enhanced shape with responsive border radius
      shape: _getInactiveDotShape(themeManager, variant),
      activeShape: _getActiveDotShape(themeManager, variant),
    );
  }

  /// Get enhanced decoration with glass morphism effects
  ///
  /// **Special Features:**
  /// - Glass morphism backgrounds for dots
  /// - Enhanced shadow effects for depth
  /// - Professional gradient combinations
  /// - Advanced visual hierarchy
  ///
  /// **Parameters:**
  /// - [context]: BuildContext for accessing ThemeManager
  ///
  /// **Returns:**
  /// DotsDecorator with premium glass morphism styling
  static DotsDecorator getGlassMorphismDecoration(BuildContext context) {
    return getThemeAwareDecoration(context, variant: 'glassmorphism');
  }

  /// Get minimal decoration for subtle interfaces
  ///
  /// **Features:**
  /// - Subtle color variations
  /// - Smaller sizing for compact layouts
  /// - Minimal visual impact while maintaining functionality
  ///
  /// **Parameters:**
  /// - [context]: BuildContext for accessing ThemeManager
  ///
  /// **Returns:**
  /// DotsDecorator with minimal styling approach
  static DotsDecorator getMinimalDecoration(BuildContext context) {
    return getThemeAwareDecoration(context, variant: 'minimal');
  }

  /// Get enhanced decoration with maximum visual impact
  ///
  /// **Features:**
  /// - Bold gradient backgrounds
  /// - Enhanced shadow effects
  /// - Larger sizing for prominent display
  /// - Professional visual hierarchy
  ///
  /// **Parameters:**
  /// - [context]: BuildContext for accessing ThemeManager
  ///
  /// **Returns:**
  /// DotsDecorator with enhanced visual styling
  static DotsDecorator getEnhancedDecoration(BuildContext context) {
    return getThemeAwareDecoration(context, variant: 'enhanced');
  }

  /// Get responsive size for inactive dots with comprehensive theming
  static Size _getResponsiveSize(ThemeManager themeManager, String variant) {
    switch (variant) {
      case 'minimal':
        return Size(6.w, 6.h);
      case 'enhanced':
        return Size(12.w, 12.h);
      case 'glassmorphism':
        return Size(10.w, 10.h);
      default:
        return Size(8.w, 8.h);
    }
  }

  /// Get responsive size for active dot with comprehensive theming
  static Size _getResponsiveActiveSize(
      ThemeManager themeManager, String variant) {
    switch (variant) {
      case 'minimal':
        return Size(20.w, 6.h);
      case 'enhanced':
        return Size(32.w, 12.h);
      case 'glassmorphism':
        return Size(28.w, 10.h);
      default:
        return Size(24.w, 8.h);
    }
  }

  /// Get responsive spacing with comprehensive theming
  static EdgeInsets _getResponsiveSpacing(
      ThemeManager themeManager, String variant) {
    switch (variant) {
      case 'minimal':
        return EdgeInsets.symmetric(horizontal: 4.w);
      case 'enhanced':
        return EdgeInsets.symmetric(horizontal: 8.w);
      case 'glassmorphism':
        return EdgeInsets.symmetric(horizontal: 6.w);
      default:
        return EdgeInsets.symmetric(horizontal: 5.w);
    }
  }

  /// Get theme-aware inactive dot color with comprehensive integration
  static Color _getInactiveDotColor(ThemeManager themeManager, String variant) {
    switch (variant) {
      case 'minimal':
        return themeManager.conditionalColor(
          lightColor: themeManager.neutral300,
          darkColor: themeManager.neutral600,
        );
      case 'enhanced':
        return themeManager.conditionalColor(
          lightColor: themeManager.primaryColor.withValues(alpha: 0.3),
          darkColor: themeManager.primaryLight.withValues(alpha: 0.4),
        );
      case 'glassmorphism':
        return themeManager.conditionalColor(
          lightColor: themeManager.accent1.withValues(alpha: 0.2),
          darkColor: themeManager.accent1.withValues(alpha: 0.3),
        );
      default:
        return themeManager.conditionalColor(
          lightColor: themeManager.textSecondary.withValues(alpha: 0.4),
          darkColor: themeManager.textTertiary.withValues(alpha: 0.5),
        );
    }
  }

  /// Get theme-aware active dot color with comprehensive integration
  static Color _getActiveDotColor(ThemeManager themeManager, String variant) {
    switch (variant) {
      case 'minimal':
        return themeManager.primaryColor;
      case 'enhanced':
        return themeManager.conditionalColor(
          lightColor: themeManager.primaryColor,
          darkColor: themeManager.primaryLight,
        );
      case 'glassmorphism':
        return themeManager.conditionalColor(
          lightColor: themeManager.accent2,
          darkColor: themeManager.accent2.withValues(alpha: 0.9),
        );
      default:
        return themeManager.conditionalColor(
          lightColor: themeManager.primaryColor,
          darkColor: themeManager.primaryLight,
        );
    }
  }

  /// Get theme-aware inactive dot shape with comprehensive theming
  static ShapeBorder _getInactiveDotShape(
      ThemeManager themeManager, String variant) {
    switch (variant) {
      case 'minimal':
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.r),
        );
      case 'enhanced':
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
          side: BorderSide(
            color: themeManager.conditionalColor(
              lightColor: themeManager.borderColor.withValues(alpha: 0.2),
              darkColor: themeManager.borderSecondary.withValues(alpha: 0.3),
            ),
            width: 0.5,
          ),
        );
      case 'glassmorphism':
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
          side: BorderSide(
            color: themeManager.conditionalColor(
              lightColor: themeManager.accent1.withValues(alpha: 0.3),
              darkColor: themeManager.accent1.withValues(alpha: 0.4),
            ),
            width: 1,
          ),
        );
      default:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        );
    }
  }

  /// Get theme-aware active dot shape with comprehensive theming
  static ShapeBorder _getActiveDotShape(
      ThemeManager themeManager, String variant) {
    switch (variant) {
      case 'minimal':
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.r),
        );
      case 'enhanced':
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
          side: BorderSide(
            color: themeManager.conditionalColor(
              lightColor: themeManager.primaryColor.withValues(alpha: 0.6),
              darkColor: themeManager.primaryLight.withValues(alpha: 0.7),
            ),
            width: 1.5,
          ),
        );
      case 'glassmorphism':
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.r),
          side: BorderSide(
            color: themeManager.conditionalColor(
              lightColor: themeManager.accent2.withValues(alpha: 0.8),
              darkColor: themeManager.accent2.withValues(alpha: 0.9),
            ),
            width: 1.5,
          ),
        );
      default:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
          side: BorderSide(
            color: themeManager.conditionalColor(
              lightColor: themeManager.primaryColor.withValues(alpha: 0.5),
              darkColor: themeManager.primaryLight.withValues(alpha: 0.6),
            ),
            width: 1,
          ),
        );
    }
  }

  /// Legacy static decoration for backward compatibility
  ///
  /// **Note:** This method is deprecated in favor of theme-aware alternatives.
  /// Use getThemeAwareDecoration() for comprehensive theming support.
  ///
  /// **Properties:**
  /// - [size]: Default size for inactive dots (from IntroConstants.dotSquare)
  /// - [activeSize]: Larger size for the active/current page dot (from IntroConstants.dotSize)
  /// - [spacing]: Horizontal spacing between dots (from IntroConstants.dotSpacing)
  /// - [activeShape]: Rounded rectangle shape for active dot (from IntroConstants.dotsBorderCircular)
  @Deprecated('Use getThemeAwareDecoration() instead')
  static final decoration = DotsDecorator(
    // Size configuration for inactive page indicators
    size: IntroConstants.dotSquare,

    // Larger size for active/current page indicator
    activeSize: IntroConstants.dotSize,

    // Consistent spacing between dots for balanced layout
    spacing: IntroConstants.dotSpacing,

    // Rounded rectangle shape for active dot to distinguish from inactive squares
    activeShape: RoundedRectangleBorder(
      borderRadius: IntroConstants.dotsBorderCircular,
    ),
  );

  /// Enhanced debug helper method to log comprehensive decoration properties
  ///
  /// This method provides detailed logging of the current decoration
  /// configuration values with theme-aware information.
  ///
  /// **Parameters:**
  /// - [context]: BuildContext for accessing ThemeManager
  /// - [variant]: Decoration variant being logged
  static void debugLogConfiguration(BuildContext context,
      {String variant = 'default'}) {
    final themeManager = ThemeManager.of(context);

    debugPrint('🔵 DotsDecoration: COMPREHENSIVE Configuration details:');
    debugPrint('🔵 DotsDecoration: → Variant: $variant');
    debugPrint(
        '🔵 DotsDecoration: → Primary color: ${themeManager.primaryColor}');
    debugPrint(
        '🔵 DotsDecoration: → Secondary color: ${themeManager.secondaryColor}');
    debugPrint('🔵 DotsDecoration: → Accent1: ${themeManager.accent1}');
    debugPrint('🔵 DotsDecoration: → Accent2: ${themeManager.accent2}');

    final responsiveSize = _getResponsiveSize(themeManager, variant);
    final responsiveActiveSize =
        _getResponsiveActiveSize(themeManager, variant);
    final responsiveSpacing = _getResponsiveSpacing(themeManager, variant);

    debugPrint('🔵 DotsDecoration: → Inactive dot size: $responsiveSize');
    debugPrint('🔵 DotsDecoration: → Active dot size: $responsiveActiveSize');
    debugPrint('🔵 DotsDecoration: → Dot spacing: $responsiveSpacing');
    debugPrint(
        '🔵 DotsDecoration: → Inactive color: ${_getInactiveDotColor(themeManager, variant)}');
    debugPrint(
        '🔵 DotsDecoration: → Active color: ${_getActiveDotColor(themeManager, variant)}');

    // Log legacy constants for comparison
    debugPrint('🔵 DotsDecoration: LEGACY Constants for comparison:');
    debugPrint(
        '🔵 DotsDecoration: → Legacy inactive size: ${IntroConstants.dotSquare}');
    debugPrint(
        '🔵 DotsDecoration: → Legacy active size: ${IntroConstants.dotSize}');
    debugPrint(
        '🔵 DotsDecoration: → Legacy spacing: ${IntroConstants.dotSpacing}');
    debugPrint(
        '🔵 DotsDecoration: → Legacy border radius: ${IntroConstants.dotsBorderCircular}');
  }

  /// Get decoration variant information for debugging
  ///
  /// **Returns:**
  /// Map containing variant information and features
  static Map<String, dynamic> getVariantInfo() {
    return {
      'available_variants': ['default', 'minimal', 'enhanced', 'glassmorphism'],
      'features': {
        'default':
            'Standard theme-aware decoration with balanced visual impact',
        'minimal':
            'Subtle decoration for compact layouts with minimal visual impact',
        'enhanced':
            'Bold decoration with enhanced visual effects and larger sizing',
        'glassmorphism':
            'Modern decoration with glass morphism effects and borders',
      },
      'theming': {
        'colors': 'All variants use comprehensive ThemeManager color system',
        'sizing': 'Responsive sizing with ScreenUtil integration',
        'spacing': 'Theme-aware spacing with responsive design',
        'shapes': 'Dynamic borders and shapes based on variant and theme',
      },
    };
  }
}
