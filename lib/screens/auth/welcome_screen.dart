import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/widgets/phone_login_bottom_sheet.dart';
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
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
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
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _buttonController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700; // Detect smaller screens

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
                    const Color(0xFF334155),
                  ]
                : [
                    const Color(0xFFFFFFFF),
                    const Color(0xFFF8FAFC),
                    const Color(0xFFE2E8F0),
                  ],
          ),
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
                          child: _buildIllustrationSection(isDark),
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
                            child: _buildContentSection(isDark),
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
                      child: _buildActionButtons(isDark),
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

  Widget _buildIllustrationSection(bool isDark) {
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
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
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
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
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

  Widget _buildContentSection(bool isDark) {
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
            color: isDark ? Colors.white : const Color(0xFF0F172A),
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
            color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
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
              const Color(0xFF10B981),
              isDark,
            ),
            _buildFeatureHighlight(
              'Secure\nPayments',
              Prbal.lock,
              const Color(0xFF3B82F6),
              isDark,
            ),
            _buildFeatureHighlight(
              '24/7\nSupport',
              Prbal.headset,
              const Color(0xFF8B5CF6),
              isDark,
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
    bool isDark,
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
            color: isDark ? Colors.grey[300] : const Color(0xFF475569),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary action button
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to login/registration
              _showPhoneLoginBottomSheet();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: const Color(0xFF3B82F6).withValues(alpha: 0.3),
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
              // Navigate to explore as guest
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white : const Color(0xFF3B82F6),
              side: BorderSide(
                color: isDark
                    ? Colors.grey[600]!
                    : const Color(0xFF3B82F6).withValues(alpha: 0.3),
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
                color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Show terms
              },
              child: Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              ' and ',
              style: TextStyle(
                fontSize: 11.sp,
                color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Show privacy policy
              },
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF3B82F6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '.',
              style: TextStyle(
                fontSize: 11.sp,
                color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPhoneLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const PhoneLoginBottomSheet(),
    );
  }
}
