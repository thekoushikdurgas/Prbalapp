import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/lang/locale_keys.g.dart';
import 'package:prbal/utils/localization/project_locales.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/widgets/theme_selector_widget.dart';
import 'package:easy_localization/easy_localization.dart';

/// **THEMEMANAGER INTEGRATED** SettingsBottomSheets - Collection of bottom sheet widgets for settings
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, status gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated, primary shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and bottom sheet state monitoring
/// - ✨ Enhanced visual feedback with glass morphism and interactive states
///
/// This class provides static methods to show various bottom sheets:
/// - Theme selection bottom sheet with enhanced theming
/// - Language selection bottom sheet with visual indicators
/// - Security settings bottom sheet with biometric controls
/// - Data management bottom sheets with storage visualization
/// All with modern design and comprehensive theme integration
class SettingsBottomSheets {
  /// Shows a modern bottom sheet with comprehensive theme integration
  static Future<T?> _showModernBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    final themeManager = ThemeManager.of(context);

    debugPrint(
        '🎨 [BottomSheets] Creating modern bottom sheet with ThemeManager integration');

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: themeManager.conditionalGradient(
            lightGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeManager.surfaceColor.withValues(alpha: 242),
                themeManager.backgroundColor.withValues(alpha: 230),
              ],
            ),
            darkGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeManager.surfaceColor.withValues(alpha: 230),
                themeManager.backgroundColor.withValues(alpha: 242),
              ],
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: themeManager.elevatedShadow,
          border: Border(
            top: BorderSide(
              color: themeManager.conditionalColor(
                lightColor: themeManager.borderColor.withValues(alpha: 128),
                darkColor: themeManager.borderColor.withValues(alpha: 77),
              ),
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced drag handle with gradient
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                gradient: themeManager.conditionalGradient(
                  lightGradient: LinearGradient(
                    colors: [
                      themeManager.neutral400,
                      themeManager.neutral300,
                    ],
                  ),
                  darkGradient: LinearGradient(
                    colors: [
                      themeManager.neutral600,
                      themeManager.neutral700,
                    ],
                  ),
                ),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Content
            Flexible(child: child),
          ],
        ),
      ),
    );
  }

  /// Shows enhanced theme selection bottom sheet with comprehensive ThemeManager integration
  static Future<void> showThemeBottomSheet(BuildContext context) async {
    final themeManager = ThemeManager.of(context);

    debugPrint('🎨 [BottomSheets] === ENHANCED THEME SELECTION INITIATED ===');

    final stopwatch = Stopwatch()..start();

    try {
      await _showModernBottomSheet(
        context,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced header with theme integration
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: themeManager.conditionalGradient(
                        lightGradient: LinearGradient(
                          colors: [
                            themeManager.accent3.withValues(alpha: 26),
                            themeManager.accent3.withValues(alpha: 13),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        darkGradient: LinearGradient(
                          colors: [
                            themeManager.accent3.withValues(alpha: 51),
                            themeManager.accent3.withValues(alpha: 26),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: themeManager.accent3.withValues(alpha: 77),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Prbal.palette,
                      color: themeManager.accent3,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.themeThemeChoose.tr(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: themeManager.conditionalColor(
                              lightColor: themeManager.textPrimary,
                              darkColor: themeManager.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Current: ${Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light'} Theme',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: themeManager.conditionalColor(
                              lightColor: themeManager.textSecondary,
                              darkColor: themeManager.textSecondary,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Enhanced theme selector widget
              const ThemeSelectorWidget(),

              SizedBox(height: 24.h),

              // Enhanced close button with theme integration
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: themeManager.primaryGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: themeManager.primaryShadow,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      stopwatch.stop();
                      debugPrint(
                          '🎨 [BottomSheets] ⏱️ Selection time: ${stopwatch.elapsedMilliseconds}ms');
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      stopwatch.stop();
      debugPrint(
          '🎨 [BottomSheets] ✅ Theme selection completed: ${stopwatch.elapsedMilliseconds}ms');
    } catch (error) {
      stopwatch.stop();
      debugPrint('🎨 [BottomSheets] ❌ Error: $error');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Prbal.errorOutline, color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                const Expanded(
                    child:
                        Text('Theme selection unavailable. Please try again.')),
              ],
            ),
            backgroundColor: themeManager.errorColor,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
          ),
        );
      }
    }
  }

  /// Shows enhanced language selection bottom sheet with ThemeManager integration
  static Future<void> showLanguageBottomSheet(BuildContext context) async {
    final themeManager = ThemeManager.of(context);

    debugPrint('🌐 [BottomSheets] Showing enhanced language selection');

    await _showModernBottomSheet(
      context,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced header with theme integration
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
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
                  child: Icon(
                    Prbal.language,
                    color: themeManager.infoColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  LocaleKeys.localizationLangChoose.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.textPrimary,
                      darkColor: themeManager.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Enhanced language options
            ...ProjectLocales.localesMap.entries.map((entry) {
              final isSelected = context.locale == entry.key;
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    splashColor: themeManager.infoColor.withValues(alpha: 26),
                    highlightColor:
                        themeManager.infoColor.withValues(alpha: 13),
                    onTap: () {
                      context.setLocale(entry.key);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? themeManager.conditionalGradient(
                                lightGradient: LinearGradient(
                                  colors: [
                                    themeManager.infoColor
                                        .withValues(alpha: 26),
                                    themeManager.infoColor
                                        .withValues(alpha: 13),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                darkGradient: LinearGradient(
                                  colors: [
                                    themeManager.infoColor
                                        .withValues(alpha: 51),
                                    themeManager.infoColor
                                        .withValues(alpha: 26),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              )
                            : null,
                        border: Border.all(
                          color: isSelected
                              ? themeManager.infoColor
                              : themeManager.conditionalColor(
                                  lightColor: themeManager.borderColor,
                                  darkColor: themeManager.borderColor,
                                ),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? themeManager.infoColor
                                    : themeManager.conditionalColor(
                                        lightColor: themeManager.textPrimary,
                                        darkColor: themeManager.textPrimary,
                                      ),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Prbal.checkCircle,
                              color: themeManager.infoColor,
                              size: 20.sp,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            SizedBox(height: 16.h),

            // Enhanced close button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  side: BorderSide(
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.borderColor,
                      darkColor: themeManager.borderColor,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.textSecondary,
                      darkColor: themeManager.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows enhanced security settings bottom sheet with ThemeManager integration
  static Future<void> showSecurityBottomSheet(
    BuildContext context, {
    required bool biometricsEnabled,
    required Function(bool) onBiometricsChanged,
    required VoidCallback onResetPin,
  }) async {
    final themeManager = ThemeManager.of(context);

    debugPrint('🔒 [BottomSheets] Showing enhanced security settings');

    await _showModernBottomSheet(
      context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced header with theme integration
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        gradient: themeManager.conditionalGradient(
                          lightGradient: LinearGradient(
                            colors: [
                              themeManager.accent1.withValues(alpha: 26),
                              themeManager.accent1.withValues(alpha: 13),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          darkGradient: LinearGradient(
                            colors: [
                              themeManager.accent1.withValues(alpha: 51),
                              themeManager.accent1.withValues(alpha: 26),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: themeManager.accent1.withValues(alpha: 77),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Prbal.fingerprint,
                        color: themeManager.accent1,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'settings.securitySettings'.tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: themeManager.conditionalColor(
                          lightColor: themeManager.textPrimary,
                          darkColor: themeManager.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Enhanced biometric toggle
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          themeManager.surfaceColor.withValues(alpha: 242),
                          themeManager.backgroundColor.withValues(alpha: 230),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          themeManager.surfaceColor.withValues(alpha: 230),
                          themeManager.backgroundColor.withValues(alpha: 242),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: themeManager.conditionalColor(
                        lightColor:
                            themeManager.borderColor.withValues(alpha: 128),
                        darkColor:
                            themeManager.borderColor.withValues(alpha: 77),
                      ),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Prbal.fingerprint, color: themeManager.accent1),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Biometric Authentication',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: themeManager.conditionalColor(
                                  lightColor: themeManager.textPrimary,
                                  darkColor: themeManager.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              'Use fingerprint or face ID to unlock',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: themeManager.conditionalColor(
                                  lightColor: themeManager.textSecondary,
                                  darkColor: themeManager.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: biometricsEnabled,
                        onChanged: (value) {
                          setState(() {});
                          onBiometricsChanged(value);
                        },
                        activeColor: themeManager.accent1,
                        activeTrackColor:
                            themeManager.accent1.withValues(alpha: 77),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Enhanced reset PIN option
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    splashColor: themeManager.errorColor.withValues(alpha: 26),
                    highlightColor:
                        themeManager.errorColor.withValues(alpha: 13),
                    onTap: () {
                      Navigator.pop(context);
                      onResetPin();
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: themeManager.conditionalGradient(
                          lightGradient: LinearGradient(
                            colors: [
                              themeManager.surfaceColor.withValues(alpha: 242),
                              themeManager.backgroundColor
                                  .withValues(alpha: 230),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          darkGradient: LinearGradient(
                            colors: [
                              themeManager.surfaceColor.withValues(alpha: 230),
                              themeManager.backgroundColor
                                  .withValues(alpha: 242),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: themeManager.conditionalColor(
                            lightColor:
                                themeManager.borderColor.withValues(alpha: 128),
                            darkColor:
                                themeManager.borderColor.withValues(alpha: 77),
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Prbal.key, color: themeManager.errorColor),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reset PIN',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: themeManager.conditionalColor(
                                      lightColor: themeManager.textPrimary,
                                      darkColor: themeManager.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Change your security PIN',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: themeManager.conditionalColor(
                                      lightColor: themeManager.textSecondary,
                                      darkColor: themeManager.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Prbal.angleRight,
                            color: themeManager.conditionalColor(
                              lightColor: themeManager.textTertiary,
                              darkColor: themeManager.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Enhanced close button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(
                        color: themeManager.conditionalColor(
                          lightColor: themeManager.borderColor,
                          darkColor: themeManager.borderColor,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: themeManager.conditionalColor(
                          lightColor: themeManager.textSecondary,
                          darkColor: themeManager.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Shows enhanced storage usage bottom sheet with ThemeManager integration
  static Future<void> showStorageBottomSheet(BuildContext context) async {
    final themeManager = ThemeManager.of(context);

    debugPrint('💾 [BottomSheets] Showing enhanced storage usage');

    await _showModernBottomSheet(
      context,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced header with theme integration
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          themeManager.accent3.withValues(alpha: 26),
                          themeManager.accent3.withValues(alpha: 13),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          themeManager.accent3.withValues(alpha: 51),
                          themeManager.accent3.withValues(alpha: 26),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: themeManager.accent3.withValues(alpha: 77),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Prbal.storage,
                    color: themeManager.accent3,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  'Storage Usage',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.textPrimary,
                      darkColor: themeManager.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Enhanced storage items with ThemeManager colors
            _buildStorageItem(
                themeManager, 'App Data', '45.2 MB', themeManager.infoColor),
            SizedBox(height: 12.h),
            _buildStorageItem(
                themeManager, 'Cache', '12.8 MB', themeManager.warningColor),
            SizedBox(height: 12.h),
            _buildStorageItem(
                themeManager, 'Images', '89.1 MB', themeManager.successColor),
            SizedBox(height: 12.h),
            _buildStorageItem(
                themeManager, 'Documents', '23.4 MB', themeManager.accent1),
            SizedBox(height: 24.h),

            // Enhanced close button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  side: BorderSide(
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.borderColor,
                      darkColor: themeManager.borderColor,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.textSecondary,
                      darkColor: themeManager.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows enhanced clear cache confirmation bottom sheet with ThemeManager integration
  static Future<bool?> showClearCacheBottomSheet(BuildContext context) async {
    final themeManager = ThemeManager.of(context);

    debugPrint('🧹 [BottomSheets] Showing enhanced clear cache confirmation');

    return await _showModernBottomSheet<bool>(
      context,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced header with theme integration
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          themeManager.warningColor.withValues(alpha: 26),
                          themeManager.warningColor.withValues(alpha: 13),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          themeManager.warningColor.withValues(alpha: 51),
                          themeManager.warningColor.withValues(alpha: 26),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: themeManager.warningColor.withValues(alpha: 77),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Prbal.cleaningServices,
                    color: themeManager.warningColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  'Clear Cache',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.textPrimary,
                      darkColor: themeManager.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Enhanced content with theme integration
            Text(
              'This will clear all cached data to free up space. This action cannot be undone.',
              style: TextStyle(
                fontSize: 16.sp,
                color: themeManager.conditionalColor(
                  lightColor: themeManager.textSecondary,
                  darkColor: themeManager.textSecondary,
                ),
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),

            // Enhanced action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(
                        color: themeManager.conditionalColor(
                          lightColor: themeManager.borderColor,
                          darkColor: themeManager.borderColor,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: themeManager.conditionalColor(
                          lightColor: themeManager.textSecondary,
                          darkColor: themeManager.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: themeManager.warningGradient,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color:
                              themeManager.warningColor.withValues(alpha: 77),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Clear Cache',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds enhanced storage item row with ThemeManager integration
  static Widget _buildStorageItem(
      ThemeManager themeManager, String label, String size, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 77),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: themeManager.conditionalColor(
                lightColor: themeManager.textPrimary,
                darkColor: themeManager.textPrimary,
              ),
            ),
          ),
          const Spacer(),
          Text(
            size,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: themeManager.conditionalColor(
                lightColor: themeManager.textSecondary,
                darkColor: themeManager.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
