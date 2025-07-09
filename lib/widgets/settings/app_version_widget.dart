import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({
    super.key,
    this.version = 'Version 1.0.0',
  });

  final String version;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        version,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          color: isDark ? Colors.grey[500] : Colors.grey[500],
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
