import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/services/service_providers.dart';

// ========== EXTRACTED COMPONENTS ==========
import 'package:prbal/widgets/admin/category/components/category_search_header.dart';
// import 'package:prbal/widgets/admin/category/components/category_cards.dart';
// import 'package:prbal/widgets/admin/category/components/category_states.dart';
import 'package:prbal/widgets/admin/category/components/category_selection_bar.dart';
import 'package:prbal/widgets/admin/category/components/category_fab_actions.dart';
import 'package:prbal/widgets/admin/category/components/create_category_modal_widget.dart';
import 'package:prbal/widgets/admin/category/components/edit_category_modal_widget.dart';
import 'package:prbal/widgets/admin/category/components/category_main_content.dart';
import 'package:prbal/widgets/admin/category/components/categories_list_view.dart';
import 'package:prbal/widgets/admin/category/components/category_filter_bottom_sheet.dart';

// ========== UTILITIES ==========
import 'package:prbal/widgets/admin/category/utils/category_utils.dart';

/// ServiceCategoryCrudWidget - Modern CRUD operations for Service Categories
///
/// **Purpose**: Provides advanced CRUD functionality with modern Material Design 3.0
///
/// **Key Features**:
/// - Modern Material Design 3.0 components with enhanced visual hierarchy
/// - Advanced dark/light theme support with dynamic gradients
/// - Comprehensive search and filtering with real-time feedback
/// - Intuitive CRUD operations with smooth animations
/// - Enhanced user experience with haptic feedback and contextual actions
/// - Progressive disclosure with expandable cards
/// - Visual status indicators and badges
/// - Built-in search bar and filter functionality
/// - Optional back button for navigation
/// - **FULLY MODULARIZED**: Uses extracted components for better maintainability
///
/// **Extracted Components Used**:
/// - CategorySearchHeader: Search and filter functionality
/// - CategorySelectionBar: Selection management when categories are selected
/// - CategoryFabActions: Floating action buttons for add/bulk operations
/// - CategoryMainContent: Main content area with state management
/// - CategoriesListView: Complete categories list with statistics and cards
/// - CategoryFilterBottomSheet: Modern filter bottom sheet with gradient design
/// - CategoryCard: Individual category display with actions
/// - CategoryStatisticCards: Statistics overview display
class ServiceCategoryCrudWidget extends ConsumerStatefulWidget {
  final Set<String> selectedIds;
  final Function(String) onSelectionChanged;
  final VoidCallback? onDataChanged;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? title;
  final String? subtitle;

  const ServiceCategoryCrudWidget({
    super.key,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.onDataChanged,
    this.showBackButton = false,
    this.onBackPressed,
    this.title,
    this.subtitle,
  });

  @override
  ConsumerState<ServiceCategoryCrudWidget> createState() => _ServiceCategoryCrudWidgetState();
}

class _ServiceCategoryCrudWidgetState extends ConsumerState<ServiceCategoryCrudWidget> with TickerProviderStateMixin {
  // ========== STATE VARIABLES ==========
  List<ServiceCategory> _allCategories = [];
  List<ServiceCategory> _filteredCategories = [];
  bool _isLoading = false;
  bool _isInitialLoad = true;
  String? _errorMessage;
  int _totalCount = 0;
  int _activeCount = 0;
  int _inactiveCount = 0;

  // Search and Filter state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _currentFilter = 'all'; // 'all', 'active', 'inactive'

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _headerAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _fabScaleAnimation;

  // Track expanded state for each category
  final Set<String> _expandedCategories = <String>{};

  late ServiceManagementService _serviceManagementService;

