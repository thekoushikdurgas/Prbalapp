import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

/// Utility class for managing standardized snackbar notifications
class FeedbackUtils {
  /// Shows error snackbar with standard styling
  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    int durationSeconds = 5,
  }) {
    if (!context.mounted) return;

    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Prbal.errorOutline,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: title != null ? 12.sp : 14.sp,
                      fontWeight:
                          title != null ? FontWeight.w400 : FontWeight.w500,
                      color: title != null
                          ? Colors.white.withValues(alpha: 0.9)
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }

  /// Shows success snackbar with standard styling
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    int durationSeconds = 3,
  }) {
    if (!context.mounted) return;

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Prbal.checkCircle,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: title != null ? 12.sp : 14.sp,
                      fontWeight:
                          title != null ? FontWeight.w400 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF48BB78),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }

  /// Shows authentication required snackbar
  static void showAuthenticationRequired({
    required BuildContext context,
    String message = 'Please log in to access this feature',
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Prbal.errorOutline,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
