import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

/// Admin Users Management Screen
/// This screen provides comprehensive user management functionality including:
/// - User search and filtering
/// - Tab-based user categorization (All, Providers, Customers)
/// - User status management (verified, pending, suspended)
/// - Individual user actions and details
class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen>
    with TickerProviderStateMixin {
  // ========== STATE VARIABLES ==========
  late TabController
      _tabController; // Controls the user type tabs (All/Providers/Customers)
  final TextEditingController _searchController =
      TextEditingController(); // Search input controller
  String _selectedFilter =
      'All'; // Currently selected filter (All/Verified/Pending/Suspended/New)

  @override
  void initState() {
    super.initState();
    debugPrint('👥 AdminUsersScreen: Initializing user management screen');

    // Initialize tab controller with 3 tabs (All Users, Providers, Customers)
    _tabController = TabController(length: 3, vsync: this);
    debugPrint('👥 AdminUsersScreen: Tab controller initialized with 3 tabs');

    // Add listener to track tab changes for debugging
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        debugPrint(
            '👥 AdminUsersScreen: Tab changed to index ${_tabController.index}');
        final tabNames = ['All Users', 'Providers', 'Customers'];
        debugPrint(
            '👥 AdminUsersScreen: Now viewing ${tabNames[_tabController.index]} tab');
      }
    });

    // Add listener to search controller for real-time search tracking
    _searchController.addListener(() {
      debugPrint(
          '🔍 AdminUsersScreen: Search query changed: "${_searchController.text}"');
    });
  }

  @override
  void dispose() {
    debugPrint('👥 AdminUsersScreen: Disposing user management screen');
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get current theme for consistent styling across the screen
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint('👥 AdminUsersScreen: Building user management interface');
    debugPrint('👥 AdminUsersScreen: Dark mode: $isDark');
    debugPrint('👥 AdminUsersScreen: Current filter: $_selectedFilter');

    return Scaffold(
      // Adaptive background color based on theme
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // ========== HEADER SECTION ==========
            // Contains title, search bar, and tab navigation
            _buildHeaderSection(isDark),

            // ========== FILTER CHIPS SECTION ==========
            // Horizontal scrollable filter options
            _buildFilterSection(isDark),

            // ========== USER LIST SECTION ==========
            // Tab-based user listing with different categories
            _buildUserListSection(isDark),
          ],
        ),
      ),
    );
  }

  // ========== HEADER SECTION BUILDER ==========
  /// Builds the top section containing title, export button, search bar, and tabs
  /// This section provides the main navigation and search functionality
  Widget _buildHeaderSection(bool isDark) {
    debugPrint('👥 AdminUsersScreen: Building header section');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ========== TITLE AND EXPORT ROW ==========
          Row(
            children: [
              Text(
                'User Management',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              // Export functionality for user data
              IconButton(
                onPressed: () {
                  debugPrint('📤 AdminUsersScreen: Export button pressed');
                  debugPrint(
                      '📤 AdminUsersScreen: Preparing user data export...');
                  // TODO: Implement user data export functionality
                  // This could export to CSV, Excel, or PDF format
                },
                icon: Icon(
                  LineIcons.download,
                  color: isDark ? Colors.white : const Color(0xFF4A5568),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ========== SEARCH BAR ==========
          // Real-time search functionality for user filtering
          _buildSearchBar(isDark),

          SizedBox(height: 16.h),

          // ========== TAB BAR ==========
          // User type categorization tabs
          _buildTabBar(isDark),
        ],
      ),
    );
  }

  // ========== SEARCH BAR BUILDER ==========
  /// Builds the search input field with proper theming and functionality
  Widget _buildSearchBar(bool isDark) {
    debugPrint('👥 AdminUsersScreen: Building search bar');

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          debugPrint('🔍 AdminUsersScreen: Search input changed: "$value"');
          // TODO: Implement real-time search filtering
          // This could filter users by name, email, phone, or ID
        },
        decoration: InputDecoration(
          hintText: 'Search users...',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 16.sp,
          ),
          prefixIcon: Icon(
            LineIcons.search,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }

  // ========== TAB BAR BUILDER ==========
  /// Builds the user type categorization tab bar
  Widget _buildTabBar(bool isDark) {
    debugPrint('👥 AdminUsersScreen: Building tab bar');

    return Container(
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
          debugPrint('👥 AdminUsersScreen: Tab tapped: index $index');
          final tabNames = ['All Users', 'Providers', 'Customers'];
          debugPrint('👥 AdminUsersScreen: Switched to ${tabNames[index]} tab');
        },
        tabs: const [
          Tab(text: 'All Users'), // Shows all user types
          Tab(text: 'Providers'), // Shows only service providers
          Tab(text: 'Customers'), // Shows only customers/takers
        ],
      ),
    );
  }

  // ========== FILTER SECTION BUILDER ==========
  /// Builds the horizontal scrollable filter chips for user status filtering
  Widget _buildFilterSection(bool isDark) {
    debugPrint('👥 AdminUsersScreen: Building filter section');
    debugPrint(
        '👥 AdminUsersScreen: Current selected filter: $_selectedFilter');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: SizedBox(
        height: 40.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // Filter options for different user states
            _buildFilterChip('All', _selectedFilter == 'All', isDark),
            SizedBox(width: 8.w),
            _buildFilterChip('Verified', _selectedFilter == 'Verified', isDark),
            SizedBox(width: 8.w),
            _buildFilterChip('Pending', _selectedFilter == 'Pending', isDark),
            SizedBox(width: 8.w),
            _buildFilterChip(
                'Suspended', _selectedFilter == 'Suspended', isDark),
            SizedBox(width: 8.w),
            _buildFilterChip('New', _selectedFilter == 'New', isDark),
          ],
        ),
      ),
    );
  }

  // ========== USER LIST SECTION BUILDER ==========
  /// Builds the tab view containing different user lists
  Widget _buildUserListSection(bool isDark) {
    debugPrint('👥 AdminUsersScreen: Building user list section');

    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildUserList('all', isDark), // All users regardless of type
          _buildUserList('provider', isDark), // Service providers only
          _buildUserList('customer', isDark), // Customers/takers only
        ],
      ),
    );
  }

  // ========== FILTER CHIP BUILDER ==========
  /// Builds individual filter chips for status filtering
  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        debugPrint('🏷️ AdminUsersScreen: Filter chip tapped: $label');
        debugPrint('🏷️ AdminUsersScreen: Previous filter: $_selectedFilter');
        setState(() {
          _selectedFilter = label;
        });
        debugPrint('🏷️ AdminUsersScreen: New filter: $_selectedFilter');
        // TODO: Implement actual filtering logic based on selected filter
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          // Visual feedback for selected/unselected state
          color: isSelected
              ? const Color(0xFF8B5CF6)
              : (isDark ? const Color(0xFF2D2D2D) : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : const Color(0xFF2D3748)),
          ),
        ),
      ),
    );
  }

  // ========== USER LIST BUILDER ==========
  /// Builds the scrollable list of users based on type and filters
  Widget _buildUserList(String userType, bool isDark) {
    debugPrint('👥 AdminUsersScreen: Building user list for type: $userType');
    debugPrint('👥 AdminUsersScreen: Applied filter: $_selectedFilter');

    // TODO: Replace with actual API call to fetch users
    // This should filter based on userType and _selectedFilter
    const int mockUserCount = 20;

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: mockUserCount,
      itemBuilder: (context, index) {
        debugPrint(
            '👥 AdminUsersScreen: Building user card $index for $userType users');

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildUserCard(index, userType, isDark),
        );
      },
    );
  }

  // ========== USER CARD BUILDER ==========
  /// Builds individual user cards with all user information and actions
  Widget _buildUserCard(int index, String userType, bool isDark) {
    // ========== MOCK DATA ==========
    // TODO: Replace with actual user data from API
    final users = [
      {'name': 'Sarah Johnson', 'type': 'provider', 'service': 'Home Cleaning'},
      {'name': 'Mike Wilson', 'type': 'provider', 'service': 'AC Repair'},
      {'name': 'John Smith', 'type': 'customer', 'service': null},
      {'name': 'Lisa Brown', 'type': 'provider', 'service': 'Garden Care'},
      {'name': 'David Lee', 'type': 'customer', 'service': null},
    ];

    final statuses = [
      'verified',
      'pending',
      'suspended',
      'verified',
      'verified'
    ];
    final user = users[index % users.length];
    final status = statuses[index % statuses.length];
    final isProvider = user['type'] == 'provider';

    debugPrint(
        '👥 AdminUsersScreen: Building card for ${user['name']} (${user['type']}, $status)');

    // ========== STATUS COLOR MAPPING ==========
    Color statusColor;
    switch (status) {
      case 'verified':
        statusColor = const Color(0xFF10B981); // Green for verified
        break;
      case 'pending':
        statusColor = const Color(0xFFF59E0B); // Orange for pending
        break;
      case 'suspended':
        statusColor = const Color(0xFFEF4444); // Red for suspended
        break;
      default:
        statusColor = const Color(0xFF6B7280); // Gray for unknown
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // ========== USER AVATAR ==========
          // Visual distinction between providers and customers
          CircleAvatar(
            radius: 24.r,
            backgroundColor: isProvider
                ? const Color(0xFF10B981)
                    .withValues(alpha: 0.1) // Green for providers
                : const Color(0xFF3B82F6)
                    .withValues(alpha: 0.1), // Blue for customers
            child: Icon(
              isProvider ? LineIcons.tools : LineIcons.user,
              color: isProvider
                  ? const Color(0xFF10B981)
                  : const Color(0xFF3B82F6),
              size: 20.sp,
            ),
          ),

          SizedBox(width: 12.w),

          // ========== USER INFORMATION ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and status row
                Row(
                  children: [
                    Text(
                      user['name']!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Status badge with appropriate color
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // User type and service information
                Row(
                  children: [
                    Text(
                      isProvider ? 'Provider' : 'Customer',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color:
                            isDark ? Colors.grey[400] : const Color(0xFF6B7280),
                      ),
                    ),
                    // Show service type for providers
                    if (isProvider && user['service'] != null) ...[
                      Text(
                        ' • ${user['service']}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark
                              ? Colors.grey[400]
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                // Registration date (mock data)
                Row(
                  children: [
                    Icon(
                      LineIcons.calendar,
                      size: 12.sp,
                      color:
                          isDark ? Colors.grey[500] : const Color(0xFF9CA3AF),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Joined ${index + 1} days ago',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color:
                            isDark ? Colors.grey[500] : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ========== ACTION MENU ==========
          // Context menu for user management actions
          PopupMenuButton<String>(
            onSelected: (value) {
              debugPrint(
                  '👥 AdminUsersScreen: Action selected for ${user['name']}: $value');
              _handleUserAction(value, user, status);
            },
            itemBuilder: (context) => [
              // View user details action
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(LineIcons.eye),
                    SizedBox(width: 8),
                    Text('View Details'),
                  ],
                ),
              ),
              // Verify action (only for pending users)
              if (status == 'pending')
                const PopupMenuItem(
                  value: 'verify',
                  child: Row(
                    children: [
                      Icon(LineIcons.checkCircle),
                      SizedBox(width: 8),
                      Text('Verify'),
                    ],
                  ),
                ),
              // Suspend action (only for non-suspended users)
              if (status != 'suspended')
                const PopupMenuItem(
                  value: 'suspend',
                  child: Row(
                    children: [
                      Icon(LineIcons.ban),
                      SizedBox(width: 8),
                      Text('Suspend'),
                    ],
                  ),
                ),
              // Delete action (always available, with warning styling)
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LineIcons.trash, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            child: Icon(
              LineIcons.verticalEllipsis,
              color: isDark ? Colors.grey[400] : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // ========== USER ACTION HANDLER ==========
  /// Handles all user management actions from the context menu
  void _handleUserAction(
      String action, Map<String, String?> user, String status) {
    debugPrint(
        '👥 AdminUsersScreen: Handling $action for user ${user['name']}');

    switch (action) {
      case 'view':
        debugPrint('👁️ AdminUsersScreen: Showing details for ${user['name']}');
        _showUserDetails(user);
        break;
      case 'verify':
        debugPrint('✅ AdminUsersScreen: Verifying user ${user['name']}');
        // TODO: Implement user verification API call
        break;
      case 'suspend':
        debugPrint('🚫 AdminUsersScreen: Suspending user ${user['name']}');
        // TODO: Implement user suspension API call
        break;
      case 'delete':
        debugPrint('🗑️ AdminUsersScreen: Deleting user ${user['name']}');
        // TODO: Implement user deletion with confirmation dialog
        break;
      default:
        debugPrint('❓ AdminUsersScreen: Unknown action: $action');
    }
  }

  // ========== USER DETAILS MODAL ==========
  /// Shows detailed user information in a bottom sheet modal
  void _showUserDetails(Map<String, String?> user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint(
        '👁️ AdminUsersScreen: Displaying user details modal for ${user['name']}');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allow full screen height
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            // ========== MODAL HANDLE ==========
            // Visual indicator for drag-to-close functionality
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // ========== MODAL HEADER ==========
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    'User Details',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      debugPrint(
                          '👁️ AdminUsersScreen: Closing user details modal');
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      LineIcons.times,
                      color:
                          isDark ? Colors.grey[400] : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            // ========== MODAL CONTENT ==========
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: Replace with comprehensive user profile display
                    // This should include: profile image, contact info, verification status,
                    // service history, ratings, reviews, etc.

                    _buildDetailRow('Name', user['name']!, isDark),
                    _buildDetailRow('Type', user['type']!, isDark),
                    if (user['service'] != null)
                      _buildDetailRow('Service', user['service']!, isDark),

                    // TODO: Add more comprehensive user details:
                    // - Email address
                    // - Phone number
                    // - Registration date
                    // - Last login
                    // - Verification documents
                    // - Service history
                    // - Ratings and reviews
                    // - Payment information
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== DETAIL ROW BUILDER ==========
  /// Builds a single row in the user details modal
  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 16.sp,
          color: isDark ? Colors.white : const Color(0xFF111827),
        ),
      ),
    );
  }
}
