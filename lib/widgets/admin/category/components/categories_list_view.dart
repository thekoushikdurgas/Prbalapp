import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/widgets/admin/category/components/category_cards.dart';
import 'package:prbal/widgets/admin/category/components/category_states.dart';

/// CategoriesListView - Extracted component for building categories list
///
/// **Purpose**: Encapsulates the categories list building logic with statistics cards
///
/// **Key Features**:
/// - Statistics cards display with total, active, and inactive counts
/// - Animated categories list with refresh indicator
/// - Individual CategoryCard components for each category
/// - Proper selection and expansion state management
/// - Smooth animations and haptic feedback
class CategoriesListView extends StatelessWidget {
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final List<ServiceCategory> filteredCategories;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Set<String> selectedIds;
  final Set<String> expandedCategories;
  final Future<void> Function() onRefresh;
  final Function(String) onSelectionChanged;
  final Function(ServiceCategory) onEdit;
  final Function(ServiceCategory) onDelete;
  final Function(ServiceCategory) onToggleStatus;
  final Function(String) onToggleExpand;

  const CategoriesListView({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.filteredCategories,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.selectedIds,
    required this.expandedCategories,
    required this.onRefresh,
    required this.onSelectionChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('📋 CategoriesListView: Building with ${filteredCategories.length} CategoryCard components');

    return Column(
      children: [
        // ========== OPTIONAL STATISTICS CARDS ==========
        if (totalCount > 0) ...[
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CategoryStatisticCards(
              totalCount: totalCount,
              activeCount: activeCount,
              inactiveCount: inactiveCount,
            ),
          ),
        ],

        // ========== ENHANCED CATEGORIES LIST WITH EXTRACTED COMPONENTS ==========
        Expanded(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: RefreshIndicator(
                onRefresh: onRefresh,
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    final isSelected = selectedIds.contains(category.id);

                    debugPrint(
                        '🎴 CategoriesListView: Building CategoryCard for "${category.name}" (index: $index, selected: $isSelected)');

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutCubic,
                      child: CategoryCard(
                        category: category,
                        isSelected: isSelected,
                        index: index,
                        onTap: () {
                          debugPrint('🎯 CategoriesListView: CategoryCard tapped for "${category.name}"');
                          HapticFeedback.lightImpact();
                          onSelectionChanged(category.id);
                        },
                        onLongPress: () {
                          debugPrint('🎯 CategoriesListView: CategoryCard long pressed for "${category.name}"');
                          HapticFeedback.mediumImpact();
                          onSelectionChanged(category.id);
                        },
                        onEdit: onEdit,
                        onDelete: onDelete,
                        onToggleStatus: onToggleStatus,
                        expandedCategories: expandedCategories,
                        onToggleExpand: onToggleExpand,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
