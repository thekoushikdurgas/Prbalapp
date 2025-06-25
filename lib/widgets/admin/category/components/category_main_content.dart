import 'package:flutter/material.dart';
// import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/widgets/admin/category/components/category_states.dart';

/// CategoryMainContent - Extracted main content component for category management
///
/// **Purpose**: Centralized main content area that handles different UI states
///
/// **Key Features**:
/// - Handles loading, error, empty, and content states
/// - Delegates to appropriate state components
/// - Clean separation between state management and UI rendering
/// - Reusable across different category management screens
///
/// **States Handled**:
/// - Loading state (when initially loading categories)
/// - Error state (when API calls fail)
/// - Empty state (when no categories exist)
/// - Content state (displays categories list)
///
/// **Usage**:
/// ```dart
/// CategoryMainContent(
///   isLoading: _isLoading,
///   isInitialLoad: _isInitialLoad,
///   errorMessage: _errorMessage,
///   hasCategories: _filteredCategories.isNotEmpty,
///   onRetry: _loadCategories,
///   onCreateCategory: _showCreateCategoryModal,
///   categoriesListBuilder: () => _buildCategoriesListWithExtractedCards(),
/// )
/// ```
class CategoryMainContent extends StatelessWidget {
  final bool isLoading;
  final bool isInitialLoad;
  final String? errorMessage;
  final bool hasCategories;
  final VoidCallback onRetry;
  final VoidCallback onCreateCategory;
  final Widget Function() categoriesListBuilder;

  const CategoryMainContent({
    super.key,
    required this.isLoading,
    required this.isInitialLoad,
    required this.errorMessage,
    required this.hasCategories,
    required this.onRetry,
    required this.onCreateCategory,
    required this.categoriesListBuilder,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '📱 CategoryMainContent: Building main content with EXTRACTED COMPONENTS');
    debugPrint(
        '📱 CategoryMainContent: Loading: $isLoading, Error: ${errorMessage != null}, HasCategories: $hasCategories');

    // ========== LOADING STATE COMPONENT ==========
    if (isLoading && isInitialLoad) {
      debugPrint(
          '⏳ CategoryMainContent: Showing CategoryLoadingState component');
      return const CategoryLoadingState();
    }

    // ========== ERROR STATE COMPONENT ==========
    if (errorMessage != null) {
      debugPrint(
          '❌ CategoryMainContent: Showing CategoryErrorState component with message: $errorMessage');
      return CategoryErrorState(
        errorMessage: errorMessage!,
        onRetry: onRetry,
      );
    }

    // ========== EMPTY STATE COMPONENT ==========
    if (!hasCategories) {
      debugPrint(
          '📭 CategoryMainContent: Showing CategoryEmptyState component');
      return CategoryEmptyState(
        onCreateCategory: onCreateCategory,
      );
    }

    // ========== CATEGORIES LIST WITH EXTRACTED CARD COMPONENTS ==========
    debugPrint(
        '📋 CategoryMainContent: Showing categories list with CategoryCard components');
    return categoriesListBuilder();
  }
}
