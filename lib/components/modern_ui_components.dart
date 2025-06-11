import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

/// ModernUIComponents - A comprehensive library of modern UI components
///
/// This utility class provides a collection of pre-built, modern UI components
/// with consistent styling and theming. All components are designed to work
/// seamlessly across light and dark themes.
///
/// **Available Components:**
/// - Glassmorphism cards with blur effects
/// - Gradient cards with customizable colors
/// - Elevated cards with subtle shadows
/// - Metric cards for displaying statistics
/// - Status indicators for real-time states
/// - Modern buttons with multiple styles
///
/// **Design Philosophy:**
/// - Consistent spacing and sizing using ScreenUtil
/// - Theme-aware color schemes
/// - Smooth animations and transitions
/// - Accessibility-friendly implementations
/// - Responsive design patterns
///
/// **Usage Pattern:**
/// All methods are static and can be called directly:
/// ```dart
/// ModernUIComponents.glassmorphismCard(
///   child: YourContent(),
///   isDark: Theme.of(context).brightness == Brightness.dark,
/// )
/// ```
class ModernUIComponents {
  /// Private constructor to prevent instantiation
  /// This class is designed as a utility class with static methods only
  ModernUIComponents._();

  /// Creates a modern glassmorphism card with blur effect
  ///
  /// **Glassmorphism Design:**
  /// - Semi-transparent background with gradient overlay
  /// - Subtle border for definition
  /// - Shadow effects for depth perception
  /// - Responsive to theme changes (light/dark)
  ///
  /// **Parameters:**
  /// - [child]: Content widget to display inside the card
  /// - [padding]: Internal spacing (default: 20.w)
  /// - [margin]: External spacing (default: 8.w)
  /// - [isDark]: Theme mode for color adaptation
  /// - [borderRadius]: Corner rounding (default: 16)
  ///
  /// **Usage:**
  /// ```dart
  /// ModernUIComponents.glassmorphismCard(
  ///   child: Text('Glassmorphism Content'),
  ///   isDark: Theme.of(context).brightness == Brightness.dark,
  /// )
  /// ```
  static Widget glassmorphismCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool isDark = false,
    double borderRadius = 16,
  }) {
    debugPrint('🎨 ModernUIComponents: Creating glassmorphism card');
    debugPrint('🎨 ModernUIComponents: Theme mode: ${isDark ? 'dark' : 'light'}');
    debugPrint('🎨 ModernUIComponents: Border radius: $borderRadius');

    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        // Glassmorphism gradient effect
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ]
              : [
                  Colors.white.withValues(alpha: 0.7),
                  Colors.white.withValues(alpha: 0.3),
                ],
        ),
        // Subtle border for glassmorphism effect
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        // Shadow for depth perception
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: Container(
          padding: padding ?? EdgeInsets.all(20.w),
          child: child,
        ),
      ),
    );
  }

  /// Creates a modern gradient card with customizable colors
  ///
  /// **Gradient Design:**
  /// - Linear gradient from top-left to bottom-right
  /// - Customizable color scheme
  /// - Automatic shadow generation based on primary color
  /// - Responsive corner rounding
  ///
  /// **Parameters:**
  /// - [child]: Content widget for the card
  /// - [colors]: List of colors for the gradient effect
  /// - [padding]: Internal spacing (default: 20.w)
  /// - [margin]: External spacing (default: 8.w)
  /// - [borderRadius]: Corner rounding (default: 16)
  /// - [boxShadow]: Custom shadow effects (optional)
  ///
  /// **Color Guidelines:**
  /// - Use 2-3 colors for smooth gradients
  /// - Ensure sufficient contrast for text readability
  /// - Consider theme compatibility
  static Widget gradientCard({
    required Widget child,
    required List<Color> colors,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 16,
    List<BoxShadow>? boxShadow,
  }) {
    debugPrint('🎨 ModernUIComponents: Creating gradient card');
    debugPrint('🎨 ModernUIComponents: Gradient colors: ${colors.length} colors');
    debugPrint('🎨 ModernUIComponents: Border radius: $borderRadius');

    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        // Custom gradient with provided colors
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        // Shadow effect using primary color
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(20.w),
        child: child,
      ),
    );
  }

  /// Creates a modern elevated card with subtle shadow
  ///
  /// **Elevated Design:**
  /// - Clean, minimalist appearance
  /// - Subtle shadow for depth
  /// - Theme-aware background colors
  /// - Consistent with Material Design principles
  ///
  /// **Theme Adaptation:**
  /// - Light theme: White background with light shadow
  /// - Dark theme: Dark surface with stronger shadow
  /// - Automatic color scheme integration
  static Widget elevatedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool isDark = false,
    double borderRadius = 16,
    Color? backgroundColor,
  }) {
    debugPrint('🎨 ModernUIComponents: Creating elevated card');
    debugPrint('🎨 ModernUIComponents: Theme mode: ${isDark ? 'dark' : 'light'}');
    debugPrint('🎨 ModernUIComponents: Custom background: ${backgroundColor != null}');

    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        // Theme-appropriate background color
        color: backgroundColor ?? (isDark ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(borderRadius.r),
        // Subtle shadow for elevation effect
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.08),
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
  ///   icon: Icons.people,
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
    bool isDark = false,
    VoidCallback? onTap,
  }) {
    debugPrint('🎨 ModernUIComponents: Creating metric card');
    debugPrint('🎨 ModernUIComponents: Metric - Title: "$title", Value: "$value"');
    debugPrint('🎨 ModernUIComponents: Icon color: $iconColor');
    debugPrint('🎨 ModernUIComponents: Tappable: ${onTap != null}');
    debugPrint('🎨 ModernUIComponents: Has subtitle: ${subtitle != null}');

    return elevatedCard(
      isDark: isDark,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  debugPrint('🎨 ModernUIComponents: Metric card tapped - $title');
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
                      LineIcons.alternateExternalLink,
                      color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.5),
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
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 4.h),

              // Descriptive title
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                ),
              ),

              // Optional subtitle with positive change indicator color
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF10B981), // Green for positive metrics
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
    debugPrint('🎨 ModernUIComponents: Status - Label: "$label", Online: $isOnline');
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
    bool isDark = false,
  }) {
    final buttonColors = _getButtonColors(type, isDark);

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
          backgroundColor: type == ModernButtonType.gradient ? Colors.transparent : buttonColors['background'],
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

  /// Modern search bar
  static Widget modernSearchBar({
    required TextEditingController controller,
    String? hintText,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    bool isDark = false,
    bool readOnly = false,
  }) {
    return elevatedCard(
      isDark: isDark,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: TextField(
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText ?? 'Search...',
          hintStyle: TextStyle(
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            LineIcons.search,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1F2937),
          fontSize: 14.sp,
        ),
      ),
    );
  }

  /// Modern list tile
  static Widget modernListTile({
    required String title,
    String? subtitle,
    IconData? leadingIcon,
    Color? leadingIconColor,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return elevatedCard(
      isDark: isDark,
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
                      color: (leadingIconColor ?? const Color(0xFF3B82F6)).withValues(alpha: 0.1),
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
                          color: isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
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
                    LineIcons.angleRight,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
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
    bool isDark = false,
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
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
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
  static Map<String, Color> _getButtonColors(ModernButtonType type, bool isDark) {
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
          'background': isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
          'foreground': isDark ? Colors.white : const Color(0xFF1F2937),
          'shadow': Colors.black.withValues(alpha: 0.1),
          'border': Colors.transparent,
        };
      case ModernButtonType.outline:
        return {
          'background': Colors.transparent,
          'foreground': isDark ? Colors.white : const Color(0xFF1F2937),
          'shadow': Colors.transparent,
          'border': isDark ? const Color(0xFF64748B) : const Color(0xFFD1D5DB),
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

/// Modern animated container with subtle hover effects
class ModernAnimatedContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isDark;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ModernAnimatedContainer({
    super.key,
    required this.child,
    this.onTap,
    this.isDark = false,
    this.borderRadius = 16,
    this.padding,
    this.margin,
  });

  @override
  State<ModernAnimatedContainer> createState() => _ModernAnimatedContainerState();
}

class _ModernAnimatedContainerState extends State<ModernAnimatedContainer> with SingleTickerProviderStateMixin {
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
              isDark: widget.isDark,
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
