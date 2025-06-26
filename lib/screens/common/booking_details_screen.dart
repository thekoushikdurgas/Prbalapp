import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:go_router/go_router.dart';

class BookingDetailsScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  @override
  ConsumerState<BookingDetailsScreen> createState() =>
      _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends ConsumerState<BookingDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // Mock booking data
  Map<String, dynamic> bookingData = {
    'id': 'BKG-2024-001',
    'serviceName': 'House Deep Cleaning',
    'provider': {
      'name': 'Sarah Johnson',
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
      'rating': 4.8,
      'phone': '+1 (555) 123-4567',
      'email': 'sarah.johnson@email.com',
    },
    'customer': {
      'name': 'John Smith',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'phone': '+1 (555) 987-6543',
      'email': 'john.smith@email.com',
    },
    'status': 'in_progress',
    'date': DateTime.now().add(const Duration(days: 2)),
    'time': '10:00 AM - 2:00 PM',
    'duration': '4 hours',
    'price': 150.00,
    'address': '123 Main Street, Apt 4B\nNew York, NY 10001',
    'description':
        'Deep cleaning for 3-bedroom apartment including kitchen, bathrooms, living areas, and bedrooms. Special attention to baseboards and windows.',
    'notes':
        'Please use eco-friendly products only. Front door key is under the flower pot.',
    'images': [
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300',
      'https://images.unsplash.com/photo-1556912167-f556f1b39b6b?w=300',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300',
    ],
    'timeline': [
      {
        'status': 'booked',
        'title': 'Booking Confirmed',
        'description': 'Your service has been booked successfully',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'completed': true,
      },
      {
        'status': 'assigned',
        'title': 'Provider Assigned',
        'description': 'Sarah Johnson has been assigned to your service',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'completed': true,
      },
      {
        'status': 'in_progress',
        'title': 'Service in Progress',
        'description': 'The service is currently being performed',
        'time': DateTime.now(),
        'completed': true,
      },
      {
        'status': 'completed',
        'title': 'Service Completed',
        'description': 'The service has been completed successfully',
        'time': DateTime.now().add(const Duration(hours: 4)),
        'completed': false,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    debugPrint(
        '📋 BookingDetailsScreen: Initializing booking details for ID: ${widget.bookingId}');
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    debugPrint('📋 BookingDetailsScreen: Setting up animation controllers');

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.75,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startAnimations() async {
    debugPrint('📋 BookingDetailsScreen: Starting booking details animations');
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _progressController.forward();
    debugPrint('📋 BookingDetailsScreen: All animations started successfully');
  }

  @override
  void dispose() {
    debugPrint('📋 BookingDetailsScreen: Disposing animation controllers');
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('📋 BookingDetailsScreen: Building booking details interface');
    debugPrint(
        '🎨 BookingDetailsScreen: Theme mode: ${themeManager.themeManager ? 'Dark' : 'Light'}');
    debugPrint(
        '📋 BookingDetailsScreen: Booking status: ${bookingData['status']}');

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
                    _buildStatusCard(themeManager),
                    SizedBox(height: 16.h),
                    _buildServiceInfo(themeManager),
                    SizedBox(height: 16.h),
                    _buildProviderInfo(themeManager),
                    SizedBox(height: 16.h),
                    _buildLocationCard(themeManager),
                    SizedBox(height: 16.h),
                    _buildTimelineCard(themeManager),
                    SizedBox(height: 16.h),
                    _buildImagesCard(themeManager),
                    SizedBox(height: 16.h),
                    _buildNotesCard(themeManager),
                    SizedBox(height: 16.h),
                    _buildActionButtons(themeManager),
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

  Widget _buildSliverAppBar(ThemeManager themeManager) {
    debugPrint('📋 BookingDetailsScreen: Building sliver app bar');

    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      backgroundColor: themeManager.surfaceColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Prbal.arrowLeft,
          color: themeManager.textPrimary,
        ),
        onPressed: () {
          debugPrint('📋 BookingDetailsScreen: Back button pressed');
          context.pop();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Prbal.share,
            color: themeManager.textSecondary,
          ),
          onPressed: () {
            debugPrint('📋 BookingDetailsScreen: Share button pressed');
          },
        ),
        IconButton(
          icon: Icon(
            Prbal.moreVertical,
            color: themeManager.textSecondary,
          ),
          onPressed: () {
            debugPrint('📋 BookingDetailsScreen: More options pressed');
            _showMoreOptions(themeManager);
          },
        ),
        SizedBox(width: 8.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
        title: Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: themeManager.textPrimary,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: themeManager.surfaceGradient,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeManager themeManager) {
    debugPrint(
        '📋 BookingDetailsScreen: Building status card for status: ${bookingData['status']}');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: _getStatusGradient(bookingData['status'], themeManager),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(bookingData['status'], themeManager)
                .withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking ID: ${bookingData['id']}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _getStatusDisplayName(bookingData['status']),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            bookingData['serviceName'],
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Prbal.calendar,
                color: Colors.white70,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '${_formatDate(bookingData['date'])} • ${bookingData['time']}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(_progressAnimation.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6.h,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfo(ThemeManager themeManager) {
    debugPrint('📋 BookingDetailsScreen: Building service info card');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Information',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: themeManager.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            icon: Prbal.clock,
            label: 'Duration',
            value: bookingData['duration'],
            themeManager: themeManager,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            icon: Prbal.dollarSign,
            label: 'Total Price',
            value: '\$${bookingData['price'].toStringAsFixed(2)}',
            themeManager: themeManager,
          ),
          if (bookingData['description'] != null) ...[
            SizedBox(height: 16.h),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              bookingData['description'],
              style: TextStyle(
                fontSize: 14.sp,
                color: themeManager.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProviderInfo(ThemeManager themeManager) {
    final provider = bookingData['provider'];
    debugPrint(
        '📋 BookingDetailsScreen: Building provider info for: ${provider['name']}');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Provider',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: themeManager.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: themeManager.primaryColor,
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
                        Text(
                          '• Professional Cleaner',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: themeManager.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    debugPrint(
                        '📋 BookingDetailsScreen: Call provider button pressed');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: themeManager.successColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: themeManager.successColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Prbal.phone,
                          color: themeManager.successColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Call',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: themeManager.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    debugPrint(
                        '📋 BookingDetailsScreen: Message provider button pressed');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: themeManager.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: themeManager.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Prbal.comment,
                          color: themeManager.primaryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Message',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: themeManager.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(ThemeManager themeManager) {
    debugPrint('📋 BookingDetailsScreen: Building location card');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Location',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: themeManager.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: themeManager.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Prbal.directions,
                  color: themeManager.primaryColor,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Prbal.mapMarker,
                color: themeManager.errorColor,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  bookingData['address'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeManager.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(ThemeManager themeManager) {
    debugPrint('📋 BookingDetailsScreen: Building timeline card');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Timeline',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: themeManager.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          ...bookingData['timeline'].map<Widget>((item) {
            final index = bookingData['timeline'].indexOf(item);
            final isLast = index == bookingData['timeline'].length - 1;

            return _buildTimelineItem(
              item,
              isLast,
              themeManager,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      Map<String, dynamic> item, bool isLast, ThemeManager themeManager) {
    final isCompleted = item['completed'] as bool;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: isCompleted
                    ? themeManager.successColor
                    : themeManager.surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isCompleted
                      ? themeManager.successColor
                      : themeManager.borderColor,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(
                      Prbal.check,
                      color: Colors.white,
                      size: 12.sp,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color: themeManager.borderColor,
              ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item['description'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeManager.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatDateTime(item['time']),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: themeManager.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesCard(ThemeManager themeManager) {
    debugPrint(
        '📋 BookingDetailsScreen: Building images card with ${bookingData['images'].length} images');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Images',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: themeManager.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bookingData['images'].length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: themeManager.surfaceColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      bookingData['images'][index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Prbal.image, color: themeManager.textSecondary),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(ThemeManager themeManager) {
    if (bookingData['notes'] == null) {
      debugPrint(
          '📋 BookingDetailsScreen: No notes to display, returning empty widget');
      return const SizedBox.shrink();
    }

    debugPrint('📋 BookingDetailsScreen: Building notes card');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Instructions',
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
              color: themeManager.warningColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: themeManager.warningColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Prbal.exclamationTriangle,
                  color: themeManager.warningColor,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    bookingData['notes'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: themeManager.textSecondary,
                      height: 1.5,
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

  Widget _buildActionButtons(ThemeManager themeManager) {
    debugPrint(
        '📋 BookingDetailsScreen: Building action buttons for status: ${bookingData['status']}');

    return Column(
      children: [
        if (bookingData['status'] == 'booked' ||
            bookingData['status'] == 'assigned') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showCancelDialog(themeManager),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeManager.errorColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Cancel Booking',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
        if (bookingData['status'] == 'completed') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showReviewDialog(themeManager),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeManager.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Leave Review',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              side: BorderSide(
                color: themeManager.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeManager themeManager,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF3B82F6),
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: themeManager.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: themeManager.textPrimary,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, ThemeManager themeManager) {
    debugPrint('📋 BookingDetailsScreen: Getting status color for: $status');

    switch (status) {
      case 'booked':
        return themeManager.primaryColor;
      case 'assigned':
        return themeManager.warningColor;
      case 'in_progress':
        return themeManager.infoColor;
      case 'completed':
        return themeManager.successColor;
      case 'cancelled':
        return themeManager.errorColor;
      default:
        return themeManager.textSecondary;
    }
  }

  LinearGradient _getStatusGradient(String status, ThemeManager themeManager) {
    debugPrint(
        '📋 BookingDetailsScreen: Creating status gradient for: $status');

    final color = _getStatusColor(status, themeManager);
    return LinearGradient(
      colors: [color, color.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'booked':
        return 'BOOKED';
      case 'assigned':
        return 'ASSIGNED';
      case 'in_progress':
        return 'IN PROGRESS';
      case 'completed':
        return 'COMPLETED';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showMoreOptions(ThemeManager themeManager) {
    debugPrint('📋 BookingDetailsScreen: Showing more options modal');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: themeManager.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Prbal.edit, color: themeManager.primaryColor),
              title: Text('Modify Booking',
                  style: TextStyle(color: themeManager.textPrimary)),
              onTap: () {
                debugPrint('📋 BookingDetailsScreen: Modify booking selected');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Prbal.calendar, color: themeManager.warningColor),
              title: Text('Reschedule',
                  style: TextStyle(color: themeManager.textPrimary)),
              onTap: () {
                debugPrint('📋 BookingDetailsScreen: Reschedule selected');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Prbal.flag, color: themeManager.errorColor),
              title: Text('Report Issue',
                  style: TextStyle(color: themeManager.textPrimary)),
              onTap: () {
                debugPrint('📋 BookingDetailsScreen: Report issue selected');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(ThemeManager themeManager) {
    debugPrint('📋 BookingDetailsScreen: Showing cancel booking dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.surfaceColor,
        title: Text(
          'Cancel Booking',
          style: TextStyle(
            color: themeManager.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: TextStyle(
            color: themeManager.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle cancellation
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: themeManager.errorColor),
            child: const Text('Cancel Booking',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(ThemeManager themeManager) {
    debugPrint('📋 BookingDetailsScreen: Showing review dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.surfaceColor,
        title: Text(
          'Leave Review',
          style: TextStyle(
            color: themeManager.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How was your experience with ${bookingData['provider']['name']}?',
              style: TextStyle(
                color: themeManager.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Prbal.star,
                  color: themeManager.warningColor,
                  size: 32.sp,
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle review submission
            },
            child: const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
