import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _initializeAnimations();
    _startAnimations();
    debugPrint('🎯 IntroductionScreen: Basic initialization completed');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _logThemeInitialization();
      _isInitialized = true;
    }
  }

  /// Logs initialization with theme information
  void _logThemeInitialization() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    debugPrint('🎯 IntroductionScreen: Initializing with theme-aware design');
    debugPrint(
        '🎯 IntroductionScreen: Theme mode: ${isDark ? 'dark' : 'light'}');
    debugPrint(
        '🎯 IntroductionScreen: Page count: ${_getPages(context).length}');
    debugPrint('🎯 IntroductionScreen: Animation controllers ready');
  }

  /// Gets theme-aware onboarding pages
  List<OnboardingPage> _getPages(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    debugPrint(
        '🎨 IntroductionScreen: Building pages for ${isDark ? 'dark' : 'light'} theme');

    return [
      OnboardingPage(
        title: 'Get Help Anytime, Anywhere!',
        subtitle:
            'From trusted services to skilled manpower — get exactly what you need, when you need it. 24/7 availability at your fingertips.',
        animationPath: 'assets/intro/work.json',
        color: _getThemeAwareColor(context, 0),
        icon: Prbal.clock,
      ),
      OnboardingPage(
        title: 'Vast Network of Professionals',
        subtitle:
            'Access our large network with thousands of verified professionals and businesses ready to serve your needs.',
        animationPath: 'assets/intro/commerce.json',
        color: _getThemeAwareColor(context, 1),
        icon: Prbal.users,
      ),
      OnboardingPage(
        title: 'Be Your Boss & Boost Business',
        subtitle:
            'Discover opportunities and services tailored to your skills with total flexibility. Take control of your professional journey.',
        animationPath: 'assets/intro/app.json',
        color: _getThemeAwareColor(context, 2),
        icon: Prbal.graduationCap1,
      ),
      OnboardingPage(
        title: 'Earn Hourly with AI Assistance',
        subtitle:
            'Earn wages on an hourly basis with intelligent AI that helps optimize your work schedule and maximize your income.',
        animationPath: 'assets/intro/hourly.json',
        color: _getThemeAwareColor(context, 3),
        icon: Prbal.laptop11,
      ),
      OnboardingPage(
        title: 'Smart Bidding System',
        subtitle:
            'Make offers based on your skills, location, and experience. AI suggests fair wages based on market trends and job requirements.',
        animationPath: 'assets/intro/bidding.json',
        color: _getThemeAwareColor(context, 4),
        icon: Prbal.hand,
      ),
      OnboardingPage(
        title: 'Best Match & Swipe Features',
        subtitle:
            'Smart algorithm learns your preferences. Swipe right to like, left to pass. Get matched with perfect opportunities!',
        animationPath: 'assets/intro/match.json',
        color: _getThemeAwareColor(context, 5),
        icon: Prbal.heart,
      ),
      OnboardingPage(
        title: 'Minimalistic Design',
        subtitle:
            'Clean, intuitive interface with large, clear images and seamless navigation. Built for the modern professional.',
        animationPath: 'assets/intro/design.json',
        color: _getThemeAwareColor(context, 6),
        icon: Prbal.palette,
      ),
      OnboardingPage(
        title: 'Trusted & Verified Experts',
        subtitle:
            'Complete background verification ensures you work with trusted professionals. Your safety and security is our priority.',
        animationPath: 'assets/intro/verification.json',
        color: _getThemeAwareColor(context, 7),
        icon: Prbal.checkCircle,
      ),
    ];
  }

  /// Gets theme-aware color for each page
  Color _getThemeAwareColor(BuildContext context, int pageIndex) {
    // final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define color palettes for light and dark themes
    final lightColors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Emerald
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFFEC4899), // Pink
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF84CC16), // Lime
    ];

    final darkColors = [
      const Color(0xFF60A5FA), // Lighter Blue for dark mode
      const Color(0xFF34D399), // Lighter Emerald for dark mode
      const Color(0xFFA78BFA), // Lighter Purple for dark mode
      const Color(0xFFFBBF24), // Lighter Amber for dark mode
      const Color(0xFFF87171), // Lighter Red for dark mode
      const Color(0xFFF472B6), // Lighter Pink for dark mode
      const Color(0xFF22D3EE), // Lighter Cyan for dark mode
      const Color(0xFFA3E635), // Lighter Lime for dark mode
    ];

    final colors = isDark ? darkColors : lightColors;
    final color = colors[pageIndex % colors.length];

    debugPrint(
        '🎨 IntroductionScreen: Page $pageIndex color: $color (${isDark ? 'dark' : 'light'} theme)');
    return color;
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
    debugPrint('🎯 IntroductionScreen: Disposed animation controllers');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    debugPrint(
        '🎨 IntroductionScreen: Building with ${isDark ? 'dark' : 'light'} theme');
    debugPrint('🎨 IntroductionScreen: Primary color: ${colorScheme.primary}');
    debugPrint('🎨 IntroductionScreen: Surface color: ${colorScheme.surface}');

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
    final pages = _getPages(context);

    return Expanded(
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical, // Changed to vertical scrolling
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
          _restartAnimations();
          debugPrint('🎯 IntroductionScreen: Page changed to $index');
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimation,
            child: _buildPageContent(pages[index]),
          );
        },
      ),
    );
  }

  Widget _buildSkipIndicator() {
    final pages = _getPages(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: pages[currentPage].color.withValues(alpha: 51),
                        width: 1,
                      ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: colorScheme.shadow.withValues(alpha: 26),
                      //     blurRadius: 4,
                      //     offset: const Offset(0, 2),
                      //   ),
                      // ],
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: pages[currentPage].color,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${currentPage + 1}/${pages.length}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: colorScheme.onSurface.withValues(alpha: 153),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRightSideIndicators() {
    final pages = _getPages(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  color: pages[currentPage].color,
                  borderRadius: BorderRadius.circular(12.r),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: pages[currentPage].color.withValues(alpha: 77),
                  //     blurRadius: 6,
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
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
              ...List.generate(pages.length, (index) {
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
                            ? pages[currentPage].color
                            : colorScheme.onSurface.withValues(alpha: 102),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 12.h),

              // Swipe hint
              if (currentPage < pages.length - 1)
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: pages[currentPage].color.withValues(alpha: 26),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Prbal.arrowDown,
                    size: 12.sp,
                    color: pages[currentPage].color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingPage page) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 10.h),

                        // Enhanced subtitle with theme-aware colors
                        Text(
                          page.subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: colorScheme.onSurface.withValues(alpha: 204),
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
    final pages = _getPages(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                        foregroundColor: pages[currentPage].color,
                        side: BorderSide(
                          color: pages[currentPage].color.withValues(alpha: 77),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        backgroundColor: colorScheme.surface,
                      ),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Prbal.arrowUp,
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
                      backgroundColor: pages[currentPage].color,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor:
                          pages[currentPage].color.withValues(alpha: 102),
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
                              currentPage == pages.length - 1
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
                            currentPage == pages.length - 1
                                ? Prbal.rocket2
                                : Prbal.arrowDown,
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
    final pages = _getPages(context);
    debugPrint(
        '🎯 IntroductionScreen: Skip button pressed - jumping to last page');

    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _handlePrevious() {
    if (currentPage > 0) {
      debugPrint(
          '🎯 IntroductionScreen: Previous button pressed - going to page ${currentPage - 1}');
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNext() {
    final pages = _getPages(context);

    if (currentPage < pages.length - 1) {
      debugPrint(
          '🎯 IntroductionScreen: Next button pressed - going to page ${currentPage + 1}');
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint(
          '🎯 IntroductionScreen: Get Started button pressed - completing onboarding');
      _handleGetStarted();
    }
  }

  Future<void> _handleGetStarted() async {
    debugPrint(
        '🎯 IntroductionScreen: Setting intro as watched and navigating to welcome');
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
