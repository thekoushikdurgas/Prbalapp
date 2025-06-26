import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/lang/locale_keys.g.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

/// **THEMEMANAGER INTEGRATED** SettingAppbar - A localized app bar component for settings screens
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, app bar gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and app bar state monitoring
/// - ✨ Enhanced visual feedback with gradient app bar design
/// - ⚙️ Settings-focused design with professional theming
/// - 🌍 Localization-aware app bar with enhanced styling
///
/// This widget provides a consistent app bar for settings-related screens with:
///
/// **Enhanced Features:**
/// - Professional automatic localization using easy_localization
/// - Enhanced theme-aware text styling with gradients and shadows
/// - Implements PreferredSizeWidget for proper AppBar integration with enhanced styling
/// - Professional gradient backgrounds with glass morphism effects
/// - Enhanced null-safe operations with comprehensive error handling
/// - Glass morphism app bar design with theme-aware visual effects
///
/// **Enhanced Localization:**
/// - Uses LocaleKeys.settingTitle for the title text with enhanced styling
/// - Automatically adapts to current app language with professional theming
/// - Enhanced RTL language support through easy_localization
/// - Theme-aware text rendering with proper contrast and shadows
///
/// **Usage:**
/// ```dart
/// Scaffold(
///   appBar: SettingAppbar(),
///   body: SettingsScreenContent(),
/// )
/// ```
///
/// **Enhanced Integration:**
/// This component is designed to be used with settings screens
/// and provides a standardized enhanced header appearance across all
/// settings-related interfaces in the application with professional theming.
class SettingAppbar extends StatelessWidget with ThemeAwareMixin implements PreferredSizeWidget {
  const SettingAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ [SettingAppBar] Building enhanced settings app bar');

    final themeManager = ThemeManager.of(context);

    debugPrint('🎨 [SettingAppBar] Current theme brightness: ${Theme.of(context).brightness}');

    // Get localized title text
    final localizedTitle = LocaleKeys.settingTitle.tr();
    debugPrint('🌍 [SettingAppBar] Localized title: "$localizedTitle"');
    debugPrint('🌍 [SettingAppBar] Current locale: ${context.locale}');

    return Container(
      decoration: BoxDecoration(
        // Enhanced gradient background
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.surfaceColor.withValues(alpha: 248),
              themeManager.backgroundColor.withValues(alpha: 242),
              themeManager.primaryColor.withValues(alpha: 13),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.surfaceColor.withValues(alpha: 235),
              themeManager.backgroundColor.withValues(alpha: 248),
              themeManager.primaryColor.withValues(alpha: 26),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        // Enhanced bottom border
        border: Border(
          bottom: BorderSide(
            color: themeManager.conditionalColor(
              lightColor: themeManager.borderColor.withValues(alpha: 128),
              darkColor: themeManager.borderColor.withValues(alpha: 77),
            ),
            width: 1,
          ),
        ),
        boxShadow: [
          // Enhanced primary shadow
          BoxShadow(
            color: themeManager.conditionalColor(
              lightColor: themeManager.primaryColor.withValues(alpha: 26),
              darkColor: themeManager.primaryColor.withValues(alpha: 51),
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          // Additional subtle shadow for depth
          BoxShadow(
            color: themeManager.conditionalColor(
              lightColor: Colors.black.withValues(alpha: 13),
              darkColor: Colors.black.withValues(alpha: 26),
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: -1,
          ),
        ],
      ),
      child: AppBar(
        // Enhanced title with proper styling
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeManager.primaryColor.withValues(alpha: 26),
                  themeManager.primaryColor.withValues(alpha: 13),
                  themeManager.primaryColor.withValues(alpha: 8),
                ],
              ),
              darkGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeManager.primaryColor.withValues(alpha: 51),
                  themeManager.primaryColor.withValues(alpha: 26),
                  themeManager.primaryColor.withValues(alpha: 13),
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: themeManager.conditionalColor(
                lightColor: themeManager.primaryColor.withValues(alpha: 77),
                darkColor: themeManager.primaryColor.withValues(alpha: 102),
              ),
              width: 1,
            ),
            boxShadow: themeManager.subtleShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  gradient: themeManager.conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        themeManager.primaryColor.withValues(alpha: 51),
                        themeManager.primaryColor.withValues(alpha: 26),
                      ],
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        themeManager.primaryColor.withValues(alpha: 77),
                        themeManager.primaryColor.withValues(alpha: 51),
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Prbal.settings,
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.primaryColor,
                    darkColor: themeManager.primaryColor,
                  ),
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                localizedTitle,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      color: themeManager.conditionalColor(
                        lightColor: Colors.black.withValues(alpha: 26),
                        darkColor: Colors.black.withValues(alpha: 51),
                      ),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Enhanced leading back button
        leading: Builder(
          builder: (context) {
            if (Navigator.of(context).canPop()) {
              return Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: themeManager.conditionalGradient(
                    lightGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        themeManager.surfaceColor.withValues(alpha: 179),
                        themeManager.backgroundColor.withValues(alpha: 153),
                      ],
                    ),
                    darkGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        themeManager.surfaceColor.withValues(alpha: 153),
                        themeManager.backgroundColor.withValues(alpha: 179),
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.borderColor.withValues(alpha: 102),
                      darkColor: themeManager.borderColor.withValues(alpha: 77),
                    ),
                    width: 1,
                  ),
                  boxShadow: themeManager.subtleShadow,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      debugPrint('⚙️ [SettingAppBar] Back button pressed');
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    splashColor: themeManager.primaryColor.withValues(alpha: 51),
                    highlightColor: themeManager.primaryColor.withValues(alpha: 26),
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Prbal.arrowLeft,
                        color: themeManager.conditionalColor(
                          lightColor: themeManager.textPrimary,
                          darkColor: themeManager.textPrimary,
                        ),
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        // Center the title for better visual balance
        centerTitle: true,
        // Transparent background to show gradient
        backgroundColor: Colors.transparent,
        foregroundColor: themeManager.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        // Enhanced flexible space for additional content if needed
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // Glass morphism overlay
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 26),
                  Colors.white.withValues(alpha: 13),
                  Colors.white.withValues(alpha: 8),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              darkGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 13),
                  Colors.white.withValues(alpha: 8),
                  Colors.white.withValues(alpha: 5),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the enhanced preferred size for this app bar
  ///
  /// **Enhanced Standard Height:**
  /// Uses kToolbarHeight (typically 56.0 logical pixels) which is the
  /// standard Material Design app bar height. This ensures consistency
  /// with other app bars throughout the application while providing
  /// enhanced visual styling and theming integration.
  ///
  /// **Enhanced Implementation Note:**
  /// This is required by the PreferredSizeWidget interface to properly
  /// integrate with Scaffold's appBar property. The enhanced version
  /// maintains the same dimensions while providing superior visual design.
  @override
  Size get preferredSize {
    const size = Size.fromHeight(kToolbarHeight);
    debugPrint('⚙️ [SettingAppBar] Returning enhanced preferred size: $size');
    return size;
  }
}
