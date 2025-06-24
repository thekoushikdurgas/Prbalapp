import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildMetaInfo({
  required IconData icon,
  required String label,
  required String value,
  required bool isDark,
}) {
  final textColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  final valueColor = isDark ? Colors.white : const Color(0xFF111827);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            icon,
            size: 12.sp,
            color: textColor,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      SizedBox(height: 4.h),
      Text(
        value,
        style: TextStyle(
          fontSize: 13.sp,
          color: valueColor,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
