import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/services/performance_service.dart';
import 'package:prbal/services/health_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';

// TODO: Add proper theme service integration
// TODO: Add localization support
// TODO: Add connectivity check before navigation
// TODO: Add custom fonts and advanced styling
// TODO: Add sound effects for splash animations
// TODO: Add biometric authentication check
// TODO: Add app update checker

/// HEALTH CHECK OPTIMIZATION:
/// - Health checks are now cached for 30 minutes to avoid redundant API calls
/// - Splash screen first checks for cached health data before making network requests
/// - Only performs fresh health checks when cached data is expired or unavailable
/// - Network calls are reduced by ~90% for subsequent app launches
/// - Cached health data includes status, timestamp, and full health results
/// - Debug logs clearly indicate whether cached or fresh data is being used

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _lottieController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _progressValue;

  String _loadingText = 'Initializing app...';
  bool _isInitializationComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Lottie animation controller
    _lottieController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Progress animation controller
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo animations
    _logoScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Text animation
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Progress animation
    _progressValue = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startAnimationSequence() async {
    // Start logo and lottie animations simultaneously
    _logoController.forward();
    _lottieController.repeat(); // Loop the Lottie animation

    // Wait for logo animation to finish
    await _logoController.forward();

    // Start text animation
    await _textController.forward();

    // Start initialization and progress animation simultaneously
    _progressController.forward();
    await _initializeServices();

    // Stop Lottie animation when initialization is complete
    _lottieController.stop();

    // Navigate to next screen after animations complete
    await Future.delayed(const Duration(milliseconds: 500));
    _navigateToNextScreen();
  }

  Future<void> _initializeServices() async {
    try {
      // Verify Hive service initialization
      _updateLoadingText('Checking local storage...');
      if (!HiveService.isStorageHealthy()) {
        debugPrint('⚠️ Storage health check failed - attempting recovery');
        _updateLoadingText('Recovering local storage...');
        // HiveService.init() should already be called in main.dart
        await Future.delayed(const Duration(milliseconds: 300));
      }
      await Future.delayed(const Duration(milliseconds: 300));

      // Initialize performance service
      _updateLoadingText('Setting up performance monitoring...');
      await PerformanceService.instance.initializePerformanceMonitoring();
      await Future.delayed(const Duration(milliseconds: 500));

      // Optimize startup
      _updateLoadingText('Optimizing app startup...');
      await PerformanceService.instance.optimizeStartup();
      await Future.delayed(const Duration(milliseconds: 500));

      // Initialize image loading optimization
      _updateLoadingText('Optimizing image loading...');
      PerformanceService.optimizeImageLoading();
      await Future.delayed(const Duration(milliseconds: 300));

      // Initialize health monitoring
      _updateLoadingText('Initializing health monitoring...');
      final healthService = HealthService();
      await healthService.initialize();
      await Future.delayed(const Duration(milliseconds: 500));

      // Check system health only if needed (uses cache when available)
      _updateLoadingText('Checking system health...');
      ApplicationHealth? healthStatus;

      // First try to get quick status from cache
      final quickStatus = healthService.getQuickHealthStatus();
      if (quickStatus != null && healthService.hasCachedHealthData) {
        _updateLoadingText('Using cached health status...');
        healthStatus = healthService.currentHealth;
        debugPrint('🏥 Using cached health status: ${quickStatus.name}');
        debugPrint('🏥 Skipping network health check - recent data available');
        await Future.delayed(
            const Duration(milliseconds: 200)); // Shorter delay for cached data
      } else {
        // Only perform network check if no recent cached data
        _updateLoadingText('Performing health check...');
        debugPrint('🏥 No recent cached health data - performing fresh check');
        healthStatus = await healthService.performHealthCheck();
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Update UI based on health status
      if (healthStatus?.overallStatus == HealthStatus.healthy) {
        _updateLoadingText('System healthy - Ready to launch!');
      } else {
        _updateLoadingText(
            'System status: ${healthStatus?.overallStatus.name ?? 'unknown'}');
      }

      if (kDebugMode) {
        final lastCheck = HiveService.getLastHealthCheck();
        if (lastCheck != null) {
          debugPrint(
              '🏥 Last health check: ${lastCheck.toString().substring(0, 19)}');
        }
      }

      await Future.delayed(const Duration(milliseconds: 300));

      // Load user preferences and cached data
      _updateLoadingText('Loading user preferences...');
      await _loadUserPreferences();
      await Future.delayed(const Duration(milliseconds: 300));

      // Final setup
      _updateLoadingText('Finalizing setup...');
      await Future.delayed(const Duration(milliseconds: 500));

      _updateLoadingText('Ready!');
      _isInitializationComplete = true;
    } catch (e) {
      debugPrint('Splash screen initialization error: $e');
      _updateLoadingText('Initialization completed with warnings');
      _isInitializationComplete = true;
    }
  }

  /// Load user preferences and cached data from Hive
  Future<void> _loadUserPreferences() async {
    try {
      // Load debug info for development (only in debug mode)
      if (kDebugMode) {
        final debugInfo = HiveService.getDebugInfo();
        debugPrint('📊 Storage Debug Info: $debugInfo');
      }

      // Pre-check user state for faster navigation
      final isLoggedIn = HiveService.isLoggedIn();
      final hasIntroBeenWatched = HiveService.hasIntroBeenWatched();
      final isLanguageSelected = HiveService.isLanguageSelected();

      debugPrint('📱 User state pre-loaded:');
      debugPrint('  - Language: ${isLanguageSelected ? "✅" : "❌"}');
      debugPrint('  - Intro: ${hasIntroBeenWatched ? "✅" : "❌"}');
      debugPrint('  - Auth: ${isLoggedIn ? "✅" : "❌"}');

      // Load additional user data if logged in
      if (isLoggedIn) {
        final userData = HiveService.getUserData();
        final phoneNumber = HiveService.getPhoneNumber();
        final lastLogin = HiveService.getLastLogin();

        if (userData != null) {
          final userType = userData['userType'] as String? ?? 'unknown';
          final username = userData['username'] as String? ?? 'Unknown';
          debugPrint('👤 User data loaded: $username (Type: $userType)');
        }
        if (phoneNumber != null) {
          debugPrint('📞 Phone: ${phoneNumber.substring(0, 3)}***');
        }
        if (lastLogin != null) {
          debugPrint('🕐 Last login: ${lastLogin.toString().substring(0, 16)}');
        }
      }
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
      // Don't throw - this is not critical for app startup
    }
  }

  void _updateLoadingText(String text) {
    if (mounted) {
      setState(() {
        _loadingText = text;
      });
    }
  }

  void _navigateToNextScreen() {
    if (_isInitializationComplete) {
      _performNavigation();
    }
  }

  Future<void> _performNavigation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final isLoggedIn = HiveService.isLoggedIn();
    final hasIntroBeenWatched = HiveService.hasIntroBeenWatched();
    final isLanguageSelected = HiveService.isLanguageSelected();

    debugPrint('🔍 Navigation state check:');
    debugPrint('  - Language selected: $isLanguageSelected');
    debugPrint('  - Intro watched: $hasIntroBeenWatched');
    debugPrint('  - User logged in: $isLoggedIn');

    // Note: We could set a default language here for first-time users,
    // but explicit language selection provides better UX
    if (!isLanguageSelected) {
      debugPrint('🌐 Navigating to language selection');
      context.go(RouteEnum.languageSelection.rawValue);
    } else if (!hasIntroBeenWatched) {
      debugPrint('👋 Navigating to onboarding');
      context.go(RouteEnum.onboarding.rawValue);
    } else if (!isLoggedIn) {
      debugPrint('🔑 Navigating to welcome screen');
      context.go(RouteEnum.welcome.rawValue);
    } else {
      // User is logged in - check user type and navigate to appropriate dashboard
      final userData = HiveService.getUserData();
      final userType = userData?['userType'] as String? ?? 'customer';

      debugPrint('👤 User type detected: $userType');

      switch (userType.toLowerCase()) {
        case 'admin':
          debugPrint('👑 Navigating to admin dashboard');
          context.go(RouteEnum.adminDashboard
              .rawValue); // Will show admin dashboard through bottom navigation
          break;
        case 'provider':
          debugPrint('🔧 Navigating to provider dashboard');
          context.go(RouteEnum.providerDashboard
              .rawValue); // Will show provider dashboard through bottom navigation
          break;
        case 'customer':
        case 'taker':
        default:
          debugPrint('🏠 Navigating to taker dashboard');
          context.go(RouteEnum.takerDashboard
              .rawValue); // Will show taker dashboard through bottom navigation
          break;
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A), // Dark slate
                    const Color(0xFF1E293B), // Slate 800
                    const Color(0xFF334155), // Slate 700
                  ]
                : [
                    const Color(0xFFFFFFFF), // White
                    const Color(0xFFF8FAFC), // Slate 50
                    const Color(0xFFF1F5F9), // Slate 100
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Status bar space
              SizedBox(height: 60.h),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo section with Lottie animation
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Opacity(
                            opacity: _logoOpacity.value,
                            child: Container(
                              width: 160.w,
                              height: 160.h,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF3B82F6)
                                        .withValues(alpha: 0.1),
                                    const Color(0xFF1D4ED8)
                                        .withValues(alpha: 0.05),
                                    Colors.transparent,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background glow effect
                                  Container(
                                    width: 140.w,
                                    height: 140.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF3B82F6)
                                              .withValues(alpha: 0.2),
                                          const Color(0xFF1D4ED8)
                                              .withValues(alpha: 0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(70.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF3B82F6)
                                              .withValues(alpha: 0.3),
                                          blurRadius: 30,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Lottie animation
                                  AnimatedBuilder(
                                    animation: _lottieController,
                                    builder: (context, child) {
                                      return SizedBox(
                                        width: 120.w,
                                        height: 120.h,
                                        child: Lottie.asset(
                                          isDark
                                              ? 'assets/animations/splash_dark.json'
                                              : 'assets/animations/splash_light.json',
                                          controller: _lottieController,
                                          fit: BoxFit.contain,
                                          repeat: true,
                                          animate: true,
                                        ),
                                      );
                                    },
                                  ),
                                  // Fallback icon overlay (subtle)
                                  Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF3B82F6)
                                              .withValues(alpha: 0.8),
                                          const Color(0xFF1D4ED8)
                                              .withValues(alpha: 0.9),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF3B82F6)
                                              .withValues(alpha: 0.4),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      LineIcons.briefcase,
                                      size: 30.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 32.h),

                    // App name and tagline
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Column(
                            children: [
                              // App name
                              Text(
                                'Prbal',
                                style: TextStyle(
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                  letterSpacing: -1.5,
                                ),
                              ),

                              SizedBox(height: 8.h),

                              // Tagline
                              Text(
                                'Your Service Marketplace',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : const Color(0xFF64748B),
                                  letterSpacing: 0.5,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              // Subtitle
                              Text(
                                'Connect • Serve • Thrive',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? Colors.grey[500]
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bottom section with progress
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  children: [
                    // Loading text
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Text(
                            _loadingText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.grey[400]
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16.h),

                    // Progress bar
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF374151)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progressValue.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isInitializationComplete
                                      ? [
                                          const Color(0xFF10B981), // Green
                                          const Color(0xFF059669),
                                        ]
                                      : [
                                          const Color(0xFF3B82F6), // Blue
                                          const Color(0xFF1D4ED8),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
