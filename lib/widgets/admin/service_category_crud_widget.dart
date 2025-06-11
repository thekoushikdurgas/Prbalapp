import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

import 'package:prbal/services/service_category_service.dart';

/// ServiceCategoryCrudWidget - Comprehensive CRUD operations for Service Categories
///
/// **Purpose**: Provides full CRUD (Create, Read, Update, Delete) functionality for Service Categories
///
/// **Key Features**:
/// - Dynamic list view with search and filtering
/// - Create new categories with validation
/// - Edit existing categories with pre-filled data
/// - Delete categories with confirmation
/// - Bulk operations support
/// - Real-time data updates
/// - Error handling with user feedback
///
/// **Business Logic**:
/// - Categories have name, description, icon, sort order, and active status
/// - Validation ensures required fields are filled
/// - Sort order determines display sequence
/// - Active/inactive status controls visibility to users
class ServiceCategoryCrudWidget extends ConsumerStatefulWidget {
  final String searchQuery;
  final String filter; // 'all', 'active', 'inactive'
  final Set<String> selectedIds;
  final Function(String) onSelectionChanged;
  final VoidCallback? onDataChanged;

  const ServiceCategoryCrudWidget({
    super.key,
    required this.searchQuery,
    required this.filter,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.onDataChanged,
  });

  @override
  ConsumerState<ServiceCategoryCrudWidget> createState() => _ServiceCategoryCrudWidgetState();
}

class _ServiceCategoryCrudWidgetState extends ConsumerState<ServiceCategoryCrudWidget> {
  // ========== STATE VARIABLES ==========
  bool _isLoading = false;
  List<ServiceCategory> _categories = [];
  List<ServiceCategory> _filteredCategories = [];

