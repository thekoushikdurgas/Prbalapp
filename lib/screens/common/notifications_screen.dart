import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('📢 NotificationsScreen: Building notifications interface');
    debugPrint(
        '📢 NotificationsScreen: Dark mode: ${themeManager.themeManager}');

    return Scaffold(
      backgroundColor: themeManager.themeManager
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor:
            themeManager.themeManager ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeManager.themeManager
                ? Colors.white
                : const Color(0xFF1F2937),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('📢 NotificationsScreen: Mark all as read pressed');
              // TODO: Implement mark all as read functionality
            },
            icon: Icon(
              Prbal.check,
              color: themeManager.themeManager
                  ? Colors.white
                  : const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 10,
        itemBuilder: (context, index) {
          debugPrint(
              '📢 NotificationsScreen: Building notification item $index');
          return _buildNotificationItem(
            'Service Request Update',
            'Your house cleaning service has been confirmed for tomorrow at 10 AM.',
            '2 minutes ago',
            false,
            themeManager,
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String subtitle,
    String time,
    bool isRead,
    ThemeManager themeManager,
  ) {
    debugPrint(
        '📢 NotificationsScreen: Building notification card for "$title"');

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: themeManager.themeManager ? const Color(0xFF1E293B) : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF3B82F6),
          child: Icon(
            Prbal.bell,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: themeManager.themeManager
                ? Colors.white
                : const Color(0xFF1F2937),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                color: themeManager.themeManager
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              time,
              style: TextStyle(
                fontSize: 12.sp,
                color: themeManager.themeManager
                    ? const Color(0xFF64748B)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          debugPrint('📢 NotificationsScreen: Notification tapped: "$title"');
          // TODO: Handle notification tap - mark as read, navigate to details
        },
      ),
    );
  }
}
