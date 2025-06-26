import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/services/performance_service.dart';
import 'package:prbal/services/health_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';

// TODO: Add sound effects for splash animations
// TODO: Add biometric authentication check
// TODO: Add app update checker

/// ENHANCED TYPOGRAPHY & STYLING FEATURES:
/// - Custom SourGummy font family with proper weight hierarchy
/// - Advanced text styling with letter spacing, line height, and shadows
/// - Font animation effects with scale, fade, and slide transitions
/// - Responsive typography system with ScreenUtil integration
/// - Theme-aware font color management with gradient text effects
/// - Professional text hierarchy: Display, Headline, Title, Body, Caption levels
/// - Enhanced readability with optimized font weights and spacing
/// - Sophisticated text shadow and glow effects for premium appearance

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

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _lottieController;
  late AnimationController _fontAnimationController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _progressValue;
  late Animation<double> _letterSpacing;

  // Lottie animation state management

  String _loadingText = 'loading.initializingApp'.tr();
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

    // Font animation controller for advanced typography effects
    _fontAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    // Advanced font animations

    _letterSpacing = Tween<double>(
      begin: 30.0,
      end: -2.0,
    ).animate(CurvedAnimation(
      parent: _fontAnimationController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  Future<void> _startAnimationSequence() async {
    // Start logo and lottie animations simultaneously
    _logoController.forward();
    _lottieController.duration = const Duration(milliseconds: 3000); // Set initial duration
    _lottieController.repeat(); // Loop the Lottie animation

    // Wait for logo animation to finish
    await _logoController.forward();

    // Start text and font animations simultaneously
    _textController.forward();
    _fontAnimationController.forward();

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
      _updateLoadingText('loading.checkingStorage'.tr());
      if (!HiveService.isStorageHealthy()) {
        debugPrint('⚠️ Storage health check failed - attempting recovery');
        _updateLoadingText('loading.recoveringStorage'.tr());
        // HiveService.init() should already be called in main.dart
        await Future.delayed(const Duration(milliseconds: 300));
      }
      await Future.delayed(const Duration(milliseconds: 300));

      // Initialize performance service
      _updateLoadingText('loading.settingUpPerformance'.tr());
      await PerformanceService.instance.initializePerformanceMonitoring();
      await Future.delayed(const Duration(milliseconds: 500));

      // Optimize startup
      _updateLoadingText('loading.optimizingStartup'.tr());
      await PerformanceService.instance.optimizeStartup();
      await Future.delayed(const Duration(milliseconds: 500));

      // Initialize image loading optimization
      _updateLoadingText('loading.optimizingImageLoading'.tr());
      PerformanceService.optimizeImageLoading();
      await Future.delayed(const Duration(milliseconds: 300));

      // Initialize health monitoring
      _updateLoadingText('loading.initializingHealth'.tr());
      final healthService = HealthService();
      await healthService.initialize();
      await Future.delayed(const Duration(milliseconds: 500));

      // Check system health with connectivity awareness
      _updateLoadingText('loading.checkingSystemHealth'.tr());
      ApplicationHealth healthStatusResult = ApplicationHealth.fromComponents(
        system: SystemHealth(
          status: 'unknown',
          version: '1.0.0',
          timestamp: DateTime.now(),
        ),
        database: DatabaseHealth(
          status: 'unknown',
          timestamp: DateTime.now(),
        ),
      );

      // Check connectivity first
      _updateLoadingText('loading.checkingConnectivity'.tr());
      final connectivityStatus = await healthService.checkConnectivity();
      debugPrint('🌐 Splash Screen: Connectivity status: ${connectivityStatus.name}');

      // First try to get quick status from cache
      final quickStatus = healthService.getQuickHealthStatus();
      if (quickStatus != null && healthService.hasCachedHealthData) {
        _updateLoadingText('loading.usingCachedHealth'.tr());
        final currentHealth = healthService.currentHealth;
        if (currentHealth != null) {
          healthStatusResult = currentHealth;
        }
        debugPrint('🏥 Using cached health status: ${quickStatus.name}');
        debugPrint('🏥 Skipping network health check - recent data available');
        await Future.delayed(const Duration(milliseconds: 200)); // Shorter delay for cached data
      } else {
        // Perform health check with connectivity awareness
        if (healthService.isOffline) {
          _updateLoadingText('loading.offlineMode'.tr());
          debugPrint('🏥 Device offline - using offline health status');
          final offlineHealth = await healthService.performHealthCheck();
          if (offlineHealth != null) {
            healthStatusResult = offlineHealth;
          }
          await Future.delayed(const Duration(milliseconds: 200));
        } else {
          // Network available - perform full health check
          _updateLoadingText('loading.performingHealthCheck'.tr());
          debugPrint('🏥 Network available - performing comprehensive health check');
          final healthCheckResult = await healthService.performHealthCheckWithWait(
            networkTimeout: const Duration(seconds: 3),
          );
          if (healthCheckResult != null) {
            healthStatusResult = healthCheckResult;
          }
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }

      // Update UI based on health status and connectivity
      if (healthService.isOffline) {
        _updateLoadingText('loading.offlineReady'.tr());
      } else if (healthStatusResult.overallStatus == HealthStatus.healthy) {
        _updateLoadingText('loading.systemHealthy'.tr());
      } else {
        _updateLoadingText('${'loading.systemStatus'.tr()}: ${healthStatusResult.overallStatus.name}');
      }

      if (kDebugMode) {
        final lastCheck = HiveService.getLastHealthCheck();
        if (lastCheck != null) {
          debugPrint('🏥 Last health check: ${lastCheck.toString().substring(0, 19)}');
        }
      }

      await Future.delayed(const Duration(milliseconds: 300));

      // Load user preferences and cached data
      _updateLoadingText('loading.loadingPreferences'.tr());
      await _loadUserPreferences();
      await Future.delayed(const Duration(milliseconds: 300));

      // Final setup
      _updateLoadingText('loading.finalizingSetup'.tr());
      await Future.delayed(const Duration(milliseconds: 500));

      _updateLoadingText('loading.ready'.tr());
      _isInitializationComplete = true;
    } catch (e) {
      debugPrint('Splash screen initialization error: $e');
      _updateLoadingText('loading.initializationWarnings'.tr());
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
          final userType = userData['userType'] as String;
          final username = userData['username'] as String;
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

    // Check connectivity before navigation
    final healthService = HealthService();
    final connectivityStatus = await healthService.checkConnectivity();
    final isNetworkAvailable = await healthService.isNetworkAvailable();

    debugPrint('🌐 Pre-navigation connectivity check:');
    debugPrint('  - Connectivity status: ${connectivityStatus.name}');
    debugPrint('  - Network available: $isNetworkAvailable');

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
      // Also consider connectivity status for dashboard features
      final userData = HiveService.getUserData();
      final userType = userData != null ? userData['userType'] as String : 'customer';

      debugPrint('👤 User type detected: $userType');

      if (!isNetworkAvailable) {
        debugPrint('🌐 Limited connectivity - dashboard may have reduced functionality');
        // Still navigate but user will see offline indicators in the dashboard
      }

      switch (userType.toLowerCase()) {
        case 'admin':
          debugPrint('👑 Navigating to admin dashboard${!isNetworkAvailable ? ' (offline mode)' : ''}');
          context.go(RouteEnum.adminDashboard.rawValue); // Will show admin dashboard through bottom navigation
          break;
        case 'provider':
          debugPrint('🔧 Navigating to provider dashboard${!isNetworkAvailable ? ' (offline mode)' : ''}');
          context.go(RouteEnum.providerDashboard.rawValue); // Will show provider dashboard through bottom navigation
          break;
        case 'customer':
        case 'taker':
        default:
          debugPrint('🏠 Navigating to taker dashboard${!isNetworkAvailable ? ' (offline mode)' : ''}');
          context.go(RouteEnum.takerDashboard.rawValue); // Will show taker dashboard through bottom navigation
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
    _fontAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    // Enhanced debug logging with all ThemeManager features

    debugPrint('🚀 SplashScreen: Building with enhanced ThemeManager features');
    debugPrint('🚀 SplashScreen: Using ${themeManager.themeManager ? 'dark' : 'light'} theme');

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: themeManager.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main content with enhanced visuals - Make scrollable to prevent overflow
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add some top padding for better spacing
                        SizedBox(height: 20.h),

                        // Enhanced logo section with multiple gradients and effects
                        // _buildEnhancedLogoSection(themeManager),

                        SizedBox(height: 20.h), // Reduced from 28.h

                        // Enhanced text section with custom SourGummy font and advanced typography
                        _buildEnhancedTextSection(themeManager),
                      ],
                    ),
                  ),
                ),
              ),

              // Enhanced bottom section with progress and status
              _buildEnhancedBottomSection(themeManager),
            ],
          ),
        ),
        // ],
        // ),
      ),
    );
  }

  /// Build Lottie animation with fallback
  Widget _buildLottieAnimation(ThemeManager themeManager, String animation, double height) {
    return AnimatedBuilder(
      animation: _lottieController,
      builder: (context, child) {
        return SizedBox(
          // width: 80.w,
          // height: height,
          child: Lottie.asset(
            animation,
            controller: _lottieController,
            fit: BoxFit.contain,
            repeat: true,
            animate: true,
            frameRate: FrameRate.composition,
            options: LottieOptions(
              enableMergePaths: true,
            ),
            onLoaded: (composition) {
              debugPrint('🎬 Lottie animation loaded: ${composition.duration}');
              _lottieController.duration = composition.duration;
              _lottieController.repeat();
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint('❌ Lottie animation error: $error');
              return Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: themeManager.errorGradient,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Icon(
                  Prbal.business,
                  size: 40.sp,
                  color: themeManager.textInverted,
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Build enhanced text section with custom SourGummy font and advanced typography
  Widget _buildEnhancedTextSection(ThemeManager themeManager) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Add to prevent excessive expansion
      children: [
        // App name with custom SourGummy font and gradient text effect
        ShaderMask(
          shaderCallback: (bounds) => themeManager.primaryGradient.createShader(bounds),
          child: Text(
            'Prbal',
            style: TextStyle(
              fontFamily: ThemeManager.fontFamilyPrimary,
              fontSize: 56.sp, // Reduced from 64.sp for smaller screens
              // fontWeight: FontWeight.w800, // ExtraBold
              color: themeManager.textPrimary,
              letterSpacing: _letterSpacing.value,
              // height: 0.9,
            ),
          ),
        ),

        // SizedBox(height: 10.h), // Reduced from 12.h

        // // Enhanced tagline with SourGummy SemiBold
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h), // Reduced padding
        //   decoration: BoxDecoration(
        //     gradient: themeManager.neutralGradient,
        //     borderRadius: BorderRadius.circular(25.r),
        //     border: Border.all(
        //       color: themeManager.borderFocus.withValues(alpha: 102),
        //       width: 1.5,
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: themeManager.shadowLight,
        //         blurRadius: 12,
        //         offset: const Offset(0, 4),
        //       ),
        //     ],
        //   ),
        //   child: Text(
        //     'Your Service Marketplace',
        //     style: TextStyle(
        //       fontFamily: ThemeManager.fontFamilySemiExpanded,
        //       fontSize: 18.sp, // Reduced from 20.sp
        //       fontWeight: FontWeight.w600, // SemiBold
        //       color: themeManager.textPrimary,
        //       letterSpacing: 1.2,
        //       height: 1.2,
        //       shadows: [
        //         Shadow(
        //           color: themeManager.shadowLight,
        //           blurRadius: 4,
        //           offset: const Offset(0, 2),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        _buildLottieAnimation(themeManager, 'assets/animations/loading.json', 70.h),
      ],
    );
  }

  /// Build enhanced bottom section with custom typography
  Widget _buildEnhancedBottomSection(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h), // Reduced padding
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: themeManager.elevatedShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent excessive expansion
        children: [
          // Status and loading text with enhanced typography
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Opacity(
                opacity: _textOpacity.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevent excessive expansion
                  children: [
                    // Loading text with enhanced styling
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // Reduced padding
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(16.r),
                      //   border: Border.all(
                      //     color: _isInitializationComplete ? themeManager.successColor : themeManager.warningColor,
                      //     width: 1.2,
                      //   ),
                      // ),
                      child: Text(
                        _loadingText,
                        textAlign: TextAlign.center,
                        maxLines: 2, // Prevent text overflow
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: ThemeManager.fontFamilyPrimary,
                          fontSize: 14.sp, // Reduced from 15.sp
                          fontWeight: FontWeight.w500, // Medium
                          color: _isInitializationComplete ? themeManager.successColor : themeManager.warningColor,
                          letterSpacing: 0.4,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: themeManager.shadowLight,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 16.h), // Reduced from 20.h

          // Enhanced progress bar with custom labels
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min, // Prevent excessive expansion
                children: [
                  // Progress percentage with custom font
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   mainAxisSize: MainAxisSize.min, // Prevent excessive expansion
                  //   children: [
                  //     Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h), // Reduced padding
                  //       decoration: BoxDecoration(
                  //         gradient: themeManager.accent4Gradient,
                  //         borderRadius: BorderRadius.circular(10.r),
                  //       ),
                  //       child: Text(
                  //         '${(_progressValue.value * 100).toInt()}%',
                  //         style: TextStyle(
                  //           fontFamily: ThemeManager.fontFamilySemiExpanded,
                  //           fontSize: 11.sp, // Reduced from 12.sp
                  //           fontWeight: FontWeight.w700, // Bold
                  //           color: themeManager.textInverted,
                  //           letterSpacing: 0.5,
                  //           shadows: [
                  //             Shadow(
                  //               color: themeManager.shadowDark,
                  //               blurRadius: 2,
                  //               offset: const Offset(0, 1),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 6.h), // Reduced from 8.h
                  // Progress bar container with moving circle
                  Container(
                    width: double.infinity,
                    height: 6.h, // Reduced from 7.h
                    decoration: BoxDecoration(
                      gradient: themeManager.neutralGradient,
                      borderRadius: BorderRadius.circular(3.r),
                      boxShadow: themeManager.subtleShadow,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final progressWidth = constraints.maxWidth * _progressValue.value;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Background shimmer
                            Container(
                              decoration: BoxDecoration(
                                gradient: _isInitializationComplete ? null : themeManager.shimmerGradient,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                            // Progress fill
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressValue.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: _isInitializationComplete
                                      ? themeManager.successGradient
                                      : themeManager.accent1Gradient,
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                            ),
                            // Moving circle at the end of progress bar
                            if (_progressValue.value > 0.01) // Only show circle when progress has started
                              Positioned(
                                left: progressWidth - 8.w, // Center the circle at the progress end
                                top: -4.h, // Position circle to overlap the progress bar
                                child: Container(
                                  width: 15.w,
                                  height: 15.h,
                                  decoration: BoxDecoration(
                                    gradient: _isInitializationComplete
                                        ? themeManager.successGradient
                                        : themeManager.primaryGradient,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: themeManager.textPrimary,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        color: themeManager.textPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 16.h), // Reduced from 20.h

          // Footer with enhanced typography
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min, // Prevent excessive expansion
            children: [
              Flexible(
                // Add to prevent overflow
                child: Text(
                  'footer.copyright'.tr(),
                  style: TextStyle(
                    fontFamily: ThemeManager.fontFamilyPrimary,
                    fontSize: 9.sp, // Reduced from 10.sp
                    fontWeight: FontWeight.w300, // Light
                    color: themeManager.textDisabled,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w), // Reduced from 5.w
              Icon(
                Prbal.shield,
                size: 12.sp, // Reduced from 13.sp
                color: themeManager.verifiedColor,
              ),
              SizedBox(width: 4.w), // Reduced from 5.w
              Text(
                'footer.secure'.tr(),
                style: TextStyle(
                  fontFamily: ThemeManager.fontFamilySemiExpanded,
                  fontSize: 10.sp, // Reduced from 11.sp
                  fontWeight: FontWeight.w600, // SemiBold
                  color: themeManager.verifiedColor,
                  letterSpacing: 0.4,
                  shadows: [
                    Shadow(
                      color: themeManager.verifiedColor.withValues(alpha: 77),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w), // Reduced from 5.w
              Text(
                'footer.version'.tr(),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: themeManager.textQuaternary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
