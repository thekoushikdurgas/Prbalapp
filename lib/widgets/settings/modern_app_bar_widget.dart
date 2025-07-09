import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ModernAppBarWidget - Modern app bar with gradient background
///
/// This widget provides a beautiful app bar with:
/// - Gradient background effects
/// - Theme-aware styling
/// - Customizable title and expandedHeight
/// - Floating and pinned behavior options
class ModernAppBarWidget extends StatelessWidget {
  const ModernAppBarWidget({
    super.key,
    required this.title,
    this.expandedHeight = 120,
    this.floating = false,
    this.pinned = true,
    this.elevation = 0,
  });

  final String title;
  final double expandedHeight;
  final bool floating;
  final bool pinned;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🏗️ ModernAppBarWidget: Building modern app bar for title: $title');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: expandedHeight.h,
      floating: floating,
      pinned: pinned,
      backgroundColor: Colors.transparent,
      elevation: elevation,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2D2D2D),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFF7FAFC),
                  ],
          ),
        ),
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
              letterSpacing: -1.0,
            ),
          ),
        ),
      ),
    );
  }
}
