import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// **THEMEMANAGER INTEGRATED** ModernAppBarWidget - Modern app bar with enhanced theming
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, primary gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and app bar state monitoring
/// - ✨ Enhanced visual feedback with glass morphism effects
///
/// This widget provides a beautiful app bar with:
/// - Enhanced gradient background effects with ThemeManager integration
/// - Comprehensive theme-aware styling with automatic adaptation
/// - Customizable title with proper typography and theme colors
/// - Floating and pinned behavior options with enhanced visuals
/// - Professional glass morphism and shadow effects
class ModernAppBarWidget extends StatelessWidget with ThemeAwareMixin {
  const ModernAppBarWidget({
    super.key,
    required this.title,
    this.expandedHeight = 120,
    this.floating = false,
    this.pinned = true,
    this.elevation = 0,
    this.showBackButton = true,
    this.actions,
  });

  final String title;
  final double expandedHeight;
  final bool floating;
  final bool pinned;
  final double elevation;
  final bool showBackButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('🏗️ [ModernAppBar] Building modern app bar for title: $title');
    debugPrint(
        '📊 [ModernAppBar] Expanded height: ${expandedHeight}h, Pinned: $pinned');

    return SliverAppBar(
      expandedHeight: expandedHeight.h,
      floating: floating,
      pinned: pinned,
      backgroundColor: Colors.transparent,
      elevation: elevation,
      leading: showBackButton ? _buildEnhancedBackButton(themeManager) : null,
      actions: actions != null
          ? [
              ...actions!,
              SizedBox(width: 8.w), // Add spacing after actions
            ]
          : null,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          // Enhanced gradient background with ThemeManager
          gradient: themeManager.conditionalGradient(
            lightGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeManager.backgroundColor.withValues(alpha: 242),
                themeManager.surfaceColor.withValues(alpha: 230),
                themeManager.primaryColor.withValues(alpha: 13),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            darkGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeManager.backgroundColor.withValues(alpha: 242),
                themeManager.surfaceColor.withValues(alpha: 230),
                themeManager.primaryColor.withValues(alpha: 26),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
          // Enhanced border with theme integration
          border: Border(
            bottom: BorderSide(
              color: themeManager.conditionalColor(
                lightColor: themeManager.borderColor.withValues(alpha: 77),
                darkColor: themeManager.borderColor.withValues(alpha: 51),
              ),
              width: 0.5,
            ),
          ),
        ),
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              // Enhanced title background with subtle gradient
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    themeManager.surfaceColor.withValues(alpha: 128),
                    themeManager.backgroundColor.withValues(alpha: 77),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                darkGradient: LinearGradient(
                  colors: [
                    themeManager.surfaceColor.withValues(alpha: 77),
                    themeManager.backgroundColor.withValues(alpha: 128),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: themeManager.conditionalColor(
                  lightColor: themeManager.borderColor.withValues(alpha: 51),
                  darkColor: themeManager.borderColor.withValues(alpha: 77),
                ),
                width: 0.5,
              ),
              boxShadow: themeManager.subtleShadow,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: themeManager.conditionalColor(
                  lightColor: themeManager.textPrimary,
                  darkColor: themeManager.textPrimary,
                ),
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.neutral400.withValues(alpha: 77),
                      darkColor: themeManager.neutral800.withValues(alpha: 128),
                    ),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
          background: Container(
            decoration: BoxDecoration(
              // Enhanced background with glass morphism effect
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themeManager.primaryColor.withValues(alpha: 8),
                    themeManager.accent1.withValues(alpha: 13),
                    themeManager.backgroundColor.withValues(alpha: 242),
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themeManager.primaryColor.withValues(alpha: 26),
                    themeManager.accent1.withValues(alpha: 51),
                    themeManager.backgroundColor.withValues(alpha: 242),
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                // Glass morphism overlay
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 13),
                    Colors.transparent,
                    themeManager.conditionalColor(
                      lightColor: themeManager.neutral100.withValues(alpha: 26),
                      darkColor: themeManager.neutral900.withValues(alpha: 51),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds enhanced back button with ThemeManager integration
  Widget _buildEnhancedBackButton(ThemeManager themeManager) {
    return Builder(
      builder: (context) => Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          // Enhanced back button container
          gradient: themeManager.conditionalGradient(
            lightGradient: LinearGradient(
              colors: [
                themeManager.surfaceColor.withValues(alpha: 179),
                themeManager.backgroundColor.withValues(alpha: 128),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            darkGradient: LinearGradient(
              colors: [
                themeManager.surfaceColor.withValues(alpha: 128),
                themeManager.backgroundColor.withValues(alpha: 179),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: themeManager.conditionalColor(
              lightColor: themeManager.borderColor.withValues(alpha: 77),
              darkColor: themeManager.borderColor.withValues(alpha: 51),
            ),
            width: 1,
          ),
          boxShadow: themeManager.subtleShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            splashColor: themeManager.primaryColor.withValues(alpha: 26),
            highlightColor: themeManager.accent1.withValues(alpha: 13),
            onTap: () {
              debugPrint('🏗️ [ModernAppBar] Back button tapped');
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: themeManager.conditionalColor(
                  lightColor: themeManager.textPrimary,
                  darkColor: themeManager.textPrimary,
                ),
                size: 20.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
