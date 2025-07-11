import 'package:flutter/foundation.dart';

// ===== ENUMS =====

/// Health status enumeration
enum HealthStatus {
  healthy,
  unhealthy,
  unknown;

  String get value {
    switch (this) {
      case HealthStatus.healthy:
        return 'healthy';
      case HealthStatus.unhealthy:
        return 'unhealthy';
      case HealthStatus.unknown:
        return 'unknown';
    }
  }

  static HealthStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return HealthStatus.healthy;
      case 'unhealthy':
        return HealthStatus.unhealthy;
      case 'unknown':
      default:
        return HealthStatus.unknown;
    }
  }

  /// Get health status color for UI
  String get color {
    switch (this) {
      case HealthStatus.healthy:
        return '#4CAF50'; // Green
      case HealthStatus.unhealthy:
        return '#F44336'; // Red
      case HealthStatus.unknown:
        return '#9E9E9E'; // Grey
    }
  }

  /// Get status display text
  String get displayText {
    switch (this) {
      case HealthStatus.healthy:
        return 'Healthy';
      case HealthStatus.unhealthy:
        return 'Unhealthy';
      case HealthStatus.unknown:
        return 'Unknown';
    }
  }

  @override
  String toString() =>
      'HealthStatus.$name(value: $value, display: $displayText, color: $color)';
}

/// Connectivity status enumeration
enum ConnectivityStatus {
  online,
  offline,
  unknown;

  String get value {
    switch (this) {
      case ConnectivityStatus.online:
        return 'online';
      case ConnectivityStatus.offline:
        return 'offline';
      case ConnectivityStatus.unknown:
        return 'unknown';
    }
  }

  static ConnectivityStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return ConnectivityStatus.online;
      case 'offline':
        return ConnectivityStatus.offline;
      case 'unknown':
      default:
        return ConnectivityStatus.unknown;
    }
  }

  /// Get connectivity status display text
  String get displayText {
    switch (this) {
      case ConnectivityStatus.online:
        return 'Online';
      case ConnectivityStatus.offline:
        return 'Offline';
      case ConnectivityStatus.unknown:
        return 'Unknown';
    }
  }

  /// Get connectivity status color
  String get color {
    switch (this) {
      case ConnectivityStatus.online:
        return '#4CAF50'; // Green
      case ConnectivityStatus.offline:
        return '#F44336'; // Red
      case ConnectivityStatus.unknown:
        return '#FF9800'; // Orange
    }
  }

  @override
  String toString() =>
      'ConnectivityStatus.$name(value: $value, display: $displayText, color: $color)';
}

// ===== MAIN MODELS =====

/// System health model
class SystemHealth {
  final String status;
  final String version;
  final DateTime timestamp;

  const SystemHealth({
    required this.status,
    required this.version,
    required this.timestamp,
  });

  factory SystemHealth.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('🏥 Parsing SystemHealth from JSON: ${json.keys.join(', ')}');

