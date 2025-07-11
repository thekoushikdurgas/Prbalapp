import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:prbal/widget/modern_ui_components.dart';
import 'package:prbal/services/health_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

/// SystemHealthWidget - Modern system health display for admin users
///
/// This widget displays comprehensive system health information in a beautiful card layout:
/// - Overall system health status with color-coded indicators
/// - API, Database, and System version information
/// - Modern gradient design with proper theming
/// - Responsive animations and visual feedback
/// - Only visible to admin users for security
class SystemHealthWidget extends StatefulWidget {
  const SystemHealthWidget({
    super.key,
    required this.healthData,
  });

  /// Application health data from HealthService
  final ApplicationHealth healthData;

  @override
  State<SystemHealthWidget> createState() => _SystemHealthWidgetState();
}

class _SystemHealthWidgetState extends State<SystemHealthWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🏥 SystemHealthWidget: Initializing system health display');

    // Initialize pulse animation for health status indicator
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation if system is healthy
    if (widget.healthData.overallStatus == HealthStatus.healthy) {
      _animationController.repeat(reverse: true);
    }

    debugPrint('🏥 SystemHealthWidget: Animation controller initialized');
    debugPrint(
        '🏥 SystemHealthWidget: Health status: ${widget.healthData.overallStatus}');
  }

  @override
  void dispose() {
    debugPrint('🏥 SystemHealthWidget: Disposing animation controller');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏥 SystemHealthWidget: Building system health card');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHealthy = widget.healthData.overallStatus == HealthStatus.healthy;

    debugPrint('🏥 SystemHealthWidget: Theme is dark: $isDark');
    debugPrint('🏥 SystemHealthWidget: System is healthy: $isHealthy');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isHealthy
              ? [
                  const Color(0xFF48BB78),
                  const Color(0xFF38A169),
                ]
              : [
                  const Color(0xFFED8936),
                  const Color(0xFFDD6B20),
                ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                (isHealthy ? const Color(0xFF48BB78) : const Color(0xFFED8936))
                    .withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Status Indicator
            _buildHealthHeader(isHealthy),

            SizedBox(height: 20.h),

            // Health Metrics Row
            _buildHealthMetrics(),

            // Additional System Info
            SizedBox(height: 16.h),
            _buildSystemInfo(),
          ],
        ),
      ),
    );
  }

  /// Builds the health header with animated status indicator
  Widget _buildHealthHeader(bool isHealthy) {
    debugPrint('🏥 SystemHealthWidget: Building health header');

    return Row(
      children: [
        // Animated Status Icon
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isHealthy ? _pulseAnimation.value : 1.0,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  isHealthy ? Prbal.checkCircle : Prbal.exclamationTriangle,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            );
          },
        ),

        SizedBox(width: 16.w),

        // Title and Status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Health',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                isHealthy ? 'All systems operational' : 'Issues detected',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Status Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            isHealthy ? 'Healthy' : 'Warning',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the health metrics row with system information
  Widget _buildHealthMetrics() {
    debugPrint('🏥 SystemHealthWidget: Building health metrics');

    return Row(
      children: [
        Expanded(
          child: _buildHealthMetric(
            'API',
            widget.healthData.system.status,
            Prbal.server,
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: _buildHealthMetric(
            'Database',
            widget.healthData.database.status,
            Prbal.database,
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: _buildHealthMetric(
            'Version',
            widget.healthData.system.version,
            Prbal.tag,
          ),
        ),
      ],
    );
  }

  /// Builds individual health metric item
  Widget _buildHealthMetric(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.8),
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Builds additional system information
  Widget _buildSystemInfo() {
    debugPrint('🏥 SystemHealthWidget: Building system info');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Prbal.clock,
            color: Colors.white.withValues(alpha: 0.8),
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Flexible(
            flex: 2,
            child: Text(
              'System Version: ${widget.healthData.system.version}',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            flex: 1,
            child: Text(
              'Updated: ${_formatTimestamp(widget.healthData.lastUpdate)}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
