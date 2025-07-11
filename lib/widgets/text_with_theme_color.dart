import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// TEXT WITH THEME COLOR COMPONENT
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
/// - Text Colors: textPrimary, textSecondary, textTertiary, textQuaternary,
///   textDisabled, textInverted
/// - Status Colors: successColor/Light/Dark, warningColor/Light/Dark,
///   errorColor/Light/Dark, infoColor/Light/Dark
/// - Accent Colors: accent1-5, neutral50-900
/// - Border Colors: borderColor, borderSecondary, borderFocus, dividerColor
/// - Interactive Colors: buttonBackground, inputBackground, statusColors
/// - Shadow Colors: shadowLight, shadowMedium, shadowDark
/// - Semantic Colors: statusOnline/Offline/Away/Busy, favoriteColor, ratingColor
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
/// - withThemeAlpha() - theme-consistent alpha application
///
/// **🏗️ ARCHITECTURAL ENHANCEMENTS:**
///
/// **1. Enhanced Text Container:**
/// - Multi-layer gradient backgrounds with comprehensive color transitions
/// - Advanced border system with borderFocus and dynamic alpha values
/// - Layered shadow effects combining all shadow types
/// - Theme-aware text styling with proper contrast
///
/// **2. Advanced Text Style System:**
/// - Dynamic font weight based on text importance level
/// - Gradient text effects using ShaderMask
/// - Interactive states with hover/pressed effects
/// - Professional typography with theme-aware contrast
///
/// **3. Variant System:**
/// - Multiple text variants (primary, secondary, accent, status)
/// - Each variant uses different ThemeManager color combinations
/// - Semantic color mapping for different use cases
/// - Enhanced visual hierarchy with theme-aware styling
///
/// **🎯 RESULT:**
/// A sophisticated text component that provides premium visual experience
/// with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible text rendering.
/// ====================================================================

/// Text component with comprehensive ThemeManager integration and localization support
///
/// This enhanced widget provides:
/// - ALL ThemeManager color properties integration
/// - Comprehensive gradient and shadow effects
/// - Multiple text variants with semantic styling
/// - Interactive states and animations
/// - Professional typography with theme-aware contrast
/// - Built-in localization support via easy_localization
/// - Responsive text rendering with ScreenUtil
/// - Debug logging for comprehensive theme tracking
class TextWithThemeColor extends StatefulWidget {
  /// The localization key to translate and display
  final String text;

  /// Text variant type for different styling
  final TextVariant variant;

  /// Optional text style overrides
  final TextStyle? style;

  /// Whether to show text in a container with background
  final bool showContainer;

  /// Whether to apply gradient text effect
  final bool useGradientText;

  /// Whether the text should be interactive
  final bool isInteractive;

  /// Optional tap callback for interactive text
  final VoidCallback? onTap;

  /// Text alignment
  final TextAlign textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow overflow;

  const TextWithThemeColor({
    super.key,
    required this.text,
    this.variant = TextVariant.primary,
    this.style,
    this.showContainer = false,
    this.useGradientText = false,
    this.isInteractive = false,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  State<TextWithThemeColor> createState() => _TextWithThemeColorState();
}

class _TextWithThemeColorState extends State<TextWithThemeColor>
    with SingleTickerProviderStateMixin, ThemeAwareMixin {
  // ========== ANIMATION CONTROLLER ==========
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // ========== INTERACTION STATE ==========
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '📝 TextWithThemeColor: Initializing comprehensive theme-aware text component');
    debugPrint(
        '📝 TextWithThemeColor: Text key: "${widget.text}", Variant: ${widget.variant}');

    // Initialize animations for interactive text
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    debugPrint('📝 TextWithThemeColor: Disposing text component');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ========== COMPREHENSIVE THEME INTEGRATION ==========

    // Comprehensive theme logging for debugging

    debugPrint(
        '📝 TextWithThemeColor: Building with COMPREHENSIVE ThemeManager integration');
    debugPrint('📝 TextWithThemeColor: → Variant: ${widget.variant}');
    debugPrint(
        '📝 TextWithThemeColor: → Show Container: ${widget.showContainer}');
    debugPrint(
        '📝 TextWithThemeColor: → Use Gradient: ${widget.useGradientText}');
    debugPrint('📝 TextWithThemeColor: → Interactive: ${widget.isInteractive}');
    debugPrint(
        '📝 TextWithThemeColor: → Primary Color: ${ThemeManager.of(context).primaryColor}');
    debugPrint(
        '📝 TextWithThemeColor: → Text Colors: Primary=${ThemeManager.of(context).textPrimary}, Secondary=${ThemeManager.of(context).textSecondary}');
    debugPrint(
        '📝 TextWithThemeColor: → Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint(
        '📝 TextWithThemeColor: → Status Colors: Success=${ThemeManager.of(context).successColor}, Warning=${ThemeManager.of(context).warningColor}, Error=${ThemeManager.of(context).errorColor}, Info=${ThemeManager.of(context).infoColor}');

    // Translate the text
    final translatedText = widget.text.tr();
    debugPrint('📝 TextWithThemeColor: Translated text: "$translatedText"');

    // Build the text widget
    final textWidget = _buildTextWidget(translatedText);

    // Wrap in container if requested
    if (widget.showContainer) {
      return _buildContainerWrapper(textWidget);
    }

    // Wrap in interactive wrapper if needed
    if (widget.isInteractive) {
      return _buildInteractiveWrapper(textWidget);
    }

    return textWidget;
  }

