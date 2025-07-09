import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/screens/auth/phone_login_bottom_sheet.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> with TickerProviderStateMixin {
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
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700; // Detect smaller screens

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).backgroundGradient,
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
                          child: _buildIllustrationSection(),
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
                            child: _buildContentSection(),
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
                      child: _buildActionButtons(),
                    );
                  },
                ),

                SizedBox(height: isSmallScreen ? 10.h : 20.h), // Further reduced for small screens
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationSection() {
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
                color: ThemeManager.of(context).primaryColor.withValues(alpha: 0.1),
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
                color: ThemeManager.of(context).successColor.withValues(alpha: 0.1),
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

  Widget _buildContentSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main heading
        Text(
          'welcome.title'.tr(),
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: ThemeManager.of(context).textPrimary,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 40.h),

        // Feature highlights
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFeatureHighlight(
              'welcome.features.verified'.tr(),
              Prbal.group1,
              ThemeManager.of(context).successColor,
            ),
            _buildFeatureHighlight(
              'welcome.features.secure'.tr(),
              Prbal.lock5,
              ThemeManager.of(context).primaryColor,
            ),
            _buildFeatureHighlight(
              'welcome.features.support'.tr(),
              Prbal.headphones5,
              ThemeManager.of(context).infoColor,
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
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24.sp,
          color: color,
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary action button
        SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              _showPhoneLoginBottomSheet();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeManager.of(context).primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: ThemeManager.of(context).primaryColor.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Prbal.phoneCall,
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'welcome.getStarted'.tr(),
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
              'welcome.termsAgreement'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: ThemeManager.of(context).textTertiary,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Show terms
              },
              child: Text(
                'welcome.termsOfService'.tr(),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: ThemeManager.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              'welcome.and'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: ThemeManager.of(context).textTertiary,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Show privacy policy
              },
              child: Text(
                'welcome.privacyPolicy'.tr(),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: ThemeManager.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              'welcome.period'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: ThemeManager.of(context).textTertiary,
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
