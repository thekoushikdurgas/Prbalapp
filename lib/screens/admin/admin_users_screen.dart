import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
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
                  Row(
                    children: [
                      Text(
                        'User Management',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Export user data
                        },
                        icon: Icon(
                          LineIcons.download,
                          color:
                              isDark ? Colors.white : const Color(0xFF4A5568),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2D2D2D)
                          : const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _searchController,
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
                  ),

                  SizedBox(height: 16.h),

                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2D2D2D)
                          : const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFF8B5CF6),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          isDark ? Colors.grey[400] : Colors.grey[600],
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'All Users'),
                        Tab(text: 'Providers'),
                        Tab(text: 'Customers'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Filters
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: SizedBox(
                height: 40.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip('All', _selectedFilter == 'All', isDark),
                    SizedBox(width: 8.w),
                    _buildFilterChip(
                        'Verified', _selectedFilter == 'Verified', isDark),
                    SizedBox(width: 8.w),
                    _buildFilterChip(
                        'Pending', _selectedFilter == 'Pending', isDark),
                    SizedBox(width: 8.w),
                    _buildFilterChip(
                        'Suspended', _selectedFilter == 'Suspended', isDark),
                    SizedBox(width: 8.w),
                    _buildFilterChip('New', _selectedFilter == 'New', isDark),
                  ],
                ),
              ),
            ),

            // User List
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUserList('all', isDark),
                  _buildUserList('provider', isDark),
                  _buildUserList('customer', isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
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

  Widget _buildUserList(String userType, bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 20, // Mock data
      itemBuilder: (context, index) {
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

  Widget _buildUserCard(int index, String userType, bool isDark) {
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

    Color statusColor;
    switch (status) {
      case 'verified':
        statusColor = const Color(0xFF10B981);
        break;
      case 'pending':
        statusColor = const Color(0xFFF59E0B);
        break;
      case 'suspended':
        statusColor = const Color(0xFFEF4444);
        break;
      default:
        statusColor = const Color(0xFF6B7280);
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24.r,
            backgroundColor: isProvider
                ? const Color(0xFF10B981).withValues(alpha: 0.1)
                : const Color(0xFF3B82F6).withValues(alpha: 0.1),
            child: Icon(
              isProvider ? LineIcons.tools : LineIcons.user,
              color: isProvider
                  ? const Color(0xFF10B981)
                  : const Color(0xFF3B82F6),
              size: 20.sp,
            ),
          ),

          SizedBox(width: 12.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

          // Actions
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle action
              switch (value) {
                case 'view':
                  _showUserDetails(user, isDark);
                  break;
                case 'verify':
                  // Verify user
                  break;
                case 'suspend':
                  // Suspend user
                  break;
                case 'delete':
                  // Delete user
                  break;
              }
            },
            itemBuilder: (context) => [
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

  void _showUserDetails(Map<String, String?> user, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Title
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
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      LineIcons.times,
                      color:
                          isDark ? Colors.grey[400] : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User profile info would go here
                    Text(
                      'Name: ${user['name']}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Type: ${user['type']}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    if (user['service'] != null) ...[
                      SizedBox(height: 8.h),
                      Text(
                        'Service: ${user['service']}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color:
                              isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                    ],
                    // Add more user details here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
