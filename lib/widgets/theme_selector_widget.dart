import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/cubit/theme_cubit.dart';
// import 'package:prbal/utils/theme/theme_caching.dart';

/// ThemeSelectorWidget - A modern, interactive theme selection component
///
/// This widget provides a beautiful UI for users to choose between:
/// - System Default (follows device theme)
/// - Light theme
/// - Dark theme
///
/// Features:
/// - Real-time theme switching with BLoC state management
/// - Adaptive UI that responds to current theme
/// - Visual feedback for selected option
/// - Modern card design with shadows and rounded corners
/// - Haptic feedback for better UX
///
/// Usage:
/// ```dart
/// ThemeSelectorWidget() // Shows theme selection options
/// ```
class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 ThemeSelectorWidget: Building theme selector UI');

    // Determine current theme mode for adaptive UI styling
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint(
        '🎨 ThemeSelectorWidget: Current theme is ${isDark ? 'dark' : 'light'}');

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        debugPrint(
            '🎨 ThemeSelectorWidget: Current ThemeMode state: $themeMode');

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            // Dynamic background color based on current theme
            color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header title
              Text(
                'Choose Theme',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 16.h),

              // System Default Theme Option
              _buildThemeOption(
                context,
                title: 'System Default',
                subtitle: 'Follow device settings',
                icon: Prbal.mobilePhone,
                isSelected: themeMode == ThemeMode.system,
                onTap: () {
                  debugPrint(
                      '🎨 ThemeSelectorWidget: User selected System Default theme');
                  context.read<ThemeCubit>().makeSystem();
                },
                isDark: isDark,
              ),
              SizedBox(height: 8.h),

              // Light Theme Option
              _buildThemeOption(
                context,
                title: 'Light',
                subtitle: 'Light appearance',
                icon: Prbal.sun,
                isSelected: themeMode == ThemeMode.light,
                onTap: () {
                  debugPrint(
                      '🎨 ThemeSelectorWidget: User selected Light theme');
                  context.read<ThemeCubit>().makelight();
                },
                isDark: isDark,
              ),
              SizedBox(height: 8.h),

              // Dark Theme Option
              _buildThemeOption(
                context,
                title: 'Dark',
                subtitle: 'Dark appearance',
                icon: Prbal.moon,
                isSelected: themeMode == ThemeMode.dark,
                onTap: () {
                  debugPrint(
                      '🎨 ThemeSelectorWidget: User selected Dark theme');
                  context.read<ThemeCubit>().makeDark();
                },
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds a single theme option row with icon, title, subtitle and selection state
  ///
  /// Parameters:
  /// - [title]: Main title for the theme option
  /// - [subtitle]: Descriptive subtitle explaining the theme
  /// - [icon]: Icon representing the theme option
  /// - [isSelected]: Whether this option is currently selected
  /// - [onTap]: Callback when user taps this option
  /// - [isDark]: Current theme mode for adaptive styling
  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    debugPrint(
        '🎨 ThemeSelectorWidget: Building theme option - $title (selected: $isSelected)');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          debugPrint('🎨 ThemeSelectorWidget: Theme option tapped - $title');
          onTap();
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            // Highlight selected option with primary color
            color: isSelected
                ? const Color(0xFF3B82F6).withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              // Dynamic border styling based on selection and theme
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon container with dynamic styling
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF3B82F6)
                      : (isDark ? Colors.grey[700] : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey[300] : Colors.grey[600]),
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),

              // Title and subtitle section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main title with dynamic color based on selection
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF3B82F6)
                            : (isDark ? Colors.white : const Color(0xFF2D3748)),
                      ),
                    ),
                    // Subtitle with muted color
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Check icon for selected state
              if (isSelected) ...[
                Builder(
                  builder: (context) {
                    debugPrint(
                        '🎨 ThemeSelectorWidget: Showing check icon for selected option - $title');
                    return Icon(
                      Prbal.check,
                      color: const Color(0xFF3B82F6),
                      size: 20.sp,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