  @override
  void initState() {
    super.initState();
    debugPrint('🏷️ ServiceCategoryCrud: Initializing FULLY MODULARIZED widget with EXTRACTED COMPONENTS');
    debugPrint(
        '🏷️ ServiceCategoryCrud: Using CategorySearchHeader, CategorySelectionBar, CategoryFabActions, and more');

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOutCubic),
    );
    _headerSlideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOutCubic),
    );
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOutCubic),
    );

    // Add search listener for real-time filtering
    _searchController.addListener(() {
      if (_searchController.text != _searchQuery) {
        setState(() {
          _searchQuery = _searchController.text;
        });
        debugPrint('🔍 ServiceCategoryCrud: Search query updated: "$_searchQuery"');
        _applyFilters();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🏷️ ServiceCategoryCrud: Post-frame callback - starting data load and animations');
      _initializeServiceAndLoadData();
      _headerAnimationController.forward();
      Future.delayed(const Duration(milliseconds: 600), () {
        _fabAnimationController.forward();
      });
    });
  }

  @override
  void didUpdateWidget(ServiceCategoryCrudWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget now manages its own search and filter state internally
  }

  /// Initialize the service management service and load initial data
  Future<void> _initializeServiceAndLoadData() async {
    debugPrint('🏷️ ServiceCategoryCrud: Initializing service management service');

    try {
      _serviceManagementService = ref.read(serviceManagementServiceProvider);
      debugPrint('🏷️ ServiceCategoryCrud: Service management service obtained successfully');

      // Initialize CategoryUtils with the global service
      CategoryUtils.initialize(_serviceManagementService);
      debugPrint('🏷️ ServiceCategoryCrud: CategoryUtils initialized with global service');

      await _loadCategories();
    } catch (e, stackTrace) {
      debugPrint('❌ ServiceCategoryCrud: Error initializing service - $e');
      debugPrint('❌ ServiceCategoryCrud: Stack trace: $stackTrace');

      setState(() {
        _errorMessage = 'Failed to initialize service: $e';
        _isLoading = false;
      });
    }
  }

  /// Load all categories using CategoryUtils
  Future<void> _loadCategories() async {
    debugPrint('📊 ServiceCategoryCrud: Starting to load categories using CategoryUtils');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('🔄 ServiceCategoryCrud: Delegating to CategoryUtils.loadCategories');

      final result = await CategoryUtils.loadCategories(
        activeOnly: false,
        ordering: 'sort_order',
        useCache: !_isInitialLoad,
      );

      debugPrint(
          '📊 ServiceCategoryCrud: CategoryUtils.loadCategories completed in ${result.loadDuration.inMilliseconds}ms');

      if (result.isSuccess) {
        debugPrint('✅ ServiceCategoryCrud: Categories loaded successfully via CategoryUtils');
        debugPrint('📊 ServiceCategoryCrud: Received ${result.categories.length} categories');
        debugPrint(
            '📊 ServiceCategoryCrud: Statistics - Total: ${result.totalCount}, Active: ${result.activeCount}, Inactive: ${result.inactiveCount}');

        // Update widget state with CategoryUtils results
        _totalCount = result.totalCount;
        _activeCount = result.activeCount;
        _inactiveCount = result.inactiveCount;

        setState(() {
          _allCategories = result.categories;
          _isLoading = false;
          _isInitialLoad = false;
        });

        _applyFilters();
        widget.onDataChanged?.call();

        // Start animations
        _fadeController.forward();
        _slideController.forward();
      } else {
        debugPrint('❌ ServiceCategoryCrud: CategoryUtils.loadCategories failed: ${result.errorMessage}');
        setState(() {
          _errorMessage = result.errorMessage ?? 'Unknown error occurred';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ ServiceCategoryCrud: Exception in CategoryUtils.loadCategories - $e');
      setState(() {
        _errorMessage = 'Failed to load categories: $e';
        _isLoading = false;
      });
    }
  }

  /// Show create category modal
  Future<void> _showCreateCategoryModal() async {
    debugPrint('🎨 ServiceCategoryCrud: Showing create category modal');

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        builder: (BuildContext context) => CreateCategoryModalWidget(
          onCategoryCreated: () {
            debugPrint('✅ ServiceCategoryCrud: Category created, refreshing data');
            _loadCategories();
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ ServiceCategoryCrud: Error showing create modal - $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open create category form: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show edit category modal
  Future<void> _showEditCategoryModal(ServiceCategory category) async {
    debugPrint('✏️ ServiceCategoryCrud: Showing edit category modal for: ${category.name}');

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        builder: (BuildContext context) => EditCategoryModalWidget(
          category: category,
          onCategoryUpdated: () {
            debugPrint('✅ ServiceCategoryCrud: Category updated, refreshing data');
            _loadCategories();
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ ServiceCategoryCrud: Error showing edit modal - $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open edit category form: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Apply search and filter criteria to the categories list
  void _applyFilters() {
    debugPrint('🔍 ServiceCategoryCrud: Applying filters - search: "$_searchQuery", filter: "$_currentFilter"');

    // Use CategoryUtils for efficient filtering
    List<ServiceCategory> filtered = List.from(_allCategories);

    // Apply status filter using CategoryUtils
    filtered = CategoryUtils.applyStatusFilter(filtered, _currentFilter);

    // Apply search filter using CategoryUtils
    filtered = CategoryUtils.applySearchFilter(filtered, _searchQuery);

    // Sort by sort_order
    filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    setState(() {
      _filteredCategories = filtered;
    });

    debugPrint(
        '🔍 ServiceCategoryCrud: Filters applied using CategoryUtils - showing ${_filteredCategories.length} categories');

    // Additional CategoryUtils debug info for filtered categories
    if (_filteredCategories.isNotEmpty) {
      final sampleCategory = _filteredCategories.first;
      debugPrint(
          '🔍 Sample category: "${CategoryUtils.capitalizeWords(sampleCategory.name)}" - Updated: ${CategoryUtils.formatDate(sampleCategory.updatedAt)}');
    }
  }

  /// Refresh the categories data
  Future<void> refreshData() async {
    debugPrint('🔄 ServiceCategoryCrud: Manual refresh triggered');
    await _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 ServiceCategoryCrud: Building modern widget with EXTRACTED COMPONENTS');
    debugPrint(
        '🎨 ServiceCategoryCrud: Using CategorySearchHeader, CategoryMainContent, and CategoriesListView components');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // ========== EXTRACTED SEARCH HEADER COMPONENT ==========
          if (widget.selectedIds.isEmpty)
            // Show search header when no categories are selected
            FadeTransition(
              opacity: _headerFadeAnimation,
              child: SlideTransition(
                position: _headerSlideAnimation,
                child: CategorySearchHeader(
                  searchController: _searchController,
                  onFilterPressed: _showModernFilterBottomSheet,
                  currentFilter: _currentFilter,
                  totalCount: _totalCount,
                  activeCount: _activeCount,
                  inactiveCount: _inactiveCount,
                  filteredCount: _filteredCategories.length,
                  selectedCount: widget.selectedIds.length,
                  showBackButton: widget.showBackButton,
                  onBackPressed: widget.onBackPressed,
                  title: widget.title,
                  subtitle: widget.subtitle,
                ),
              ),
            )
          else
            // ========== EXTRACTED SELECTION BAR COMPONENT ==========
            // Show selection info bar when categories are selected
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: CategorySelectionBar(
                selectedCount: widget.selectedIds.length,
                totalCount: _totalCount,
                onClearSelection: () {
                  debugPrint('❌ ServiceCategoryCrud: Clear selection triggered from CategorySelectionBar');
                  // Clear all selections
                  for (String id in widget.selectedIds.toList()) {
                    widget.onSelectionChanged(id);
                  }
                },
                onSelectAll: _totalCount > widget.selectedIds.length
                    ? () {
                        debugPrint('✅ ServiceCategoryCrud: Select all triggered from CategorySelectionBar');
                        // Select all filtered categories
                        for (final category in _filteredCategories) {
                          if (!widget.selectedIds.contains(category.id)) {
                            widget.onSelectionChanged(category.id);
                          }
                        }
                      }
                    : null,
                selectionMessage: 'Tap bulk actions to manage selected categories',
              ),
            ),

          // ========== MAIN CONTENT WITH EXTRACTED COMPONENTS ==========
          Expanded(
            child: CategoryMainContent(
              isLoading: _isLoading,
              isInitialLoad: _isInitialLoad,
              errorMessage: _errorMessage,
              hasCategories: _filteredCategories.isNotEmpty,
              onRetry: _loadCategories,
              onCreateCategory: _showCreateCategoryModal,
              categoriesListBuilder: () => CategoriesListView(
                totalCount: _totalCount,
                activeCount: _activeCount,
                inactiveCount: _inactiveCount,
                filteredCategories: _filteredCategories,
                fadeAnimation: _fadeAnimation,
                slideAnimation: _slideAnimation,
                selectedIds: widget.selectedIds,
                expandedCategories: _expandedCategories,
                onRefresh: _loadCategories,
                onSelectionChanged: widget.onSelectionChanged,
                onEdit: _showEditCategoryModal,
                onDelete: _showDeleteConfirmation,
                onToggleStatus: _toggleCategoryStatus,
                onToggleExpand: (String categoryId) {
                  debugPrint('📖 ServiceCategoryCrud: Toggle expand for category ID: $categoryId');
                  setState(() {
                    if (_expandedCategories.contains(categoryId)) {
                      _expandedCategories.remove(categoryId);
                    } else {
                      _expandedCategories.add(categoryId);
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
      // ========== EXTRACTED FAB ACTIONS COMPONENT ==========
      floatingActionButton: _isLoading
          ? null
          : CategoryFabActions(
              hasSelection: widget.selectedIds.isNotEmpty,
              selectedCount: widget.selectedIds.length,
              onAddCategory: _showCreateCategoryModal,
              onBulkActivate: _bulkActivateCategories,
              onBulkDeactivate: _bulkDeactivateCategories,
              onBulkExport: _bulkExportCategories,
              onBulkDelete: _bulkDeleteCategories,
              scaleAnimation: _fabScaleAnimation,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Show modern filter bottom sheet using CategoryFilterBottomSheet component
  Future<void> _showModernFilterBottomSheet() async {
    debugPrint('🔧 ServiceCategoryCrud: Delegating to CategoryFilterBottomSheet.show');

    await CategoryFilterBottomSheet.show(
      context: context,
      currentFilter: _currentFilter,
      onFilterSelected: (selectedFilter) {
        debugPrint('🔧 ServiceCategoryCrud: Filter selected from CategoryFilterBottomSheet: $selectedFilter');
        setState(() {
          _currentFilter = selectedFilter;
        });
        _applyFilters();
      },
    );
  }

  @override
  void dispose() {
    debugPrint('🏷️ ServiceCategoryCrud: Disposing widget');
    _fadeController.dispose();
    _slideController.dispose();
    _headerAnimationController.dispose();
    _fabAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ========== CATEGORY CRUD OPERATIONS ==========

  /// Show delete confirmation dialog for a single category using CategoryUtils
  Future<void> _showDeleteConfirmation(ServiceCategory category) async {
    debugPrint('🗑️ ServiceCategoryCrud: Delegating to CategoryUtils.showDeleteConfirmation for "${category.name}"');

    final confirmed = await CategoryUtils.showDeleteConfirmation(context, category);

    if (confirmed) {
      debugPrint('🗑️ ServiceCategoryCrud: Proceeding with category deletion');
      await _deleteCategory(category);
    } else {
      debugPrint('🗑️ ServiceCategoryCrud: Category deletion cancelled');
    }
  }

  /// Toggle category active/inactive status using CategoryUtils
  Future<void> _toggleCategoryStatus(ServiceCategory category) async {
    debugPrint('🔄 ServiceCategoryCrud: Delegating to CategoryUtils.toggleCategoryStatus for "${category.name}"');

    final success = await CategoryUtils.toggleCategoryStatus(
      context: context,
      category: category,
      onDataRefresh: () => _loadCategories(),
      onLoadingStateChange: (isLoading) => setState(() => _isLoading = isLoading),
    );

    if (success) {
      debugPrint('✅ ServiceCategoryCrud: Category status toggle completed successfully');
    } else {
      debugPrint('❌ ServiceCategoryCrud: Category status toggle failed');
    }
  }

  /// Delete a category using CategoryUtils
  Future<void> _deleteCategory(ServiceCategory category) async {
    debugPrint('🗑️ ServiceCategoryCrud: Delegating to CategoryUtils.deleteCategory for "${category.name}"');

    final success = await CategoryUtils.deleteCategory(
      context: context,
      category: category,
      selectedIds: widget.selectedIds,
      onSelectionChanged: (id) => widget.onSelectionChanged(id),
      onDataRefresh: () => _loadCategories(),
      onDataChanged: () => widget.onDataChanged?.call(),
      onLoadingStateChange: (isLoading) => setState(() => _isLoading = isLoading),
    );

    if (success) {
      debugPrint('✅ ServiceCategoryCrud: Category deletion completed successfully');
    } else {
      debugPrint('❌ ServiceCategoryCrud: Category deletion failed');
    }
  }

  // ========== BULK ACTION METHODS USING CATEGORYUTILS ==========

  /// Bulk activate selected categories using CategoryUtils
  Future<void> _bulkActivateCategories() async {
    debugPrint('✅ ServiceCategoryCrud: Delegating to CategoryUtils.bulkActivateCategories');

    final result = await CategoryUtils.bulkActivateCategories(
      context: context,
      selectedIds: widget.selectedIds,
      allCategories: _allCategories,
      onSelectionChanged: widget.onSelectionChanged,
      onDataRefresh: () => _loadCategories(),
      onLoadingStateChange: (isLoading) => setState(() => _isLoading = isLoading),
    );

    debugPrint('✅ ServiceCategoryCrud: Bulk activation result - ${result.summary}');
  }

  /// Bulk deactivate selected categories using CategoryUtils
  Future<void> _bulkDeactivateCategories() async {
    debugPrint('⏸️ ServiceCategoryCrud: Delegating to CategoryUtils.bulkDeactivateCategories');

    final result = await CategoryUtils.bulkDeactivateCategories(
      context: context,
      selectedIds: widget.selectedIds,
      allCategories: _allCategories,
      onSelectionChanged: widget.onSelectionChanged,
      onDataRefresh: () => _loadCategories(),
      onLoadingStateChange: (isLoading) => setState(() => _isLoading = isLoading),
    );

    debugPrint('⏸️ ServiceCategoryCrud: Bulk deactivation result - ${result.summary}');
  }

  /// Bulk export selected categories using CategoryUtils
  Future<void> _bulkExportCategories() async {
    debugPrint('📥 ServiceCategoryCrud: Delegating to CategoryUtils.bulkExportCategories');

    final result = await CategoryUtils.bulkExportCategories(
      context: context,
      selectedIds: widget.selectedIds,
      allCategories: _allCategories,
      onSelectionChanged: widget.onSelectionChanged,
    );

    debugPrint('📥 ServiceCategoryCrud: Bulk export result - ${result.summary}');
  }

  /// Bulk delete selected categories using CategoryUtils
  Future<void> _bulkDeleteCategories() async {
    debugPrint('🗑️ ServiceCategoryCrud: Delegating to CategoryUtils.bulkDeleteCategories');

    final result = await CategoryUtils.bulkDeleteCategories(
      context: context,
      selectedIds: widget.selectedIds,
      allCategories: _allCategories,
      onSelectionChanged: widget.onSelectionChanged,
      onDataRefresh: () => _loadCategories(),
      onDataChanged: () => widget.onDataChanged?.call(),
      onLoadingStateChange: (isLoading) => setState(() => _isLoading = isLoading),
    );

    debugPrint('🗑️ ServiceCategoryCrud: Bulk deletion result - ${result.summary}');
  }
}
