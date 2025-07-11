import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:prbal/widgets/settings/settings_section_widget.dart';
import 'package:prbal/widgets/settings/system_health_widget.dart';

// Navigation
import 'package:prbal/utils/navigation/routes/route_enum.dart';

// Services
//
import 'package:prbal/services/health_service.dart';
import 'package:prbal/services/performance_service.dart';

/// AdminToolManagerScreen - Modern admin dashboard for managing tools
///
/// **Purpose**: Provides navigation to different admin management screens:
/// - Service Categories: Navigate to category management
/// - Service SubCategories: Navigate to subcategory management
/// - Services: Navigate to service management
///
/// **Design**: Modern Material Design with advanced theming, animations, and component architecture
/// **Features**:
/// - Advanced animation system with fade and slide animations
/// - Modern gradient app bar with proper spacing
/// - System health monitoring for admin users
/// - Performance metrics display
/// - Enhanced loading states with theme-aware styling
/// - Component-based architecture for maintainability
/// **Memory Safety**: Uses content-only version to prevent circular dependency
/// with BottomNavigation widget, avoiding memory leaks and out-of-memory errors.
class AdminToolManagerScreen extends ConsumerStatefulWidget {
  const AdminToolManagerScreen({super.key});

  @override
  ConsumerState<AdminToolManagerScreen> createState() =>
      _AdminToolManagerScreenState();
}

