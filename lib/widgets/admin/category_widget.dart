import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/services/service_providers.dart';

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
    debugPrint('🏷️ ServiceCategoryCrud: Initializing modern CRUD widget with integrated search');

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

  /// Load all categories from the API
  Future<void> _loadCategories() async {
    debugPrint('📊 ServiceCategoryCrud: Starting to load categories');
    final startTime = DateTime.now();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('🔄 ServiceCategoryCrud: Calling getCategories API');

      final response = await _serviceManagementService.getCategories(
        activeOnly: false,
        ordering: 'sort_order',
        useCache: !_isInitialLoad,
      );

      final duration = DateTime.now().difference(startTime);

      debugPrint('📊 ServiceCategoryCrud: API call completed in ${duration.inMilliseconds}ms');

      if (response.isSuccess && response.data != null) {
        final categories = response.data!;
        debugPrint('📊 ServiceCategoryCrud: Received ${categories.length} categories');

        _totalCount = categories.length;
        _activeCount = categories.where((cat) => cat.isActive).length;
        _inactiveCount = categories.where((cat) => !cat.isActive).length;

        setState(() {
          _allCategories = categories;
          _isLoading = false;
          _isInitialLoad = false;
        });

        _applyFilters();
        widget.onDataChanged?.call();

        // Start animations
        _fadeController.forward();
        _slideController.forward();
      } else {
        debugPrint('❌ ServiceCategoryCrud: API error: ${response.message}');
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ ServiceCategoryCrud: Exception loading categories - $e');
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
          serviceManagementService: _serviceManagementService,
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
          serviceManagementService: _serviceManagementService,
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

  /// Build modern bulk actions FAB
  Widget _buildBulkActionsFAB() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('🔧 ServiceCategoryCrud: Bulk actions button pressed');
          HapticFeedback.mediumImpact();
          _showModernBulkActionsBottomSheet();
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: Icon(LineIcons.cogs, size: 20.sp, color: Colors.white),
        label: Text(
          '${widget.selectedIds.length}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Build modern add category FAB
  Widget _buildAddCategoryFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          debugPrint('🎨 ServiceCategoryCrud: FAB pressed - showing create modal');
          HapticFeedback.mediumImpact();
          _showCreateCategoryModal();
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          LineIcons.plus,
          color: Colors.white,
          size: 20.sp,
        ),
        // label: Text(
        //   'Add Category',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontWeight: FontWeight.w600,
        //     fontSize: 14.sp,
        //   ),
        // ),
      ),
    );
  }

  /// Show modern bulk actions bottom sheet
  void _showModernBulkActionsBottomSheet() {
    debugPrint('🔧 ServiceCategoryCrud: Showing modern bulk actions bottom sheet');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    // Theme-aware color definitions
    final successColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
    final warningColor = isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706);
    final infoColor = isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);
    final errorColor = isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark ? [const Color(0xFF374151), const Color(0xFF1F2937)] : [Colors.white, const Color(0xFFF8FAFC)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 60.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.2),
                          primaryColor.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      LineIcons.cogs,
                      color: primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bulk Actions',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          '${widget.selectedIds.length} categories selected',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Actions - Make this flexible to handle overflow
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 28.h),
                child: Column(
                  children: [
                    _buildBulkActionTile('Activate All', LineIcons.checkCircle, successColor, isDark),
                    SizedBox(height: 12.h),
                    _buildBulkActionTile('Deactivate All', LineIcons.pauseCircle, warningColor, isDark),
                    SizedBox(height: 12.h),
                    _buildBulkActionTile('Export Selected', LineIcons.download, infoColor, isDark),
                    SizedBox(height: 12.h),
                    _buildBulkActionTile('Delete All', LineIcons.trash, errorColor, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build modern bulk action tile
  Widget _buildBulkActionTile(String title, IconData icon, Color color, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        HapticFeedback.lightImpact();
        debugPrint('🔧 ServiceCategoryCrud: Bulk action selected: $title');

        // Show coming soon snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20.sp),
                SizedBox(width: 12.w),
                Text(
                  '$title action will be implemented soon',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            margin: EdgeInsets.all(16.w),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
            ),
            Icon(
              LineIcons.angleRight,
              color: color,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  /// Apply search and filter criteria to the categories list
  void _applyFilters() {
    debugPrint('🔍 ServiceCategoryCrud: Applying filters - search: "$_searchQuery", filter: "$_currentFilter"');

    List<ServiceCategory> filtered = List.from(_allCategories);

    // Apply status filter
    if (_currentFilter == 'active') {
      filtered = filtered.where((cat) => cat.isActive).toList();
    } else if (_currentFilter == 'inactive') {
      filtered = filtered.where((cat) => !cat.isActive).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final searchLower = _searchQuery.toLowerCase();
      filtered = filtered.where((cat) {
        final nameMatch = cat.name.toLowerCase().contains(searchLower);
        final descMatch = cat.description.toLowerCase().contains(searchLower);
        return nameMatch || descMatch;
      }).toList();
    }

    // Sort by sort_order
    filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    setState(() {
      _filteredCategories = filtered;
    });

    debugPrint('🔍 ServiceCategoryCrud: Filters applied - showing ${_filteredCategories.length} categories');
  }

  /// Refresh the categories data
  Future<void> refreshData() async {
    debugPrint('🔄 ServiceCategoryCrud: Manual refresh triggered');
    await _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 ServiceCategoryCrud: Building modern widget with integrated search');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // ========== CONDITIONAL HEADER: SEARCH OR SELECTION ==========
          if (widget.selectedIds.isEmpty)
            // Show search header when no categories are selected
            FadeTransition(
              opacity: _headerFadeAnimation,
              child: SlideTransition(
                position: _headerSlideAnimation,
                child: _buildModernSearchHeader(),
              ),
            )
          else
            // Show selection info bar when categories are selected
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: _buildModernSelectionInfoBar(),
            ),

          // ========== MAIN CONTENT ==========
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
      // ========== FLOATING ACTION BUTTON ==========
      floatingActionButton: _isLoading
          ? null
          : ScaleTransition(
              scale: _fabScaleAnimation,
              child: widget.selectedIds.isNotEmpty ? _buildBulkActionsFAB() : _buildAddCategoryFAB(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Build modern search header with back button, search, and filter in one row
  Widget _buildModernSearchHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF374151).withValues(alpha: 0.9),
                    const Color(0xFF1F2937).withValues(alpha: 0.8),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.95),
                    const Color(0xFFF8FAFC).withValues(alpha: 0.9),
                  ],
          ),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Row(
                children: [
                  // Back button (optional)
                  if (widget.showBackButton) ...[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withValues(alpha: 0.15),
                            Theme.of(context).primaryColor.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          debugPrint('⬅️ ServiceCategoryCrud: Back button pressed');
                          HapticFeedback.lightImpact();
                          widget.onBackPressed?.call();
                        },
                        icon: Icon(
                          LineIcons.arrowLeft,
                          size: 20.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                        tooltip: 'Back',
                        constraints: BoxConstraints(
                          minWidth: 44.w,
                          minHeight: 44.h,
                        ),
                        padding: EdgeInsets.all(8.w),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],

                  // Enhanced search field - takes most of the space
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF1F2937).withValues(alpha: 0.8),
                                  const Color(0xFF374151).withValues(alpha: 0.6),
                                ]
                              : [
                                  Colors.white.withValues(alpha: 0.9),
                                  const Color(0xFFF8FAFC).withValues(alpha: 0.7),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search categories...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(10.w),
                            child: Icon(
                              LineIcons.search,
                              color: Theme.of(context).primaryColor,
                              size: 18.sp,
                            ),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      debugPrint('🗑️ ServiceCategoryCrud: Clear search button pressed');
                                      _searchController.clear();
                                      HapticFeedback.lightImpact();
                                    },
                                    icon: Icon(
                                      LineIcons.times,
                                      color: Colors.grey[600],
                                      size: 14.sp,
                                    ),
                                    tooltip: 'Clear Search',
                                    constraints: BoxConstraints(
                                      minWidth: 32.w,
                                      minHeight: 32.h,
                                    ),
                                    padding: EdgeInsets.all(4.w),
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                        ),
                        onSubmitted: (value) {
                          debugPrint('🔍 ServiceCategoryCrud: Search submitted: "$value"');
                          HapticFeedback.selectionClick();
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Enhanced filter button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _currentFilter != 'all'
                            ? [
                                Theme.of(context).primaryColor.withValues(alpha: 0.2),
                                Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              ]
                            : isDark
                                ? [
                                    const Color(0xFF374151).withValues(alpha: 0.8),
                                    const Color(0xFF1F2937).withValues(alpha: 0.6),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.9),
                                    const Color(0xFFF8FAFC).withValues(alpha: 0.7),
                                  ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: _currentFilter != 'all'
                            ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                            : isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.2),
                        width: _currentFilter != 'all' ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _currentFilter != 'all'
                              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                              : isDark
                                  ? Colors.black.withValues(alpha: 0.2)
                                  : Colors.grey.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        debugPrint('🔧 ServiceCategoryCrud: Filter button pressed');
                        HapticFeedback.lightImpact();
                        _showModernFilterBottomSheet();
                      },
                      icon: Stack(
                        children: [
                          Icon(
                            LineIcons.filter,
                            size: 18.sp,
                            color: _currentFilter != 'all'
                                ? Theme.of(context).primaryColor
                                : isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          if (_currentFilter != 'all')
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      tooltip: 'Filter Categories',
                      constraints: BoxConstraints(
                        minWidth: 44.w,
                        minHeight: 44.h,
                      ),
                      padding: EdgeInsets.all(8.w),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  // Results count badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (isDark ? const Color(0xFF10B981) : const Color(0xFF059669)).withValues(alpha: 0.15),
                          (isDark ? const Color(0xFF10B981) : const Color(0xFF059669)).withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: (isDark ? const Color(0xFF10B981) : const Color(0xFF059669)).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LineIcons.barChartAlt,
                          size: 12.sp,
                          color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${_filteredCategories.length}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced statistics with icons and gradients
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnhancedStatCard(
                          'Total',
                          _totalCount.toString(),
                          LineIcons.database,
                          isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5),
                          isDark,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildEnhancedStatCard(
                          'Active',
                          _activeCount.toString(),
                          LineIcons.checkCircle,
                          isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                          isDark,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildEnhancedStatCard(
                          'Inactive',
                          _inactiveCount.toString(),
                          LineIcons.pauseCircle,
                          isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706),
                          isDark,
                        ),
                      ),
                      if (widget.selectedIds.isNotEmpty) ...[
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildEnhancedStatCard(
                            'Selected',
                            widget.selectedIds.length.toString(),
                            LineIcons.checkSquare,
                            isDark ? const Color(0xFF8B5CF6) : const Color(0xFF7C3AED),
                            isDark,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // // Performance indicator
                  // if (_totalCount > 0) ...[
                  //   SizedBox(height: 16.h),
                  //   Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           const Color(0xFF10B981).withValues(alpha: 0.1),
                  //           const Color(0xFF10B981).withValues(alpha: 0.05),
                  //         ],
                  //       ),
                  //       borderRadius: BorderRadius.circular(8.r),
                  //       border: Border.all(
                  //         color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(
                  //           LineIcons.lineChart,
                  //           size: 14.sp,
                  //           color: const Color(0xFF10B981),
                  //         ),
                  //         SizedBox(width: 6.w),
                  //         Text(
                  //           '${((_activeCount / _totalCount) * 100).toStringAsFixed(0)}% Active Rate',
                  //           style: TextStyle(
                  //             fontSize: 12.sp,
                  //             color: const Color(0xFF10B981),
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          ],
        ));
  }

  /// Build main content area
  Widget _buildMainContent() {
    // Show loading state
    if (_isLoading && _isInitialLoad) {
      return _buildLoadingState();
    }

    // Show error state
    if (_errorMessage != null) {
      return _buildErrorState();
    }

    // Show empty state or categories list
    if (_filteredCategories.isEmpty) {
      return _buildEmptyState();
    } else {
      return _buildCategoriesList();
    }
  }

  /// Show modern filter bottom sheet for category filtering
  void _showModernFilterBottomSheet() {
    debugPrint('🔧 ServiceCategoryCrud: Showing modern filter bottom sheet');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (BuildContext context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark ? [const Color(0xFF374151), const Color(0xFF1F2937)] : [Colors.white, const Color(0xFFF8FAFC)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 60.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            // Header
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Filter icon with gradient background
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      LineIcons.filter,
                      color: Theme.of(context).primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter Categories',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3748),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Choose category status to display',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        LineIcons.times,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: 20.sp,
                      ),
                      padding: EdgeInsets.all(8.w),
                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter options
            Flexible(
              child: ListView(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
                children: [
                  _buildModernFilterOption(
                    title: 'All Categories',
                    subtitle: 'Show both active and inactive categories',
                    icon: LineIcons.list,
                    value: 'all',
                    isDark: isDark,
                  ),
                  SizedBox(height: 12.h),
                  _buildModernFilterOption(
                    title: 'Active Categories',
                    subtitle: 'Show only active categories',
                    icon: LineIcons.checkCircle,
                    value: 'active',
                    isDark: isDark,
                    color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                  ),
                  SizedBox(height: 12.h),
                  _buildModernFilterOption(
                    title: 'Inactive Categories',
                    subtitle: 'Show only inactive categories',
                    icon: LineIcons.pauseCircle,
                    value: 'inactive',
                    isDark: isDark,
                    color: isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build modern filter option widget
  Widget _buildModernFilterOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required bool isDark,
    Color? color,
  }) {
    final isSelected = _currentFilter == value;
    final effectiveColor = color ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        debugPrint('🔧 ServiceCategoryCrud: Filter option selected: $value');
        HapticFeedback.selectionClick();
        setState(() {
          _currentFilter = value;
        });
        _applyFilters();
        Navigator.of(context).pop();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    effectiveColor.withValues(alpha: 0.15),
                    effectiveColor.withValues(alpha: 0.05),
                  ],
                )
              : null,
          color: isSelected ? null : (isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB)),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? effectiveColor.withValues(alpha: 0.4)
                : (isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: effectiveColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveColor.withValues(alpha: 0.2),
                    effectiveColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: effectiveColor.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                icon,
                color: effectiveColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? effectiveColor : (isDark ? Colors.white : const Color(0xFF2D3748)),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: effectiveColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LineIcons.check,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build modern loading state widget
  Widget _buildLoadingState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF1A1A1A), const Color(0xFF0D1117)]
              : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Modern loading animation
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(40.r),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 24.h),

            // Loading text with shimmer effect
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.5),
                  Theme.of(context).primaryColor,
                ],
                stops: const [0.0, 0.5, 1.0],
              ).createShader(bounds),
              child: Text(
                'Loading Categories...',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please wait while we fetch your data',
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build modern error state widget
  Widget _buildErrorState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF1A1A1A), const Color(0xFF0D1117)]
              : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon with animated glow
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
                  ),
                  borderRadius: BorderRadius.circular(50.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  LineIcons.exclamationTriangle,
                  size: 48.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Retry button with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _loadCategories,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  icon: Icon(LineIcons.redo, color: Colors.white, size: 20.sp),
                  label: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build modern empty state widget
  Widget _buildEmptyState() {
    final bool isSearchResult = _searchQuery.isNotEmpty;
    final bool isFiltered = _currentFilter != 'all';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String title, subtitle;
    IconData icon;
    Color iconColor;

    if (isSearchResult) {
      title = 'No Results Found';
      subtitle = 'We couldn\'t find any categories matching "$_searchQuery"';
      icon = LineIcons.searchMinus;
      iconColor = const Color(0xFF6366F1);
    } else if (isFiltered) {
      title = 'No ${_currentFilter.toUpperCase()} Categories';
      subtitle = 'There are no $_currentFilter categories at the moment';
      icon = LineIcons.filter;
      iconColor = const Color(0xFFF59E0B);
    } else {
      title = 'Ready to Get Started?';
      subtitle = 'Create your first category to organize your services';
      icon = LineIcons.rocket;
      iconColor = const Color(0xFF10B981);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF1A1A1A), const Color(0xFF0D1117)]
              : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Modern empty state illustration
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconColor.withValues(alpha: 0.2),
                      iconColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(60.r),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 56.sp,
                  color: iconColor,
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                title,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12.h),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),

              if (_totalCount > 0) ...[
                SizedBox(height: 24.h),
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF374151), const Color(0xFF1F2937)]
                          : [Colors.white, const Color(0xFFF8FAFC)],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Total', _totalCount.toString(), const Color(0xFF6366F1), isDark),
                      _buildStatColumn('Active', _activeCount.toString(), const Color(0xFF10B981), isDark),
                      _buildStatColumn('Inactive', _inactiveCount.toString(), const Color(0xFFF59E0B), isDark),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build statistic column for empty state
  Widget _buildStatColumn(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build modern categories list widget
  Widget _buildCategoriesList() {
    return Column(
      children: [
        // ========== MODERN HEADER WITH ANALYTICS ==========
        // _buildModernHeader(),

        // ========== CATEGORIES LIST WITH ANIMATIONS ==========
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: RefreshIndicator(
                onRefresh: _loadCategories,
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategories[index];
                    final isSelected = widget.selectedIds.contains(category.id);
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutCubic,
                      child: _buildModernCategoryCard(category, isSelected, index),
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

  /// Build enhanced statistic card with gradient and icons
  Widget _buildEnhancedStatCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          // SizedBox(height: 6.h),
          // Text(
          //   label,
          //   style: TextStyle(
          //     fontSize: 12.sp,
          //     color: color,
          //     fontWeight: FontWeight.w600,
          //     letterSpacing: 0.5,
          //   ),
          //   overflow: TextOverflow.ellipsis,
          //   maxLines: 1,
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }

  /// Build individual category item with expandable design and long press selection
  Widget _buildModernCategoryCard(ServiceCategory category, bool isSelected, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = category.isActive ? Theme.of(context).primaryColor : Colors.grey;
    final isExpanded = _expandedCategories.contains(category.id);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        // Enhanced selection state with stronger visual difference
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [
                  Theme.of(context).primaryColor.withValues(alpha: 0.25),
                  Theme.of(context).primaryColor.withValues(alpha: 0.15),
                ]
              : isDark
                  ? [
                      const Color(0xFF2D2D2D).withValues(alpha: 0.9),
                      const Color(0xFF1E1E1E).withValues(alpha: 0.95),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.95),
                      const Color(0xFFF8F9FA).withValues(alpha: 0.9),
                    ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                : isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.grey.withValues(alpha: 0.1),
            blurRadius: isSelected ? 20 : 15,
            offset: Offset(0, isSelected ? 12 : 8),
            spreadRadius: isSelected ? 2 : 0,
          ),
          if (isSelected)
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
        ],
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.6)
              : category.isActive
                  ? (isDark ? const Color(0xFF10B981) : const Color(0xFF059669)).withValues(alpha: 0.4)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.2),
          width: isSelected ? 3 : (category.isActive ? 2 : 1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // Single tap to expand/collapse
          onTap: () {
            debugPrint('📱 CategoryCard: Single tap on ${category.name} - toggling expansion');
            setState(() {
              if (isExpanded) {
                _expandedCategories.remove(category.id);
              } else {
                _expandedCategories.add(category.id);
              }
            });
          },
          // Long press to select/deselect
          onLongPress: () {
            debugPrint('📱 CategoryCard: Long press on ${category.name} - toggling selection');
            widget.onSelectionChanged(category.id);

            // Haptic feedback for selection
            HapticFeedback.mediumImpact();
          },
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Main content row
                Row(
                  children: [
                    // Selection Indicator
                    // _buildSelectionIndicator(isSelected),

                    // SizedBox(width: 12.w),

                    // Icon Container (SettingsItemWidget style)
                    _buildCategoryIcon(category, iconColor, isDark),

                    SizedBox(width: 12.w),

                    // Content Section
                    Expanded(
                      child: _buildCategoryMainContent(category, isDark),
                    ),

                    SizedBox(width: 8.w),

                    // Expand/Collapse indicator
                    // _buildExpandIndicator(isExpanded, isDark),

                    SizedBox(width: 6.w),

                    // Actions Menu
                    _buildActionsMenu(category),
                  ],
                ),

                // Expandable content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildExpandableContent(category, isDark),
                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build category main content (title only, no subtitle here)
  Widget _buildCategoryMainContent(ServiceCategory category, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Name only
        Text(
          category.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF2D3748),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  /// Build expandable content (description and meta info)
  Widget _buildExpandableContent(ServiceCategory category, bool isDark) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: (isDark ? Colors.grey[800] : Colors.grey[50])?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: (isDark ? Colors.grey[700] : Colors.grey[200])!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon(
              //   LineIcons.infoCircle,
              //   size: 16.sp,
              //   color: Theme.of(context).primaryColor,
              // ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      category.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Meta Information
          Row(
            children: [
              Expanded(
                child: _buildMetaInfo(
                  icon: LineIcons.sort,
                  label: 'Sort Order',
                  value: category.sortOrder.toString(),
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildMetaInfo(
                  icon: LineIcons.calendar,
                  label: 'Created',
                  value: _formatDate(category.createdAt),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build meta information item
  Widget _buildMetaInfo({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey[500]),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build category icon with SettingsItemWidget style
  Widget _buildCategoryIcon(ServiceCategory category, Color iconColor, bool isDark) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor.withValues(alpha: 0.15),
            iconColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(
        category.icon != null ? _getIconFromString(category.icon!) : LineIcons.list,
        color: iconColor,
        size: 24.sp,
      ),
    );
  }

  /// Build actions menu button that opens modal bottom sheet
  Widget _buildActionsMenu(ServiceCategory category) {
    return IconButton(
      onPressed: () {
        debugPrint('🔧 CategoryWidget: Opening actions modal for: ${category.name}');
        _showActionsModal(category);
      },
      icon: Icon(
        LineIcons.verticalEllipsis,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
        size: 26.sp,
      ),
      tooltip: 'Category Actions',
      padding: EdgeInsets.all(6.w),
      constraints: BoxConstraints(
        minWidth: 32.w,
        minHeight: 32.h,
      ),
    );
  }

  /// Show actions modal bottom sheet for category
  void _showActionsModal(ServiceCategory category) {
    debugPrint('🔧 CategoryWidget: Showing actions modal for category: ${category.name}');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware colors
    final successColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
    final warningColor = isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706);
    final infoColor = isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);
    final errorColor = isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (BuildContext context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 60.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            // Header with category info
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Category icon
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (category.isActive ? Theme.of(context).primaryColor : Colors.grey).withValues(alpha: 0.2),
                          (category.isActive ? Theme.of(context).primaryColor : Colors.grey).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color:
                            (category.isActive ? Theme.of(context).primaryColor : Colors.grey).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      category.icon != null ? _getIconFromString(category.icon!) : LineIcons.list,
                      color: category.isActive ? Theme.of(context).primaryColor : Colors.grey,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // Category details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3748),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: category.isActive ? successColor : warningColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              category.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: category.isActive ? successColor : warningColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        LineIcons.times,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: 20.sp,
                      ),
                      padding: EdgeInsets.all(8.w),
                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action options
            Flexible(
              child: ListView(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
                children: [
                  _buildActionOption(
                    title: 'Edit Category',
                    subtitle: 'Modify category details and settings',
                    icon: LineIcons.edit,
                    color: infoColor,
                    onTap: () {
                      Navigator.of(context).pop();
                      debugPrint('✏️ Edit category: ${category.name}');
                      // TODO: Implement edit
                      _showEditCategoryModal(category);
                    },
                    isDark: isDark,
                  ),
                  SizedBox(height: 12.h),
                  _buildActionOption(
                    title: category.isActive ? 'Deactivate Category' : 'Activate Category',
                    subtitle:
                        category.isActive ? 'Hide this category from users' : 'Make this category visible to users',
                    icon: category.isActive ? LineIcons.toggleOff : LineIcons.toggleOn,
                    color: category.isActive ? warningColor : successColor,
                    onTap: () {
                      Navigator.of(context).pop();
                      debugPrint('🔄 Toggle status: ${category.name}');
                      // TODO: Implement toggle
                    },
                    isDark: isDark,
                  ),
                  SizedBox(height: 12.h),
                  _buildActionOption(
                    title: 'Delete Category',
                    subtitle: 'Permanently remove this category',
                    icon: LineIcons.trash,
                    color: errorColor,
                    onTap: () {
                      Navigator.of(context).pop();
                      debugPrint('🗑️ Delete category: ${category.name}');
                      // TODO: Implement delete
                    },
                    isDark: isDark,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual action option
  Widget _buildActionOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? color : (isDark ? Colors.white : const Color(0xFF2D3748)),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              LineIcons.angleRight,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  /// Get icon from string
  IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'home':
        return LineIcons.home;
      case 'car':
        return LineIcons.car;
      case 'tools':
        return LineIcons.tools;
      case 'heart':
        return LineIcons.heart;
      case 'computer':
        return LineIcons.laptop;
      default:
        return LineIcons.list;
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

  /// Build modern selection info bar
  Widget _buildModernSelectionInfoBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    // Theme-aware color definitions
    final successColor = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
    final warningColor = isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706);
    final errorColor = isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);
    final infoColor = isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);

    // Enhanced background colors for better theme differentiation
    final backgroundGradient = isDark
        ? [
            const Color(0xFF1E293B).withValues(alpha: 0.95),
            const Color(0xFF0F172A).withValues(alpha: 0.9),
          ]
        : [
            const Color(0xFFF8FAFC).withValues(alpha: 0.95),
            Colors.white.withValues(alpha: 0.9),
          ];

    // Border colors for better contrast
    final borderColor = isDark ? primaryColor.withValues(alpha: 0.4) : primaryColor.withValues(alpha: 0.3);

    // Text colors for better readability
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark ? Colors.grey[300] : Colors.grey[600];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundGradient,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          // Primary shadow
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.4) : primaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          // Secondary shadow for depth
          BoxShadow(
            color: isDark ? primaryColor.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Enhanced selection icon with animated gradient
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  successColor.withValues(alpha: 0.2),
                  successColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: successColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: successColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              LineIcons.checkCircle,
              color: successColor,
              size: 22.sp,
            ),
          ),

          SizedBox(width: 16.w),

          // Enhanced selection text with better typography
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${widget.selectedIds.length} ${widget.selectedIds.length == 1 ? 'Category' : 'Categories'} Selected',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: primaryTextColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Selection count badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            infoColor.withValues(alpha: 0.2),
                            infoColor.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: infoColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '${widget.selectedIds.length}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: infoColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      LineIcons.cogs,
                      size: 12.sp,
                      color: secondaryTextColor,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        'Tap the floating button for bulk actions',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
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

          SizedBox(width: 12.w),

          // Enhanced clear button with modern design
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  errorColor.withValues(alpha: 0.15),
                  errorColor.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: errorColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: errorColor.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  debugPrint('🗑️ ServiceCategoryCrud: Clear selection pressed');
                  HapticFeedback.mediumImpact();
                  // Clear all selections by calling the callback for each selected ID
                  final selectedIdsCopy = Set<String>.from(widget.selectedIds);
                  for (final id in selectedIdsCopy) {
                    widget.onSelectionChanged(id);
                  }
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LineIcons.times,
                        color: errorColor,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
}

// ====================================================================
// CREATE CATEGORY MODAL WIDGET - Simplified Design
// ====================================================================

/// CreateCategoryModalWidget - Simple modal for creating categories
class CreateCategoryModalWidget extends StatefulWidget {
  final VoidCallback onCategoryCreated;
  final ServiceManagementService serviceManagementService;

  const CreateCategoryModalWidget({
    super.key,
    required this.onCategoryCreated,
    required this.serviceManagementService,
  });

  @override
  State<CreateCategoryModalWidget> createState() => _CreateCategoryModalWidgetState();
}

class _CreateCategoryModalWidgetState extends State<CreateCategoryModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sortOrderController = TextEditingController();

  bool _isActive = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _sortOrderController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(LineIcons.plus, color: Theme.of(context).primaryColor),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Create Category',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(LineIcons.times),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Error message
          if (_errorMessage != null)
            Container(
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 30),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  Icon(LineIcons.exclamationTriangle, color: Colors.red),
                  SizedBox(width: 8.w),
                  Expanded(child: Text(_errorMessage!, style: TextStyle(color: Colors.red))),
                ],
              ),
            ),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Category Name *',
                      prefixIcon: Icon(LineIcons.tag),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Category name is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Description field
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description *',
                      prefixIcon: Icon(LineIcons.edit),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      if (value.trim().length < 10) {
                        return 'Description must be at least 10 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Sort order field
                  TextFormField(
                    controller: _sortOrderController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Sort Order',
                      prefixIcon: Icon(LineIcons.sort),
                      border: OutlineInputBorder(),
                      helperText: 'Lower numbers appear first',
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final sortOrder = int.tryParse(value);
                        if (sortOrder == null || sortOrder < 0) {
                          return 'Must be a positive number';
                        }
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Active status
                  SwitchListTile(
                    title: Text('Active Status'),
                    subtitle: Text(
                        _isActive ? 'Category will be visible immediately' : 'Category will be hidden until activated'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Create'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Create category
  Future<void> _createCategory() async {
    debugPrint('🚀 CreateCategoryModal: Starting category creation');

    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ CreateCategoryModal: Form validation failed');
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final sortOrderText = _sortOrderController.text.trim();
    final sortOrder = sortOrderText.isEmpty ? 0 : int.tryParse(sortOrderText) ?? 0;

    setState(() => _isLoading = true);

    try {
      final response = await widget.serviceManagementService.createCategory(
        name: name,
        description: description,
        sortOrder: sortOrder,
        isActive: _isActive,
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('✅ CreateCategoryModal: Category created successfully');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category "${response.data!.name}" created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        widget.onCategoryCreated();
        Navigator.of(context).pop();
      } else {
        debugPrint('❌ CreateCategoryModal: API error - ${response.message}');
        setState(() {
          _isLoading = false;
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      debugPrint('💥 CreateCategoryModal: Exception - $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }
}

// ====================================================================
// EDIT CATEGORY MODAL WIDGET - Pre-populated form for editing categories
// ====================================================================

/// EditCategoryModalWidget - Modal for editing existing categories
class EditCategoryModalWidget extends StatefulWidget {
  final ServiceCategory category;
  final VoidCallback onCategoryUpdated;
  final ServiceManagementService serviceManagementService;

  const EditCategoryModalWidget({
    super.key,
    required this.category,
    required this.onCategoryUpdated,
    required this.serviceManagementService,
  });

  @override
  State<EditCategoryModalWidget> createState() => _EditCategoryModalWidgetState();
}

class _EditCategoryModalWidgetState extends State<EditCategoryModalWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sortOrderController;

  late bool _isActive;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Pre-populate form with existing category data
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(text: widget.category.description);
    _sortOrderController = TextEditingController(text: widget.category.sortOrder.toString());
    _isActive = widget.category.isActive;

    debugPrint('✏️ EditCategoryModal: Initialized with category: ${widget.category.name}');
    debugPrint('✏️ → Name: ${widget.category.name}');
    debugPrint('✏️ → Description: ${widget.category.description}');
    debugPrint('✏️ → Sort Order: ${widget.category.sortOrder}');
    debugPrint('✏️ → Is Active: ${widget.category.isActive}');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? [const Color(0xFF374151), const Color(0xFF1F2937)] : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              width: 60.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.blue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  LineIcons.edit,
                  color: Colors.blue,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Category',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      'Modify "${widget.category.name}" details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    LineIcons.times,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Error message
          if (_errorMessage != null)
            Container(
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withValues(alpha: 0.1),
                    Colors.red.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(LineIcons.exclamationTriangle, color: Colors.red, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Name field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Category Name *',
                        labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            LineIcons.tag,
                            color: Colors.blue,
                            size: 20.sp,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Category name is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Description field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            LineIcons.edit,
                            color: Colors.blue,
                            size: 20.sp,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Sort order field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: TextFormField(
                      controller: _sortOrderController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Sort Order',
                        labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            LineIcons.sort,
                            color: Colors.blue,
                            size: 20.sp,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        helperText: 'Lower numbers appear first',
                        helperStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                          fontSize: 12.sp,
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final sortOrder = int.tryParse(value);
                          if (sortOrder == null || sortOrder < 0) {
                            return 'Must be a positive number';
                          }
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Active status switch
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (_isActive ? Colors.green : Colors.orange).withValues(alpha: 0.2),
                                (_isActive ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            _isActive ? LineIcons.checkCircle : LineIcons.pauseCircle,
                            color: _isActive ? Colors.green : Colors.orange,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Status',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _isActive
                                    ? 'Category is visible and available to users'
                                    : 'Category is hidden from users',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isActive,
                          onChanged: (value) => setState(() => _isActive = value),
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blue.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LineIcons.save,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Update Category',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Update category using the service management service
  Future<void> _updateCategory() async {
    debugPrint('🔄 EditCategoryModal: Starting category update for: ${widget.category.name}');

    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ EditCategoryModal: Form validation failed');
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final sortOrderText = _sortOrderController.text.trim();
    final sortOrder =
        sortOrderText.isEmpty ? widget.category.sortOrder : int.tryParse(sortOrderText) ?? widget.category.sortOrder;

    // Check if anything actually changed
    final hasChanges = name != widget.category.name ||
        description != widget.category.description ||
        sortOrder != widget.category.sortOrder ||
        _isActive != widget.category.isActive;

    if (!hasChanges) {
      debugPrint('ℹ️ EditCategoryModal: No changes detected, closing modal');
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      debugPrint('🔄 EditCategoryModal: Calling updateCategory API');
      debugPrint('🔄 → Category ID: ${widget.category.id}');
      debugPrint('🔄 → New Name: $name');
      debugPrint('🔄 → New Description: $description');
      debugPrint('🔄 → New Sort Order: $sortOrder');
      debugPrint('🔄 → New Active Status: $_isActive');

      final response = await widget.serviceManagementService.updateCategory(
        categoryId: widget.category.id,
        name: name,
        description: description,
        sortOrder: sortOrder,
        isActive: _isActive,
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('✅ EditCategoryModal: Category updated successfully');
        debugPrint('✅ → Updated Category: ${response.data!.name}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(LineIcons.checkCircle, color: Colors.white, size: 20.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Category "${response.data!.name}" updated successfully!',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              margin: EdgeInsets.all(16.w),
            ),
          );
        }

        widget.onCategoryUpdated();
        Navigator.of(context).pop();
      } else {
        debugPrint('❌ EditCategoryModal: API error - ${response.message}');
        setState(() {
          _isLoading = false;
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      debugPrint('💥 EditCategoryModal: Exception - $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }
}
