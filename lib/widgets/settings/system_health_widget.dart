import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/widget/modern_ui_components.dart';
import 'package:prbal/services/health_service.dart';

/// **THEMEMANAGER INTEGRATED** SystemHealthWidget - Modern system health display for admin users
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, health status gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and health monitoring
/// - ✨ Enhanced visual feedback with animated health indicators
/// - 🏥 Health-focused design with status color integration
/// - 🛡️ Admin-focused security monitoring with proper theming
///
/// This widget displays comprehensive system health information in a beautiful card layout:
/// - Enhanced overall system health status with theme-aware color-coded indicators
/// - Professional API, Database, and System version information display
/// - Modern gradient design with glass morphism and proper theming
/// - Responsive animations and enhanced visual feedback with theme integration
/// - Enhanced admin-only visibility with security-focused design
/// - Health status mapping using ThemeManager status colors
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

class _SystemHealthWidgetState extends State<SystemHealthWidget> with SingleTickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🏥 [SystemHealth] Initializing enhanced system health display');

    // Initialize enhanced pulse animation for health status indicator
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    // Start enhanced animation based on system health status
    if (widget.healthData.overallStatus == HealthStatus.healthy) {
      _animationController.repeat(reverse: true);
      debugPrint('✅ [SystemHealth] Healthy system - pulse animation enabled');
    } else {
      _animationController.repeat();
      debugPrint('⚠️ [SystemHealth] Unhealthy system - alert animation enabled');
    }

    debugPrint('🎬 [SystemHealth] Animation controller initialized');
    debugPrint('📊 [SystemHealth] Health status: ${widget.healthData.overallStatus}');
    debugPrint('🔧 [SystemHealth] System version: ${widget.healthData.system.version}');
  }

  @override
  void dispose() {
    debugPrint('🏥 [SystemHealth] Disposing animation controller');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏥 [SystemHealth] Building enhanced system health card');

    final themeManager = ThemeManager.of(context);
    final isHealthy = widget.healthData.overallStatus == HealthStatus.healthy;

    debugPrint('🎨 [SystemHealth] Theme mode: ${Theme.of(context).brightness}');
    debugPrint('💚 [SystemHealth] System is healthy: $isHealthy');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        // Enhanced gradient based on health status using ThemeManager colors
        gradient: _getHealthGradient(themeManager, isHealthy),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: (isHealthy ? themeManager.successColor : themeManager.warningColor).withValues(alpha: 77),
            darkColor: (isHealthy ? themeManager.successColor : themeManager.warningColor).withValues(alpha: 102),
          ),
          width: 1.5,
        ),
        boxShadow: [
          // Enhanced primary shadow with theme awareness
          BoxShadow(
            color: (isHealthy ? themeManager.successColor : themeManager.warningColor).withValues(alpha: 102),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          // Additional subtle shadow for depth
          BoxShadow(
            color: themeManager.conditionalColor(
              lightColor: Colors.black.withValues(alpha: 26),
              darkColor: Colors.black.withValues(alpha: 51),
            ),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          // Glass morphism overlay
          gradient: themeManager.conditionalGradient(
            lightGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 51),
                Colors.white.withValues(alpha: 26),
                Colors.white.withValues(alpha: 13),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            darkGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 26),
                Colors.white.withValues(alpha: 13),
                Colors.white.withValues(alpha: 8),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(28.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Header Row with Status Indicator
              _buildHealthHeader(themeManager, isHealthy),

              SizedBox(height: 24.h),

              // Enhanced Health Metrics Row
              _buildHealthMetrics(themeManager),

              // Enhanced Additional System Info
              SizedBox(height: 20.h),
              _buildSystemInfo(themeManager),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets health-based gradient using ThemeManager colors
  LinearGradient _getHealthGradient(ThemeManager themeManager, bool isHealthy) {
    if (isHealthy) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          themeManager.successColor,
          themeManager.successColor.withValues(
            red: themeManager.successColor.r * 0.9,
            green: themeManager.successColor.g * 0.95,
            blue: themeManager.successColor.b * 0.9,
          ),
          themeManager.successColor.withValues(
            red: themeManager.successColor.r * 0.8,
            green: themeManager.successColor.g * 0.9,
            blue: themeManager.successColor.b * 0.8,
          ),
        ],
        stops: const [0.0, 0.6, 1.0],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          themeManager.warningColor,
          themeManager.warningColor.withValues(
            red: themeManager.warningColor.r * 0.9,
            green: themeManager.warningColor.g * 0.95,
            blue: themeManager.warningColor.b * 0.9,
          ),
          themeManager.errorColor.withValues(
            red: themeManager.errorColor.r * 0.9,
            green: themeManager.errorColor.g * 0.8,
            blue: themeManager.errorColor.b * 0.8,
          ),
        ],
        stops: const [0.0, 0.6, 1.0],
      );
    }
  }

  /// Builds the enhanced health header with animated status indicator
  Widget _buildHealthHeader(ThemeManager themeManager, bool isHealthy) {
    debugPrint('🏥 [SystemHealth] Building enhanced health header');

    return Row(
      children: [
        // Enhanced Animated Status Icon
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: isHealthy ? _pulseAnimation.value : 1.0,
              child: Transform.rotate(
                angle: isHealthy ? 0 : _rotateAnimation.value * 2 * 3.14159,
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 102),
                          Colors.white.withValues(alpha: 77),
                          Colors.white.withValues(alpha: 51),
                        ],
                      ),
                      darkGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 77),
                          Colors.white.withValues(alpha: 51),
                          Colors.white.withValues(alpha: 26),
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 102),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 77),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isHealthy ? Prbal.checkCircle : Prbal.exclamationTriangle,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(width: 20.w),

        // Enhanced Title and Status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Health Monitor',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.3,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 77),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: themeManager.conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 51),
                        Colors.white.withValues(alpha: 26),
                      ],
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 26),
                        Colors.white.withValues(alpha: 13),
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isHealthy ? 'All systems operational' : 'Issues detected - Admin action required',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 230),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // Enhanced Status Badge with pulse effect
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: themeManager.conditionalGradient(
                  lightGradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 77),
                      Colors.white.withValues(alpha: 51),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  darkGradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 51),
                      Colors.white.withValues(alpha: 26),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 102),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: isHealthy ? (_pulseAnimation.value * 77).toDouble() : 51.0),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 128),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isHealthy ? 'Healthy' : 'Warning',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Builds the enhanced health metrics row with system information
  Widget _buildHealthMetrics(ThemeManager themeManager) {
    debugPrint('🏥 [SystemHealth] Building enhanced health metrics');

    return Row(
      children: [
        Expanded(
          child: _buildHealthMetric(
            themeManager,
            'API Service',
            widget.healthData.system.status,
            Prbal.server,
            _getMetricStatusColor(widget.healthData.system.status, themeManager),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: _buildHealthMetric(
            themeManager,
            'Database',
            widget.healthData.database.status,
            Prbal.database,
            _getMetricStatusColor(widget.healthData.database.status, themeManager),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: _buildHealthMetric(
            themeManager,
            'Version',
            widget.healthData.system.version,
            Prbal.tag,
            Colors.white,
          ),
        ),
      ],
    );
  }

  /// Gets metric status color based on status value
  Color _getMetricStatusColor(String status, ThemeManager themeManager) {
    switch (status.toLowerCase()) {
      case 'healthy':
      case 'operational':
      case 'online':
        return Colors.white;
      case 'warning':
      case 'degraded':
        return Colors.yellow[100] ?? Colors.white;
      case 'error':
      case 'offline':
      case 'down':
        return Colors.red[100] ?? Colors.white;
      default:
        return Colors.white;
    }
  }

  /// Builds enhanced individual health metric item
  Widget _buildHealthMetric(ThemeManager themeManager, String label, String value, IconData icon, Color valueColor) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 51),
              Colors.white.withValues(alpha: 26),
              Colors.white.withValues(alpha: 13),
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 26),
              Colors.white.withValues(alpha: 13),
              Colors.white.withValues(alpha: 8),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  gradient: themeManager.conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 77),
                        Colors.white.withValues(alpha: 51),
                      ],
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 51),
                        Colors.white.withValues(alpha: 26),
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 204),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 26),
                    Colors.white.withValues(alpha: 13),
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 13),
                    Colors.white.withValues(alpha: 8),
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: valueColor,
                letterSpacing: 0.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 51),
                    offset: const Offset(0, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds enhanced additional system information
  Widget _buildSystemInfo(ThemeManager themeManager) {
    debugPrint('🏥 [SystemHealth] Building enhanced system info');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 51),
              Colors.white.withValues(alpha: 26),
              Colors.white.withValues(alpha: 13),
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 26),
              Colors.white.withValues(alpha: 13),
              Colors.white.withValues(alpha: 8),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 77),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 77),
                    Colors.white.withValues(alpha: 51),
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 51),
                    Colors.white.withValues(alpha: 26),
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Prbal.clock,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Information',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 230),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 26),
                          Colors.white.withValues(alpha: 13),
                        ],
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 13),
                          Colors.white.withValues(alpha: 8),
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Version: ${widget.healthData.system.version} • Updated: ${_formatTimestamp(widget.healthData.lastUpdate)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 179),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
