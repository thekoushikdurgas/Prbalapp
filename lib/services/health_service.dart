import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prbal/services/api_service.dart';

/// Health status enumeration
enum HealthStatus {
  healthy,
  degraded,
  unhealthy,
  unknown,
}

/// System health metrics model
class SystemHealthMetrics {
  final HealthStatus status;
  final DateTime timestamp;
  final int uptime;
  final double memoryUsage;
  final double cpuUsage;
  final Map<String, dynamic> additionalMetrics;

  SystemHealthMetrics({
    required this.status,
    required this.timestamp,
    required this.uptime,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.additionalMetrics,
  });

  factory SystemHealthMetrics.fromJson(Map<String, dynamic> json) {
    return SystemHealthMetrics(
      status: _parseHealthStatus(json['status']),
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      uptime: json['uptime'] ?? 0,
      memoryUsage: (json['memory_usage'] ?? 0.0).toDouble(),
      cpuUsage: (json['cpu_usage'] ?? 0.0).toDouble(),
      additionalMetrics: json['additional_metrics'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'uptime': uptime,
      'memory_usage': memoryUsage,
      'cpu_usage': cpuUsage,
      'additional_metrics': additionalMetrics,
    };
  }

  static HealthStatus _parseHealthStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'healthy':
        return HealthStatus.healthy;
      case 'degraded':
        return HealthStatus.degraded;
      case 'unhealthy':
        return HealthStatus.unhealthy;
      default:
        return HealthStatus.unknown;
    }
  }
}

/// Database health metrics model
class DatabaseHealthMetrics {
  final HealthStatus status;
  final DateTime timestamp;
  final int connectionPoolSize;
  final int activeConnections;
  final double averageQueryTime;
  final int failedQueries;
  final Map<String, dynamic> additionalInfo;

  DatabaseHealthMetrics({
    required this.status,
    required this.timestamp,
    required this.connectionPoolSize,
    required this.activeConnections,
    required this.averageQueryTime,
    required this.failedQueries,
    required this.additionalInfo,
  });

  factory DatabaseHealthMetrics.fromJson(Map<String, dynamic> json) {
    return DatabaseHealthMetrics(
      status: SystemHealthMetrics._parseHealthStatus(json['database_status']),
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      connectionPoolSize: json['connection_pool_size'] ?? 0,
      activeConnections: json['active_connections'] ?? 0,
      averageQueryTime: (json['average_query_time'] ?? 0.0).toDouble(),
      failedQueries: json['failed_queries'] ?? 0,
      additionalInfo: json['additional_info'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'database_status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'connection_pool_size': connectionPoolSize,
      'active_connections': activeConnections,
      'average_query_time': averageQueryTime,
      'failed_queries': failedQueries,
      'additional_info': additionalInfo,
    };
  }
}

/// Service dependency health model
class ServiceDependencyHealth {
  final String serviceName;
  final HealthStatus status;
  final DateTime lastChecked;
  final int responseTime;
  final String? errorMessage;
  final Map<String, dynamic> metadata;

  ServiceDependencyHealth({
    required this.serviceName,
    required this.status,
    required this.lastChecked,
    required this.responseTime,
    this.errorMessage,
    required this.metadata,
  });

  factory ServiceDependencyHealth.fromJson(Map<String, dynamic> json) {
    return ServiceDependencyHealth(
      serviceName: json['service_name'] ?? 'Unknown',
      status: SystemHealthMetrics._parseHealthStatus(json['status']),
      lastChecked: DateTime.parse(
          json['last_checked'] ?? DateTime.now().toIso8601String()),
      responseTime: json['response_time'] ?? 0,
      errorMessage: json['error_message'],
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'status': status.name,
      'last_checked': lastChecked.toIso8601String(),
      'response_time': responseTime,
      'error_message': errorMessage,
      'metadata': metadata,
    };
  }
}

/// Dependencies health metrics model
class DependenciesHealthMetrics {
  final HealthStatus overallStatus;
  final DateTime timestamp;
  final List<ServiceDependencyHealth> dependencies;
  final Map<String, dynamic> summary;

  DependenciesHealthMetrics({
    required this.overallStatus,
    required this.timestamp,
    required this.dependencies,
    required this.summary,
  });

  factory DependenciesHealthMetrics.fromJson(Map<String, dynamic> json) {
    return DependenciesHealthMetrics(
      overallStatus:
          SystemHealthMetrics._parseHealthStatus(json['overall_status']),
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      dependencies: (json['dependencies'] as List<dynamic>?)
              ?.map((dep) => ServiceDependencyHealth.fromJson(dep))
              .toList() ??
          [],
      summary: json['summary'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall_status': overallStatus.name,
      'timestamp': timestamp.toIso8601String(),
      'dependencies': dependencies.map((dep) => dep.toJson()).toList(),
      'summary': summary,
    };
  }
}

/// Prometheus metrics model
class PrometheusMetrics {
  final String rawMetrics;
  final DateTime timestamp;
  final Map<String, double> parsedMetrics;

  PrometheusMetrics({
    required this.rawMetrics,
    required this.timestamp,
    required this.parsedMetrics,
  });

