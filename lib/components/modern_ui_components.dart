import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

/// Modern UI Components Library for consistent design across the app
class ModernUIComponents {
  // Private constructor to prevent instantiation
  ModernUIComponents._();

  /// Modern glassmorphism card with blur effect
  static Widget glassmorphismCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool isDark = false,
    double borderRadius = 16,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
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
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
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

  /// Modern gradient card
  static Widget gradientCard({
    required Widget child,
    required List<Color> colors,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 16,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
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

  /// Modern elevated card with subtle shadow
  static Widget elevatedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool isDark = false,
    double borderRadius = 16,
    Color? backgroundColor,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
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

  /// Modern metric card with icon and statistics
  static Widget metricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    String? subtitle,
    bool isDark = false,
    VoidCallback? onTap,
  }) {
    return elevatedCard(
      isDark: isDark,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  if (onTap != null)
                    Icon(
                      LineIcons.alternateExternalLink,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.black.withValues(alpha: 0.5),
                      size: 16.sp,
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF6B7280),
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF10B981),
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

  /// Modern status indicator
  static Widget statusIndicator({
    required String label,
    required Color color,
    bool isOnline = true,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
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

  /// Modern button with multiple styles
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
                          color:
                              isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF6B7280),
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
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF9CA3AF),
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
                      color: isDark
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
      ModernButtonType type, bool isDark) {
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
              isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
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