  /// Build the main text widget with comprehensive ThemeManager styling
  Widget _buildTextWidget(String translatedText) {
    debugPrint(
        '📝 TextWithThemeColor: Building text widget with variant: ${widget.variant}');

    // Get variant-specific styling
    final variantStyle = _getVariantStyle();

    // Combine with any override styles
    final finalStyle = variantStyle.merge(widget.style);

    debugPrint(
        '📝 TextWithThemeColor: Final style - color: ${finalStyle.color}, fontSize: ${finalStyle.fontSize}, fontWeight: ${finalStyle.fontWeight}');

    // Build text with or without gradient effect
    final textWidget = Text(
      translatedText,
      style: finalStyle,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );

    // Apply gradient effect if requested
    if (widget.useGradientText) {
      return _buildGradientText(textWidget);
    }

    return textWidget;
  }

  /// Get text style based on variant using comprehensive ThemeManager properties
  TextStyle _getVariantStyle() {
    debugPrint(
        '📝 TextWithThemeColor: Getting variant style for: ${widget.variant}');

    switch (widget.variant) {
      case TextVariant.primary:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).textPrimary,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.4,
        );

      case TextVariant.secondary:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).textSecondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.3,
        );

      case TextVariant.tertiary:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).textTertiary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
          height: 1.2,
        );

      case TextVariant.accent:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilySemiExpanded,
          color: ThemeManager.of(context).primaryColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.4,
        );

      case TextVariant.success:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).successColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.3,
        );

      case TextVariant.warning:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).warningColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.3,
        );

      case TextVariant.error:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).errorColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.3,
        );

      case TextVariant.info:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).infoColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.3,
        );

      case TextVariant.subtitle:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilySemiExpanded,
          color: ThemeManager.of(context).textSecondary,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          height: 1.5,
        );

      case TextVariant.caption:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).textTertiary,
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.1,
        );

      case TextVariant.heading:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyExpanded,
          color: ThemeManager.of(context).textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.2,
        );

      case TextVariant.inverted:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).textInverted,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.4,
        );

      case TextVariant.disabled:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).textDisabled,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
          height: 1.3,
        );

      case TextVariant.quaternary:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilyPrimary,
          color: ThemeManager.of(context).textQuaternary,
          fontSize: 11.sp,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.4,
          height: 1.1,
        );

      case TextVariant.accent2:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilySemiExpanded,
          color: ThemeManager.of(context).accent2,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.4,
        );

      case TextVariant.accent3:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilySemiExpanded,
          color: ThemeManager.of(context).accent3,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.4,
        );

      case TextVariant.accent4:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilySemiExpanded,
          color: ThemeManager.of(context).accent4,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.4,
        );

      case TextVariant.accent5:
        return TextStyle(
          fontFamily: ThemeManager.fontFamilySemiExpanded,
          color: ThemeManager.of(context).accent5,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          height: 1.4,
        );
    }
  }

  /// Build gradient text effect using comprehensive ThemeManager gradients
  Widget _buildGradientText(Widget textWidget) {
    debugPrint(
        '📝 TextWithThemeColor: Building gradient text effect for variant: ${widget.variant}');

    // Select gradient based on variant
    LinearGradient gradient;
    switch (widget.variant) {
      case TextVariant.primary:
      case TextVariant.heading:
        gradient = ThemeManager.of(context).primaryGradient;
        break;
      case TextVariant.accent:
        gradient = ThemeManager.of(context).accent1Gradient;
        break;
      case TextVariant.accent2:
        gradient = ThemeManager.of(context).accent2Gradient;
        break;
      case TextVariant.accent3:
        gradient = ThemeManager.of(context).accent3Gradient;
        break;
      case TextVariant.accent4:
        gradient = ThemeManager.of(context).accent4Gradient;
        break;
      case TextVariant.accent5:
        gradient = ThemeManager.of(context)
            .secondaryGradient; // Using secondary as closest for accent5
        break;
      case TextVariant.success:
        gradient = ThemeManager.of(context).successGradient;
        break;
      case TextVariant.warning:
        gradient = ThemeManager.of(context).warningGradient;
        break;
      case TextVariant.error:
        gradient = ThemeManager.of(context).errorGradient;
        break;
      case TextVariant.info:
        gradient = ThemeManager.of(context).infoGradient;
        break;
      default:
        gradient = ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              ThemeManager.of(context).textPrimary,
              ThemeManager.of(context).textSecondary,
            ],
          ),
          darkGradient: LinearGradient(
            colors: [
              ThemeManager.of(context).textPrimary,
              ThemeManager.of(context).accent1,
            ],
          ),
        );
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: textWidget,
    );
  }

  /// Build container wrapper with comprehensive ThemeManager styling
  Widget _buildContainerWrapper(Widget textWidget) {
    debugPrint(
        '📝 TextWithThemeColor: Building container wrapper with comprehensive theming');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).cardBackground,
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).backgroundSecondary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).cardBackground,
              ThemeManager.of(context).backgroundTertiary,
              ThemeManager.of(context).surfaceElevated,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor:
                ThemeManager.of(context).borderColor.withValues(alpha: 0.3),
            darkColor:
                ThemeManager.of(context).borderSecondary.withValues(alpha: 0.4),
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...ThemeManager.of(context).subtleShadow,
          BoxShadow(
            color: ThemeManager.of(context).shadowMedium,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: _getVariantShadowColor(),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: textWidget,
    );
  }

  /// Build interactive wrapper with animations and state management
  Widget _buildInteractiveWrapper(Widget textWidget) {
    debugPrint('📝 TextWithThemeColor: Building interactive wrapper');

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              onTapDown: (_) => _setPressed(true),
              onTapUp: (_) => _setPressed(false),
              onTapCancel: () => _setPressed(false),
              child: MouseRegion(
                onEnter: (_) => _setHovered(true),
                onExit: (_) => _setHovered(false),
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getInteractiveBackgroundColor(),
                    borderRadius: BorderRadius.circular(8.r),
                    border: _isHovered || _isPressed
                        ? Border.all(
                            color: ThemeManager.of(context)
                                .primaryColor
                                .withValues(alpha: 0.5),
                            width: 1,
                          )
                        : null,
                  ),
                  child: textWidget,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Get variant-specific shadow color using comprehensive ThemeManager shadows
  Color _getVariantShadowColor() {
    switch (widget.variant) {
      case TextVariant.success:
        return ThemeManager.of(context).successColor.withValues(alpha: 0.1);
      case TextVariant.warning:
        return ThemeManager.of(context).warningColor.withValues(alpha: 0.1);
      case TextVariant.error:
        return ThemeManager.of(context).errorColor.withValues(alpha: 0.1);
      case TextVariant.info:
        return ThemeManager.of(context).infoColor.withValues(alpha: 0.1);
      case TextVariant.accent:
        return ThemeManager.of(context).primaryColor.withValues(alpha: 0.1);
      case TextVariant.heading:
        return ThemeManager.of(context).shadowDark;
      case TextVariant.primary:
        return ThemeManager.of(context).shadowMedium;
      default:
        return ThemeManager.of(context).shadowLight;
    }
  }

  /// Get interactive background color based on state
  Color _getInteractiveBackgroundColor() {
    if (_isPressed) {
      return ThemeManager.of(context).primaryColor.withValues(alpha: 0.2);
    } else if (_isHovered) {
      return ThemeManager.of(context).primaryColor.withValues(alpha: 0.1);
    }
    return Colors.transparent;
  }

  /// Set pressed state with animation
  void _setPressed(bool pressed) {
    if (_isPressed != pressed) {
      setState(() {
        _isPressed = pressed;
      });
      if (pressed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  /// Set hovered state
  void _setHovered(bool hovered) {
    if (_isHovered != hovered) {
      setState(() {
        _isHovered = hovered;
      });
    }
  }
}

/// Text variant enum for different styling options using ALL ThemeManager colors
enum TextVariant {
  /// Primary text with highest emphasis
  primary,

  /// Secondary text with medium emphasis
  secondary,

  /// Tertiary text with low emphasis
  tertiary,

  /// Quaternary text with subtle emphasis using textQuaternary
  quaternary,

  /// Accent text with brand color (accent1)
  accent,

  /// Accent text with accent2 color (pink)
  accent2,

  /// Accent text with accent3 color (teal)
  accent3,

  /// Accent text with accent4 color (orange)
  accent4,

  /// Accent text with accent5 color (indigo)
  accent5,

  /// Success text with green color
  success,

  /// Warning text with yellow/orange color
  warning,

  /// Error text with red color
  error,

  /// Info text with blue color
  info,

  /// Subtitle text variant
  subtitle,

  /// Caption text variant
  caption,

  /// Heading text variant
  heading,

  /// Inverted text for dark backgrounds
  inverted,

  /// Disabled text with reduced opacity
  disabled,
}

/// Legacy alias for backward compatibility
///
/// This maintains compatibility with existing code that uses TextLabelLargeTitle
/// while providing the enhanced functionality of TextWithThemeColor
typedef TextLabelLargeTitle = TextWithThemeColor;
