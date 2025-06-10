import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/services/health_service.dart';
import 'package:prbal/init/navigation/navigation_route.dart';
import 'package:prbal/product/enum/route_enum.dart';

/// Health Status Widget - Shows current system health
class HealthStatusWidget extends StatefulWidget {
  final bool showDetails;
  final bool isCompact;

  const HealthStatusWidget({
    super.key,
    this.showDetails = true,
    this.isCompact = false,
  });

  @override
  State<HealthStatusWidget> createState() => _HealthStatusWidgetState();
}

class _HealthStatusWidgetState extends State<HealthStatusWidget> {
  final HealthService _healthService = HealthService();
  Map<String, dynamic>? _healthData;
  bool _isLoading = true;
  String _healthStatus = 'unknown';

  @override
  void initState() {
    super.initState();
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    try {
      await _healthService.initialize();

      // Get individual health components
      final systemHealth = await _healthService.getSystemHealth();
      final databaseHealth = await _healthService.getDatabaseHealth();
      final dependenciesHealth = await _healthService.getDependenciesHealth();

      final healthCheck = {
        'system': systemHealth,
        'database': databaseHealth,
        'dependencies': dependenciesHealth,
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (mounted) {
        setState(() {
          _healthData = healthCheck;
          _healthStatus = _determineOverallStatus(healthCheck);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _healthStatus = 'error';
        });
      }
    }
  }

  String _determineOverallStatus(Map<String, dynamic>? healthData) {
    if (healthData == null) return 'unknown';

    final systemStatus = healthData['system']?['status'];
    final databaseStatus = healthData['database']?['database_status'];
    final dependenciesStatus = healthData['dependencies']?['overall_status'];

    final statuses = [systemStatus, databaseStatus, dependenciesStatus];

    if (statuses.contains('unhealthy')) return 'unhealthy';
    if (statuses.contains('degraded')) return 'degraded';
    if (statuses.contains('healthy')) return 'healthy';
    return 'unknown';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Colors.green;
      case 'degraded':
        return Colors.orange;
      case 'unhealthy':
        return Colors.red;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Icons.check_circle;
      case 'degraded':
        return Icons.warning;
      case 'unhealthy':
        return Icons.error;
      case 'error':
        return Icons.error_outline;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return 'All systems operational';
      case 'degraded':
        return 'Some issues detected';
      case 'unhealthy':
        return 'System issues detected';
      case 'error':
        return 'Unable to check status';
      default:
        return 'Status unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(_healthStatus);

    if (widget.isCompact) {
      return _buildCompactWidget(theme, colorScheme, statusColor);
    }

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      child: InkWell(
        onTap: () => NavigationRoute.goRouteNormal(RouteEnum.health.rawValue),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                statusColor.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      _getStatusIcon(_healthStatus),
                      color: statusColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Health',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _getStatusText(_healthStatus),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isLoading)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 16.sp,
                    ),
                ],
              ),
              if (widget.showDetails && _healthData != null) ...[
                SizedBox(height: 16.h),
                _buildHealthMetrics(theme, colorScheme),
              ],
              if (_isLoading) ...[
                SizedBox(height: 16.h),
                Center(
                  child: SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactWidget(
      ThemeData theme, ColorScheme colorScheme, Color statusColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(_healthStatus),
            color: statusColor,
            size: 16.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            _healthStatus.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildMetricRow(
            'System',
            _healthData!['system']?['status']?.toString() ?? 'Unknown',
            _getStatusColor(_healthData!['system']?['status'] ?? 'unknown'),
            theme,
          ),
          SizedBox(height: 8.h),
          _buildMetricRow(
            'Database',
            _healthData!['database']?['database_status']?.toString() ??
                'Unknown',
            _getStatusColor(
                _healthData!['database']?['database_status'] ?? 'unknown'),
            theme,
          ),
          SizedBox(height: 8.h),
          _buildMetricRow(
            'Services',
            _healthData!['dependencies']?['overall_status']?.toString() ??
                'Unknown',
            _getStatusColor(
                _healthData!['dependencies']?['overall_status'] ?? 'unknown'),
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
      String label, String value, Color valueColor, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: valueColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            value.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _healthService.dispose();
    super.dispose();
  }
}