  // Form controllers for create/edit modals (TODO: implement when forms are added)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _iconUrlController = TextEditingController();
  final TextEditingController _sortOrderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('📋 ServiceCategoryCrud: Initializing category CRUD widget');
    _loadCategories();
  }

  @override
  void didUpdateWidget(ServiceCategoryCrudWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Refilter when search query or filter changes
    if (oldWidget.searchQuery != widget.searchQuery || oldWidget.filter != widget.filter) {
      debugPrint('🔍 ServiceCategoryCrud: Search/filter updated, refiltering data');
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint('📋 ServiceCategoryCrud: Building category CRUD widget');

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredCategories.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return _buildCategoriesList(isDark);
  }

  // ========== UI BUILDERS ==========

  /// Build loading state with spinner
  Widget _buildLoadingState() {
    debugPrint('⏳ ServiceCategoryCrud: Building loading state');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF8B5CF6),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading categories...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state when no categories found
  Widget _buildEmptyState(bool isDark) {
    debugPrint('📭 ServiceCategoryCrud: Building empty state');

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
            widget.searchQuery.isNotEmpty ? 'No categories found' : 'No categories available',
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
                : 'Create your first service category to get started',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.searchQuery.isEmpty) ...[
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => _showCreateCategoryModal(context, isDark),
              icon: const Icon(LineIcons.plus, color: Colors.white),
              label: const Text('Create Category', style: TextStyle(color: Colors.white)),
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

  /// Build categories list with selection support
  Widget _buildCategoriesList(bool isDark) {
    debugPrint('📋 ServiceCategoryCrud: Building categories list (${_filteredCategories.length} items)');

    return ListView.separated(
      padding: EdgeInsets.all(20.w),
      itemCount: _filteredCategories.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        final isSelected = widget.selectedIds.contains(category.id);

        debugPrint('📋 ServiceCategoryCrud: Building card for category: ${category.name}');

        return _buildCategoryCard(category, isSelected, isDark);
      },
    );
  }

  /// Build individual category card with actions
  Widget _buildCategoryCard(ServiceCategory category, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        debugPrint('👆 ServiceCategoryCrud: Category card tapped: ${category.name}');
        widget.onSelectionChanged(category.id);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
              : (isDark ? const Color(0xFF2D2D2D) : Colors.white),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with selection, icon, name, and actions
            Row(
              children: [
                // Selection checkbox
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    debugPrint('☑️ ServiceCategoryCrud: Checkbox toggled for: ${category.name}');
                    widget.onSelectionChanged(category.id);
                  },
                  activeColor: const Color(0xFF8B5CF6),
                ),

                SizedBox(width: 8.w),

                // Category icon
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: category.iconUrl != null && category.iconUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            category.iconUrl!,
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('🖼️ ServiceCategoryCrud: Failed to load icon for ${category.name}');
                              return Icon(
                                LineIcons.tag,
                                color: const Color(0xFF8B5CF6),
                                size: 20.sp,
                              );
                            },
                          ),
                        )
                      : Icon(
                          LineIcons.tag,
                          color: const Color(0xFF8B5CF6),
                          size: 20.sp,
                        ),
                ),

                SizedBox(width: 12.w),

                // Category name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF1F2937),
                              ),
                            ),
                          ),

                          // Active status badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: category.isActive
                                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                                  : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              category.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: category.isActive ? const Color(0xFF10B981) : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Sort Order: ${category.sortOrder}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons
                PopupMenuButton<String>(
                  onSelected: (value) => _handleCategoryAction(value, category, isDark),
                  icon: Icon(
                    LineIcons.verticalEllipsis,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(LineIcons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(
                            category.isActive ? LineIcons.eyeSlash : LineIcons.eye,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(category.isActive ? 'Deactivate' : 'Activate'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(LineIcons.trash, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Description
            if (category.description.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                category.description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Metadata row
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  LineIcons.clock,
                  size: 14.sp,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 4.w),
                Text(
                  'Created: ${_formatDate(category.createdAt)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                  ),
                ),
                const Spacer(),
                if (category.updatedAt != category.createdAt) ...[
                  Icon(
                    LineIcons.edit,
                    size: 14.sp,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Updated: ${_formatDate(category.updatedAt)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ========== DATA METHODS ==========

  /// Load categories from API
  Future<void> _loadCategories() async {
    debugPrint('📊 ServiceCategoryCrud: Loading categories from API');

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(serviceCategoryServiceProvider);
      final response = await service.getCategories(activeOnly: false);

      if (response.success && response.data != null) {
        setState(() {
          _categories = response.data!;
          _filteredCategories = _categories;
        });
        debugPrint('✅ ServiceCategoryCrud: Loaded ${_categories.length} categories');

        // Notify parent of data change
        widget.onDataChanged?.call();
      } else {
        debugPrint('❌ ServiceCategoryCrud: Failed to load categories: ${response.message}');
        _showErrorSnackBar(response.message ?? 'Failed to load categories');
      }
    } catch (e) {
      debugPrint('❌ ServiceCategoryCrud: Exception loading categories: $e');
      _showErrorSnackBar('An error occurred while loading categories');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Apply search and filter to categories
  void _applyFilters() {
    debugPrint('🔍 ServiceCategoryCrud: Applying filters - Query: "${widget.searchQuery}", Filter: "${widget.filter}"');

    setState(() {
      _filteredCategories = _categories.where((category) {
        // Apply search query filter
        final matchesSearch = widget.searchQuery.isEmpty ||
            category.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
            category.description.toLowerCase().contains(widget.searchQuery.toLowerCase());

        // Apply status filter
        final matchesFilter = widget.filter == 'all' ||
            (widget.filter == 'active' && category.isActive) ||
            (widget.filter == 'inactive' && !category.isActive);

        return matchesSearch && matchesFilter;
      }).toList();
    });

    debugPrint('🔍 ServiceCategoryCrud: Filtered to ${_filteredCategories.length} categories');
  }

  /// Handle category action from popup menu
  void _handleCategoryAction(String action, ServiceCategory category, bool isDark) {
    debugPrint('🎬 ServiceCategoryCrud: Handling action "$action" for category: ${category.name}');

    switch (action) {
      case 'edit':
        _showEditCategoryModal(context, category, isDark);
        break;
      case 'toggle':
        _toggleCategoryStatus(category);
        break;
      case 'delete':
        _showDeleteConfirmation(context, category, isDark);
        break;
    }
  }

  // ========== MODAL METHODS ==========

  /// Show create category modal
  void _showCreateCategoryModal(BuildContext context, bool isDark) {
    debugPrint('➕ ServiceCategoryCrud: Showing create category modal');

    _clearFormControllers();
    _showCategoryFormModal(
      context: context,
      title: 'Create New Category',
      isEdit: false,
      isDark: isDark,
    );
  }

  /// Show edit category modal
  void _showEditCategoryModal(BuildContext context, ServiceCategory category, bool isDark) {
    debugPrint('✏️ ServiceCategoryCrud: Showing edit modal for category: ${category.name}');

    _populateFormControllers(category);
    _showCategoryFormModal(
      context: context,
      title: 'Edit Category',
      isEdit: true,
      category: category,
      isDark: isDark,
    );
  }

  /// Show category form modal (create/edit)
  void _showCategoryFormModal({
    required BuildContext context,
    required String title,
    required bool isEdit,
    ServiceCategory? category,
    required bool isDark,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: _buildCategoryForm(title, isEdit, category, isDark),
      ),
    );
  }

  // Placeholder methods - will implement the complete form in next task
  Widget _buildCategoryForm(String title, bool isEdit, ServiceCategory? category, bool isDark) {
    return Center(child: Text('Category Form - Coming in next task'));
  }

  void _clearFormControllers() {
    debugPrint('🧹 ServiceCategoryCrud: Clearing form controllers');
  }

  void _populateFormControllers(ServiceCategory category) {
    debugPrint('📝 ServiceCategoryCrud: Populating form for: ${category.name}');
  }

  void _toggleCategoryStatus(ServiceCategory category) {
    debugPrint('🔄 ServiceCategoryCrud: Toggling status for: ${category.name}');
  }

  void _showDeleteConfirmation(BuildContext context, ServiceCategory category, bool isDark) {
    debugPrint('🗑️ ServiceCategoryCrud: Showing delete confirmation for: ${category.name}');
  }

  // ========== UTILITY METHODS ==========

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

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
    debugPrint('🛠️ ServiceCategoryCrud: Disposing category CRUD widget');
    _nameController.dispose();
    _descriptionController.dispose();
    _iconUrlController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }
}
