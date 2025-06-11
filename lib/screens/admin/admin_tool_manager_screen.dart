import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

// import 'package:prbal/services/service_category_service.dart';
// import 'package:prbal/services/service_subcategory_service.dart';
import 'package:prbal/widgets/admin/service_category_crud_widget.dart';
import 'package:prbal/widgets/admin/service_subcategory_crud_widget.dart';

/// AdminToolManagerScreen - Comprehensive tool management screen for admin users
///
/// **Purpose**: Provides CRUD operations for:
/// - Service Categories: Create, Read, Update, Delete service categories
/// - Service SubCategories: Create, Read, Update, Delete service subcategories
///
/// **Key Features**:
/// - Tab-based interface for Categories and SubCategories
/// - Real-time search and filtering
/// - Modal forms for creating/editing entries
/// - Bulk operations support
/// - Statistics dashboard
/// - Export functionality
///
/// **Memory Safety**: Uses content-only version to prevent circular dependency
/// with BottomNavigation widget, avoiding memory leaks and out-of-memory errors.
class AdminToolManagerScreen extends ConsumerStatefulWidget {
  const AdminToolManagerScreen({super.key});

  @override
  ConsumerState<AdminToolManagerScreen> createState() => _AdminToolManagerScreenState();
}

class _AdminToolManagerScreenState extends ConsumerState<AdminToolManagerScreen> with TickerProviderStateMixin {
  // ========== STATE VARIABLES ==========
  late TabController _tabController; // Controls Categories/SubCategories tabs
  final TextEditingController _searchController = TextEditingController(); // Search input

  // Loading states for better UX
  bool _isLoadingCategories = false;
  bool _isLoadingSubcategories = false;

  // Selected items for bulk operations
  final Set<String> _selectedCategoryIds = <String>{};
  final Set<String> _selectedSubcategoryIds = <String>{};

  // Filter states
  String _categoryFilter = 'all'; // 'all', 'active', 'inactive'
  String _subcategoryFilter = 'all'; // 'all', 'active', 'inactive'
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    debugPrint('🛠️ AdminToolManager: Initializing tool manager screen');

    // Initialize tab controller with 2 tabs (Categories, SubCategories)
    _tabController = TabController(length: 2, vsync: this);
    debugPrint('🛠️ AdminToolManager: Tab controller initialized with 2 tabs');

    // Add listener to track tab changes for debugging and data loading
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        debugPrint('🛠️ AdminToolManager: Tab changed to index ${_tabController.index}');
        final tabNames = ['Categories', 'SubCategories'];
        debugPrint('🛠️ AdminToolManager: Now viewing ${tabNames[_tabController.index]} tab');

