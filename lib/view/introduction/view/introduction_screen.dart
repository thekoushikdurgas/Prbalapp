import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/init/navigation/navigation_route.dart';
import 'package:prbal/product/enum/route_enum.dart';
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
      title: 'Find Trusted Professionals',
      subtitle:
          'Connect with verified service providers in your area for all your home and personal needs.',
      icon: LineIcons.userCheck,
      color: const Color(0xFF3B82F6),
    ),
    OnboardingPage(
      title: 'Secure & Smart Booking',
      subtitle:
          'Book services with confidence using our smart matching system and secure payment processing.',
      icon: LineIcons.lock,
      color: const Color(0xFF10B981),
    ),
    OnboardingPage(
      title: 'Real-time Tracking',
      subtitle:
          'Track your service requests, communicate with providers, and manage bookings in real-time.',
      icon: LineIcons.mapMarker,
      color: const Color(0xFF8B5CF6),
    ),
    OnboardingPage(
      title: 'Quality Assured',
      subtitle:
          'Rate and review services to help build a trusted community of professionals.',
      icon: LineIcons.star,
      color: const Color(0xFFF59E0B),
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
          // Logo
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  LineIcons.briefcase,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Prbal',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          // Skip button
          if (currentPage < _pages.length - 1)
            GestureDetector(
              onTap: _skipOnboarding,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[300] : const Color(0xFF6B7280),
                  ),
                ),
              ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),

          // Illustration container
          Expanded(
            flex: 3,
            child: _buildIllustration(page, isDark),
          ),

          SizedBox(height: 40.h),

          // Content
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Title
                Text(
                  page.title,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.h),

                // Subtitle
                Text(
                  page.subtitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(OnboardingPage page, bool isDark) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 280.w,
            height: 280.h,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  page.color.withValues(alpha: 0.1),
                  page.color.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
          ),

          // Decorative elements
          ...List.generate(3, (index) {
            final angle = (index * 120) * (3.14159 / 180);
            final radius = 100.0 + (index * 20);
            return Positioned(
              left: 140.w + (radius * cos(angle)),
              top: 140.h + (radius * sin(angle)),
              child: Container(
                width: 12.w + (index * 4),
                height: 12.h + (index * 4),
                decoration: BoxDecoration(
                  color: page.color.withValues(alpha: 0.3 - (index * 0.1)),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          // Main icon container
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  page.color,
                  page.color.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(60.r),
              boxShadow: [
                BoxShadow(
                  color: page.color.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 60.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        children: [
          // Page indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: currentPage == index ? 32.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? _pages[currentPage].color
                      : (isDark ? Colors.grey[600] : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),

          SizedBox(height: 32.h),

          // Action buttons
          Row(
            children: [
              // Back button
              if (currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handlePrevious,
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isDark ? Colors.white : _pages[currentPage].color,
                      side: BorderSide(
                        color: isDark
                            ? Colors.grey[600]!
                            : _pages[currentPage].color.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              if (currentPage > 0) SizedBox(width: 16.w),

              // Next/Get Started button
              Expanded(
                flex: currentPage == 0 ? 1 : 1,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _pages[currentPage].color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor:
                        _pages[currentPage].color.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (currentPage < _pages.length - 1) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          LineIcons.arrowRight,
                          size: 20.sp,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _skipOnboarding() {
    pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
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
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

// Legacy Introduction class for backward compatibility
class Introduction {
  const Introduction._();
  static Widget get intro => const IntroductionScreen();
}
