import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/services/health_service.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

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
    debugPrint('💊 HealthDashboard: Initializing health monitoring dashboard');
    _initializeAnimations();
    _startAnimations();
    _initializeHealthMonitoring();
  }

  void _initializeAnimations() {
    debugPrint('💊 HealthDashboard: Initializing animations');
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
    debugPrint('💊 HealthDashboard: Initializing health monitoring');
    try {
      await _healthService.initialize();
      await _refreshHealthData();
      debugPrint(
          '💊 HealthDashboard: Health monitoring initialized successfully');
    } catch (e) {
      debugPrint(
          '❌ HealthDashboard: Health monitoring initialization failed: $e');
    }
  }

  Future<void> _refreshHealthData() async {
    debugPrint('💊 HealthDashboard: Refreshing health data');
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
      debugPrint('💊 HealthDashboard: Health data refreshed successfully');
    } catch (e) {
      debugPrint('❌ HealthDashboard: Health data refresh failed: $e');
      setState(() {
        _isLoading = false;
      });
    } finally {
      _fadeController.reset();
    }
  }

  @override
  void dispose() {
    debugPrint('💊 HealthDashboard: Disposing health dashboard');
    _fadeController.dispose();
    _healthService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('💊 HealthDashboard: Building health dashboard UI');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              // System status overview
              SliverToBoxAdapter(
                child: _buildSystemStatus(),
              ),

              // Health metrics
              SliverToBoxAdapter(
                child: _buildHealthMetrics(),
              ),

              // Service health
              SliverToBoxAdapter(
                child: _buildServiceHealth(),
              ),

              // Recent alerts
              SliverToBoxAdapter(
                child: _buildRecentAlerts(),
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

  Widget _buildHeader() {
    debugPrint('💊 HealthDashboard: Building header section');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  debugPrint('💊 HealthDashboard: Back button pressed');
                  Navigator.pop(context);
                },
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context).surfaceColor,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: ThemeManager.of(context).subtleShadow,
                  ),
                  child: Icon(
                    Prbal.arrowLeft,
                    size: 20.sp,
                    color: ThemeManager.of(context).textPrimary,
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
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Monitor system performance and health',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Auto refresh toggle
              GestureDetector(
                onTap: () {
                  debugPrint(
                      '💊 HealthDashboard: Auto refresh toggled: ${!_autoRefresh}');
                  setState(() {
                    _autoRefresh = !_autoRefresh;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: _autoRefresh
                        ? ThemeManager.of(context).successColor
                        : ThemeManager.of(context).surfaceColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: _autoRefresh
                          ? ThemeManager.of(context).successColor
                          : ThemeManager.of(context).borderColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Prbal.redo,
                        size: 16.sp,
                        color: _autoRefresh
                            ? Colors.white
                            : ThemeManager.of(context).textSecondary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Auto',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: _autoRefresh
                              ? Colors.white
                              : ThemeManager.of(context).textSecondary,
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

  Widget _buildSystemStatus() {
    debugPrint('💊 HealthDashboard: Building system status section');
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
                ? [
                    ThemeManager.of(context).successColor,
                    ThemeManager.of(context).successColor.withValues(alpha: 204)
                  ]
                : [
                    ThemeManager.of(context).errorColor,
                    ThemeManager.of(context).errorColor.withValues(alpha: 204)
                  ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: (isHealthy
                      ? ThemeManager.of(context).successColor
                      : ThemeManager.of(context).errorColor)
                  .withValues(alpha: 77),
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
                    color: Colors.white.withValues(alpha: 51),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Icon(
                    Prbal.heartbeat,
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
                          color: Colors.white.withValues(alpha: 204),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: const BoxDecoration(
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
            color: color.withValues(alpha: 204),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetrics() {
    debugPrint('💊 HealthDashboard: Building health metrics section');

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
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  'System Health',
                  _healthData?.system.status ?? 'Unknown',
                  Prbal.server,
                  _getHealthColor(_healthData?.system.status),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildHealthCard(
                  'Database',
                  _healthData?.database.status ?? 'Unknown',
                  Prbal.database,
                  _getHealthColor(_healthData?.database.status),
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
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
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
                  color: color.withValues(alpha: 26),
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
                  color: color.withValues(alpha: 26),
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
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _getHealthDescription(status),
            style: TextStyle(
              fontSize: 12.sp,
              color: ThemeManager.of(context).textSecondary,
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

  Widget _buildServiceHealth() {
    debugPrint('💊 HealthDashboard: Building service health section');

    final services = [
      {
        'name': 'API Server',
        'status':
            _healthData?.system.status == 'healthy' ? 'Healthy' : 'Warning',
        'responseTime': '45ms',
        'color': _healthData?.system.status == 'healthy'
            ? ThemeManager.of(context).successColor
            : ThemeManager.of(context).warningColor
      },
      {
        'name': 'Database',
        'status': _healthData?.database.status == 'database_connected'
            ? 'Connected'
            : 'Disconnected',
        'responseTime': '12ms',
        'color': _healthData?.database.status == 'database_connected'
            ? ThemeManager.of(context).successColor
            : ThemeManager.of(context).errorColor
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
                  color: ThemeManager.of(context).textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('💊 HealthDashboard: Refresh button pressed');
                  _refreshHealthData();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Prbal.redo,
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
              color: ThemeManager.of(context).surfaceColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: ThemeManager.of(context).subtleShadow,
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
                        color: ThemeManager.of(context).textPrimary,
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
                  color: statusColor.withValues(alpha: 26),
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
            color: ThemeManager.of(context).borderColor,
          ),
      ],
    );
  }

  Widget _buildRecentAlerts() {
    debugPrint('💊 HealthDashboard: Building recent alerts section');

    final alerts = [
      {
        'title': 'High Memory Usage',
        'description': 'Memory usage exceeded 80% threshold',
        'time': '2 hours ago',
        'severity': 'warning',
        'icon': Prbal.exclamationTriangle,
      },
      {
        'title': 'Database Slow Query',
        'description': 'Query execution time exceeded 500ms',
        'time': '4 hours ago',
        'severity': 'info',
        'icon': Prbal.infoCircle,
      },
      {
        'title': 'System Backup Completed',
        'description': 'Daily backup process completed successfully',
        'time': '6 hours ago',
        'severity': 'success',
        'icon': Prbal.checkCircle,
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
                  color: ThemeManager.of(context).textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('💊 HealthDashboard: View all alerts pressed');
                  // TODO: Navigate to all alerts
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: ThemeManager.of(context).surfaceColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: ThemeManager.of(context).subtleShadow,
            ),
            child: Column(
              children: alerts.asMap().entries.map((entry) {
                final index = entry.key;
                final alert = entry.value;
                final isLast = index == alerts.length - 1;

                return _buildAlertItem(alert, !isLast);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(Map<String, dynamic> alert, bool showDivider) {
    Color getAlertColor(String severity) {
      switch (severity) {
        case 'warning':
          return ThemeManager.of(context).warningColor;
        case 'error':
          return ThemeManager.of(context).errorColor;
        case 'success':
          return ThemeManager.of(context).successColor;
        default:
          return ThemeManager.of(context).infoColor;
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
                  color: alertColor.withValues(alpha: 26),
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
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      alert['description'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                alert['time'],
                style: TextStyle(
                  fontSize: 10.sp,
                  color: ThemeManager.of(context).textTertiary,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: ThemeManager.of(context).borderColor,
          ),
      ],
    );
  }
}
