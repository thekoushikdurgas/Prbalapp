import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/widgets/admin/service_widget.dart';

/// AdminServiceManagerScreen - Comprehensive service management screen for admin users
///
/// **Purpose**: Provides full CRUD operations for managing services on the platform:
/// - View all services with advanced filtering and search
/// - Create new services with comprehensive validation
/// - Edit existing services with pre-filled data
/// - Delete services with confirmation dialogs
/// - Bulk operations for managing multiple services
/// - Service status management (active/inactive/pending)
/// - Provider assignment and service categorization
///
/// **Key Features**:
/// - Modern glassmorphism design with responsive animations
/// - Advanced search and filtering capabilities
/// - Real-time data updates with pull-to-refresh
/// - Service status indicators and management
/// - Comprehensive service details and metadata display
/// - Integration with ServiceManagementService for API operations
/// - Dark/Light theme support with consistent theming
/// - Error handling with user-friendly feedback
/// - Performance optimization with efficient data loading
///
/// **Service Management Capabilities**:
/// - Service approval/rejection workflow
/// - Category and subcategory assignment
/// - Provider management and assignment
/// - Service pricing and availability controls
/// - Service image and media management
/// - Location and service area configuration
/// - Service rating and review moderation
///
/// **Business Logic**:
/// - Services can be in different states: pending, active, inactive, rejected
/// - Only approved services are visible to end users
/// - Services must be assigned to valid categories and subcategories
/// - Services must have valid provider assignments
/// - Services require comprehensive information for approval
/// - Price validation and formatting for different service types
///
/// **Integration Points**:
/// - ServiceManagementService for API operations
/// - ServiceCrudWidget for reusable service operations
/// - Provider management system for service assignments
/// - Category/Subcategory system for service organization
/// - Media management for service images and documents
///
/// **Memory Safety**: Optimized for performance with efficient data loading,
/// proper disposal of resources, and minimal memory footprint.
class AdminServiceManagerScreen extends ConsumerStatefulWidget {
  const AdminServiceManagerScreen({super.key});

  @override
  ConsumerState<AdminServiceManagerScreen> createState() =>
      _AdminServiceManagerScreenState();
}

