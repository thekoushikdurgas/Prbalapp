import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/widgets/admin/category/utils/category_utils.dart';

/// ====================================================================
/// CATEGORY CARD COMPONENTS
/// ====================================================================
///
/// **Purpose**: Reusable card components for displaying category information
///
/// **Components Included**:
/// - CategoryCard: Main category card with expandable content
/// - CategoryIcon: Icon component for categories
/// - CategoryCardContent: Main content area of the card
/// - ExpandableContent: Expandable details section
/// - CategoryActionsMenu: Actions menu for each category
///
/// **Features**:
/// - Modern Material Design 3.0
/// - Theme-aware design
/// - Smooth animations
/// - Haptic feedback
/// - Comprehensive debug logging
/// ====================================================================

/// Modern category card with expandable content and actions
class CategoryCard extends StatefulWidget {
  final ServiceCategory category;
  final bool isSelected;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(ServiceCategory)? onEdit;
  final Function(ServiceCategory)? onDelete;
  final Function(ServiceCategory)? onToggleStatus;
  final Set<String> expandedCategories;
  final Function(String) onToggleExpand;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.index,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
    required this.expandedCategories,
    required this.onToggleExpand,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🎴 CategoryCard: Initializing card for category "${widget.category.name}"');

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isExpanded = widget.expandedCategories.contains(widget.category.id);

    debugPrint('🎴 CategoryCard: Building card for "${widget.category.name}" (expanded: $isExpanded)');

