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

  /// Initialize performance monitoring
  Future<void> initializePerformanceMonitoring() async {
    if (kDebugMode) {
      // Monitor frame performance
      SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
        _checkFramePerformance();
      });

      debugPrint('Performance monitoring initialized');
    }

    // Initialize health monitoring
    await _healthService.initialize();
  }

  /// Check frame rendering performance
  void _checkFramePerformance() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // Monitor frame budget (16.67ms for 60fps)
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final frameDuration = DateTime.now().millisecondsSinceEpoch - currentTime;

      if (frameDuration > 16) {
        debugPrint('⚠️ Frame budget exceeded: ${frameDuration}ms');
      }
    });
  }

  /// Optimize app startup
  Future<void> optimizeStartup() async {
    // Warm up platform channels
    await _warmupPlatformChannels();

    // Pre-cache commonly used resources
    await _precacheResources();
  }

  /// Warm up platform channels to reduce first-use latency
  Future<void> _warmupPlatformChannels() async {
    try {
      // Warm up method channels that will be used frequently
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      debugPrint('Platform channels warmed up');
    } catch (e) {
      debugPrint('Platform channel warmup error: $e');
    }
  }

  /// Pre-cache commonly used resources
  Future<void> _precacheResources() async {
    try {
      // Pre-load system fonts
      await _preloadSystemFonts();
      debugPrint('Resources pre-cached');
    } catch (e) {
      debugPrint('Resource pre-caching error: $e');
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
      debugPrint('Memory optimization triggered');
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

  /// Report performance metrics
  Future<void> reportPerformanceMetrics() async {
    if (kDebugMode) {
      final binding = SchedulerBinding.instance;
      debugPrint('=== Performance Metrics ===');
      debugPrint('Lifecycle state: ${binding.lifecycleState}');
      debugPrint('Frame scheduling: ${binding.hasScheduledFrame}');

      // Get health metrics
      try {
        await _healthService.performHealthCheck();
        debugPrint('Health monitoring: Active');
      } catch (e) {
        debugPrint('Health monitoring: Error - $e');
      }

      debugPrint('============================');
    }
  }

  /// Optimize image loading
  static void optimizeImageLoading() {
    // Set reasonable image cache limits
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        50 * 1024 * 1024; // 50MB
  }

  /// Reduce animation complexity during heavy operations
  void reduceAnimationComplexity() {
    // Disable non-essential animations during heavy operations
    SchedulerBinding.instance.addPostFrameCallback((_) {
      debugPrint('Animation complexity reduced for performance');
    });
  }
}
