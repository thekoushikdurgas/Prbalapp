import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';
import 'package:prbal/components/bottom_navigation.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
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
                  'Admin Dashboard',
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
                    // Navigate to notifications - could be implemented as a feature route
                    context.push(RouteEnum.notifications.rawValue);
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

                    // System Status
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'System Status',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF2D3748),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF48BB78)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF48BB78),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'All Systems Operational',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF48BB78),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              _buildSystemMetric(
                                  'API Response',
                                  '99.9%',
                                  LineIcons.server,
                                  const Color(0xFF48BB78),
                                  isDark),
                              _buildSystemMetric(
                                  'Database',
                                  '100%',
                                  LineIcons.database,
                                  const Color(0xFF4299E1),
                                  isDark),
                              _buildSystemMetric(
                                  'Payment',
                                  '98.7%',
                                  LineIcons.creditCard,
                                  const Color(0xFF9F7AEA),
                                  isDark),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Key Metrics
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Total Users',
                            '12,450',
                            '+5.2% this week',
                            LineIcons.users,
                            const Color(0xFF4299E1),
                            isDark,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildMetricCard(
                            'Active Bookings',
                            '847',
                            '+12.3% today',
                            LineIcons.calendar,
                            const Color(0xFF48BB78),
                            isDark,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Revenue',
                            '\$45,230',
                            '+8.7% this month',
                            LineIcons.dollarSign,
                            const Color(0xFF9F7AEA),
                            isDark,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildMetricCard(
                            'Support Tickets',
                            '23',
                            '-15% this week',
                            LineIcons.headset,
                            const Color(0xFFED8936),
                            isDark,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Quick Actions
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 1.1,
                            children: [
                              _buildQuickActionCard(
                                'User\nManagement',
                                LineIcons.userEdit,
                                const Color(0xFF4299E1),
                                isDark,
                                onTap: () {
                                  // Navigate to users screen via bottom navigation
                                  context.go(RouteEnum.explore
                                      .rawValue); // This will show AdminUsersScreen
                                },
                              ),
                              _buildQuickActionCard(
                                'Service\nModeration',
                                LineIcons.lock,
                                const Color(0xFF48BB78),
                                isDark,
                                onTap: () {
                                  // Navigate to moderation screen
                                  context.go(RouteEnum.orders
                                      .rawValue); // This will show moderation screen
                                },
                              ),
                              _buildQuickActionCard(
                                'Payment\nIssues',
                                LineIcons.exclamationTriangle,
                                const Color(0xFFE53E3E),
                                isDark,
                                onTap: () {
                                  // Navigate to payments screen
                                  context.push(RouteEnum.payments.rawValue);
                                },
                              ),
                              _buildQuickActionCard(
                                'Analytics\nReports',
                                Icons.bar_chart,
                                const Color(0xFF9F7AEA),
                                isDark,
                                onTap: () {
                                  // Stay on current dashboard for analytics
                                  context.go(RouteEnum.home.rawValue);
                                },
                              ),
                              _buildQuickActionCard(
                                'System\nSettings',
                                LineIcons.cog,
                                const Color(0xFFED8936),
                                isDark,
                                onTap: () {
                                  // Navigate to settings
                                  context.go('/settings');
                                },
                              ),
                              _buildQuickActionCard(
                                'Backup\n& Security',
                                LineIcons.lock,
                                const Color(0xFF38B2AC),
                                isDark,
                                onTap: () {
                                  // Navigate to settings for backup/security
                                  context.go('/settings');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Recent Activity
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Row(
                              children: [
                                Text(
                                  'Recent Activity',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF2D3748),
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to full activity view
                                    context.push(
                                        '/admin-activity'); // Could be a feature route
                                  },
                                  child: Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4299E1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildActivityItem(
                            'New user registration',
                            'John Doe joined as a service provider',
                            '5 minutes ago',
                            LineIcons.userPlus,
                            const Color(0xFF48BB78),
                            isDark,
                          ),
                          const Divider(height: 1),
                          _buildActivityItem(
                            'Payment dispute resolved',
                            'Booking #12345 - \$150 dispute closed',
                            '15 minutes ago',
                            Icons.security,
                            const Color(0xFF4299E1),
                            isDark,
                          ),
                          const Divider(height: 1),
                          _buildActivityItem(
                            'Service verification completed',
                            'Mike Wilson - AC Repair service approved',
                            '1 hour ago',
                            LineIcons.checkCircle,
                            const Color(0xFF9F7AEA),
                            isDark,
                          ),
                          const Divider(height: 1),
                          _buildActivityItem(
                            'System maintenance',
                            'Database optimization completed',
                            '2 hours ago',
                            LineIcons.tools,
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
      bottomNavigationBar: const BottomNavigation(
        initialIndex: 0, // Admin Dashboard is the first tab
      ),
    );
  }

  Widget _buildSystemMetric(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
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
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String trend,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
              const Spacer(),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            trend,
            style: TextStyle(
              fontSize: 11.sp,
              color: trend.contains('+')
                  ? const Color(0xFF48BB78)
                  : const Color(0xFFE53E3E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap ??
            () {
              // Default action if no specific onTap provided
            },
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 24.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
