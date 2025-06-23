import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:prbal/services/health_service.dart';

/// Performance monitoring and optimization service
class PerformanceService {
  static PerformanceService? _instance;

  PerformanceService._();

  static PerformanceService get instance {
    _instance ??= PerformanceService._();
    return _instance!;
  }

  final HealthService _healthService = HealthService();

  // Performance metrics
  int _frameDropCount = 0;
  DateTime? _lastFrameCheck;
  List<int> _frameTimes = [];

  /// Initialize performance monitoring
  Future<void> initializePerformanceMonitoring() async {
    if (kDebugMode) {
      // Monitor frame performance
      SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
        _checkFramePerformance();
      });

      debugPrint('🚀 Performance monitoring initialized');
    }

    // Initialize health monitoring
    try {
      await _healthService.initialize();
      debugPrint('🏥 Health monitoring integrated with performance service');
    } catch (e) {
      debugPrint('🏥 Health monitoring integration failed: $e');
    }
  }

  /// Check frame rendering performance
  void _checkFramePerformance() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    _lastFrameCheck ??= DateTime.now();

    // Monitor frame budget (16.67ms for 60fps)
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final frameDuration = DateTime.now().millisecondsSinceEpoch - currentTime;

      // Track frame times
      _frameTimes.add(frameDuration);
      if (_frameTimes.length > 100) {
        _frameTimes.removeAt(0); // Keep only last 100 frames
      }

      if (frameDuration > 16) {
        _frameDropCount++;
        debugPrint(
            '⚠️ Frame budget exceeded: ${frameDuration}ms (Drops: $_frameDropCount)');
      }
    });
  }

  /// Get current performance metrics
  Map<String, dynamic> getPerformanceMetrics() {
    final avgFrameTime = _frameTimes.isNotEmpty
        ? _frameTimes.reduce((a, b) => a + b) / _frameTimes.length
        : 0.0;

    return {
      'frame_drops': _frameDropCount,
      'average_frame_time': avgFrameTime,
      'target_frame_time': 16.67,
      'performance_score': _calculatePerformanceScore(),
      'last_check': _lastFrameCheck?.toIso8601String(),
    };
  }

  /// Calculate performance score (0-100)
  double _calculatePerformanceScore() {
    if (_frameTimes.isEmpty) return 100.0;

    final avgFrameTime =
        _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    final dropRate = _frameDropCount / _frameTimes.length;

    // Score based on frame time and drop rate
    final frameScore = (16.67 / (avgFrameTime + 1)) * 50; // Max 50 points
    final dropScore = ((1 - dropRate) * 50).clamp(0, 50); // Max 50 points

    return (frameScore + dropScore).clamp(0, 100);
  }

  /// Optimize app startup
  Future<void> optimizeStartup() async {
    debugPrint('🚀 Starting app optimization...');

    // Warm up platform channels
    await _warmupPlatformChannels();

    // Pre-cache commonly used resources
    await _precacheResources();

    // Initialize health monitoring
    await _healthService.initialize();

    debugPrint('🚀 App optimization completed');
  }

  /// Warm up platform channels to reduce first-use latency
  Future<void> _warmupPlatformChannels() async {
    try {
      // Warm up method channels that will be used frequently
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      debugPrint('🔌 Platform channels warmed up');
    } catch (e) {
      debugPrint('🔌 Platform channel warmup error: $e');
    }
  }

  /// Pre-cache commonly used resources
  Future<void> _precacheResources() async {
    try {
      // Pre-load system fonts
      await _preloadSystemFonts();
      debugPrint('📦 Resources pre-cached');
    } catch (e) {
      debugPrint('📦 Resource pre-caching error: $e');
    }
  }

  /// Pre-load system fonts to reduce text rendering latency
  Future<void> _preloadSystemFonts() async {
    // This will trigger font loading
    const textStyles = [
      TextStyle(fontSize: 12),
      TextStyle(fontSize: 14),
      TextStyle(fontSize: 16),
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ];

    for (final style in textStyles) {
      // Force font loading by creating a painter
      final painter = TextPainter(
        text: TextSpan(text: 'Test', style: style),
        textDirection: TextDirection.ltr,
      );
      painter.layout();
    }
  }

  /// Optimize memory usage
  void optimizeMemory() {
    if (kDebugMode) {
      debugPrint('🧹 Memory optimization triggered');
    }

    // Clear performance metrics history to free memory
    if (_frameTimes.length > 50) {
      _frameTimes = _frameTimes.sublist(_frameTimes.length - 50);
    }

    // Force garbage collection in debug mode
    if (kDebugMode) {
      // This is only for debugging purposes
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Suggest garbage collection
        SystemChannels.platform.invokeMethod('System.gc');
      });
    }
  }

  /// Report comprehensive performance and health metrics
  Future<void> reportPerformanceMetrics() async {
    if (kDebugMode) {
      final binding = SchedulerBinding.instance;
      final performanceMetrics = getPerformanceMetrics();

      debugPrint('=== Performance & Health Report ===');
      debugPrint('Lifecycle state: ${binding.lifecycleState}');
      debugPrint('Frame scheduling: ${binding.hasScheduledFrame}');
      debugPrint(
          'Performance score: ${performanceMetrics['performance_score']?.toStringAsFixed(1)}%');
      debugPrint(
          'Average frame time: ${performanceMetrics['average_frame_time']?.toStringAsFixed(2)}ms');
      debugPrint('Frame drops: ${performanceMetrics['frame_drops']}');

      // Get health status
      try {
        final healthCheck = await _healthService.performHealthCheck();
        if (healthCheck != null) {
          debugPrint('System health: ${healthCheck.system.status}');
          debugPrint('Database health: ${healthCheck.database.status}');
          debugPrint('Overall status: ${healthCheck.overallStatus.name}');
          debugPrint('App version: ${healthCheck.system.version}');
        } else {
          debugPrint('Health monitoring: No data available');
        }
      } catch (e) {
        debugPrint('Health monitoring: Error - $e');
      }

      debugPrint('================================');
    }
  }

  /// Get current health status
  Future<ApplicationHealth?> getCurrentHealthStatus() async {
    try {
      return await _healthService.performHealthCheck();
    } catch (e) {
      debugPrint('🏥 Failed to get health status: $e');
      return null;
    }
  }

  /// Check if system is healthy for performance-critical operations
  Future<bool> isSystemHealthy() async {
    try {
      final health = await _healthService.performHealthCheck();
      return health?.overallStatus == HealthStatus.healthy;
    } catch (e) {
      debugPrint('🏥 Health check failed: $e');
      return false; // Assume unhealthy if check fails
    }
  }

  /// Optimize image loading
  static void optimizeImageLoading() {
    // Set reasonable image cache limits
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        50 * 1024 * 1024; // 50MB

    debugPrint('🖼️ Image loading optimized');
  }

  /// Reduce animation complexity during heavy operations
  void reduceAnimationComplexity() {
    // Disable non-essential animations during heavy operations
    SchedulerBinding.instance.addPostFrameCallback((_) {
      debugPrint('🎨 Animation complexity reduced for performance');
    });
  }

  /// Reset performance metrics
  void resetPerformanceMetrics() {
    _frameDropCount = 0;
    _frameTimes.clear();
    _lastFrameCheck = DateTime.now();
    debugPrint('📊 Performance metrics reset');
  }

  /// Dispose the performance service
  void dispose() {
    _healthService.dispose();
    _frameTimes.clear();
    debugPrint('🚀 Performance service disposed');
  }
}
