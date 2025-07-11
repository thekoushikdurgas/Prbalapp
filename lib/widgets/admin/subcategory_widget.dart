import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/models/business/service_models.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/services/service_management_service.dart';

/// ServiceSubcategoryCrudWidget - CRUD operations for Service SubCategories
///
/// **ENHANCED VERSION - Major Improvements Made:**
///
/// 🔍 **SEARCH LOGIC ENHANCEMENTS:**
/// - Empty searchQuery now shows ALL subcategories of selected categories (as requested)
/// - Non-empty searchQuery filters subcategories by name AND description
/// - Case-insensitive search with comprehensive debug logging
/// - Clear visual feedback for search results vs no-data states
/// - Respects parent category filtering during search
///
/// 📊 **DATA LOADING IMPROVEMENTS:**
/// - Enhanced _loadSubcategories() method with smart category filtering
/// - Loads ALL subcategories when no parentCategoryId specified
/// - Loads only relevant subcategories when parentCategoryId specified
/// - Better state management with _allSubcategories and _filteredSubcategories separation
/// - Comprehensive error handling with user-friendly messages
/// - Detailed breakdown logging (active/inactive counts, category distribution)
///
/// 🎯 **FILTERING LOGIC ENHANCEMENTS:**
/// - Enhanced _applyFilters() with step-by-step debug logging
/// - Triple filtering: search query + category relationship + status
/// - Proper handling of 'all', 'active', 'inactive' filter states
/// - Clear separation of search vs category vs status filtering logic
/// - Detailed result logging for troubleshooting
///
/// 🏷️ **CATEGORY RELATIONSHIP IMPROVEMENTS:**
/// - Smart category filtering at data loading level for performance
/// - Proper parent-child relationship management
/// - Category context preservation during search/filter operations
/// - Enhanced dropdown loading for category selection
/// - Better validation for category assignments
///
/// 🎨 **UI/UX IMPROVEMENTS:**
/// - Context-aware empty states (search vs category vs no-data)
/// - Search result indicators with counts and category context
/// - Better loading states with category-specific messages
/// - Enhanced information display with category relationships
/// - Improved visual hierarchy and information architecture
///
/// 🔧 **DEBUG LOGGING ENHANCEMENTS:**
/// - Comprehensive lifecycle logging (init, update, build, dispose)
/// - Step-by-step filter application logging with category context
/// - API request/response logging with category breakdowns
/// - Error handling with stack traces
/// - Performance monitoring logs
/// - Category distribution logging for debugging
///
/// **Purpose**: Provides full CRUD functionality for Service SubCategories
///
/// **Key Features**:
/// - Dynamic list view with search and filtering
/// - Category association display and management
/// - Create/edit/delete operations with comprehensive validation
/// - Bulk operations support
/// - Real-time data updates with parent category filtering
/// - Parent category relationship management
/// - Enhanced search functionality - shows all subcategories when search is empty
/// - Better debug logging for troubleshooting
///
/// **Business Logic**:
/// - SubCategories belong to a parent Category (required relationship)
/// - Each subcategory has name, description, icon, sort order, and active status
/// - Validation ensures parent category is selected and exists
/// - Sort order determines display sequence within category
/// - Empty search query displays ALL subcategories (filtered by parent category if specified)
/// - Search is case-insensitive and searches both name and description
///
/// **Category Relationship Logic**:
/// - parentCategoryId filter -> Show only subcategories of that specific category
/// - No parentCategoryId filter -> Show ALL subcategories from all categories
/// - Search respects the category filter (searches within the filtered set)
///
/// **Search Logic**:
/// - Empty searchQuery + No parentCategoryId -> Show ALL subcategories
/// - Empty searchQuery + parentCategoryId -> Show ALL subcategories of that category
/// - Non-empty searchQuery + No parentCategoryId -> Search in ALL subcategories
/// - Non-empty searchQuery + parentCategoryId -> Search in subcategories of that category
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
  ConsumerState<ServiceSubcategoryCrudWidget> createState() =>
      _ServiceSubcategoryCrudWidgetState();
}

