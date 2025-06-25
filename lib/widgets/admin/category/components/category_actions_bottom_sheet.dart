import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/widgets/admin/category/components/category_cards.dart';
import 'package:prbal/widgets/admin/category/utils/category_utils.dart';
// import 'package:prbal/widgets/admin/category/utils/meta_info.dart';

/// CategoryActionsBottomSheet - Modal bottom sheet for category actions
///
/// **Purpose**: Provides category action options in a modern modal bottom sheet
///
/// **Key Features**:
/// - Modern Material Design 3.0 bottom sheet
/// - Gradient backgrounds with theme awareness
/// - Action options for Edit, Toggle Status, and Delete
/// - Smooth animations and intuitive interactions
/// - Drag handle and close button for better UX
/// - Dynamic action labels based on category status
class CategoryActionsBottomSheet extends StatelessWidget {
  final ServiceCategory category;
  final Function(ServiceCategory)? onEdit;
  final Function(ServiceCategory)? onDelete;
  final Function(ServiceCategory)? onToggleStatus;

  const CategoryActionsBottomSheet({
    super.key,
    required this.category,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  /// Show the category actions bottom sheet
  static Future<void> show({
    required BuildContext context,
    required ServiceCategory category,
    Function(ServiceCategory)? onEdit,
    Function(ServiceCategory)? onDelete,
    Function(ServiceCategory)? onToggleStatus,
  }) async {
    debugPrint(
        '⚙️ CategoryActionsBottomSheet: Showing actions bottom sheet for "${category.name}"');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      // showDragHandle: false,
      builder: (BuildContext context) => CategoryActionsBottomSheet(
        category: category,
        onEdit: onEdit,
        onDelete: onDelete,
        onToggleStatus: onToggleStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🎨 CategoryActionsBottomSheet: Building actions bottom sheet for "${category.name}"');
    debugPrint(
        '🎨 CategoryActionsBottomSheet: Screen height: ${MediaQuery.of(context).size.height}');
    debugPrint(
        '🎨 CategoryActionsBottomSheet: Max height constraint: ${MediaQuery.of(context).size.height * 0.6}');

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ========== DRAG HANDLE ==========
            _buildDragHandle(isDark),

            // ========== HEADER ==========
            _buildHeader(context, isDark),

            // ========== ACTION OPTIONS ==========
            _buildActionOptions(context, isDark),
          ],
        ),
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

  /// Build header section with category info and close button
  Widget _buildHeader(BuildContext context, bool isDark) {
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111827);
    final secondaryTextColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final statusColor = CategoryUtils.getStatusColor(category.isActive, isDark);
    final iconColor = CategoryUtils.getCategoryIconColor(category, isDark);

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
          CategoryIcon(
            category: category,
            iconColor: iconColor,
            isDark: isDark,
          ),
          SizedBox(width: 16.w),

          // ========== CATEGORY INFO ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Prbal.infoCircle,
                      size: 16.sp,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        category.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5.h),
                // Description
                if (category.description.isNotEmpty)
                  Text(
                    category.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: secondaryTextColor,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                SizedBox(height: 5.h),

                // Quick stats
                Row(
                  children: [
                    Icon(
                      Prbal.layers5,
                      size: 12.sp,
                      color: secondaryTextColor,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        'Sort: ${category.sortOrder}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Prbal.clock,
                      size: 12.sp,
                      color: secondaryTextColor,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        CategoryUtils.formatDate(category.updatedAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build action options list
  Widget _buildActionOptions(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ========== EDIT ACTION ==========
          _buildActionOption(
            context: context,
            title: 'Edit Category',
            subtitle: 'Modify category details and settings',
            icon: Prbal.edit,
            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
            isDark: isDark,
            onTap: () {
              debugPrint(
                  '⚙️ CategoryActionsBottomSheet: Edit action selected for "${category.name}"');
              Navigator.of(context).pop();
              HapticFeedback.selectionClick();
              onEdit?.call(category);
            },
          ),
          SizedBox(height: 12.h),

          // ========== TOGGLE STATUS ACTION ==========
          _buildActionOption(
            context: context,
            title:
                category.isActive ? 'Deactivate Category' : 'Activate Category',
            subtitle: category.isActive
                ? 'Set category as inactive'
                : 'Set category as active',
            icon: category.isActive ? Prbal.pauseCircle : Prbal.playCircle,
            color: category.isActive
                ? (isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B))
                : (isDark ? const Color(0xFF34D399) : const Color(0xFF10B981)),
            isDark: isDark,
            onTap: () {
              debugPrint(
                  '⚙️ CategoryActionsBottomSheet: Toggle status action selected for "${category.name}"');
              Navigator.of(context).pop();
              HapticFeedback.selectionClick();
              onToggleStatus?.call(category);
            },
          ),
          SizedBox(height: 12.h),

          // ========== DELETE ACTION ==========
          _buildActionOption(
            context: context,
            title: 'Delete Category',
            subtitle: 'Permanently remove this category',
            icon: Prbal.trash,
            color: isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444),
            isDark: isDark,
            isDestructive: true,
            onTap: () {
              debugPrint(
                  '⚙️ CategoryActionsBottomSheet: Delete action selected for "${category.name}"');
              Navigator.of(context).pop();
              HapticFeedback.mediumImpact();
              onDelete?.call(category);
            },
          ),
        ],
      ),
    );
  }

  /// Build individual action option tile
  Widget _buildActionOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // ========== ACTION ICON ==========
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: color,
                ),
              ),
              SizedBox(width: 16.w),

              // ========== ACTION TEXT ==========
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDestructive
                            ? color
                            : (isDark ? Colors.white : const Color(0xFF111827)),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
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

              // ========== ARROW INDICATOR ==========
              Icon(
                Prbal.angleRight,
                size: 16.sp,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
