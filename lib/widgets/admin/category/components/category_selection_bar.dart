import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

/// CategorySelectionBar - Modern selection info bar component
///
/// **Purpose**: Displays selection information when categories are selected
///
/// **Key Features**:
/// - Shows selected categories count
/// - Displays selection actions (clear, select all)
/// - Modern Material Design 3.0 styling
/// - Dark/light theme support
/// - Smooth animations and haptic feedback
/// - Gradient backgrounds and glassmorphism effects
class CategorySelectionBar extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onClearSelection;
  final VoidCallback? onSelectAll;
  final String selectionMessage;

  const CategorySelectionBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onClearSelection,
    this.onSelectAll,
    this.selectionMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('📊 CategorySelectionBar: Building selection bar with $selectedCount/$totalCount selected');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.15),
            primaryColor.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Selection icon with gradient background
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.2),
                  primaryColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              LineIcons.checkSquare,
              color: primaryColor,
              size: 20.sp,
            ),
          ),

          SizedBox(width: 16.w),

          // Selection info text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedCount selected',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                    letterSpacing: -0.2,
                  ),
                ),
                if (selectionMessage.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    selectionMessage,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Select all button (if not all selected)
              if (onSelectAll != null && selectedCount < totalCount)
                _buildActionButton(
                  onPressed: () {
                    debugPrint('✅ CategorySelectionBar: Select all button pressed');
                    HapticFeedback.lightImpact();
                    onSelectAll?.call();
                  },
                  icon: LineIcons.shareSquareAlt,
                  tooltip: 'Select All',
                  isDark: isDark,
                ),

              if (onSelectAll != null && selectedCount < totalCount) SizedBox(width: 8.w),

              // Clear selection button
              _buildActionButton(
                onPressed: () {
                  debugPrint('❌ CategorySelectionBar: Clear selection button pressed');
                  HapticFeedback.lightImpact();
                  onClearSelection();
                },
                icon: LineIcons.times,
                tooltip: 'Clear Selection',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build action button with consistent styling
  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String tooltip,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
          size: 18.sp,
        ),
        tooltip: tooltip,
        constraints: BoxConstraints(
          minWidth: 36.w,
          minHeight: 36.h,
        ),
        padding: EdgeInsets.all(6.w),
      ),
    );
  }
}
