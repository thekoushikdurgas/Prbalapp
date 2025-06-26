import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// **THEMEMANAGER INTEGRATED** ProfileStatItemWidget - Reusable stat item for profile displays
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, stat-specific gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and stat item state monitoring
/// - ✨ Enhanced visual feedback with color-coded statistics
/// - 📈 Statistics-focused design with enhanced visual hierarchy
///
/// This widget displays statistics in a consistent format with:
/// - Enhanced icon container with gradient background and shadows
/// - Professional value and label display with theme-aware typography
/// - Comprehensive theme-aware styling with automatic adaptation
/// - Enhanced spacing and visual hierarchy for better readability
/// - Color-coded statistical display with professional design
class ProfileStatItemWidget extends StatelessWidget with ThemeAwareMixin {
  const ProfileStatItemWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('📈 [ProfileStatItem] Building stat item: $label = $value');
    debugPrint('🎨 [ProfileStatItem] Color: $color, Interactive: ${onTap != null}');

    return Container(
      decoration: BoxDecoration(
        // Enhanced gradient background
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              color.withValues(alpha: 26),
              color.withValues(alpha: 13),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          darkGradient: LinearGradient(
            colors: [
              color.withValues(alpha: 51),
              color.withValues(alpha: 26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          splashColor: color.withValues(alpha: 51),
          highlightColor: color.withValues(alpha: 26),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Enhanced icon container
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 77),
                        color.withValues(alpha: 51),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 51),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24.sp,
                  ),
                ),
                
                SizedBox(height: 12.h),
                
                // Enhanced value display
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
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
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 4.h),
                
                // Enhanced label display
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 13),
                          color.withValues(alpha: 8),
                        ],
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 26),
                          color.withValues(alpha: 13),
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: themeManager.conditionalColor(
                        lightColor: themeManager.textSecondary,
                        darkColor: themeManager.textSecondary,
                      ),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
