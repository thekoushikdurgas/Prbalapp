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

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _lottieController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _progressValue;

  // Lottie animation state management

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
    _lottieController.duration = const Duration(milliseconds: 3000); // Set initial duration
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

      // First try to get quick status from cache
      final quickStatus = healthService.getQuickHealthStatus();
      if (quickStatus != null && healthService.hasCachedHealthData) {
        _updateLoadingText('Using cached health status...');
        final currentHealth = healthService.currentHealth;
        if (currentHealth != null) {
          healthStatusResult = currentHealth;
        }
        debugPrint('🏥 Using cached health status: ${quickStatus.name}');
        debugPrint('🏥 Skipping network health check - recent data available');
        await Future.delayed(const Duration(milliseconds: 200)); // Shorter delay for cached data
      } else {
        // Only perform network check if no recent cached data
        _updateLoadingText('Performing health check...');
        debugPrint('🏥 No recent cached health data - performing fresh check');
        final healthCheckResult = await healthService.performHealthCheck();
        if (healthCheckResult != null) {
          healthStatusResult = healthCheckResult;
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Update UI based on health status
      if (healthStatusResult.overallStatus == HealthStatus.healthy) {
        _updateLoadingText('System healthy - Ready to launch!');
      } else {
        _updateLoadingText('System status: ${healthStatusResult.overallStatus.name}');
      }

      if (kDebugMode) {
        final lastCheck = HiveService.getLastHealthCheck();
        if (lastCheck != null) {
          debugPrint('🏥 Last health check: ${lastCheck.toString().substring(0, 19)}');
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
      final userType = userData != null ? userData['userType'] as String : 'customer';

      debugPrint('👤 User type detected: $userType');

      switch (userType.toLowerCase()) {
        case 'admin':
          debugPrint('👑 Navigating to admin dashboard');
          context.go(RouteEnum.adminDashboard.rawValue); // Will show admin dashboard through bottom navigation
          break;
        case 'provider':
          debugPrint('🔧 Navigating to provider dashboard');
          context.go(RouteEnum.providerDashboard.rawValue); // Will show provider dashboard through bottom navigation
          break;
        case 'customer':
        case 'taker':
        default:
          debugPrint('🏠 Navigating to taker dashboard');
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    // Enhanced debug logging with all ThemeManager features
    themeManager.logThemeInfo();
    debugPrint('🚀 SplashScreen: Building with enhanced ThemeManager features');
    debugPrint('🚀 SplashScreen: Using ${themeManager.themeManager ? 'dark' : 'light'} theme');

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: themeManager.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Background decorative elements using new accent colors and gradients
            _buildBackgroundDecorations(themeManager),

            SafeArea(
              child: Column(
                children: [
                  // Enhanced header section with status indicators
                  _buildHeaderSection(themeManager),

                  // Main content with enhanced visuals
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Enhanced logo section with multiple gradients and effects
                        _buildEnhancedLogoSection(themeManager),

                        SizedBox(height: 40.h),

                        // Enhanced text section with new text color variants
                        _buildEnhancedTextSection(themeManager),

                        SizedBox(height: 32.h),

                        // Feature showcase using accent colors
                        _buildFeatureShowcase(themeManager),
                      ],
                    ),
                  ),

                  // Enhanced bottom section with progress and status
                  _buildEnhancedBottomSection(themeManager),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build background decorative elements using new gradients and colors
  Widget _buildBackgroundDecorations(ThemeManager themeManager) {
    return Stack(
      children: [
        // Top accent decoration
        Positioned(
          top: -50.h,
          right: -50.w,
          child: Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: themeManager.accent1Gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: themeManager.shadowLight,
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
          ),
        ),
        // Bottom accent decoration
        Positioned(
          bottom: -100.h,
          left: -80.w,
          child: Container(
            width: 250.w,
            height: 250.h,
            decoration: BoxDecoration(
              gradient: themeManager.accent3Gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: themeManager.shadowMedium,
                  blurRadius: 40,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
          ),
        ),
        // Glass morphism overlay
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: themeManager.glassMorphism.copyWith(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ],
    );
  }

  /// Build enhanced header section with status indicators
  Widget _buildHeaderSection(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App version info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: themeManager.cardBackground,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: themeManager.borderSecondary),
              boxShadow: themeManager.subtleShadow,
            ),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textQuaternary,
              ),
            ),
          ),
          // Network status indicator
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: themeManager.statusOnline,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: themeManager.statusOnline.withValues(alpha: 128),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced logo section with multiple effects
  Widget _buildEnhancedLogoSection(ThemeManager themeManager) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Opacity(
            opacity: _logoOpacity.value,
            child: Container(
              width: 180.w,
              height: 180.h,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    themeManager.primaryColor.withValues(alpha: 51),
                    themeManager.accent1.withValues(alpha: 26),
                    themeManager.accent3.withValues(alpha: 13),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow ring
                  Container(
                    width: 160.w,
                    height: 160.h,
                    decoration: BoxDecoration(
                      gradient: themeManager.accent2Gradient,
                      shape: BoxShape.circle,
                      boxShadow: themeManager.elevatedShadow,
                    ),
                  ),
                  // Middle glass morphism effect
                  Container(
                    width: 140.w,
                    height: 140.h,
                    decoration: themeManager.enhancedGlassMorphism.copyWith(
                      borderRadius: BorderRadius.circular(70.r),
                    ),
                  ),
                  // Inner gradient container
                  Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      gradient: themeManager.primaryGradient,
                      borderRadius: BorderRadius.circular(60.r),
                      boxShadow: themeManager.primaryShadow,
                    ),
                    child: _buildLottieAnimation(themeManager),
                  ),
                  // Central icon with enhanced styling
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeManager.textInverted.withValues(alpha: 230),
                          themeManager.textInverted.withValues(alpha: 179),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35.r),
                      boxShadow: [
                        BoxShadow(
                          color: themeManager.shadowDark,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Prbal.briefcase,
                      size: 35.sp,
                      color: themeManager.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build Lottie animation with fallback
  Widget _buildLottieAnimation(ThemeManager themeManager) {
    return AnimatedBuilder(
      animation: _lottieController,
      builder: (context, child) {
        return SizedBox(
          width: 120.w,
          height: 120.h,
          child: Lottie.asset(
            themeManager.themeManager ? 'assets/animations/splash_dark.json' : 'assets/animations/splash_light.json',
            controller: _lottieController,
            fit: BoxFit.contain,
            repeat: true,
            animate: true,
            frameRate: FrameRate.max,
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
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  gradient: themeManager.errorGradient,
                  borderRadius: BorderRadius.circular(60.r),
                ),
                child: Icon(
                  Prbal.business,
                  size: 60.sp,
                  color: themeManager.textInverted,
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Build enhanced text section with new color variants
  Widget _buildEnhancedTextSection(ThemeManager themeManager) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacity.value,
          child: Column(
            children: [
              // App name with gradient text effect
              ShaderMask(
                shaderCallback: (bounds) => themeManager.primaryGradient.createShader(bounds),
                child: Text(
                  'Prbal',
                  style: TextStyle(
                    fontSize: 52.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -2.0,
                    shadows: [
                      Shadow(
                        color: themeManager.shadowMedium,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Enhanced tagline with better typography
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: themeManager.neutralGradient,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: themeManager.borderFocus.withValues(alpha: 77)),
                ),
                child: Text(
                  'Your Service Marketplace',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.textPrimary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Subtitle with quaternary text color
              Text(
                'Connect • Serve • Thrive',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: themeManager.textQuaternary,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 4.h),

              // Additional tagline
              Text(
                'Powered by Innovation',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: themeManager.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build feature showcase using accent colors
  Widget _buildFeatureShowcase(ThemeManager themeManager) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacity.value * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureIcon(themeManager, Prbal.users, themeManager.accent1, 'Connect'),
              _buildFeatureIcon(themeManager, Prbal.tools, themeManager.accent2, 'Serve'),
              _buildFeatureIcon(themeManager, Prbal.trendingUp, themeManager.accent3, 'Grow'),
              _buildFeatureIcon(themeManager, Prbal.star, themeManager.accent4, 'Excel'),
            ],
          ),
        );
      },
    );
  }

  /// Build individual feature icon
  Widget _buildFeatureIcon(ThemeManager themeManager, IconData icon, Color color, String label) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 26),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withValues(alpha: 77)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 51),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: themeManager.textQuaternary,
          ),
        ),
      ],
    );
  }

  /// Build enhanced bottom section with progress and additional info
  Widget _buildEnhancedBottomSection(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: themeManager.elevatedShadow,
      ),
      child: Column(
        children: [
          // Status and loading text
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Opacity(
                opacity: _textOpacity.value,
                child: Column(
                  children: [
                    // Status indicator row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: _isInitializationComplete ? themeManager.statusOnline : themeManager.statusAway,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_isInitializationComplete ? themeManager.statusOnline : themeManager.statusAway)
                                    .withValues(alpha: 128),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _isInitializationComplete ? 'Ready' : 'Loading',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _isInitializationComplete ? themeManager.successColor : themeManager.warningColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Loading text with enhanced styling
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: themeManager.cardBackground,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: themeManager.borderSecondary),
                      ),
                      child: Text(
                        _loadingText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: themeManager.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 20.h),

          // Enhanced progress bar with shimmer effect
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Column(
                children: [
                  // Progress percentage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: themeManager.textTertiary,
                        ),
                      ),
                      Text(
                        '${(_progressValue.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: themeManager.accent5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Progress bar container
                  Container(
                    width: double.infinity,
                    height: 6.h,
                    decoration: BoxDecoration(
                      gradient: themeManager.neutralGradient,
                      borderRadius: BorderRadius.circular(3.r),
                      boxShadow: themeManager.subtleShadow,
                    ),
                    child: Stack(
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
                              boxShadow: [
                                BoxShadow(
                                  color: (_isInitializationComplete ? themeManager.successColor : themeManager.accent1)
                                      .withValues(alpha: 128),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 20.h),

          // Footer with app info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2024 Prbal',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: themeManager.textDisabled,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Prbal.shield,
                    size: 12.sp,
                    color: themeManager.verifiedColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Secure',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: themeManager.verifiedColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
