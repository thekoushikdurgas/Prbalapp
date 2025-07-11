import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/models/business/service_models.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
// import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/widgets/admin/category/category_cards.dart';
import 'package:prbal/utils/category/category_utils.dart';
// import 'package:prbal/widgets/admin/category/utils/meta_info.dart';

/// CategoryActionsBottomSheet - Modal bottom sheet for category actions
///
/// **Purpose**: Provides category action options in a modern modal bottom sheet with complete ThemeManager integration
///
/// **Key Features**:
/// - Complete ThemeManager integration with all color properties
/// - Advanced gradient theming with background, surface, primary, and semantic gradients
/// - Theme-aware shadows (primary, elevated, subtle) and glass morphism effects
/// - Modern Material Design 3.0 bottom sheet with dynamic theming
/// - Action options for Edit, Toggle Status, and Delete with semantic colors
/// - Smooth animations and intuitive interactions with theme-consistent styling
/// - Drag handle and close button with enhanced UX and theme awareness
/// - Dynamic action labels based on category status using ThemeManager colors
/// - Comprehensive debug logging for theme operations
/// - Enhanced status indicators with ThemeManager semantic colors
/// - Glass morphism icon containers and enhanced visual hierarchy
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

  /// Show the category actions bottom sheet with comprehensive theming
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
      showDragHandle: false, // We'll create our own themed drag handle
      isDismissible: true,
      useSafeArea: true,
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
    // Comprehensive debug logging for theme operations
    debugPrint(
        '🎨 CategoryActionsBottomSheet: Building actions bottom sheet for "${category.name}"');

    debugPrint(
        '🎨 CategoryActionsBottomSheet: Theme mode: ${ThemeManager.of(context).themeManager ? 'dark' : 'light'}');
    debugPrint(
        '🎨 CategoryActionsBottomSheet: Screen height: ${MediaQuery.of(context).size.height}');
    debugPrint(
        '🎨 CategoryActionsBottomSheet: Max height constraint: ${MediaQuery.of(context).size.height * 0.6}');
    debugPrint(
        '🌈 CategoryActionsBottomSheet: Using gradients - Background: ${ThemeManager.of(context).backgroundGradient.colors.length} colors, Surface: ${ThemeManager.of(context).surfaceGradient.colors.length} colors');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1.5,
        ),
        boxShadow: ThemeManager.of(context).elevatedShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ========== ENHANCED DRAG HANDLE WITH THEMEMANAGER ==========
          _buildEnhancedDragHandle(ThemeManager.of(context)),

          // ========== THEMED HEADER WITH GLASS MORPHISM ==========
          _buildThemedHeader(context),

          // ========== ACTION OPTIONS WITH COMPREHENSIVE THEMING ==========
          Flexible(
            child: SingleChildScrollView(
              child: _buildThemedActionOptions(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced drag handle with comprehensive ThemeManager styling
  Widget _buildEnhancedDragHandle(ThemeManager themeManager) {
    debugPrint(
        '🎯 CategoryActionsBottomSheet: Building enhanced drag handle with ThemeManager');

    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Column(
        children: [
          // Main drag handle
          Container(
            width: 48.w,
            height: 6.h,
            decoration: BoxDecoration(
              gradient: themeManager.neutralGradient,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: themeManager.subtleShadow,
            ),
          ),

          SizedBox(height: 8.h),

          // Optional close button with glass morphism
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: themeManager.glassMorphism,
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: themeManager.textTertiary,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// Build themed header section with category info and enhanced styling
  Widget _buildThemedHeader(
    BuildContext context,
  ) {
    debugPrint(
        '📋 CategoryActionsBottomSheet: Building themed header with comprehensive ThemeManager integration');

    CategoryUtils.getStatusColor(category.isActive, ThemeManager.of(context));
    final iconColor =
        CategoryUtils.getCategoryIconColor(category, ThemeManager.of(context));

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).backgroundGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.of(context).borderColor,
            width: 1.5,
          ),
        ),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Row(
        children: [
          // Enhanced category icon with glass morphism
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: ThemeManager.of(context).enhancedGlassMorphism,
            child: EnhancedCategoryIcon(
              category: category,
              iconColor: iconColor,
            ),
          ),

          SizedBox(width: 20.w),

          // ========== ENHANCED CATEGORY INFO WITH THEMEMANAGER ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category name with status badge
                Row(
                  children: [
                    Icon(
                      Prbal.infoCircle,
                      size: 16.sp,
                      color: ThemeManager.of(context).accent3,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeManager.of(context).textPrimary,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Enhanced status badge
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        gradient: category.isActive
                            ? ThemeManager.of(context).successGradient
                            : ThemeManager.of(context).warningGradient,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: ThemeManager.of(context).subtleShadow,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category.isActive
                                ? Icons.check_circle_rounded
                                : Icons.pause_circle_rounded,
                            size: 12.sp,
                            color: ThemeManager.of(context).textInverted,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            category.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: ThemeManager.of(context).textInverted,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Description with enhanced styling
                if (category.description.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: ThemeManager.of(context).surfaceElevated,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: ThemeManager.of(context).borderColor),
                      boxShadow: ThemeManager.of(context).subtleShadow,
                    ),
                    child: Text(
                      category.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).textSecondary,
                        height: 1.4,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                // Enhanced metadata with themed containers
                Row(
                  children: [
                    // Sort order info
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          gradient: ThemeManager.of(context).accent1Gradient,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: ThemeManager.of(context).subtleShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Prbal.layers5,
                              size: 14.sp,
                              color: ThemeManager.of(context).textInverted,
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                'Sort: ${category.sortOrder}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ThemeManager.of(context).textInverted,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Updated date info
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          gradient: ThemeManager.of(context).accent2Gradient,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: ThemeManager.of(context).subtleShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Prbal.clock,
                              size: 14.sp,
                              color: ThemeManager.of(context).textInverted,
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                CategoryUtils.formatDate(category.updatedAt),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ThemeManager.of(context).textInverted,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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

  /// Build themed action options with comprehensive ThemeManager integration
  Widget _buildThemedActionOptions(
    BuildContext context,
  ) {
    debugPrint(
        '🎯 CategoryActionsBottomSheet: Building themed action options with comprehensive ThemeManager');

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: ThemeManager.of(context).neutralGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: ThemeManager.of(context).subtleShadow,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.settings_rounded,
                  color: ThemeManager.of(context).textInverted,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Available Actions',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeManager.of(context).textInverted,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // ========== EDIT ACTION WITH THEMEMANAGER ==========
          _buildThemedActionOption(
            context: context,
            title: 'Edit Category',
            subtitle: 'Modify category details and settings',
            icon: Prbal.edit,
            gradient: ThemeManager.of(context).infoGradient,
            iconColor: ThemeManager.of(context).infoColor,
            onTap: () {
              debugPrint(
                  '⚙️ CategoryActionsBottomSheet: Edit action selected for "${category.name}"');
              Navigator.of(context).pop();
              HapticFeedback.selectionClick();
              onEdit?.call(category);
            },
          ),

          SizedBox(height: 16.h),

          // ========== TOGGLE STATUS ACTION WITH THEMEMANAGER ==========
          _buildThemedActionOption(
            context: context,
            title:
                category.isActive ? 'Deactivate Category' : 'Activate Category',
            subtitle: category.isActive
                ? 'Set category as inactive'
                : 'Set category as active',
            icon: category.isActive ? Prbal.pauseCircle : Prbal.playCircle,
            gradient: category.isActive
                ? ThemeManager.of(context).warningGradient
                : ThemeManager.of(context).successGradient,
            iconColor: category.isActive
                ? ThemeManager.of(context).warningColor
                : ThemeManager.of(context).successColor,
            onTap: () {
              debugPrint(
                  '⚙️ CategoryActionsBottomSheet: Toggle status action selected for "${category.name}"');
              Navigator.of(context).pop();
              HapticFeedback.selectionClick();
              onToggleStatus?.call(category);
            },
          ),

          SizedBox(height: 16.h),

          // ========== DELETE ACTION WITH THEMEMANAGER ==========
          _buildThemedActionOption(
            context: context,
            title: 'Delete Category',
            subtitle: 'Permanently remove this category',
            icon: Prbal.trash,
            gradient: ThemeManager.of(context).errorGradient,
            iconColor: ThemeManager.of(context).errorColor,
            isDestructive: true,
            onTap: () {
              debugPrint(
                  '⚙️ CategoryActionsBottomSheet: Delete action selected for "${category.name}"');
              Navigator.of(context).pop();
              HapticFeedback.mediumImpact();
              onDelete?.call(category);
            },
          ),

          SizedBox(height: 16.h),

          // Enhanced footer with theme info
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: ThemeManager.of(context).glassMorphism,
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  size: 14.sp,
                  color: ThemeManager.of(context).textTertiary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Actions will be applied immediately',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ThemeManager.of(context).textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual themed action option with comprehensive ThemeManager styling
  Widget _buildThemedActionOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required Color iconColor,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: ThemeManager.of(context).elevatedShadow,
        border: Border.all(
          color: iconColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // ========== ENHANCED ACTION ICON WITH GLASS MORPHISM ==========
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: ThemeManager.of(context).enhancedGlassMorphism,
                  child: Icon(
                    icon,
                    size: 24.sp,
                    color: ThemeManager.of(context).textInverted,
                  ),
                ),

                SizedBox(width: 20.w),

                // ========== ENHANCED ACTION TEXT WITH THEMEMANAGER ==========
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeManager.of(context).textInverted,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: ThemeManager.of(context)
                              .textInverted
                              .withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),

                // ========== ENHANCED ARROW INDICATOR ==========
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context)
                        .textInverted
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Prbal.angleRight,
                    size: 18.sp,
                    color: ThemeManager.of(context).textInverted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
