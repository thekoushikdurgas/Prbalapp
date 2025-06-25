import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

/// Health status enumeration
enum HealthStatus {
  healthy,
  unhealthy,
  unknown,
}

/// Simple system health model
class SystemHealth {
  final String status;
  final String version;
  final DateTime timestamp;

  SystemHealth({
    required this.status,
    required this.version,
    required this.timestamp,
  });

  factory SystemHealth.fromJson(Map<String, dynamic> json) {
    return SystemHealth(
      status: json['status'] ?? 'unknown',
      version: json['version'] ?? '1.0.0',
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'version': version,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  HealthStatus get healthStatus {
    switch (status.toLowerCase()) {
      case 'healthy':
        return HealthStatus.healthy;
      default:
        return HealthStatus.unhealthy;
    }
  }
}

/// Simple database health model
class DatabaseHealth {
  final String status;
  final DateTime timestamp;

  DatabaseHealth({
    required this.status,
    required this.timestamp,
  });

  factory DatabaseHealth.fromJson(Map<String, dynamic> json) {
    return DatabaseHealth(
      status: json['status'] ?? 'unknown',
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  HealthStatus get healthStatus {
    switch (status.toLowerCase()) {
      case 'database_connected':
        return HealthStatus.healthy;
      default:
        return HealthStatus.unhealthy;
    }
  }
}

/// Overall application health model
class ApplicationHealth {
  final SystemHealth system;
  final DatabaseHealth database;
  final HealthStatus overallStatus;
  final DateTime lastUpdate;

  ApplicationHealth({
    required this.system,
    required this.database,
    required this.overallStatus,
    required this.lastUpdate,
  });

  factory ApplicationHealth.fromComponents({
    required SystemHealth system,
    required DatabaseHealth database,
  }) {
    // Determine overall status based on both components
    HealthStatus overallStatus = HealthStatus.healthy;

    if (system.healthStatus == HealthStatus.unhealthy ||
        database.healthStatus == HealthStatus.unhealthy) {
      overallStatus = HealthStatus.unhealthy;
    } else if (system.healthStatus == HealthStatus.unknown ||
        database.healthStatus == HealthStatus.unknown) {
      overallStatus = HealthStatus.unknown;
    }

    return ApplicationHealth(
      system: system,
      database: database,
      overallStatus: overallStatus,
      lastUpdate: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'system': system.toJson(),
      'database': database.toJson(),
      'overall_status': overallStatus.name,
      'last_update': lastUpdate.toIso8601String(),
    };
  }
}

/// Simplified health monitoring service
class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final ApiService _apiService = ApiService();

  Timer? _healthCheckTimer;

  // Cached health data
  ApplicationHealth? _lastHealthCheck;

  // Health monitoring configuration
  Duration healthCheckInterval = const Duration(minutes: 5);

  // Stream controller for real-time updates
  final StreamController<ApplicationHealth> _healthStream =
      StreamController<ApplicationHealth>.broadcast();

  /// Initialize health monitoring
  Future<void> initialize() async {
    try {
      debugPrint('🏥 Health Service: Initializing health monitoring');

      // Check if we have recent cached health data
      if (_shouldUseCachedHealthData()) {
        debugPrint(
            '🏥 Health Service: Using cached health data (recent check found)');
        _loadCachedHealthData();
      } else {
        // Perform initial health check
        await performHealthCheck();
      }

      // Start periodic monitoring
      startPeriodicMonitoring();

      debugPrint('🏥 Health Service: Health monitoring initialized');
    } catch (e) {
      debugPrint('🏥 Health Service: Initialization failed - $e');
      // Continue anyway, monitoring will be retried on the next cycle
    }
  }

  /// Check if we should use cached health data instead of making new API calls
  bool _shouldUseCachedHealthData() {
    return !HiveService.isHealthCheckNeeded(
        interval: const Duration(minutes: 30));
  }

  /// Load cached health data from local storage
  void _loadCachedHealthData() {
    try {
      final cachedResult = HiveService.getHealthCheckResult();
      final cachedStatus = HiveService.getHealthCheckStatus();
      final lastCheck = HiveService.getLastHealthCheck();

      if (cachedResult != null && cachedStatus != null && lastCheck != null) {
        // Reconstruct ApplicationHealth from cached data
        // Cast the dynamic maps to Map<String, dynamic> for proper type safety
        final systemHealth = SystemHealth.fromJson(
            Map<String, dynamic>.from(cachedResult['system'] as Map));
        final databaseHealth = DatabaseHealth.fromJson(
            Map<String, dynamic>.from(cachedResult['database'] as Map));

        _lastHealthCheck = ApplicationHealth.fromComponents(
          system: systemHealth,
          database: databaseHealth,
        );

        // Emit cached data to stream
        _healthStream.add(_lastHealthCheck!);

        debugPrint(
            '🏥 Health Service: Loaded cached health data - Status: $cachedStatus');
        debugPrint(
            '🏥 Health Service: Last check: ${lastCheck.toString().substring(0, 19)}');
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Failed to load cached health data - $e');
    }
  }

  /// Start periodic health monitoring
  void startPeriodicMonitoring() {
    // Health check timer
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(healthCheckInterval, (timer) {
      performHealthCheck();
    });

    debugPrint('🏥 Health Service: Periodic monitoring started');
  }

  /// Stop periodic monitoring
  void stopPeriodicMonitoring() {
    _healthCheckTimer?.cancel();
    debugPrint('🏥 Health Service: Periodic monitoring stopped');
  }

  /// Perform simplified health check
  Future<ApplicationHealth?> performHealthCheck() async {
    try {
      // Check if we should skip this check due to recent cached data
      if (_shouldUseCachedHealthData()) {
        debugPrint(
            '🏥 Health Service: Skipping health check - recent data available');
        return _lastHealthCheck;
      }

      debugPrint('🏥 Health Service: Performing health check');

      // Execute both health checks in parallel
      final results = await Future.wait([
        getSystemHealth(),
        getDatabaseHealth(),
      ]);

      final systemHealth = results[0] as SystemHealth?;
      final databaseHealth = results[1] as DatabaseHealth?;

      if (systemHealth != null && databaseHealth != null) {
        final appHealth = ApplicationHealth.fromComponents(
          system: systemHealth,
          database: databaseHealth,
        );

        _lastHealthCheck = appHealth;
        _healthStream.add(appHealth);

        // Cache the health check results
        await _cacheHealthCheckResults(appHealth);

        debugPrint(
            '🏥 Health Service: Health check completed - Status: ${appHealth.overallStatus.name}');
        return appHealth;
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Health check failed - $e');
    }

    return null;
  }

  /// Cache health check results to avoid redundant API calls
  Future<void> _cacheHealthCheckResults(ApplicationHealth appHealth) async {
    try {
      await HiveService.saveLastHealthCheck(DateTime.now());
      await HiveService.saveHealthCheckStatus(appHealth.overallStatus.name);
      await HiveService.saveHealthCheckResult(appHealth.toJson());

      debugPrint('🏥 Health Service: Health check results cached');
    } catch (e) {
      debugPrint('🏥 Health Service: Failed to cache health results - $e');
    }
  }

  /// Get system health from /health/ endpoint
  Future<SystemHealth?> getSystemHealth() async {
    try {
      final response = await _apiService.get<SystemHealth>(
        '/health/',
        fromJson: (json) => SystemHealth.fromJson(json),
      );

      if (response.success && response.data != null) {
        debugPrint(
            '🏥 Health Service: System health - ${response.data!.status}');
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

  /// Get database health from /health/db/ endpoint
  Future<DatabaseHealth?> getDatabaseHealth() async {
    try {
      final response = await _apiService.get<DatabaseHealth>(
        '/health/db/',
        fromJson: (json) => DatabaseHealth.fromJson(json),
      );

      if (response.success && response.data != null) {
        debugPrint(
            '🏥 Health Service: Database health - ${response.data!.status}');
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

  /// Get current application health status
  ApplicationHealth? get currentHealth => _lastHealthCheck;

  /// Stream of health updates
  Stream<ApplicationHealth> get healthStream => _healthStream.stream;

  /// Check if the application is healthy
  bool get isHealthy => _lastHealthCheck?.overallStatus == HealthStatus.healthy;

  /// Check if the application is experiencing issues
  bool get hasIssues =>
      _lastHealthCheck?.overallStatus == HealthStatus.unhealthy;

  /// Get health status color for UI
  Color getHealthStatusColor() {
    switch (_lastHealthCheck?.overallStatus) {
      case HealthStatus.healthy:
        return const Color(0xFF4CAF50); // Green
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
        return Prbal.checkCircle;
      case HealthStatus.unhealthy:
        return Prbal.error;
      case HealthStatus.unknown:
      default:
        return Prbal.help;
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
  }) {
    if (healthCheckInterval != null) {
      this.healthCheckInterval = healthCheckInterval;
    }

    // Restart monitoring with new intervals
    if (_healthCheckTimer?.isActive == true) {
      stopPeriodicMonitoring();
      startPeriodicMonitoring();
    }
  }

  /// Dispose the service
  void dispose() {
    stopPeriodicMonitoring();
    _healthStream.close();
    debugPrint('🏥 Health Service: Disposed');
  }

  /// Force a fresh health check (ignores cache)
  Future<ApplicationHealth?> forceHealthCheck() async {
    try {
      debugPrint('🏥 Health Service: Forcing fresh health check');

      // Execute both health checks in parallel
      final results = await Future.wait([
        getSystemHealth(),
        getDatabaseHealth(),
      ]);

      final systemHealth = results[0] as SystemHealth?;
      final databaseHealth = results[1] as DatabaseHealth?;

      if (systemHealth != null && databaseHealth != null) {
        final appHealth = ApplicationHealth.fromComponents(
          system: systemHealth,
          database: databaseHealth,
        );

        _lastHealthCheck = appHealth;
        _healthStream.add(appHealth);

        // Cache the health check results
        await _cacheHealthCheckResults(appHealth);

        debugPrint(
            '🏥 Health Service: Forced health check completed - Status: ${appHealth.overallStatus.name}');
        return appHealth;
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Forced health check failed - $e');
    }

    return null;
  }

  /// Get quick health status from cache (no network call)
  HealthStatus? getQuickHealthStatus() {
    // First check in-memory cache
    if (_lastHealthCheck != null) {
      return _lastHealthCheck!.overallStatus;
    }

    // Then check persistent cache
    final cachedStatus = HiveService.getHealthCheckStatus();
    if (cachedStatus != null) {
      switch (cachedStatus.toLowerCase()) {
        case 'healthy':
          return HealthStatus.healthy;
        case 'unhealthy':
          return HealthStatus.unhealthy;
        default:
          return HealthStatus.unknown;
      }
    }

    return null;
  }

  /// Check if cached health data is available
  bool get hasCachedHealthData =>
      _lastHealthCheck != null || HiveService.getHealthCheckStatus() != null;
}
