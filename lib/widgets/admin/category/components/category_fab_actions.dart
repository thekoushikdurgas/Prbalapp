import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

/// CategoryFabActions - Floating Action Button components for category operations
///
/// **Purpose**: Provides floating action buttons for category operations
///
/// **Key Features**:
/// - Add category FAB for creating new categories
/// - Bulk actions FAB for selected categories operations
/// - Modern Material Design 3.0 styling
/// - Dark/light theme support
/// - Smooth animations and haptic feedback
/// - Gradient backgrounds and visual indicators
class CategoryFabActions extends StatelessWidget {
  final bool hasSelection;
  final int selectedCount;
  final VoidCallback onAddCategory;
  final VoidCallback? onBulkActivate;
  final VoidCallback? onBulkDeactivate;
  final VoidCallback? onBulkExport;
  final VoidCallback? onBulkDelete;
  final Animation<double>? scaleAnimation;

  const CategoryFabActions({
    super.key,
    required this.hasSelection,
    required this.selectedCount,
    required this.onAddCategory,
    this.onBulkActivate,
    this.onBulkDeactivate,
    this.onBulkExport,
    this.onBulkDelete,
    this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🚀 CategoryFabActions: Building FAB - hasSelection: $hasSelection, selectedCount: $selectedCount');

    final fabWidget = hasSelection
        ? _buildBulkActionsFAB(context)
        : _buildAddCategoryFAB(context);

    if (scaleAnimation != null) {
      return ScaleTransition(
        scale: scaleAnimation!,
        child: fabWidget,
      );
    }

    return fabWidget;
  }

  /// Build bulk actions floating action button when categories are selected
  Widget _buildBulkActionsFAB(BuildContext context) {
    debugPrint(
        '⚡ CategoryFabActions: Building bulk actions FAB for $selectedCount selected categories');

    final primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton.extended(
      onPressed: () {
        debugPrint('⚡ CategoryFabActions: Bulk actions FAB pressed');
        HapticFeedback.mediumImpact();
        _showBulkActionsBottomSheet(context);
      },
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Prbal.cog,
          size: 20.sp,
          color: Colors.white,
        ),
      ),
      label: Text(
        '$selectedCount',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }

  /// Build add category floating action button when no categories are selected
  Widget _buildAddCategoryFAB(BuildContext context) {
    debugPrint('➕ CategoryFabActions: Building add category FAB');

    // final primaryColor = Theme.of(context).primaryColor;

    return FloatingActionButton(
      onPressed: () {
        debugPrint('➕ CategoryFabActions: Add category FAB pressed');
        HapticFeedback.lightImpact();
        onAddCategory();
      },
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      // foregroundColor: Colors.white,
      // elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(
        Prbal.plus,
        size: 20.sp,
        color: Colors.white,
      ),
    );
  }

  /// Show bulk actions bottom sheet with modern design
  void _showBulkActionsBottomSheet(BuildContext context) {
    debugPrint('⚡ CategoryFabActions: Showing bulk actions bottom sheet');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (BuildContext context) => Container(
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
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 60.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              // Header
              Container(
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
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withValues(alpha: 0.2),
                            primaryColor.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        Prbal.cog,
                        color: primaryColor,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bulk Actions',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF2D3748),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '$selectedCount categories selected',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Prbal.cross,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Action options
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
                child: Column(
                  children: [
                    _buildBulkActionTile(
                      context,
                      'Activate All',
                      'Set all selected categories as active',
                      Prbal.checkCircle,
                      Colors.green,
                      onBulkActivate,
                    ),
                    SizedBox(height: 12.h),
                    _buildBulkActionTile(
                      context,
                      'Deactivate All',
                      'Set all selected categories as inactive',
                      Prbal.pauseCircle,
                      Colors.orange,
                      onBulkDeactivate,
                    ),
                    SizedBox(height: 12.h),
                    _buildBulkActionTile(
                      context,
                      'Export Selected',
                      'Export selected categories data',
                      Prbal.download,
                      Colors.blue,
                      onBulkExport,
                    ),
                    SizedBox(height: 12.h),
                    _buildBulkActionTile(
                      context,
                      'Delete All',
                      'Permanently delete all selected categories',
                      Prbal.trash,
                      Colors.red,
                      onBulkDelete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build bulk action tile for bottom sheet
  Widget _buildBulkActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null
            ? () {
                debugPrint(
                    '⚡ CategoryFabActions: Bulk action "$title" pressed');
                Navigator.of(context).pop();
                HapticFeedback.lightImpact();
                onTap();
              }
            : null,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Prbal.angleRight,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
