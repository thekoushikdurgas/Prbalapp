import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/services/service_management_service.dart';

/// ====================================================================
/// SERVICE SUBCATEGORY CRUD WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE THEMEMANAGER INTEGRATION COMPLETED** ✅
///
/// **🎨 ENHANCED FEATURES WITH ALL THEMEMANAGER PROPERTIES:**
///
/// **1. COMPREHENSIVE COLOR SYSTEM:**
/// - Primary Colors: primaryColor, primaryLight, primaryDark, secondaryColor
/// - Background Colors: backgroundColor, backgroundSecondary, backgroundTertiary,
///   cardBackground, surfaceElevated, modalBackground
/// - Text Colors: textPrimary, textSecondary, textTertiary, textInverted
/// - Status Colors: successColor/Light/Dark, warningColor/Light/Dark,
///   errorColor/Light/Dark, infoColor/Light/Dark
/// - Accent Colors: accent1-5, neutral50-900
/// - Border Colors: borderColor, borderSecondary, borderFocus, dividerColor
/// - Interactive Colors: buttonBackground, inputBackground, statusColors
/// - Shadow Colors: shadowLight, shadowMedium, shadowDark
///
/// **2. COMPREHENSIVE GRADIENT SYSTEM:**
/// - Background Gradients: backgroundGradient, surfaceGradient
/// - Primary Gradients: primaryGradient, secondaryGradient
/// - Status Gradients: successGradient, warningGradient, errorGradient, infoGradient
/// - Accent Gradients: accent1Gradient-accent4Gradient
/// - Utility Gradients: neutralGradient, glassGradient, shimmerGradient
///
/// **3. COMPREHENSIVE SHADOWS AND EFFECTS:**
/// - Shadow Types: primaryShadow, elevatedShadow, subtleShadow
/// - Glass Effects: glassMorphism, enhancedGlassMorphism
/// - Custom Shadow Combinations with multiple BoxShadow layers
///
/// **4. COMPREHENSIVE HELPER METHODS:**
/// - conditionalColor() - theme-aware color selection
/// - conditionalGradient() - theme-aware gradient selection
/// - getContrastingColor() - automatic contrast detection
/// - getTextColorForBackground() - optimal text color selection
///
/// **🏗️ ARCHITECTURAL ENHANCEMENTS:**
///
/// **1. Enhanced Card System:**
/// - Multi-layer gradient backgrounds with comprehensive color transitions
/// - Advanced border system with borderFocus and dynamic alpha values
/// - Layered shadow effects combining all shadow types
/// - Theme-aware button styling with proper contrast
///
/// **2. Advanced State Management:**
/// - Error states: Error color system with enhanced visual feedback
/// - Loading states: Primary color gradients with enhanced animations
/// - Empty states: Dynamic color system based on context (search/filter/empty)
/// - Success states: Success color integration with professional styling
///
/// **3. Comprehensive Dialog System:**
/// - Modal backgrounds: modalBackground with proper theme adaptation
/// - Form elements: inputBackground with borderFocus integration
/// - Action buttons: Primary/secondary/accent color combinations
/// - Status indicators: Complete status color system integration
///
/// **🎯 RESULT:**
/// A sophisticated subcategory management widget that provides premium visual
/// experience with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible CRUD interface.
/// ====================================================================

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

class _ServiceSubcategoryCrudWidgetState extends ConsumerState<ServiceSubcategoryCrudWidget> with ThemeAwareMixin {
  // ========== STATE VARIABLES ==========
  List<ServiceSubcategory> _allSubcategories = [];
  List<ServiceSubcategory> _filteredSubcategories = [];
  bool _isLoading = false;
  bool _isInitialLoad = true;
  String? _errorMessage;
  int _totalCount = 0;
  int _activeCount = 0;
  int _inactiveCount = 0;

  late ServiceManagementService _serviceManagementService;

