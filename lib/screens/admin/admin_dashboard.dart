import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// Full Admin Dashboard with bottom navigation bar
/// Use this for direct route access
/// This class provides the complete admin dashboard experience with navigation
class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    // Debug: Track when full admin dashboard is initialized
    debugPrint('🏠 AdminDashboard: Full dashboard widget initialized');
    debugPrint('🏠 AdminDashboard: This version includes bottom navigation bar');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏠 AdminDashboard: Building full dashboard with bottom navigation');

    return Scaffold(
      // Main dashboard content without navigation (prevents circular dependency)
      body: const AdminDashboardContent(),
    );
  }

  @override
  void dispose() {
    debugPrint('🏠 AdminDashboard: Full dashboard widget disposed');
    super.dispose();
  }
}

/// Content-only Admin Dashboard without bottom navigation
/// Use this within BottomNavigation to prevent circular dependency
/// This separation is crucial for preventing memory leaks and circular references
class AdminDashboardContent extends ConsumerStatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  ConsumerState<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends ConsumerState<AdminDashboardContent> {
  @override
  void initState() {
    super.initState();
    // Debug: Track when content-only dashboard is initialized
    debugPrint('📊 AdminDashboardContent: Content-only dashboard initialized');
    debugPrint('📊 AdminDashboardContent: This version prevents circular dependency');
  }

