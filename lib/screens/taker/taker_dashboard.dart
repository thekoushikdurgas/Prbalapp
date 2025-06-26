import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/utils/navigation/routes/route_enum.dart';

/// Full Taker Dashboard with bottom navigation bar
/// Use this for direct route access
class TakerDashboard extends ConsumerStatefulWidget {
  const TakerDashboard({super.key});

  @override
  ConsumerState<TakerDashboard> createState() => _TakerDashboardState();
}

class _TakerDashboardState extends ConsumerState<TakerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const TakerDashboardContent(),
    );
  }
}

/// Content-only Taker Dashboard without bottom navigation
/// Use this within BottomNavigation to prevent circular dependency
class TakerDashboardContent extends ConsumerStatefulWidget {
  const TakerDashboardContent({super.key});

  @override
  ConsumerState<TakerDashboardContent> createState() =>
      _TakerDashboardContentState();
}

class _TakerDashboardContentState extends ConsumerState<TakerDashboardContent> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _promoController = PageController();

  @override
  void dispose() {
    _searchController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            backgroundColor: themeManager.surfaceColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
              title: Text(
                'Find Services',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: themeManager.surfaceGradient,
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
                  Prbal.bell,
                  color: themeManager.textPrimary,
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
                      color: themeManager.inputBackground,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: themeManager.themeManager
                              ? Colors.black.withValues(alpha: 77)
                              : Colors.grey.withValues(alpha: 26),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'What service do you need?',
                        hintStyle: TextStyle(
                          color: themeManager.textSecondary,
                          fontSize: 16.sp,
                        ),
                        prefixIcon: Icon(
                          Prbal.search,
                          color: themeManager.textSecondary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // Navigate to explore with search
                            context.go('/explore');
                          },
                          icon: Icon(
                            Prbal.arrowRight,
                            color: themeManager.primaryColor,
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

                  // Promotional Banner
                  Container(
                    height: 150.h, // Increased height to accommodate content
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: themeManager.themeManager
                              ? Colors.black.withValues(alpha: 77)
                              : Colors.grey.withValues(alpha: 26),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: PageView(
                      controller: _promoController,
                      children: [
                        _buildPromoBanner(
                          'New User Special',
                          '50% OFF your first service',
                          'Use code: WELCOME50',
                          themeManager.primaryColor,
                          themeManager,
                        ),
                        _buildPromoBanner(
                          'Weekend Deal',
                          'Home cleaning starting at \$30',
                          'Book now for this weekend',
                          themeManager.successColor,
                          themeManager,
                        ),
                        _buildPromoBanner(
                          'Emergency Services',
                          '24/7 urgent repairs available',
                          'Quick response guaranteed',
                          themeManager.warningColor,
                          themeManager,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Service Categories
                  Row(
                    children: [
                      Text(
                        'Popular Services',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: themeManager.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          context.push('/explore');
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: themeManager.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Service Categories Grid
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 1.2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildServiceCard(
                        'Home Cleaning',
                        Prbal.home1,
                        themeManager.primaryColor,
                        '150+ providers',
                        themeManager,
                      ),
                      _buildServiceCard(
                        'Plumbing',
                        Prbal.tools,
                        themeManager.successColor,
                        '89+ providers',
                        themeManager,
                      ),
                      _buildServiceCard(
                        'Electrical',
                        Prbal.plug,
                        themeManager.warningColor,
                        '67+ providers',
                        themeManager,
                      ),
                      _buildServiceCard(
                        'Gardening',
                        Prbal.leaf,
                        themeManager.infoColor,
                        '45+ providers',
                        themeManager,
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Recent Activity
                  Row(
                    children: [
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: themeManager.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          context.push('/orders');
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: themeManager.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Activity List
                  Container(
                    decoration: BoxDecoration(
                      color: themeManager.surfaceColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: themeManager.themeManager
                              ? Colors.black.withValues(alpha: 77)
                              : Colors.grey.withValues(alpha: 26),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildActivityItem(
                          'Home cleaning completed',
                          '2 hours ago',
                          Prbal.checkCircle,
                          themeManager.successColor,
                          themeManager,
                        ),
                        _buildActivityItem(
                          'Payment processed',
                          '5 hours ago',
                          Prbal.dollarSign,
                          themeManager.primaryColor,
                          themeManager,
                        ),
                        _buildActivityItem(
                          'Service reviewed',
                          '1 day ago',
                          Prbal.star,
                          themeManager.warningColor,
                          themeManager,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(
    String title,
    String subtitle,
    String action,
    Color color,
    ThemeManager themeManager,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 179), // 0.7 opacity
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withValues(alpha: 230), // 0.9 opacity
              ),
            ),
            const Spacer(),
            Text(
              action,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    IconData icon,
    Color color,
    String subtitle,
    ThemeManager themeManager,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Navigate to service category
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 26), // 0.1 opacity
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
                    color: themeManager.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: themeManager.textSecondary,
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
    String time,
    IconData icon,
    Color color,
    ThemeManager themeManager,
  ) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 26), // 0.1 opacity
          borderRadius: BorderRadius.circular(10.r),
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
          color: themeManager.textPrimary,
        ),
      ),
      subtitle: Text(
        time,
        style: TextStyle(
          fontSize: 12.sp,
          color: themeManager.textSecondary,
        ),
      ),
      trailing: Icon(
        Prbal.angleRight,
        color: themeManager.textSecondary,
        size: 16.sp,
      ),
    );
  }
}
