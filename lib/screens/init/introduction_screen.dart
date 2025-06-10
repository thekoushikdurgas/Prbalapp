import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';
import 'dart:math' show cos, sin;

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with TickerProviderStateMixin {
  late PageController pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Get Help Anytime, Anywhere!',
      subtitle:
          'From trusted services to skilled manpower — get exactly what you need, when you need it. 24/7 availability at your fingertips.',
      animationPath: 'assets/intro/work.json',
      color: const Color(0xFF3B82F6),
      icon: LineIcons.clock,
    ),
    OnboardingPage(
      title: 'Vast Network of Professionals',
      subtitle:
          'Access our large network with thousands of verified professionals and businesses ready to serve your needs.',
      animationPath: 'assets/intro/commerce.json',
      color: const Color(0xFF10B981),
      icon: LineIcons.users,
    ),
    OnboardingPage(
      title: 'Be Your Boss & Boost Business',
      subtitle:
          'Discover opportunities and services tailored to your skills with total flexibility. Take control of your professional journey.',
      animationPath: 'assets/intro/app.json',
      color: const Color(0xFF8B5CF6),
      icon: LineIcons.crown,
    ),
    OnboardingPage(
      title: 'Earn Hourly with AI Assistance',
      subtitle:
          'Earn wages on an hourly basis with intelligent AI that helps optimize your work schedule and maximize your income.',
      animationPath: 'assets/intro/hourly.json',
      color: const Color(0xFFF59E0B),
      icon: LineIcons.robot,
    ),
    OnboardingPage(
      title: 'Smart Bidding System',
      subtitle:
          'Make offers based on your skills, location, and experience. AI suggests fair wages based on market trends and job requirements.',
      animationPath: 'assets/intro/bidding.json',
      color: const Color(0xFFEF4444),
      icon: LineIcons.handshake,
    ),
    OnboardingPage(
      title: 'Best Match & Swipe Features',
      subtitle:
          'Smart algorithm learns your preferences. Swipe right to like, left to pass. Get matched with perfect opportunities!',
      animationPath: 'assets/intro/match.json',
      color: const Color(0xFFEC4899),
      icon: LineIcons.heart,
    ),
    OnboardingPage(
      title: 'Minimalistic Design',
      subtitle:
          'Clean, intuitive interface with large, clear images and seamless navigation. Built for the modern professional.',
      animationPath: 'assets/intro/design.json',
      color: const Color(0xFF06B6D4),
      icon: LineIcons.palette,
    ),
    OnboardingPage(
      title: 'Trusted & Verified Experts',
      subtitle:
          'Complete background verification ensures you work with trusted professionals. Your safety and security is our priority.',
      animationPath: 'assets/intro/verification.json',
      color: const Color(0xFF84CC16),
      icon: LineIcons.checkCircle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
  }

  void _restartAnimations() {
    _slideController.reset();
    _slideController.forward();
  }

  @override
  void dispose() {
    pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                  ]
                : [
                    const Color(0xFFFFFFFF),
                    const Color(0xFFF8FAFC),
                  ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(isDark),
                _buildPageView(isDark),
                _buildBottomNavigation(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo with enhanced branding
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _pages[currentPage].color,
                      _pages[currentPage].color.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: _pages[currentPage].color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  LineIcons.briefcase,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prbal',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Your Professional Hub',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color:
                          isDark ? Colors.grey[400] : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Skip button with page indicator
          if (currentPage < _pages.length - 1)
            Column(
              children: [
                GestureDetector(
                  onTap: _skipOnboarding,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: _pages[currentPage].color.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _pages[currentPage].color,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${currentPage + 1}/${_pages.length}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isDark ? Colors.grey[500] : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPageView(bool isDark) {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
          _restartAnimations();
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimation,
            child: _buildPageContent(_pages[index], isDark),
          );
        },
      ),
    );
  }

  Widget _buildPageContent(OnboardingPage page, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // Enhanced Animation Container
              Expanded(
                flex: 3,
                child: _buildEnhancedIllustration(page, isDark),
              ),

              SizedBox(height: 16.h),

              // Content with better typography
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
                        // Feature badge
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: page.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: page.color.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                page.icon,
                                size: 14.sp,
                                color: page.color,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Feature ${currentPage + 1}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: page.color,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Title with gradient effect
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              page.color,
                              page.color.withValues(alpha: 0.8),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            page.title,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // Enhanced subtitle
                        Text(
                          page.subtitle,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.grey[300]
                                : const Color(0xFF475569),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
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

  Widget _buildEnhancedIllustration(OnboardingPage page, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background gradient circle
          Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  page.color.withValues(alpha: 0.15),
                  page.color.withValues(alpha: 0.08),
                  page.color.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
          ),

          // Floating elements
          ...List.generate(6, (index) {
            final angle = (index * 60) * (3.14159 / 180);
            final radius = 120.0 + (index * 10);
            return Positioned(
              left: 150.w + (radius * 0.8 * cos(angle)),
              top: 150.h + (radius * 0.8 * sin(angle)),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 2000 + (index * 200)),
                width: 8.w + (index * 2),
                height: 8.h + (index * 2),
                decoration: BoxDecoration(
                  color: page.color.withValues(alpha: 0.4 - (index * 0.05)),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: page.color.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Main Lottie animation
          Container(
            width: 280.w,
            height: 280.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: page.color.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Lottie.asset(
                page.animationPath,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
            ),
          ),

          // Overlay gradient for better contrast
          Container(
            width: 280.w,
            height: 280.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  page.color.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced page indicator
          SizedBox(
            height: 32.h,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        width: currentPage == index ? 24.w : 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? _pages[currentPage].color
                              : (isDark ? Colors.grey[600] : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(3.r),
                          boxShadow: currentPage == index
                              ? [
                                  BoxShadow(
                                    color: _pages[currentPage]
                                        .color
                                        .withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Enhanced action buttons
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  // Back button
                  if (currentPage > 0)
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: _handlePrevious,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _pages[currentPage].color,
                            side: BorderSide(
                              color: _pages[currentPage]
                                  .color
                                  .withValues(alpha: 0.3),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LineIcons.arrowLeft,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (currentPage > 0) SizedBox(width: 12.w),

                  // Next/Get Started button
                  Expanded(
                    flex: currentPage == 0 ? 1 : 1,
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[currentPage].color,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor:
                              _pages[currentPage].color.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  currentPage == _pages.length - 1
                                      ? 'Get Started'
                                      : 'Next',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(
                                currentPage == _pages.length - 1
                                    ? LineIcons.rocketChat
                                    : LineIcons.arrowRight,
                                size: 18.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _skipOnboarding() {
    pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _handlePrevious() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNext() {
    if (currentPage < _pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleGetStarted();
    }
  }

  Future<void> _handleGetStarted() async {
    await HiveService.setIntroWatched();
    NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String animationPath;
  final Color color;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.animationPath,
    required this.color,
    required this.icon,
  });
}

// Legacy Introduction class for backward compatibility
class Introduction {
  const Introduction._();
  static Widget get intro => const IntroductionScreen();
}