        // Load appropriate data when switching tabs
        _loadDataForCurrentTab();
      }
    });

    // Add search listener for real-time filtering
    _searchController.addListener(() {
      if (_searchController.text != _searchQuery) {
        setState(() {
          _searchQuery = _searchController.text;
        });
        debugPrint('🛠️ AdminToolManager: Search query updated: "$_searchQuery"');
        _performSearch();
      }
    });

    // Initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🛠️ AdminToolManager: Widget build complete, loading initial data');
      _loadDataForCurrentTab();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🛠️ AdminToolManager: Building tool manager UI');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint('🛠️ AdminToolManager: Theme mode: ${isDark ? 'dark' : 'light'}');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),

      // ========== APP BAR SECTION ==========
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button for navigation tab
        title: Row(
          children: [
            Icon(
              LineIcons.tools,
              color: const Color(0xFF8B5CF6), // Purple admin color
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Tool Manager',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        actions: [
          // Statistics button
          IconButton(
            onPressed: () {
              debugPrint('📊 AdminToolManager: Statistics button pressed');
              _showStatisticsModal(context, isDark);
            },
            icon: Icon(
              LineIcons.calculator,
              color: isDark ? Colors.white70 : const Color(0xFF6B7280),
            ),
          ),

          // Export button
          IconButton(
            onPressed: () {
              debugPrint('📤 AdminToolManager: Export button pressed');
              _showExportModal(context, isDark);
            },
            icon: Icon(
              LineIcons.download,
              color: isDark ? Colors.white70 : const Color(0xFF6B7280),
            ),
          ),

          // Bulk actions button (only show when items selected)
          if (_selectedCategoryIds.isNotEmpty || _selectedSubcategoryIds.isNotEmpty)
            IconButton(
              onPressed: () {
                debugPrint('🔧 AdminToolManager: Bulk actions button pressed');
                _showBulkActionsModal(context, isDark);
              },
              icon: Icon(
                LineIcons.cogs,
                color: const Color(0xFF8B5CF6),
              ),
            ),

          SizedBox(width: 8.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120.h),
          child: Column(
            children: [
              // Tab selector
              _buildTabSelector(isDark),
              SizedBox(height: 8.h),

              // Search and filter row
              _buildSearchAndFilterRow(isDark),
            ],
          ),
        ),
      ),

      // ========== MAIN CONTENT SECTION ==========
      body: TabBarView(
        controller: _tabController,
        children: [
          // Categories Tab
          _buildCategoriesTab(isDark),

          // SubCategories Tab
          _buildSubcategoriesTab(isDark),
        ],
      ),

      // ========== FLOATING ACTION BUTTON ==========
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('➕ AdminToolManager: Add new button pressed');
          final currentTab = _tabController.index;
          if (currentTab == 0) {
            debugPrint('➕ AdminToolManager: Adding new category');
            _showCreateCategoryModal(context, isDark);
          } else {
            debugPrint('➕ AdminToolManager: Adding new subcategory');
            _showCreateSubcategoryModal(context, isDark);
          }
        },
        backgroundColor: const Color(0xFF8B5CF6),
        icon: const Icon(LineIcons.plus, color: Colors.white),
        label: Text(
          _tabController.index == 0 ? 'Add Category' : 'Add SubCategory',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ========== TAB SELECTOR BUILDER ==========
  Widget _buildTabSelector(bool isDark) {
    debugPrint('🛠️ AdminToolManager: Building tab selector');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF8B5CF6), // Purple indicator for selected tab
          borderRadius: BorderRadius.circular(10.r),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[600],
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        onTap: (index) {
          debugPrint('🛠️ AdminToolManager: Tab tapped: index $index');
          final tabNames = ['Categories', 'SubCategories'];
          debugPrint('🛠️ AdminToolManager: Switched to ${tabNames[index]} tab');

          // Clear selections when switching tabs
          _clearSelections();
        },
        tabs: const [
          Tab(text: 'Categories'), // Service Categories management
          Tab(text: 'SubCategories'), // Service SubCategories management
        ],
      ),
    );
  }

  // ========== SEARCH AND FILTER ROW BUILDER ==========
  Widget _buildSearchAndFilterRow(bool isDark) {
    debugPrint('🛠️ AdminToolManager: Building search and filter row');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // Search field
          Expanded(
            flex: 3,
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: _tabController.index == 0 ? 'Search categories...' : 'Search subcategories...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : const Color(0xFF9CA3AF),
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    LineIcons.search,
                    color: isDark ? Colors.grey[500] : const Color(0xFF9CA3AF),
                    size: 18.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
                onChanged: (value) {
                  debugPrint('🔍 AdminToolManager: Search input changed: "$value"');
                },
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Filter dropdown
          Expanded(
            flex: 2,
            child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _tabController.index == 0 ? _categoryFilter : _subcategoryFilter,
                  icon: Icon(
                    LineIcons.chevronDown,
                    color: isDark ? Colors.grey[500] : const Color(0xFF9CA3AF),
                    size: 16.sp,
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                    fontSize: 14.sp,
                  ),
                  dropdownColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        if (_tabController.index == 0) {
                          _categoryFilter = newValue;
                        } else {
                          _subcategoryFilter = newValue;
                        }
                      });
                      debugPrint('🔽 AdminToolManager: Filter changed to: $newValue');
                      _applyFilter();
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== CATEGORIES TAB BUILDER ==========
  Widget _buildCategoriesTab(bool isDark) {
    debugPrint('🛠️ AdminToolManager: Building categories tab');

    return RefreshIndicator(
      onRefresh: () async {
        debugPrint('🔄 AdminToolManager: Refreshing categories data');
        await _loadCategories();
      },
      child: _isLoadingCategories ? _buildLoadingState() : _buildCategoriesList(isDark),
    );
  }

  // ========== SUBCATEGORIES TAB BUILDER ==========
  Widget _buildSubcategoriesTab(bool isDark) {
    debugPrint('🛠️ AdminToolManager: Building subcategories tab');

    return RefreshIndicator(
      onRefresh: () async {
        debugPrint('🔄 AdminToolManager: Refreshing subcategories data');
        await _loadSubcategories();
      },
      child: _isLoadingSubcategories ? _buildLoadingState() : _buildSubcategoriesList(isDark),
    );
  }

  // ========== LOADING STATE BUILDER ==========
  Widget _buildLoadingState() {
    debugPrint('⏳ AdminToolManager: Building loading state');

    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF8B5CF6),
      ),
    );
  }

  /// Build categories list using ServiceCategoryCrudWidget
  Widget _buildCategoriesList(bool isDark) {
    debugPrint('📋 AdminToolManager: Building categories list');

    return ServiceCategoryCrudWidget(
      searchQuery: _searchQuery,
      filter: _categoryFilter,
      selectedIds: _selectedCategoryIds,
      onSelectionChanged: (categoryId) {
        debugPrint('☑️ AdminToolManager: Category selection changed: $categoryId');
        setState(() {
          if (_selectedCategoryIds.contains(categoryId)) {
            _selectedCategoryIds.remove(categoryId);
            debugPrint('☑️ AdminToolManager: Deselected category: $categoryId');
          } else {
            _selectedCategoryIds.add(categoryId);
            debugPrint('☑️ AdminToolManager: Selected category: $categoryId');
          }
        });
      },
      onDataChanged: () {
        debugPrint('🔄 AdminToolManager: Categories data changed, refreshing UI');
        // Refresh any dependent data or UI components
        setState(() {});
      },
    );
  }

  /// Build subcategories list using ServiceSubcategoryCrudWidget
  Widget _buildSubcategoriesList(bool isDark) {
    debugPrint('📋 AdminToolManager: Building subcategories list');

    return ServiceSubcategoryCrudWidget(
      searchQuery: _searchQuery,
      filter: _subcategoryFilter,
      selectedIds: _selectedSubcategoryIds,
      onSelectionChanged: (subcategoryId) {
        debugPrint('☑️ AdminToolManager: Subcategory selection changed: $subcategoryId');
        setState(() {
          if (_selectedSubcategoryIds.contains(subcategoryId)) {
            _selectedSubcategoryIds.remove(subcategoryId);
            debugPrint('☑️ AdminToolManager: Deselected subcategory: $subcategoryId');
          } else {
            _selectedSubcategoryIds.add(subcategoryId);
            debugPrint('☑️ AdminToolManager: Selected subcategory: $subcategoryId');
          }
        });
      },
      onDataChanged: () {
        debugPrint('🔄 AdminToolManager: Subcategories data changed, refreshing UI');
        // Refresh any dependent data or UI components
        setState(() {});
      },
    );
  }

  // ========== DATA LOADING METHODS ==========

  /// Load data based on current active tab
  void _loadDataForCurrentTab() {
    debugPrint('📊 AdminToolManager: Loading data for current tab: ${_tabController.index}');

    if (_tabController.index == 0) {
      _loadCategories();
    } else {
      _loadSubcategories();
    }
  }

  /// Load service categories from API
  Future<void> _loadCategories() async {
    debugPrint('📊 AdminToolManager: Starting to load categories');

    setState(() {
      _isLoadingCategories = true;
    });

    try {
      // TODO: Implement actual API call using ServiceCategoryService
      await Future.delayed(const Duration(seconds: 1)); // Simulated loading
      debugPrint('✅ AdminToolManager: Categories loaded successfully');
    } catch (e) {
      debugPrint('❌ AdminToolManager: Failed to load categories: $e');
    } finally {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  /// Load service subcategories from API
  Future<void> _loadSubcategories() async {
    debugPrint('📊 AdminToolManager: Starting to load subcategories');

    setState(() {
      _isLoadingSubcategories = true;
    });

    try {
      // TODO: Implement actual API call using ServiceSubcategoryService
      await Future.delayed(const Duration(seconds: 1)); // Simulated loading
      debugPrint('✅ AdminToolManager: Subcategories loaded successfully');
    } catch (e) {
      debugPrint('❌ AdminToolManager: Failed to load subcategories: $e');
    } finally {
      setState(() {
        _isLoadingSubcategories = false;
      });
    }
  }

  // ========== SEARCH AND FILTER METHODS ==========

  /// Perform real-time search based on query
  void _performSearch() {
    debugPrint('🔍 AdminToolManager: Performing search with query: "$_searchQuery"');
    // TODO: Implement search logic
  }

  /// Apply selected filter to current tab data
  void _applyFilter() {
    final currentFilter = _tabController.index == 0 ? _categoryFilter : _subcategoryFilter;
    debugPrint('🔽 AdminToolManager: Applying filter: $currentFilter');
    // TODO: Implement filter logic
  }

  /// Clear all selections when switching tabs
  void _clearSelections() {
    debugPrint('🗑️ AdminToolManager: Clearing all selections');
    setState(() {
      _selectedCategoryIds.clear();
      _selectedSubcategoryIds.clear();
    });
  }

  // ========== MODAL METHODS (PLACEHOLDERS) ==========

  void _showStatisticsModal(BuildContext context, bool isDark) {
    debugPrint('📊 AdminToolManager: Showing statistics modal');
    // TODO: Implement statistics modal
  }

  void _showExportModal(BuildContext context, bool isDark) {
    debugPrint('📤 AdminToolManager: Showing export modal');
    // TODO: Implement export modal
  }

  void _showBulkActionsModal(BuildContext context, bool isDark) {
    debugPrint('🔧 AdminToolManager: Showing bulk actions modal');
    // TODO: Implement bulk actions modal
  }

  void _showCreateCategoryModal(BuildContext context, bool isDark) {
    debugPrint('➕ AdminToolManager: Showing create category modal');
    // TODO: Implement create category modal
  }

  void _showCreateSubcategoryModal(BuildContext context, bool isDark) {
    debugPrint('➕ AdminToolManager: Showing create subcategory modal');
    // TODO: Implement create subcategory modal
  }

  @override
  void dispose() {
    debugPrint('🛠️ AdminToolManager: Disposing tool manager screen');
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