  factory PrometheusMetrics.fromRawData(String rawData) {
    final parsedMetrics = <String, double>{};

    // Parse basic metrics from Prometheus format
    final lines = rawData.split('\n');
    for (final line in lines) {
      if (line.startsWith('#') || line.trim().isEmpty) continue;

      final parts = line.split(' ');
      if (parts.length >= 2) {
        final metricName = parts[0];
        final value = double.tryParse(parts[1]);
        if (value != null) {
          parsedMetrics[metricName] = value;
        }
      }
    }

    return PrometheusMetrics(
      rawMetrics: rawData,
      timestamp: DateTime.now(),
      parsedMetrics: parsedMetrics,
    );
  }
}

/// Overall application health model
class ApplicationHealth {
  final SystemHealthMetrics system;
  final DatabaseHealthMetrics database;
  final DependenciesHealthMetrics dependencies;
  final HealthStatus overallStatus;
  final DateTime lastUpdate;

  ApplicationHealth({
    required this.system,
    required this.database,
    required this.dependencies,
    required this.overallStatus,
    required this.lastUpdate,
  });

  factory ApplicationHealth.fromComponents({
    required SystemHealthMetrics system,
    required DatabaseHealthMetrics database,
    required DependenciesHealthMetrics dependencies,
  }) {
    // Determine overall status based on all components
    HealthStatus overallStatus = HealthStatus.healthy;

    final statuses = [
      system.status,
      database.status,
      dependencies.overallStatus
    ];

    if (statuses.contains(HealthStatus.unhealthy)) {
      overallStatus = HealthStatus.unhealthy;
    } else if (statuses.contains(HealthStatus.degraded)) {
      overallStatus = HealthStatus.degraded;
    } else if (statuses.contains(HealthStatus.unknown)) {
      overallStatus = HealthStatus.unknown;
    }

    return ApplicationHealth(
      system: system,
      database: database,
      dependencies: dependencies,
      overallStatus: overallStatus,
      lastUpdate: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'system': system.toJson(),
      'database': database.toJson(),
      'dependencies': dependencies.toJson(),
      'overall_status': overallStatus.name,
      'last_update': lastUpdate.toIso8601String(),
    };
  }
}

/// Health monitoring service
class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final ApiService _apiService = ApiService();

  Timer? _healthCheckTimer;
  Timer? _metricsTimer;

  // Cached health data
  ApplicationHealth? _lastHealthCheck;
  PrometheusMetrics? _lastMetrics;

  // Health monitoring configuration
  Duration healthCheckInterval = const Duration(minutes: 5);
  Duration metricsInterval = const Duration(minutes: 1);

  // Stream controllers for real-time updates
  final StreamController<ApplicationHealth> _healthStream =
      StreamController<ApplicationHealth>.broadcast();
  final StreamController<PrometheusMetrics> _metricsStream =
      StreamController<PrometheusMetrics>.broadcast();

  /// Initialize health monitoring
  Future<void> initialize() async {
    debugPrint('🏥 Health Service: Initializing health monitoring');

    // Perform initial health check
    await performHealthCheck();

    // Start periodic monitoring
    startPeriodicMonitoring();

    debugPrint('🏥 Health Service: Health monitoring initialized');
  }

  /// Start periodic health monitoring
  void startPeriodicMonitoring() {
    // Health check timer
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(healthCheckInterval, (timer) {
      performHealthCheck();
    });

    // Metrics collection timer
    _metricsTimer?.cancel();
    _metricsTimer = Timer.periodic(metricsInterval, (timer) {
      collectMetrics();
    });

    debugPrint('🏥 Health Service: Periodic monitoring started');
  }

  /// Stop periodic monitoring
  void stopPeriodicMonitoring() {
    _healthCheckTimer?.cancel();
    _metricsTimer?.cancel();
    debugPrint('🏥 Health Service: Periodic monitoring stopped');
  }