      return SystemHealth(
        status: json['status'] as String? ?? 'unknown',
        version: json['version'] as String? ?? '1.0.0',
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing SystemHealth from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');

      // Return fallback SystemHealth
      return SystemHealth.offline();
    }
  }

  /// Create offline fallback system health
  factory SystemHealth.offline() {
    return SystemHealth(
      status: 'offline',
      version: '1.0.0',
      timestamp: DateTime.now(),
    );
  }

  /// Create healthy system health
  factory SystemHealth.healthy({String version = '1.0.0'}) {
    return SystemHealth(
      status: 'healthy',
      version: version,
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'status': status,
      'version': version,
      'timestamp': timestamp.toIso8601String(),
    };

    debugPrint('📤 SystemHealth toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Get health status enum
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

  /// Check if system is healthy
  bool get isHealthy => healthStatus == HealthStatus.healthy;

  /// Check if system is offline
  bool get isOffline => status.toLowerCase() == 'offline';

  /// Get formatted timestamp
  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() =>
      'SystemHealth(status: $status, version: $version, healthStatus: ${healthStatus.displayText})';
}

/// Database health model
class DatabaseHealth {
  final String status;
  final DateTime timestamp;

  const DatabaseHealth({
    required this.status,
    required this.timestamp,
  });

  factory DatabaseHealth.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint(
          '🏥 Parsing DatabaseHealth from JSON: ${json.keys.join(', ')}');

      return DatabaseHealth(
        status: json['status'] as String? ?? 'unknown',
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing DatabaseHealth from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');

      // Return fallback DatabaseHealth
      return DatabaseHealth.offline();
    }
  }

  /// Create offline fallback database health
  factory DatabaseHealth.offline() {
    return DatabaseHealth(
      status: 'offline',
      timestamp: DateTime.now(),
    );
  }

  /// Create healthy database health
  factory DatabaseHealth.healthy() {
    return DatabaseHealth(
      status: 'database_connected',
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };

    debugPrint('📤 DatabaseHealth toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Get health status enum
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

  /// Check if database is healthy
  bool get isHealthy => healthStatus == HealthStatus.healthy;

  /// Check if database is connected
  bool get isConnected => status.toLowerCase() == 'database_connected';

  /// Check if database is offline
  bool get isOffline => status.toLowerCase() == 'offline';

  /// Get formatted timestamp
  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() =>
      'DatabaseHealth(status: $status, healthStatus: ${healthStatus.displayText})';
}

/// Overall application health model
class ApplicationHealth {
  final SystemHealth system;
  final DatabaseHealth database;
  final HealthStatus overallStatus;
  final DateTime lastUpdate;
  final ConnectivityStatus connectivityStatus;

  const ApplicationHealth({
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
    try {
      debugPrint('🏥 Creating ApplicationHealth from components');
      debugPrint('🏥 → System Status: ${system.healthStatus.displayText}');
      debugPrint('🏥 → Database Status: ${database.healthStatus.displayText}');
      debugPrint('🏥 → Connectivity Status: ${connectivityStatus.displayText}');

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

      debugPrint('🏥 → Overall Status: ${overallStatus.displayText}');

      return ApplicationHealth(
        system: system,
        database: database,
        overallStatus: overallStatus,
        lastUpdate: DateTime.now(),
        connectivityStatus: connectivityStatus,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error creating ApplicationHealth from components: $e');
      debugPrint('📋 Stack trace: $stackTrace');

      // Return fallback ApplicationHealth
      return ApplicationHealth.offline();
    }
  }

  factory ApplicationHealth.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint(
          '🏥 Parsing ApplicationHealth from JSON: ${json.keys.join(', ')}');

      return ApplicationHealth(
        system: SystemHealth.fromJson(json['system'] as Map<String, dynamic>),
        database:
            DatabaseHealth.fromJson(json['database'] as Map<String, dynamic>),
        overallStatus:
            HealthStatus.fromString(json['overall_status'] as String),
        lastUpdate: DateTime.parse(json['last_update'] as String),
        connectivityStatus: ConnectivityStatus.fromString(
            json['connectivity_status'] as String),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing ApplicationHealth from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');

      // Return fallback ApplicationHealth
      return ApplicationHealth.offline();
    }
  }

  /// Create offline application health
  factory ApplicationHealth.offline() {
    return ApplicationHealth(
      system: SystemHealth.offline(),
      database: DatabaseHealth.offline(),
      overallStatus: HealthStatus.unknown,
      lastUpdate: DateTime.now(),
      connectivityStatus: ConnectivityStatus.offline,
    );
  }

  /// Create healthy application health
  factory ApplicationHealth.healthy({String systemVersion = '1.0.0'}) {
    return ApplicationHealth(
      system: SystemHealth.healthy(version: systemVersion),
      database: DatabaseHealth.healthy(),
      overallStatus: HealthStatus.healthy,
      lastUpdate: DateTime.now(),
      connectivityStatus: ConnectivityStatus.online,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'system': system.toJson(),
      'database': database.toJson(),
      'overall_status': overallStatus.name,
      'last_update': lastUpdate.toIso8601String(),
      'connectivity_status': connectivityStatus.name,
    };

    debugPrint('📤 ApplicationHealth toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Check if application is healthy
  bool get isHealthy => overallStatus == HealthStatus.healthy;

  /// Check if application is offline
  bool get isOffline => connectivityStatus == ConnectivityStatus.offline;

  /// Check if application is online
  bool get isOnline => connectivityStatus == ConnectivityStatus.online;

  /// Check if both system and database are healthy
  bool get isFullyHealthy => system.isHealthy && database.isHealthy && isOnline;

  /// Get health summary string
  String get healthSummary {
    final statusName = overallStatus.displayText.toUpperCase();
    final connectivityName = connectivityStatus.displayText.toUpperCase();
    final lastUpdateTime = lastUpdate.toLocal();

    return 'System: $statusName | Network: $connectivityName (Updated: ${lastUpdateTime.hour}:${lastUpdateTime.minute.toString().padLeft(2, '0')})';
  }

  /// Get formatted last update time
  String get formattedLastUpdate {
    return '${lastUpdate.day}/${lastUpdate.month}/${lastUpdate.year} ${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')}';
  }

  /// Get time since last update
  String get timeSinceUpdate {
    final now = DateTime.now();
    final difference = now.difference(lastUpdate);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Create updated health with new connectivity status
  ApplicationHealth copyWithConnectivity(
      ConnectivityStatus newConnectivityStatus) {
    return ApplicationHealth.fromComponents(
      system: system,
      database: database,
      connectivityStatus: newConnectivityStatus,
    );
  }

  /// Create updated health with new system health
  ApplicationHealth copyWithSystemHealth(SystemHealth newSystemHealth) {
    return ApplicationHealth.fromComponents(
      system: newSystemHealth,
      database: database,
      connectivityStatus: connectivityStatus,
    );
  }

  /// Create updated health with new database health
  ApplicationHealth copyWithDatabaseHealth(DatabaseHealth newDatabaseHealth) {
    return ApplicationHealth.fromComponents(
      system: system,
      database: newDatabaseHealth,
      connectivityStatus: connectivityStatus,
    );
  }

  @override
  String toString() =>
      'ApplicationHealth(overall: ${overallStatus.displayText}, system: ${system.healthStatus.displayText}, database: ${database.healthStatus.displayText}, connectivity: ${connectivityStatus.displayText})';
}