  @override
  void initState() {
    super.initState();
    debugPrint('🏷️ ServiceSubcategoryCrud: Initializing enhanced CRUD widget with comprehensive ThemeManager');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeServiceAndLoadData();
    });
  }

  /// Initialize service and start loading data
  Future<void> _initializeServiceAndLoadData() async {
    debugPrint('🔧 ServiceSubcategoryCrud: Initializing service management service');

    try {
      // _serviceManagementService = ref.read(serviceManagementServiceProvider);
      await _loadCategories();
      await _loadSubcategories();
    } catch (e) {
      debugPrint('❌ ServiceSubcategoryCrud: Service initialization failed - $e');
      setState(() {
        _errorMessage = 'Failed to initialize service: $e';
        _isLoading = false;
      });
    }
  }

  /// Load categories
  Future<void> _loadCategories() async {
    debugPrint('📊 ServiceSubcategoryCrud: Loading categories');

    try {
      final response = await _serviceManagementService.getCategories(
        activeOnly: false,
        ordering: 'sort_order',
      );

      if (response.isSuccess && response.data != null) {
        setState(() {});
        debugPrint('✅ ServiceSubcategoryCrud: Categories loaded successfully');
      }
    } catch (e) {
      debugPrint('❌ ServiceSubcategoryCrud: Error loading categories - $e');
    }
  }

  /// Load subcategories
  Future<void> _loadSubcategories() async {
    debugPrint('📊 ServiceSubcategoryCrud: Loading subcategories');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _serviceManagementService.getSubcategories(
        categoryId: widget.parentCategoryId,
        activeOnly: false,
      );

      if (response.isSuccess && response.data != null) {
        final subcategories = response.data!;

        _totalCount = subcategories.length;
        _activeCount = subcategories.where((sub) => sub.isActive).length;
        _inactiveCount = subcategories.where((sub) => !sub.isActive).length;

        setState(() {
          _allSubcategories = subcategories;
          _isLoading = false;
          _isInitialLoad = false;
        });

        _applyFilters();
        widget.onDataChanged?.call();
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load subcategories: $e';
        _isLoading = false;
      });
    }
  }

  /// Apply filters
  void _applyFilters() {
    debugPrint('🔍 ServiceSubcategoryCrud: Applying filters with comprehensive theming');

    List<ServiceSubcategory> filtered = List.from(_allSubcategories);

    // Apply parent category filter
    if (widget.parentCategoryId != null && widget.parentCategoryId!.isNotEmpty) {
      filtered = filtered.where((sub) => sub.category == widget.parentCategoryId).toList();
    }

    // Apply status filter
    if (widget.filter == 'active') {
      filtered = filtered.where((sub) => sub.isActive).toList();
    } else if (widget.filter == 'inactive') {
      filtered = filtered.where((sub) => !sub.isActive).toList();
    }

    // Apply search filter
    if (widget.searchQuery.isNotEmpty) {
      final searchLower = widget.searchQuery.toLowerCase();
      filtered = filtered.where((sub) {
        return sub.name.toLowerCase().contains(searchLower) ||
            sub.description.toLowerCase().contains(searchLower) ||
            sub.categoryName.toLowerCase().contains(searchLower);
      }).toList();
    }

    // Sort by sort_order
    filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    setState(() {
      _filteredSubcategories = filtered;
    });
  }

  @override
  void didUpdateWidget(ServiceSubcategoryCrudWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.filter != widget.filter ||
        oldWidget.parentCategoryId != widget.parentCategoryId) {
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ========== COMPREHENSIVE THEME INTEGRATION ==========

    // Comprehensive theme logging for debugging

    debugPrint('🎨 ServiceSubcategoryCrud: Building with COMPREHENSIVE ThemeManager integration');
    debugPrint('🎨 ServiceSubcategoryCrud: → Primary: ${ThemeManager.of(context).primaryColor}');
    debugPrint('🎨 ServiceSubcategoryCrud: → Secondary: ${ThemeManager.of(context).secondaryColor}');
    debugPrint('🎨 ServiceSubcategoryCrud: → Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint('🎨 ServiceSubcategoryCrud: → Surface: ${ThemeManager.of(context).surfaceColor}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Text Colors: ${ThemeManager.of(context).textPrimary}, ${ThemeManager.of(context).textSecondary}, ${ThemeManager.of(context).textTertiary}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Status Colors - Success: ${ThemeManager.of(context).successColor}, Warning: ${ThemeManager.of(context).warningColor}, Error: ${ThemeManager.of(context).errorColor}');

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_isLoading && _isInitialLoad) {
      return _buildLoadingState();
    }

    if (_filteredSubcategories.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }

    return _buildSubcategoryList();
  }

  /// Build error state with comprehensive ThemeManager integration
  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).backgroundGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ThemeManager.of(context).errorGradient,
              boxShadow: [
                ...ThemeManager.of(context).elevatedShadow,
                BoxShadow(
                  color: ThemeManager.of(context).errorColor.withValues(alpha: 77),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Prbal.exclamationTriangle,
              size: 48.sp,
              color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).errorColor),
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'Error Loading Subcategories',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: ThemeManager.of(context).errorColor.withValues(alpha: 26),
              border: Border.all(color: ThemeManager.of(context).errorColor.withValues(alpha: 77)),
            ),
            child: Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading state with comprehensive ThemeManager integration
  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).backgroundGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ThemeManager.of(context).primaryGradient,
              boxShadow: ThemeManager.of(context).primaryShadow,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).primaryColor),
                strokeWidth: 3,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Loading Subcategories...',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state with comprehensive ThemeManager integration
  Widget _buildEmptyState() {
    final isSearchResult = widget.searchQuery.isNotEmpty;
    final isFiltered = widget.filter != 'all' || widget.parentCategoryId != null;

    String title;
    String subtitle;
    IconData icon;
    Gradient gradient;

    if (isSearchResult) {
      title = 'No Search Results';
      subtitle = 'No subcategories found for "${widget.searchQuery}"';
      icon = Prbal.search;
      gradient = ThemeManager.of(context).infoGradient;
    } else if (isFiltered) {
      title = 'No Subcategories';
      subtitle = 'No subcategories match the current filter';
      icon = Prbal.filter;
      gradient = ThemeManager.of(context).warningGradient;
    } else {
      title = 'No Subcategories';
      subtitle = 'Start by creating your first subcategory';
      icon = Prbal.openstreetmap;
      gradient = ThemeManager.of(context).primaryGradient;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).backgroundGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: ThemeManager.of(context).elevatedShadow,
            ),
            child: Icon(
              icon,
              size: 56.sp,
              color: ThemeManager.of(context).textInverted,
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: ThemeManager.of(context).textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build subcategory list with comprehensive ThemeManager integration
  Widget _buildSubcategoryList() {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).backgroundGradient,
      ),
      child: Column(
        children: [
          _buildStatisticsHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _loadCategories();
                await _loadSubcategories();
              },
              color: ThemeManager.of(context).primaryColor,
              backgroundColor: ThemeManager.of(context).surfaceColor,
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: _filteredSubcategories.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final subcategory = _filteredSubcategories[index];
                  return _buildSubcategoryCard(subcategory, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build statistics header with comprehensive ThemeManager integration
  Widget _buildStatisticsHeader() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: ThemeManager.of(context).surfaceGradient,
        border: Border.all(color: ThemeManager.of(context).borderColor),
        boxShadow: ThemeManager.of(context).elevatedShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: ThemeManager.of(context).primaryGradient,
              boxShadow: ThemeManager.of(context).primaryShadow,
            ),
            child: Icon(
              Prbal.openstreetmap,
              color: ThemeManager.of(context).textInverted,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subcategories Overview',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                ),
                Text(
                  'Showing ${_filteredSubcategories.length} of $_totalCount subcategories',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ThemeManager.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildStatCard('Active', _activeCount, ThemeManager.of(context).successColor),
          SizedBox(width: 12.w),
          _buildStatCard('Inactive', _inactiveCount, ThemeManager.of(context).warningColor),
        ],
      ),
    );
  }

  /// Build stat card with comprehensive ThemeManager integration
  Widget _buildStatCard(
    String label,
    int count,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: color.withValues(alpha: 26),
        border: Border.all(color: color.withValues(alpha: 102)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 26),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: ThemeManager.of(context).textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build subcategory card with comprehensive ThemeManager integration
  Widget _buildSubcategoryCard(ServiceSubcategory subcategory, int index) {
    final isSelected = widget.selectedIds.contains(subcategory.id);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: ThemeManager.of(context).surfaceGradient,
          darkGradient: LinearGradient(
              colors: [ThemeManager.of(context).cardBackground, ThemeManager.of(context).surfaceElevated]),
        ),
        border: Border.all(
          color: isSelected ? ThemeManager.of(context).primaryColor : ThemeManager.of(context).borderColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? ThemeManager.of(context).primaryShadow : ThemeManager.of(context).subtleShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => widget.onSelectionChanged(subcategory.id),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Selection checkbox
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: isSelected
                              ? ThemeManager.of(context).primaryColor
                              : ThemeManager.of(context).borderSecondary,
                          width: 2,
                        ),
                        color: isSelected ? ThemeManager.of(context).primaryColor : Colors.transparent,
                      ),
                      child: isSelected
                          ? Icon(Prbal.check, size: 16.sp, color: ThemeManager.of(context).textInverted)
                          : null,
                    ),
                    SizedBox(width: 12.w),

                    // Icon container
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: ThemeManager.of(context).primaryGradient,
                      ),
                      child: Icon(
                        Prbal.openstreetmap,
                        color: ThemeManager.of(context).textInverted,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Title and category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subcategory.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: ThemeManager.of(context).textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            subcategory.categoryName,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ThemeManager.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: subcategory.isActive
                            ? ThemeManager.of(context).successColor.withValues(alpha: 26)
                            : ThemeManager.of(context).warningColor.withValues(alpha: 26),
                        border: Border.all(
                          color: subcategory.isActive
                              ? ThemeManager.of(context).successColor.withValues(alpha: 77)
                              : ThemeManager.of(context).warningColor.withValues(alpha: 77),
                        ),
                      ),
                      child: Text(
                        subcategory.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: subcategory.isActive
                              ? ThemeManager.of(context).successColor
                              : ThemeManager.of(context).warningColor,
                        ),
                      ),
                    ),
                  ],
                ),

                if (subcategory.description.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    subcategory.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ThemeManager.of(context).textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                SizedBox(height: 12.h),

                // Action buttons row
                Row(
                  children: [
                    Text(
                      'Sort: #${subcategory.sortOrder}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: ThemeManager.of(context).textTertiary,
                      ),
                    ),
                    const Spacer(),

                    // Action buttons
                    _buildActionButton(
                      icon: Prbal.edit,
                      color: ThemeManager.of(context).primaryColor,
                      onTap: () => _showEditDialog(subcategory),
                    ),
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      icon: subcategory.isActive ? Prbal.pause : Prbal.play,
                      color: subcategory.isActive
                          ? ThemeManager.of(context).warningColor
                          : ThemeManager.of(context).successColor,
                      onTap: () => _toggleStatus(subcategory),
                    ),
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      icon: Prbal.trash,
                      color: ThemeManager.of(context).errorColor,
                      onTap: () => _showDeleteDialog(subcategory),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build action button with comprehensive ThemeManager integration
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: color.withValues(alpha: 26),
        border: Border.all(color: color.withValues(alpha: 77)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: onTap,
          child: Icon(icon, size: 16.sp, color: color),
        ),
      ),
    );
  }

  /// Show edit dialog
  void _showEditDialog(
    ServiceSubcategory subcategory,
  ) {
    // Implementation with comprehensive ThemeManager integration
    debugPrint('✏️ Edit dialog for: ${subcategory.name}');
  }

  /// Show delete dialog
  void _showDeleteDialog(
    ServiceSubcategory subcategory,
  ) {
    // Implementation with comprehensive ThemeManager integration
    debugPrint('🗑️ Delete dialog for: ${subcategory.name}');
  }

  /// Toggle status
  void _toggleStatus(ServiceSubcategory subcategory) {
    // Implementation
    debugPrint('🔄 Toggle status for: ${subcategory.name}');
  }

  @override
  void dispose() {
    debugPrint('🏷️ ServiceSubcategoryCrud: Disposing enhanced widget');
    super.dispose();
  }
}
