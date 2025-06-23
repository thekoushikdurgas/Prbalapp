import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

/// CategoryFilterOption - Modern filter option widget component
///
/// **Purpose**: Reusable filter option component for category filtering
///
/// **Key Features**:
/// - Modern Material Design 3.0 styling
/// - Theme-aware design with gradient selection states
/// - Smooth animations and haptic feedback
/// - Customizable colors for different filter types
/// - Selection indicator with scale animation
/// - Comprehensive debug logging
///
/// **Usage**:
/// ```dart
/// CategoryFilterOption(
///   title: 'Active Categories',
///   subtitle: 'Show only active categories',
///   icon: LineIcons.checkCircle,
///   value: 'active',
///   currentFilter: _currentFilter,
///   isDark: isDark,
///   color: Colors.green,
///   onSelected: (value) {
///     setState(() => _currentFilter = value);
///     _applyFilters();
///     Navigator.of(context).pop();
///   },
/// )
/// ```
class CategoryFilterOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String currentFilter;
  final bool isDark;
  final Color? color;
  final Function(String) onSelected;

  const CategoryFilterOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.currentFilter,
    required this.isDark,
    this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentFilter == value;
    final effectiveColor = color ?? Theme.of(context).primaryColor;

    debugPrint('🔧 CategoryFilterOption: Building filter option "$title" (selected: $isSelected)');

    return GestureDetector(
      onTap: () {
        debugPrint('🔧 CategoryFilterOption: Filter option selected: $value');
        HapticFeedback.selectionClick();
        onSelected(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    effectiveColor.withValues(alpha: 0.15),
                    effectiveColor.withValues(alpha: 0.05),
                  ],
                )
              : null,
          color: isSelected ? null : (isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB)),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? effectiveColor.withValues(alpha: 0.4)
                : (isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: effectiveColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveColor.withValues(alpha: 0.2),
                    effectiveColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: effectiveColor.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                icon,
                color: effectiveColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? effectiveColor : (isDark ? Colors.white : const Color(0xFF2D3748)),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: effectiveColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LineIcons.check,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
