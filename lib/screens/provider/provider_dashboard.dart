import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/utils/navigation/routes/route_enum.dart';

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
    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120.h,
              floating: false,
              pinned: true,
              backgroundColor: ThemeManager.of(context).surfaceColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
                title: Text(
                  'Provider Dashboard',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: ThemeManager.of(context).surfaceGradient,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // Navigate to notifications
                    context.push(RouteEnum.notifications.name);
                  },
                  icon: Icon(
                    Prbal.bell,
                    color: ThemeManager.of(context).textPrimary,
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
                        color: ThemeManager.of(context).inputBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: ThemeManager.of(context).subtleShadow,
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search services or customers...',
                          hintStyle: TextStyle(
                            color: ThemeManager.of(context).textSecondary,
                            fontSize: 16.sp,
                          ),
                          prefixIcon: Icon(
                            Prbal.search,
                            color: ThemeManager.of(context).textSecondary,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              // Navigate to explore with filters
                              context.go('/explore');
                            },
                            icon: Icon(
                              Prbal.tune,
                              color: ThemeManager.of(context).textSecondary,
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
                        color: ThemeManager.of(context).surfaceColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: ThemeManager.of(context).subtleShadow,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              'Active Services',
                              '12',
                              Prbal.tools,
                              ThemeManager.of(context).primaryColor,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40.h,
                            color: ThemeManager.of(context).borderColor,
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Pending Requests',
                              '5',
                              Prbal.clock,
                              ThemeManager.of(context).warningColor,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40.h,
                            color: ThemeManager.of(context).borderColor,
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Rating',
                              '4.8',
                              Prbal.star,
                              ThemeManager.of(context).successColor,
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
                          color: ThemeManager.of(context).textPrimary,
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
                          Prbal.home1,
                          ThemeManager.of(context).primaryColor,
                          '8 active listings',
                          onTap: () {
                            // Navigate to cleaning services
                            context.push('/services/cleaning');
                          },
                        ),
                        _buildCategoryCard(
                          'Plumbing',
                          Prbal.tools,
                          ThemeManager.of(context).successColor,
                          '3 active listings',
                          onTap: () {
                            // Navigate to plumbing services
                            context.push('/services/plumbing');
                          },
                        ),
                        _buildCategoryCard(
                          'Electrical',
                          Prbal.plug,
                          ThemeManager.of(context).warningColor,
                          '2 active listings',
                          onTap: () {
                            // Navigate to electrical services
                            context.push('/services/electrical');
                          },
                        ),
                        _buildCategoryCard(
                          'Add New',
                          Prbal.plus,
                          ThemeManager.of(context).secondaryColor,
                          'Create service',
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
                        color: ThemeManager.of(context).surfaceColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: ThemeManager.of(context).subtleShadow,
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
                                    color: ThemeManager.of(context).textPrimary,
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
                                      color: ThemeManager.of(context).primaryColor,
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
                            Prbal.calendar,
                            ThemeManager.of(context).primaryColor,
                          ),
                          const Divider(height: 1),
                          _buildActivityItem(
                            'Payment received',
                            'Received \$150 from Sarah Smith',
                            '5 hours ago',
                            Prbal.dollarSign,
                            ThemeManager.of(context).successColor,
                          ),
                          const Divider(height: 1),
                          _buildActivityItem(
                            'Review received',
                            'Mike Johnson left a 5-star review',
                            '1 day ago',
                            Prbal.star,
                            ThemeManager.of(context).warningColor,
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
            color: ThemeManager.of(context).textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: ThemeManager.of(context).textSecondary,
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
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
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
                    color: ThemeManager.of(context).textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ThemeManager.of(context).textSecondary,
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
          color: ThemeManager.of(context).textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: ThemeManager.of(context).textSecondary,
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 11.sp,
          color: ThemeManager.of(context).textSecondary,
        ),
      ),
    );
  }
}
