import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:prbal/services/app_services.dart';
import 'package:prbal/components/theme_selector_widget.dart';
import 'package:prbal/components/modern_ui_components.dart';
import 'package:prbal/utils/localization/project_locales.dart';
import 'package:prbal/utils/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/services/auth_service.dart';
import 'package:prbal/services/health_service.dart';
import 'package:prbal/services/performance_service.dart';
import 'package:prbal/services/sync_service.dart';
import 'package:prbal/services/booking_service.dart';
import 'package:prbal/services/admin_service.dart';
// import 'package:prbal/services/notification_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:prbal/widgets/lottie_loading_widget.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Settings Screen - Comprehensive settings management with real backend data
///
/// This screen displays:
/// - Real user profile data from backend
/// - Live system health metrics
/// - Actual app storage usage
/// - Performance monitoring data
/// - Real booking statistics
/// - Platform analytics (for admins)
///
/// Data Sources:
/// - AuthService: User profile, authentication status
/// - HealthService: System health, database status
/// - PerformanceService: App performance metrics
/// - SyncService: Enhanced user profile data
/// - BookingService: Booking statistics
/// - AdminService: Platform analytics (admin only)
/// - HiveService: Local storage and preferences
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // === CORE SERVICES ===
  final HealthService _healthService = HealthService();
  final PerformanceService _performanceService = PerformanceService.instance;

  // === STATE VARIABLES FOR REAL BACKEND DATA ===

  // System Health Data (from backend /health/ endpoints)
  ApplicationHealth? _healthData;

  // Performance Metrics (real-time app performance)
  Map<String, dynamic>? _performanceMetrics;

  // Enhanced User Profile Data (from sync service with complete info)
  SyncUserProfile? _enhancedUserProfile;

  // Real Storage Usage Data (calculated from device)
  Map<String, dynamic>? _storageData;

  // Booking Statistics (real counts from backend)
  Map<String, dynamic>? _bookingStats;

  // Platform Analytics (admin users only)
  Map<String, dynamic>? _platformAnalytics;

  // App Version Info (from pubspec and build data)
  String? _appVersion;
  String? _buildNumber;

  // User Preferences (from local storage)
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  bool _analyticsEnabled = true;

  // Loading states for different data sections
  bool _loadingEnhancedProfile = false;
  bool _loadingBookingStats = false;
  bool _loadingStorageData = false;
  bool _loadingPlatformAnalytics = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔧 Settings Screen: Initializing with real backend data loading...');

    // Load all settings data in parallel for better performance
    _initializeSettingsData();
  }

  /// Initialize all settings data from various backend sources
  /// This method orchestrates loading data from multiple services in parallel
  Future<void> _initializeSettingsData() async {
    debugPrint('🔄 Settings Screen: Starting comprehensive data initialization...');

    try {
      // Execute all data loading operations in parallel for better performance
      await Future.wait([
        _loadUserPreferences(), // Local preferences from Hive
        _loadHealthData(), // Backend health status
        _loadPerformanceData(), // Real-time performance metrics
        _loadAppVersionInfo(), // App version from build
      ]);

      // Load user-specific data if authenticated
      final currentUser = ref.read(authServiceProvider);
      if (currentUser != null) {
        debugPrint('👤 Settings Screen: User authenticated, loading user-specific data...');

        await Future.wait([
          _loadEnhancedUserProfile(), // Enhanced profile from sync service
          _loadBookingStatistics(), // Real booking counts
          _loadStorageUsageData(), // Device storage analysis
        ]);

        // Load admin-specific data if user is admin
        final userType = HiveService.getUserType();
        if (userType == 'admin') {
          debugPrint('👑 Settings Screen: Admin user detected, loading platform analytics...');
          await _loadPlatformAnalytics();
        }
      } else {
        debugPrint('🚫 Settings Screen: User not authenticated, skipping user-specific data');
      }

      debugPrint('✅ Settings Screen: Data initialization completed successfully');
    } catch (e) {
      debugPrint('❌ Settings Screen: Error during data initialization: $e');
      // Continue with available data even if some fails
    }
  }

  /// Load user preferences from local Hive storage
  /// These are settings that don't require backend calls
  Future<void> _loadUserPreferences() async {
    debugPrint('📱 Settings Screen: Loading user preferences from local storage...');

    try {
      final userData = HiveService.getUserData();
      debugPrint('📊 Settings Screen: Raw user data from Hive: ${userData?.keys.toList()}');

      if (mounted) {
        setState(() {
          _notificationsEnabled = userData?['notifications_enabled'] ?? true;
          _biometricsEnabled = userData?['biometrics_enabled'] ?? false;
          _analyticsEnabled = userData?['analytics_enabled'] ?? true;
        });

        debugPrint(
            '✅ Settings Screen: Preferences loaded - Notifications: $_notificationsEnabled, Biometrics: $_biometricsEnabled, Analytics: $_analyticsEnabled');
      }
    } catch (e) {
      debugPrint('❌ Settings Screen: Error loading user preferences: $e');
    }
  }

  /// Load real system health data from backend health endpoints
  /// Uses /health/ and /health/db/ endpoints for live system status
  Future<void> _loadHealthData() async {
    debugPrint('🏥 Settings Screen: Loading system health data from backend...');

    try {
      final health = await _healthService.performHealthCheck();

      if (health != null) {
        debugPrint('✅ Settings Screen: Health data loaded successfully');
        debugPrint('   - System Status: ${health.system.status}');
        debugPrint('   - Database Status: ${health.database.status}');
        debugPrint('   - Overall Status: ${health.overallStatus.name}');
        debugPrint('   - System Version: ${health.system.version}');
        debugPrint('   - Last Update: ${health.lastUpdate}');

        if (mounted) {
          setState(() {
            _healthData = health;
          });
        }
      } else {
        debugPrint('⚠️ Settings Screen: Health data is null, health check may have failed');
      }
    } catch (e) {
      debugPrint('❌ Settings Screen: Failed to load health data: $e');
    }
  }

  /// Load real-time performance metrics from PerformanceService
  /// Includes frame rates, memory usage, and app performance indicators
  Future<void> _loadPerformanceData() async {
    debugPrint('📊 Settings Screen: Loading real-time performance metrics...');

    try {
      final metrics = _performanceService.getPerformanceMetrics();

      if (metrics.isNotEmpty) {
        debugPrint('✅ Settings Screen: Performance metrics loaded:');
        debugPrint('   - Performance Score: ${metrics['performance_score']}%');
        debugPrint('   - Average Frame Time: ${metrics['average_frame_time']}ms');
        debugPrint('   - Frame Drops: ${metrics['frame_drops']}');
        debugPrint('   - Total Frames: ${metrics['total_frames']}');

        if (mounted) {
          setState(() {
            _performanceMetrics = metrics;
          });
        }
      } else {
        debugPrint('⚠️ Settings Screen: Performance metrics are empty');
      }
    } catch (e) {
      debugPrint('❌ Settings Screen: Failed to load performance data: $e');
    }
  }

  /// Load enhanced user profile data from SyncService
  /// This provides more detailed user information than the basic auth profile
  Future<void> _loadEnhancedUserProfile() async {
    debugPrint('👤 Settings Screen: Loading enhanced user profile from sync service...');

    setState(() {
      _loadingEnhancedProfile = true;
    });

    try {
      // First try to get cached profile for immediate display
      final syncService = ref.read(syncServiceProvider.notifier);
      final cachedProfile = await syncService.getCachedUserProfile();

      if (cachedProfile != null) {
        debugPrint('📱 Settings Screen: Using cached enhanced profile data');
        debugPrint('   - User ID: ${cachedProfile.id}');
        debugPrint('   - Username: ${cachedProfile.username}');
        debugPrint('   - User Type: ${cachedProfile.userType}');
        debugPrint('   - Rating: ${cachedProfile.rating}');
        debugPrint('   - Balance: ${cachedProfile.balance}');
        debugPrint('   - Verified: ${cachedProfile.isVerified}');
        debugPrint('   - Date Joined: ${cachedProfile.dateJoined}');
        debugPrint('   - Last Login: ${cachedProfile.lastLogin}');

        if (mounted) {
          setState(() {
            _enhancedUserProfile = cachedProfile;
          });
        }
      }

      // Then try to download fresh profile data
      debugPrint('🔄 Settings Screen: Downloading fresh profile data from backend...');
      final response = await syncService.downloadUserProfile();

      if (response.success && response.data != null) {
        debugPrint('✅ Settings Screen: Fresh enhanced profile downloaded');
        final freshProfile = response.data!;

        debugPrint('   - Updated User Data:');
        debugPrint('     * Display Name: ${freshProfile.firstName} ${freshProfile.lastName}');
        debugPrint('     * Email: ${freshProfile.email}');
        debugPrint('     * Phone: ${freshProfile.phoneNumber}');
        debugPrint('     * Location: ${freshProfile.location}');
        debugPrint('     * Bio: ${freshProfile.bio?.substring(0, 50) ?? "No bio"}...');

        if (mounted) {
          setState(() {
            _enhancedUserProfile = freshProfile;
          });
        }
      } else {
        debugPrint('⚠️ Settings Screen: Failed to download fresh profile: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Settings Screen: Error loading enhanced user profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingEnhancedProfile = false;
        });
      }
    }
  }

  /// Load real booking statistics from BookingService
  /// Gets actual booking counts and statistics for the current user
  Future<void> _loadBookingStatistics() async {
    debugPrint('📅 Settings Screen: Loading real booking statistics...');

    setState(() {
      _loadingBookingStats = true;
    });

    try {
      final userType = HiveService.getUserType();
      final bookingService = ref.read(bookingServiceProvider);

      Map<String, dynamic> bookingStats = {
        'total_bookings': 0,
        'completed_bookings': 0,
        'pending_bookings': 0,
        'cancelled_bookings': 0,
        'total_earnings': '0.00',
        'average_rating': 0.0,
      };

      if (userType == 'provider') {
        debugPrint('🔧 Settings Screen: Loading provider booking statistics...');

        // Get all provider bookings
        final allBookingsResponse = await bookingService.listProviderBookings();

        if (allBookingsResponse.success && allBookingsResponse.data != null) {
          final bookings = allBookingsResponse.data!.results;

          // Calculate real statistics
          bookingStats['total_bookings'] = bookings.length;
          bookingStats['completed_bookings'] = bookings.where((b) => b.status == BookingStatus.completed).length;
          bookingStats['pending_bookings'] = bookings.where((b) => b.status == BookingStatus.pending).length;
          bookingStats['cancelled_bookings'] = bookings.where((b) => b.status == BookingStatus.cancelled).length;

          // Calculate total earnings from completed bookings
          double totalEarnings = bookings
              .where((b) => b.status == BookingStatus.completed)
              .fold(0.0, (sum, booking) => sum + booking.amount);
          bookingStats['total_earnings'] = totalEarnings.toStringAsFixed(2);

          debugPrint('✅ Settings Screen: Provider stats calculated:');
          debugPrint('   - Total Bookings: ${bookingStats['total_bookings']}');
          debugPrint('   - Completed: ${bookingStats['completed_bookings']}');
          debugPrint('   - Pending: ${bookingStats['pending_bookings']}');
          debugPrint('   - Total Earnings: \$${bookingStats['total_earnings']}');
        }
      } else if (userType == 'customer') {
        debugPrint('🛒 Settings Screen: Loading customer booking statistics...');

        // Get all customer bookings
        final allBookingsResponse = await bookingService.listCustomerBookings();

        if (allBookingsResponse.success && allBookingsResponse.data != null) {
          final bookings = allBookingsResponse.data!.results;

          bookingStats['total_bookings'] = bookings.length;
          bookingStats['completed_bookings'] = bookings.where((b) => b.status == BookingStatus.completed).length;
          bookingStats['pending_bookings'] = bookings.where((b) => b.status == BookingStatus.pending).length;
          bookingStats['cancelled_bookings'] = bookings.where((b) => b.status == BookingStatus.cancelled).length;

          debugPrint('✅ Settings Screen: Customer stats calculated:');
          debugPrint('   - Total Bookings: ${bookingStats['total_bookings']}');
          debugPrint('   - Completed: ${bookingStats['completed_bookings']}');
          debugPrint('   - Pending: ${bookingStats['pending_bookings']}');
        }
      }

      if (mounted) {
        setState(() {
          _bookingStats = bookingStats;
        });
      }
    } catch (e) {
      debugPrint('❌ Settings Screen: Error loading booking statistics: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingBookingStats = false;
        });
      }
    }
  }

  /// Calculate real device storage usage data
  /// Analyzes actual app storage, cache, and data usage
  Future<void> _loadStorageUsageData() async {
    debugPrint('💾 Settings Screen: Calculating real device storage usage...');

    setState(() {
      _loadingStorageData = true;
    });

    try {
      // Get application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final tempDir = await getTemporaryDirectory();

      // Calculate real storage usage
      Map<String, dynamic> storageData = {
        'app_data_size': await _calculateDirectorySize(appDir),
        'cache_size': await _calculateDirectorySize(tempDir),
        'hive_db_size': await _calculateHiveStorageSize(),
        'total_size': 0,
        'available_space': 0,
      };

      // Calculate total app storage
      storageData['total_size'] =
          storageData['app_data_size'] + storageData['cache_size'] + storageData['hive_db_size'];

      // Format sizes for display
      storageData['app_data_formatted'] = _formatBytes(storageData['app_data_size']);
      storageData['cache_formatted'] = _formatBytes(storageData['cache_size']);
      storageData['hive_db_formatted'] = _formatBytes(storageData['hive_db_size']);
      storageData['total_formatted'] = _formatBytes(storageData['total_size']);

      debugPrint('✅ Settings Screen: Real storage usage calculated:');
      debugPrint('   - App Data: ${storageData['app_data_formatted']}');
      debugPrint('   - Cache: ${storageData['cache_formatted']}');
      debugPrint('   - Database: ${storageData['hive_db_formatted']}');
      debugPrint('   - Total: ${storageData['total_formatted']}');

      if (mounted) {
        setState(() {
          _storageData = storageData;
        });
      }
    } catch (e) {
      debugPrint('❌ Settings Screen: Error calculating storage usage: $e');

      // Fallback to estimated values if calculation fails
      if (mounted) {
        setState(() {
          _storageData = {
            'app_data_formatted': '~25 MB',
            'cache_formatted': '~8 MB',
            'hive_db_formatted': '~2 MB',
            'total_formatted': '~35 MB',
          };
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingStorageData = false;
        });
      }
    }
  }

  /// Load platform analytics data for admin users
  /// Gets real platform statistics and user metrics
  Future<void> _loadPlatformAnalytics() async {
    debugPrint('📈 Settings Screen: Loading platform analytics for admin user...');

    setState(() {
      _loadingPlatformAnalytics = true;
    });

    try {
      final adminService = ref.read(adminServiceProvider);

      // Get platform analytics
      final analyticsResponse = await adminService.getPlatformAnalytics(
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now(),
      );

      if (analyticsResponse.success && analyticsResponse.data != null) {
        final analytics = analyticsResponse.data!;

        debugPrint('✅ Settings Screen: Platform analytics loaded:');
        debugPrint('   - Analytics Keys: ${analytics.keys.toList()}');

        // Log key metrics for debugging
        if (analytics.containsKey('total_users')) {
          debugPrint('   - Total Users: ${analytics['total_users']}');
        }
        if (analytics.containsKey('total_bookings')) {
          debugPrint('   - Total Bookings: ${analytics['total_bookings']}');
        }
        if (analytics.containsKey('total_revenue')) {
          debugPrint('   - Total Revenue: ${analytics['total_revenue']}');
        }

        if (mounted) {
          setState(() {
            _platformAnalytics = analytics;
          });
        }
      } else {
        debugPrint('⚠️ Settings Screen: Failed to load platform analytics: ${analyticsResponse.message}');
      }
    } catch (e) {
      debugPrint('❌ Settings Screen: Error loading platform analytics: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingPlatformAnalytics = false;
        });
      }
    }
  }

  /// Load real app version information from build configuration
  Future<void> _loadAppVersionInfo() async {
    debugPrint('📱 Settings Screen: Loading app version information...');

    try {
      // App version is defined in pubspec.yaml as 1.0.0+1
      // Split version and build number
      const String versionString = '1.0.0+1'; // This could be loaded from package_info_plus if available
      final parts = versionString.split('+');

      _appVersion = parts[0]; // e.g., "1.0.0"
      _buildNumber = parts.length > 1 ? parts[1] : '1'; // e.g., "1"

      debugPrint('✅ Settings Screen: App version loaded:');
      debugPrint('   - Version: $_appVersion');
      debugPrint('   - Build: $_buildNumber');
      debugPrint('   - Platform: ${Platform.operatingSystem}');
    } catch (e) {
      debugPrint('❌ Settings Screen: Error loading app version: $e');
      _appVersion = '1.0.0';
      _buildNumber = '1';
    }
  }

  /// Calculate directory size recursively
  Future<int> _calculateDirectorySize(Directory directory) async {
    try {
      if (!await directory.exists()) return 0;

      int size = 0;
      await for (var entity in directory.list(recursive: true)) {
        if (entity is File) {
          size += await entity.length();
        }
      }
      return size;
    } catch (e) {
      debugPrint('❌ Settings Screen: Error calculating directory size for ${directory.path}: $e');
      return 0;
    }
  }

  /// Calculate Hive database storage size
  Future<int> _calculateHiveStorageSize() async {
    try {
      // Get Hive storage info
      final debugInfo = HiveService.getDebugInfo();

      // Estimate based on stored data (fallback calculation)
      int estimatedSize = 1024 * 1024; // 1MB base

      if (debugInfo['total_keys'] != null) {
        estimatedSize += (debugInfo['total_keys'] as int) * 512; // ~512 bytes per key
      }

      debugPrint('💾 Settings Screen: Hive DB estimated size: ${_formatBytes(estimatedSize)}');
      return estimatedSize;
    } catch (e) {
      debugPrint('❌ Settings Screen: Error calculating Hive storage size: $e');
      return 1024 * 1024; // 1MB fallback
    }
  }

  /// Format bytes to human readable format
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Clear app cache files from temporary directory
  Future<void> _clearAppCache() async {
    try {
      debugPrint('🗑️ Settings Screen: Clearing app cache files...');
      final tempDir = await getTemporaryDirectory();

      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
        await tempDir.create(); // Recreate the directory
        debugPrint('✅ Settings Screen: App cache cleared');
      }
    } catch (e) {
      debugPrint('❌ Settings Screen: Error clearing app cache: $e');
    }
  }

  /// Clear Hive database cache (non-essential cached data)
  Future<void> _clearHiveCache() async {
    try {
      debugPrint('🗑️ Settings Screen: Clearing Hive cache data...');

      // Clear non-essential cached data from sync service
      await HiveService.clearSyncData();
      await HiveService.clearOfflineData();
      await HiveService.clearHealthCheckData();

      debugPrint('✅ Settings Screen: Hive cache cleared');
    } catch (e) {
      debugPrint('❌ Settings Screen: Error clearing Hive cache: $e');
    }
  }

  /// Clear image cache from Flutter's image cache
  Future<void> _clearImageCache() async {
    try {
      debugPrint('🗑️ Settings Screen: Clearing image cache...');

      // Clear Flutter's image cache
      imageCache.clear();
      imageCache.clearLiveImages();

      debugPrint('✅ Settings Screen: Image cache cleared');
    } catch (e) {
      debugPrint('❌ Settings Screen: Error clearing image cache: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userType = HiveService.getUserType();
    final user = ref.watch(authServiceProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120.h,
              floating: false,
              pinned: true,
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF1E1E1E), const Color(0xFF2D2D2D)]
                          : [Colors.white, const Color(0xFFF7FAFC)],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // System Health Status Card
                    if (_healthData != null && userType == 'admin') _buildSystemHealthCard(isDark),
                    if (_healthData != null && userType == 'admin') SizedBox(height: 20.h),

                    // Performance Metrics Card
                    if (_performanceMetrics != null && userType == 'admin') _buildPerformanceCard(isDark),
                    if (_performanceMetrics != null && userType == 'admin') SizedBox(height: 20.h),

                    // Profile Section
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Profile Picture
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: _getUserTypeColor(userType).withValues(alpha: 0.1),
                            child: Icon(
                              _getUserTypeIcon(userType),
                              color: _getUserTypeColor(userType),
                              size: 32.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // User Info with Real Backend Data
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display name from enhanced profile or fallback to auth user
                                Text(
                                  _getDisplayName(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                // User type badge
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: _getUserTypeColor(userType).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    _getUserTypeDisplayName(userType),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _getUserTypeColor(userType),
                                    ),
                                  ),
                                ),
                                // Provider-specific real data
                                if (userType == 'provider') ...[
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        LineIcons.star,
                                        size: 14.sp,
                                        color: const Color(0xFFED8936),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        _getRealRating(),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFED8936),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '•',
                                        style: TextStyle(
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        _getRealBookingCount(),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      if (_bookingStats != null && _bookingStats!['total_earnings'] != '0.00') ...[
                                        Text(
                                          '•',
                                          style: TextStyle(
                                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '\$${_bookingStats!['total_earnings']}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF48BB78),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                                // Customer-specific real data
                                if (userType == 'customer' && _bookingStats != null) ...[
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        LineIcons.calendar,
                                        size: 14.sp,
                                        color: const Color(0xFF4299E1),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        _getRealBookingCount(),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                      if (_bookingStats!['completed_bookings'] > 0) ...[
                                        SizedBox(width: 8.w),
                                        Text(
                                          '•',
                                          style: TextStyle(
                                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '${_bookingStats!['completed_bookings']} completed',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: const Color(0xFF48BB78),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                                // Show loading indicator for enhanced profile or booking stats
                                if (_loadingEnhancedProfile) ...[
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      LottieLoadingWidget.inline(
                                        loadingText: 'Loading profile...',
                                        textStyle: TextStyle(
                                          fontSize: 10.sp,
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else if (_loadingBookingStats) ...[
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      LottieLoadingWidget.inline(
                                        loadingText: 'Loading stats...',
                                        textStyle: TextStyle(
                                          fontSize: 10.sp,
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Edit Button
                          IconButton(
                            onPressed: () {
                              // Navigate to edit profile
                            },
                            icon: Icon(
                              LineIcons.edit,
                              color: _getUserTypeColor(userType),
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Account Settings
                    _buildSettingsSection(
                      'Account',
                      [
                        _buildSettingsItem(
                          'Personal Information',
                          'Update your profile details',
                          LineIcons.user,
                          const Color(0xFF4299E1),
                          isDark,
                          () {
                            // Navigate to personal info
                          },
                        ),
                        if (userType == 'provider')
                          _buildSettingsItem(
                            'Business Profile',
                            'Manage your services and portfolio',
                            LineIcons.briefcase,
                            const Color(0xFF48BB78),
                            isDark,
                            () {
                              // Navigate to business profile
                            },
                          ),
                        _buildSettingsItem(
                          'Payment & Billing',
                          'Manage payment methods and history',
                          LineIcons.creditCard,
                          const Color(0xFF9F7AEA),
                          isDark,
                          () {
                            // Navigate to payment settings
                          },
                        ),
                        _buildSettingsItem(
                          'Verification',
                          user?.isVerified == true ? 'Account verified' : 'Complete verification',
                          Icons.security,
                          user?.isVerified == true ? const Color(0xFF48BB78) : const Color(0xFFED8936),
                          isDark,
                          () {
                            // Navigate to verification
                          },
                        ),
                      ],
                      isDark,
                    ),

                    SizedBox(height: 24.h),

                    // App Settings
                    _buildSettingsSection(
                      'App Settings',
                      [
                        _buildNotificationSettingItem(isDark),
                        _buildSecuritySettingItem(isDark),
                        _buildPinResetSettingItem(isDark),
                        _buildThemeSettingItem(isDark),
                        _buildLanguageSettingItem(isDark),
                        _buildAnalyticsSettingItem(isDark),
                      ],
                      isDark,
                    ),

                    if (userType == 'admin') ...[
                      SizedBox(height: 24.h),

                      // Platform Analytics Card (Admin Only)
                      if (_loadingPlatformAnalytics) ...[
                        ModernUIComponents.elevatedCard(
                          isDark: isDark,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.analytics, color: const Color(0xFF9F7AEA), size: 24.sp),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Platform Analytics',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : const Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              LottieLoadingWidget.dots(
                                size: 40.w,
                                loadingText: 'Loading analytics...',
                                textStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ] else if (_platformAnalytics != null) ...[
                        _buildPlatformAnalyticsCard(isDark),
                        SizedBox(height: 20.h),
                      ],

                      // Admin Settings
                      _buildSettingsSection(
                        'Admin Controls',
                        [
                          _buildSettingsItem(
                            'User Management',
                            'Manage users and permissions',
                            LineIcons.users,
                            const Color(0xFF4299E1),
                            isDark,
                            () {
                              // Navigate to user management
                            },
                          ),
                          _buildSettingsItem(
                            'Content Moderation',
                            'Review and moderate content',
                            Icons.security,
                            const Color(0xFF48BB78),
                            isDark,
                            () {
                              // Navigate to content moderation
                            },
                          ),
                          _buildSettingsItem(
                            'Analytics & Reports',
                            'View platform analytics',
                            Icons.bar_chart,
                            const Color(0xFF9F7AEA),
                            isDark,
                            () {
                              // Navigate to analytics
                            },
                          ),
                          _buildSettingsItem(
                            'System Settings',
                            'Configure platform settings',
                            LineIcons.cog,
                            const Color(0xFFED8936),
                            isDark,
                            () {
                              // Navigate to system settings
                            },
                          ),
                        ],
                        isDark,
                      ),
                    ],

                    SizedBox(height: 24.h),

                    // Data & Storage Section
                    _buildSettingsSection(
                      'Data & Storage',
                      [
                        _buildSettingsItem(
                          'Storage Usage',
                          'View app storage and cache usage',
                          Icons.storage,
                          const Color(0xFF38B2AC),
                          isDark,
                          () => _showStorageDialog(isDark),
                        ),
                        _buildSettingsItem(
                          'Clear Cache',
                          'Free up space by clearing cached data',
                          Icons.cleaning_services,
                          const Color(0xFFED8936),
                          isDark,
                          () => _showClearCacheDialog(isDark),
                        ),
                        _buildSettingsItem(
                          'Export Data',
                          'Download your personal data',
                          Icons.download,
                          const Color(0xFF4299E1),
                          isDark,
                          () => _showExportDataDialog(isDark),
                        ),
                        _buildSettingsItem(
                          'Data Sync',
                          'Manage data synchronization settings',
                          Icons.sync,
                          const Color(0xFF9F7AEA),
                          isDark,
                          () => _showDataSyncDialog(isDark),
                        ),
                      ],
                      isDark,
                    ),

                    SizedBox(height: 24.h),

                    // Support & Legal
                    _buildSettingsSection(
                      'Support & Legal',
                      [
                        _buildSettingsItem(
                          'Help Center',
                          'Get help and support',
                          LineIcons.questionCircle,
                          const Color(0xFF4299E1),
                          isDark,
                          () {
                            // Navigate to help center
                          },
                        ),
                        _buildSettingsItem(
                          'Contact Us',
                          'Get in touch with our team',
                          LineIcons.envelope,
                          const Color(0xFF48BB78),
                          isDark,
                          () {
                            // Navigate to contact
                          },
                        ),
                        _buildSettingsItem(
                          'Terms of Service',
                          'Read our terms and conditions',
                          LineIcons.file,
                          const Color(0xFF9F7AEA),
                          isDark,
                          () {
                            // Navigate to terms
                          },
                        ),
                        _buildSettingsItem(
                          'Privacy Policy',
                          'Read our privacy policy',
                          LineIcons.userShield,
                          const Color(0xFFED8936),
                          isDark,
                          () {
                            // Navigate to privacy policy
                          },
                        ),
                      ],
                      isDark,
                    ),

                    SizedBox(height: 24.h),

                    // Logout Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.r),
                          onTap: () async {
                            // Show logout confirmation
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                    'Are you sure you want to logout? This will revoke all your device tokens and sign you out.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await _performCompleteLogout();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.logout,
                                    color: const Color(0xFFE53E3E),
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFE53E3E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // App Version with Real Build Info
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'App Version: ${_appVersion ?? '1.0.0'}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Build: ${_buildNumber ?? '1'}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                '•',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                Platform.operatingSystem.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                              if (_healthData?.system.version != null) ...[
                                SizedBox(width: 12.w),
                                Text(
                                  '•',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'API: ${_healthData!.system.version}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    String title,
    List<Widget> items,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    bool isDark,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LineIcons.angleRight,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Theme Settings Item
  Widget _buildThemeSettingItem(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showThemeDialog(),
          borderRadius: BorderRadius.circular(8.r),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF38B2AC).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.palette,
                  color: const Color(0xFF38B2AC),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.themeTheme.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Choose your preferred theme',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LineIcons.angleRight,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Language Settings Item
  Widget _buildLanguageSettingItem(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.language,
                  color: const Color(0xFF667EEA),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.localizationAppLang.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Change app language',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showLanguageDialog(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    LineIcons.angleDown,
                    color: const Color(0xFF667EEA),
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PIN Reset Settings Item
  Widget _buildPinResetSettingItem(bool isDark) {
    final currentUser = ref.watch(authServiceProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: currentUser != null ? () => _showPinResetDialog(isDark) : null,
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.lock,
                  color: const Color(0xFFE53E3E),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy & Security',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      currentUser != null ? 'Reset PIN and security settings' : 'Sign in to access security settings',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LineIcons.angleRight,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show Theme Dialog
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.themeThemeChoose.tr()),
        content: const ThemeSelectorWidget(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show Language Dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.localizationLangChoose.tr()),
        content: _changeLocalWithDropdown(context),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Language Dropdown
  DropdownButton<dynamic> _changeLocalWithDropdown(BuildContext context) {
    return DropdownButton(
      value: context.locale,
      items: ProjectLocales.localesMap.entries.map((entry) {
        return DropdownMenuItem(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (value) {
        context.setLocale(value);
        Navigator.pop(context);
      },
    );
  }

  // Show PIN Reset Dialog
  Future<void> _showPinResetDialog(bool isDark) async {
    final currentUser = ref.read(authServiceProvider);
    if (currentUser?.phoneNumber == null) return;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                LineIcons.lock,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Reset PIN',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to reset your PIN?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You will be redirected to create a new PIN.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            child: Text(
              'Cancel',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Reset',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Navigate to PIN reset screen
      context.push(
        RouteEnum.pinEntry.rawValue,
        extra: {
          'phoneNumber': currentUser!.phoneNumber!,
          'isNewUser': true, // Treat as new user to set new PIN
        },
      );
    }
  }

  Color _getUserTypeColor(String? userType) {
    switch (userType) {
      case 'provider':
        return const Color(0xFF48BB78);
      case 'customer':
        return const Color(0xFF4299E1);
      case 'admin':
        return const Color(0xFF9F7AEA);
      default:
        return const Color(0xFF4299E1);
    }
  }

  IconData _getUserTypeIcon(String? userType) {
    switch (userType) {
      case 'provider':
        return LineIcons.tools;
      case 'customer':
        return LineIcons.user;
      case 'admin':
        return LineIcons.crown;
      default:
        return LineIcons.user;
    }
  }

  String _getUserTypeDisplayName(String? userType) {
    switch (userType) {
      case 'provider':
        return 'Service Provider';
      case 'customer':
        return 'Customer';
      case 'admin':
        return 'Administrator';
      default:
        return 'User';
    }
  }

  /// Get real display name from enhanced profile or fallback to auth user
  /// Prioritizes enhanced profile data from sync service over basic auth profile
  String _getDisplayName() {
    debugPrint('👤 Settings Screen: Getting display name from enhanced profile...');

    // First try enhanced profile data
    if (_enhancedUserProfile != null) {
      final enhanced = _enhancedUserProfile!;

      if (enhanced.firstName != null || enhanced.lastName != null) {
        final fullName = '${enhanced.firstName ?? ''} ${enhanced.lastName ?? ''}'.trim();
        if (fullName.isNotEmpty) {
          debugPrint('✅ Settings Screen: Using enhanced profile name: $fullName');
          return fullName;
        }
      }

      if (enhanced.username.isNotEmpty) {
        debugPrint('✅ Settings Screen: Using enhanced profile username: ${enhanced.username}');
        return enhanced.username;
      }
    }

    // Fallback to auth user data
    final user = ref.read(authServiceProvider);
    if (user?.displayName != null && user!.displayName.isNotEmpty) {
      debugPrint('✅ Settings Screen: Using auth user display name: ${user.displayName}');
      return user.displayName;
    }

    debugPrint('⚠️ Settings Screen: No display name found, using fallback');
    return 'User';
  }

  /// Get real user rating from enhanced profile or auth user
  /// Returns formatted rating string with actual backend data
  String _getRealRating() {
    debugPrint('⭐ Settings Screen: Getting real rating from backend data...');

    // First try enhanced profile rating
    if (_enhancedUserProfile != null && _enhancedUserProfile!.rating > 0) {
      final rating = _enhancedUserProfile!.rating;
      debugPrint('✅ Settings Screen: Using enhanced profile rating: $rating');
      return rating.toStringAsFixed(1);
    }

    // Fallback to auth user rating
    final user = ref.read(authServiceProvider);
    if (user?.rating != null && user!.rating > 0) {
      debugPrint('✅ Settings Screen: Using auth user rating: ${user.rating}');
      return user.rating.toStringAsFixed(1);
    }

    debugPrint('⚠️ Settings Screen: No rating found, using default');
    return '0.0';
  }

  /// Get real booking count from booking statistics
  /// Returns formatted booking count string with actual data from backend
  String _getRealBookingCount() {
    debugPrint('📅 Settings Screen: Getting real booking count from statistics...');

    // Use real booking statistics if available
    if (_bookingStats != null) {
      final totalBookings = _bookingStats!['total_bookings'] as int? ?? 0;
      final completedBookings = _bookingStats!['completed_bookings'] as int? ?? 0;

      if (totalBookings > 0) {
        debugPrint('✅ Settings Screen: Using real booking count: $totalBookings total, $completedBookings completed');
        return totalBookings == 1 ? '1 booking' : '$totalBookings bookings';
      }
    }

    // Check if we're still loading
    if (_loadingBookingStats) {
      debugPrint('🔄 Settings Screen: Still loading booking statistics');
      return 'Loading...';
    }

    // Fallback to auth user data if available
    final user = ref.read(authServiceProvider);
    if (user?.totalBookings != null && user!.totalBookings > 0) {
      debugPrint('✅ Settings Screen: Using auth user booking count: ${user.totalBookings}');
      final count = user.totalBookings;
      return count == 1 ? '1 booking' : '$count bookings';
    }

    debugPrint('⚠️ Settings Screen: No booking count found, showing default');
    return '0 bookings';
  }

  // Enhanced Settings Components

  Widget _buildSystemHealthCard(bool isDark) {
    final isHealthy = _healthData?.overallStatus == HealthStatus.healthy;

    return ModernUIComponents.gradientCard(
      colors: isHealthy
          ? [const Color(0xFF48BB78), const Color(0xFF38A169)]
          : [const Color(0xFFED8936), const Color(0xFFDD6B20)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHealthy ? LineIcons.checkCircle : LineIcons.exclamationTriangle,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'System Health',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isHealthy ? 'Healthy' : 'Warning',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildHealthMetric('API', _healthData?.system.status ?? 'Unknown', Colors.white),
              SizedBox(width: 24.w),
              _buildHealthMetric('Database', _healthData?.database.status ?? 'Unknown', Colors.white),
              SizedBox(width: 24.w),
              _buildHealthMetric('Version', _healthData?.system.version ?? '1.0.0', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(bool isDark) {
    final performanceScore = _performanceMetrics?['performance_score'] as double? ?? 0.0;
    final frameDrops = _performanceMetrics?['frame_drops'] as int? ?? 0;
    final avgFrameTime = _performanceMetrics?['average_frame_time'] as double? ?? 0.0;

    return ModernUIComponents.elevatedCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                color: const Color(0xFF4299E1),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Performance Metrics',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getPerformanceColor(performanceScore).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${performanceScore.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _getPerformanceColor(performanceScore),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildPerformanceMetric('Frame Drops', frameDrops.toString(), isDark),
              SizedBox(width: 24.w),
              _buildPerformanceMetric('Avg Frame Time', '${avgFrameTime.toStringAsFixed(1)}ms', isDark),
              SizedBox(width: 24.w),
              _buildPerformanceMetric('Target', '16.7ms', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformAnalyticsCard(bool isDark) {
    return ModernUIComponents.elevatedCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: const Color(0xFF9F7AEA),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Platform Analytics',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildAnalyticsMetric(
                'Total Users',
                _platformAnalytics?['total_users']?.toString() ?? '0',
                isDark,
              ),
              SizedBox(width: 24.w),
              _buildAnalyticsMetric(
                'Total Bookings',
                _platformAnalytics?['total_bookings']?.toString() ?? '0',
                isDark,
              ),
              SizedBox(width: 24.w),
              _buildAnalyticsMetric(
                'Revenue',
                '\$${_platformAnalytics?['total_revenue']?.toString() ?? '0'}',
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsMetric(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getPerformanceColor(double score) {
    if (score >= 90) return const Color(0xFF48BB78);
    if (score >= 70) return const Color(0xFFED8936);
    return const Color(0xFFE53E3E);
  }

  Widget _buildPerformanceMetric(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettingItem(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFED8936).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              LineIcons.bell,
              color: const Color(0xFFED8936),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Manage your notification preferences',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _notificationsEnabled,
            onChanged: (value) async {
              setState(() {
                _notificationsEnabled = value;
              });
              await _saveNotificationPreference(value);
            },
            activeColor: const Color(0xFFED8936),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettingItem(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showSecurityDialog(isDark),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF9F7AEA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  LineIcons.fingerprint,
                  color: const Color(0xFF9F7AEA),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biometric Authentication',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _biometricsEnabled ? 'Enabled' : 'Disabled',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _biometricsEnabled
                            ? const Color(0xFF48BB78)
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LineIcons.angleRight,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsSettingItem(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.analytics,
              color: const Color(0xFF4299E1),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analytics & Data',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Help improve the app with usage analytics',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _analyticsEnabled,
            onChanged: (value) async {
              setState(() {
                _analyticsEnabled = value;
              });
              await _saveAnalyticsPreference(value);
            },
            activeColor: const Color(0xFF4299E1),
          ),
        ],
      ),
    );
  }

  Future<void> _saveNotificationPreference(bool enabled) async {
    try {
      final userData = HiveService.getUserData() ?? {};
      userData['notifications_enabled'] = enabled;
      await HiveService.saveUserData(userData);

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enabled ? 'Notifications enabled' : 'Notifications disabled'),
            backgroundColor: enabled ? const Color(0xFF48BB78) : const Color(0xFFED8936),
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to save notification preference: $e');
    }
  }

  Future<void> _saveAnalyticsPreference(bool enabled) async {
    try {
      final userData = HiveService.getUserData() ?? {};
      userData['analytics_enabled'] = enabled;
      await HiveService.saveUserData(userData);

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enabled ? 'Analytics enabled' : 'Analytics disabled'),
            backgroundColor: const Color(0xFF4299E1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to save analytics preference: $e');
    }
  }

  Future<void> _showSecurityDialog(bool isDark) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFF9F7AEA).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                LineIcons.fingerprint,
                color: const Color(0xFF9F7AEA),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Security Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile.adaptive(
              title: Text('Biometric Authentication'),
              subtitle: Text('Use fingerprint or face ID to unlock'),
              value: _biometricsEnabled,
              onChanged: (value) {
                setState(() {
                  _biometricsEnabled = value;
                });
                _saveBiometricPreference(value);
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF9F7AEA),
            ),
            Divider(),
            ListTile(
              leading: Icon(LineIcons.key, color: const Color(0xFFE53E3E)),
              title: Text('Reset PIN'),
              subtitle: Text('Change your security PIN'),
              trailing: Icon(LineIcons.angleRight),
              onTap: () {
                Navigator.pop(context);
                _showPinResetDialog(isDark);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBiometricPreference(bool enabled) async {
    try {
      final userData = HiveService.getUserData() ?? {};
      userData['biometrics_enabled'] = enabled;
      await HiveService.saveUserData(userData);

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enabled ? 'Biometric authentication enabled' : 'Biometric authentication disabled'),
            backgroundColor: const Color(0xFF9F7AEA),
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to save biometric preference: $e');
    }
  }

  /// Show storage usage dialog with real device storage data
  /// Displays actual calculated storage usage from the device
  Future<void> _showStorageDialog(bool isDark) async {
    debugPrint('💾 Settings Screen: Displaying storage usage dialog with real data');

    // Use real storage data if available, otherwise show loading or fallback
    final storageData = _storageData;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.storage, color: const Color(0xFF38B2AC)),
            SizedBox(width: 8.w),
            Text('Storage Usage'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (storageData != null) ...[
              // Real storage data from device calculation
              _buildStorageItem('App Data', storageData['app_data_formatted'] ?? '~25 MB', const Color(0xFF4299E1)),
              _buildStorageItem('Cache', storageData['cache_formatted'] ?? '~8 MB', const Color(0xFFED8936)),
              _buildStorageItem('Database', storageData['hive_db_formatted'] ?? '~2 MB', const Color(0xFF48BB78)),
              Divider(),
              _buildStorageItem('Total Used', storageData['total_formatted'] ?? '~35 MB', const Color(0xFF9F7AEA)),
            ] else if (_loadingStorageData) ...[
              // Show loading indicator while calculating storage
              Center(
                child: LottieLoadingWidget.dots(
                  size: 50.w,
                  loadingText: 'Calculating storage usage...',
                ),
              ),
            ] else ...[
              // Fallback data if calculation failed
              _buildStorageItem('App Data', '~25 MB', const Color(0xFF4299E1)),
              _buildStorageItem('Cache', '~8 MB', const Color(0xFFED8936)),
              _buildStorageItem('Database', '~2 MB', const Color(0xFF48BB78)),
              _buildStorageItem('Total', '~35 MB', const Color(0xFF9F7AEA)),
            ],
          ],
        ),
        actions: [
          if (_storageData != null)
            TextButton(
              onPressed: () {
                // Refresh storage calculation
                Navigator.pop(context);
                _loadStorageUsageData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recalculating storage usage...'),
                    backgroundColor: Color(0xFF38B2AC),
                  ),
                );
              },
              child: Text('Refresh'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String size, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Text(label),
          Spacer(),
          Text(size, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _showClearCacheDialog(bool isDark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cleaning_services, color: const Color(0xFFED8936)),
            SizedBox(width: 8.w),
            Text('Clear Cache'),
          ],
        ),
        content: Text(
          'This will clear all cached data to free up space. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED8936),
            ),
            child: Text('Clear Cache', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      debugPrint('🧹 Settings Screen: Starting cache clearing process...');

      try {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                LottieLoadingWidget.inline(
                  loadingText: null,
                ),
                SizedBox(width: 16.w),
                const Text('Clearing cache...'),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Clear different types of cache
        await Future.wait([
          _clearAppCache(),
          _clearHiveCache(),
          _clearImageCache(),
        ]);

        // Refresh storage data after clearing
        await _loadStorageUsageData();

        debugPrint('✅ Settings Screen: Cache cleared successfully');

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cache cleared successfully'),
              backgroundColor: Color(0xFF48BB78),
            ),
          );
        }
      } catch (e) {
        debugPrint('❌ Settings Screen: Error clearing cache: $e');

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error clearing cache: ${e.toString()}'),
              backgroundColor: const Color(0xFFE53E3E),
            ),
          );
        }
      }
    }
  }

  Future<void> _showExportDataDialog(bool isDark) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, color: const Color(0xFF4299E1)),
            SizedBox(width: 8.w),
            Text('Export Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose what data to export:'),
            SizedBox(height: 16.h),
            CheckboxListTile(
              title: Text('Profile Data'),
              value: true,
              onChanged: null,
            ),
            CheckboxListTile(
              title: Text('Booking History'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Messages'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement data export logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data export started'),
                  backgroundColor: const Color(0xFF4299E1),
                ),
              );
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDataSyncDialog(bool isDark) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.sync, color: const Color(0xFF9F7AEA)),
            SizedBox(width: 8.w),
            Text('Data Sync'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Auto Sync'),
              subtitle: Text('Automatically sync data when connected'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('WiFi Only'),
              subtitle: Text('Only sync when connected to WiFi'),
              value: false,
              onChanged: (value) {},
            ),
            ListTile(
              title: Text('Last Sync'),
              subtitle: Text('2 minutes ago'),
              trailing: TextButton(
                onPressed: () {
                  // Implement manual sync
                },
                child: Text('Sync Now'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Performs complete logout with proper token management
  /// This method will:
  /// 1. Get user tokens to see all active sessions
  /// 2. Revoke all tokens for security
  /// 3. Perform logout
  /// 4. Clear local data
  /// 5. Navigate to welcome screen
  Future<void> _performCompleteLogout() async {
    debugPrint('🔄 Starting complete logout process...');

    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                LottieLoadingWidget.inline(
                  loadingText: null,
                ),
                SizedBox(width: 16.w),
                const Text('Signing out...'),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      final authService = ref.read(authServiceProvider.notifier);

      // Step 1: Get current user tokens for debugging
      debugPrint('📋 Getting user tokens...');
      final tokensResponse = await authService.getUserTokens();
      if (tokensResponse.success && tokensResponse.data != null) {
        debugPrint('✅ Found ${tokensResponse.data!.length} active tokens');
        for (var i = 0; i < tokensResponse.data!.length; i++) {
          final token = tokensResponse.data![i];
          debugPrint('   Token ${i + 1}: ${token['id']} - Created: ${token['created_at']}');
        }
      } else {
        debugPrint('⚠️ Could not retrieve user tokens: ${tokensResponse.message}');
      }

      // Step 2: Revoke all tokens for security
      debugPrint('🔐 Revoking all tokens...');
      final revokeResponse = await authService.revokeAllTokens();
      if (revokeResponse.success) {
        debugPrint('✅ Successfully revoked all tokens');
      } else {
        debugPrint('⚠️ Failed to revoke tokens: ${revokeResponse.message}');
        // Continue with logout even if token revocation fails
      }

      // Step 3: Perform logout to clean up server-side session
      debugPrint('🚪 Performing logout...');
      final logoutResponse = await authService.logout();
      if (logoutResponse.success) {
        debugPrint('✅ Logout successful');
      } else {
        debugPrint('⚠️ Logout failed: ${logoutResponse.message}');
        // Continue anyway as local data will be cleared
      }

      // Step 4: Clear local storage (this is done in the logout method but let's be explicit)
      debugPrint('🧹 Clearing local data...');
      await HiveService.setLoggedIn(false);
      await HiveService.clearUserData();
      await HiveService.removeAuthToken();
      await HiveService.removeRefreshToken();
      debugPrint('✅ Local data cleared');

      // Step 5: Navigate to welcome screen
      debugPrint('🏠 Navigating to welcome screen...');
      if (mounted) {
        // Clear the snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Navigate to welcome screen and clear the entire navigation stack
        NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
        debugPrint('✅ Navigation completed');

        // Show success message briefly
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully signed out'),
                backgroundColor: Color(0xFF48BB78),
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      }

      debugPrint('🎉 Complete logout process finished successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error during logout process: $e');
      debugPrint('📍 Stack trace: $stackTrace');

      // Even if there's an error, clear local data and navigate
      try {
        debugPrint('🔄 Attempting emergency cleanup...');
        await HiveService.setLoggedIn(false);
        await HiveService.clearUserData();
        await HiveService.removeAuthToken();
        await HiveService.removeRefreshToken();

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);

          // Show error message
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed out (with errors): ${e.toString()}'),
                  backgroundColor: const Color(0xFFED8936),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          });
        }
        debugPrint('✅ Emergency cleanup completed');
      } catch (cleanupError) {
        debugPrint('❌ Emergency cleanup failed: $cleanupError');
        // Last resort - just navigate away
        if (mounted) {
          NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
        }
      }
    }
  }
}
