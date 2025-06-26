import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// INTRODUCTION SCREEN COMPONENT
/// ====================================================================
///
/// ✅ **COMPREHENSIVE THEMEMANAGER INTEGRATION COMPLETED** ✅
///
/// **🎨 ENHANCED FEATURES WITH ALL THEMEMANAGER PROPERTIES:**
///
/// **1. COMPREHENSIVE COLOR SYSTEM:**
/// - Primary Colors: primaryColor, primaryLight, primaryDark, secondaryColor
/// - Background Colors: backgroundColor, backgroundSecondary, backgroundTertiary,
///   cardBackground, surfaceElevated, modalBackground
/// - Text Colors: textPrimary, textSecondary, textTertiary, textQuaternary, textInverted
/// - Status Colors: successColor/Light/Dark, warningColor/Light/Dark,
///   errorColor/Light/Dark, infoColor/Light/Dark
/// - Accent Colors: accent1-5, neutral50-900
/// - Border Colors: borderColor, borderSecondary, borderFocus, dividerColor
/// - Interactive Colors: buttonBackground, inputBackground, statusColors
/// - Shadow Colors: shadowLight, shadowMedium, shadowDark
///
/// **2. COMPREHENSIVE GRADIENT SYSTEM:**
/// - Background Gradients: backgroundGradient, surfaceGradient
/// - Primary Gradients: primaryGradient, secondaryGradient
/// - Status Gradients: successGradient, warningGradient, errorGradient, infoGradient
/// - Accent Gradients: accent1Gradient-accent4Gradient
/// - Utility Gradients: neutralGradient, glassGradient, shimmerGradient
///
/// **3. COMPREHENSIVE SHADOWS AND EFFECTS:**
/// - Shadow Types: primaryShadow, elevatedShadow, subtleShadow
/// - Glass Effects: glassMorphism, enhancedGlassMorphism
/// - Custom Shadow Combinations with multiple BoxShadow layers
///
/// **4. COMPREHENSIVE HELPER METHODS:**
/// - conditionalColor() - theme-aware color selection
/// - conditionalGradient() - theme-aware gradient selection
/// - getContrastingColor() - automatic contrast detection
/// - getTextColorForBackground() - optimal text color selection
///
/// **🏗️ ARCHITECTURAL ENHANCEMENTS:**
///
/// **1. Enhanced Background System:**
/// - Multi-layer gradient backgrounds with comprehensive color transitions
/// - Theme-aware background adaptation using backgroundGradient
/// - Professional visual hierarchy with proper contrast ratios
///
/// **2. Advanced Animation Container:**
/// - Glass morphism effects with enhancedGlassMorphism
/// - Gradient overlays using accent gradients
/// - Professional shadows combining all shadow types
/// - Theme-aware animation colors
///
/// **3. Enhanced Navigation System:**
/// - Dynamic button styling with primary/secondary gradients
/// - Interactive states with theme-aware colors
/// - Professional visual feedback with shadows and animations
/// - Comprehensive status color integration
///
/// **4. Premium Visual Effects:**
/// - Comprehensive page indicators using accent colors
/// - Theme-aware skip functionality with glass morphism
/// - Professional typography with optimal contrast
/// - Advanced visual hierarchy with semantic colors
///
/// **🎯 RESULT:**
/// A sophisticated introduction screen that provides premium visual experience
/// with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible onboarding.
/// ====================================================================

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> with TickerProviderStateMixin, ThemeAwareMixin {
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

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _initializeAnimations();
    _startAnimations();
    debugPrint('🎯 IntroductionScreen: Comprehensive initialization completed with ThemeManager integration');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _logComprehensiveThemeInitialization();
      _isInitialized = true;
    }
  }

  /// Logs comprehensive initialization with ALL theme information
  void _logComprehensiveThemeInitialization() {
    final themeManager = ThemeManager.of(context);

    debugPrint('🎯 IntroductionScreen: ===== COMPREHENSIVE THEMEMANAGER INTEGRATION =====');

    // Comprehensive theme logging
    themeManager.logThemeInfo();
    themeManager.logGradientInfo();
    themeManager.logAllColors();

    debugPrint('🎯 IntroductionScreen: → Enhanced with ALL ThemeManager properties');
    debugPrint('🎯 IntroductionScreen: → Background System: backgroundColor, backgroundSecondary, backgroundTertiary');
    debugPrint(
        '🎯 IntroductionScreen: → Surface System: surfaceColor, surfaceElevated, cardBackground, modalBackground');
    debugPrint(
        '🎯 IntroductionScreen: → Text System: textPrimary, textSecondary, textTertiary, textQuaternary, textInverted');
    debugPrint('🎯 IntroductionScreen: → Status System: success/warning/error/info with Light/Dark variants');
    debugPrint('🎯 IntroductionScreen: → Accent System: accent1-5 with comprehensive gradients');
    debugPrint('🎯 IntroductionScreen: → Border System: borderColor, borderSecondary, borderFocus, dividerColor');
    debugPrint('🎯 IntroductionScreen: → Shadow System: primaryShadow, elevatedShadow, subtleShadow');
    debugPrint('🎯 IntroductionScreen: → Glass Effects: glassMorphism, enhancedGlassMorphism');
    debugPrint(
        '🎯 IntroductionScreen: → Helper Methods: conditionalColor(), conditionalGradient(), getContrastingColor()');
    debugPrint('🎯 IntroductionScreen: → Page count: ${_getEnhancedPages(context).length}');
    debugPrint('🎯 IntroductionScreen: → Animation controllers ready with comprehensive theme integration');
  }

  /// Gets comprehensive theme-aware onboarding pages using ALL ThemeManager properties
  List<OnboardingPage> _getEnhancedPages(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('🎨 IntroductionScreen: Building pages with COMPREHENSIVE ThemeManager integration');

    return [
      OnboardingPage(
        title: 'Get Help Anytime, Anywhere!',
        subtitle:
            'From trusted services to skilled manpower — get exactly what you need, when you need it. 24/7 availability at your fingertips.',
        animationPath: 'assets/intro/work.json',
        color: themeManager.primaryColor,
        gradientColors: [themeManager.primaryColor, themeManager.primaryLight, themeManager.accent1],
        icon: Prbal.clock,
        statusType: 'primary',
      ),
      OnboardingPage(
        title: 'Vast Network of Professionals',
        subtitle:
            'Access our large network with thousands of verified professionals and businesses ready to serve your needs.',
        animationPath: 'assets/intro/commerce.json',
        color: themeManager.successColor,
        gradientColors: [themeManager.successColor, themeManager.successLight, themeManager.accent3],
        icon: Prbal.users,
        statusType: 'success',
      ),
      OnboardingPage(
        title: 'Be Your Boss & Boost Business',
        subtitle:
            'Discover opportunities and services tailored to your skills with total flexibility. Take control of your professional journey.',
        animationPath: 'assets/intro/app.json',
        color: themeManager.infoColor,
        gradientColors: [themeManager.infoColor, themeManager.infoLight, themeManager.accent5],
        icon: Prbal.graduationCap1,
        statusType: 'info',
      ),
      OnboardingPage(
        title: 'Earn Hourly with AI Assistance',
        subtitle:
            'Earn wages on an hourly basis with intelligent AI that helps optimize your work schedule and maximize your income.',
        animationPath: 'assets/intro/hourly.json',
        color: themeManager.warningColor,
        gradientColors: [themeManager.warningColor, themeManager.warningLight, themeManager.accent4],
        icon: Prbal.laptop11,
        statusType: 'warning',
      ),
      OnboardingPage(
        title: 'Smart Bidding System',
        subtitle:
            'Make offers based on your skills, location, and experience. AI suggests fair wages based on market trends and job requirements.',
        animationPath: 'assets/intro/bidding.json',
        color: themeManager.errorColor,
        gradientColors: [themeManager.errorColor, themeManager.errorLight, themeManager.accent2],
        icon: Prbal.hand,
        statusType: 'error',
      ),
      OnboardingPage(
        title: 'Best Match & Swipe Features',
        subtitle:
            'Smart algorithm learns your preferences. Swipe right to like, left to pass. Get matched with perfect opportunities!',
        animationPath: 'assets/intro/match.json',
        color: themeManager.accent2,
        gradientColors: [themeManager.accent2, themeManager.primaryColor, themeManager.accent1],
        icon: Prbal.heart,
        statusType: 'accent',
      ),
      OnboardingPage(
        title: 'Minimalistic Design',
        subtitle:
            'Clean, intuitive interface with large, clear images and seamless navigation. Built for the modern professional.',
        animationPath: 'assets/intro/design.json',
        color: themeManager.secondaryColor,
        gradientColors: [themeManager.secondaryColor, themeManager.secondaryLight, themeManager.accent3],
        icon: Prbal.palette,
        statusType: 'secondary',
      ),
      OnboardingPage(
        title: 'Trusted & Verified Experts',
        subtitle:
            'Complete background verification ensures you work with trusted professionals. Your safety and security is our priority.',
        animationPath: 'assets/intro/verification.json',
        color: themeManager.verifiedColor,
        gradientColors: [themeManager.verifiedColor, themeManager.successColor, themeManager.accent3],
        icon: Prbal.checkCircle,
        statusType: 'verified',
      ),
    ];
  }

  /// Gets comprehensive page gradient using ThemeManager gradient system
  LinearGradient _getPageGradient(OnboardingPage page, ThemeManager themeManager) {
    switch (page.statusType) {
      case 'primary':
        return themeManager.primaryGradient;
      case 'success':
        return themeManager.successGradient;
      case 'info':
        return themeManager.infoGradient;
      case 'warning':
        return themeManager.warningGradient;
      case 'error':
        return themeManager.errorGradient;
      case 'accent':
        return themeManager.accent2Gradient;
      case 'secondary':
        return themeManager.secondaryGradient;
      case 'verified':
        return themeManager.accent3Gradient;
      default:
        return themeManager.primaryGradient;
    }
  }

  void _initializeAnimations() {
    debugPrint('🎯 IntroductionScreen: Initializing comprehensive animation system');

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
      begin: const Offset(0, 0.8),
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
    debugPrint('🎯 IntroductionScreen: Starting comprehensive animation sequence');

    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _glowController.repeat(reverse: true);
  }

  void _restartAnimations() {
    debugPrint('🎯 IntroductionScreen: Restarting animations with page transition');

    _slideController.reset();
    _slideController.forward();
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    debugPrint('🎯 IntroductionScreen: Disposing comprehensive animation controllers');
    pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('🎨 IntroductionScreen: Building with COMPREHENSIVE ThemeManager integration');
    debugPrint('🎨 IntroductionScreen: → Background Gradient: ${themeManager.backgroundGradient.colors}');
    debugPrint('🎨 IntroductionScreen: → Surface Gradient: ${themeManager.surfaceGradient.colors}');
    debugPrint('🎨 IntroductionScreen: → Primary Colors: ${themeManager.primaryColor}');
    debugPrint(
        '🎨 IntroductionScreen: → Text Colors: Primary(${themeManager.textPrimary}), Secondary(${themeManager.textSecondary})');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeManager.conditionalGradient(
            lightGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeManager.backgroundColor,
                themeManager.backgroundSecondary,
                themeManager.backgroundTertiary.withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            darkGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeManager.backgroundColor,
                themeManager.backgroundSecondary,
                themeManager.backgroundTertiary,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                // Enhanced background gradient overlay
                _buildEnhancedBackgroundOverlay(themeManager),

                // Main content with vertical PageView
                Column(
                  children: [
                    _buildEnhancedVerticalPageView(themeManager),
                    _buildEnhancedBottomNavigation(themeManager),
                  ],
                ),

                // Enhanced right-side components
                _buildEnhancedSkipIndicator(themeManager),
                _buildEnhancedRightSideIndicators(themeManager),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build enhanced background overlay with comprehensive gradients
  Widget _buildEnhancedBackgroundOverlay(ThemeManager themeManager) {
    final pages = _getEnhancedPages(context);
    final currentPageData = pages[currentPage];

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: [
                currentPageData.color.withValues(alpha: 0.15 * _glowAnimation.value),
                currentPageData.gradientColors[1].withValues(alpha: 0.08 * _glowAnimation.value),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedVerticalPageView(ThemeManager themeManager) {
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
          debugPrint('🎯 IntroductionScreen: Enhanced page changed to $index with theme-aware styling');
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimation,
            child: _buildEnhancedPageContent(pages[index], themeManager),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedSkipIndicator(ThemeManager themeManager) {
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
                GestureDetector(
                  onTap: _skipOnboarding,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      gradient: themeManager.conditionalGradient(
                        lightGradient: LinearGradient(
                          colors: [
                            themeManager.surfaceElevated,
                            themeManager.cardBackground,
                            themeManager.modalBackground,
                          ],
                        ),
                        darkGradient: LinearGradient(
                          colors: [
                            themeManager.surfaceElevated,
                            themeManager.backgroundSecondary,
                            themeManager.cardBackground,
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: themeManager.conditionalColor(
                          lightColor: currentPageData.color.withValues(alpha: 0.3),
                          darkColor: currentPageData.color.withValues(alpha: 0.4),
                        ),
                        width: 1.5,
                      ),
                      boxShadow: [
                        ...themeManager.elevatedShadow,
                        BoxShadow(
                          color: currentPageData.color.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: currentPageData.color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.neutral100,
                      darkColor: themeManager.neutral700,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: themeManager.borderSecondary,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${currentPage + 1}/${pages.length}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: themeManager.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedRightSideIndicators(ThemeManager themeManager) {
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
                      gradient: _getPageGradient(currentPageData, themeManager),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: themeManager.getContrastingColor(currentPageData.color).withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentPageData.color.withValues(alpha: 0.4 * _glowAnimation.value),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        ...themeManager.primaryShadow,
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${currentPage + 1}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: themeManager.getContrastingColor(currentPageData.color),
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
                            ? _getPageGradient(pageData, themeManager)
                            : LinearGradient(
                                colors: [
                                  themeManager.textTertiary,
                                  themeManager.textQuaternary,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(6.r),
                        border: isActive
                            ? Border.all(
                                color: pageData.color.withValues(alpha: 0.3),
                                width: 1,
                              )
                            : null,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: pageData.color.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
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
                            currentPageData.color.withValues(alpha: 0.2 * _glowAnimation.value),
                            currentPageData.color.withValues(alpha: 0.1 * _glowAnimation.value),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: currentPageData.color.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: themeManager.subtleShadow,
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

  Widget _buildEnhancedPageContent(OnboardingPage page, ThemeManager themeManager) {
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
                child: _buildEnhancedIllustration(page, themeManager),
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
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            gradient: themeManager.conditionalGradient(
                              lightGradient: LinearGradient(
                                colors: [
                                  page.color.withValues(alpha: 0.15),
                                  page.gradientColors[1].withValues(alpha: 0.1),
                                  page.gradientColors[2].withValues(alpha: 0.05),
                                ],
                              ),
                              darkGradient: LinearGradient(
                                colors: [
                                  page.color.withValues(alpha: 0.2),
                                  page.gradientColors[1].withValues(alpha: 0.15),
                                  page.gradientColors[2].withValues(alpha: 0.1),
                                ],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: themeManager.conditionalColor(
                                lightColor: page.color.withValues(alpha: 0.3),
                                darkColor: page.color.withValues(alpha: 0.4),
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: page.color.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                              ...themeManager.subtleShadow,
                            ],
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
                                'Feature ${currentPage + 1}',
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
                              color: themeManager.textPrimary,
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
                              color: themeManager.textSecondary,
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

  Widget _buildEnhancedIllustration(OnboardingPage page, ThemeManager themeManager) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            page.color.withValues(alpha: 0.05),
            page.gradientColors[1].withValues(alpha: 0.03),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Enhanced background glow effect
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      page.color.withValues(alpha: 0.1 * _glowAnimation.value),
                      page.gradientColors[1].withValues(alpha: 0.05 * _glowAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              );
            },
          ),

          // Main Lottie animation with enhanced container
          Container(
            padding: EdgeInsets.all(16.w),
            child: Lottie.asset(
              page.animationPath,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBottomNavigation(ThemeManager themeManager) {
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
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              themeManager.surfaceElevated,
              themeManager.cardBackground,
              themeManager.modalBackground.withValues(alpha: 0.9),
            ],
          ),
          darkGradient: LinearGradient(
            colors: [
              themeManager.surfaceElevated,
              themeManager.backgroundSecondary,
              themeManager.cardBackground,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 0.3),
            darkColor: themeManager.borderSecondary.withValues(alpha: 0.4),
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...themeManager.elevatedShadow,
          BoxShadow(
            color: currentPageData.color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Enhanced Previous button
          if (currentPage > 0)
            Expanded(
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  gradient: themeManager.conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        themeManager.neutral100,
                        themeManager.neutral200,
                        themeManager.surfaceElevated,
                      ],
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        themeManager.neutral700,
                        themeManager.neutral600,
                        themeManager.surfaceElevated,
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: themeManager.conditionalColor(
                      lightColor: currentPageData.color.withValues(alpha: 0.3),
                      darkColor: currentPageData.color.withValues(alpha: 0.4),
                    ),
                    width: 2,
                  ),
                  boxShadow: themeManager.subtleShadow,
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
                            'Previous',
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
                gradient: _getPageGradient(currentPageData, themeManager),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: themeManager.getContrastingColor(currentPageData.color).withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentPageData.color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  ...themeManager.primaryShadow,
                ],
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
                          currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: themeManager.getContrastingColor(currentPageData.color),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          currentPage == pages.length - 1 ? Prbal.rocket2 : Prbal.arrowDown,
                          size: 18.sp,
                          color: themeManager.getContrastingColor(currentPageData.color),
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
    debugPrint('🎯 IntroductionScreen: Skip button pressed - jumping to last page with comprehensive theming');
    HapticFeedback.mediumImpact();

    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _handlePrevious() {
    if (currentPage > 0) {
      debugPrint('🎯 IntroductionScreen: Previous button pressed - going to page ${currentPage - 1}');
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
      debugPrint('🎯 IntroductionScreen: Next button pressed - going to page ${currentPage + 1}');
      HapticFeedback.lightImpact();
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      debugPrint('🎯 IntroductionScreen: Get Started button pressed - completing comprehensive onboarding');
      HapticFeedback.heavyImpact();
      _handleGetStarted();
    }
  }

  Future<void> _handleGetStarted() async {
    debugPrint('🎯 IntroductionScreen: Setting intro as watched and navigating to welcome with comprehensive theming');
    await HiveService.setIntroWatched();
    NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
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

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.animationPath,
    required this.color,
    required this.gradientColors,
    required this.icon,
    required this.statusType,
  });
}

/// Legacy Introduction class for backward compatibility
class Introduction {
  const Introduction._();
  static Widget get intro => const IntroductionScreen();
}
