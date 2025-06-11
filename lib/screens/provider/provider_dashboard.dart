import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:go_router/go_router.dart';
// import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';

/// Full Provider Dashboard with bottom navigation bar
/// Use this for direct route access
class ProviderDashboard extends ConsumerStatefulWidget {
  const ProviderDashboard({super.key});

  @override
  ConsumerState<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends ConsumerState<ProviderDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ProviderDashboardContent(),
    );
  }
}

/// Content-only Provider Dashboard without bottom navigation
/// Use this within BottomNavigation to prevent circular dependency
class ProviderDashboardContent extends ConsumerStatefulWidget {
  const ProviderDashboardContent({super.key});

  @override
  ConsumerState<ProviderDashboardContent> createState() => _ProviderDashboardContentState();
}

class _ProviderDashboardContentState extends ConsumerState<ProviderDashboardContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120.h,
              floating: false,
              pinned: true,
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
                title: Text(
                  'Provider Dashboard',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF1E1E1E), const Color(0xFF2D2D2D)]
                          : [Colors.white, const Color(0xFFF7FAFC)],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // Navigate to notifications
                    context.push('/notifications');
                  },
                  icon: Icon(
                    LineIcons.bell,
                    color: isDark ? Colors.white : const Color(0xFF4A5568),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search services or customers...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 16.sp,
                          ),
                          prefixIcon: Icon(
                            LineIcons.search,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              // Navigate to explore with filters
                              context.go('/explore');
                            },
                            icon: Icon(
                              Icons.tune,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Quick Stats
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              'Active Services',
                              '12',
                              LineIcons.tools,
                              const Color(0xFF4299E1),
                              isDark,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40.h,
                            color: isDark ? Colors.grey[700] : Colors.grey[300],
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Pending Requests',
                              '5',
                              LineIcons.clock,
                              const Color(0xFFED8936),
                              isDark,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40.h,
                            color: isDark ? Colors.grey[700] : Colors.grey[300],
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Rating',
                              '4.8',
                              LineIcons.star,
                              const Color(0xFF48BB78),
                              isDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Service Categories
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Service Categories',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Categories Grid
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 1.2,
                      ),
                      children: [
                        _buildCategoryCard(
                          'Home Cleaning',
                          LineIcons.broom,
                          const Color(0xFF4299E1),
                          '8 active listings',
                          isDark,
                          onTap: () {
                            // Navigate to cleaning services
                            context.push('/services/cleaning');
                          },
                        ),
                        _buildCategoryCard(
                          'Plumbing',
                          LineIcons.tools,
                          const Color(0xFF48BB78),
                          '3 active listings',
                          isDark,
                          onTap: () {
                            // Navigate to plumbing services
                            context.push('/services/plumbing');
                          },
                        ),
                        _buildCategoryCard(
                          'Electrical',
                          LineIcons.plug,
                          const Color(0xFFED8936),
                          '2 active listings',
                          isDark,
                          onTap: () {
                            // Navigate to electrical services
                            context.push('/services/electrical');
                          },
                        ),
                        _buildCategoryCard(
                          'Add New',
                          LineIcons.plus,
                          const Color(0xFF9F7AEA),
                          'Create service',
                          isDark,
                          onTap: () {
                            // Navigate to add service
                            context.push('/services/add');
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Recent Activity
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Activity',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to full activity
                                    context.push('/activity');
                                  },
                                  child: Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: const Color(0xFF4299E1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildActivityItem(
                            'New booking request',
                            'John Doe requested home cleaning',
                            '2 hours ago',
                            LineIcons.calendar,
                            const Color(0xFF4299E1),
                            isDark,
                          ),
                          const Divider(height: 1),
                          _buildActivityItem(
                            'Payment received',
                            'Received \$150 from Sarah Smith',
                            '5 hours ago',
                            LineIcons.dollarSign,
                            const Color(0xFF48BB78),
                            isDark,
                          ),
                          const Divider(height: 1),
                          _buildActivityItem(
                            'Review received',
                            'Mike Johnson left a 5-star review',
                            '1 day ago',
                            LineIcons.star,
                            const Color(0xFFED8936),
                            isDark,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24.sp,
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color color,
    String subtitle,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap ??
              () {
                // Default navigation
              },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return ListTile(
      leading: Container(
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
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF2D3748),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 11.sp,
          color: isDark ? Colors.grey[500] : Colors.grey[500],
        ),
      ),
    );
  }
}
