import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

/// Health status enumeration
enum HealthStatus {
  healthy,
  unhealthy,
  unknown,
}

/// Connectivity status enumeration
enum ConnectivityStatus {
  online,
  offline,
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

  /// Create offline fallback system health
  factory SystemHealth.offline() {
    return SystemHealth(
      status: 'offline',
      version: '1.0.0',
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
      case 'offline':
        return HealthStatus.unknown;
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

  /// Create offline fallback database health
  factory DatabaseHealth.offline() {
    return DatabaseHealth(
      status: 'offline',
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
      case 'offline':
        return HealthStatus.unknown;
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
  final ConnectivityStatus connectivityStatus;

  ApplicationHealth({
    required this.system,
    required this.database,
    required this.overallStatus,
    required this.lastUpdate,
    required this.connectivityStatus,
  });

  factory ApplicationHealth.fromComponents({
    required SystemHealth system,
    required DatabaseHealth database,
    ConnectivityStatus connectivityStatus = ConnectivityStatus.unknown,
  }) {
    // Determine overall status based on both components and connectivity
    HealthStatus overallStatus = HealthStatus.healthy;

    // If offline, status is unknown
    if (connectivityStatus == ConnectivityStatus.offline) {
      overallStatus = HealthStatus.unknown;
    } else if (system.healthStatus == HealthStatus.unhealthy ||
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
      connectivityStatus: connectivityStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'system': system.toJson(),
      'database': database.toJson(),
      'overall_status': overallStatus.name,
      'last_update': lastUpdate.toIso8601String(),
      'connectivity_status': connectivityStatus.name,
    };
  }
}

/// Enhanced health monitoring service with connectivity checking
class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final ApiService _apiService = ApiService();
  final Connectivity _connectivity = Connectivity();

  Timer? _healthCheckTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Cached health data
  ApplicationHealth? _lastHealthCheck;
  ConnectivityStatus _currentConnectivityStatus = ConnectivityStatus.unknown;

  // Health monitoring configuration
  Duration healthCheckInterval = const Duration(minutes: 5);

  // Stream controller for real-time updates
  final StreamController<ApplicationHealth> _healthStream =
      StreamController<ApplicationHealth>.broadcast();

  /// Initialize health monitoring with connectivity tracking
  Future<void> initialize() async {
    try {
      debugPrint(
          '🏥 Health Service: Initializing health monitoring with connectivity tracking');

      // Initialize connectivity monitoring
      await _initializeConnectivityMonitoring();

      // Check if we have recent cached health data
      if (_shouldUseCachedHealthData()) {
        debugPrint(
            '🏥 Health Service: Using cached health data (recent check found)');
        _loadCachedHealthData();
      } else {
        // Perform initial health check (with connectivity check)
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

  /// Initialize connectivity monitoring
  Future<void> _initializeConnectivityMonitoring() async {
    try {
      // Check initial connectivity status
      final connectivityResults = await _connectivity.checkConnectivity();
      _currentConnectivityStatus = _mapConnectivityResults(connectivityResults);

      debugPrint(
          '🌐 Health Service: Initial connectivity status: ${_currentConnectivityStatus.name}');

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (connectivityResults) {
          final newStatus = _mapConnectivityResults(connectivityResults);
          if (newStatus != _currentConnectivityStatus) {
            debugPrint(
                '🌐 Health Service: Connectivity changed from ${_currentConnectivityStatus.name} to ${newStatus.name}');
            _currentConnectivityStatus = newStatus;

            // Trigger health check on connectivity change (if online)
            if (_currentConnectivityStatus == ConnectivityStatus.online) {
              debugPrint(
                  '🌐 Health Service: Network restored - triggering health check');
              performHealthCheck();
            }
          }
        },
        onError: (error) {
          debugPrint(
              '🌐 Health Service: Connectivity monitoring error - $error');
          _currentConnectivityStatus = ConnectivityStatus.unknown;
        },
      );
    } catch (e) {
      debugPrint(
          '🌐 Health Service: Failed to initialize connectivity monitoring - $e');
      _currentConnectivityStatus = ConnectivityStatus.unknown;
    }
  }

  /// Map connectivity results to our connectivity status
  ConnectivityStatus _mapConnectivityResults(List<ConnectivityResult> results) {
    if (results.isEmpty) return ConnectivityStatus.offline;

    // Check if any connection type is available (excluding none)
    final hasConnection =
        results.any((result) => result != ConnectivityResult.none);

    if (hasConnection) {
      return ConnectivityStatus.online;
    } else {
      return ConnectivityStatus.offline;
    }
  }

  /// Check current connectivity status
  Future<ConnectivityStatus> checkConnectivity() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      _currentConnectivityStatus = _mapConnectivityResults(connectivityResults);

      debugPrint(
          '🌐 Health Service: Connectivity check result: ${_currentConnectivityStatus.name}');
      return _currentConnectivityStatus;
    } catch (e) {
      debugPrint('🌐 Health Service: Connectivity check failed - $e');
      _currentConnectivityStatus = ConnectivityStatus.unknown;
      return ConnectivityStatus.unknown;
    }
  }

  /// Check if network operations should be attempted
  Future<bool> isNetworkAvailable() async {
    await checkConnectivity();
    final isAvailable = _currentConnectivityStatus == ConnectivityStatus.online;
    debugPrint('🌐 Health Service: Network available: $isAvailable');
    return isAvailable;
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
          connectivityStatus: _currentConnectivityStatus,
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

  /// Perform comprehensive health check with connectivity verification
  Future<ApplicationHealth?> performHealthCheck() async {
    try {
      // Check if we should skip this check due to recent cached data
      if (_shouldUseCachedHealthData()) {
        debugPrint(
            '🏥 Health Service: Skipping health check - recent data available');
        return _lastHealthCheck;
      }

      debugPrint(
          '🏥 Health Service: Starting health check with connectivity verification');

      // First, check network connectivity
      final networkAvailable = await isNetworkAvailable();

      if (!networkAvailable) {
        debugPrint(
            '🏥 Health Service: Network unavailable - using offline fallback');
        return _createOfflineHealthStatus();
      }

      debugPrint(
          '🏥 Health Service: Network available - performing API health checks');

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
          connectivityStatus: _currentConnectivityStatus,
        );

        _lastHealthCheck = appHealth;
        _healthStream.add(appHealth);

        // Cache the health check results
        await _cacheHealthCheckResults(appHealth);

        debugPrint(
            '🏥 Health Service: Health check completed - Status: ${appHealth.overallStatus.name}');
        return appHealth;
      } else {
        debugPrint(
            '🏥 Health Service: API health checks failed - falling back to offline status');
        return _createOfflineHealthStatus();
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Health check failed - $e');
      return _createOfflineHealthStatus();
    }
  }

  /// Create offline fallback health status
  ApplicationHealth _createOfflineHealthStatus() {
    final offlineHealth = ApplicationHealth.fromComponents(
      system: SystemHealth.offline(),
      database: DatabaseHealth.offline(),
      connectivityStatus: _currentConnectivityStatus,
    );

    _lastHealthCheck = offlineHealth;
    _healthStream.add(offlineHealth);

    debugPrint('🏥 Health Service: Created offline health status');
    return offlineHealth;
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

  /// Get system health from /health/ endpoint with connectivity check
  Future<SystemHealth?> getSystemHealth() async {
    try {
      // Verify network availability before API call
      if (!await isNetworkAvailable()) {
        debugPrint(
            '🏥 Health Service: Skipping system health check - no network');
        return SystemHealth.offline();
      }

      debugPrint('🏥 Health Service: Calling system health API');
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

  /// Get database health from /health/db/ endpoint with connectivity check
  Future<DatabaseHealth?> getDatabaseHealth() async {
    try {
      // Verify network availability before API call
      if (!await isNetworkAvailable()) {
        debugPrint(
            '🏥 Health Service: Skipping database health check - no network');
        return DatabaseHealth.offline();
      }

      debugPrint('🏥 Health Service: Calling database health API');
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

  /// Get current connectivity status
  ConnectivityStatus get connectivityStatus => _currentConnectivityStatus;

  /// Stream of health updates
  Stream<ApplicationHealth> get healthStream => _healthStream.stream;

  /// Check if the application is healthy
  bool get isHealthy => _lastHealthCheck?.overallStatus == HealthStatus.healthy;

  /// Check if the application is experiencing issues
  bool get hasIssues =>
      _lastHealthCheck?.overallStatus == HealthStatus.unhealthy;

  /// Check if the application is offline
  bool get isOffline =>
      _currentConnectivityStatus == ConnectivityStatus.offline;

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

  /// Get connectivity status color for UI
  Color getConnectivityStatusColor() {
    switch (_currentConnectivityStatus) {
      case ConnectivityStatus.online:
        return const Color(0xFF4CAF50); // Green
      case ConnectivityStatus.offline:
        return const Color(0xFFF44336); // Red
      case ConnectivityStatus.unknown:
        return const Color(0xFFFF9800); // Orange
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
      case null:
        return Prbal.help;
    }
  }

  /// Get connectivity status icon for UI
  IconData getConnectivityStatusIcon() {
    switch (_currentConnectivityStatus) {
      case ConnectivityStatus.online:
        return Prbal.wifi;
      case ConnectivityStatus.offline:
        return Prbal.wifiOff;
      case ConnectivityStatus.unknown:
        return Prbal.help;
    }
  }

  /// Get health summary for display
  String getHealthSummary() {
    if (_lastHealthCheck == null) return 'Health status unknown';

    final health = _lastHealthCheck!;
    final statusName = health.overallStatus.name.toUpperCase();
    final connectivityName = _currentConnectivityStatus.name.toUpperCase();
    final lastUpdate = health.lastUpdate.toLocal();

    return 'System: $statusName | Network: $connectivityName (Updated: ${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')})';
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
    _connectivitySubscription?.cancel();
    _healthStream.close();
    debugPrint('🏥 Health Service: Disposed');
  }

  /// Force a fresh health check (ignores cache) with connectivity verification
  Future<ApplicationHealth?> forceHealthCheck() async {
    try {
      debugPrint(
          '🏥 Health Service: Forcing fresh health check with connectivity verification');

      // First, check network connectivity
      final networkAvailable = await isNetworkAvailable();

      if (!networkAvailable) {
        debugPrint(
            '🏥 Health Service: Network unavailable for forced check - using offline status');
        return _createOfflineHealthStatus();
      }

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
          connectivityStatus: _currentConnectivityStatus,
        );

        _lastHealthCheck = appHealth;
        _healthStream.add(appHealth);

        // Cache the health check results
        await _cacheHealthCheckResults(appHealth);

        debugPrint(
            '🏥 Health Service: Forced health check completed - Status: ${appHealth.overallStatus.name}');
        return appHealth;
      } else {
        debugPrint(
            '🏥 Health Service: Forced health check failed - falling back to offline status');
        return _createOfflineHealthStatus();
      }
    } catch (e) {
      debugPrint('🏥 Health Service: Forced health check failed - $e');
      return _createOfflineHealthStatus();
    }
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

  /// Wait for network connectivity before proceeding with operations
  Future<bool> waitForConnectivity(
      {Duration timeout = const Duration(seconds: 10)}) async {
    debugPrint(
        '🌐 Health Service: Waiting for network connectivity (timeout: ${timeout.inSeconds}s)');

    final completer = Completer<bool>();
    Timer? timeoutTimer;
    StreamSubscription<List<ConnectivityResult>>? subscription;

    // Check current status first
    if (_currentConnectivityStatus == ConnectivityStatus.online) {
      debugPrint('🌐 Health Service: Already connected');
      return true;
    }

    // Set up timeout
    timeoutTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        debugPrint('🌐 Health Service: Connectivity wait timed out');
        subscription?.cancel();
        completer.complete(false);
      }
    });

    // Listen for connectivity changes
    subscription = _connectivity.onConnectivityChanged.listen((results) {
      final status = _mapConnectivityResults(results);
      if (status == ConnectivityStatus.online && !completer.isCompleted) {
        debugPrint('🌐 Health Service: Network connectivity restored');
        timeoutTimer?.cancel();
        subscription?.cancel();
        completer.complete(true);
      }
    });

    return completer.future;
  }

  /// Perform health check with network wait fallback
  Future<ApplicationHealth?> performHealthCheckWithWait(
      {Duration networkTimeout = const Duration(seconds: 5)}) async {
    // Check if we already have network
    if (await isNetworkAvailable()) {
      return performHealthCheck();
    }

    debugPrint(
        '🏥 Health Service: No network - waiting for connectivity before health check');

    // Wait for network with timeout
    final networkRestored = await waitForConnectivity(timeout: networkTimeout);

    if (networkRestored) {
      debugPrint(
          '🏥 Health Service: Network restored - performing health check');
      return performHealthCheck();
    } else {
      debugPrint(
          '🏥 Health Service: Network wait timed out - using offline status');
      return _createOfflineHealthStatus();
    }
  }
}
