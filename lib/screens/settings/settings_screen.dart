import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/app_services.dart';
import 'package:prbal/components/theme_selector_widget.dart';
import 'package:prbal/components/modern_ui_components.dart';
import 'package:prbal/utils/localization/project_locales.dart';
import 'package:prbal/utils/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/services/auth_service.dart';
import 'package:prbal/services/health_service.dart';
import 'package:prbal/services/performance_service.dart';
// import 'package:prbal/services/notification_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final HealthService _healthService = HealthService();
  final PerformanceService _performanceService = PerformanceService.instance;

  ApplicationHealth? _healthData;
  Map<String, dynamic>? _performanceMetrics;
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  bool _analyticsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadHealthData();
    _loadPerformanceData();
  }

  Future<void> _loadSettings() async {
    // Load user preferences from Hive
    final userData = HiveService.getUserData();
    if (mounted) {
      setState(() {
        _notificationsEnabled = userData?['notifications_enabled'] ?? true;
        _biometricsEnabled = userData?['biometrics_enabled'] ?? false;
        _analyticsEnabled = userData?['analytics_enabled'] ?? true;
      });
    }
  }

  Future<void> _loadHealthData() async {
    try {
      final health = await _healthService.performHealthCheck();
      if (mounted) {
        setState(() {
          _healthData = health;
        });
      }
    } catch (e) {
      debugPrint('Failed to load health data: $e');
    }
  }

  Future<void> _loadPerformanceData() async {
    try {
      final metrics = _performanceService.getPerformanceMetrics();
      if (mounted) {
        setState(() {
          _performanceMetrics = metrics;
        });
      }
    } catch (e) {
      debugPrint('Failed to load performance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userType = HiveService.getUserType();
    final user = ref.watch(authServiceProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
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

                    // System Health Status Card
                    if (_healthData != null && userType == 'admin') _buildSystemHealthCard(isDark),
                    if (_healthData != null && userType == 'admin') SizedBox(height: 20.h),

                    // Performance Metrics Card
                    if (_performanceMetrics != null && userType == 'admin') _buildPerformanceCard(isDark),
                    if (_performanceMetrics != null && userType == 'admin') SizedBox(height: 20.h),

                    // Profile Section
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
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
                            backgroundColor: _getUserTypeColor(userType).withValues(alpha: 0.1),
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
                                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: _getUserTypeColor(userType).withValues(alpha: 0.1),
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
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${user?.totalBookings ?? 0} bookings',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                          user?.isVerified == true ? 'Account verified' : 'Complete verification',
                          Icons.security,
                          user?.isVerified == true ? const Color(0xFF48BB78) : const Color(0xFFED8936),
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
                        _buildNotificationSettingItem(isDark),
                        _buildSecuritySettingItem(isDark),
                        _buildPinResetSettingItem(isDark),
                        _buildThemeSettingItem(isDark),
                        _buildLanguageSettingItem(isDark),
                        _buildAnalyticsSettingItem(isDark),
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

                    // Data & Storage Section
                    _buildSettingsSection(
                      'Data & Storage',
                      [
                        _buildSettingsItem(
                          'Storage Usage',
                          'View app storage and cache usage',
                          Icons.storage,
                          const Color(0xFF38B2AC),
                          isDark,
                          () => _showStorageDialog(isDark),
                        ),
                        _buildSettingsItem(
                          'Clear Cache',
                          'Free up space by clearing cached data',
                          Icons.cleaning_services,
                          const Color(0xFFED8936),
                          isDark,
                          () => _showClearCacheDialog(isDark),
                        ),
                        _buildSettingsItem(
                          'Export Data',
                          'Download your personal data',
                          Icons.download,
                          const Color(0xFF4299E1),
                          isDark,
                          () => _showExportDataDialog(isDark),
                        ),
                        _buildSettingsItem(
                          'Data Sync',
                          'Manage data synchronization settings',
                          Icons.sync,
                          const Color(0xFF9F7AEA),
                          isDark,
                          () => _showDataSyncDialog(isDark),
                        ),
                      ],
                      isDark,
                    ),

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
                            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
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
                                    'Are you sure you want to logout? This will revoke all your device tokens and sign you out.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await _performCompleteLogout();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
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
                color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
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

  // Theme Settings Item
  Widget _buildThemeSettingItem(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showThemeDialog(),
          borderRadius: BorderRadius.circular(8.r),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF38B2AC).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.palette,
                  color: const Color(0xFF38B2AC),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.themeTheme.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Choose your preferred theme',
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

  // Language Settings Item
  Widget _buildLanguageSettingItem(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.language,
                  color: const Color(0xFF667EEA),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.localizationAppLang.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Change app language',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showLanguageDialog(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    LineIcons.angleDown,
                    color: const Color(0xFF667EEA),
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PIN Reset Settings Item
  Widget _buildPinResetSettingItem(bool isDark) {
    final currentUser = ref.watch(authServiceProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: currentUser != null ? () => _showPinResetDialog(isDark) : null,
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.lock,
                  color: const Color(0xFFE53E3E),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy & Security',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      currentUser != null ? 'Reset PIN and security settings' : 'Sign in to access security settings',
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

  // Show Theme Dialog
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.themeThemeChoose.tr()),
        content: const ThemeSelectorWidget(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show Language Dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.localizationLangChoose.tr()),
        content: _changeLocalWithDropdown(context),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Language Dropdown
  DropdownButton<dynamic> _changeLocalWithDropdown(BuildContext context) {
    return DropdownButton(
      value: context.locale,
      items: ProjectLocales.localesMap.entries.map((entry) {
        return DropdownMenuItem(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (value) {
        context.setLocale(value);
        Navigator.pop(context);
      },
    );
  }

  // Show PIN Reset Dialog
  Future<void> _showPinResetDialog(bool isDark) async {
    final currentUser = ref.read(authServiceProvider);
    if (currentUser?.phoneNumber == null) return;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                LineIcons.lock,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Reset PIN',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to reset your PIN?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You will be redirected to create a new PIN.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            child: Text(
              'Cancel',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Reset',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Navigate to PIN reset screen
      context.push(
        RouteEnum.pinEntry.rawValue,
        extra: {
          'phoneNumber': currentUser!.phoneNumber!,
          'isNewUser': true, // Treat as new user to set new PIN
        },
      );
    }
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

  // Enhanced Settings Components

  Widget _buildSystemHealthCard(bool isDark) {
    final isHealthy = _healthData?.overallStatus == HealthStatus.healthy;

    return ModernUIComponents.gradientCard(
      colors: isHealthy
          ? [const Color(0xFF48BB78), const Color(0xFF38A169)]
          : [const Color(0xFFED8936), const Color(0xFFDD6B20)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHealthy ? LineIcons.checkCircle : LineIcons.exclamationTriangle,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'System Health',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isHealthy ? 'Healthy' : 'Warning',
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
          Row(
            children: [
              _buildHealthMetric('API', _healthData?.system.status ?? 'Unknown', Colors.white),
              SizedBox(width: 24.w),
              _buildHealthMetric('Database', _healthData?.database.status ?? 'Unknown', Colors.white),
              SizedBox(width: 24.w),
              _buildHealthMetric('Version', _healthData?.system.version ?? '1.0.0', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(bool isDark) {
    final performanceScore = _performanceMetrics?['performance_score'] as double? ?? 0.0;
    final frameDrops = _performanceMetrics?['frame_drops'] as int? ?? 0;
    final avgFrameTime = _performanceMetrics?['average_frame_time'] as double? ?? 0.0;

    return ModernUIComponents.elevatedCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                color: const Color(0xFF4299E1),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Performance Metrics',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getPerformanceColor(performanceScore).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${performanceScore.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _getPerformanceColor(performanceScore),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildPerformanceMetric('Frame Drops', frameDrops.toString(), isDark),
              SizedBox(width: 24.w),
              _buildPerformanceMetric('Avg Frame Time', '${avgFrameTime.toStringAsFixed(1)}ms', isDark),
              SizedBox(width: 24.w),
              _buildPerformanceMetric('Target', '16.7ms', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(double score) {
    if (score >= 90) return const Color(0xFF48BB78);
    if (score >= 70) return const Color(0xFFED8936);
    return const Color(0xFFE53E3E);
  }

  Widget _buildPerformanceMetric(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettingItem(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFED8936).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              LineIcons.bell,
              color: const Color(0xFFED8936),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Manage your notification preferences',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _notificationsEnabled,
            onChanged: (value) async {
              setState(() {
                _notificationsEnabled = value;
              });
              await _saveNotificationPreference(value);
            },
            activeColor: const Color(0xFFED8936),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettingItem(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showSecurityDialog(isDark),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF9F7AEA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.fingerprint,
                  color: const Color(0xFF9F7AEA),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biometric Authentication',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _biometricsEnabled ? 'Enabled' : 'Disabled',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _biometricsEnabled
                            ? const Color(0xFF48BB78)
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
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

  Widget _buildAnalyticsSettingItem(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.analytics,
              color: const Color(0xFF4299E1),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analytics & Data',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Help improve the app with usage analytics',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _analyticsEnabled,
            onChanged: (value) async {
              setState(() {
                _analyticsEnabled = value;
              });
              await _saveAnalyticsPreference(value);
            },
            activeColor: const Color(0xFF4299E1),
          ),
        ],
      ),
    );
  }

  Future<void> _saveNotificationPreference(bool enabled) async {
    try {
      final userData = HiveService.getUserData() ?? {};
      userData['notifications_enabled'] = enabled;
      await HiveService.saveUserData(userData);

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enabled ? 'Notifications enabled' : 'Notifications disabled'),
            backgroundColor: enabled ? const Color(0xFF48BB78) : const Color(0xFFED8936),
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to save notification preference: $e');
    }
  }

  Future<void> _saveAnalyticsPreference(bool enabled) async {
    try {
      final userData = HiveService.getUserData() ?? {};
      userData['analytics_enabled'] = enabled;
      await HiveService.saveUserData(userData);

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enabled ? 'Analytics enabled' : 'Analytics disabled'),
            backgroundColor: const Color(0xFF4299E1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to save analytics preference: $e');
    }
  }

  Future<void> _showSecurityDialog(bool isDark) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFF9F7AEA).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                LineIcons.fingerprint,
                color: const Color(0xFF9F7AEA),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Security Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile.adaptive(
              title: Text('Biometric Authentication'),
              subtitle: Text('Use fingerprint or face ID to unlock'),
              value: _biometricsEnabled,
              onChanged: (value) {
                setState(() {
                  _biometricsEnabled = value;
                });
                _saveBiometricPreference(value);
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF9F7AEA),
            ),
            Divider(),
            ListTile(
              leading: Icon(LineIcons.key, color: const Color(0xFFE53E3E)),
              title: Text('Reset PIN'),
              subtitle: Text('Change your security PIN'),
              trailing: Icon(LineIcons.angleRight),
              onTap: () {
                Navigator.pop(context);
                _showPinResetDialog(isDark);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBiometricPreference(bool enabled) async {
    try {
      final userData = HiveService.getUserData() ?? {};
      userData['biometrics_enabled'] = enabled;
      await HiveService.saveUserData(userData);

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enabled ? 'Biometric authentication enabled' : 'Biometric authentication disabled'),
            backgroundColor: const Color(0xFF9F7AEA),
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to save biometric preference: $e');
    }
  }

  Future<void> _showStorageDialog(bool isDark) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.storage, color: const Color(0xFF38B2AC)),
            SizedBox(width: 8.w),
            Text('Storage Usage'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStorageItem('App Data', '45.2 MB', const Color(0xFF4299E1)),
            _buildStorageItem('Cache', '12.8 MB', const Color(0xFFED8936)),
            _buildStorageItem('Images', '89.1 MB', const Color(0xFF48BB78)),
            _buildStorageItem('Documents', '23.4 MB', const Color(0xFF9F7AEA)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String size, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Text(label),
          Spacer(),
          Text(size, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _showClearCacheDialog(bool isDark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cleaning_services, color: const Color(0xFFED8936)),
            SizedBox(width: 8.w),
            Text('Clear Cache'),
          ],
        ),
        content: Text(
          'This will clear all cached data to free up space. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED8936),
            ),
            child: Text('Clear Cache', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Implement cache clearing logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cache cleared successfully'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  Future<void> _showExportDataDialog(bool isDark) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, color: const Color(0xFF4299E1)),
            SizedBox(width: 8.w),
            Text('Export Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose what data to export:'),
            SizedBox(height: 16.h),
            CheckboxListTile(
              title: Text('Profile Data'),
              value: true,
              onChanged: null,
            ),
            CheckboxListTile(
              title: Text('Booking History'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Messages'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement data export logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data export started'),
                  backgroundColor: const Color(0xFF4299E1),
                ),
              );
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDataSyncDialog(bool isDark) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.sync, color: const Color(0xFF9F7AEA)),
            SizedBox(width: 8.w),
            Text('Data Sync'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Auto Sync'),
              subtitle: Text('Automatically sync data when connected'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('WiFi Only'),
              subtitle: Text('Only sync when connected to WiFi'),
              value: false,
              onChanged: (value) {},
            ),
            ListTile(
              title: Text('Last Sync'),
              subtitle: Text('2 minutes ago'),
              trailing: TextButton(
                onPressed: () {
                  // Implement manual sync
                },
                child: Text('Sync Now'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Performs complete logout with proper token management
  /// This method will:
  /// 1. Get user tokens to see all active sessions
  /// 2. Revoke all tokens for security
  /// 3. Perform logout
  /// 4. Clear local data
  /// 5. Navigate to welcome screen
  Future<void> _performCompleteLogout() async {
    debugPrint('🔄 Starting complete logout process...');

    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 16),
                Text('Signing out...'),
              ],
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }

      final authService = ref.read(authServiceProvider.notifier);

      // Step 1: Get current user tokens for debugging
      debugPrint('📋 Getting user tokens...');
      final tokensResponse = await authService.getUserTokens();
      if (tokensResponse.success && tokensResponse.data != null) {
        debugPrint('✅ Found ${tokensResponse.data!.length} active tokens');
        for (var i = 0; i < tokensResponse.data!.length; i++) {
          final token = tokensResponse.data![i];
          debugPrint('   Token ${i + 1}: ${token['id']} - Created: ${token['created_at']}');
        }
      } else {
        debugPrint('⚠️ Could not retrieve user tokens: ${tokensResponse.message}');
      }

      // Step 2: Revoke all tokens for security
      debugPrint('🔐 Revoking all tokens...');
      final revokeResponse = await authService.revokeAllTokens();
      if (revokeResponse.success) {
        debugPrint('✅ Successfully revoked all tokens');
      } else {
        debugPrint('⚠️ Failed to revoke tokens: ${revokeResponse.message}');
        // Continue with logout even if token revocation fails
      }

      // Step 3: Perform logout to clean up server-side session
      debugPrint('🚪 Performing logout...');
      final logoutResponse = await authService.logout();
      if (logoutResponse.success) {
        debugPrint('✅ Logout successful');
      } else {
        debugPrint('⚠️ Logout failed: ${logoutResponse.message}');
        // Continue anyway as local data will be cleared
      }

      // Step 4: Clear local storage (this is done in the logout method but let's be explicit)
      debugPrint('🧹 Clearing local data...');
      await HiveService.setLoggedIn(false);
      await HiveService.clearUserData();
      await HiveService.removeAuthToken();
      await HiveService.removeRefreshToken();
      debugPrint('✅ Local data cleared');

      // Step 5: Navigate to welcome screen
      debugPrint('🏠 Navigating to welcome screen...');
      if (mounted) {
        // Clear the snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Navigate to welcome screen and clear the entire navigation stack
        NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
        debugPrint('✅ Navigation completed');

        // Show success message briefly
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully signed out'),
                backgroundColor: Color(0xFF48BB78),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }

      debugPrint('🎉 Complete logout process finished successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error during logout process: $e');
      debugPrint('📍 Stack trace: $stackTrace');

      // Even if there's an error, clear local data and navigate
      try {
        debugPrint('🔄 Attempting emergency cleanup...');
        await HiveService.setLoggedIn(false);
        await HiveService.clearUserData();
        await HiveService.removeAuthToken();
        await HiveService.removeRefreshToken();

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);

          // Show error message
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed out (with errors): ${e.toString()}'),
                  backgroundColor: const Color(0xFFED8936),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          });
        }
        debugPrint('✅ Emergency cleanup completed');
      } catch (cleanupError) {
        debugPrint('❌ Emergency cleanup failed: $cleanupError');
        // Last resort - just navigate away
        if (mounted) {
          NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
        }
      }
    }
  }
}
