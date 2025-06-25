import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/widgets/admin/category/components/category_filter_option.dart';

/// CategoryFilterBottomSheet - Extracted component for filter bottom sheet
///
/// **Purpose**: Encapsulates the modern filter bottom sheet functionality
///
/// **Key Features**:
/// - Modern Material Design 3.0 bottom sheet
/// - Gradient backgrounds with theme awareness
/// - Filter options for all, active, and inactive categories
/// - Smooth animations and intuitive interactions
/// - Drag handle and close button for better UX
class CategoryFilterBottomSheet extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterSelected;

  const CategoryFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
  });

  /// Show the filter bottom sheet
  static Future<void> show({
    required BuildContext context,
    required String currentFilter,
    required Function(String) onFilterSelected,
  }) async {
    debugPrint(
        '🔧 CategoryFilterBottomSheet: Showing modern filter bottom sheet');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (BuildContext context) => CategoryFilterBottomSheet(
        currentFilter: currentFilter,
        onFilterSelected: onFilterSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 CategoryFilterBottomSheet: Building filter bottom sheet');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF374151), const Color(0xFF1F2937)]
              : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ========== DRAG HANDLE ==========
          _buildDragHandle(isDark),

          // ========== HEADER ==========
          _buildHeader(context, isDark),

          // ========== FILTER OPTIONS ==========
          _buildFilterOptions(context, isDark),
        ],
      ),
    );
  }

  /// Build drag handle widget
  Widget _buildDragHandle(bool isDark) {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      width: 60.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[600] : Colors.grey[300],
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  /// Build header section with title and close button
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // ========== FILTER ICON WITH GRADIENT BACKGROUND ==========
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Prbal.filter,
              color: Theme.of(context).primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),

          // ========== TITLE SECTION ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Categories',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Choose category status to display',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ========== CLOSE BUTTON ==========
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              onPressed: () {
                debugPrint(
                    '🔧 CategoryFilterBottomSheet: Close button pressed');
                Navigator.of(context).pop();
              },
              icon: Icon(
                Prbal.cross,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 20.sp,
              ),
              padding: EdgeInsets.all(8.w),
              constraints: BoxConstraints(
                minWidth: 40.w,
                minHeight: 40.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build filter options list
  Widget _buildFilterOptions(BuildContext context, bool isDark) {
    return Flexible(
      child: ListView(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        children: [
          // ========== ALL CATEGORIES OPTION ==========
          CategoryFilterOption(
            title: 'All Categories',
            subtitle: 'Show both active and inactive categories',
            icon: Prbal.list,
            value: 'all',
            currentFilter: currentFilter,
            isDark: isDark,
            onSelected: (value) {
              debugPrint(
                  '🔧 CategoryFilterBottomSheet: Filter option selected: $value');
              onFilterSelected(value);
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 12.h),

          // ========== ACTIVE CATEGORIES OPTION ==========
          CategoryFilterOption(
            title: 'Active Categories',
            subtitle: 'Show only active categories',
            icon: Prbal.checkCircle,
            value: 'active',
            currentFilter: currentFilter,
            isDark: isDark,
            color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
            onSelected: (value) {
              debugPrint(
                  '🔧 CategoryFilterBottomSheet: Filter option selected: $value');
              onFilterSelected(value);
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 12.h),

          // ========== INACTIVE CATEGORIES OPTION ==========
          CategoryFilterOption(
            title: 'Inactive Categories',
            subtitle: 'Show only inactive categories',
            icon: Prbal.pauseCircle,
            value: 'inactive',
            currentFilter: currentFilter,
            isDark: isDark,
            color: isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706),
            onSelected: (value) {
              debugPrint(
                  '🔧 CategoryFilterBottomSheet: Filter option selected: $value');
              onFilterSelected(value);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
