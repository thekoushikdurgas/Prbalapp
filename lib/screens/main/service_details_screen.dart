import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
  });

  @override
  ConsumerState<ServiceDetailsScreen> createState() =>
      _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  bool _isFavorite = false;

  // Mock service data
  Map<String, dynamic> serviceData = {
    'id': 'SVC-001',
    'title': 'Professional House Deep Cleaning',
    'description':
        'Complete deep cleaning service for your home including all rooms, kitchen, bathrooms, and common areas. We use eco-friendly products and professional equipment.',
    'price': 75.00,
    'duration': '3-4 hours',
    'category': 'Home Services',
    'rating': 4.8,
    'reviewCount': 156,
    'images': [
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      'https://images.unsplash.com/photo-1556912167-f556f1b39b6b?w=400',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
      'https://images.unsplash.com/photo-1628177142898-93e36e4e3a50?w=400',
    ],
    'provider': {
      'id': 'PRV-001',
      'name': 'Sarah Johnson',
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
      'rating': 4.9,
      'reviewCount': 234,
      'joinDate': DateTime.now().subtract(const Duration(days: 365)),
      'completedJobs': 189,
      'responseTime': '< 1 hour',
    },
    'features': [
      'All rooms cleaning',
      'Kitchen deep clean',
      'Bathroom sanitization',
      'Window cleaning',
      'Eco-friendly products',
      'Professional equipment',
      'Insured service',
      'Satisfaction guarantee',
    ],
    'availability': [
      {
        'day': 'Monday',
        'slots': ['9:00 AM', '2:00 PM', '5:00 PM']
      },
      {
        'day': 'Tuesday',
        'slots': ['10:00 AM', '3:00 PM']
      },
      {
        'day': 'Wednesday',
        'slots': ['9:00 AM', '1:00 PM', '4:00 PM']
      },
      {
        'day': 'Thursday',
        'slots': ['11:00 AM', '2:00 PM']
      },
      {
        'day': 'Friday',
        'slots': ['9:00 AM', '3:00 PM', '6:00 PM']
      },
      {
        'day': 'Saturday',
        'slots': ['10:00 AM', '1:00 PM']
      },
      {'day': 'Sunday', 'slots': []},
    ],
  };

  // Mock reviews data
  List<Map<String, dynamic>> reviews = [
    {
      'id': '1',
      'user': 'Mike Wilson',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'rating': 5,
      'comment':
          'Excellent service! Sarah was very professional and thorough. My house has never been cleaner.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'images': [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200'
      ],
    },
    {
      'id': '2',
      'user': 'Emily Davis',
      'avatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'rating': 5,
      'comment':
          'Amazing attention to detail. Highly recommend this service to anyone!',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'images': [],
    },
    {
      'id': '3',
      'user': 'David Chen',
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      'rating': 4,
      'comment': 'Good service overall. Very punctual and professional.',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'images': [],
    },
  ];

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🎯 ServiceDetailsScreen: Initializing for service ${widget.serviceId}');
    _initializeAnimations();
    _startAnimations();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _initializeAnimations() {
    debugPrint('🎯 ServiceDetailsScreen: Setting up fade animation controller');
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startAnimations() async {
    debugPrint('🎯 ServiceDetailsScreen: Starting entrance animations');
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
  }

  @override
  void dispose() {
    debugPrint('🎯 ServiceDetailsScreen: Disposing controllers');
    _fadeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(themeManager),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceHeader(themeManager),
                    SizedBox(height: 16.h),
                    _buildProviderCard(themeManager),
                    SizedBox(height: 16.h),
                    _buildTabSection(themeManager),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(themeManager),
    );
  }

  Widget _buildSliverAppBar(ThemeManager themeManager) {
    debugPrint(
        '🎨 ServiceDetailsScreen: Building sliver app bar with gradient overlay');
    return SliverAppBar(
      expandedHeight: 300.h,
      floating: false,
      pinned: true,
      backgroundColor: themeManager.surfaceColor,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: themeManager.backgroundColor
              .withValues(alpha: 179), // 0.7 opacity
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: themeManager.subtleShadow,
        ),
        child: IconButton(
          icon: Icon(
            Prbal.arrowLeft,
            color: themeManager.textPrimary,
          ),
          onPressed: () {
            debugPrint('🔄 ServiceDetailsScreen: Navigating back');
            context.pop();
          },
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: themeManager.backgroundColor
                .withValues(alpha: 179), // 0.7 opacity
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.subtleShadow,
          ),
          child: IconButton(
            icon: Icon(
              _isFavorite ? Prbal.heart : Prbal.heart5,
              color: _isFavorite
                  ? themeManager.errorColor
                  : themeManager.textPrimary,
            ),
            onPressed: () {
              debugPrint('💖 ServiceDetailsScreen: Toggling favorite status');
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: themeManager.backgroundColor
                .withValues(alpha: 179), // 0.7 opacity
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.subtleShadow,
          ),
          child: IconButton(
            icon: Icon(
              Prbal.share,
              color: themeManager.textPrimary,
            ),
            onPressed: () {
              debugPrint('📤 ServiceDetailsScreen: Sharing service');
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: serviceData['images'].length,
              itemBuilder: (context, index) {
                return Image.network(
                  serviceData['images'][index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      gradient: themeManager.backgroundGradient,
                    ),
                    child: Icon(
                      Prbal.image,
                      color: themeManager.textTertiary,
                      size: 64.sp,
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    themeManager.backgroundColor
                        .withValues(alpha: 77), // 0.3 opacity
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceHeader(ThemeManager themeManager) {
    debugPrint(
        '🎨 ServiceDetailsScreen: Building service header with theme colors');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color:
                themeManager.primaryColor.withValues(alpha: 26), // 0.1 opacity
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: themeManager.primaryColor
                  .withValues(alpha: 77), // 0.3 opacity
            ),
          ),
          child: Text(
            serviceData['category'],
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: themeManager.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          serviceData['title'],
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            color: themeManager.textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(
              Prbal.star,
              color: themeManager.warningColor,
              size: 18.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              serviceData['rating'].toString(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '(${serviceData['reviewCount']} reviews)',
              style: TextStyle(
                fontSize: 14.sp,
                color: themeManager.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: themeManager.surfaceColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: themeManager.subtleShadow,
                  border: Border.all(
                    color: themeManager.borderColor,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Starting at',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: themeManager.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\$${serviceData['price'].toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: themeManager.successColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: themeManager.surfaceColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: themeManager.subtleShadow,
                  border: Border.all(
                    color: themeManager.borderColor,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: themeManager.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      serviceData['duration'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: themeManager.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProviderCard(ThemeManager themeManager) {
    debugPrint(
        '🎨 ServiceDetailsScreen: Building provider card with gradient styling');
    final provider = serviceData['provider'];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.elevatedShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  gradient: themeManager.primaryGradient,
                  boxShadow: themeManager.primaryShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: Image.network(
                    provider['avatar'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Prbal.user, color: Colors.white, size: 30.sp),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider['name'],
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: themeManager.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Prbal.star,
                          color: themeManager.warningColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          provider['rating'].toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: themeManager.warningColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            '(${provider['reviewCount']} reviews)',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: themeManager.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: themeManager.primaryColor
                      .withValues(alpha: 26), // 0.1 opacity
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Prbal.comment,
                  color: themeManager.primaryColor,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildProviderStat(
                  'Completed Jobs',
                  provider['completedJobs'].toString(),
                  Prbal.check,
                  themeManager,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildProviderStat(
                  'Response Time',
                  provider['responseTime'],
                  Prbal.clock,
                  themeManager,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProviderStat(
      String label, String value, IconData icon, ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color:
            themeManager.backgroundColor.withValues(alpha: 128), // 0.5 opacity
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: themeManager.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: themeManager.primaryColor,
            size: 20.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: themeManager.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: themeManager.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(ThemeManager themeManager) {
    debugPrint(
        '🎨 ServiceDetailsScreen: Building tab section with theme styling');
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: themeManager.surfaceColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.subtleShadow,
            border: Border.all(
              color: themeManager.borderColor,
              width: 0.5,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: themeManager.primaryShadow,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: themeManager.textTertiary,
            labelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Details'),
              Tab(text: 'Reviews'),
              Tab(text: 'Availability'),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 400.h,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsTab(themeManager),
              _buildReviewsTab(themeManager),
              _buildAvailabilityTab(themeManager),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTab(ThemeManager themeManager) {
    debugPrint('🎯 ServiceDetailsScreen: Building details tab');
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: themeManager.surfaceGradient,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: themeManager.elevatedShadow,
              border: Border.all(
                color: themeManager.borderColor,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: themeManager.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  serviceData['description'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeManager.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: themeManager.surfaceGradient,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: themeManager.elevatedShadow,
              border: Border.all(
                color: themeManager.borderColor,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What\'s Included',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: themeManager.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                ...serviceData['features'].map<Widget>((feature) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      children: [
                        Icon(
                          Prbal.check,
                          color: themeManager.successColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: themeManager.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(ThemeManager themeManager) {
    debugPrint('🎯 ServiceDetailsScreen: Building reviews tab');
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: themeManager.surfaceGradient,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: themeManager.elevatedShadow,
              border: Border.all(
                color: themeManager.borderColor,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        serviceData['rating'].toString(),
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w800,
                          color: themeManager.textPrimary,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            Prbal.star,
                            color: index < serviceData['rating'].floor()
                                ? themeManager.warningColor
                                : themeManager.borderColor,
                            size: 20.sp,
                          );
                        }),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${serviceData['reviewCount']} reviews',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: themeManager.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: List.generate(5, (index) {
                      final rating = 5 - index;
                      final percentage = rating == 5
                          ? 0.8
                          : rating == 4
                              ? 0.15
                              : 0.05;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          children: [
                            Text(
                              '$rating',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: themeManager.textSecondary,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: percentage,
                                  backgroundColor: themeManager.borderColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      themeManager.warningColor),
                                  minHeight: 6.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          ...reviews.map((review) => _buildReviewItem(review, themeManager)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
      Map<String, dynamic> review, ThemeManager themeManager) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: themeManager.primaryGradient,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.network(
                    review['avatar'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Prbal.user, color: Colors.white, size: 20.sp),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['user'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: themeManager.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Prbal.star,
                            color: index < review['rating']
                                ? themeManager.warningColor
                                : themeManager.borderColor,
                            size: 14.sp,
                          );
                        }),
                        SizedBox(width: 8.w),
                        Text(
                          _formatDate(review['date']),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: themeManager.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review['comment'],
            style: TextStyle(
              fontSize: 14.sp,
              color: themeManager.textSecondary,
              height: 1.4,
            ),
          ),
          if (review['images'].isNotEmpty) ...[
            SizedBox(height: 12.h),
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review['images'].length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: themeManager.backgroundColor,
                      border: Border.all(
                        color: themeManager.borderColor,
                        width: 0.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        review['images'][index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Prbal.image,
                          color: themeManager.textTertiary,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvailabilityTab(ThemeManager themeManager) {
    debugPrint('🎯 ServiceDetailsScreen: Building availability tab');
    return SingleChildScrollView(
      child: Column(
        children: serviceData['availability'].map<Widget>((dayData) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: themeManager.surfaceColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: themeManager.subtleShadow,
              border: Border.all(
                color: themeManager.borderColor,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayData['day'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: themeManager.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                if (dayData['slots'].isEmpty)
                  Text(
                    'No availability',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: themeManager.textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: dayData['slots'].map<Widget>((slot) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: themeManager.successColor
                              .withValues(alpha: 26), // 0.1 opacity
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: themeManager.successColor
                                .withValues(alpha: 77), // 0.3 opacity
                          ),
                        ),
                        child: Text(
                          slot,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: themeManager.successColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomBar(ThemeManager themeManager) {
    debugPrint(
        '🎨 ServiceDetailsScreen: Building bottom bar with gradient button');
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        boxShadow: themeManager.elevatedShadow,
        border: Border(
          top: BorderSide(
            color: themeManager.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: themeManager.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${serviceData['price'].toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: themeManager.successColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: themeManager.primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: themeManager.primaryShadow,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint(
                        '📅 ServiceDetailsScreen: Opening booking dialog');
                    _showBookingDialog(themeManager);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showBookingDialog(ThemeManager themeManager) {
    debugPrint('🎯 ServiceDetailsScreen: Showing booking modal dialog');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: themeManager.surfaceGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: themeManager.elevatedShadow,
          border: Border.all(
            color: themeManager.borderColor,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: themeManager.borderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Book Service',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              serviceData['title'],
              style: TextStyle(
                fontSize: 16.sp,
                color: themeManager.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date & Time',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: themeManager.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: themeManager.backgroundColor
                            .withValues(alpha: 128), // 0.5 opacity
                        border: Border.all(
                          color: themeManager.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Tomorrow, 10:00 AM',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: themeManager.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Prbal.calendar,
                            color: themeManager.primaryColor,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: themeManager.primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: themeManager.primaryShadow,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('✅ ServiceDetailsScreen: Confirming booking');
                    Navigator.pop(context);
                    // Handle booking confirmation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Confirm Booking - \$${serviceData['price'].toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