    // Theme-aware colors
    final primaryColor = isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);
    final backgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final borderColor = widget.isSelected ? primaryColor : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB));
    final iconColor = CategoryUtils.getCategoryIconColor(widget.category, isDark);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Material(
              elevation: widget.isSelected ? 8 : 2,
              shadowColor:
                  widget.isSelected ? primaryColor.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: borderColor,
                    width: widget.isSelected ? 2.0 : 1.0,
                  ),
                  gradient: widget.isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withValues(alpha: 0.05),
                            backgroundColor,
                          ],
                        )
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        debugPrint('🎴 CategoryCard: Card tapped for "${widget.category.name}"');
                        HapticFeedback.lightImpact();
                        widget.onTap?.call();
                      },
                      onLongPress: () {
                        debugPrint('🎴 CategoryCard: Card long pressed for "${widget.category.name}"');
                        HapticFeedback.mediumImpact();
                        _scaleController.forward().then((_) {
                          _scaleController.reverse();
                        });
                        widget.onLongPress?.call();
                      },
                      borderRadius: BorderRadius.circular(16.r),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Column(
                          children: [
                            // Main card content
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Row(
                                children: [
                                  // Category icon
                                  CategoryIcon(
                                    category: widget.category,
                                    iconColor: iconColor,
                                    isDark: isDark,
                                  ),

                                  SizedBox(width: 16.w),

                                  // Main content
                                  Expanded(
                                    child: CategoryCardContent(
                                      category: widget.category,
                                      isDark: isDark,
                                    ),
                                  ),

                                  SizedBox(width: 12.w),

                                  // Expand/collapse button
                                  _buildExpandButton(isExpanded, isDark),

                                  SizedBox(width: 8.w),

                                  // Actions menu
                                  CategoryActionsMenu(
                                    category: widget.category,
                                    onEdit: widget.onEdit,
                                    onDelete: widget.onDelete,
                                    onToggleStatus: widget.onToggleStatus,
                                  ),
                                ],
                              ),
                            ),

                            // Expandable content
                            if (isExpanded)
                              ExpandableContent(
                                category: widget.category,
                                isDark: isDark,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandButton(bool isExpanded, bool isDark) {
    final iconColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: GestureDetector(
        onTap: () {
          debugPrint('🔄 CategoryCard: Expand button tapped for "${widget.category.name}"');
          HapticFeedback.selectionClick();
          widget.onToggleExpand(widget.category.id);
        },
        child: AnimatedRotation(
          turns: isExpanded ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            LineIcons.angleDown,
            size: 16.sp,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('🎴 CategoryCard: Disposing card for category "${widget.category.name}"');
    _scaleController.dispose();
    super.dispose();
  }
}

/// Category icon component with theme-aware styling
class CategoryIcon extends StatelessWidget {
  final ServiceCategory category;
  final Color iconColor;
  final bool isDark;

  const CategoryIcon({
    super.key,
    required this.category,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 CategoryIcon: Building icon for category "${category.name}" with icon "${category.icon}"');

    final icon = CategoryUtils.getIconFromString(category.icon ?? 'list');

    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            iconColor.withValues(alpha: 0.15),
            iconColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 28.sp,
        color: iconColor,
      ),
    );
  }
}

/// Main content area of the category card
class CategoryCardContent extends StatelessWidget {
  final ServiceCategory category;
  final bool isDark;

  const CategoryCardContent({
    super.key,
    required this.category,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('📝 CategoryCardContent: Building content for category "${category.name}"');

    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111827);
    final secondaryTextColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final statusColor = CategoryUtils.getStatusColor(category.isActive, isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category name and status
        Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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

        SizedBox(height: 6.h),

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

        SizedBox(height: 8.h),

        // Quick stats
        Row(
          children: [
            Icon(
              LineIcons.layerGroup,
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
              LineIcons.clock,
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
    );
  }
}

/// Expandable content section showing detailed information
class ExpandableContent extends StatelessWidget {
  final ServiceCategory category;
  final bool isDark;

  const ExpandableContent({
    super.key,
    required this.category,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('📋 ExpandableContent: Building expandable content for category "${category.name}"');

    final dividerColor = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
    final backgroundColor = isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detailed information header
            Row(
              children: [
                Icon(
                  LineIcons.infoCircle,
                  size: 16.sp,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Detailed Information',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Metadata grid
            Row(
              children: [
                Expanded(
                  child: _buildMetaInfo(
                    icon: LineIcons.calendar,
                    label: 'Created',
                    value: CategoryUtils.formatFullDate(category.createdAt),
                    isDark: isDark,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildMetaInfo(
                    icon: LineIcons.edit,
                    label: 'Updated',
                    value: CategoryUtils.formatFullDate(category.updatedAt),
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Additional metadata
            _buildMetaInfo(
              icon: LineIcons.hashtag,
              label: 'Category ID',
              value: category.id,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo({
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
}

/// Actions menu component for category operations
class CategoryActionsMenu extends StatelessWidget {
  final ServiceCategory category;
  final Function(ServiceCategory)? onEdit;
  final Function(ServiceCategory)? onDelete;
  final Function(ServiceCategory)? onToggleStatus;

  const CategoryActionsMenu({
    super.key,
    required this.category,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    debugPrint('⚙️ CategoryActionsMenu: Building actions menu for category "${category.name}"');

    return PopupMenuButton<String>(
      icon: Icon(
        LineIcons.verticalEllipsis,
        size: 20.sp,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 8,
      offset: Offset(-8.w, 8.h),
      onSelected: (value) {
        debugPrint('⚙️ CategoryActionsMenu: Action selected: $value for "${category.name}"');
        HapticFeedback.selectionClick();

        switch (value) {
          case 'edit':
            onEdit?.call(category);
            break;
          case 'toggle_status':
            onToggleStatus?.call(category);
            break;
          case 'delete':
            onDelete?.call(category);
            break;
        }
      },
      itemBuilder: (context) => [
        _buildActionOption(
          value: 'edit',
          icon: LineIcons.edit,
          label: 'Edit Category',
          color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
          isDark: isDark,
        ),
        _buildActionOption(
          value: 'toggle_status',
          icon: category.isActive ? LineIcons.pauseCircle : LineIcons.playCircle,
          label: category.isActive ? 'Deactivate' : 'Activate',
          color: category.isActive
              ? (isDark ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B))
              : (isDark ? const Color(0xFF34D399) : const Color(0xFF10B981)),
          isDark: isDark,
        ),
        PopupMenuDivider(height: 1),
        _buildActionOption(
          value: 'delete',
          icon: LineIcons.trash,
          label: 'Delete',
          color: isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444),
          isDark: isDark,
          isDestructive: true,
        ),
      ],
    );
  }

  PopupMenuEntry<String> _buildActionOption({
    required String value,
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: 16.sp,
                color: color,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? color : (isDark ? Colors.white : const Color(0xFF111827)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
