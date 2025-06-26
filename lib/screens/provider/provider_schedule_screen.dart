import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/widgets/modern_ui_components.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

class ProviderScheduleScreen extends ConsumerStatefulWidget {
  const ProviderScheduleScreen({super.key});

  @override
  ConsumerState<ProviderScheduleScreen> createState() => _ProviderScheduleScreenState();
}

class _ProviderScheduleScreenState extends ConsumerState<ProviderScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeManager.surfaceColor,
        title: Text(
          'Schedule',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeManager.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Prbal.plus,
              color: themeManager.textPrimary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Calendar Header
            ModernUIComponents.elevatedCard(
              themeManager: themeManager,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = DateTime(
                              selectedDate.year,
                              selectedDate.month - 1,
                            );
                          });
                        },
                        icon: Icon(
                          Prbal.angleLeft,
                          color: themeManager.textPrimary,
                        ),
                      ),
                      Text(
                        '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: themeManager.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = DateTime(
                              selectedDate.year,
                              selectedDate.month + 1,
                            );
                          });
                        },
                        icon: Icon(
                          Prbal.angleRight,
                          color: themeManager.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildCalendarGrid(themeManager),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Today's Schedule
            Expanded(
              child: ModernUIComponents.elevatedCard(
                themeManager: themeManager,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Schedule',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: themeManager.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildScheduleItem(
                            '9:00 AM',
                            'House Cleaning',
                            'John Doe',
                            themeManager.primaryColor,
                            themeManager,
                          ),
                          SizedBox(height: 12.h),
                          _buildScheduleItem(
                            '2:00 PM',
                            'Plumbing Repair',
                            'Jane Smith',
                            themeManager.successColor,
                            themeManager,
                          ),
                          SizedBox(height: 12.h),
                          _buildScheduleItem(
                            '4:30 PM',
                            'Electrical Work',
                            'Mike Johnson',
                            themeManager.warningColor,
                            themeManager,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(ThemeManager themeManager) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 7 * 6, // 6 weeks
      itemBuilder: (context, index) {
        if (index < 7) {
          // Week day headers
          final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
          return Center(
            child: Text(
              weekDays[index],
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textSecondary,
              ),
            ),
          );
        }

        final dayIndex = index - 7;
        final day = dayIndex + 1;
        final isToday = day == DateTime.now().day;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
            });
          },
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isToday
                  ? themeManager.primaryColor
                  : (selectedDate.day == day ? themeManager.surfaceColor : Colors.transparent),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isToday ? Colors.white : themeManager.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleItem(String time, String service, String client, Color color, ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: themeManager.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  service,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.textPrimary,
                  ),
                ),
                Text(
                  client,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeManager.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Prbal.angleRight,
            color: themeManager.textSecondary,
            size: 16.sp,
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}
