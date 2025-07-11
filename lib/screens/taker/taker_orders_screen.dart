import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

class TakerOrdersScreen extends ConsumerStatefulWidget {
  const TakerOrdersScreen({super.key});

  @override
  ConsumerState<TakerOrdersScreen> createState() => _TakerOrdersScreenState();
}

class _TakerOrdersScreenState extends ConsumerState<TakerOrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: ThemeManager.of(context).surfaceColor,
                boxShadow: ThemeManager.of(context).subtleShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'My Bookings',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeManager.of(context).textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Show filter options
                        },
                        icon: Icon(
                          Prbal.filter,
                          color: ThemeManager.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeManager.of(context).inputBackground,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: ThemeManager.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          ThemeManager.of(context).textTertiary,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Active'),
                        Tab(text: 'History'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUpcomingOrders(),
                  _buildActiveOrders(),
                  _buildOrderHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingOrders() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 4, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: ThemeManager.of(context).subtleShadow,
          ),
          child: _buildUpcomingOrderCard(index),
        );
      },
    );
  }

  Widget _buildActiveOrders() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 2, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: ThemeManager.of(context).subtleShadow,
          ),
          child: _buildActiveOrderCard(index),
        );
      },
    );
  }

  Widget _buildOrderHistory() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 10, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: ThemeManager.of(context).subtleShadow,
          ),
          child: _buildHistoryOrderCard(index),
        );
      },
    );
  }

  Widget _buildUpcomingOrderCard(
    int index,
  ) {
    final services = [
      {
        'title': 'House Cleaning',
        'provider': 'John Doe',
        'time': '10:00 AM',
        'date': 'Today'
      },
      {
        'title': 'Plumbing Repair',
        'provider': 'Jane Smith',
        'time': '2:00 PM',
        'date': 'Tomorrow'
      },
      {
        'title': 'Electrical Work',
        'provider': 'Mike Johnson',
        'time': '11:00 AM',
        'date': 'Dec 15'
      },
      {
        'title': 'Gardening',
        'provider': 'Sarah Wilson',
        'time': '9:00 AM',
        'date': 'Dec 16'
      },
    ];

    final service = services[index];

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context)
                      .primaryColor
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Prbal.clock,
                  color: ThemeManager.of(context).primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title']!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Provider: ${service['provider']}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context)
                      .warningColor
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).warningColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Service details
          Row(
            children: [
              Icon(
                Prbal.calendar,
                color: ThemeManager.of(context).textTertiary,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                service['date']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
              SizedBox(width: 24.w),
              Icon(
                Prbal.clock,
                color: ThemeManager.of(context).textTertiary,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                service['time']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Prbal.message,
                    size: 16.sp,
                  ),
                  label: Text('Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeManager.of(context).surfaceColor,
                    foregroundColor: ThemeManager.of(context).textPrimary,
                    side:
                        BorderSide(color: ThemeManager.of(context).borderColor),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Prbal.close,
                    size: 16.sp,
                  ),
                  label: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeManager.of(context).errorColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
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

  Widget _buildActiveOrderCard(
    int index,
  ) {
    final services = [
      {
        'title': 'Carpet Cleaning',
        'provider': 'Alex Brown',
        'status': 'In Progress',
        'progress': 0.6
      },
      {
        'title': 'AC Repair',
        'provider': 'Emma Davis',
        'status': 'Starting Soon',
        'progress': 0.2
      },
    ];

    final service = services[index];

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context)
                      .successColor
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Prbal.tools,
                  color: ThemeManager.of(context).successColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'] as String,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Provider: ${service['provider']}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context)
                      .successColor
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  service['status'] as String,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).successColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              LinearProgressIndicator(
                value: (service['progress'] as num).toDouble(),
                backgroundColor: ThemeManager.of(context).borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                    ThemeManager.of(context).successColor),
                minHeight: 8.h,
              ),
              SizedBox(height: 4.h),
              Text(
                '${(((service['progress'] as num).toDouble()) * 100).toInt()}% Complete',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ThemeManager.of(context).textTertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Prbal.message,
                    size: 16.sp,
                  ),
                  label: Text('Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeManager.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Prbal.mapPin,
                    size: 16.sp,
                  ),
                  label: Text('Track'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeManager.of(context).surfaceColor,
                    foregroundColor: ThemeManager.of(context).textPrimary,
                    side:
                        BorderSide(color: ThemeManager.of(context).borderColor),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
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

  Widget _buildHistoryOrderCard(
    int index,
  ) {
    final services = [
      {
        'title': 'Home Painting',
        'provider': 'Lisa Johnson',
        'date': 'Dec 10',
        'rating': '4.8',
        'amount': '\$180'
      },
      {
        'title': 'Furniture Assembly',
        'provider': 'Tom Wilson',
        'date': 'Dec 8',
        'rating': '4.9',
        'amount': '\$120'
      },
      {
        'title': 'Appliance Repair',
        'provider': 'Maria Garcia',
        'date': 'Dec 5',
        'rating': '4.7',
        'amount': '\$95'
      },
      {
        'title': 'Deep Cleaning',
        'provider': 'Chris Lee',
        'date': 'Dec 3',
        'rating': '5.0',
        'amount': '\$150'
      },
      {
        'title': 'Plumbing',
        'provider': 'David Miller',
        'date': 'Nov 28',
        'rating': '4.6',
        'amount': '\$85'
      },
      {
        'title': 'Electrical Work',
        'provider': 'Sarah Taylor',
        'date': 'Nov 25',
        'rating': '4.8',
        'amount': '\$200'
      },
      {
        'title': 'Gardening',
        'provider': 'Jake Brown',
        'date': 'Nov 20',
        'rating': '4.9',
        'amount': '\$70'
      },
      {
        'title': 'Carpet Cleaning',
        'provider': 'Emma Davis',
        'date': 'Nov 15',
        'rating': '4.7',
        'amount': '\$110'
      },
      {
        'title': 'AC Service',
        'provider': 'Mark Johnson',
        'date': 'Nov 10',
        'rating': '4.5',
        'amount': '\$130'
      },
      {
        'title': 'House Cleaning',
        'provider': 'Anna Wilson',
        'date': 'Nov 5',
        'rating': '5.0',
        'amount': '\$90'
      },
    ];

    final service = services[index];

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color:
                      ThemeManager.of(context).infoColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Prbal.checkCircle,
                  color: ThemeManager.of(context).infoColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'] as String,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Provider: ${service['provider']}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                service['amount']!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Service details
          Row(
            children: [
              Icon(
                Prbal.calendar,
                color: ThemeManager.of(context).textTertiary,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                service['date']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
              SizedBox(width: 24.w),
              Icon(
                Prbal.star,
                color: ThemeManager.of(context).warningColor,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                service['rating']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context)
                      .successColor
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).successColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Prbal.refresh,
                    size: 16.sp,
                  ),
                  label: Text('Book Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeManager.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Prbal.star,
                    size: 16.sp,
                  ),
                  label: Text('Review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeManager.of(context).surfaceColor,
                    foregroundColor: ThemeManager.of(context).textPrimary,
                    side:
                        BorderSide(color: ThemeManager.of(context).borderColor),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
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
}
