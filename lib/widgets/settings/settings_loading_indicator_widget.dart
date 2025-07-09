import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

/// SettingsLoadingIndicatorWidget - Reusable loading indicator for settings screens
///
/// This widget provides a consistent loading state UI that can be used across
/// different settings sections. It includes:
/// - Theme-aware styling for light and dark modes
/// - Consistent spacing and typography
/// - Customizable loading message
/// - Modern glass-morphism design
class SettingsLoadingIndicatorWidget extends StatelessWidget {
  const SettingsLoadingIndicatorWidget({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ SettingsLoadingIndicatorWidget: Building loading indicator');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
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
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? Colors.white : const Color(0xFF4299E1),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            message ?? 'settings.loadingSettings'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}
