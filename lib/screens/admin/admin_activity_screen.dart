// Placeholder screen for admin activity
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/theme/theme_manager.dart';
import '../../utils/icon/prbal_icons.dart';

/// Comprehensive Admin Activity Screen showcasing all ThemeManager capabilities
class AdminActivityScreen extends StatefulWidget {
  const AdminActivityScreen({super.key});

  @override
  State<AdminActivityScreen> createState() => _AdminActivityScreenState();
}

class _AdminActivityScreenState extends State<AdminActivityScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample data for activity demonstration
  final List<ActivityItem> _activities = [
    ActivityItem(
      id: 'ACT001',
      title: 'User Registration Surge',
      description: 'Increased user registrations in the past 24 hours',
      type: ActivityType.info,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      priority: Priority.medium,
      category: 'User Management',
    ),
    ActivityItem(
      id: 'ACT002',
      title: 'System Performance Alert',
      description: 'Database query response time exceeded threshold',
      type: ActivityType.warning,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      priority: Priority.high,
      category: 'System',
    ),
    ActivityItem(
      id: 'ACT003',
      title: 'Payment Processing Success',
      description: 'All payment transactions processed successfully',
      type: ActivityType.success,
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      priority: Priority.low,
      category: 'Finance',
    ),
    ActivityItem(
      id: 'ACT004',
      title: 'Security Breach Detected',
      description: 'Suspicious login attempts from multiple IPs',
      type: ActivityType.error,
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      priority: Priority.critical,
      category: 'Security',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    debugPrint('🚀 AdminActivityScreen: Initializing with ${_activities.length} activities');
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Comprehensive theme debugging

    // ThemeManager.of(context).logGradientInfo();
    // debugPrint('🎯 AdminActivityScreen: Building with theme mode: ${ThemeManager.of(context).themeManager ? 'Dark' : 'Light'}');
    // debugPrint('🎨 AdminActivityScreen: Primary color: ${ThemeManager.of(context).primaryColor}');
    // debugPrint('🎨 AdminActivityScreen: Background color: ${ThemeManager.of(context).backgroundColor}');

    return Scaffold(
      // Use ThemeManager background with gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with Glass Morphism
              _buildGlassMorphismAppBar(),

              // Main Content Area
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildMainContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button with Primary Gradient
      floatingActionButton: _buildThemeAwareFAB(),
    );
  }

  /// Glass Morphism App Bar showcasing advanced ThemeManager features
  Widget _buildGlassMorphismAppBar() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: ThemeManager.of(context).enhancedGlassMorphism.copyWith(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: ThemeManager.of(context).elevatedShadow,
          ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).glassGradient,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: ThemeManager.of(context).borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Back Button with Primary Gradient
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: ThemeManager.of(context).primaryShadow,
              ),
              child: Icon(
                Prbal.arrowLeft,
                size: 20.sp,
                color: ThemeManager.of(context).textInverted,
              ),
            ),

            SizedBox(width: 16.w),

            // Title Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Activity',
                    style: ThemeManager.of(context).theme.textTheme.headlineSmall?.copyWith(
                          color: ThemeManager.of(context).textPrimary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Real-time system monitoring',
                    style: ThemeManager.of(context).theme.textTheme.bodyMedium?.copyWith(
                          color: ThemeManager.of(context).textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            // Status Indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).successGradient,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: ThemeManager.of(context).subtleShadow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: ThemeManager.of(context).statusOnline,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ThemeManager.of(context).statusOnline.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Live',
                    style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                          color: ThemeManager.of(context).textInverted,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Main content area with comprehensive ThemeManager showcase
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Cards Row
          _buildStatisticsCards(),

          SizedBox(height: 24.h),

          // System Status Showcase - Using all status colors
          _buildSystemStatusShowcase(),

          SizedBox(height: 24.h),

          // Accent Colors Showcase - Using all accent gradients
          _buildAccentColorsShowcase(),

          SizedBox(height: 24.h),

          // Activity Filter Section
          _buildActivityFilters(),

          SizedBox(height: 24.h),

          // Activities List
          _buildActivitiesList(),

          SizedBox(height: 100.h), // Bottom padding for FAB
        ],
      ),
    );
  }

  /// Statistics cards showcasing all gradient types
  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Activities',
            '${_activities.length}',
            Prbal.activity,
            ThemeManager.of(context).primaryGradient,
            ThemeManager.of(context).primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'Critical Issues',
            '${_activities.where((a) => a.priority == Priority.critical).length}',
            Prbal.alertTriangle,
            ThemeManager.of(context).errorGradient,
            ThemeManager.of(context).errorColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            'Success Rate',
            '94.2%',
            Prbal.checkCircle,
            ThemeManager.of(context).successGradient,
            ThemeManager.of(context).successColor,
          ),
        ),
      ],
    );
  }

  /// Individual statistics card
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1,
        ),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: ThemeManager.of(context).primaryShadow,
            ),
            child: Icon(
              icon,
              size: 16.sp,
              color: ThemeManager.of(context).textInverted,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: ThemeManager.of(context).theme.textTheme.headlineSmall?.copyWith(
                  color: ThemeManager.of(context).textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: ThemeManager.of(context).theme.textTheme.bodySmall?.copyWith(
                  color: ThemeManager.of(context).textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  /// Activity filters with theme-aware chips
  Widget _buildActivityFilters() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).neutralGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ThemeManager.of(context).borderSecondary),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context).infoColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Prbal.filter,
                  size: 16.sp,
                  color: ThemeManager.of(context).textInverted,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Activity Filters',
                style: ThemeManager.of(context).theme.textTheme.titleMedium?.copyWith(
                      color: ThemeManager.of(context).textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildFilterChip('All', true),
              _buildFilterChip('Critical', false),
              _buildFilterChip('Warnings', false),
              _buildFilterChip('Success', false),
              _buildFilterChip('Today', false),
            ],
          ),
        ],
      ),
    );
  }

  /// Theme-aware filter chip
  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: isSelected ? ThemeManager.of(context).secondaryGradient : null,
        color: isSelected ? null : ThemeManager.of(context).cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? ThemeManager.of(context).secondaryColor : ThemeManager.of(context).borderColor,
          width: 1,
        ),
        boxShadow: isSelected ? ThemeManager.of(context).primaryShadow : null,
      ),
      child: Text(
        label,
        style: ThemeManager.of(context).theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? ThemeManager.of(context).textInverted : ThemeManager.of(context).textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
      ),
    );
  }

  /// Activities list with comprehensive theming
  Widget _buildActivitiesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).warningGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Prbal.list,
                size: 16.sp,
                color: ThemeManager.of(context).textInverted,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Recent Activities',
              style: ThemeManager.of(context).theme.textTheme.titleLarge?.copyWith(
                    color: ThemeManager.of(context).textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _activities.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final activity = _activities[index];
            return _buildActivityCard(activity);
          },
        ),
      ],
    );
  }

  /// Individual activity card with full ThemeManager integration
  Widget _buildActivityCard(ActivityItem activity) {
    final typeColors = _getActivityTypeColors(activity.type);
    final priorityColors = _getPriorityColors(activity.priority);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: typeColors['border']!,
          width: 1,
        ),
        boxShadow: ThemeManager.of(context).elevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: typeColors['gradient'] as LinearGradient,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: ThemeManager.of(context).primaryShadow,
                ),
                child: Icon(
                  _getActivityTypeIcon(activity.type),
                  size: 18.sp,
                  color: ThemeManager.of(context).textInverted,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: ThemeManager.of(context).theme.textTheme.titleMedium?.copyWith(
                            color: ThemeManager.of(context).textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      activity.description,
                      style: ThemeManager.of(context).theme.textTheme.bodySmall?.copyWith(
                            color: ThemeManager.of(context).textSecondary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Priority Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: priorityColors['gradient'] as LinearGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  activity.priority.name.toUpperCase(),
                  style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                        color: ThemeManager.of(context).textInverted,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Footer Row
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ThemeManager.of(context).cardBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ThemeManager.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(
                  Prbal.tag,
                  size: 14.sp,
                  color: ThemeManager.of(context).textTertiary,
                ),
                SizedBox(width: 6.w),
                Text(
                  activity.category,
                  style: ThemeManager.of(context).theme.textTheme.labelMedium?.copyWith(
                        color: ThemeManager.of(context).textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                Icon(
                  Prbal.clock,
                  size: 14.sp,
                  color: ThemeManager.of(context).textQuaternary,
                ),
                SizedBox(width: 6.w),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                        color: ThemeManager.of(context).textQuaternary,
                      ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '#${activity.id}',
                  style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                        color: ThemeManager.of(context).textQuaternary,
                        fontFamily: ThemeManager.fontFamilySemiExpanded,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Theme-aware Floating Action Button
  Widget _buildThemeAwareFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).primaryShadow,
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('🔄 AdminActivityScreen: Refresh button pressed');
          // Add refresh functionality here
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: Icon(
          Prbal.refresh,
          color: ThemeManager.of(context).textInverted,
          size: 20.sp,
        ),
        label: Text(
          'Refresh',
          style: ThemeManager.of(context).theme.textTheme.labelLarge?.copyWith(
                color: ThemeManager.of(context).textInverted,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  /// Get activity type colors and gradients
  Map<String, dynamic> _getActivityTypeColors(ActivityType type) {
    switch (type) {
      case ActivityType.success:
        return {
          'gradient': ThemeManager.of(context).successGradient,
          'border': ThemeManager.of(context).successColor,
        };
      case ActivityType.warning:
        return {
          'gradient': ThemeManager.of(context).warningGradient,
          'border': ThemeManager.of(context).warningColor,
        };
      case ActivityType.error:
        return {
          'gradient': ThemeManager.of(context).errorGradient,
          'border': ThemeManager.of(context).errorColor,
        };
      case ActivityType.info:
        return {
          'gradient': ThemeManager.of(context).infoGradient,
          'border': ThemeManager.of(context).infoColor,
        };
    }
  }

  /// Get priority colors and gradients
  Map<String, dynamic> _getPriorityColors(Priority priority) {
    switch (priority) {
      case Priority.critical:
        return {'gradient': ThemeManager.of(context).errorGradient};
      case Priority.high:
        return {'gradient': ThemeManager.of(context).warningGradient};
      case Priority.medium:
        return {'gradient': ThemeManager.of(context).secondaryGradient};
      case Priority.low:
        return {'gradient': ThemeManager.of(context).neutralGradient};
    }
  }

  /// Get activity type icon
  IconData _getActivityTypeIcon(ActivityType type) {
    switch (type) {
      case ActivityType.success:
        return Prbal.checkCircle;
      case ActivityType.warning:
        return Prbal.alertTriangle;
      case ActivityType.error:
        return Prbal.xCircle;
      case ActivityType.info:
        return Prbal.info4;
    }
  }

  /// Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// System Status Showcase using all status colors and neutral colors
  Widget _buildSystemStatusShowcase() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeManager.of(context).backgroundSecondary,
            ThemeManager.of(context).backgroundTertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ThemeManager.of(context).borderFocus),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with special colors
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context).newIndicator,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeManager.of(context).newIndicator.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Prbal.globe,
                  size: 20.sp,
                  color: ThemeManager.of(context).textInverted,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Status Monitor',
                      style: ThemeManager.of(context).theme.textTheme.titleLarge?.copyWith(
                            color: ThemeManager.of(context).textPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Real-time system health indicators',
                      style: ThemeManager.of(context).theme.textTheme.bodyMedium?.copyWith(
                            color: ThemeManager.of(context).textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              // Verified badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context).verifiedColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Prbal.verified,
                      size: 12.sp,
                      color: ThemeManager.of(context).textInverted,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'VERIFIED',
                      style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                            color: ThemeManager.of(context).textInverted,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Status indicators grid using all status colors
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 2.5,
            children: [
              _buildStatusIndicatorCard(
                'Online Services',
                '24/7',
                ThemeManager.of(context).statusOnline,
                Prbal.checkCircle,
              ),
              _buildStatusIndicatorCard(
                'Maintenance Mode',
                'Scheduled',
                ThemeManager.of(context).statusAway,
                Prbal.wrench,
              ),
              _buildStatusIndicatorCard(
                'High Load Alert',
                'Active',
                ThemeManager.of(context).statusBusy,
                Prbal.alertTriangle,
              ),
              _buildStatusIndicatorCard(
                'Backup Services',
                'Offline',
                ThemeManager.of(context).statusOffline,
                Prbal.database,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Additional indicators using special colors
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context).modalBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ThemeManager.of(context).borderSecondary),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Prbal.star,
                        size: 16.sp,
                        color: ThemeManager.of(context).favoriteColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Favorites: ${ThemeManager.of(context).favoriteColor.toARGB32().toRadixString(16).toUpperCase()}',
                        style: ThemeManager.of(context).theme.textTheme.labelMedium?.copyWith(
                              color: ThemeManager.of(context).textTertiary,
                              fontFamily: ThemeManager.fontFamilySemiExpanded,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context).surfaceElevated,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ThemeManager.of(context).borderSecondary),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Prbal.starFull,
                        size: 16.sp,
                        color: ThemeManager.of(context).ratingColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Rating: 4.8/5',
                        style: ThemeManager.of(context).theme.textTheme.labelMedium?.copyWith(
                              color: ThemeManager.of(context).textTertiary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Status indicator card helper
  Widget _buildStatusIndicatorCard(
    String title,
    String status,
    Color statusColor,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeManager.of(context).cardBackground,
            ThemeManager.of(context).inputBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 16.sp,
              color: statusColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: ThemeManager.of(context).theme.textTheme.labelMedium?.copyWith(
                        color: ThemeManager.of(context).textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  status,
                  style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Accent Colors Showcase using all accent gradients and neutral colors
  Widget _buildAccentColorsShowcase() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ThemeManager.of(context).overlayBackground,
            ThemeManager.of(context).modalBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ThemeManager.of(context).borderColor),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).shadowDark,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: ThemeManager.of(context).shimmerGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Prbal.palette,
                  size: 20.sp,
                  color: ThemeManager.of(context).textInverted,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  'Accent Color Palette',
                  style: ThemeManager.of(context).theme.textTheme.titleLarge?.copyWith(
                        color: ThemeManager.of(context).textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Accent gradients showcase
          Row(
            children: [
              Expanded(
                child: _buildAccentCard(
                  'Accent 1',
                  ThemeManager.of(context).accent1Gradient,
                  ThemeManager.of(context).accent1,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildAccentCard(
                  'Accent 2',
                  ThemeManager.of(context).accent2Gradient,
                  ThemeManager.of(context).accent2,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: _buildAccentCard(
                  'Accent 3',
                  ThemeManager.of(context).accent3Gradient,
                  ThemeManager.of(context).accent3,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildAccentCard(
                  'Accent 4',
                  ThemeManager.of(context).accent4Gradient,
                  ThemeManager.of(context).accent4,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Neutral colors gradient bar
          Container(
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ThemeManager.of(context).borderColor),
            ),
            child: Row(
              children: [
                _buildNeutralSegment(ThemeManager.of(context).neutral100, '100'),
                _buildNeutralSegment(ThemeManager.of(context).neutral200, '200'),
                _buildNeutralSegment(ThemeManager.of(context).neutral300, '300'),
                _buildNeutralSegment(ThemeManager.of(context).neutral400, '400'),
                _buildNeutralSegment(ThemeManager.of(context).neutral500, '500'),
                _buildNeutralSegment(ThemeManager.of(context).neutral600, '600'),
                _buildNeutralSegment(ThemeManager.of(context).neutral700, '700'),
                _buildNeutralSegment(ThemeManager.of(context).neutral800, '800'),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Button state colors showcase
          Row(
            children: [
              Expanded(
                child: _buildButtonStateCard(
                  'Default',
                  ThemeManager.of(context).buttonBackground,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildButtonStateCard(
                  'Hover',
                  ThemeManager.of(context).buttonBackgroundHover,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildButtonStateCard(
                  'Pressed',
                  ThemeManager.of(context).buttonBackgroundPressed,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildButtonStateCard(
                  'Disabled',
                  ThemeManager.of(context).buttonBackgroundDisabled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Accent card helper
  Widget _buildAccentCard(
    String title,
    LinearGradient gradient,
    Color accentColor,
  ) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: ThemeManager.of(context).theme.textTheme.titleMedium?.copyWith(
                  color: ThemeManager.of(context).textInverted,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            '#${accentColor.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0')}',
            style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                  color: ThemeManager.of(context).textInverted.withValues(alpha: 0.8),
                  fontFamily: ThemeManager.fontFamilySemiExpanded,
                ),
          ),
        ],
      ),
    );
  }

  /// Neutral segment helper
  Widget _buildNeutralSegment(Color color, String label) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: label == '100'
              ? BorderRadius.only(topLeft: Radius.circular(12.r), bottomLeft: Radius.circular(12.r))
              : label == '800'
                  ? BorderRadius.only(topRight: Radius.circular(12.r), bottomRight: Radius.circular(12.r))
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                    color: ThemeManager.of(context).getContrastingColor(color),
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Button state card helper
  Widget _buildButtonStateCard(String state, Color backgroundColor) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ThemeManager.of(context).borderColor),
      ),
      child: Center(
        child: Text(
          state,
          style: ThemeManager.of(context).theme.textTheme.labelSmall?.copyWith(
                color: ThemeManager.of(context).getTextColorForBackground(backgroundColor),
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
        ),
      ),
    );
  }
}

/// Activity item model
class ActivityItem {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final DateTime timestamp;
  final Priority priority;
  final String category;

  ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    required this.priority,
    required this.category,
  });
}

/// Activity types
enum ActivityType { success, warning, error, info }

/// Priority levels
enum Priority { low, medium, high, critical }
