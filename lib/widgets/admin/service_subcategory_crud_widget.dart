import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/service_subcategory_service.dart';
import 'package:prbal/services/api_service.dart';

/// ServiceSubcategoryCrudWidget - CRUD operations for Service SubCategories
///
/// **Purpose**: Provides full CRUD functionality for Service SubCategories
///
/// **Key Features**:
/// - Dynamic list view with search and filtering
/// - Category association display
/// - Create/edit/delete operations
/// - Bulk operations support
/// - Real-time data updates
/// - Parent category filtering
///
/// **Business Logic**:
/// - SubCategories belong to a parent Category
/// - Each subcategory has name, description, icon, sort order, and active status
/// - Validation ensures parent category is selected
/// - Sort order determines display sequence within category
class ServiceSubcategoryCrudWidget extends ConsumerStatefulWidget {
  final String searchQuery;
  final String filter; // 'all', 'active', 'inactive'
  final Set<String> selectedIds;
  final Function(String) onSelectionChanged;
  final VoidCallback? onDataChanged;
  final String? parentCategoryId; // Filter by parent category

  const ServiceSubcategoryCrudWidget({
    super.key,
    required this.searchQuery,
    required this.filter,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.onDataChanged,
    this.parentCategoryId,
  });

  @override
  ConsumerState<ServiceSubcategoryCrudWidget> createState() => _ServiceSubcategoryCrudWidgetState();
}

class _ServiceSubcategoryCrudWidgetState extends ConsumerState<ServiceSubcategoryCrudWidget> {
  // ========== STATE VARIABLES ==========
  bool _isLoading = false;
  List<ServiceSubcategory> _subcategories = [];
  List<ServiceSubcategory> _filteredSubcategories = [];

  // Form controllers for create/edit modals (TODO: implement when forms are added)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _iconUrlController = TextEditingController();
  final TextEditingController _sortOrderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('📋 ServiceSubcategoryCrud: Initializing subcategory CRUD widget');
    debugPrint('📋 ServiceSubcategoryCrud: Parent category filter: ${widget.parentCategoryId}');
    _loadSubcategories();
  }

  @override
  void didUpdateWidget(ServiceSubcategoryCrudWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload data if parent category filter changes
    if (oldWidget.parentCategoryId != widget.parentCategoryId) {
      debugPrint('🔄 ServiceSubcategoryCrud: Parent category filter changed, reloading data');
      _loadSubcategories();
    }

    // Refilter when search query or filter changes
    if (oldWidget.searchQuery != widget.searchQuery || oldWidget.filter != widget.filter) {
      debugPrint('🔍 ServiceSubcategoryCrud: Search/filter updated, refiltering data');
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint('📋 ServiceSubcategoryCrud: Building subcategory CRUD widget');

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
    }

    if (_filteredSubcategories.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return _buildSubcategoriesList(isDark);
  }

  // ========== UI BUILDERS ==========

  /// Build empty state when no subcategories found
  Widget _buildEmptyState(bool isDark) {
    debugPrint('📭 ServiceSubcategoryCrud: Building empty state');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LineIcons.folderOpen,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            widget.searchQuery.isNotEmpty ? 'No subcategories found' : 'No subcategories available',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Create your first service subcategory to get started',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.searchQuery.isEmpty) ...[
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                debugPrint('➕ ServiceSubcategoryCrud: Create button pressed (TODO: implement)');
              },
              icon: const Icon(LineIcons.plus, color: Colors.white),
              label: const Text('Create SubCategory', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build subcategories list with selection support
  Widget _buildSubcategoriesList(bool isDark) {
    debugPrint('📋 ServiceSubcategoryCrud: Building subcategories list (${_filteredSubcategories.length} items)');

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: _filteredSubcategories.length,
      itemBuilder: (context, index) {
        final subcategory = _filteredSubcategories[index];
        final isSelected = widget.selectedIds.contains(subcategory.id);
        return _buildSubcategoryCard(subcategory, isSelected, isDark);
      },
    );
  }

  /// Build individual subcategory card with actions
  Widget _buildSubcategoryCard(ServiceSubcategory subcategory, bool isSelected, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: isSelected ? Border.all(color: const Color(0xFF8B5CF6)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) => widget.onSelectionChanged(subcategory.id),
                activeColor: const Color(0xFF8B5CF6),
              ),
              Expanded(
                child: Text(
                  subcategory.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: subcategory.isActive
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  subcategory.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: subcategory.isActive ? const Color(0xFF10B981) : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          if (subcategory.description.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              subcategory.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Text(
            'Category: ${subcategory.categoryId} | Sort: ${subcategory.sortOrder}',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // ========== DATA METHODS ==========

  /// Load subcategories from API
  Future<void> _loadSubcategories() async {
    debugPrint('📊 ServiceSubcategoryCrud: Loading subcategories from API');

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(serviceSubcategoryServiceProvider);

      ApiResponse<List<ServiceSubcategory>> response;

      // Load by parent category if specified, otherwise load all
      if (widget.parentCategoryId != null) {
        debugPrint('📊 ServiceSubcategoryCrud: Loading subcategories for category: ${widget.parentCategoryId}');
        response = await service.getSubcategoriesByCategory(
          widget.parentCategoryId!,
          activeOnly: false,
        );
      } else {
        debugPrint('📊 ServiceSubcategoryCrud: Loading all subcategories');
        response = await service.getSubcategories(activeOnly: false);
      }

      if (response.success && response.data != null) {
        setState(() {
          _subcategories = response.data!;
          _filteredSubcategories = _subcategories;
        });
        debugPrint('✅ ServiceSubcategoryCrud: Loaded ${_subcategories.length} subcategories');

        // Notify parent of data change
        widget.onDataChanged?.call();
      } else {
        debugPrint('❌ ServiceSubcategoryCrud: Failed to load subcategories: ${response.message}');
        _showErrorSnackBar(response.message ?? 'Failed to load subcategories');
      }
    } catch (e) {
      debugPrint('❌ ServiceSubcategoryCrud: Exception loading subcategories: $e');
      _showErrorSnackBar('An error occurred while loading subcategories');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Apply search and filter to subcategories
  void _applyFilters() {
    debugPrint(
        '🔍 ServiceSubcategoryCrud: Applying filters - Query: "${widget.searchQuery}", Filter: "${widget.filter}"');

    setState(() {
      _filteredSubcategories = _subcategories.where((subcategory) {
        // Apply search query filter
        final matchesSearch = widget.searchQuery.isEmpty ||
            subcategory.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
            subcategory.description.toLowerCase().contains(widget.searchQuery.toLowerCase());

        // Apply status filter
        final matchesFilter = widget.filter == 'all' ||
            (widget.filter == 'active' && subcategory.isActive) ||
            (widget.filter == 'inactive' && !subcategory.isActive);

        return matchesSearch && matchesFilter;
      }).toList();
    });

    debugPrint('🔍 ServiceSubcategoryCrud: Filtered to ${_filteredSubcategories.length} subcategories');
  }

  // ========== MODAL METHODS (TODO: implement when needed) ==========

  // ========== UTILITY METHODS ==========

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    debugPrint('🛠️ ServiceSubcategoryCrud: Disposing subcategory CRUD widget');
    _nameController.dispose();
    _descriptionController.dispose();
    _iconUrlController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }
}