  /// Perform comprehensive health check
  Future<ApplicationHealth?> performHealthCheck() async {
    try {
      debugPrint('🏥 Health Service: Performing health check');

      // Execute all health checks in parallel
      final results = await Future.wait([
        getSystemHealth(),
        getDatabaseHealth(),
        getDependenciesHealth(),
      ]);

      final systemHealth = results[0] as SystemHealthMetrics?;
      final databaseHealth = results[1] as DatabaseHealthMetrics?;
      final dependenciesHealth = results[2] as DependenciesHealthMetrics?;

      if (systemHealth != null &&
          databaseHealth != null &&
          dependenciesHealth != null) {
        final appHealth = ApplicationHealth.fromComponents(
          system: systemHealth,
          database: databaseHealth,
          dependencies: dependenciesHealth,
        );

        _lastHealthCheck = appHealth;
        _healthStream.add(appHealth);

        debugPrint(
            '🏥 Health Service: Health check completed - Status: ${appHealth.overallStatus.name}');
        return appHealth;
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Health check failed - $e');
    }

    return null;
  }

  /// Get system health metrics
  Future<SystemHealthMetrics?> getSystemHealth() async {
    try {
      final response = await _apiService.get<SystemHealthMetrics>(
        '/health/system/',
        fromJson: (json) => SystemHealthMetrics.fromJson(json),
      );

      if (response.success && response.data != null) {
        return response.data;
      } else {
        debugPrint(
            '🏥 Health Service: System health check failed - ${response.message}');
      }
    } catch (e) {
      debugPrint('🏥 Health Service: System health check error - $e');
    }

    return null;
  }

  /// Get database health metrics
  Future<DatabaseHealthMetrics?> getDatabaseHealth() async {
    try {
      final response = await _apiService.get<DatabaseHealthMetrics>(
        '/health/database/',
        fromJson: (json) => DatabaseHealthMetrics.fromJson(json),
      );

      if (response.success && response.data != null) {
        return response.data;
      } else {
        debugPrint(
            '🏥 Health Service: Database health check failed - ${response.message}');
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Database health check error - $e');
    }

    return null;
  }

  /// Get service dependencies health metrics
  Future<DependenciesHealthMetrics?> getDependenciesHealth() async {
    try {
      final response = await _apiService.get<DependenciesHealthMetrics>(
        '/health/dependencies/',
        fromJson: (json) => DependenciesHealthMetrics.fromJson(json),
      );

      if (response.success && response.data != null) {
        return response.data;
      } else {
        debugPrint(
            '🏥 Health Service: Dependencies health check failed - ${response.message}');
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Dependencies health check error - $e');
    }

    return null;
  }

  /// Collect Prometheus metrics
  Future<PrometheusMetrics?> collectMetrics() async {
    try {
      // Note: Prometheus endpoint is at /metrics/ not /api/v1/metrics/
      final response = await _apiService.get<String>(
        '/../metrics/', // Go up one level from /api/v1 to reach /metrics/
        headers: {'Accept': 'text/plain'},
        fromJson: (json) => json['metrics'] as String? ?? '',
      );

      if (response.success) {
        final metricsData = response.data ?? '';
        final metrics = PrometheusMetrics.fromRawData(metricsData);

        _lastMetrics = metrics;
        _metricsStream.add(metrics);

        debugPrint(
            '🏥 Health Service: Metrics collected - ${metrics.parsedMetrics.length} metrics');
        return metrics;
      } else {
        debugPrint(
            '🏥 Health Service: Metrics collection failed - ${response.message}');
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Metrics collection error - $e');
    }

    return null;
  }

  /// Get current application health status
  ApplicationHealth? get currentHealth => _lastHealthCheck;

  /// Get current metrics
  PrometheusMetrics? get currentMetrics => _lastMetrics;

  /// Stream of health updates
  Stream<ApplicationHealth> get healthStream => _healthStream.stream;

  /// Stream of metrics updates
  Stream<PrometheusMetrics> get metricsStream => _metricsStream.stream;

  /// Check if the application is healthy
  bool get isHealthy => _lastHealthCheck?.overallStatus == HealthStatus.healthy;

  /// Check if the application is experiencing issues
  bool get hasIssues =>
      _lastHealthCheck?.overallStatus == HealthStatus.degraded ||
      _lastHealthCheck?.overallStatus == HealthStatus.unhealthy;

  /// Get health status color for UI
  Color getHealthStatusColor() {
    switch (_lastHealthCheck?.overallStatus) {
      case HealthStatus.healthy:
        return const Color(0xFF4CAF50); // Green
      case HealthStatus.degraded:
        return const Color(0xFFFF9800); // Orange
      case HealthStatus.unhealthy:
        return const Color(0xFFF44336); // Red
      case HealthStatus.unknown:
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  /// Get health status icon for UI
  IconData getHealthStatusIcon() {
    switch (_lastHealthCheck?.overallStatus) {
      case HealthStatus.healthy:
        return Icons.check_circle;
      case HealthStatus.degraded:
        return Icons.warning;
      case HealthStatus.unhealthy:
        return Icons.error;
      case HealthStatus.unknown:
      default:
        return Icons.help;
    }
  }

  /// Get health summary for display
  String getHealthSummary() {
    if (_lastHealthCheck == null) return 'Health status unknown';

    final health = _lastHealthCheck!;
    final statusName = health.overallStatus.name.toUpperCase();
    final lastUpdate = health.lastUpdate.toLocal();

    return 'System: $statusName (Updated: ${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')})';
  }

  /// Configure monitoring intervals
  void configureMonitoring({
    Duration? healthCheckInterval,
    Duration? metricsInterval,
  }) {
    if (healthCheckInterval != null) {
      this.healthCheckInterval = healthCheckInterval;
    }
    if (metricsInterval != null) {
      this.metricsInterval = metricsInterval;
    }

    // Restart monitoring with new intervals
    if (_healthCheckTimer?.isActive == true ||
        _metricsTimer?.isActive == true) {
      stopPeriodicMonitoring();
      startPeriodicMonitoring();
    }
  }

  /// Dispose the service
  void dispose() {
    stopPeriodicMonitoring();
    _healthStream.close();
    _metricsStream.close();
    debugPrint('🏥 Health Service: Disposed');
  }
}
