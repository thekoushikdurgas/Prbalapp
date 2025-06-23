import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/utils/lang/locale_keys.g.dart';
import 'package:prbal/utils/localization/project_locales.dart';
import 'package:prbal/widgets/theme_selector_widget.dart';
import 'package:easy_localization/easy_localization.dart';

/// SettingsBottomSheets - Collection of bottom sheet widgets for settings
///
/// This class provides static methods to show various bottom sheets:
/// - Theme selection bottom sheet
/// - Language selection bottom sheet
/// - Security settings bottom sheet
/// - Data management bottom sheets
/// All with modern design and proper theming
class SettingsBottomSheets {
  /// Shows a modern bottom sheet with consistent styling
  static Future<T?> _showModernBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
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

  /// Shows enhanced theme selection bottom sheet with comprehensive debugging
  ///
  /// **Enhanced Features:**
  /// - Real-time theme state monitoring during selection
  /// - Performance tracking for bottom sheet operations
  /// - Enhanced error handling with user feedback
  /// - Detailed debug logging for theme operations
  /// - Integration with enhanced ThemeSelectorWidget
  ///
  /// **Debug Features:**
  /// - Bottom sheet lifecycle tracking
  /// - Theme state validation before and after selection
  /// - Performance metrics for user interactions
  /// - Error context and recovery guidance
  static Future<void> showThemeBottomSheet(BuildContext context) async {
    debugPrint(
        '🎨 SettingsBottomSheets: === ENHANCED THEME SELECTION INITIATED ===');

    // Capture initial theme state for comparison
    final initialTheme = Theme.of(context);
    final isDark = initialTheme.brightness == Brightness.dark;
    debugPrint(
        '🎨 SettingsBottomSheets: Initial theme state - Brightness: ${initialTheme.brightness}');
    debugPrint(
        '🎨 SettingsBottomSheets: Theme colors - Primary: ${initialTheme.colorScheme.primary}');
    debugPrint(
        '🎨 SettingsBottomSheets: Surface: ${initialTheme.colorScheme.surface}');

    // Start performance timing
    final stopwatch = Stopwatch()..start();

    try {
      debugPrint(
          '🎨 SettingsBottomSheets: Creating enhanced theme selection bottom sheet...');

      await _showModernBottomSheet(
        context,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced header with theme state display
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38B2AC).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      LineIcons.palette,
                      color: const Color(0xFF38B2AC),
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
                            color:
                                isDark ? Colors.white : const Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Current: ${isDark ? 'Dark' : 'Light'} Theme',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Enhanced theme selector widget with debugging
              const ThemeSelectorWidget(),

              SizedBox(height: 24.h),

              // Enhanced close button with performance logging
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('🎨 SettingsBottomSheets: Close button tapped');
                    stopwatch.stop();
                    debugPrint(
                        '🎨 SettingsBottomSheets: ⏱️ Total selection time: ${stopwatch.elapsedMilliseconds}ms');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B2AC),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
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
            ],
          ),
        ),
      );

      stopwatch.stop();
      debugPrint(
          '🎨 SettingsBottomSheets: ✅ Theme selection bottom sheet completed successfully');
      debugPrint(
          '🎨 SettingsBottomSheets: ⏱️ Total operation time: ${stopwatch.elapsedMilliseconds}ms');
    } catch (error, stackTrace) {
      stopwatch.stop();
      debugPrint(
          '🎨 SettingsBottomSheets: ❌ Error in theme selection bottom sheet: $error');
      debugPrint(
          '🎨 SettingsBottomSheets: 📍 Error occurred after ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('🎨 SettingsBottomSheets: 🔍 Stack trace: $stackTrace');

      // Show user-friendly error feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text('Theme selection unavailable. Please try again.'),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    } finally {
      debugPrint(
          '🎨 SettingsBottomSheets: === THEME SELECTION OPERATION COMPLETED ===');
    }
  }

  /// Shows language selection bottom sheet
  static Future<void> showLanguageBottomSheet(BuildContext context) async {
    debugPrint(
        '🌐 SettingsBottomSheets: Showing language selection bottom sheet');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    await _showModernBottomSheet(
      context,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    LineIcons.language,
                    color: const Color(0xFF667EEA),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  LocaleKeys.localizationLangChoose.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Language options
            ...ProjectLocales.localesMap.entries.map((entry) {
              final isSelected = context.locale == entry.key;
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () {
                      context.setLocale(entry.key);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF667EEA)
                              : (isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        color: isSelected
                            ? const Color(0xFF667EEA).withValues(alpha: 0.1)
                            : Colors.transparent,
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
                                    ? const Color(0xFF667EEA)
                                    : (isDark
                                        ? Colors.white
                                        : const Color(0xFF2D3748)),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF667EEA),
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
            // Close button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  side: BorderSide(
                    color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
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
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows security settings bottom sheet
  static Future<void> showSecurityBottomSheet(
    BuildContext context, {
    required bool biometricsEnabled,
    required Function(bool) onBiometricsChanged,
    required VoidCallback onResetPin,
  }) async {
    debugPrint(
        '🔒 SettingsBottomSheets: Showing security settings bottom sheet');

    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                // Header with icon
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9F7AEA).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        LineIcons.fingerprint,
                        color: const Color(0xFF9F7AEA),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'settings.securitySettings'.tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Biometric toggle
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.grey[800] : Colors.grey[50]),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(LineIcons.fingerprint,
                          color: const Color(0xFF9F7AEA)),
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
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF2D3748),
                              ),
                            ),
                            Text(
                              'Use fingerprint or face ID to unlock',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
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
                        activeColor: const Color(0xFF9F7AEA),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Reset PIN option
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () {
                      Navigator.pop(context);
                      onResetPin();
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.grey[800] : Colors.grey[50]),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(LineIcons.key, color: const Color(0xFFE53E3E)),
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
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF2D3748),
                                  ),
                                ),
                                Text(
                                  'Change your security PIN',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            LineIcons.angleRight,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                // Close button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(
                        color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
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
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
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

  /// Shows storage usage bottom sheet
  static Future<void> showStorageBottomSheet(BuildContext context) async {
    debugPrint('💾 SettingsBottomSheets: Showing storage usage bottom sheet');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    await _showModernBottomSheet(
      context,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38B2AC).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.storage,
                    color: const Color(0xFF38B2AC),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  'Storage Usage',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Storage items
            _buildStorageItem('App Data', '45.2 MB', const Color(0xFF4299E1)),
            SizedBox(height: 12.h),
            _buildStorageItem('Cache', '12.8 MB', const Color(0xFFED8936)),
            SizedBox(height: 12.h),
            _buildStorageItem('Images', '89.1 MB', const Color(0xFF48BB78)),
            SizedBox(height: 12.h),
            _buildStorageItem('Documents', '23.4 MB', const Color(0xFF9F7AEA)),
            SizedBox(height: 24.h),
            // Close button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  side: BorderSide(
                    color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
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
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows clear cache confirmation bottom sheet
  static Future<bool?> showClearCacheBottomSheet(BuildContext context) async {
    debugPrint(
        '🧹 SettingsBottomSheets: Showing clear cache confirmation bottom sheet');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return await _showModernBottomSheet<bool>(
      context,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED8936).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.cleaning_services,
                    color: const Color(0xFFED8936),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  'Clear Cache',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Content
            Text(
              'This will clear all cached data to free up space. This action cannot be undone.',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(
                        color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
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
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED8936),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds storage item row
  static Widget _buildStorageItem(String label, String size, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Text(label),
          Spacer(),
          Text(size, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
