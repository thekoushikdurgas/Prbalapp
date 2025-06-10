import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

// TODO bu kısıma anasayfa tasarlanır ve proje buradan başlar
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  // Mock data for services
  final List<Map<String, dynamic>> _serviceCategories = [
    {
      'name': 'All',
      'icon': LineIcons.th,
      'color': const Color(0xFF3B82F6),
      'count': 150,
    },
    {
      'name': 'Home Services',
      'icon': LineIcons.home,
      'color': const Color(0xFF10B981),
      'count': 45,
    },
    {
      'name': 'Technical',
      'icon': LineIcons.laptop,
      'color': const Color(0xFFF59E0B),
      'count': 32,
    },
    {
      'name': 'Beauty & Care',
      'icon': LineIcons.cut,
      'color': const Color(0xFFEF4444),
      'count': 28,
    },
    {
      'name': 'Health',
      'icon': LineIcons.heartbeat,
      'color': const Color(0xFF8B5CF6),
      'count': 18,
    },
    {
      'name': 'Education',
      'icon': LineIcons.graduationCap,
      'color': const Color(0xFF06B6D4),
      'count': 25,
    },
  ];

  final List<Map<String, dynamic>> _featuredServices = [
    {
      'name': 'House Cleaning',
      'provider': 'Sarah Johnson',
      'rating': 4.8,
      'price': 25,
      'image':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=150',
      'category': 'Home Services',
    },
    {
      'name': 'Laptop Repair',
      'provider': 'Tech Solutions',
      'rating': 4.9,
      'price': 40,
      'image':
          'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=150',
      'category': 'Technical',
    },
    {
      'name': 'Hair Styling',
      'provider': 'Beauty Pro',
      'rating': 4.7,
      'price': 35,
      'image':
          'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=150',
      'category': 'Beauty & Care',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header section
              SliverToBoxAdapter(
                child: _buildHeader(isDark),
              ),

              // Search section
              SliverToBoxAdapter(
                child: _buildSearchSection(isDark),
              ),

              // Categories section
              SliverToBoxAdapter(
                child: _buildCategoriesSection(isDark),
              ),

              // Quick stats section
              SliverToBoxAdapter(
                child: _buildQuickStatsSection(isDark),
              ),

              // Featured services section
              SliverToBoxAdapter(
                child: _buildFeaturedServicesSection(isDark),
              ),

              // Recent activity section
              SliverToBoxAdapter(
                child: _buildRecentActivitySection(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          // User avatar
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(
              LineIcons.user,
              color: Colors.white,
              size: 24.sp,
            ),
          ),

          SizedBox(width: 16.w),

          // Welcome text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),

          // Notifications button
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(22.r),
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
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    LineIcons.bell,
                    size: 20.sp,
                    color: isDark ? Colors.white : const Color(0xFF374151),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontSize: 16.sp,
            color: isDark ? Colors.white : const Color(0xFF374151),
          ),
          decoration: InputDecoration(
            hintText: 'Search for services...',
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
            prefixIcon: Icon(
              LineIcons.search,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              size: 20.sp,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                // Show filters
              },
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.filter,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Text(
            'Service Categories',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _serviceCategories.length,
            itemBuilder: (context, index) {
              final category = _serviceCategories[index];
              final isSelected = category['name'] == _selectedCategory;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                  });
                },
                child: Container(
                  width: 90.w,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category['color']
                        : (isDark ? const Color(0xFF1E293B) : Colors.white),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? category['color'].withValues(alpha: 0.3)
                            : (isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.1)),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : category['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Icon(
                          category['icon'],
                          size: 24.sp,
                          color: isSelected ? Colors.white : category['color'],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? Colors.white
                                  : const Color(0xFF374151)),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${category['count']}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : (isDark ? Colors.grey[400] : Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsSection(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Active Services',
              '12',
              LineIcons.briefcase,
              const Color(0xFF10B981),
              isDark,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildStatCard(
              'This Month',
              '\$2,450',
              LineIcons.dollarSign,
              const Color(0xFF3B82F6),
              isDark,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildStatCard(
              'Rating',
              '4.8',
              LineIcons.star,
              const Color(0xFFF59E0B),
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: color,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
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

  Widget _buildFeaturedServicesSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Services',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to see all
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _featuredServices.length,
            itemBuilder: (context, index) {
              final service = _featuredServices[index];

              return Container(
                width: 160.w,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service image
                    Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['name'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            service['provider'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LineIcons.star,
                                    size: 12.sp,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${service['rating']}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF374151),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '\$${service['price']}/hr',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
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
            child: Column(
              children: [
                _buildActivityItem(
                  'Service completed',
                  'House Cleaning with Sarah Johnson',
                  '2 hours ago',
                  LineIcons.checkCircle,
                  const Color(0xFF10B981),
                  isDark,
                ),
                _buildActivityItem(
                  'New booking',
                  'Laptop Repair scheduled for tomorrow',
                  '5 hours ago',
                  LineIcons.calendar,
                  const Color(0xFF3B82F6),
                  isDark,
                ),
                _buildActivityItem(
                  'Payment received',
                  '\$25.00 from hair styling service',
                  '1 day ago',
                  LineIcons.dollarSign,
                  const Color(0xFFF59E0B),
                  isDark,
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
        ],
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
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: color,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 10.sp,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
