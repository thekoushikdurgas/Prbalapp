import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/health_service.dart';

/// Health Dashboard Widget
class HealthDashboard extends ConsumerStatefulWidget {
  const HealthDashboard({super.key});

  @override
  ConsumerState<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends ConsumerState<HealthDashboard>
    with TickerProviderStateMixin {
  final HealthService _healthService = HealthService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _autoRefresh = true;

  ApplicationHealth? _healthData;
  bool _isLoading = true;
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _initializeHealthMonitoring();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
  }

  Future<void> _initializeHealthMonitoring() async {
    try {
      await _healthService.initialize();
      await _refreshHealthData();
    } catch (e) {
      debugPrint('Health monitoring initialization failed: $e');
    }
  }

  Future<void> _refreshHealthData() async {
    setState(() {
      _isLoading = true;
    });

    _fadeController.forward();

    try {
      final healthCheck = await _healthService.performHealthCheck();

      setState(() {
        _healthData = healthCheck;
        _lastUpdate = DateTime.now();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Health data refresh failed: $e');
      setState(() {
        _isLoading = false;
      });
    } finally {
      _fadeController.reset();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _healthService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(isDark),
              ),

              // System status overview
              SliverToBoxAdapter(
                child: _buildSystemStatus(isDark),
              ),

              // Health metrics
              SliverToBoxAdapter(
                child: _buildHealthMetrics(isDark),
              ),

              // Service health
              SliverToBoxAdapter(
                child: _buildServiceHealth(isDark),
              ),

              // Recent alerts
              SliverToBoxAdapter(
                child: _buildRecentAlerts(isDark),
              ),

              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: 40.h),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    LineIcons.arrowLeft,
                    size: 20.sp,
                    color: isDark ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Health',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Monitor system performance and health',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color:
                            isDark ? Colors.grey[400] : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // Auto refresh toggle
              GestureDetector(
                onTap: () {
                  setState(() {
                    _autoRefresh = !_autoRefresh;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: _autoRefresh
                        ? const Color(0xFF10B981)
                        : (isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LineIcons.redo,
                        size: 16.sp,
                        color: _autoRefresh
                            ? Colors.white
                            : (isDark
                                ? Colors.grey[400]
                                : const Color(0xFF6B7280)),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Auto',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: _autoRefresh
                              ? Colors.white
                              : (isDark
                                  ? Colors.grey[400]
                                  : const Color(0xFF6B7280)),
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

  Widget _buildSystemStatus(bool isDark) {
    final isHealthy = _healthData?.overallStatus == HealthStatus.healthy;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isHealthy
                ? [const Color(0xFF10B981), const Color(0xFF059669)]
                : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: (isHealthy
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444))
                  .withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Icon(
                    LineIcons.heartbeat,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLoading
                            ? 'Loading...'
                            : (isHealthy
                                ? 'All Systems Operational'
                                : 'System Issues Detected'),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Last updated: ${_lastUpdate?.toString().substring(0, 16) ?? 'Never'}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                _buildStatusMetric(
                    isHealthy ? '99.9%' : '95.2%', 'Uptime', Colors.white),
                SizedBox(width: 24.w),
                _buildStatusMetric('< 50ms', 'Response Time', Colors.white),
                SizedBox(width: 24.w),
                _buildStatusMetric(_healthData?.system.version ?? '1.0.0',
                    'Version', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMetric(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetrics(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Overview',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  'System Health',
                  _healthData?.system.status ?? 'Unknown',
                  LineIcons.server,
                  _getHealthColor(_healthData?.system.status),
                  isDark,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildHealthCard(
                  'Database',
                  _healthData?.database.status ?? 'Unknown',
                  LineIcons.database,
                  _getHealthColor(_healthData?.database.status),
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'healthy':
      case 'database_connected':
        return const Color(0xFF10B981);
      case 'unhealthy':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  Widget _buildHealthCard(
    String title,
    String status,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  icon,
                  size: 18.sp,
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _getHealthDescription(status),
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  String _getHealthDescription(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return 'Operating normally';
      case 'database_connected':
        return 'Connection established';
      case 'unhealthy':
        return 'Issues detected';
      default:
        return 'Status unknown';
    }
  }

  Widget _buildServiceHealth(bool isDark) {
    final services = [
      {
        'name': 'API Server',
        'status':
            _healthData?.system.status == 'healthy' ? 'Healthy' : 'Warning',
        'responseTime': '45ms',
        'color': _healthData?.system.status == 'healthy'
            ? const Color(0xFF10B981)
            : const Color(0xFFF59E0B)
      },
      {
        'name': 'Database',
        'status': _healthData?.database.status == 'database_connected'
            ? 'Connected'
            : 'Disconnected',
        'responseTime': '12ms',
        'color': _healthData?.database.status == 'database_connected'
            ? const Color(0xFF10B981)
            : const Color(0xFFEF4444)
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Health',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              GestureDetector(
                onTap: _refreshHealthData,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LineIcons.redo,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Refresh',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: services.asMap().entries.map((entry) {
                final index = entry.key;
                final service = entry.value;
                final isLast = index == services.length - 1;

                return _buildServiceItem(
                  service['name'] as String,
                  service['status'] as String,
                  service['responseTime'] as String,
                  service['color'] as Color,
                  isDark,
                  !isLast,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    String name,
    String status,
    String responseTime,
    Color statusColor,
    bool isDark,
    bool showDivider,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  responseTime,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
      ],
    );
  }

  Widget _buildRecentAlerts(bool isDark) {
    final alerts = [
      {
        'title': 'High Memory Usage',
        'description': 'Memory usage exceeded 80% threshold',
        'time': '2 hours ago',
        'severity': 'warning',
        'icon': LineIcons.exclamationTriangle,
      },
      {
        'title': 'Database Slow Query',
        'description': 'Query execution time exceeded 500ms',
        'time': '4 hours ago',
        'severity': 'info',
        'icon': LineIcons.infoCircle,
      },
      {
        'title': 'System Backup Completed',
        'description': 'Daily backup process completed successfully',
        'time': '6 hours ago',
        'severity': 'success',
        'icon': LineIcons.checkCircle,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Alerts',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to all alerts
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: alerts.asMap().entries.map((entry) {
                final index = entry.key;
                final alert = entry.value;
                final isLast = index == alerts.length - 1;

                return _buildAlertItem(alert, isDark, !isLast);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
      Map<String, dynamic> alert, bool isDark, bool showDivider) {
    Color getAlertColor(String severity) {
      switch (severity) {
        case 'warning':
          return const Color(0xFFF59E0B);
        case 'error':
          return const Color(0xFFEF4444);
        case 'success':
          return const Color(0xFF10B981);
        default:
          return const Color(0xFF3B82F6);
      }
    }

    final alertColor = getAlertColor(alert['severity']);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: alertColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  alert['icon'],
                  size: 20.sp,
                  color: alertColor,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert['title'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      alert['description'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color:
                            isDark ? Colors.grey[400] : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                alert['time'],
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isDark ? Colors.grey[500] : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
      ],
    );
  }
}
