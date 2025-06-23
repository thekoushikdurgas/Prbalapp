import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:go_router/go_router.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
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
                'Find Services',
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
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.grey.withValues(alpha: 0.1),
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
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 16.sp,
                        ),
                        prefixIcon: Icon(
                          LineIcons.search,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // Navigate to explore with search
                            context.go('/explore');
                          },
                          icon: Icon(
                            LineIcons.arrowRight,
                            color: const Color(0xFF4299E1),
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
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.grey.withValues(alpha: 0.1),
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
                          const Color(0xFF4299E1),
                          isDark,
                        ),
                        _buildPromoBanner(
                          'Weekend Deal',
                          'Home cleaning starting at \$30',
                          'Book now for this weekend',
                          const Color(0xFF48BB78),
                          isDark,
                        ),
                        _buildPromoBanner(
                          'Emergency Services',
                          '24/7 urgent repairs available',
                          'Quick response guaranteed',
                          const Color(0xFFED8936),
                          isDark,
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
                          color:
                              isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Navigate to explore page
                          context.go('/explore');
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4299E1),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Category Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.9,
                    children: [
                      _buildCategoryCard(
                        'Home\nCleaning',
                        LineIcons.home,
                        const Color(0xFF4299E1),
                        isDark,
                        onTap: () {
                          // Navigate to explore with home cleaning filter
                          context.go('/explore');
                        },
                      ),
                      _buildCategoryCard(
                        'AC Repair\n& Service',
                        LineIcons.snowflake,
                        const Color(0xFF48BB78),
                        isDark,
                        onTap: () {
                          // Navigate to explore with AC repair filter
                          context.go('/explore');
                        },
                      ),
                      _buildCategoryCard(
                        'Plumbing\nServices',
                        LineIcons.wrench,
                        const Color(0xFF9F7AEA),
                        isDark,
                        onTap: () {
                          // Navigate to explore with plumbing filter
                          context.go('/explore');
                        },
                      ),
                      _buildCategoryCard(
                        'Beauty\n& Care',
                        LineIcons.cut,
                        const Color(0xFFED64A6),
                        isDark,
                        onTap: () {
                          // Navigate to explore with beauty filter
                          context.go('/explore');
                        },
                      ),
                      _buildCategoryCard(
                        'Tech\nSupport',
                        LineIcons.laptop,
                        const Color(0xFFED8936),
                        isDark,
                        onTap: () {
                          // Navigate to explore with tech support filter
                          context.go('/explore');
                        },
                      ),
                      _buildCategoryCard(
                        'More\nServices',
                        LineIcons.thLarge,
                        isDark ? Colors.grey[600]! : Colors.grey[400]!,
                        isDark,
                        onTap: () {
                          // Navigate to full explore page
                          context.go('/explore');
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Recent Services
                  Row(
                    children: [
                      Text(
                        'Recent Services',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Navigate to order history
                          context.go('/orders');
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

                  SizedBox(height: 16.h),

                  // Recent Services List
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
                      children: [
                        _buildRecentServiceItem(
                          'Home Cleaning',
                          'Completed yesterday',
                          'by Sarah Johnson',
                          4.8,
                          LineIcons.home,
                          const Color(0xFF4299E1),
                          isDark,
                        ),
                        const Divider(height: 1),
                        _buildRecentServiceItem(
                          'AC Repair',
                          'Completed 3 days ago',
                          'by Mike Wilson',
                          4.9,
                          LineIcons.snowflake,
                          const Color(0xFF48BB78),
                          isDark,
                        ),
                        const Divider(height: 1),
                        _buildRecentServiceItem(
                          'Garden Care',
                          'Completed 1 week ago',
                          'by Lisa Brown',
                          4.7,
                          LineIcons.leaf,
                          const Color(0xFF9F7AEA),
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          'Emergency',
                          'Urgent service needed?',
                          LineIcons.exclamationTriangle,
                          const Color(0xFFE53E3E),
                          isDark,
                          onTap: () {
                            // Navigate to explore with emergency filter
                            context.go('/explore');
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildQuickActionCard(
                          'Schedule',
                          'Book for later',
                          LineIcons.calendar,
                          const Color(0xFF4299E1),
                          isDark,
                          onTap: () {
                            // Navigate to explore to book services
                            context.go('/explore');
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),
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
    String description,
    Color color,
    bool isDark,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding:
            EdgeInsets.all(14.w), // Further reduced padding to prevent overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Changed from center to spaceBetween
          mainAxisSize:
              MainAxisSize.max, // Changed to max to use full container height
          children: [
            Flexible(
              // Wrapped text section in Flexible
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp, // Slightly reduced
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h), // Further reduced spacing
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp, // Slightly reduced
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 10.sp, // Slightly reduced
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Button section with fixed space
            SizedBox(
              height: 32.h, // Fixed height for button
              child: ElevatedButton(
                onPressed: () {
                  // Apply promotion
                  context
                      .go('/explore'); // Navigate to explore to use promotion
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: color,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 6.h), // Adjusted padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Claim Now',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color color,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap ??
              () {
                // Default navigation to explore
                context.go('/explore');
              },
          child: Padding(
            padding: EdgeInsets.all(12.w), // Reduced from 16.w
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Added to prevent overflow
              children: [
                Container(
                  padding: EdgeInsets.all(10.w), // Reduced from 12.w
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(10.r), // Reduced from 12.r
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20.sp, // Reduced from 24.sp
                  ),
                ),
                SizedBox(height: 8.h), // Reduced from 12.h
                Flexible(
                  // Added Flexible to prevent overflow
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp, // Reduced from 12.sp
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentServiceItem(
    String title,
    String date,
    String provider,
    double rating,
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          Text(
            provider,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LineIcons.star,
            size: 16.sp,
            color: const Color(0xFFED8936),
          ),
          SizedBox(width: 4.w),
          Text(
            rating.toString(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFED8936),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap ??
              () {
                // Default action
              },
          child: Padding(
            padding: EdgeInsets.all(12.w), // Reduced from 16.w
            child: Column(
              mainAxisSize: MainAxisSize.min, // Added to prevent overflow
              children: [
                Container(
                  padding: EdgeInsets.all(6.w), // Reduced from 8.w
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(6.r), // Reduced from 8.r
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 18.sp, // Reduced from 20.sp
                  ),
                ),
                SizedBox(height: 6.h), // Reduced from 8.h
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp, // Reduced from 14.sp
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h), // Reduced from 4.h
                Flexible(
                  // Added Flexible to prevent overflow
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp, // Reduced from 11.sp
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
