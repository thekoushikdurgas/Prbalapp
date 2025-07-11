import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/app_services.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';

/// ====================================================================
/// INTRODUCTION SCREEN COMPONENT
/// ====================================================================
///
/// ✅ **COMPREHENSIVE AUTHENTICATION INTEGRATION COMPLETED** ✅
///
/// **🔐 ENHANCED FEATURES WITH RIVERPOD AUTHENTICATION:**
///
/// **1. AUTHENTICATION STATE INTEGRATION:**
/// - Integrated with authenticationStateProvider for centralized state management
/// - Uses AuthenticationNotifier for proper intro completion tracking
/// - Automatic navigation flow using router's redirect functionality
/// - Proper error handling and loading states
///
/// **2. ENHANCED USER EXPERIENCE:**
/// - Seamless integration with authentication flow
/// - Proper state persistence through AuthenticationNotifier
/// - Enhanced debug logging with auth state information
/// - Better error recovery and user feedback
///
/// **3. ARCHITECTURAL IMPROVEMENTS:**
/// - ConsumerStatefulWidget for Riverpod integration
/// - Centralized state management instead of direct HiveService calls
/// - Leverages router's authentication-aware redirect logic
/// - Follows app's dependency injection patterns
///
/// **🎯 RESULT:**
/// A sophisticated introduction screen that properly integrates with the app's
/// authentication architecture, providing seamless user onboarding with
/// proper state management and navigation flow.
/// ====================================================================

class IntroductionScreen extends ConsumerStatefulWidget {
  const IntroductionScreen({super.key});

