import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/widgets/admin/category/category_cards.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// CategoriesListView - Extracted component for building categories list
///
/// **Purpose**: Encapsulates the categories list building logic with statistics cards
///
/// **Key Features**:
/// - Complete ThemeManager integration with all color properties
/// - Advanced gradient theming with background, surface, and accent gradients
/// - Theme-aware shadows (primary, elevated, subtle) and glass morphism effects
/// - Statistics cards display with total, active, and inactive counts
/// - Animated categories list with refresh indicator using theme-aware colors
/// - Individual CategoryCard components for each category
/// - Proper selection state management with theme-aware styling
/// - Smooth animations and haptic feedback with theme-consistent colors
/// - Comprehensive debug logging for theme operations
class CategoriesListView extends StatelessWidget {
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final List<ServiceCategory> filteredCategories;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Set<String> selectedIds;
  final Future<void> Function() onRefresh;
  final Function(String) onSelectionChanged;
  final Function(ServiceCategory) onEdit;
  final Function(ServiceCategory) onDelete;
  final Function(ServiceCategory) onToggleStatus;

  const CategoriesListView({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.filteredCategories,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.selectedIds,
    required this.onRefresh,
    required this.onSelectionChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    // Comprehensive debug logging for theme operations
    debugPrint(
        '📋 CategoriesListView: Building with ${filteredCategories.length} CategoryCard components');
    themeManager.logThemeInfo();
    debugPrint(
        '🎨 CategoriesListView: Using theme colors - Primary: ${themeManager.primaryColor}, Surface: ${themeManager.surfaceColor}');
    debugPrint(
        '🌈 CategoriesListView: Active gradients - Background: ${themeManager.backgroundGradient.colors.length} colors, Surface: ${themeManager.surfaceGradient.colors.length} colors');

    return Container(
      // Enhanced background with theme-aware gradient
      decoration: BoxDecoration(
        gradient: themeManager.backgroundGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // ========== OPTIONAL STATISTICS CARDS WITH THEMEMANAGER ==========
          if (totalCount > 0) ...[
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: themeManager.surfaceGradient,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: themeManager.borderColor,
                  width: 1.5,
                ),
                boxShadow: themeManager.elevatedShadow,
              ),
              child: _buildStatisticsSection(themeManager),
            ),
          ],

          // ========== ENHANCED CATEGORIES LIST WITH FULL THEMEMANAGER INTEGRATION ==========
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: themeManager.surfaceGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: themeManager.primaryShadow,
              ),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: RefreshIndicator(
                    onRefresh: onRefresh,
                    color: themeManager.primaryColor,
                    backgroundColor: themeManager.surfaceColor,
                    strokeWidth: 3.0,
                    displacement: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: themeManager.backgroundGradient,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: filteredCategories.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          final isSelected = selectedIds.contains(category.id);

                          debugPrint(
                              '🎴 CategoriesListView: Building CategoryCard for "${category.name}" (index: $index, selected: $isSelected)');

                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            child: AnimatedContainer(
                              duration:
                                  Duration(milliseconds: 300 + (index * 50)),
                              curve: Curves.easeOutCubic,
                              decoration: _buildItemDecoration(
                                  themeManager, isSelected, index),
                              child: CategoryCard(
                                category: category,
                                isSelected: isSelected,
                                index: index,
                                isInSelectionMode: selectedIds.isNotEmpty,
                                onTap: () {
                                  debugPrint(
                                      '🎯 CategoriesListView: CategoryCard tapped for "${category.name}" (selection mode: ${selectedIds.isNotEmpty})');
                                  // Enhanced haptic feedback with theme awareness
                                  if (selectedIds.isNotEmpty) {
                                    HapticFeedback.selectionClick();
                                    onSelectionChanged(category.id);
                                  }
                                },
                                onLongPress: () {
                                  debugPrint(
                                      '🎯 CategoriesListView: CategoryCard long pressed for "${category.name}" - toggling selection');
                                  HapticFeedback.mediumImpact();
                                  onSelectionChanged(category.id);
                                },
                                onEdit: onEdit,
                                onDelete: onDelete,
                                onToggleStatus: onToggleStatus,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds comprehensive statistics section with all ThemeManager features
  Widget _buildStatisticsSection(ThemeManager themeManager) {
    debugPrint(
        '📊 CategoriesListView: Building statistics section with ThemeManager integration');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Statistics header with theme-aware styling
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: themeManager.primaryGradient,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.subtleShadow,
          ),
          child: Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: themeManager.textInverted,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Category Statistics',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textInverted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Statistics cards row with comprehensive theming
        Row(
          children: [
            // Total categories card
            Expanded(
              child: _buildStatCard(
                themeManager,
                title: 'Total',
                count: totalCount,
                gradient: themeManager.infoGradient,
                iconColor: themeManager.infoColor,
                icon: Icons.category_rounded,
              ),
            ),

            SizedBox(width: 12.w),

            // Active categories card
            Expanded(
              child: _buildStatCard(
                themeManager,
                title: 'Active',
                count: activeCount,
                gradient: themeManager.successGradient,
                iconColor: themeManager.successColor,
                icon: Icons.check_circle_rounded,
              ),
            ),

            SizedBox(width: 12.w),

            // Inactive categories card
            Expanded(
              child: _buildStatCard(
                themeManager,
                title: 'Inactive',
                count: inactiveCount,
                gradient: themeManager.warningGradient,
                iconColor: themeManager.warningColor,
                icon: Icons.pause_circle_rounded,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Additional metadata with theme styling
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: themeManager.surfaceElevated,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: themeManager.borderColor),
            boxShadow: themeManager.subtleShadow,
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_rounded,
                color: themeManager.textTertiary,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Total management efficiency: ${totalCount > 0 ? ((activeCount / totalCount) * 100).toStringAsFixed(1) : '0.0'}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: themeManager.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds individual statistic card with comprehensive ThemeManager styling
  Widget _buildStatCard(
    ThemeManager themeManager, {
    required String title,
    required int count,
    required LinearGradient gradient,
    required Color iconColor,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.elevatedShadow,
        border: Border.all(
          color: themeManager.borderColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon container with glass morphism
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: themeManager.glassMorphism,
            child: Icon(
              icon,
              color: themeManager.textInverted,
              size: 24.sp,
            ),
          ),

          SizedBox(height: 8.h),

          // Count with enhanced typography
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: themeManager.textInverted,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: 4.h),

          // Title with theme-aware styling
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: themeManager.textInverted.withValues(alpha: 0.9),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds enhanced item decoration with comprehensive theming
  BoxDecoration _buildItemDecoration(
      ThemeManager themeManager, bool isSelected, int index) {
    if (isSelected) {
      // Selected state with primary gradient and enhanced effects
      return BoxDecoration(
        gradient: themeManager.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.elevatedShadow,
        border: Border.all(
          color: themeManager.primaryColor,
          width: 2,
        ),
      );
    } else {
      // Normal state with surface gradient and subtle effects
      return BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      );
    }
  }
}
