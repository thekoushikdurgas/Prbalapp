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
    return SafeArea(
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
                'Find Services',
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
                  context.push('/notifications');
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
                      boxShadow: [
                        BoxShadow(
                          color: ThemeManager.of(context).themeManager
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
                          color: ThemeManager.of(context).textSecondary,
                          fontSize: 16.sp,
                        ),
                        prefixIcon: Icon(
                          Prbal.search,
                          color: ThemeManager.of(context).textSecondary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // Navigate to explore with search
                            context.go('/explore');
                          },
                          icon: Icon(
                            Prbal.arrowRight,
                            color: ThemeManager.of(context).primaryColor,
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
                          color: ThemeManager.of(context).themeManager
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
                          ThemeManager.of(context).primaryColor,
                        ),
                        _buildPromoBanner(
                          'Weekend Deal',
                          'Home cleaning starting at \$30',
                          'Book now for this weekend',
                          ThemeManager.of(context).successColor,
                        ),
                        _buildPromoBanner(
                          'Emergency Services',
                          '24/7 urgent repairs available',
                          'Quick response guaranteed',
                          ThemeManager.of(context).warningColor,
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
                          color: ThemeManager.of(context).textPrimary,
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
                            color: ThemeManager.of(context).primaryColor,
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
                        ThemeManager.of(context).primaryColor,
                        '150+ providers',
                      ),
                      _buildServiceCard(
                        'Plumbing',
                        Prbal.tools,
                        ThemeManager.of(context).successColor,
                        '89+ providers',
                      ),
                      _buildServiceCard(
                        'Electrical',
                        Prbal.plug,
                        ThemeManager.of(context).warningColor,
                        '67+ providers',
                      ),
                      _buildServiceCard(
                        'Gardening',
                        Prbal.leaf,
                        ThemeManager.of(context).infoColor,
                        '45+ providers',
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
                          color: ThemeManager.of(context).textPrimary,
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
                            color: ThemeManager.of(context).primaryColor,
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
                      color: ThemeManager.of(context).surfaceColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeManager.of(context).themeManager
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
                          ThemeManager.of(context).successColor,
                        ),
                        _buildActivityItem(
                          'Payment processed',
                          '5 hours ago',
                          Prbal.dollarSign,
                          ThemeManager.of(context).primaryColor,
                        ),
                        _buildActivityItem(
                          'Service reviewed',
                          '1 day ago',
                          Prbal.star,
                          ThemeManager.of(context).warningColor,
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
  ) {
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
    String time,
    IconData icon,
    Color color,
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
          color: ThemeManager.of(context).textPrimary,
        ),
      ),
      subtitle: Text(
        time,
        style: TextStyle(
          fontSize: 12.sp,
          color: ThemeManager.of(context).textSecondary,
        ),
      ),
      trailing: Icon(
        Prbal.angleRight,
        color: ThemeManager.of(context).textSecondary,
        size: 16.sp,
      ),
    );
  }
}
