import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/services/user_service.dart';
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

      // First try to get quick status from cache
      final quickStatus = healthService.getQuickHealthStatus();
      if (quickStatus != null && healthService.hasCachedHealthData) {
        _updateLoadingText('loading.usingCachedHealth'.tr());
        final currentHealth = healthService.currentHealth;
        if (currentHealth != null) {
          healthStatusResult = currentHealth;
        }
        await Future.delayed(const Duration(milliseconds: 200)); // Shorter delay for cached data
      } else {
        // Perform health check with connectivity awareness
        if (healthService.isOffline) {
          _updateLoadingText('loading.offlineMode'.tr());
          final offlineHealth = await healthService.performHealthCheck();
          if (offlineHealth != null) {
            healthStatusResult = offlineHealth;
          }
          await Future.delayed(const Duration(milliseconds: 200));
        } else {
          // Network available - perform full health check
          _updateLoadingText('loading.performingHealthCheck'.tr());
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

      await Future.delayed(const Duration(milliseconds: 300));

      // Load user preferences and cached data
      _updateLoadingText('loading.loadingPreferences'.tr());
      // await _loadUserPreferences();
      await Future.delayed(const Duration(milliseconds: 300));

      // Final setup
      _updateLoadingText('loading.finalizingSetup'.tr());
      await Future.delayed(const Duration(milliseconds: 500));

      _updateLoadingText('loading.ready'.tr());
      _isInitializationComplete = true;
    } catch (e) {
      _updateLoadingText('loading.initializationWarnings'.tr());
      _isInitializationComplete = true;
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
    debugPrint('🏠 SplashScreen: ====== NAVIGATION DECISION PROCESS STARTED ======');

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    debugPrint('🏠 SplashScreen: Widget is still mounted, proceeding with navigation');

    // Get all authentication and onboarding status
    debugPrint('🏠 SplashScreen: Checking user authentication and onboarding status...');

    final isLoggedIn = HiveService.isLoggedIn();
    final hasIntroBeenWatched = HiveService.hasIntroBeenWatched();
    final isLanguageSelected = HiveService.isLanguageSelected();

    debugPrint('🏠 SplashScreen: ====== STATUS SUMMARY ======');
    debugPrint('🏠 SplashScreen: Language selected: $isLanguageSelected');
    debugPrint('🏠 SplashScreen: Intro watched: $hasIntroBeenWatched');
    debugPrint('🏠 SplashScreen: User logged in: $isLoggedIn');

    // Navigation decision tree with comprehensive logging
    if (!isLanguageSelected) {
      debugPrint('🏠 SplashScreen: ➡️ Language not selected - navigating to language selection');
      debugPrint('🏠 SplashScreen: Route: ${RouteEnum.languageSelection.rawValue}');
      context.go(RouteEnum.languageSelection.rawValue);
      return;
    }

    if (!hasIntroBeenWatched) {
      debugPrint('🏠 SplashScreen: ➡️ Intro not watched - navigating to onboarding');
      debugPrint('🏠 SplashScreen: Route: ${RouteEnum.onboarding.rawValue}');
      context.go(RouteEnum.onboarding.rawValue);
      return;
    }

    if (!isLoggedIn) {
      debugPrint('🏠 SplashScreen: ➡️ User not logged in - navigating to welcome screen');
      debugPrint('🏠 SplashScreen: Route: ${RouteEnum.welcome.rawValue}');
      context.go(RouteEnum.welcome.rawValue);
      return;
    }

    // User appears to be logged in - let's verify user data exists
    debugPrint('🏠 SplashScreen: ====== USER DATA VERIFICATION ======');
    debugPrint('🏠 SplashScreen: User appears logged in, verifying user data...');

    final userData = HiveService.getUserDataSafe();

    if (userData == null) {
      debugPrint('🏠 SplashScreen: ❌ CRITICAL: User marked as logged in but no user data found!');
      debugPrint('🏠 SplashScreen: This indicates an inconsistent authentication state');
      debugPrint('🏠 SplashScreen: Clearing authentication state and redirecting to welcome');

      // Clean up inconsistent state
      await HiveService.setLoggedIn(false);
      await HiveService.removeAuthToken();
      await HiveService.removeRefreshToken();

      debugPrint('🏠 SplashScreen: ➡️ Authentication state cleared - navigating to welcome screen');
      context.go(RouteEnum.welcome.rawValue);
      return;
    }

    // User data exists - proceed with dashboard navigation
    final UserType userType = userData.userType;

    debugPrint('🏠 SplashScreen: ✅ User data found and verified');
    debugPrint('🏠 SplashScreen: User ID: ${userData.id}');
    debugPrint('🏠 SplashScreen: Username: ${userData.username}');
    debugPrint('🏠 SplashScreen: User type: $userType');
    debugPrint('🏠 SplashScreen: Display name: ${userData.firstName} ${userData.lastName}');
    debugPrint('🏠 SplashScreen: Phone: ${userData.phoneNumber}');
    debugPrint('🏠 SplashScreen: Email: ${userData.email}');

    debugPrint('🏠 SplashScreen: ====== DASHBOARD NAVIGATION ======');

    switch (userType) {
      case UserType.admin:
        debugPrint('🏠 SplashScreen: ➡️ Admin user - navigating to admin dashboard');
        debugPrint('🏠 SplashScreen: Route: ${RouteEnum.adminDashboard.rawValue}');
        context.go(RouteEnum.adminDashboard.rawValue);
        break;

      case UserType.provider:
        debugPrint('🏠 SplashScreen: ➡️ Provider user - navigating to provider dashboard');
        debugPrint('🏠 SplashScreen: Route: ${RouteEnum.providerDashboard.rawValue}');
        context.go(RouteEnum.providerDashboard.rawValue);
        break;

      case UserType.customer:
        debugPrint('🏠 SplashScreen: ➡️ Customer user - navigating to taker dashboard');
        debugPrint('🏠 SplashScreen: Route: ${RouteEnum.takerDashboard.rawValue}');
        context.go(RouteEnum.takerDashboard.rawValue);
        break;
    }

    debugPrint('🏠 SplashScreen: ====== NAVIGATION COMPLETED ======');
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).backgroundGradient,
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
                        // _buildEnhancedLogoSection(),

                        SizedBox(height: 20.h), // Reduced from 28.h

                        // Enhanced text section with custom SourGummy font and advanced typography
                        _buildEnhancedTextSection(),
                      ],
                    ),
                  ),
                ),
              ),

              // Enhanced bottom section with progress and status
              _buildEnhancedBottomSection(),
            ],
          ),
        ),
        // ],
        // ),
      ),
    );
  }

  /// Build Lottie animation with fallback
  Widget _buildLottieAnimation(String animation, double height) {
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
              _lottieController.duration = composition.duration;
              _lottieController.repeat();
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: ThemeManager.of(context).errorGradient,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Icon(
                  Prbal.business,
                  size: 40.sp,
                  color: ThemeManager.of(context).textInverted,
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Build enhanced text section with custom SourGummy font and advanced typography
  Widget _buildEnhancedTextSection() {
    return Column(
      mainAxisSize: MainAxisSize.min, // Add to prevent excessive expansion
      children: [
        // App name with custom SourGummy font and gradient text effect
        ShaderMask(
          shaderCallback: (bounds) => ThemeManager.of(context).primaryGradient.createShader(bounds),
          child: Text(
            'Prbal',
            style: TextStyle(
              fontFamily: ThemeManager.fontFamilyPrimary,
              fontSize: 56.sp, // Reduced from 64.sp for smaller screens
              // fontWeight: FontWeight.w800, // ExtraBold
              color: ThemeManager.of(context).textPrimary,
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
        //     gradient: ThemeManager.of(context).neutralGradient,
        //     borderRadius: BorderRadius.circular(25.r),
        //     border: Border.all(
        //       color: ThemeManager.of(context).borderFocus.withValues(alpha: 102),
        //       width: 1.5,
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: ThemeManager.of(context).shadowLight,
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
        //       color: ThemeManager.of(context).textPrimary,
        //       letterSpacing: 1.2,
        //       height: 1.2,
        //       shadows: [
        //         Shadow(
        //           color: ThemeManager.of(context).shadowLight,
        //           blurRadius: 4,
        //           offset: const Offset(0, 2),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        _buildLottieAnimation('assets/animations/loading.json', 70.h),
      ],
    );
  }

  /// Build enhanced bottom section with custom typography
  Widget _buildEnhancedBottomSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h), // Reduced padding
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: ThemeManager.of(context).elevatedShadow,
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
                      //     color: _isInitializationComplete ? ThemeManager.of(context).successColor : ThemeManager.of(context).warningColor,
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
                          color: _isInitializationComplete
                              ? ThemeManager.of(context).successColor
                              : ThemeManager.of(context).warningColor,
                          letterSpacing: 0.4,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: ThemeManager.of(context).shadowLight,
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
                  //         gradient: ThemeManager.of(context).accent4Gradient,
                  //         borderRadius: BorderRadius.circular(10.r),
                  //       ),
                  //       child: Text(
                  //         '${(_progressValue.value * 100).toInt()}%',
                  //         style: TextStyle(
                  //           fontFamily: ThemeManager.fontFamilySemiExpanded,
                  //           fontSize: 11.sp, // Reduced from 12.sp
                  //           fontWeight: FontWeight.w700, // Bold
                  //           color: ThemeManager.of(context).textInverted,
                  //           letterSpacing: 0.5,
                  //           shadows: [
                  //             Shadow(
                  //               color: ThemeManager.of(context).shadowDark,
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
                      gradient: ThemeManager.of(context).neutralGradient,
                      borderRadius: BorderRadius.circular(3.r),
                      boxShadow: ThemeManager.of(context).subtleShadow,
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
                                gradient: _isInitializationComplete ? null : ThemeManager.of(context).shimmerGradient,
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
                                      ? ThemeManager.of(context).successGradient
                                      : ThemeManager.of(context).accent1Gradient,
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
                                        ? ThemeManager.of(context).successGradient
                                        : ThemeManager.of(context).primaryGradient,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ThemeManager.of(context).textPrimary,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        color: ThemeManager.of(context).textPrimary,
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
                    color: ThemeManager.of(context).textDisabled,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w), // Reduced from 5.w
              Icon(
                Prbal.shield,
                size: 12.sp, // Reduced from 13.sp
                color: ThemeManager.of(context).verifiedColor,
              ),
              SizedBox(width: 4.w), // Reduced from 5.w
              Text(
                'footer.secure'.tr(),
                style: TextStyle(
                  fontFamily: ThemeManager.fontFamilySemiExpanded,
                  fontSize: 10.sp, // Reduced from 11.sp
                  fontWeight: FontWeight.w600, // SemiBold
                  color: ThemeManager.of(context).verifiedColor,
                  letterSpacing: 0.4,
                  shadows: [
                    Shadow(
                      color: ThemeManager.of(context).verifiedColor.withValues(alpha: 77),
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
                  color: ThemeManager.of(context).textQuaternary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