  @override
  Widget build(BuildContext context) {
    // Get current theme mode for consistent styling

    debugPrint('📊 AdminDashboardContent: Building dashboard content');
    // debugPrint('📊 AdminDashboardContent: Dark mode: $themeManager');

    return Scaffold(
      // Background color that adapts to theme
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ========== SLIVER APP BAR SECTION ==========
            // Collapsible app bar that stays pinned at top when scrolled
            SliverAppBar(
              expandedHeight: 120.h, // Height when expanded
              floating: false, // Don't show when scrolling up
              pinned: true, // Stay visible when collapsed
              backgroundColor: ThemeManager.of(context).surfaceColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
                title: Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                ),
                // Gradient background that adapts to theme
                background: Container(
                  decoration: BoxDecoration(
                    gradient: ThemeManager.of(context).surfaceGradient,
                  ),
                ),
              ),
              actions: [
                // Notifications button
                IconButton(
                  onPressed: () {
                    debugPrint('🔔 AdminDashboard: Notifications button pressed');
                    debugPrint('🔔 AdminDashboard: Navigating to ${RouteEnum.notifications.rawValue}');
                    try {
                      // Navigate to notifications - using predefined route enum for consistency
                      context.push(RouteEnum.notifications.rawValue);
                      debugPrint('🔔 AdminDashboard: Navigation to notifications successful');
                    } catch (e) {
                      debugPrint('❌ AdminDashboard: Navigation to notifications failed: $e');
                    }
                  },
                  icon: Icon(
                    Prbal.bell,
                    color: ThemeManager.of(context).textSecondary,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
            ),

            // ========== MAIN CONTENT SECTION ==========
            // Scrollable content area with all dashboard widgets
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // ========== SYSTEM STATUS CARD ==========
                    // Real-time system health monitoring widget
                    _buildSystemStatusCard(),

                    SizedBox(height: 24.h),

                    // ========== KEY METRICS GRID ==========
                    // Two-row grid showing important business metrics
                    _buildMetricsGrid(),

                    SizedBox(height: 24.h),

                    // ========== QUICK ACTIONS SECTION ==========
                    // Grid of admin action buttons for common tasks
                    _buildQuickActionsSection(),

                    SizedBox(height: 24.h),

                    // ========== RECENT ACTIVITY SECTION ==========
                    // Live feed of recent system activities and events
                    _buildRecentActivitySection(),

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

  // ========== SYSTEM STATUS CARD BUILDER ==========
  /// Builds the system status monitoring card showing API, database, and payment health
  /// This provides real-time operational status for critical system components
  Widget _buildSystemStatusCard() {
    debugPrint('📊 AdminDashboard: Building system status card');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status header with operational indicator
          Row(
            children: [
              Text(
                'System',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).textPrimary,
                ),
              ),
              const Spacer(),
              // Global system status indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    // Green dot indicator for operational status
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF48BB78),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'All Systems Operational',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF48BB78),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Individual system metrics row
          Row(
            children: [
              _buildSystemMetric(
                'API Response', // API performance metric
                '99.9%',
                Prbal.server,
                const Color(0xFF48BB78),
              ),
              _buildSystemMetric(
                'Database', // Database connectivity metric
                '100%',
                Prbal.database,
                const Color(0xFF4299E1),
              ),
              _buildSystemMetric(
                'Payment', // Payment gateway status
                '98.7%',
                Prbal.creditCard,
                const Color(0xFF9F7AEA),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== METRICS GRID BUILDER ==========
  /// Builds the key business metrics grid showing users, bookings, revenue, and support data
  /// This provides quick insights into business performance
  Widget _buildMetricsGrid() {
    debugPrint('📊 AdminDashboard: Building metrics grid');

    return Column(
      children: [
        // First row: Users and Bookings
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Users', // User base size
                '12,450',
                '+5.2% this week', // Growth indicator
                Prbal.users,
                const Color(0xFF4299E1),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildMetricCard(
                'Active Bookings', // Current active bookings
                '847',
                '+12.3% today', // Daily growth
                Prbal.calendar,
                const Color(0xFF48BB78),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Second row: Revenue and Support
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Revenue', // Financial performance
                '\$84,350',
                '+8.1% this month', // Monthly growth
                Prbal.dollarSign,
                const Color(0xFF9F7AEA),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildMetricCard(
                'Support Tickets', // Customer support load
                '23',
                '-15.4% today', // Support ticket reduction (positive trend)
                Prbal.helpCircle,
                const Color(0xFFED8936),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========== QUICK ACTIONS SECTION BUILDER ==========
  /// Builds the quick actions grid for common admin tasks
  /// This provides one-tap access to frequently used admin functions
  Widget _buildQuickActionsSection() {
    debugPrint('📊 AdminDashboard: Building quick actions section');

    return Column(
      children: [
        // Section title
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // 4-column grid of action buttons
        GridView.count(
          shrinkWrap: true, // Don't take more space than needed
          physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
          crossAxisCount: 4, // 4 items per row
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.85, // Slightly taller aspect ratio to accommodate text
          children: [
            _buildQuickActionCard(
              'Manage Users', // User management functionality
              Prbal.edit3,
              const Color(0xFF4299E1),
              onTap: () {
                debugPrint('👥 AdminDashboard: Manage Users button pressed');
                debugPrint('👥 AdminDashboard: Navigating to ${RouteEnum.adminUsers.rawValue}');
                try {
                  // Navigate to user management screen
                  context.push(RouteEnum.adminUsers.rawValue);
                  debugPrint('👥 AdminDashboard: Navigation to user management successful');
                } catch (e) {
                  debugPrint('❌ AdminDashboard: Navigation to user management failed: $e');
                }
              },
            ),
            _buildQuickActionCard(
              'View Reports', // Analytics and reporting
              Prbal.calculator,
              const Color(0xFF48BB78),
              onTap: () {
                debugPrint('📈 AdminDashboard: View Reports button pressed');
                debugPrint('📈 AdminDashboard: Navigating to /admin/reports');
                try {
                  // Navigate to reports section
                  context.push('/admin/reports');
                  debugPrint('📈 AdminDashboard: Navigation to reports successful');
                } catch (e) {
                  debugPrint('❌ AdminDashboard: Navigation to reports failed: $e');
                }
              },
            ),
            _buildQuickActionCard(
              'System Settings', // Configuration management
              Prbal.cogs,
              const Color(0xFF9F7AEA),
              onTap: () {
                debugPrint('⚙️ AdminDashboard: System Settings button pressed');
                debugPrint('⚙️ AdminDashboard: Navigating to /admin/settings');
                try {
                  // Navigate to system settings
                  context.push('/admin/settings');
                  debugPrint('⚙️ AdminDashboard: Navigation to settings successful');
                } catch (e) {
                  debugPrint('❌ AdminDashboard: Navigation to settings failed: $e');
                }
              },
            ),
            _buildQuickActionCard(
              'Send Alert', // Emergency communication system
              Prbal.alertTriangle,
              const Color(0xFFED8936),
              onTap: () {
                debugPrint('🚨 AdminDashboard: Send Alert button pressed');
                debugPrint('🚨 AdminDashboard: Navigating to /admin/alerts');
                try {
                  // Navigate to alert management
                  context.push('/admin/alerts');
                  debugPrint('🚨 AdminDashboard: Navigation to alerts successful');
                } catch (e) {
                  debugPrint('❌ AdminDashboard: Navigation to alerts failed: $e');
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  // ========== RECENT ACTIVITY SECTION BUILDER ==========
  /// Builds the recent system activity feed showing live system events
  /// This provides real-time visibility into system operations and user activities
  Widget _buildRecentActivitySection() {
    debugPrint('📊 AdminDashboard: Building recent activity section');

    return Column(
      children: [
        // Section title
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Recent System Activity',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Activity feed container
        Container(
          decoration: BoxDecoration(
            color: ThemeManager.of(context).surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: ThemeManager.of(context).primaryShadow,
          ),
          child: Column(
            children: [
              // Recent activity items (could be fetched from API in real implementation)
              _buildActivityItem(
                'New user registration', // User onboarding event
                'Sarah Johnson signed up as a provider',
                '10 min ago',
                Prbal.userPlus,
                const Color(0xFF4299E1),
              ),
              const Divider(height: 1),
              _buildActivityItem(
                'Payment processed', // Financial transaction
                'Transaction #TXN-12345 completed',
                '25 min ago',
                Prbal.checkCircle,
                const Color(0xFF48BB78),
              ),
              const Divider(height: 1),
              _buildActivityItem(
                'Support ticket created', // Customer service event
                'User reported booking issue #SUP-789',
                '1 hour ago',
                Prbal.alertCircle,
                const Color(0xFFED8936),
              ),
              const Divider(height: 1),
              _buildActivityItem(
                'System maintenance', // Operational event
                'Scheduled database backup completed',
                '3 hours ago',
                Prbal.server,
                const Color(0xFF9F7AEA),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ========== INDIVIDUAL WIDGET BUILDERS ==========
  // These methods build specific UI components used throughout the dashboard

  /// Builds individual system metric display (API, Database, Payment status)
  /// Shows health percentage with icon and label
  Widget _buildSystemMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    debugPrint('📊 AdminDashboard: Building system metric for $label: $value');

    return Expanded(
      child: Column(
        children: [
          // Metric icon with theme-aware coloring
          Icon(
            icon,
            color: color,
            size: 20.sp,
          ),
          SizedBox(height: 8.h),
          // Metric value (percentage)
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          // Metric label
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: ThemeManager.of(context).textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds individual metric cards for business KPIs
  /// Shows value, trend, and icon with proper theming
  Widget _buildMetricCard(
    String title,
    String value,
    String trend,
    IconData icon,
    Color color,
  ) {
    debugPrint('📊 AdminDashboard: Building metric card for $title: $value ($trend)');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon container with colored background
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20.sp,
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 12.h),
          // Metric title
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: ThemeManager.of(context).textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          // Metric value (main number)
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          // Trend indicator (growth/decline percentage)
          Text(
            trend,
            style: TextStyle(
              fontSize: 11.sp,
              // Green for positive trends (+), red for negative trends (-)
              color: trend.contains('+') ? const Color(0xFF48BB78) : const Color(0xFFE53E3E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds quick action cards for admin functions
  /// Provides tap functionality and visual feedback
  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    debugPrint('📊 AdminDashboard: Building quick action card for $title');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap ??
            () {
              // Default action if no specific onTap provided
              debugPrint('🔄 AdminDashboard: Default action triggered for $title');
            },
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1), // Semi-transparent background
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Prevent column from taking more space than needed
            children: [
              // Action icon
              Icon(
                icon,
                color: color,
                size: 20.sp, // Reduced icon size to fit better
              ),
              SizedBox(height: 6.h), // Reduced spacing
              // Action title
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.sp, // Slightly smaller font
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Allow text to wrap to 2 lines if needed
                  overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds individual activity items for the recent activity feed
  /// Shows activity type, description, timestamp, and status icon
  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    debugPrint('📊 AdminDashboard: Building activity item: $title - $time');

    return ListTile(
      // Activity icon with colored background
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20.sp,
        ),
      ),
      // Activity title
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: ThemeManager.of(context).textPrimary,
        ),
      ),
      // Activity description
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: ThemeManager.of(context).textSecondary,
        ),
      ),
      // Activity timestamp
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 11.sp,
          color: ThemeManager.of(context).textTertiary,
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('📊 AdminDashboardContent: Content dashboard disposed');
    super.dispose();
  }
}