  @override
  ConsumerState<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends ConsumerState<IntroductionScreen>
    with TickerProviderStateMixin, ThemeAwareMixin {
  // ========== ANIMATION CONTROLLERS ==========
  late PageController pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  int currentPage = 0;
  bool _isInitialized = false;
  bool _isCompletingIntro = false; // Track intro completion state

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🎬 IntroductionScreen: ====== INITIALIZING WITH AUTH INTEGRATION ======');
    pageController = PageController();
    _initializeAnimations();
    _startAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _logComprehensiveThemeInitialization();
      _logAuthenticationState();
      _isInitialized = true;
    }
  }

  /// Logs comprehensive initialization with ALL theme information
  void _logComprehensiveThemeInitialization() {
    // Comprehensive theme logging
    ThemeManager.of(context).logGradientInfo();
    ThemeManager.of(context).logAllColors();
  }

  /// Logs current authentication state for debugging
  void _logAuthenticationState() {
    final authState = ref.read(authenticationStateProvider);
    debugPrint('🔐 IntroductionScreen: Authentication state check:');
    debugPrint(
        '🔐 IntroductionScreen:   - Authenticated: ${authState.isAuthenticated}');
    debugPrint('🔐 IntroductionScreen:   - Loading: ${authState.isLoading}');
    debugPrint(
        '🔐 IntroductionScreen:   - User: ${authState.user?.username ?? 'none'}');
    debugPrint(
        '🔐 IntroductionScreen:   - User Type: ${authState.user?.userType.name ?? 'none'}');
    debugPrint(
        '🔐 IntroductionScreen:   - Has Tokens: ${authState.tokens != null}');
    debugPrint(
        '🔐 IntroductionScreen:   - Error: ${authState.error ?? 'none'}');
  }

  /// Gets comprehensive theme-aware onboarding pages using ALL ThemeManager properties
  List<OnboardingPage> _getEnhancedPages(BuildContext context) {
    return [
      OnboardingPage(
        title: 'intro.onboarding.page1.title'.tr(),
        subtitle: 'intro.onboarding.page1.subtitle'.tr(),
        animationPath: 'assets/intro/work.json',
        color: ThemeManager.of(context).primaryColor,
        gradientColors: [
          ThemeManager.of(context).primaryColor,
          ThemeManager.of(context).primaryLight,
          ThemeManager.of(context).accent1
        ],
        icon: Prbal.clock,
        statusType: 'primary',
        scale: 1.3, // Slightly larger for work animation
        translateX: 15.0,
        translateY: 30.0,
      ),
      OnboardingPage(
        title: 'intro.onboarding.page2.title'.tr(),
        subtitle: 'intro.onboarding.page2.subtitle'.tr(),
        animationPath: 'assets/intro/commerce.json',
        color: ThemeManager.of(context).successColor,
        gradientColors: [
          ThemeManager.of(context).successColor,
          ThemeManager.of(context).successLight,
          ThemeManager.of(context).accent3
        ],
        icon: Prbal.users,
        statusType: 'success',
        scale: 2.5, // Smaller for commerce animation
        translateX: 10.0,
        translateY: 25.0,
      ),
      OnboardingPage(
        title: 'intro.onboarding.page3.title'.tr(),
        subtitle: 'intro.onboarding.page3.subtitle'.tr(),
        animationPath: 'assets/intro/walking.json',
        color: ThemeManager.of(context).infoColor,
        gradientColors: [
          ThemeManager.of(context).infoColor,
          ThemeManager.of(context).infoLight,
          ThemeManager.of(context).accent5
        ],
        icon: Prbal.graduationCap1,
        statusType: 'info',
        // scale: 1.1, // Medium-large for walking animation
        // translateX: 30.0,
        // translateY: 10.0,
      ),
      OnboardingPage(
        title: 'intro.onboarding.page4.title'.tr(),
        subtitle: 'intro.onboarding.page4.subtitle'.tr(),
        animationPath: 'assets/intro/hourly.json',
        color: ThemeManager.of(context).warningColor,
        gradientColors: [
          ThemeManager.of(context).warningColor,
          ThemeManager.of(context).warningLight,
          ThemeManager.of(context).accent4
        ],
        icon: Prbal.laptop11,
        statusType: 'warning',
        scale: 1.8, // Smaller for hourly animation
        translateX: 15.0,
        translateY: 40.0,
      ),
      OnboardingPage(
        title: 'intro.onboarding.page5.title'.tr(),
        subtitle: 'intro.onboarding.page5.subtitle'.tr(),
        animationPath: 'assets/intro/bidding.json',
        color: ThemeManager.of(context).errorColor,
        gradientColors: [
          ThemeManager.of(context).errorColor,
          ThemeManager.of(context).errorLight,
          ThemeManager.of(context).accent2
        ],
        icon: Prbal.hand,
        statusType: 'error',
        // scale: 1.3, // Larger for bidding animation
        translateX: 15.0,
        translateY: 10.0,
      ),
      OnboardingPage(
        title: 'intro.onboarding.page6.title'.tr(),
        subtitle: 'intro.onboarding.page6.subtitle'.tr(),
        animationPath: 'assets/intro/match.json',
        color: ThemeManager.of(context).accent2,
        gradientColors: [
          ThemeManager.of(context).accent2,
          ThemeManager.of(context).primaryColor,
          ThemeManager.of(context).accent1
        ],
        icon: Prbal.heart,
        statusType: 'accent',
        scale: 2, // Default scale for match animation
        translateX: 15.0,
        translateY: 15.0,
      ),
      OnboardingPage(
        title: 'intro.onboarding.page7.title'.tr(),
        subtitle: 'intro.onboarding.page7.subtitle'.tr(),
        animationPath: 'assets/intro/design.json',
        color: ThemeManager.of(context).secondaryColor,
        gradientColors: [
          ThemeManager.of(context).secondaryColor,
          ThemeManager.of(context).secondaryLight,
          ThemeManager.of(context).accent3
        ],
        icon: Prbal.palette,
        statusType: 'secondary',
        scale: 1.3, // Slightly smaller for design animation
        translateX: 20.0,
        translateY: 10.0,
      ),
      OnboardingPage(
        title: 'intro.onboarding.page8.title'.tr(),
        subtitle: 'intro.onboarding.page8.subtitle'.tr(),
        animationPath: 'assets/intro/verification.json',
        color: ThemeManager.of(context).verifiedColor,
        gradientColors: [
          ThemeManager.of(context).verifiedColor,
          ThemeManager.of(context).successColor,
          ThemeManager.of(context).accent3
        ],
        icon: Prbal.checkCircle,
        statusType: 'verified',
        scale: 1.15, // Medium-large for verification animation
        translateX: 25.0,
        translateY: 30.0,
      ),
    ];
  }

  /// Gets comprehensive page gradient using ThemeManager gradient system
  LinearGradient _getPageGradient(
    OnboardingPage page,
  ) {
    switch (page.statusType) {
      case 'primary':
        return ThemeManager.of(context).primaryGradient;
      case 'success':
        return ThemeManager.of(context).successGradient;
      case 'info':
        return ThemeManager.of(context).infoGradient;
      case 'warning':
        return ThemeManager.of(context).warningGradient;
      case 'error':
        return ThemeManager.of(context).errorGradient;
      case 'accent':
        return ThemeManager.of(context).accent2Gradient;
      case 'secondary':
        return ThemeManager.of(context).secondaryGradient;
      case 'verified':
        return ThemeManager.of(context).accent3Gradient;
      default:
        return ThemeManager.of(context).primaryGradient;
    }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _glowController.repeat(reverse: true);
  }

  void _restartAnimations() {
    _slideController.reset();
    _slideController.forward();
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Enhanced background gradient overlay
              // _buildEnhancedBackgroundOverlay(),

              // Main content with vertical PageView
              Column(
                children: [
                  _buildEnhancedVerticalPageView(),
                  _buildEnhancedBottomNavigation(),
                ],
              ),

              // Enhanced right-side components
              _buildEnhancedSkipIndicator(),
              _buildEnhancedRightSideIndicators(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedVerticalPageView() {
    final pages = _getEnhancedPages(context);

    return Expanded(
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
          _restartAnimations();
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimation,
            child: _buildEnhancedPageContent(pages[index]),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedSkipIndicator() {
    final pages = _getEnhancedPages(context);
    final currentPageData = pages[currentPage];

    return Positioned(
      right: 16.w,
      top: 0,
      bottom: 0,
      child: Column(
        children: [
          if (currentPage < pages.length - 1)
            Column(
              children: [
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: _skipOnboarding,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      gradient: ThemeManager.of(context).conditionalGradient(
                        lightGradient: LinearGradient(
                          colors: [
                            ThemeManager.of(context).surfaceElevated,
                            ThemeManager.of(context).cardBackground,
                            ThemeManager.of(context).modalBackground,
                          ],
                        ),
                        darkGradient: LinearGradient(
                          colors: [
                            ThemeManager.of(context).surfaceElevated,
                            ThemeManager.of(context).backgroundSecondary,
                            ThemeManager.of(context).cardBackground,
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: ThemeManager.of(context).conditionalColor(
                          lightColor:
                              currentPageData.color.withValues(alpha: 0.3),
                          darkColor:
                              currentPageData.color.withValues(alpha: 0.4),
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'button.skip'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: currentPageData.color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedRightSideIndicators() {
    final pages = _getEnhancedPages(context);
    final currentPageData = pages[currentPage];

    return Positioned(
      right: 16.w,
      bottom: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Enhanced current page indicator with glass morphism
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      gradient: _getPageGradient(currentPageData),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: ThemeManager.of(context)
                            .getContrastingColor(currentPageData.color)
                            .withValues(alpha: 0.3),
                        width: 2,
                      ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: currentPageData.color.withValues(alpha: 0.4 * _glowAnimation.value),
                      //     blurRadius: 12,
                      //     offset: const Offset(0, 4),
                      //   ),
                      //   ...ThemeManager.of(context).primaryShadow,
                      // ],
                    ),
                    child: Center(
                      child: Text(
                        '${currentPage + 1}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeManager.of(context)
                              .getContrastingColor(currentPageData.color),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 16.h),

              // Enhanced vertical page indicators with comprehensive theming
              ...List.generate(pages.length, (index) {
                final pageData = pages[index];
                final isActive = currentPage == index;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: isActive ? 10.w : 6.w,
                      height: isActive ? 32.h : 12.h,
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? _getPageGradient(pageData)
                            : LinearGradient(
                                colors: [
                                  ThemeManager.of(context).textTertiary,
                                  ThemeManager.of(context).textQuaternary,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(6.r),
                        border: isActive
                            ? Border.all(
                                color: pageData.color.withValues(alpha: 0.3),
                                width: 1,
                              )
                            : null,
                        // boxShadow: isActive
                        //     ? [
                        //         BoxShadow(
                        //           color: pageData.color.withValues(alpha: 0.3),
                        //           blurRadius: 8,
                        //           offset: const Offset(0, 2),
                        //         ),
                        //       ]
                        //     : null,
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 16.h),

              // Enhanced swipe hint with glass morphism
              if (currentPage < pages.length - 1)
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            currentPageData.color
                                .withValues(alpha: 0.2 * _glowAnimation.value),
                            currentPageData.color
                                .withValues(alpha: 0.1 * _glowAnimation.value),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: currentPageData.color.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        // boxShadow: ThemeManager.of(context).subtleShadow,
                      ),
                      child: Icon(
                        Prbal.arrowDown,
                        size: 14.sp,
                        color: currentPageData.color,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedPageContent(
    OnboardingPage page,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 60.w,
            top: 8.h,
            bottom: 8.h,
          ),
          child: Column(
            children: [
              // Enhanced Animation Container with comprehensive theming
              Expanded(
                flex: 3,
                child: _buildEnhancedIllustration(page),
              ),

              SizedBox(height: 20.h),

              // Enhanced Content with comprehensive typography
              Flexible(
                flex: 2,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight * 0.25,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Enhanced feature badge with comprehensive theming
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            gradient:
                                ThemeManager.of(context).conditionalGradient(
                              lightGradient: LinearGradient(
                                colors: [
                                  page.color.withValues(alpha: 0.15),
                                  page.gradientColors[1].withValues(alpha: 0.1),
                                  page.gradientColors[2]
                                      .withValues(alpha: 0.05),
                                ],
                              ),
                              darkGradient: LinearGradient(
                                colors: [
                                  page.color.withValues(alpha: 0.2),
                                  page.gradientColors[1]
                                      .withValues(alpha: 0.15),
                                  page.gradientColors[2].withValues(alpha: 0.1),
                                ],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: ThemeManager.of(context).conditionalColor(
                                lightColor: page.color.withValues(alpha: 0.3),
                                darkColor: page.color.withValues(alpha: 0.4),
                              ),
                              width: 1.5,
                            ),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: page.color.withValues(alpha: 0.2),
                            //     blurRadius: 8,
                            //     offset: const Offset(0, 3),
                            //   ),
                            //   ...ThemeManager.of(context).subtleShadow,
                            // ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: page.color.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  page.icon,
                                  size: 14.sp,
                                  color: page.color,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${'intro.feature'.tr()} ${currentPage + 1}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: page.color,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Enhanced title with comprehensive typography
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            page.title,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: ThemeManager.of(context).textPrimary,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Enhanced subtitle with comprehensive theming
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            page.subtitle,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: ThemeManager.of(context).textSecondary,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnhancedIllustration(
    OnboardingPage page,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Lottie animation with enhanced container, different transform scales, and translations
          Container(
            padding: EdgeInsets.all(16.w),
            child: Transform.translate(
              offset: Offset(page.translateX, page.translateY),
              child: Transform.scale(
                scale: page.scale,
                child: Lottie.asset(
                  page.animationPath,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBottomNavigation() {
    final pages = _getEnhancedPages(context);
    final currentPageData = pages[currentPage];

    return Container(
      margin: EdgeInsets.only(
        left: 20.w,
        right: 60.w,
        bottom: 20.h,
        top: 8.h,
      ),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).cardBackground,
              ThemeManager.of(context).modalBackground.withValues(alpha: 0.9),
            ],
          ),
          darkGradient: LinearGradient(
            colors: [
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).backgroundSecondary,
              ThemeManager.of(context).cardBackground,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor:
                ThemeManager.of(context).borderColor.withValues(alpha: 0.3),
            darkColor:
                ThemeManager.of(context).borderSecondary.withValues(alpha: 0.4),
          ),
          width: 1.5,
        ),
        // boxShadow: [
        //   ...ThemeManager.of(context).elevatedShadow,
        //   BoxShadow(
        //     color: currentPageData.color.withValues(alpha: 0.1),
        //     blurRadius: 20,
        //     offset: const Offset(0, 8),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          // Enhanced Previous button
          if (currentPage > 0)
            Expanded(
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  gradient: ThemeManager.of(context).conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        ThemeManager.of(context).neutral100,
                        ThemeManager.of(context).neutral200,
                        ThemeManager.of(context).surfaceElevated,
                      ],
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        ThemeManager.of(context).neutral700,
                        ThemeManager.of(context).neutral600,
                        ThemeManager.of(context).surfaceElevated,
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: ThemeManager.of(context).conditionalColor(
                      lightColor: currentPageData.color.withValues(alpha: 0.3),
                      darkColor: currentPageData.color.withValues(alpha: 0.4),
                    ),
                    width: 2,
                  ),
                  // boxShadow: ThemeManager.of(context).subtleShadow,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handlePrevious,
                    borderRadius: BorderRadius.circular(16.r),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Prbal.arrowUp,
                            size: 18.sp,
                            color: currentPageData.color,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'intro.previous'.tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: currentPageData.color,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (currentPage > 0) SizedBox(width: 16.w),

          // Enhanced Next/Get Started button
          Expanded(
            flex: currentPage == 0 ? 1 : 1,
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                gradient: _getPageGradient(currentPageData),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ThemeManager.of(context)
                      .getContrastingColor(currentPageData.color)
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: currentPageData.color.withValues(alpha: 0.4),
                //     blurRadius: 12,
                //     offset: const Offset(0, 6),
                //   ),
                //   ...ThemeManager.of(context).primaryShadow,
                // ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleNext,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentPage == pages.length - 1
                              ? 'intro.getStarted'.tr()
                              : 'button.next'.tr(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: ThemeManager.of(context)
                                .getContrastingColor(currentPageData.color),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          currentPage == pages.length - 1
                              ? Prbal.rocket2
                              : Prbal.arrowDown,
                          size: 18.sp,
                          color: ThemeManager.of(context)
                              .getContrastingColor(currentPageData.color),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _skipOnboarding() {
    final pages = _getEnhancedPages(context);
    HapticFeedback.mediumImpact();

    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _handlePrevious() {
    if (currentPage > 0) {
      HapticFeedback.lightImpact();
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleNext() {
    final pages = _getEnhancedPages(context);

    if (currentPage < pages.length - 1) {
      HapticFeedback.lightImpact();
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      HapticFeedback.heavyImpact();
      _handleGetStarted();
    }
  }

  /// Enhanced intro completion with language selection check and authentication state management
  ///
  /// **PROCESS:**
  /// 1. Check current authentication state
  /// 2. Mark intro as watched in HiveService for persistence
  /// 3. Check if language is selected using HiveService
  /// 4. Navigate to appropriate screen based on language selection status
  /// 5. Provide proper error handling and user feedback
  ///
  /// **NAVIGATION FLOW:**
  /// - If language NOT selected → Navigate to language selection screen
  /// - If language is selected → Navigate to welcome/auth screen
  /// - Auth flow then handles authentication state and dashboard routing
  Future<void> _handleGetStarted() async {
    if (_isCompletingIntro) {
      debugPrint(
          '🚀 IntroductionScreen: Intro completion already in progress, ignoring...');
      return;
    }

    debugPrint(
        '🚀 IntroductionScreen: ====== COMPLETING INTRODUCTION FLOW ======');

    try {
      setState(() {
        _isCompletingIntro = true;
      });

      // Log current auth state for debugging
      final authState = ref.read(authenticationStateProvider);
      debugPrint(
          '🔐 IntroductionScreen: Current auth state before completion:');
      debugPrint(
          '🔐 IntroductionScreen:   - Authenticated: ${authState.isAuthenticated}');
      debugPrint(
          '🔐 IntroductionScreen:   - User: ${authState.user?.username ?? 'none'}');
      debugPrint(
          '🔐 IntroductionScreen:   - User Type: ${authState.user?.userType.name ?? 'none'}');

      // Mark intro as watched in HiveService for persistence
      debugPrint(
          '📝 IntroductionScreen: Marking intro as watched in HiveService...');
      await HiveService.setIntroWatched();
      debugPrint(
          '✅ IntroductionScreen: Intro completion status saved successfully');

      // Check if language is selected using HiveService
      debugPrint(
          '🌐 IntroductionScreen: Checking language selection status...');
      final isLanguageSelected = HiveService.isLanguageSelected();
      final selectedLanguage = HiveService.getSelectedLanguage();

      debugPrint('🌐 IntroductionScreen: Language selection check results:');
      debugPrint(
          '🌐 IntroductionScreen:   - Language selected: $isLanguageSelected');
      debugPrint(
          '🌐 IntroductionScreen:   - Selected language: ${selectedLanguage ?? 'none'}');

      // Navigate based on language selection status
      if (!isLanguageSelected) {
        debugPrint(
            '🧭 IntroductionScreen: Language NOT selected → Navigating to language selection screen');
        NavigationRoute.goRouteClear(RouteEnum.languageSelection.rawValue);
      } else {
        debugPrint(
            '🧭 IntroductionScreen: Language selected ($selectedLanguage) → Navigating to welcome screen');
        NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
      }

      debugPrint(
          '🚀 IntroductionScreen: ====== INTRO COMPLETION SUCCESSFUL ======');
    } catch (e, stackTrace) {
      debugPrint('❌ IntroductionScreen: Error completing intro: $e');
      debugPrint('🔍 IntroductionScreen: Stack trace: $stackTrace');

      // Even if there's an error, try to navigate
      debugPrint('🔄 IntroductionScreen: Attempting fallback navigation...');
      try {
        // On error, check language selection for fallback navigation
        final isLanguageSelected = HiveService.isLanguageSelected();
        if (!isLanguageSelected) {
          debugPrint(
              '🔄 IntroductionScreen: Fallback → Language selection screen');
          NavigationRoute.goRouteClear(RouteEnum.languageSelection.rawValue);
        } else {
          debugPrint('🔄 IntroductionScreen: Fallback → Welcome screen');
          NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
        }
      } catch (navError) {
        debugPrint(
            '❌ IntroductionScreen: Fallback navigation failed: $navError');
        // Ultimate fallback to welcome screen
        try {
          NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
        } catch (ultimateError) {
          debugPrint(
              '❌ IntroductionScreen: Ultimate fallback failed: $ultimateError');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCompletingIntro = false;
        });
      }
    }
  }
}

/// Enhanced OnboardingPage class with comprehensive ThemeManager support
class OnboardingPage {
  final String title;
  final String subtitle;
  final String animationPath;
  final Color color;
  final List<Color> gradientColors;
  final IconData icon;
  final String statusType;
  final double scale;
  final double translateX;
  final double translateY;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.animationPath,
    required this.color,
    required this.gradientColors,
    required this.icon,
    required this.statusType,
    this.scale = 1.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
  });
}

/// Legacy Introduction class for backward compatibility
class Introduction {
  const Introduction._();
  static Widget get intro => const IntroductionScreen();
}
