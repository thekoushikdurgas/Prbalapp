import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/widgets/phone_login_bottom_sheet.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:easy_localization/easy_localization.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    debugPrint('🎬 WelcomeScreen: Initializing welcome screen with animations');
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    debugPrint('🎬 WelcomeScreen: Setting up animation controllers');

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _buttonScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _startAnimations() async {
    debugPrint('🎬 WelcomeScreen: Starting welcome animations sequence');
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _buttonController.forward();
    debugPrint('🎬 WelcomeScreen: All animations started successfully');
  }

  @override
  void dispose() {
    debugPrint('🎬 WelcomeScreen: Disposing animation controllers');
    _slideController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700; // Detect smaller screens

    debugPrint('🎬 WelcomeScreen: Building welcome screen');
    debugPrint(
        '🎨 WelcomeScreen: Theme mode: ${themeManager.themeManager ? 'Dark' : 'Light'}');
    debugPrint(
        '📱 WelcomeScreen: Screen height: $screenHeight (Small: $isSmallScreen)');

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: themeManager.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // Header section - Responsive spacing
                SizedBox(height: isSmallScreen ? 30.h : 60.h),

                // Illustration/Logo section - Adjusted flex for small screens
                Expanded(
                  flex: isSmallScreen ? 2 : 3,
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildIllustrationSection(themeManager),
                        ),
                      );
                    },
                  ),
                ),

                // Content section - Made scrollable to prevent overflow
                Expanded(
                  flex: isSmallScreen ? 2 : 2,
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: _buildContentSection(themeManager),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Action buttons section
                AnimatedBuilder(
                  animation: _buttonController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _buttonScale.value,
                      child: _buildActionButtons(themeManager),
                    );
                  },
                ),

                SizedBox(
                    height: isSmallScreen
                        ? 10.h
                        : 20.h), // Further reduced for small screens
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationSection(ThemeManager themeManager) {
    debugPrint('🎨 WelcomeScreen: Building illustration section');

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background decorative elements
          Positioned(
            top: 10.h,
            right: 15.w,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: themeManager.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 20.w,
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: themeManager.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(17.5.r),
              ),
            ),
          ),

          // Lottie Animation
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 280.w,
              maxHeight: 280.h,
            ),
            child: Lottie.asset(
              'assets/animations/welcome.json',
              fit: BoxFit.contain,
              repeat: true,
              reverse: false,
              animate: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(ThemeManager themeManager) {
    debugPrint('🎨 WelcomeScreen: Building content section');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main heading
        Text(
          'Welcome to Prbal',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: themeManager.textPrimary,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 12.h),

        // Subtitle
        Text(
          'Your trusted marketplace for connecting with skilled professionals and quality services.',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: themeManager.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 24.h),

        // Feature highlights
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFeatureHighlight(
              'Verified\nProviders',
              Prbal.checkCircle,
              themeManager.successColor,
              themeManager,
            ),
            _buildFeatureHighlight(
              'Secure\nPayments',
              Prbal.lock,
              themeManager.primaryColor,
              themeManager,
            ),
            _buildFeatureHighlight(
              '24/7\nSupport',
              Prbal.headset,
              themeManager.infoColor,
              themeManager,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureHighlight(
    String label,
    IconData icon,
    Color color,
    ThemeManager themeManager,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Icon(
            icon,
            size: 24.sp,
            color: color,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: themeManager.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeManager themeManager) {
    debugPrint('🎨 WelcomeScreen: Building action buttons');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary action button
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              debugPrint('📱 WelcomeScreen: Get Started button pressed');
              _showPhoneLoginBottomSheet();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeManager.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: themeManager.primaryColor.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Prbal.mobilePhone,
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Secondary action button
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: OutlinedButton(
            onPressed: () {
              debugPrint('🧭 WelcomeScreen: Explore Services button pressed');
              // TODO: Navigate to explore as guest
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: themeManager.primaryColor,
              side: BorderSide(
                color: themeManager.borderColor,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Prbal.compass,
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Explore Services',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Terms and privacy
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              'By continuing, you agree to our ',
              style: TextStyle(
                fontSize: 11.sp,
                color: themeManager.textTertiary,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('📄 WelcomeScreen: Terms of Service tapped');
                // TODO: Show terms
              },
              child: Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: themeManager.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              ' and ',
              style: TextStyle(
                fontSize: 11.sp,
                color: themeManager.textTertiary,
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('🔒 WelcomeScreen: Privacy Policy tapped');
                // TODO: Show privacy policy
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: themeManager.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '.',
              style: TextStyle(
                fontSize: 11.sp,
                color: themeManager.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPhoneLoginBottomSheet() {
    debugPrint('📱 WelcomeScreen: Showing phone login bottom sheet');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const PhoneLoginBottomSheet(),
    );
  }
}