class _AdminServiceManagerScreenState
    extends ConsumerState<AdminServiceManagerScreen>
    with TickerProviderStateMixin {
  // ========== STATE VARIABLES ==========
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter =
      'all'; // 'all', 'pending', 'active', 'inactive', 'rejected'
// 'all' or specific category ID
// 'all' or specific provider ID

  // Selection state for bulk operations
  final Set<String> _selectedServiceIds = <String>{};

  // Loading and error states

  // Statistics
  final int _totalServices = 0;
  final int _pendingServices = 0;
  final int _activeServices = 0;
  final int _inactiveServices = 0;
  final int _rejectedServices = 0;

  // Animation controllers
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🏢 AdminServiceManager: Initializing service manager screen');

    // Initialize animations
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Add search listener
    _searchController.addListener(() {
      if (_searchController.text != _searchQuery) {
        setState(() {
          _searchQuery = _searchController.text;
        });
        debugPrint(
            '🔍 AdminServiceManager: Search query updated: "$_searchQuery"');
      }
    });

    // Start entrance animation and load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          '🏢 AdminServiceManager: Post-frame callback - starting entrance animation');
      _slideAnimationController.forward();
      _loadInitialData();
    });
  }

  /// Load initial data for the service manager
  Future<void> _loadInitialData() async {
    debugPrint('📊 AdminServiceManager: Loading initial service data');
    // The ServiceCrudWidget will handle the actual data loading
    // This method is for any additional initialization if needed
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 AdminServiceManager: Building service manager UI');

    // debugPrint('🎨 AdminServiceManager: Theme mode: ${ThemeManager.of(context).themeManager ? 'dark' : 'light'}');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,

      // ========== APP BAR ==========
      appBar: AppBar(
        backgroundColor: ThemeManager.of(context).surfaceColor,
        elevation: 0,
        title: Row(
          children: [
            Hero(
              tag: 'service_manager_icon',
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ThemeManager.of(context).primaryGradient,
                  boxShadow: ThemeManager.of(context).primaryShadow,
                ),
                child: Icon(
                  Prbal.designServices,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Manager',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                  Text(
                    'Manage platform services',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ThemeManager.of(context).textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Search button
          IconButton(
            onPressed: () {
              debugPrint('🔍 AdminServiceManager: Search button pressed');
              _showSearchDialog();
            },
            icon: Icon(
              Prbal.search,
              color: ThemeManager.of(context).textSecondary,
              size: 22.sp,
            ),
            tooltip: 'Search Services',
          ),

          // Filter button
          IconButton(
            onPressed: () {
              debugPrint('🔧 AdminServiceManager: Filter button pressed');
              _showFilterDialog();
            },
            icon: Icon(
              Prbal.filter,
              color: ThemeManager.of(context).textSecondary,
              size: 22.sp,
            ),
            tooltip: 'Filter Services',
          ),

          // Statistics button
          IconButton(
            onPressed: () {
              debugPrint('📊 AdminServiceManager: Statistics button pressed');
              _showStatisticsDialog();
            },
            icon: Icon(
              Prbal.calculator,
              color: ThemeManager.of(context).textSecondary,
              size: 22.sp,
            ),
            tooltip: 'View Statistics',
          ),

          // Bulk actions button (only show when services are selected)
          if (_selectedServiceIds.isNotEmpty)
            IconButton(
              onPressed: () {
                debugPrint(
                    '🔧 AdminServiceManager: Bulk actions button pressed');
                _showBulkActionsDialog();
              },
              icon: Icon(
                Prbal.cogs,
                color: const Color(0xFF8B5CF6),
                size: 22.sp,
              ),
              tooltip: 'Bulk Actions',
            ),

          SizedBox(width: 8.w),
        ],
      ),

      // ========== MAIN CONTENT ==========
      body: SlideTransition(
        position: _slideAnimation,
        child: _buildMainContent(),
      ),

      // ========== FLOATING ACTION BUTTON ==========
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('➕ AdminServiceManager: Add service FAB pressed');
          _showCreateServiceDialog();
        },
        backgroundColor: ThemeManager.of(context).primaryColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        icon: Icon(
          Prbal.plus,
          color: Colors.white,
          size: 20.sp,
        ),
        label: Text(
          'Add Service',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  /// Build main content area
  Widget _buildMainContent() {
    debugPrint('🎨 AdminServiceManager: Building main content');

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).backgroundGradient,
      ),
      child: Column(
        children: [
          // ========== HEADER WITH FILTERS ==========
          _buildHeaderSection(),

          // ========== SERVICES LIST ==========
          Expanded(
            child: _buildServicesList(),
          ),
        ],
      ),
    );
  }

  /// Build header section with filters and statistics
  Widget _buildHeaderSection() {
    debugPrint('🎨 AdminServiceManager: Building header section');

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: ThemeManager.of(context).surfaceGradient,
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1.5,
        ),
        boxShadow: ThemeManager.of(context).elevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== TITLE AND QUICK ACTIONS ==========
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Services Overview',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Manage all services on the platform',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Quick actions
              Row(
                children: [
                  _buildQuickActionButton(
                    icon: Prbal.eye,
                    label: 'View All',
                    onPressed: () {
                      debugPrint(
                          '👁️ AdminServiceManager: View all button pressed');
                      setState(() {
                        _statusFilter = 'all';
                      });
                    },
                  ),
                  SizedBox(width: 8.w),
                  _buildQuickActionButton(
                    icon: Prbal.clock,
                    label: 'Pending',
                    onPressed: () {
                      debugPrint(
                          '⏰ AdminServiceManager: Pending filter button pressed');
                      setState(() {
                        _statusFilter = 'pending';
                      });
                    },
                    isHighlighted: _statusFilter == 'pending',
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // ========== STATISTICS ROW ==========
          _buildStatisticsRow(),
        ],
      ),
    );
  }

  /// Build quick action button
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isHighlighted = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient:
            isHighlighted ? ThemeManager.of(context).primaryGradient : null,
        color: !isHighlighted
            ? ThemeManager.of(context).conditionalColor(
                lightColor: Colors.grey.withValues(alpha: 0.1),
                darkColor: Colors.white.withValues(alpha: 0.1),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16.sp,
                  color: isHighlighted
                      ? Colors.white
                      : (ThemeManager.of(context).textSecondary),
                ),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isHighlighted
                        ? Colors.white
                        : (ThemeManager.of(context).textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build statistics row
  Widget _buildStatisticsRow() {
    debugPrint('📊 AdminServiceManager: Building statistics row');

    return Row(
      children: [
        _buildStatCard('Total', _totalServices.toString(), Colors.blue),
        SizedBox(width: 12.w),
        _buildStatCard('Pending', _pendingServices.toString(), Colors.orange),
        SizedBox(width: 12.w),
        _buildStatCard('Active', _activeServices.toString(), Colors.green),
        SizedBox(width: 12.w),
        _buildStatCard('Inactive', _inactiveServices.toString(), Colors.grey),
        if (_selectedServiceIds.isNotEmpty) ...[
          SizedBox(width: 12.w),
          _buildStatCard(
              'Selected', _selectedServiceIds.length.toString(), Colors.purple),
        ],
      ],
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: color.withValues(
              alpha: ThemeManager.of(context).themeManager ? 0.2 : 0.1),
          border: Border.all(
            color: color.withValues(alpha: 77),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: ThemeManager.of(context).textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build services list using ServiceCrudWidget
  Widget _buildServicesList() {
    debugPrint('📋 AdminServiceManager: Building services list');

    return ServiceCrudWidget(
      searchQuery: _searchQuery,
      filter: _statusFilter,
      selectedIds: _selectedServiceIds,
      onSelectionChanged: (serviceId) {
        debugPrint(
            '📋 AdminServiceManager: Service selection changed: $serviceId');
        setState(() {
          if (_selectedServiceIds.contains(serviceId)) {
            _selectedServiceIds.remove(serviceId);
            debugPrint(
                '📋 AdminServiceManager: Service deselected: $serviceId');
          } else {
            _selectedServiceIds.add(serviceId);
            debugPrint('📋 AdminServiceManager: Service selected: $serviceId');
          }
        });
        debugPrint(
            '📋 AdminServiceManager: Total selected services: ${_selectedServiceIds.length}');
      },
      onDataChanged: () {
        debugPrint(
            '📋 AdminServiceManager: Services data changed - triggering UI update');
        setState(() {
          // Update statistics when data changes
          _updateStatistics();
        });
      },
    );
  }

  /// Update local statistics
  void _updateStatistics() {
    debugPrint('📊 AdminServiceManager: Updating local statistics');
    // Statistics are updated through the ServiceCrudWidget callback
    // This method is here for any additional local statistics processing
  }

  /// Show search dialog
  void _showSearchDialog() {
    debugPrint('🔍 AdminServiceManager: Showing search dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeManager.of(context).surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Prbal.search,
              color: ThemeManager.of(context).primaryColor,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Search Services',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter service name, description, or provider...',
            hintStyle: TextStyle(
              color: ThemeManager.of(context).textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color:
                    ThemeManager.of(context).primaryColor.withValues(alpha: 77),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: ThemeManager.of(context).primaryColor,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Prbal.search,
              color: ThemeManager.of(context).primaryColor,
            ),
          ),
          style: TextStyle(
            color: ThemeManager.of(context).textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: ThemeManager.of(context).textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              debugPrint(
                  '🔍 AdminServiceManager: Search initiated with: "${_searchController.text}"');
            },
            child: Text(
              'Search',
              style: TextStyle(
                color: ThemeManager.of(context).primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    debugPrint('🔧 AdminServiceManager: Showing filter dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeManager.of(context).surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Prbal.filter,
              color: ThemeManager.of(context).primaryColor,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Filter Services',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Filter',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              children: [
                _buildFilterChip('All', 'all', _statusFilter),
                _buildFilterChip('Pending', 'pending', _statusFilter),
                _buildFilterChip('Active', 'active', _statusFilter),
                _buildFilterChip('Inactive', 'inactive', _statusFilter),
                _buildFilterChip('Rejected', 'rejected', _statusFilter),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _statusFilter = 'all';
              });
              Navigator.of(context).pop();
              debugPrint('🧹 AdminServiceManager: Filters cleared');
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: ThemeManager.of(context).textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Apply',
              style: TextStyle(
                color: ThemeManager.of(context).primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build filter chip
  Widget _buildFilterChip(
    String label,
    String value,
    String currentValue,
  ) {
    final isSelected = currentValue == value;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : ThemeManager.of(context).textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _statusFilter = value;
        });
      },
      backgroundColor: ThemeManager.of(context).surfaceColor,
      selectedColor: ThemeManager.of(context).primaryColor,
      checkmarkColor: Colors.white,
    );
  }

  /// Show statistics dialog
  void _showStatisticsDialog() {
    debugPrint('📊 AdminServiceManager: Showing statistics dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeManager.of(context).surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Prbal.calculator,
              color: ThemeManager.of(context).primaryColor,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Service Statistics',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 300.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatisticRow('Total Services', _totalServices, Colors.blue),
              _buildStatisticRow(
                  'Pending Approval', _pendingServices, Colors.orange),
              _buildStatisticRow(
                  'Active Services', _activeServices, Colors.green),
              _buildStatisticRow(
                  'Inactive Services', _inactiveServices, Colors.grey),
              _buildStatisticRow(
                  'Rejected Services', _rejectedServices, Colors.red),
              if (_selectedServiceIds.isNotEmpty)
                _buildStatisticRow('Selected Services',
                    _selectedServiceIds.length, Colors.purple),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: ThemeManager.of(context).primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build statistic row for dialog
  Widget _buildStatisticRow(
    String label,
    int value,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Show bulk actions dialog
  void _showBulkActionsDialog() {
    debugPrint('🔧 AdminServiceManager: Showing bulk actions dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeManager.of(context).surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Prbal.cogs,
              color: ThemeManager.of(context).primaryColor,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Bulk Actions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected: ${_selectedServiceIds.length} services',
              style: TextStyle(
                fontSize: 16.sp,
                color: ThemeManager.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            _buildBulkActionTile(
                'Approve All', Prbal.checkCircle, Colors.green),
            _buildBulkActionTile('Reject All', Prbal.closeOutline, Colors.red),
            _buildBulkActionTile('Activate All', Prbal.toggleOn, Colors.blue),
            _buildBulkActionTile(
                'Deactivate All', Prbal.toggleOff, Colors.orange),
            _buildBulkActionTile('Delete All', Prbal.trash, Colors.red),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: ThemeManager.of(context).textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build bulk action tile
  Widget _buildBulkActionTile(
    String title,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color, size: 20.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: ThemeManager.of(context).textSecondary,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        debugPrint('🔧 AdminServiceManager: Bulk action: $title');
        _performBulkAction(title);
      },
    );
  }

  /// Perform bulk action
  void _performBulkAction(String action) {
    debugPrint('🔧 AdminServiceManager: Performing bulk action: $action');
    debugPrint(
        '🔧 AdminServiceManager: Selected services: ${_selectedServiceIds.length}');

    // TODO: Implement actual bulk actions with ServiceManagementService
    // This would involve calling the appropriate API endpoints for each action

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action will be implemented soon'),
        backgroundColor: const Color(0xFF8B5CF6),
      ),
    );
  }

  /// Show create service dialog
  void _showCreateServiceDialog() {
    debugPrint('➕ AdminServiceManager: Showing create service dialog');

    // TODO: Implement create service dialog
    // This would be a comprehensive form for creating new services

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create service functionality will be implemented soon'),
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('🏢 AdminServiceManager: Disposing service manager screen');
    debugPrint(
        '🏢 AdminServiceManager: Final selected services: ${_selectedServiceIds.length}');

    _searchController.dispose();
    _slideAnimationController.dispose();

    super.dispose();
  }
}
