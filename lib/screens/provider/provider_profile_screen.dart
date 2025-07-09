import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/widgets/modern_ui_components.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

class ProviderProfileScreen extends ConsumerStatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  ConsumerState<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends ConsumerState<ProviderProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            floating: false,
            pinned: true,
            backgroundColor: ThemeManager.of(context).primaryColor,
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
                  gradient: ThemeManager.of(context).primaryGradient,
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
                          Prbal.user,
                          size: 50.sp,
                          color: ThemeManager.of(context).primaryColor,
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
                          themeManager: ThemeManager.of(context),
                          title: 'Services',
                          value: '12',
                          icon: Prbal.tools,
                          iconColor: ThemeManager.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ModernUIComponents.metricCard(
                          themeManager: ThemeManager.of(context),
                          title: 'Rating',
                          value: '4.8',
                          icon: Prbal.star,
                          iconColor: ThemeManager.of(context).warningColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Profile Options
                  ModernUIComponents.elevatedCard(
                    themeManager: ThemeManager.of(context),
                    child: Column(
                      children: [
                        _buildProfileOption(
                          'Edit Profile',
                          Prbal.edit,
                          () => context.push('/edit-profile'),
                        ),
                        const Divider(),
                        _buildProfileOption(
                          'My Services',
                          Prbal.list,
                          () => context.push('/my-services'),
                        ),
                        const Divider(),
                        _buildProfileOption(
                          'Earnings',
                          Prbal.wallet3,
                          () => context.push('/earnings'),
                        ),
                        const Divider(),
                        _buildProfileOption(
                          'Settings',
                          Prbal.cog,
                          () => context.push('/settings'),
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
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: ThemeManager.of(context).textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: ThemeManager.of(context).textPrimary,
        ),
      ),
      trailing: Icon(
        Prbal.angleRight,
        color: ThemeManager.of(context).textSecondary,
      ),
      onTap: onTap,
    );
  }
}
