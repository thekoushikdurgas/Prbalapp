import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';

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
      begin: const Offset(0, 0.5),
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                // Main content with vertical PageView
                Column(
                  children: [
                    _buildVerticalPageView(),
                    _buildBottomNavigation(),
                  ],
                ),

                // Right-side vertical page indicators
                _buildSkipIndicator(),
                _buildRightSideIndicators(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalPageView() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical, // Changed to vertical scrolling
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
            child: _buildPageContent(_pages[index]),
          );
        },
      ),
    );
  }

  Widget _buildSkipIndicator() {
    return Positioned(
      right: 16.w,
      top: 0,
      bottom: 0,
      child: Column(
        children: [
          if (currentPage < _pages.length - 1)
            Column(
              children: [
                GestureDetector(
                  onTap: _skipOnboarding,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: _pages[currentPage].color.withValues(alpha: 51),
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
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRightSideIndicators() {
    return Positioned(
      right: 16.w,
      bottom: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Current page indicator
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: _pages[currentPage].color,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    '${currentPage + 1}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Vertical page indicators
              ...List.generate(_pages.length, (index) {
                return GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3.h),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: currentPage == index ? 8.w : 4.w,
                      height: currentPage == index ? 28.h : 8.h,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? _pages[currentPage].color
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 12.h),

              // Swipe hint
              if (currentPage < _pages.length - 1)
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: _pages[currentPage].color.withValues(alpha: 26),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    LineIcons.arrowDown,
                    size: 12.sp,
                    color: _pages[currentPage].color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingPage page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(
              left: 20.w,
              right: 60.w,
              top: 8.h,
              bottom: 8.h), // Added right padding for indicators
          child: Column(
            children: [
              // Enhanced Animation Container
              Expanded(
                flex: 3,
                child: _buildEnhancedIllustration(page),
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
                            color: page.color.withValues(alpha: 26),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: page.color.withValues(alpha: 51),
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

                        // Title with theme-aware text
                        Text(
                          page.title,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 10.h),

                        // Enhanced subtitle with theme-aware colors
                        Text(
                          page.subtitle,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
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

  Widget _buildEnhancedIllustration(OnboardingPage page) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Lottie animation
          SizedBox(
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

  Widget _buildBottomNavigation() {
    return Padding(
      padding: EdgeInsets.only(
          left: 20.w,
          right: 60.w,
          bottom: 20.h,
          top: 8.h), // Adjusted for right indicators
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced action buttons for vertical navigation
          Row(
            children: [
              // Up button (Previous)
              if (currentPage > 0)
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: _handlePrevious,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _pages[currentPage].color,
                        side: BorderSide(
                          color:
                              _pages[currentPage].color.withValues(alpha: 77),
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
                              LineIcons.arrowUp,
                              size: 18.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Previous',
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

              // Down button (Next/Get Started)
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
                          _pages[currentPage].color.withValues(alpha: 102),
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
                                : LineIcons.arrowDown,
                            size: 18.sp,
                          ),
                        ],
                      ),
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