class _AdminToolManagerScreenState extends ConsumerState<AdminToolManagerScreen>
    with TickerProviderStateMixin {
  // Services for admin features
  final HealthService _healthService = HealthService();
  final PerformanceService _performanceService = PerformanceService.instance;

  // State variables
  ApplicationHealth _healthData = ApplicationHealth(
    system: SystemHealth(
      status: 'Healthy',
      version: '1.0.0',
      timestamp: DateTime.now(),
    ),
    database: DatabaseHealth(
      status: 'Healthy',
      timestamp: DateTime.now(),
    ),
    overallStatus: HealthStatus.healthy,
    lastUpdate: DateTime.now(),
    connectivityStatus: ConnectivityStatus.unknown,
  );
  Map<String, dynamic> _performanceMetrics = {};
  bool _isLoadingData = true;

  // Animation controllers matching settings screen
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🛠️ AdminToolManager: Initializing modern admin dashboard with enhanced features');

    _initializeAnimations();
    _loadAllAdminData();
  }

  /// Initializes entrance animations matching settings screen
  void _initializeAnimations() {
    debugPrint('🛠️ AdminToolManager: Initializing animations');

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  /// Loads all admin-specific data in parallel for better performance
  Future<void> _loadAllAdminData() async {
    debugPrint('🛠️ AdminToolManager: Loading all admin data');

    try {
      // Load data in parallel for better performance
      await Future.wait([
        _loadHealthData(),
        _loadPerformanceData(),
      ]);

      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
        debugPrint('🛠️ AdminToolManager: All admin data loaded successfully');
      }
    } catch (e) {
      debugPrint('❌ AdminToolManager: Error loading admin data: $e');
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    }
  }

  /// Loads health data for admin monitoring
  Future<void> _loadHealthData() async {
    debugPrint('🛠️ AdminToolManager: Loading health data');

    try {
      final health = await _healthService.performHealthCheck();
      if (mounted) {
        setState(() {
          _healthData = health!;
        });
        debugPrint(
            '🛠️ AdminToolManager: Health data loaded - Status: ${health?.overallStatus}');
      }
    } catch (e) {
      debugPrint('❌ AdminToolManager: Error loading health data: $e');
    }
  }

  /// Loads performance metrics for admin monitoring
  Future<void> _loadPerformanceData() async {
    debugPrint('🛠️ AdminToolManager: Loading performance data');

    try {
      final metrics = _performanceService.getPerformanceMetrics();
      if (mounted) {
        setState(() {
          _performanceMetrics = metrics;
        });
        debugPrint('🛠️ AdminToolManager: Performance data loaded');
      }
    } catch (e) {
      debugPrint('❌ AdminToolManager: Error loading performance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🛠️ AdminToolManager: Building modern admin dashboard UI');

    // final authState = ref.watch(authenticationStateProvider);

    debugPrint('🛠️ AdminToolManager: Theme manager initialized');
    // debugPrint('🛠️ AdminToolManager: User authenticated: ${authState.isAuthenticated}');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Modern App Bar
                _buildModernAppBar(),

                // Main Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Loading Indicator
                      if (_isLoadingData) _buildLoadingIndicator(),

                      // System Health Widget (Admin only)
                      SystemHealthWidget(healthData: _healthData),

                      // Performance Metrics Widget (Admin only)
                      _buildPerformanceWidget(),

                      // Admin Tools Section
                      _buildAdminToolsSection(),

                      // Admin Settings Section (existing content)
                      _buildAdminSettings(),

                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds modern app bar with gradient background (matching settings screen)
  Widget _buildModernAppBar() {
    debugPrint('🛠️ AdminToolManager: Building modern app bar');

    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).surfaceGradient,
        ),
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
          title: Text(
            'Admin Tools',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
              letterSpacing: -1.0,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: 20.h, right: 16.w),
          child: IconButton(
            onPressed: () {
              context.push(RouteEnum.adminToolManager.rawValue);
            },
            icon: Icon(
              Prbal.cog,
              color: ThemeManager.of(context).textSecondary,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  // ========== HEADER SECTION ==========

  // ========== NAVIGATION CARDS ==========

  // ========== NAVIGATION CARD ==========

  // ========== ADMIN SETTINGS SECTION ==========
  Widget _buildAdminSettings() {
    debugPrint('⚙️ AdminToolManager: Building admin settings section');

    return SettingsSectionWidget(
      title: 'Admin Tools & Settings',
      children: [
        // ========== CATEGORY, SUBCATEGORY & SERVICE MANAGEMENT ==========
        // SettingsItemWidget(
        //   title: 'Category Management',
        //   subtitle: 'Advanced category settings and bulk operations',
        //   icon: Prbal.tags,
        //   iconColor: const Color(0xFF3182CE),
        //   onTap: () {
        //     debugPrint('⚙️ Category Management tapped');
        //     context.push(RouteEnum.adminCategoryManager.rawValue);
        //   },
        // ),
        // SettingsItemWidget(
        //   title: 'Subcategory Management',
        //   subtitle: 'Advanced subcategory settings and organization',
        //   icon: Prbal.openstreetmap,
        //   iconColor: const Color(0xFF319795),
        //   onTap: () {
        //     debugPrint('⚙️ Subcategory Management tapped');
        //     context.push(RouteEnum.adminSubcategoryManager.rawValue);
        //   },
        // ),
        // SettingsItemWidget(
        //   title: 'Service Management',
        //   subtitle: 'Advanced service controls and moderation',
        //   icon: Prbal.layers5,
        //   iconColor: const Color(0xFF38A169),
        //   onTap: () {
        //     debugPrint('⚙️ Service Management tapped');
        //     context.push(RouteEnum.adminServiceManager.rawValue);
        //   },
        // ),

        // ========== DIVIDER ==========
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 8.h),
        //   height: 1,
        //   color: ThemeManager.of(context).dividerColor.withValues(alpha: 77),
        // ),

        // ========== GENERAL ADMIN SETTINGS ==========
        SettingsItemWidget(
          title: 'User Management',
          subtitle: 'Manage users, roles, and permissions',
          icon: Prbal.users,
          iconColor: const Color(0xFF48BB78),
          onTap: () {
            debugPrint('⚙️ User Management tapped');
            // TODO: Navigate to user management
          },
        ),
        SettingsItemWidget(
          title: 'Platform Analytics',
          subtitle: 'View detailed platform statistics and reports',
          icon: Prbal.statsBars,
          iconColor: const Color(0xFF9F7AEA),
          onTap: () {
            debugPrint('⚙️ Platform Analytics tapped');
            // TODO: Navigate to analytics dashboard
          },
        ),
        SettingsItemWidget(
          title: 'System Configuration',
          subtitle: 'Configure platform settings and features',
          icon: Prbal.cogs,
          iconColor: const Color(0xFF667EEA),
          onTap: () {
            debugPrint('⚙️ System Configuration tapped');
            // TODO: Navigate to system config
          },
        ),
        SettingsItemWidget(
          title: 'Content Moderation',
          subtitle: 'Review and moderate platform content',
          icon: Prbal.security,
          iconColor: const Color(0xFFED8936),
          onTap: () {
            debugPrint('⚙️ Content Moderation tapped');
            // TODO: Navigate to content moderation
          },
        ),
        SettingsItemWidget(
          title: 'Backup & Security',
          subtitle: 'Manage data backups and security settings',
          icon: Prbal.security,
          iconColor: const Color(0xFF4299E1),
          onTap: () {
            debugPrint('⚙️ Backup & Security tapped');
            // TODO: Navigate to backup settings
          },
        ),
        SettingsItemWidget(
          title: 'Admin Privileges',
          subtitle: 'Manage admin roles and access levels',
          icon: Prbal.shield4,
          iconColor: const Color(0xFFE53E3E),
          onTap: () => _showAdminPrivilegesDialog(),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E).withValues(alpha: 26),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: const Color(0xFFE53E3E).withValues(alpha: 77),
                width: 1,
              ),
            ),
            child: Text(
              'ADMIN',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE53E3E),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========== ADMIN PRIVILEGES DIALOG ==========
  void _showAdminPrivilegesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Prbal.shield4,
                color: const Color(0xFFE53E3E),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              const Text('Admin Privileges'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Admin Permissions:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 12.h),
              _buildPermissionItem('Full Platform Access', true),
              _buildPermissionItem('User Management', true),
              _buildPermissionItem('Content Moderation', true),
              _buildPermissionItem('System Configuration', true),
              _buildPermissionItem('Analytics Access', true),
              _buildPermissionItem('Security Management', true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('⚙️ Admin Privileges: Edit permissions tapped');
                Navigator.of(context).pop();
                // TODO: Navigate to admin permissions editor
              },
              child: const Text('Edit Permissions'),
            ),
          ],
        );
      },
    );
  }

  // ========== PERMISSION ITEM HELPER ==========
  Widget _buildPermissionItem(String permission, bool granted) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            granted ? Prbal.checkCircle : Prbal.cancel,
            color: granted ? const Color(0xFF48BB78) : const Color(0xFFE53E3E),
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              permission,
              style: TextStyle(
                fontSize: 13.sp,
                color: granted
                    ? null
                    : ThemeManager.of(context).conditionalColor(
                        lightColor: Colors.grey[600]!,
                        darkColor: Colors.grey[400]!,
                      ),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds loading indicator (matching settings screen design)
  Widget _buildLoadingIndicator() {
    debugPrint('🛠️ AdminToolManager: Building loading indicator');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeManager.of(context).primaryColor),
            ),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: Text(
              'Loading admin dashboard...',
              style: TextStyle(
                fontSize: 16.sp,
                color: ThemeManager.of(context).textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds performance widget (matching settings screen design)
  Widget _buildPerformanceWidget() {
    debugPrint('🛠️ AdminToolManager: Building performance widget');

    final performanceScore =
        _performanceMetrics['performance_score'] as double? ?? 95.0;
    final frameDrops = _performanceMetrics['frame_drops'] as int? ?? 0;
    final avgFrameTime =
        _performanceMetrics['average_frame_time'] as double? ?? 16.5;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: ThemeManager.of(context).elevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Prbal.tachometer,
                color: ThemeManager.of(context).primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Text(
                  'Admin Dashboard Performance',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getPerformanceColor(performanceScore)
                      .withValues(alpha: 26),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPerformanceMetric('Frame Drops', frameDrops.toString()),
              SizedBox(width: 16.w),
              _buildPerformanceMetric(
                  'Avg Frame Time', '${avgFrameTime.toStringAsFixed(1)}ms'),
              SizedBox(width: 16.w),
              _buildPerformanceMetric('Target', '16.7ms'),
            ],
          ),
        ],
      ),
    );
  }

  /// Gets performance color based on score
  Color _getPerformanceColor(double score) {
    if (score >= 90) return const Color(0xFF48BB78);
    if (score >= 70) return const Color(0xFFED8936);
    return const Color(0xFFE53E3E);
  }

  /// Builds performance metric item
  Widget _buildPerformanceMetric(
    String label,
    String value,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              color: ThemeManager.of(context).textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Builds admin tools section with modern card design
  Widget _buildAdminToolsSection() {
    debugPrint('🛠️ AdminToolManager: Building admin tools section');

    return SettingsSectionWidget(
      title: 'Management Tools',
      children: [
        SettingsItemWidget(
          title: 'Category Management',
          subtitle: 'Create, edit, and organize service categories',
          icon: Prbal.tags,
          iconColor: ThemeManager.of(context).primaryColor,
          onTap: () {
            debugPrint('🛠️ Category Management tapped');
            HapticFeedback.lightImpact();
            context.push(RouteEnum.adminCategoryManager.rawValue);
          },
        ),
        SettingsItemWidget(
          title: 'Subcategory Management',
          subtitle: 'Manage subcategories within service categories',
          icon: Prbal.openstreetmap,
          iconColor: ThemeManager.of(context).successColor,
          onTap: () {
            debugPrint('🛠️ Subcategory Management tapped');
            HapticFeedback.lightImpact();
            context.push(RouteEnum.adminSubcategoryManager.rawValue);
          },
        ),
        SettingsItemWidget(
          title: 'Service Management',
          subtitle: 'View, moderate, and manage all platform services',
          icon: Prbal.layers5,
          iconColor: ThemeManager.of(context).infoColor,
          onTap: () {
            debugPrint('🛠️ Service Management tapped');
            HapticFeedback.lightImpact();
            context.push(RouteEnum.adminServiceManager.rawValue);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    debugPrint('🛠️ AdminToolManager: Disposing controllers');
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}