class _ServiceSubcategoryCrudWidgetState
    extends ConsumerState<ServiceSubcategoryCrudWidget> with ThemeAwareMixin {
  // ========== STATE VARIABLES ==========
  List<ServiceSubcategory> _allSubcategories = []; // Complete list from API
  List<ServiceSubcategory> _filteredSubcategories =
      []; // Filtered list for display
  List<ServiceCategory> _allCategories =
      []; // Categories for dropdown/filtering
  bool _isLoading = false; // Loading state for API calls
  bool _isInitialLoad = true; // Track if this is the first load
  String? _errorMessage; // Store error messages for user display
  int _totalCount = 0; // Total subcategories count for statistics
  int _activeCount = 0; // Active subcategories count
  int _inactiveCount = 0; // Inactive subcategories count

  // Category distribution tracking
  final Map<String, int> _categoryDistribution =
      {}; // Category ID -> Count mapping

  // Performance tracking
  // DateTime? _lastLoadTime;
  // Duration _lastLoadDuration = Duration.zero;

  // Service reference
  late ServiceManagementService _serviceManagementService;

  @override
  void initState() {
    super.initState();
    debugPrint('🏷️ ServiceSubcategoryCrud: Initializing CRUD widget');
    debugPrint(
        '🏷️ ServiceSubcategoryCrud: Initial search query: "${widget.searchQuery}"');
    debugPrint(
        '🏷️ ServiceSubcategoryCrud: Initial filter: "${widget.filter}"');
    debugPrint(
        '🏷️ ServiceSubcategoryCrud: Parent category filter: "${widget.parentCategoryId}"');
    debugPrint(
        '🏷️ ServiceSubcategoryCrud: Selected IDs count: ${widget.selectedIds.length}');

    // Initialize service and load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          '🏷️ ServiceSubcategoryCrud: Post-frame callback - starting data load');
      _initializeServiceAndLoadData();
    });
  }

  @override
  void didUpdateWidget(ServiceSubcategoryCrudWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    debugPrint('🏷️ ServiceSubcategoryCrud: Widget updated');
    debugPrint(
        '🏷️ ServiceSubcategoryCrud: Search query changed: "${oldWidget.searchQuery}" -> "${widget.searchQuery}"');
    debugPrint(
        '🏷️ ServiceSubcategoryCrud: Filter changed: "${oldWidget.filter}" -> "${widget.filter}"');
    debugPrint(
        '🏷️ ServiceSubcategoryCrud: Parent category changed: "${oldWidget.parentCategoryId}" -> "${widget.parentCategoryId}"');

    // Check if we need to apply new filters
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.filter != widget.filter ||
        oldWidget.parentCategoryId != widget.parentCategoryId) {
      debugPrint(
          '🏷️ ServiceSubcategoryCrud: Filter parameters changed, reapplying filters');
      _applyFilters();
    }
  }

  /// Initialize service and start loading data
  Future<void> _initializeServiceAndLoadData() async {
    debugPrint(
        '🔧 ServiceSubcategoryCrud: Initializing service management service');

    try {
      // Get service management service from provider
      // _serviceManagementService = ref.read(serviceManagementServiceProvider);
      debugPrint(
          '🔧 ServiceSubcategoryCrud: Service management service initialized');

      // Load categories first, then subcategories
      await _loadCategories();
      await _loadSubcategories();
    } catch (e, stackTrace) {
      debugPrint(
          '❌ ServiceSubcategoryCrud: Service initialization failed - $e');
      debugPrint('❌ ServiceSubcategoryCrud: Stack trace: $stackTrace');

      setState(() {
        _errorMessage = 'Failed to initialize service: $e';
        _isLoading = false;
      });
    }
  }

  // ========== DATA LOADING METHODS ==========

  /// Load all categories from the API for dropdown/filtering
  Future<void> _loadCategories() async {
    debugPrint('📊 ServiceSubcategoryCrud: Starting to load categories');
    final startTime = DateTime.now();

    try {
      debugPrint('🔄 ServiceSubcategoryCrud: Calling getCategories API');

      final response = await _serviceManagementService.getCategories(
        activeOnly: false, // Load both active and inactive categories
        ordering: 'sort_order', // Order by sort_order for proper display
      );

      final duration = DateTime.now().difference(startTime);
      debugPrint(
          '📊 ServiceSubcategoryCrud: Categories API call completed in ${duration.inMilliseconds}ms');
      debugPrint(
          '📊 ServiceSubcategoryCrud: Categories response success: ${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        final categories = response.data!;
        debugPrint(
            '📊 ServiceSubcategoryCrud: Received ${categories.length} categories');

        setState(() {
          _allCategories = categories;
        });

        // Log each category for debugging
        for (int i = 0; i < categories.length; i++) {
          final cat = categories[i];
          debugPrint(
              '📊 ServiceSubcategoryCrud: Category [$i] ${cat.name} (ID: ${cat.id})');
        }

        debugPrint('✅ ServiceSubcategoryCrud: Categories loaded successfully');
      } else {
        final errorMsg = response.message;
        debugPrint('❌ ServiceSubcategoryCrud: Categories API error: $errorMsg');
        // Categories loading failure is not critical, subcategories can still be loaded
      }
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime);
      debugPrint(
          '❌ ServiceSubcategoryCrud: Exception loading categories (${duration.inMilliseconds}ms) - $e');
      debugPrint(
          '❌ ServiceSubcategoryCrud: Categories stack trace: $stackTrace');
      // Continue with subcategories loading even if categories fail
    }
  }

  /// Load all subcategories from the API
  Future<void> _loadSubcategories() async {
    debugPrint('📊 ServiceSubcategoryCrud: Starting to load subcategories');
    final startTime = DateTime.now();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('🔄 ServiceSubcategoryCrud: Calling getSubcategories API');
      debugPrint(
          '🔄 ServiceSubcategoryCrud: Parent category filter: ${widget.parentCategoryId}');

      // Call the service to get subcategories
      final response = await _serviceManagementService.getSubcategories(
        categoryId:
            widget.parentCategoryId, // Filter by parent category if provided
        activeOnly: false, // Load both active and inactive subcategories
      );

      final duration = DateTime.now().difference(startTime);
      // _lastLoadTime = DateTime.now();
      // _lastLoadDuration = duration;

      debugPrint(
          '📊 ServiceSubcategoryCrud: Subcategories API call completed in ${duration.inMilliseconds}ms');
      debugPrint(
          '📊 ServiceSubcategoryCrud: Subcategories response success: ${response.isSuccess}');
      debugPrint(
          '📊 ServiceSubcategoryCrud: Subcategories response message: ${response.message}');

      if (response.isSuccess && response.data != null) {
        final subcategories = response.data!;
        debugPrint(
            '📊 ServiceSubcategoryCrud: Received ${subcategories.length} subcategories');

        // Calculate statistics
        _totalCount = subcategories.length;
        _activeCount = subcategories.where((sub) => sub.isActive).length;
        _inactiveCount = subcategories.where((sub) => !sub.isActive).length;

        // Calculate category distribution
        _categoryDistribution.clear();
        for (final sub in subcategories) {
          _categoryDistribution[sub.category] =
              (_categoryDistribution[sub.category] ?? 0) + 1;
        }

        debugPrint('📊 ServiceSubcategoryCrud: Subcategories breakdown:');
        debugPrint('📊 ServiceSubcategoryCrud: - Total: $_totalCount');
        debugPrint('📊 ServiceSubcategoryCrud: - Active: $_activeCount');
        debugPrint('📊 ServiceSubcategoryCrud: - Inactive: $_inactiveCount');
        debugPrint(
            '📊 ServiceSubcategoryCrud: - Category distribution: $_categoryDistribution');

        // Log each subcategory for debugging
        for (int i = 0; i < subcategories.length; i++) {
          final sub = subcategories[i];
          debugPrint(
              '📊 ServiceSubcategoryCrud: [$i] ${sub.name} (${sub.isActive ? "Active" : "Inactive"}) - Category: ${sub.categoryName} - Sort: ${sub.sortOrder}');
        }

        setState(() {
          _allSubcategories = subcategories;
          _isLoading = false;
          _isInitialLoad = false;
        });

        // Apply current filters to the loaded data
        _applyFilters();

        // Notify parent of data change
        widget.onDataChanged?.call();
      } else {
        // Handle API error
        final errorMsg = response.message;
        debugPrint(
            '❌ ServiceSubcategoryCrud: Subcategories API error: $errorMsg');
        debugPrint(
            '❌ ServiceSubcategoryCrud: Status code: ${response.statusCode}');
        debugPrint('❌ ServiceSubcategoryCrud: Errors: ${response.errors}');

        setState(() {
          _errorMessage = errorMsg;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime);
      debugPrint(
          '❌ ServiceSubcategoryCrud: Exception loading subcategories (${duration.inMilliseconds}ms) - $e');
      debugPrint('❌ ServiceSubcategoryCrud: Stack trace: $stackTrace');

      setState(() {
        _errorMessage = 'Failed to load subcategories: $e';
        _isLoading = false;
      });
    }
  }

  /// Apply search and filter criteria to the subcategories list
  void _applyFilters() {
    debugPrint('🔍 ServiceSubcategoryCrud: Applying filters');
    debugPrint(
        '🔍 ServiceSubcategoryCrud: Search query: "${widget.searchQuery}"');
    debugPrint('🔍 ServiceSubcategoryCrud: Filter: "${widget.filter}"');
    debugPrint(
        '🔍 ServiceSubcategoryCrud: Parent category filter: "${widget.parentCategoryId}"');
    debugPrint(
        '🔍 ServiceSubcategoryCrud: Total subcategories to filter: ${_allSubcategories.length}');

    List<ServiceSubcategory> filtered = List.from(_allSubcategories);

    // Step 1: Apply parent category filter (if provided)
    debugPrint(
        '🔍 ServiceSubcategoryCrud: Step 1 - Applying parent category filter');
    if (widget.parentCategoryId != null &&
        widget.parentCategoryId!.isNotEmpty) {
      final beforeCategoryCount = filtered.length;
      filtered = filtered
          .where((sub) => sub.category == widget.parentCategoryId)
          .toList();
      debugPrint(
          '🔍 ServiceSubcategoryCrud: After parent category filter: ${filtered.length} subcategories (was $beforeCategoryCount)');
    } else {
      debugPrint(
          '🔍 ServiceSubcategoryCrud: No parent category filter applied');
    }

    // Step 2: Apply status filter (all, active, inactive)
    debugPrint('🔍 ServiceSubcategoryCrud: Step 2 - Applying status filter');
    if (widget.filter == 'active') {
      final beforeStatusCount = filtered.length;
      filtered = filtered.where((sub) => sub.isActive).toList();
      debugPrint(
          '🔍 ServiceSubcategoryCrud: After active filter: ${filtered.length} subcategories (was $beforeStatusCount)');
    } else if (widget.filter == 'inactive') {
      final beforeStatusCount = filtered.length;
      filtered = filtered.where((sub) => !sub.isActive).toList();
      debugPrint(
          '🔍 ServiceSubcategoryCrud: After inactive filter: ${filtered.length} subcategories (was $beforeStatusCount)');
    } else {
      debugPrint(
          '🔍 ServiceSubcategoryCrud: No status filter applied (showing all)');
    }

    // Step 3: Apply search filter (only if search query is not empty)
    debugPrint('🔍 ServiceSubcategoryCrud: Step 3 - Applying search filter');
    if (widget.searchQuery.isNotEmpty) {
      final searchLower = widget.searchQuery.toLowerCase();
      debugPrint(
          '🔍 ServiceSubcategoryCrud: Search term (lowercase): "$searchLower"');

      final beforeSearchCount = filtered.length;
      filtered = filtered.where((sub) {
        final nameMatch = sub.name.toLowerCase().contains(searchLower);
        final descMatch = sub.description.toLowerCase().contains(searchLower);
        final categoryMatch =
            sub.categoryName.toLowerCase().contains(searchLower);
        final matches = nameMatch || descMatch || categoryMatch;

        if (matches) {
          debugPrint(
              '🔍 ServiceSubcategoryCrud: Match found - "${sub.name}" (name: $nameMatch, desc: $descMatch, category: $categoryMatch)');
        }

        return matches;
      }).toList();

      debugPrint(
          '🔍 ServiceSubcategoryCrud: Search filtering: $beforeSearchCount -> ${filtered.length} subcategories');
    } else {
      debugPrint(
          '🔍 ServiceSubcategoryCrud: Empty search query - showing all subcategories matching other filters');
    }

    // Step 4: Sort by sort_order for consistent display
    debugPrint('🔍 ServiceSubcategoryCrud: Step 4 - Sorting by sort_order');
    filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    debugPrint(
        '🔍 ServiceSubcategoryCrud: Final filtered results: ${filtered.length} subcategories');

    // Log final results for debugging
    for (int i = 0; i < filtered.length && i < 10; i++) {
      // Log first 10 for brevity
      final sub = filtered[i];
      debugPrint(
          '🔍 ServiceSubcategoryCrud: Result [$i]: ${sub.name} (${sub.isActive ? "Active" : "Inactive"}) - ${sub.categoryName}');
    }
    if (filtered.length > 10) {
      debugPrint(
          '🔍 ServiceSubcategoryCrud: ... and ${filtered.length - 10} more results');
    }

    setState(() {
      _filteredSubcategories = filtered;
    });

    debugPrint('🔍 ServiceSubcategoryCrud: Filter application completed');
  }

  /// Refresh the subcategories data
  Future<void> refreshData() async {
    debugPrint('🔄 ServiceSubcategoryCrud: Manual refresh triggered');
    await _loadCategories();
    await _loadSubcategories();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 ServiceSubcategoryCrud: Building UI');
    debugPrint('🎨 ServiceSubcategoryCrud: Loading state: $_isLoading');
    debugPrint('🎨 ServiceSubcategoryCrud: Error state: $_errorMessage');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: Filtered subcategories count: ${_filteredSubcategories.length}');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========

    // Comprehensive theme logging for debugging

    debugPrint(
        '🎨 ServiceSubcategoryCrud: Building with COMPREHENSIVE ThemeManager integration');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Primary: ${ThemeManager.of(context).primaryColor}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Secondary: ${ThemeManager.of(context).secondaryColor}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Surface: ${ThemeManager.of(context).surfaceColor}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Card Background: ${ThemeManager.of(context).cardBackground}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Surface Elevated: ${ThemeManager.of(context).surfaceElevated}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Input Background: ${ThemeManager.of(context).inputBackground}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Status Colors - Success: ${ThemeManager.of(context).successColor}, Warning: ${ThemeManager.of(context).warningColor}, Error: ${ThemeManager.of(context).errorColor}, Info: ${ThemeManager.of(context).infoColor}');
    debugPrint(
        '🎨 ServiceSubcategoryCrud: → Stats - Total: $_totalCount, Active: $_activeCount, Inactive: $_inactiveCount');

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

  /// Build error state UI with comprehensive ThemeManager integration
  Widget _buildErrorState() {
    debugPrint(
        '❌ ServiceSubcategoryCrud: Building enhanced error state UI with comprehensive theming');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundColor,
              ThemeManager.of(context).backgroundSecondary,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundColor,
              ThemeManager.of(context).backgroundTertiary,
            ],
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enhanced error icon with gradient container
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ThemeManager.of(context).conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).errorColor,
                    ThemeManager.of(context).errorLight,
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).errorDark,
                    ThemeManager.of(context).errorColor,
                  ],
                ),
              ),
              boxShadow: [
                ...ThemeManager.of(context).elevatedShadow,
                BoxShadow(
                  color:
                      ThemeManager.of(context).errorColor.withValues(alpha: 77),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Prbal.exclamationTriangle,
              size: 48.sp,
              color: ThemeManager.of(context)
                  .getContrastingColor(ThemeManager.of(context).errorColor),
            ),
          ),
          SizedBox(height: 32.h),

          // Enhanced title with proper theme colors
          Text(
            'Error Loading Subcategories',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 12.h),

          // Enhanced error message with theme-aware styling
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: ThemeManager.of(context).conditionalColor(
                lightColor:
                    ThemeManager.of(context).errorColor.withValues(alpha: 26),
                darkColor:
                    ThemeManager.of(context).errorDark.withValues(alpha: 51),
              ),
              border: Border.all(
                color: ThemeManager.of(context).conditionalColor(
                  lightColor:
                      ThemeManager.of(context).errorColor.withValues(alpha: 77),
                  darkColor: ThemeManager.of(context)
                      .errorColor
                      .withValues(alpha: 102),
                ),
              ),
            ),
            child: Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeManager.of(context).textSecondary,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // Enhanced retry button with comprehensive theming
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: ThemeManager.of(context).primaryGradient,
              boxShadow: [
                ...ThemeManager.of(context).primaryShadow,
                BoxShadow(
                  color: ThemeManager.of(context).shadowMedium,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                debugPrint('🔄 ServiceSubcategoryCrud: Retry button pressed');
                setState(() {
                  _errorMessage = null;
                });
                _initializeServiceAndLoadData();
              },
              icon: Icon(Prbal.redo, size: 18.sp),
              label: Text(
                'Retry',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: ThemeManager.of(context)
                    .getContrastingColor(ThemeManager.of(context).primaryColor),
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading state UI with comprehensive ThemeManager integration
  Widget _buildLoadingState() {
    debugPrint(
        '⏳ ServiceSubcategoryCrud: Building enhanced loading state UI with comprehensive theming');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundColor,
              ThemeManager.of(context).backgroundSecondary,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundColor,
              ThemeManager.of(context).backgroundTertiary,
            ],
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enhanced loading indicator with gradient container
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ThemeManager.of(context).conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).primaryColor.withValues(alpha: 51),
                    ThemeManager.of(context).primaryLight.withValues(alpha: 26),
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).primaryDark.withValues(alpha: 77),
                    ThemeManager.of(context).primaryColor.withValues(alpha: 51),
                  ],
                ),
              ),
              boxShadow: [
                ...ThemeManager.of(context).subtleShadow,
                BoxShadow(
                  color: ThemeManager.of(context)
                      .primaryColor
                      .withValues(alpha: 51),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeManager.of(context).primaryColor,
                strokeWidth: 3,
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // Enhanced title with proper theme colors
          Text(
            'Loading Subcategories...',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 12.h),

          // Enhanced description with theme-aware styling
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: ThemeManager.of(context).conditionalColor(
                lightColor:
                    ThemeManager.of(context).infoColor.withValues(alpha: 26),
                darkColor:
                    ThemeManager.of(context).infoDark.withValues(alpha: 51),
              ),
              border: Border.all(
                color: ThemeManager.of(context).conditionalColor(
                  lightColor:
                      ThemeManager.of(context).infoColor.withValues(alpha: 77),
                  darkColor:
                      ThemeManager.of(context).infoColor.withValues(alpha: 102),
                ),
              ),
            ),
            child: Text(
              'Please wait while we fetch the data',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeManager.of(context).textSecondary,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Loading progress dots with theme colors
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeManager.of(context).primaryColor.withValues(
                        alpha: index == 0
                            ? 204
                            : index == 1
                                ? 153
                                : 102,
                      ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build empty state UI with comprehensive ThemeManager integration
  Widget _buildEmptyState() {
    debugPrint(
        '📭 ServiceSubcategoryCrud: Building enhanced empty state UI with comprehensive theming');
    debugPrint(
        '📭 ServiceSubcategoryCrud: Search query: "${widget.searchQuery}"');
    debugPrint('📭 ServiceSubcategoryCrud: Filter: "${widget.filter}"');

    // Determine empty state type
    final isSearchResult = widget.searchQuery.isNotEmpty;
    final isFiltered =
        widget.filter != 'all' || widget.parentCategoryId != null;

    String title;
    String subtitle;
    IconData icon;
    Color primaryColor;
    Color lightColor;
    Color darkColor;

    if (isSearchResult) {
      title = 'No Search Results';
      subtitle = 'No subcategories found for "${widget.searchQuery}"';
      icon = Prbal.search;
      primaryColor = ThemeManager.of(context).infoColor;
      lightColor = ThemeManager.of(context).infoLight;
      darkColor = ThemeManager.of(context).infoDark;
    } else if (isFiltered) {
      title = 'No Subcategories';
      subtitle = 'No subcategories match the current filter';
      icon = Prbal.filter;
      primaryColor = ThemeManager.of(context).warningColor;
      lightColor = ThemeManager.of(context).warningLight;
      darkColor = ThemeManager.of(context).warningDark;
    } else {
      title = 'No Subcategories';
      subtitle = 'Start by creating your first subcategory';
      icon = Prbal.openstreetmap;
      primaryColor = ThemeManager.of(context).primaryColor;
      lightColor = ThemeManager.of(context).primaryLight;
      darkColor = ThemeManager.of(context).primaryDark;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundColor,
              ThemeManager.of(context).backgroundSecondary,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundColor,
              ThemeManager.of(context).backgroundTertiary,
            ],
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enhanced icon container with comprehensive theming
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ThemeManager.of(context).conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor,
                    lightColor,
                    primaryColor.withValues(alpha: 179),
                  ],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    darkColor,
                    primaryColor,
                    lightColor.withValues(alpha: 179),
                  ],
                ),
              ),
              boxShadow: [
                ...ThemeManager.of(context).elevatedShadow,
                BoxShadow(
                  color: primaryColor.withValues(alpha: 77),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 56.sp,
              color: ThemeManager.of(context).getContrastingColor(primaryColor),
            ),
          ),
          SizedBox(height: 40.h),

          // Enhanced title with proper theme colors
          Text(
            title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 16.h),

          // Enhanced subtitle with theme-aware styling
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: ThemeManager.of(context).conditionalColor(
                lightColor: primaryColor.withValues(alpha: 26),
                darkColor: darkColor.withValues(alpha: 51),
              ),
              border: Border.all(
                color: ThemeManager.of(context).conditionalColor(
                  lightColor: primaryColor.withValues(alpha: 77),
                  darkColor: primaryColor.withValues(alpha: 102),
                ),
              ),
            ),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: ThemeManager.of(context).textSecondary,
                height: 1.4,
              ),
            ),
          ),

          if (!isSearchResult && !isFiltered) ...[
            SizedBox(height: 40.h),

            // Enhanced create button with comprehensive theming
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: ThemeManager.of(context).primaryGradient,
                boxShadow: [
                  ...ThemeManager.of(context).primaryShadow,
                  BoxShadow(
                    color: ThemeManager.of(context).shadowMedium,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  debugPrint(
                      '➕ ServiceSubcategoryCrud: Create subcategory button pressed');
                  _showCreateSubcategoryDialog();
                },
                icon: Icon(Prbal.plus, size: 20.sp),
                label: Text(
                  'Create Subcategory',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    letterSpacing: 0.3,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: ThemeManager.of(context).getContrastingColor(
                      ThemeManager.of(context).primaryColor),
                  shadowColor: Colors.transparent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build main subcategory list UI with comprehensive ThemeManager integration
  Widget _buildSubcategoryList() {
    debugPrint(
        '📋 ServiceSubcategoryCrud: Building enhanced subcategory list UI with comprehensive theming');
    debugPrint(
        '📋 ServiceSubcategoryCrud: Displaying ${_filteredSubcategories.length} subcategories');

    return Container(
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundColor,
              ThemeManager.of(context).backgroundSecondary,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundColor,
              ThemeManager.of(context).backgroundTertiary,
            ],
          ),
        ),
      ),
      child: Column(
        children: [
          // Enhanced statistics header
          _buildStatisticsHeader(),

          // Enhanced subcategory list with theme-aware styling
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshData,
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
    debugPrint(
        '📊 ServiceSubcategoryCrud: Building enhanced statistics header with comprehensive theming');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).cardBackground,
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).backgroundSecondary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).cardBackground,
              ThemeManager.of(context).backgroundTertiary,
              ThemeManager.of(context).surfaceElevated,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor:
                ThemeManager.of(context).borderColor.withValues(alpha: 51),
            darkColor:
                ThemeManager.of(context).borderFocus.withValues(alpha: 77),
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...ThemeManager.of(context).elevatedShadow,
          BoxShadow(
            color: ThemeManager.of(context).shadowMedium,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Enhanced icon with gradient container
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: ThemeManager.of(context).conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).primaryColor,
                    ThemeManager.of(context).primaryLight,
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).primaryDark,
                    ThemeManager.of(context).primaryColor,
                  ],
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeManager.of(context)
                      .primaryColor
                      .withValues(alpha: 77),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Prbal.openstreetmap,
              color: ThemeManager.of(context)
                  .getContrastingColor(ThemeManager.of(context).primaryColor),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),

          // Enhanced text content
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
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Showing ${_filteredSubcategories.length} of $_totalCount subcategories',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ThemeManager.of(context).textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Enhanced stat cards
          _buildStatCard(
              'Active', _activeCount, ThemeManager.of(context).successColor),
          SizedBox(width: 12.w),
          _buildStatCard('Inactive', _inactiveCount,
              ThemeManager.of(context).warningColor),
        ],
      ),
    );
  }

  /// Build individual stat card with comprehensive ThemeManager integration
  Widget _buildStatCard(
    String label,
    int count,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 26),
            color.withValues(alpha: 13),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: 102),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 26),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 2.h),
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

  /// Build modern subcategory card with comprehensive ThemeManager integration
  Widget _buildSubcategoryCard(ServiceSubcategory subcategory, int index) {
    debugPrint(
        '📋 ServiceSubcategoryCrud: Building subcategory card for: ${subcategory.name}');

    final isSelected = widget.selectedIds.contains(subcategory.id);
    final categoryInfo = _allCategories.firstWhere(
      (cat) => cat.id == subcategory.category,
      orElse: () => ServiceCategory(
        id: subcategory.category,
        name: subcategory.categoryName,
        description: 'Unknown category',
        sortOrder: 0,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 230),
              const Color(0xFFF8FAFC).withValues(alpha: 179),
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E293B).withValues(alpha: 204),
              const Color(0xFF334155).withValues(alpha: 153),
            ],
          ),
        ),
        border: Border.all(
          color: isSelected
              ? ThemeManager.of(context).primaryColor
              : ThemeManager.of(context).conditionalColor(
                  lightColor: Colors.grey.withValues(alpha: 51),
                  darkColor: Colors.white.withValues(alpha: 26),
                ),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).conditionalColor(
              lightColor: Colors.grey.withValues(alpha: 26),
              darkColor: Colors.black.withValues(alpha: 77),
            ),
            blurRadius: isSelected ? 12 : 8,
            offset: Offset(0, isSelected ? 6 : 4),
          ),
          if (isSelected)
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 77),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            debugPrint(
                '📋 ServiceSubcategoryCrud: Subcategory card tapped: ${subcategory.name}');
            widget.onSelectionChanged(subcategory.id);
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========== HEADER ROW ==========
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
                              : ThemeManager.of(context).conditionalColor(
                                  lightColor: Colors.grey[400]!,
                                  darkColor: Colors.grey[600]!,
                                ),
                          width: 2,
                        ),
                        color: isSelected
                            ? ThemeManager.of(context).primaryColor
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? Icon(
                              Prbal.check,
                              size: 16.sp,
                              color: Colors.white,
                            )
                          : null,
                    ),

                    SizedBox(width: 12.w),

                    // Subcategory icon (if available)
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF8B5CF6).withValues(alpha: 204),
                            const Color(0xFF7C3AED).withValues(alpha: 153),
                          ],
                        ),
                      ),
                      child: Icon(
                        subcategory.icon != null
                            ? IconData(
                                int.tryParse(subcategory.icon!) ??
                                    Prbal.openstreetmap.codePoint,
                                fontFamily: 'LineIcons')
                            : Prbal.openstreetmap,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Title and category info
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
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Prbal.tag,
                                size: 12.sp,
                                color: const Color(0xFF8B5CF6),
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  categoryInfo.name,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF8B5CF6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Status badge
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: subcategory.isActive
                            ? Colors.green.withValues(alpha: 26)
                            : Colors.orange.withValues(alpha: 26),
                        border: Border.all(
                          color: subcategory.isActive
                              ? Colors.green.withValues(alpha: 77)
                              : Colors.orange.withValues(alpha: 77),
                        ),
                      ),
                      child: Text(
                        subcategory.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: subcategory.isActive
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // ========== DESCRIPTION ==========
                if (subcategory.description.isNotEmpty) ...[
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
                  SizedBox(height: 12.h),
                ],

                // ========== METADATA ROW ==========
                Row(
                  children: [
                    // Sort order
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: ThemeManager.of(context).conditionalColor(
                          lightColor: Colors.grey[200]!.withValues(alpha: 128),
                          darkColor: Colors.grey[800]!.withValues(alpha: 128),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Prbal.sortNumerically,
                            size: 10.sp,
                            color: ThemeManager.of(context).conditionalColor(
                              lightColor: Colors.grey[600]!,
                              darkColor: Colors.grey[400]!,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '#${subcategory.sortOrder}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: ThemeManager.of(context).conditionalColor(
                                lightColor: Colors.grey[600]!,
                                darkColor: Colors.grey[400]!,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // Created date
                    Text(
                      'Created ${_formatDate(subcategory.createdAt)}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: ThemeManager.of(context).textTertiary,
                      ),
                    ),

                    const Spacer(),

                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color:
                                const Color(0xFF8B5CF6).withValues(alpha: 26),
                            border: Border.all(
                              color:
                                  const Color(0xFF8B5CF6).withValues(alpha: 77),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.r),
                              onTap: () {
                                debugPrint(
                                    '✏️ ServiceSubcategoryCrud: Edit subcategory: ${subcategory.name}');
                                _showEditSubcategoryDialog(subcategory);
                              },
                              child: Icon(
                                Prbal.edit,
                                size: 16.sp,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // Toggle status button
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: subcategory.isActive
                                ? Colors.orange.withValues(alpha: 26)
                                : Colors.green.withValues(alpha: 26),
                            border: Border.all(
                              color: subcategory.isActive
                                  ? Colors.orange.withValues(alpha: 77)
                                  : Colors.green.withValues(alpha: 77),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.r),
                              onTap: () {
                                debugPrint(
                                    '🔄 ServiceSubcategoryCrud: Toggle status for: ${subcategory.name}');
                                _toggleSubcategoryStatus(subcategory);
                              },
                              child: Icon(
                                subcategory.isActive ? Prbal.pause : Prbal.play,
                                size: 16.sp,
                                color: subcategory.isActive
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // Delete button
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Colors.red.withValues(alpha: 26),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 77),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.r),
                              onTap: () {
                                debugPrint(
                                    '🗑️ ServiceSubcategoryCrud: Delete subcategory: ${subcategory.name}');
                                _showDeleteConfirmationDialog(subcategory);
                              },
                              child: Icon(
                                Prbal.trash,
                                size: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}m ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

// ========== CRUD OPERATION METHODS ==========

  /// Show create subcategory dialog
  void _showCreateSubcategoryDialog() {
    debugPrint('➕ ServiceSubcategoryCrud: Showing create subcategory dialog');

    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCategoryId;
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: ThemeManager.of(context).conditionalColor(
              lightColor: Colors.white,
              darkColor: const Color(0xFF1E293B),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    ),
                  ),
                  child: Icon(Prbal.plus, color: Colors.white, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Create Subcategory',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 400.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Parent Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon:
                          Icon(Prbal.tag, color: const Color(0xFF8B5CF6)),
                    ),
                    value: selectedCategoryId,
                    items: _allCategories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),

                  SizedBox(height: 16.h),

                  // Name field
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Subcategory Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: Icon(Prbal.openstreetmap,
                          color: const Color(0xFF8B5CF6)),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter a name' : null,
                  ),

                  SizedBox(height: 16.h),

                  // Description field
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon:
                          Icon(Prbal.file, color: const Color(0xFF8B5CF6)),
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a description'
                        : null,
                  ),

                  SizedBox(height: 16.h),

                  // Active status switch
                  Row(
                    children: [
                      Icon(Prbal.toggleOn, color: const Color(0xFF8B5CF6)),
                      SizedBox(width: 8.w),
                      Text('Active Status'),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                        activeColor: const Color(0xFF8B5CF6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  gradient: ThemeManager.of(context).primaryGradient,
                  boxShadow: ThemeManager.of(context).primaryShadow,
                ),
                child: ElevatedButton(
                  onPressed: () => _createSubcategory(
                    context,
                    selectedCategoryId,
                    nameController.text,
                    descriptionController.text,
                    isActive,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: ThemeManager.of(context).textInverted,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const Text('Create'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Show edit subcategory dialog
  void _showEditSubcategoryDialog(ServiceSubcategory subcategory) {
    debugPrint(
        '✏️ ServiceSubcategoryCrud: Showing edit dialog for: ${subcategory.name}');

    final nameController = TextEditingController(text: subcategory.name);
    final descriptionController =
        TextEditingController(text: subcategory.description);
    String selectedCategoryId = subcategory.category;
    bool isActive = subcategory.isActive;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: ThemeManager.of(context).conditionalColor(
              lightColor: Colors.white,
              darkColor: const Color(0xFF1E293B),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    ),
                  ),
                  child: Icon(Prbal.edit, color: Colors.white, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Edit Subcategory',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 400.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Parent Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon:
                          Icon(Prbal.tag, color: const Color(0xFF8B5CF6)),
                    ),
                    value: selectedCategoryId,
                    items: _allCategories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value!;
                      });
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Name field
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Subcategory Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: Icon(Prbal.openstreetmap,
                          color: const Color(0xFF8B5CF6)),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Description field
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon:
                          Icon(Prbal.file, color: const Color(0xFF8B5CF6)),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Active status switch
                  Row(
                    children: [
                      Icon(Prbal.toggleOn, color: const Color(0xFF8B5CF6)),
                      SizedBox(width: 8.w),
                      Text('Active Status'),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                        activeColor: const Color(0xFF8B5CF6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () => _updateSubcategory(
                  context,
                  subcategory.id,
                  selectedCategoryId,
                  nameController.text,
                  descriptionController.text,
                  isActive,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmationDialog(ServiceSubcategory subcategory) {
    debugPrint(
        '🗑️ ServiceSubcategoryCrud: Showing delete confirmation for: ${subcategory.name}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeManager.of(context).conditionalColor(
          lightColor: Colors.white,
          darkColor: const Color(0xFF1E293B),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).errorColor.withValues(alpha: 26),
                    ThemeManager.of(context).errorLight.withValues(alpha: 13),
                  ],
                ),
                border: Border.all(
                  color: ThemeManager.of(context)
                      .errorColor
                      .withValues(alpha: 102),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeManager.of(context)
                        .errorColor
                        .withValues(alpha: 26),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Prbal.trash,
                  color: ThemeManager.of(context).errorColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Delete Subcategory',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this subcategory?',
              style: TextStyle(
                fontSize: 16.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).errorColor.withValues(alpha: 26),
                    ThemeManager.of(context).errorLight.withValues(alpha: 13),
                  ],
                ),
                border: Border.all(
                  color: ThemeManager.of(context)
                      .errorColor
                      .withValues(alpha: 102),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeManager.of(context)
                        .errorColor
                        .withValues(alpha: 26),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subcategory.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeManager.of(context).errorColor,
                    ),
                  ),
                  Text(
                    'Category: ${subcategory.categoryName}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ThemeManager.of(context).textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeManager.of(context).errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              gradient: ThemeManager.of(context).errorGradient,
              boxShadow: [
                BoxShadow(
                  color:
                      ThemeManager.of(context).errorColor.withValues(alpha: 77),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _deleteSubcategory(context, subcategory),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: ThemeManager.of(context).textInverted,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: const Text('Delete'),
            ),
          ),
        ],
      ),
    );
  }

  /// Create new subcategory
  Future<void> _createSubcategory(
    BuildContext context,
    String? categoryId,
    String name,
    String description,
    bool isActive,
  ) async {
    if (categoryId == null || name.isEmpty || description.isEmpty) {
      _showSnackBar('Please fill all required fields', isError: true);
      return;
    }

    debugPrint('➕ ServiceSubcategoryCrud: Creating subcategory: $name');

    try {
      final request = ServiceSubcategoryRequest(
        category: categoryId,
        name: name,
        description: description,
        isActive: isActive,
      );

      final response =
          await _serviceManagementService.createSubcategory(request);

      if (response.isSuccess) {
        Navigator.of(context).pop();
        _showSnackBar('Subcategory created successfully');
        await _loadSubcategories();
      } else {
        _showSnackBar('Failed to create subcategory: ${response.message}',
            isError: true);
      }
    } catch (e) {
      debugPrint('❌ ServiceSubcategoryCrud: Error creating subcategory - $e');
      _showSnackBar('Error creating subcategory: $e', isError: true);
    }
  }

  /// Update existing subcategory
  Future<void> _updateSubcategory(
    BuildContext context,
    String subcategoryId,
    String categoryId,
    String name,
    String description,
    bool isActive,
  ) async {
    if (name.isEmpty || description.isEmpty) {
      _showSnackBar('Please fill all required fields', isError: true);
      return;
    }

    debugPrint('✏️ ServiceSubcategoryCrud: Updating subcategory: $name');

    try {
      final request = ServiceSubcategoryRequest(
        category: categoryId,
        name: name,
        description: description,
        isActive: isActive,
      );

      final response = await _serviceManagementService.updateSubcategory(
        subcategoryId: subcategoryId,
        request: request,
      );

      if (response.isSuccess) {
        Navigator.of(context).pop();
        _showSnackBar('Subcategory updated successfully');
        await _loadSubcategories();
      } else {
        _showSnackBar('Failed to update subcategory: ${response.message}',
            isError: true);
      }
    } catch (e) {
      debugPrint('❌ ServiceSubcategoryCrud: Error updating subcategory - $e');
      _showSnackBar('Error updating subcategory: $e', isError: true);
    }
  }

  /// Delete subcategory
  Future<void> _deleteSubcategory(
      BuildContext context, ServiceSubcategory subcategory) async {
    debugPrint(
        '🗑️ ServiceSubcategoryCrud: Deleting subcategory: ${subcategory.name}');

    try {
      final response =
          await _serviceManagementService.deleteSubcategory(subcategory.id);

      if (response.isSuccess) {
        Navigator.of(context).pop();
        _showSnackBar('Subcategory deleted successfully');
        await _loadSubcategories();
      } else {
        _showSnackBar('Failed to delete subcategory: ${response.message}',
            isError: true);
      }
    } catch (e) {
      debugPrint('❌ ServiceSubcategoryCrud: Error deleting subcategory - $e');
      _showSnackBar('Error deleting subcategory: $e', isError: true);
    }
  }

  /// Toggle subcategory status
  Future<void> _toggleSubcategoryStatus(ServiceSubcategory subcategory) async {
    debugPrint(
        '🔄 ServiceSubcategoryCrud: Toggling status for: ${subcategory.name}');

    try {
      final response = await _serviceManagementService.patchSubcategory(
        subcategoryId: subcategory.id,
        isActive: !subcategory.isActive,
      );

      if (response.isSuccess) {
        _showSnackBar(
            'Subcategory ${!subcategory.isActive ? 'activated' : 'deactivated'} successfully');
        await _loadSubcategories();
      } else {
        _showSnackBar('Failed to update status: ${response.message}',
            isError: true);
      }
    } catch (e) {
      debugPrint('❌ ServiceSubcategoryCrud: Error toggling status - $e');
      _showSnackBar('Error updating status: $e', isError: true);
    }
  }

  /// Show snackbar message with comprehensive ThemeManager integration
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: ThemeManager.of(context).textInverted,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError
            ? ThemeManager.of(context).errorColor
            : ThemeManager.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 8,
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('🏷️ ServiceSubcategoryCrud: Disposing widget');
    super.dispose();
  }
}
