import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:prbal/screens/auth/phone_login_bottom_sheet.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/utils/debug_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:prbal/services/hive_service.dart';

/// WelcomeScreen - Entry point for user authentication
///
/// **🎯 WELCOME SCREEN OVERVIEW**
/// This screen serves as the primary entry point for user authentication
/// and onboarding, providing a beautiful animated interface that leads
/// to the phone authentication flow.
///
/// **🔄 INTEGRATION WITH SERVICE LAYER:**
/// - Uses HiveService to check for existing user sessions
/// - Integrates with ThemeManager for consistent styling
/// - Connects to PhoneLoginBottomSheet for authentication flow
/// - Supports proper UserType and AppUser data flow
///
/// **🎨 DESIGN FEATURES:**
/// - Smooth entrance animations with staggered timing
/// - Lottie animation for engaging visual experience
/// - Theme-aware design with gradient backgrounds
/// - Responsive layout for different screen sizes
/// - Professional feature highlights with iconography
///
/// **🏗️ ARCHITECTURE INTEGRATION:**
/// - **State Management**: Riverpod for reactive state
/// - **Local Storage**: HiveService for session management
/// - **Navigation**: Direct integration with authentication flow
/// - **Theme**: ThemeManager for consistent styling
/// - **Animations**: Custom controllers for smooth UX
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> with TickerProviderStateMixin {
  // Animation controllers for smooth entrance effects
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  // Animation objects for different entrance effects
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    DebugLogger.ui('WelcomeScreen: Initializing welcome screen');
    DebugLogger.auth('WelcomeScreen: Checking existing user session via HiveService');

    // Check if user is already logged in via HiveService
    _checkExistingSession();

    _initializeAnimations();
    _startAnimations();

    DebugLogger.success('WelcomeScreen: Welcome screen initialization completed');
  }

  /// Check for existing user session using HiveService
  ///
  /// **Purpose:** Verify if user is already authenticated and potentially navigate away
  /// **Process:**
  /// 1. Check HiveService for existing login status
  /// 2. Validate user data and auth tokens
  /// 3. Navigate to home if authenticated (let router handle dashboard routing)
  /// **Integration:** Uses HiveService methods for session validation
  void _checkExistingSession() {
    DebugLogger.auth('WelcomeScreen: Checking for existing user session');

    try {
      // Check if user is logged in via HiveService
      final isLoggedIn = HiveService.isLoggedIn();
      DebugLogger.auth('WelcomeScreen: HiveService login status: $isLoggedIn');

      if (isLoggedIn) {
        // Get user data safely from HiveService
        final userData = HiveService.getUserDataSafe();
        final authTokens = HiveService.getAuthTokens();

        DebugLogger.user('WelcomeScreen: Existing user data found: ${userData != null}');
        DebugLogger.auth('WelcomeScreen: Auth tokens found: ${authTokens != null}');

        if (userData != null) {
          DebugLogger.success('WelcomeScreen: Valid existing session detected');
          DebugLogger.user('WelcomeScreen: User: ${userData.firstName} ${userData.lastName}');
          DebugLogger.user('WelcomeScreen: UserType: ${userData.userType}');
          DebugLogger.user('WelcomeScreen: Email: ${userData.email}');

          // Navigate to home - let router handle dashboard routing
          DebugLogger.navigation('WelcomeScreen: Navigating to home → Router will handle dashboard routing');

          // Note: We could navigate here, but the router's redirect logic will handle this
          // automatically when the authentication state is properly initialized
          DebugLogger.navigation('WelcomeScreen: Router will redirect to appropriate dashboard');
        } else {
          DebugLogger.error('WelcomeScreen: Login status true but no user data found');
          DebugLogger.storage('WelcomeScreen: Clearing inconsistent session state');

          // Clear inconsistent state
          HiveService.emergencyLogout();
        }
      } else {
        DebugLogger.info('WelcomeScreen: No existing session found, showing welcome screen');
      }
    } catch (e) {
      DebugLogger.error('WelcomeScreen: Error checking existing session: $e');
      DebugLogger.storage('WelcomeScreen: Performing emergency logout for safety');

      // Perform emergency logout on any error
      HiveService.emergencyLogout();
    }
  }

  /// Initialize animation controllers and animation objects
  ///
  /// **Purpose:** Create smooth, layered entrance animations
  /// **Animations:**
  /// - Slide animation: Content slides up from bottom (800ms)
  /// - Fade animation: Opacity transition (1000ms)
  /// - Button scale: Elastic scale-in effect (600ms)
  void _initializeAnimations() {
    DebugLogger.ui('WelcomeScreen: Initializing entrance animations');

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    DebugLogger.ui('WelcomeScreen: Slide controller created (800ms duration)');

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    DebugLogger.ui('WelcomeScreen: Fade controller created (1000ms duration)');

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    DebugLogger.ui('WelcomeScreen: Button controller created (600ms duration)');

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    DebugLogger.ui('WelcomeScreen: Slide animation configured (0.3 offset to 0.0)');

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    DebugLogger.ui('WelcomeScreen: Fade animation configured (0.0 to 1.0 opacity)');

    _buttonScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));
    DebugLogger.ui('WelcomeScreen: Button scale animation configured (0.8 to 1.0 scale)');

    DebugLogger.success('WelcomeScreen: All animations initialized successfully');
  }

  /// Start staggered entrance animations for smooth UX
  ///
  /// **Purpose:** Create professional, layered animation entrance
  /// **Sequence:**
  /// 1. Wait 300ms (allow screen to settle)
  /// 2. Start fade animation
  /// 3. Wait 200ms then start slide animation
  /// 4. Wait 400ms then start button scale animation
  /// **UX Benefit:** Creates depth and professional feel
  Future<void> _startAnimations() async {
    debugPrint('🎨 WelcomeScreen: 🎭 Starting staggered entrance animations');

    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('🎨 WelcomeScreen: ⏰ Initial delay completed (300ms)');

    _fadeController.forward();
    debugPrint('🎨 WelcomeScreen: 🌟 Fade animation started');

    await Future.delayed(const Duration(milliseconds: 200));
    debugPrint('🎨 WelcomeScreen: ⏰ Fade-to-slide delay completed (200ms)');

    _slideController.forward();
    debugPrint('🎨 WelcomeScreen: ⬆️ Slide animation started');

    await Future.delayed(const Duration(milliseconds: 400));
    debugPrint('🎨 WelcomeScreen: ⏰ Slide-to-button delay completed (400ms)');

    _buttonController.forward();
    debugPrint('🎨 WelcomeScreen: 🔘 Button animation started');

    debugPrint('🎨 WelcomeScreen: ✅ All entrance animations running');
  }

  @override
  void dispose() {
    DebugLogger.ui('WelcomeScreen: Starting welcome screen cleanup');

    // Clean up animation controllers
    DebugLogger.ui('WelcomeScreen: Disposing animation controllers');
    _slideController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();

    DebugLogger.success('WelcomeScreen: Welcome screen cleanup completed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.ui('WelcomeScreen: Building welcome screen UI');

    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700; // Detect smaller screens

    DebugLogger.ui('WelcomeScreen: Screen height: ${screenHeight}px');
    DebugLogger.ui('WelcomeScreen: Is small screen: $isSmallScreen');
    DebugLogger.ui('WelcomeScreen: Theme manager loaded: ${ThemeManager.of(context).runtimeType}');

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

  /// Build illustration section with Lottie animation and decorative elements
  ///
  /// **Purpose:** Create engaging visual centerpiece
  /// **Features:**
  /// - Lottie animation for smooth, professional feel
  /// - Decorative background elements with theme colors
  /// - Responsive sizing for different screen sizes
  /// **Theme Integration:** Uses ThemeManager colors for decorative elements
  Widget _buildIllustrationSection() {
    debugPrint('🎨 WelcomeScreen: 🖼️ Building illustration section');

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background decorative elements with theme colors
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

          // Lottie Animation - Main visual element
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

  /// Build content section with title and feature highlights
  ///
  /// **Purpose:** Communicate app value proposition
  /// **Features:**
  /// - Localized title text
  /// - Feature highlights with themed icons
  /// - Responsive layout for different screen sizes
  /// **Theme Integration:** Uses ThemeManager for consistent typography and colors
  Widget _buildContentSection() {
    debugPrint('🎨 WelcomeScreen: 📝 Building content section');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main heading with localization
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

        // Feature highlights with theme-aware styling
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

  /// Build individual feature highlight with icon and label
  ///
  /// **Purpose:** Showcase key app benefits
  /// **Parameters:**
  /// - [label]: Localized feature description
  /// - [icon]: Themed icon for visual representation
  /// - [color]: Theme-aware color for consistency
  /// **Design:** Compact, visually appealing feature card
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

  /// Build action buttons section with primary CTA and terms
  ///
  /// **Purpose:** Guide user to authentication flow
  /// **Features:**
  /// - Primary action button to start phone authentication
  /// - Terms and privacy policy links
  /// - Responsive design with theme integration
  /// **Integration:** Connects to PhoneLoginBottomSheet for authentication
  Widget _buildActionButtons() {
    debugPrint('🎨 WelcomeScreen: 🔘 Building action buttons section');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary action button - Start authentication
        SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              DebugLogger.ui('WelcomeScreen: Get Started button pressed');
              DebugLogger.navigation('WelcomeScreen: Opening phone login bottom sheet');
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

        // Terms and privacy policy with theme styling
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
                DebugLogger.ui('WelcomeScreen: Terms of Service tapped');
                // TODO: Show terms modal or navigate to terms page
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
                DebugLogger.ui('WelcomeScreen: Privacy Policy tapped');
                // TODO: Show privacy policy modal or navigate to privacy page
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

  /// Show phone login bottom sheet for authentication
  ///
  /// **Purpose:** Launch authentication flow
  /// **Integration:** Opens PhoneLoginBottomSheet which handles:
  /// - Phone number validation and country selection
  /// - UserService integration for user lookup
  /// - Navigation to PIN verification with AppUser data
  /// - HiveService integration for session management
  void _showPhoneLoginBottomSheet() {
    DebugLogger.navigation('WelcomeScreen: Opening phone login bottom sheet modal');
    DebugLogger.auth('WelcomeScreen: Integrating with authentication flow');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        DebugLogger.ui('WelcomeScreen: Building PhoneLoginBottomSheet');
        return const PhoneLoginBottomSheet();
      },
    ).then((_) {
      DebugLogger.navigation('WelcomeScreen: Phone login bottom sheet dismissed');
    });
  }
}
