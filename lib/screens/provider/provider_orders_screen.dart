import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

class ProviderOrdersScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const ProviderOrdersScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<ProviderOrdersScreen> createState() =>
      _ProviderOrdersScreenState();
}

class _ProviderOrdersScreenState extends ConsumerState<ProviderOrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🎯 ProviderOrdersScreen: Building screen with initialTabIndex: ${widget.initialTabIndex}');
    debugPrint(
        '🎨 ProviderOrdersScreen: ThemeManager - isDark: ${ThemeManager.of(context).themeManager}, primaryColor: ${ThemeManager.of(context).primaryColor}');

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
                        'My Orders',
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
                      gradient: ThemeManager.of(context).surfaceGradient,
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
                          ThemeManager.of(context).textSecondary,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(text: 'Pending'),
                        Tab(text: 'Active'),
                        Tab(text: 'Completed'),
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
                  _buildPendingOrders(),
                  _buildActiveOrders(),
                  _buildCompletedOrders(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingOrders() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 5, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: ThemeManager.of(context).elevatedShadow,
          ),
          child: _buildPendingOrderCard(index),
        );
      },
    );
  }

  Widget _buildActiveOrders() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 3, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: ThemeManager.of(context).elevatedShadow,
          ),
          child: _buildActiveOrderCard(index),
        );
      },
    );
  }

  Widget _buildCompletedOrders() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 8, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: ThemeManager.of(context).elevatedShadow,
          ),
          child: _buildCompletedOrderCard(index),
        );
      },
    );
  }

  Widget _buildPendingOrderCard(
    int index,
  ) {
    final titles = [
      'Home Cleaning Service',
      'AC Repair',
      'Garden Maintenance',
      'Computer Setup',
      'Plumbing Fix',
    ];

    final customers = [
      'Sarah Wilson',
      'John Smith',
      'Emily Brown',
      'Michael Davis',
      'Lisa Johnson',
    ];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context)
                      .warningColor
                      .withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Prbal.clock,
                  color: ThemeManager.of(context).warningColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[index % titles.length],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    Text(
                      customers[index % customers.length],
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
                      .withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).warningColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Prbal.calendar,
                size: 16.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Tomorrow, 2:00 PM - 4:00 PM',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Prbal.dollarSign,
                size: 16.sp,
                color: ThemeManager.of(context).successColor,
              ),
              SizedBox(width: 8.w),
              Text(
                '\$${75 + (index * 25)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ThemeManager.of(context).successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Decline order
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeManager.of(context).errorColor,
                    side:
                        BorderSide(color: ThemeManager.of(context).errorColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Decline',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Accept order
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeManager.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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
    final titles = [
      'Home Cleaning Service',
      'AC Repair',
      'Garden Maintenance',
    ];

    final customers = [
      'Sarah Wilson',
      'John Smith',
      'Emily Brown',
    ];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color:
                      ThemeManager.of(context).infoColor.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Prbal.play,
                  color: ThemeManager.of(context).infoColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[index % titles.length],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    Text(
                      customers[index % customers.length],
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
                  color:
                      ThemeManager.of(context).infoColor.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'In Progress',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).infoColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Prbal.mapMarker,
                size: 16.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${index + 123} Main Street, Downtown',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ThemeManager.of(context).textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Prbal.dollarSign,
                size: 16.sp,
                color: ThemeManager.of(context).successColor,
              ),
              SizedBox(width: 8.w),
              Text(
                '\$${100 + (index * 50)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ThemeManager.of(context).successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Call customer
                  },
                  icon: Icon(Prbal.phone, size: 16.sp),
                  label: Text(
                    'Call',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeManager.of(context).infoColor,
                    side: BorderSide(color: ThemeManager.of(context).infoColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Mark as completed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeManager.of(context).successColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Complete',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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

  Widget _buildCompletedOrderCard(
    int index,
  ) {
    final titles = [
      'Home Cleaning Service',
      'AC Repair',
      'Garden Maintenance',
      'Computer Setup',
      'Plumbing Fix',
      'Painting Service',
      'Furniture Assembly',
      'TV Mounting',
    ];

    final customers = [
      'Sarah Wilson',
      'John Smith',
      'Emily Brown',
      'Michael Davis',
      'Lisa Johnson',
      'Robert Taylor',
      'Jennifer White',
      'David Lee',
    ];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context)
                      .successColor
                      .withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Prbal.checkCircle,
                  color: ThemeManager.of(context).successColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[index % titles.length],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    Text(
                      customers[index % customers.length],
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
                      .withValues(alpha: 26),
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
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Prbal.calendar,
                size: 16.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Completed ${index + 1} day${index == 0 ? '' : 's'} ago',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Prbal.dollarSign,
                size: 16.sp,
                color: ThemeManager.of(context).successColor,
              ),
              SizedBox(width: 8.w),
              Text(
                '\$${75 + (index * 30)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ThemeManager.of(context).successColor,
                ),
              ),
              SizedBox(width: 16.w),
              Row(
                children: [
                  Icon(
                    Prbal.star,
                    size: 16.sp,
                    color: ThemeManager.of(context).warningColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${4.5 + (index * 0.1).round() / 10}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeManager.of(context).warningColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          OutlinedButton(
            onPressed: () {
              // View details or reorder
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: ThemeManager.of(context).primaryColor,
              side: BorderSide(color: ThemeManager.of(context).primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            child: Center(
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
