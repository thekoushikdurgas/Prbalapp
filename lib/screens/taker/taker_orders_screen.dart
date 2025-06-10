import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'My Bookings',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Show filter options
                        },
                        icon: Icon(
                          LineIcons.filter,
                          color:
                              isDark ? Colors.white : const Color(0xFF4A5568),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2D2D2D)
                          : const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFF4299E1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          isDark ? Colors.grey[400] : Colors.grey[600],
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
                  _buildUpcomingOrders(isDark),
                  _buildActiveOrders(isDark),
                  _buildOrderHistory(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingOrders(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 4, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
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
          child: _buildUpcomingOrderCard(index, isDark),
        );
      },
    );
  }

  Widget _buildActiveOrders(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 2, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
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
          child: _buildActiveOrderCard(index, isDark),
        );
      },
    );
  }

  Widget _buildOrderHistory(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 10, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
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
          child: _buildHistoryOrderCard(index, isDark),
        );
      },
    );
  }

  Widget _buildUpcomingOrderCard(int index, bool isDark) {
    final services = [
      'Home Cleaning Service',
      'AC Repair & Maintenance',
      'Garden Maintenance',
      'Computer Setup',
    ];

    final providers = [
      'Sarah Johnson',
      'Mike Wilson',
      'Lisa Brown',
      'David Lee',
    ];

    final dates = [
      'Tomorrow, 2:00 PM',
      'Friday, 10:00 AM',
      'Saturday, 9:00 AM',
      'Monday, 3:00 PM',
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
                  color: const Color(0xFF4299E1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  LineIcons.calendar,
                  color: const Color(0xFF4299E1),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      services[index],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      'Provider: ${providers[index]}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF4299E1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Confirmed',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4299E1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                LineIcons.clock,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                dates[index],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                LineIcons.mapMarker,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${index + 123} Main Street, Downtown',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                LineIcons.dollarSign,
                size: 16.sp,
                color: const Color(0xFF48BB78),
              ),
              SizedBox(width: 8.w),
              Text(
                '\$${75 + (index * 25)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF48BB78),
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
                    // Call provider
                  },
                  icon: Icon(LineIcons.phone, size: 16.sp),
                  label: Text(
                    'Call',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4299E1),
                    side: const BorderSide(color: Color(0xFF4299E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Reschedule
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFED8936),
                    side: const BorderSide(color: Color(0xFFED8936)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Reschedule',
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

  Widget _buildActiveOrderCard(int index, bool isDark) {
    final services = [
      'Home Cleaning Service',
      'AC Repair & Maintenance',
    ];

    final providers = [
      'Sarah Johnson',
      'Mike Wilson',
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
                  color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  LineIcons.play,
                  color: const Color(0xFF48BB78),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      services[index],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      'Provider: ${providers[index]}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'In Progress',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF48BB78),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Icon(
                LineIcons.clock,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                'Started 30 minutes ago',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              Icon(
                LineIcons.mapMarker,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${index + 123} Main Street, Downtown',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              Icon(
                LineIcons.dollarSign,
                size: 16.sp,
                color: const Color(0xFF48BB78),
              ),
              SizedBox(width: 8.w),
              Text(
                '\$${100 + (index * 50)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF48BB78),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Live tracking feature
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF48BB78).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  LineIcons.locationArrow,
                  color: const Color(0xFF48BB78),
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Provider is on the way - ETA: 5 minutes',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF48BB78),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Call provider
                  },
                  icon: Icon(LineIcons.phone, size: 16.sp),
                  label: Text(
                    'Call Provider',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4299E1),
                    side: const BorderSide(color: Color(0xFF4299E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Chat
                  },
                  icon: Icon(LineIcons.comment, size: 16.sp),
                  label: Text(
                    'Chat',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF48BB78),
                    side: const BorderSide(color: Color(0xFF48BB78)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryOrderCard(int index, bool isDark) {
    final services = [
      'Home Cleaning Service',
      'AC Repair & Maintenance',
      'Garden Maintenance',
      'Computer Setup',
      'Plumbing Fix',
      'Painting Service',
      'Beauty & Spa',
      'Car Wash',
      'Pet Grooming',
      'Electrical Work',
    ];

    final providers = [
      'Sarah Johnson',
      'Mike Wilson',
      'Lisa Brown',
      'David Lee',
      'Emma Davis',
      'Robert Taylor',
      'Maria Garcia',
      'James Wilson',
      'Jessica Smith',
      'Michael Brown',
    ];

    final ratings = [4.8, 4.9, 4.7, 4.6, 4.8, 4.9, 4.5, 4.7, 4.8, 4.6];

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
                  color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  LineIcons.checkCircle,
                  color: const Color(0xFF48BB78),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      services[index % services.length],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      'Provider: ${providers[index % providers.length]}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF48BB78),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                LineIcons.calendar,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                'Completed ${index + 1} day${index == 0 ? '' : 's'} ago',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                LineIcons.dollarSign,
                size: 16.sp,
                color: const Color(0xFF48BB78),
              ),
              SizedBox(width: 8.w),
              Text(
                '\$${75 + (index * 30)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF48BB78),
                ),
              ),
              SizedBox(width: 16.w),
              Row(
                children: [
                  Icon(
                    LineIcons.star,
                    size: 16.sp,
                    color: const Color(0xFFED8936),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    ratings[index % ratings.length].toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFED8936),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Book again
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4299E1),
                    side: const BorderSide(color: Color(0xFF4299E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Book Again',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View details
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        isDark ? Colors.grey[400] : Colors.grey[600],
                    side: BorderSide(
                        color: isDark ? Colors.grey[600]! : Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
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
        ],
      ),
    );
  }
}
