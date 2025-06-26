import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// **THEMEMANAGER INTEGRATED** SettingsLoadingIndicatorWidget - Reusable loading indicator for settings screens
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, loading gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and loading state monitoring
/// - ✨ Enhanced visual feedback with animated loading indicators
/// - ⏳ Loading-focused design with professional glass morphism
///
/// This widget provides a consistent loading state UI that can be used across
/// different settings sections with:
/// - Enhanced theme-aware styling for light and dark modes
/// - Professional spacing and typography with theme integration
/// - Customizable loading message with proper theming
/// - Modern enhanced glass-morphism design with gradients
/// - Animated loading indicator with theme-aware colors
class SettingsLoadingIndicatorWidget extends StatefulWidget {
  const SettingsLoadingIndicatorWidget({
    super.key,
    this.message,
    this.showAnimation = true,
  });

  final String? message;
  final bool showAnimation;

  @override
  State<SettingsLoadingIndicatorWidget> createState() => _SettingsLoadingIndicatorWidgetState();
}

class _SettingsLoadingIndicatorWidgetState extends State<SettingsLoadingIndicatorWidget>
    with SingleTickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    if (widget.showAnimation) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      
      _pulseAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.showAnimation) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('⚙️ [SettingsLoading] Building enhanced loading indicator');
    debugPrint('🎯 [SettingsLoading] Message: ${widget.message}, Animation: ${widget.showAnimation}');

    Widget loadingContent = Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        // Enhanced gradient background
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.surfaceColor.withValues(alpha: 242),
              themeManager.backgroundColor.withValues(alpha: 230),
              themeManager.infoColor.withValues(alpha: 13),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.surfaceColor.withValues(alpha: 230),
              themeManager.backgroundColor.withValues(alpha: 242),
              themeManager.infoColor.withValues(alpha: 26),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 128),
            darkColor: themeManager.borderColor.withValues(alpha: 77),
          ),
          width: 1,
        ),
        boxShadow: themeManager.elevatedShadow,
      ),
      child: Row(
        children: [
          // Enhanced loading indicator container
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    themeManager.infoColor.withValues(alpha: 26),
                    themeManager.infoColor.withValues(alpha: 13),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                darkGradient: LinearGradient(
                  colors: [
                    themeManager.infoColor.withValues(alpha: 51),
                    themeManager.infoColor.withValues(alpha: 26),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: themeManager.infoColor.withValues(alpha: 77),
                width: 1,
              ),
            ),
            child: SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(themeManager.infoColor),
              ),
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Enhanced message display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message ?? 'settings.loadingSettings'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.textPrimary,
                      darkColor: themeManager.textPrimary,
                    ),
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          themeManager.infoColor.withValues(alpha: 13),
                          themeManager.infoColor.withValues(alpha: 8),
                        ],
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          themeManager.infoColor.withValues(alpha: 26),
                          themeManager.infoColor.withValues(alpha: 13),
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Please wait...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: themeManager.conditionalColor(
                        lightColor: themeManager.textSecondary,
                        darkColor: themeManager.textSecondary,
                      ),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.showAnimation) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: loadingContent,
          );
        },
      );
    }

    return loadingContent;
  }
}
