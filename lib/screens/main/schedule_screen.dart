import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock schedule data
  final List<Map<String, dynamic>> _todaySchedule = [
    {
      'time': '9:00 AM',
      'service': 'House Cleaning',
      'client': 'John Doe',
      'status': 'confirmed',
      'duration': '2 hours',
      'location': '123 Main St',
      'color': const Color(0xFF3B82F6),
    },
    {
      'time': '2:00 PM',
      'service': 'Plumbing Repair',
      'client': 'Jane Smith',
      'status': 'pending',
      'duration': '1.5 hours',
      'location': '456 Oak Ave',
      'color': const Color(0xFF10B981),
    },
    {
      'time': '4:30 PM',
      'service': 'Electrical Work',
      'client': 'Mike Johnson',
      'status': 'confirmed',
      'duration': '3 hours',
      'location': '789 Pine Rd',
      'color': const Color(0xFFF59E0B),
    },
    {
      'time': '7:00 PM',
      'service': 'Garden Maintenance',
      'client': 'Sarah Wilson',
      'status': 'rescheduled',
      'duration': '2.5 hours',
      'location': '321 Elm St',
      'color': const Color(0xFF8B5CF6),
    },
  ];

  @override
  void initState() {
    super.initState();
    debugPrint('🎯 ScheduleScreen: Initializing animations and loading schedule data');
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    debugPrint('🎯 ScheduleScreen: Setting up fade animation controller');
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
    debugPrint('🎯 ScheduleScreen: Starting entrance animations');
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
  }

  @override
  void dispose() {
    debugPrint('🎯 ScheduleScreen: Disposing controllers');
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      appBar: _buildAppBar(themeManager),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: themeManager.backgroundGradient,
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _buildScheduleHeader(themeManager),
                SizedBox(height: 16.h),
                _buildScheduleStats(themeManager),
                SizedBox(height: 20.h),
                Expanded(
                  child: _buildTodaySchedule(themeManager),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(themeManager),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeManager themeManager) {
    debugPrint('🎨 ScheduleScreen: Building app bar with theme colors');
    return AppBar(
      backgroundColor: themeManager.surfaceColor,
      elevation: 0,
      title: Text(
        'Schedule',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: themeManager.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            debugPrint('📅 ScheduleScreen: Opening calendar view');
            _showCalendarBottomSheet(themeManager);
          },
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: themeManager.primaryColor.withValues(alpha: 26), // 0.1 opacity
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Prbal.calendar,
              color: themeManager.primaryColor,
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        IconButton(
          onPressed: () {
            debugPrint('➕ ScheduleScreen: Adding new appointment');
            _showAddAppointmentDialog(themeManager);
          },
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: themeManager.subtleShadow,
            ),
            child: Icon(
              Prbal.plus,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 16.w),
      ],
    );
  }

  Widget _buildScheduleHeader(ThemeManager themeManager) {
    debugPrint('🎨 ScheduleScreen: Building schedule header');
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
        border: Border.all(
          color: themeManager.borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: themeManager.primaryShadow,
            ),
            child: Icon(
              Prbal.calendar,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Schedule',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: themeManager.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatDate(selectedDate),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeManager.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: themeManager.successColor.withValues(alpha: 26), // 0.1 opacity
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '${_todaySchedule.length} appointments',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.successColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleStats(ThemeManager themeManager) {
    debugPrint('🎨 ScheduleScreen: Building schedule statistics');
    final confirmedCount = _todaySchedule.where((item) => item['status'] == 'confirmed').length;
    final pendingCount = _todaySchedule.where((item) => item['status'] == 'pending').length;
    final rescheduledCount = _todaySchedule.where((item) => item['status'] == 'rescheduled').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Confirmed',
            confirmedCount.toString(),
            themeManager.successColor,
            Prbal.checkCircle,
            themeManager,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'Pending',
            pendingCount.toString(),
            themeManager.warningColor,
            Prbal.clock,
            themeManager,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'Rescheduled',
            rescheduledCount.toString(),
            themeManager.infoColor,
            Prbal.calendar,
            themeManager,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon, ThemeManager themeManager) {
    return Container(
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
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 26), // 0.1 opacity
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            count,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: themeManager.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: themeManager.textTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule(ThemeManager themeManager) {
    debugPrint('🎯 ScheduleScreen: Building today\'s schedule with ${_todaySchedule.length} appointments');
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: themeManager.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: themeManager.primaryColor.withValues(alpha: 26), // 0.1 opacity
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: _todaySchedule.isEmpty
                ? _buildEmptySchedule(themeManager)
                : ListView.separated(
                    itemCount: _todaySchedule.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final appointment = _todaySchedule[index];
                      return _buildScheduleItem(
                        appointment['time'],
                        appointment['service'],
                        appointment['client'],
                        appointment['duration'],
                        appointment['location'],
                        appointment['status'],
                        appointment['color'],
                        themeManager,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySchedule(ThemeManager themeManager) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: themeManager.primaryColor.withValues(alpha: 26), // 0.1 opacity
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Icon(
              Prbal.calendar,
              color: themeManager.primaryColor,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No appointments today',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: themeManager.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap the + button to add your first appointment',
            style: TextStyle(
              fontSize: 14.sp,
              color: themeManager.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    String time,
    String service,
    String client,
    String duration,
    String location,
    String status,
    Color color,
    ThemeManager themeManager,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 13), // 0.05 opacity
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 77), // 0.3 opacity
          width: 1,
        ),
        boxShadow: themeManager.subtleShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 51), // 0.2 opacity
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        service,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: themeManager.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 26), // 0.1 opacity
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Prbal.user,
                      size: 12.sp,
                      color: themeManager.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        client,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: themeManager.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Prbal.clock,
                      size: 12.sp,
                      color: themeManager.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: themeManager.textTertiary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Prbal.mapPin,
                      size: 12.sp,
                      color: themeManager.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: themeManager.textTertiary,
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
          SizedBox(width: 12.w),
          Column(
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              SizedBox(height: 4.h),
              Icon(
                Prbal.angleRight,
                size: 16.sp,
                color: themeManager.textTertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(ThemeManager themeManager) {
    return FloatingActionButton.extended(
      onPressed: () {
        debugPrint('➕ ScheduleScreen: Quick add appointment');
        _showAddAppointmentDialog(themeManager);
      },
      backgroundColor: themeManager.primaryColor,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: Icon(Prbal.plus, size: 20.sp),
      label: Text(
        'Add Appointment',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'rescheduled':
        return const Color(0xFF3B82F6);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showCalendarBottomSheet(ThemeManager themeManager) {
    debugPrint('📅 ScheduleScreen: Showing calendar bottom sheet');
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
          boxShadow: themeManager.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: themeManager.borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Select Date',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Calendar functionality coming soon...',
              style: TextStyle(
                fontSize: 16.sp,
                color: themeManager.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _showAddAppointmentDialog(ThemeManager themeManager) {
    debugPrint('➕ ScheduleScreen: Showing add appointment dialog');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: themeManager.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: themeManager.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: themeManager.borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Add New Appointment',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Appointment creation form coming soon...',
              style: TextStyle(
                fontSize: 16.sp,
                color: themeManager.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
