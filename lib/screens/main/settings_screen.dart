import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/app_services.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userType = ref.watch(userTypeProvider);
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120.h,
              floating: false,
              pinned: true,
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF1E1E1E), const Color(0xFF2D2D2D)]
                          : [Colors.white, const Color(0xFFF7FAFC)],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // Profile Section
                    Container(
                      padding: EdgeInsets.all(20.w),
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
                      child: Row(
                        children: [
                          // Profile Picture
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: _getUserTypeColor(userType)
                                .withValues(alpha: 0.1),
                            child: Icon(
                              _getUserTypeIcon(userType),
                              color: _getUserTypeColor(userType),
                              size: 32.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? 'User Name',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF2D3748),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: _getUserTypeColor(userType)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    _getUserTypeDisplayName(userType),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _getUserTypeColor(userType),
                                    ),
                                  ),
                                ),
                                if (userType == 'provider') ...[
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        LineIcons.star,
                                        size: 14.sp,
                                        color: const Color(0xFFED8936),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        user?.rating.toString() ?? '4.8',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFED8936),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '•',
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${user?.totalBookings ?? 0} bookings',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Edit Button
                          IconButton(
                            onPressed: () {
                              // Navigate to edit profile
                            },
                            icon: Icon(
                              LineIcons.edit,
                              color: _getUserTypeColor(userType),
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Account Settings
                    _buildSettingsSection(
                      'Account',
                      [
                        _buildSettingsItem(
                          'Personal Information',
                          'Update your profile details',
                          LineIcons.user,
                          const Color(0xFF4299E1),
                          isDark,
                          () {
                            // Navigate to personal info
                          },
                        ),
                        if (userType == 'provider')
                          _buildSettingsItem(
                            'Business Profile',
                            'Manage your services and portfolio',
                            LineIcons.briefcase,
                            const Color(0xFF48BB78),
                            isDark,
                            () {
                              // Navigate to business profile
                            },
                          ),
                        _buildSettingsItem(
                          'Payment & Billing',
                          'Manage payment methods and history',
                          LineIcons.creditCard,
                          const Color(0xFF9F7AEA),
                          isDark,
                          () {
                            // Navigate to payment settings
                          },
                        ),
                        _buildSettingsItem(
                          'Verification',
                          user?.isVerified == true
                              ? 'Account verified'
                              : 'Complete verification',
                          Icons.security,
                          user?.isVerified == true
                              ? const Color(0xFF48BB78)
                              : const Color(0xFFED8936),
                          isDark,
                          () {
                            // Navigate to verification
                          },
                        ),
                      ],
                      isDark,
                    ),

                    SizedBox(height: 24.h),

                    // App Settings
                    _buildSettingsSection(
                      'App Settings',
                      [
                        _buildSettingsItem(
                          'Notifications',
                          'Manage your notification preferences',
                          LineIcons.bell,
                          const Color(0xFFED8936),
                          isDark,
                          () {
                            // Navigate to notification settings
                          },
                        ),
                        _buildSettingsItem(
                          'Privacy & Security',
                          'Control your privacy settings',
                          LineIcons.lock,
                          const Color(0xFFE53E3E),
                          isDark,
                          () {
                            // Navigate to privacy settings
                          },
                        ),
                        _buildSettingsItem(
                          'Theme',
                          'Choose your preferred theme',
                          LineIcons.palette,
                          const Color(0xFF38B2AC),
                          isDark,
                          () {
                            // Navigate to theme settings
                          },
                        ),
                        _buildSettingsItem(
                          'Language',
                          'Change app language',
                          LineIcons.language,
                          const Color(0xFF667EEA),
                          isDark,
                          () {
                            // Navigate to language settings
                          },
                        ),
                      ],
                      isDark,
                    ),

                    if (userType == 'admin') ...[
                      SizedBox(height: 24.h),

                      // Admin Settings
                      _buildSettingsSection(
                        'Admin Controls',
                        [
                          _buildSettingsItem(
                            'User Management',
                            'Manage users and permissions',
                            LineIcons.users,
                            const Color(0xFF4299E1),
                            isDark,
                            () {
                              // Navigate to user management
                            },
                          ),
                          _buildSettingsItem(
                            'Content Moderation',
                            'Review and moderate content',
                            Icons.security,
                            const Color(0xFF48BB78),
                            isDark,
                            () {
                              // Navigate to content moderation
                            },
                          ),
                          _buildSettingsItem(
                            'Analytics & Reports',
                            'View platform analytics',
                            Icons.bar_chart,
                            const Color(0xFF9F7AEA),
                            isDark,
                            () {
                              // Navigate to analytics
                            },
                          ),
                          _buildSettingsItem(
                            'System Settings',
                            'Configure platform settings',
                            LineIcons.cog,
                            const Color(0xFFED8936),
                            isDark,
                            () {
                              // Navigate to system settings
                            },
                          ),
                        ],
                        isDark,
                      ),
                    ],

                    SizedBox(height: 24.h),

                    // Support & Legal
                    _buildSettingsSection(
                      'Support & Legal',
                      [
                        _buildSettingsItem(
                          'Help Center',
                          'Get help and support',
                          LineIcons.questionCircle,
                          const Color(0xFF4299E1),
                          isDark,
                          () {
                            // Navigate to help center
                          },
                        ),
                        _buildSettingsItem(
                          'Contact Us',
                          'Get in touch with our team',
                          LineIcons.envelope,
                          const Color(0xFF48BB78),
                          isDark,
                          () {
                            // Navigate to contact
                          },
                        ),
                        _buildSettingsItem(
                          'Terms of Service',
                          'Read our terms and conditions',
                          LineIcons.file,
                          const Color(0xFF9F7AEA),
                          isDark,
                          () {
                            // Navigate to terms
                          },
                        ),
                        _buildSettingsItem(
                          'Privacy Policy',
                          'Read our privacy policy',
                          LineIcons.userShield,
                          const Color(0xFFED8936),
                          isDark,
                          () {
                            // Navigate to privacy policy
                          },
                        ),
                      ],
                      isDark,
                    ),

                    SizedBox(height: 24.h),

                    // Logout Button
                    Container(
                      width: double.infinity,
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.r),
                          onTap: () async {
                            // Show logout confirmation
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                    'Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final logout = ref.read(logoutProvider);
                              await logout();
                              // Navigate to login
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE53E3E)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.logout,
                                    color: const Color(0xFFE53E3E),
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFE53E3E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // App Version
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),

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

  Widget _buildSettingsSection(
    String title,
    List<Widget> items,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
        ),
        Container(
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
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    bool isDark,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LineIcons.angleRight,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getUserTypeColor(String? userType) {
    switch (userType) {
      case 'provider':
        return const Color(0xFF48BB78);
      case 'customer':
        return const Color(0xFF4299E1);
      case 'admin':
        return const Color(0xFF9F7AEA);
      default:
        return const Color(0xFF4299E1);
    }
  }

  IconData _getUserTypeIcon(String? userType) {
    switch (userType) {
      case 'provider':
        return LineIcons.tools;
      case 'customer':
        return LineIcons.user;
      case 'admin':
        return LineIcons.crown;
      default:
        return LineIcons.user;
    }
  }

  String _getUserTypeDisplayName(String? userType) {
    switch (userType) {
      case 'provider':
        return 'Service Provider';
      case 'customer':
        return 'Customer';
      case 'admin':
        return 'Administrator';
      default:
        return 'User';
    }
  }
}
