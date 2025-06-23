import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/widgets/modern_ui_components.dart';

class ProviderProfileScreen extends ConsumerStatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  ConsumerState<ProviderProfileScreen> createState() =>
      _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends ConsumerState<ProviderProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            backgroundColor:
                isDark ? const Color(0xFF1E293B) : const Color(0xFF3B82F6),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                        : [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          LineIcons.user,
                          size: 50.sp,
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFF3B82F6),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'John Provider',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: ModernUIComponents.metricCard(
                          title: 'Services',
                          value: '12',
                          icon: LineIcons.tools,
                          iconColor: const Color(0xFF3B82F6),
                          isDark: isDark,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ModernUIComponents.metricCard(
                          title: 'Rating',
                          value: '4.8',
                          icon: LineIcons.star,
                          iconColor: const Color(0xFFFBBF24),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Profile Options
                  ModernUIComponents.elevatedCard(
                    isDark: isDark,
                    child: Column(
                      children: [
                        _buildProfileOption(
                          'Edit Profile',
                          LineIcons.edit,
                          () => context.push('/edit-profile'),
                          isDark,
                        ),
                        const Divider(),
                        _buildProfileOption(
                          'My Services',
                          LineIcons.list,
                          () => context.push('/my-services'),
                          isDark,
                        ),
                        const Divider(),
                        _buildProfileOption(
                          'Earnings',
                          LineIcons.moneyBill,
                          () => context.push('/earnings'),
                          isDark,
                        ),
                        const Divider(),
                        _buildProfileOption(
                          'Settings',
                          LineIcons.cog,
                          () => context.push('/settings'),
                          isDark,
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
    );
  }

  Widget _buildProfileOption(
      String title, IconData icon, VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF1F2937),
        ),
      ),
      trailing: Icon(
        LineIcons.angleRight,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
      ),
      onTap: onTap,
    );
  }
}
