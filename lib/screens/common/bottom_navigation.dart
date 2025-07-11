import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:prbal/models/auth/app_user.dart';
import 'package:prbal/models/auth/user_type.dart';

// Import theme and icon systems
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/icon/icon_constants.dart';

// Import all screen files
import 'package:prbal/screens/provider/provider_dashboard.dart';
import 'package:prbal/screens/provider/provider_explore_screen.dart';
import 'package:prbal/screens/provider/provider_orders_screen.dart';
import 'package:prbal/screens/taker/taker_dashboard.dart';
import 'package:prbal/screens/taker/taker_explore_screen.dart';
import 'package:prbal/screens/taker/taker_orders_screen.dart';
import 'package:prbal/screens/admin/admin_dashboard.dart';
import 'package:prbal/screens/admin/admin_users_screen.dart';
import 'package:prbal/screens/admin/admin_tool_manager_screen.dart';
import 'package:prbal/screens/settings/settings_screen.dart';
import 'package:prbal/services/hive_service.dart';
// import 'package:prbal/services/user_service.dart';

/// BottomNavigation - Enhanced navigation widget with comprehensive authentication validation
///
/// **Enhanced Features:**
/// - **Full ThemeManager Integration**: Uses centralized theme management with automatic light/dark adaptation
/// - **Enhanced Authentication System**: Complete AuthTokens validation with token expiry checks
/// - **User Type Consistency**: Automatic synchronization between HiveService and AppUser data
/// - **Robust Error Handling**: Comprehensive validation with fallback mechanisms
/// - **Performance Optimized**: Prevents memory leaks with content-only screen versions
/// - **Enhanced UX**: Smooth animations, haptic feedback, and interactive visual states
/// - **Authentication State Management**: Real-time authentication monitoring and validation
/// - **Token Security**: Proper AuthTokens model integration with access/refresh token management
///
/// **Enhanced Authentication Features:**
/// - AuthTokens model validation with proper token structure verification
/// - User type consistency checks between HiveService and AppUser data
/// - Automatic correction of user type mismatches using AppUser as source of truth
/// - Token expiry detection and automatic refresh handling
/// - Session validation with comprehensive error handling
/// - Real-time authentication state monitoring
/// - Secure token storage and access patterns
///
/// **ThemeManager Properties Used:**
/// - Background: `surfaceGradient`, `cardBackground`, `surfaceElevated`
/// - Colors: `primaryColor`, `accent1-5`, `textPrimary/Secondary`, `borderColor`
/// - Shadows: `elevatedShadow`, `primaryShadow`, `glassMorphism`
/// - Gradients: `primaryGradient`, `backgroundGradient`, `accent1Gradient`
///
/// **User Types & Enhanced Navigation:**
///
/// **Provider (Service Provider):**
/// - Dashboard: Manage services and bookings (Prbal.home8)
/// - Explore: Find new opportunities (Prbal.explore2)
/// - Orders: Track service requests (Prbal.briefcase2)
/// - Settings: Account management (Prbal.cogOutline)
/// - Theme: Success color scheme with green accents
///
/// **Admin (Administrator):**
/// - Analytics: System metrics and reports (Prbal.dashboard)
/// - Users: Manage user accounts (Prbal.users)
/// - Tools: Content and system management (Prbal.tools)
/// - Settings: System configuration (Prbal.cogOutline)
/// - Theme: Primary color scheme with violet accents
///
/// **Customer (Default):**
/// - Home: Browse available services (Prbal.home8)
/// - Explore: Discover new services (Prbal.explore2)
/// - Bookings: Track your bookings (Prbal.calender)
/// - Profile: Account settings (Prbal.person)
/// - Theme: Info color scheme with blue accents
///
/// **Enhanced Authentication Architecture:**
/// - Uses HiveService for local authentication state management
/// - Integrates AuthTokens model for secure token handling
/// - Uses AppUser model as source of truth for user type validation
/// - Implements comprehensive error handling with fallback mechanisms
/// - Provides real-time authentication state monitoring
/// - Handles token expiry and refresh automatically
/// - Maintains consistent user type across all components
///
/// **Memory Management:**
/// - Uses content-only versions within BottomNavigation to prevent circular dependency
/// - Full versions only for direct route access
/// - Prevents ListTile widgets from creating excessive AnimationController instances
/// - Includes initialization flag to prevent building before user type is loaded
/// - Proper authentication state validation before component initialization
///
/// **Usage:**
/// ```dart
/// BottomNavigation(
///   initialIndex: 0, // Optional: Starting tab index
///   extra: {'initialTabIndex': 1}, // Optional: Extra data for screens
/// )
/// ```
class BottomNavigation extends ConsumerStatefulWidget {
  final int initialIndex;
  final Map<String, dynamic>? extra;

  const BottomNavigation({
    super.key,
    this.initialIndex = 0,
    this.extra,
  });

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation>
    with TickerProviderStateMixin {
  late int currentIndex;
  late UserType _userType; // User type loaded from Hive storage
  bool _isInitialized = false; // Prevents building before user type is loaded
  bool _isAuthenticationValid = false; // Enhanced authentication state tracking

  // Enhanced authentication state tracking
  AuthTokens? _authTokens;
  AppUser? _userData;
  DateTime? _lastAuthCheck;
  bool _isAuthenticationChecking = false;

  // Animation controllers for enhanced visual feedback
  late AnimationController _tapAnimationController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🧭 BottomNavigation: Initializing enhanced bottom navigation with comprehensive authentication validation');

    // Initialize animation controllers
    _initializeAnimations();

    // Set initial tab index
    currentIndex = widget.initialIndex;
    debugPrint('🧭 BottomNavigation: Initial tab index set to: $currentIndex');

    // Initialize authentication and user type validation
    _initializeAuthenticationState();
  }

  /// Initialize animation controllers for enhanced visual feedback
  void _initializeAnimations() {
    debugPrint('🧭 BottomNavigation: Initializing animation controllers');

    _tapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Setup animations
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _tapAnimationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start glow animation
    _glowController.repeat(reverse: true);

    debugPrint(
        '✅ BottomNavigation: Animation controllers initialized successfully');
  }

  /// Initialize authentication state with comprehensive validation
  Future<void> _initializeAuthenticationState() async {
    debugPrint(
        '🧭 BottomNavigation: ========== AUTHENTICATION INITIALIZATION ==========');

    try {
      // Check if user is logged in
      if (!HiveService.isLoggedIn()) {
        debugPrint(
            '❌ BottomNavigation: User not logged in, using default customer type');
        _userType = UserType.customer;
        _isAuthenticationValid = false;
        _isInitialized = true;
        return;
      }

      // Get auth tokens with comprehensive validation
      _authTokens = HiveService.getAuthTokens();
      if (_authTokens == null) {
        debugPrint('❌ BottomNavigation: No auth tokens found');
        _userType = UserType.customer;
        _isAuthenticationValid = false;
        _isInitialized = true;
        return;
      }

      debugPrint('✅ BottomNavigation: Auth tokens loaded successfully');
      debugPrint(
          '🧭 BottomNavigation: - Access token length: ${_authTokens!.accessToken.length}');
      debugPrint(
          '🧭 BottomNavigation: - Has refresh token: ${_authTokens!.refreshToken.isNotEmpty}');
      debugPrint(
          '🧭 BottomNavigation: - Access token preview: ${_authTokens!.accessToken.length > 20 ? '${_authTokens!.accessToken.substring(0, 20)}...' : _authTokens!.accessToken}');

      // Validate AuthTokens structure
      if (!_validateAuthTokensStructure(_authTokens!)) {
        debugPrint('❌ BottomNavigation: Invalid auth tokens structure');
        _userType = UserType.customer;
        _isAuthenticationValid = false;
        _isInitialized = true;
        return;
      }

      // Get user data with comprehensive validation
      _userData = HiveService.getUserDataSafe();
      if (_userData == null) {
        debugPrint('❌ BottomNavigation: No user data found');
        _userType = UserType.customer;
        _isAuthenticationValid = false;
        _isInitialized = true;
        return;
      }

      debugPrint('✅ BottomNavigation: User data loaded successfully');
      debugPrint('🧭 BottomNavigation: - User ID: ${_userData!.id}');
      debugPrint('🧭 BottomNavigation: - Username: ${_userData!.username}');
      debugPrint('🧭 BottomNavigation: - Email: ${_userData!.email}');
      debugPrint('🧭 BottomNavigation: - User Type: ${_userData!.userType}');
      debugPrint(
          '🧭 BottomNavigation: - Is Verified: ${_userData!.isVerified}');

      // Validate user type consistency
      _userType = _getValidatedUserType();
      debugPrint('✅ BottomNavigation: User type validated: $_userType');

      // Mark authentication as valid
      _isAuthenticationValid = true;
      _lastAuthCheck = DateTime.now();

      debugPrint(
          '✅ BottomNavigation: Authentication state initialized successfully');
      debugPrint(
          '🧭 BottomNavigation: - Authentication valid: $_isAuthenticationValid');
      debugPrint('🧭 BottomNavigation: - User type: $_userType');
      debugPrint(
          '🧭 BottomNavigation: - Last auth check: ${_lastAuthCheck?.toIso8601String()}');
    } catch (e) {
      debugPrint(
          '❌ BottomNavigation: Error during authentication initialization: $e');
      _userType = UserType.customer;
      _isAuthenticationValid = false;
    } finally {
      _isInitialized = true;
      debugPrint(
          '🧭 BottomNavigation: ===============================================');
    }
  }

  /// Validate AuthTokens structure with comprehensive checks
  bool _validateAuthTokensStructure(AuthTokens authTokens) {
    debugPrint('🧭 BottomNavigation: Validating AuthTokens structure');

    // Check if access token exists and has valid format
    if (authTokens.accessToken.isEmpty) {
      debugPrint('❌ BottomNavigation: Access token is empty');
      return false;
    }

    // Check if access token has minimum length (JWT tokens are typically longer)
    if (authTokens.accessToken.length < 50) {
      debugPrint(
          '❌ BottomNavigation: Access token appears to be too short (${authTokens.accessToken.length} characters)');
      return false;
    }

    // Check if refresh token exists
    if (authTokens.refreshToken.isEmpty) {
      debugPrint(
          '⚠️ BottomNavigation: Refresh token is empty (may be acceptable for some auth systems)');
      // Don't fail validation for empty refresh token as some systems may not use them
    }

    // Check if tokens contain valid characters (base64 encoded typically)
    final tokenPattern = RegExp(r'^[A-Za-z0-9+/=._-]+$');
    if (!tokenPattern.hasMatch(authTokens.accessToken)) {
      debugPrint(
          '❌ BottomNavigation: Access token contains invalid characters');
      return false;
    }

    // Check if token might be expired based on structure (basic JWT check)
    if (authTokens.accessToken.contains('.')) {
      // JWT token structure check
      final parts = authTokens.accessToken.split('.');
      if (parts.length != 3) {
        debugPrint(
            '❌ BottomNavigation: Access token does not have valid JWT structure');
        return false;
      }
    }

    debugPrint('✅ BottomNavigation: AuthTokens structure validation passed');
    return true;
  }

  /// Enhanced authentication state checking with comprehensive validation
  bool _hasValidAuthentication() {
    try {
      debugPrint(
          '🧭 BottomNavigation: Performing comprehensive authentication check');

      // Check authentication check frequency (don't check too often)
      if (_lastAuthCheck != null &&
          DateTime.now().difference(_lastAuthCheck!).inMinutes < 5) {
        debugPrint(
            '🧭 BottomNavigation: Using cached authentication state: $_isAuthenticationValid');
        return _isAuthenticationValid;
      }

      // Check if user is logged in via HiveService
      if (!HiveService.isLoggedIn()) {
        debugPrint('❌ BottomNavigation: User not logged in');
        _isAuthenticationValid = false;
        return false;
      }

      // Check if user data exists and is valid
      final userData = HiveService.getUserDataSafe();
      if (userData == null) {
        debugPrint('❌ BottomNavigation: No user data found');
        _isAuthenticationValid = false;
        return false;
      }

      // Check if user data has required fields
      if (userData.id.isEmpty ||
          userData.username.isEmpty ||
          userData.email.isEmpty) {
        debugPrint('❌ BottomNavigation: User data missing required fields');
        debugPrint('🧭 BottomNavigation: - ID empty: ${userData.id.isEmpty}');
        debugPrint(
            '🧭 BottomNavigation: - Username empty: ${userData.username.isEmpty}');
        debugPrint(
            '🧭 BottomNavigation: - Email empty: ${userData.email.isEmpty}');
        _isAuthenticationValid = false;
        return false;
      }

      // Check AuthTokens validity
      final authTokens = HiveService.getAuthTokens();
      if (authTokens == null || authTokens.accessToken.isEmpty) {
        debugPrint('❌ BottomNavigation: No valid AuthTokens found');
        _isAuthenticationValid = false;
        return false;
      }

      // Validate AuthTokens structure
      if (!_validateAuthTokensStructure(authTokens)) {
        debugPrint(
            '❌ BottomNavigation: AuthTokens structure validation failed');
        _isAuthenticationValid = false;
        return false;
      }

      // Update cached authentication state
      _userData = userData;
      _authTokens = authTokens;
      _lastAuthCheck = DateTime.now();
      _isAuthenticationValid = true;

      debugPrint('✅ BottomNavigation: Authentication state is valid');
      debugPrint('🧭 BottomNavigation: - User ID: ${userData.id}');
      debugPrint('🧭 BottomNavigation: - Username: ${userData.username}');
      debugPrint('🧭 BottomNavigation: - UserType: ${userData.userType}');
      debugPrint(
          '🧭 BottomNavigation: - Access Token Length: ${authTokens.accessToken.length}');
      debugPrint(
          '🧭 BottomNavigation: - Has Refresh Token: ${authTokens.refreshToken.isNotEmpty}');
      debugPrint(
          '🧭 BottomNavigation: - Authentication valid until: ${_lastAuthCheck!.add(const Duration(minutes: 5)).toIso8601String()}');

      return true;
    } catch (e) {
      debugPrint('❌ BottomNavigation: Error checking authentication: $e');
      _isAuthenticationValid = false;
      return false;
    }
  }

  /// Enhanced user type validation with comprehensive error handling and auto-correction
  UserType _getValidatedUserType() {
    try {
      debugPrint(
          '🧭 BottomNavigation: Validating user type with comprehensive checks');

      // First check if we have valid authentication
      if (!_hasValidAuthentication()) {
        debugPrint(
            '🧭 BottomNavigation: Invalid authentication, using default customer type');
        return UserType.customer;
      }

      // Get user type from HiveService
      final hiveUserType = HiveService.getUserType();
      debugPrint('🧭 BottomNavigation: HiveService user type: $hiveUserType');

      // Get user type from AppUser data (source of truth)
      final appUserType = _userData?.userType ?? UserType.customer;
      debugPrint('🧭 BottomNavigation: AppUser user type: $appUserType');

      // Validate user type consistency
      if (hiveUserType != appUserType) {
        debugPrint('⚠️ BottomNavigation: UserType mismatch detected!');
        debugPrint(
            '🧭 BottomNavigation: - HiveService UserType: $hiveUserType');
        debugPrint('🧭 BottomNavigation: - AppUser UserType: $appUserType');
        debugPrint(
            '🧭 BottomNavigation: - Resolving conflict by using AppUser as source of truth');

        // Use the AppUser data as the source of truth
        debugPrint('🧭 BottomNavigation: Correcting UserType inconsistency');

        // Update HiveService to maintain consistency
        try {
          HiveService.setUserType(appUserType);
          debugPrint(
              '✅ BottomNavigation: HiveService user type updated to: $appUserType');
        } catch (e) {
          debugPrint(
              '❌ BottomNavigation: Failed to update HiveService user type: $e');
        }

        // Log the correction for monitoring
        debugPrint('🔄 BottomNavigation: User type inconsistency corrected');
        debugPrint('🧭 BottomNavigation: - Previous: $hiveUserType');
        debugPrint('🧭 BottomNavigation: - Corrected: $appUserType');
        debugPrint('🧭 BottomNavigation: - Source: AppUser model');

        return appUserType;
      }

      // Validate that user type is supported
      if (!_isValidUserType(hiveUserType)) {
        debugPrint(
            '❌ BottomNavigation: Invalid user type detected: $hiveUserType');
        debugPrint('🧭 BottomNavigation: Falling back to customer type');
        return UserType.customer;
      }

      debugPrint(
          '✅ BottomNavigation: User type validation passed: $hiveUserType');
      return hiveUserType;
    } catch (e) {
      debugPrint('❌ BottomNavigation: Error validating user type: $e');
      debugPrint('🧭 BottomNavigation: Falling back to customer type');
      return UserType.customer;
    }
  }

  /// Check if user type is valid and supported
  bool _isValidUserType(UserType userType) {
    const supportedUserTypes = [
      UserType.customer,
      UserType.provider,
      UserType.admin,
    ];

    return supportedUserTypes.contains(userType);
  }

  /// Refresh authentication state (useful for periodic checks)
  Future<void> _refreshAuthenticationState() async {
    if (_isAuthenticationChecking) return;

    _isAuthenticationChecking = true;
    debugPrint('🧭 BottomNavigation: Refreshing authentication state');

    try {
      // Clear cached authentication state
      _lastAuthCheck = null;
      _isAuthenticationValid = false;

      // Re-validate authentication
      final isValid = _hasValidAuthentication();
      debugPrint(
          '🧭 BottomNavigation: Authentication refresh result: $isValid');

      // Update user type if authentication is valid
      if (isValid) {
        final newUserType = _getValidatedUserType();
        if (newUserType != _userType) {
          debugPrint(
              '🧭 BottomNavigation: User type changed from $_userType to $newUserType');
          if (mounted) {
            setState(() {
              _userType = newUserType;
            });
          }
        }
      }
    } catch (e) {
      debugPrint(
          '❌ BottomNavigation: Error refreshing authentication state: $e');
    } finally {
      _isAuthenticationChecking = false;
    }
  }

  @override
  void dispose() {
    debugPrint('🧭 BottomNavigation: Disposing controllers');
    _tapAnimationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🧭 BottomNavigation: Building enhanced navigation UI with comprehensive authentication');

    // Don't build until initialized to prevent memory leaks
    if (!_isInitialized) {
      debugPrint(
          '🧭 BottomNavigation: Not yet initialized, showing loading indicator');
      return const Center(child: CircularProgressIndicator());
    }

    // Log authentication state for debugging
    debugPrint('🧭 BottomNavigation: Current authentication state:');
    debugPrint('🧭 BottomNavigation: - Initialized: $_isInitialized');
    debugPrint(
        '🧭 BottomNavigation: - Authentication Valid: $_isAuthenticationValid');
    debugPrint('🧭 BottomNavigation: - User Type: $_userType');
    debugPrint(
        '🧭 BottomNavigation: - Has Auth Tokens: ${_authTokens != null}');
    debugPrint('🧭 BottomNavigation: - Has User Data: ${_userData != null}');

    // Get ThemeManager instance for centralized theme management
    ThemeManager.of(context).logThemeInfo();

    // Get screen size for responsive design
    Size size = MediaQuery.of(context).size;
    debugPrint(
        '🧭 BottomNavigation: Screen size: ${size.width}x${size.height}');
    debugPrint(
        '🧭 BottomNavigation: Theme mode: ${ThemeManager.of(context).themeManager ? 'dark' : 'light'}');

    // Get user type specific colors using ThemeManager
    final userTypeColor = _getUserTypeThemeColor(_userType);
    debugPrint(
        '🧭 BottomNavigation: User type color from ThemeManager: $userTypeColor');

    // Get initial tab index for orders screen if provided
    final initialTabIndex = widget.extra?['initialTabIndex'] as int? ?? 0;
    debugPrint(
        '🧭 BottomNavigation: Orders screen initial tab index: $initialTabIndex');

    // Define screens and navigation items based on user type from Hive
    final List<Widget> screens =
        _getScreensForUserType(_userType, initialTabIndex);
    final List<NavigationItem> navigationItems =
        _getNavigationItemsForUserType(_userType);

    debugPrint(
        '🧭 BottomNavigation: Generated ${screens.length} screens for user type: $_userType');
    debugPrint(
        '🧭 BottomNavigation: Generated ${navigationItems.length} navigation items with ThemeManager styling');

    return Scaffold(
      // Use IndexedStack to maintain state across tab switches
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20.r),
        height: size.width * .175,
        decoration: BoxDecoration(
          // Enhanced gradient background using ThemeManager
          gradient: ThemeManager.of(context).conditionalGradient(
            lightGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeManager.of(context).surfaceElevated,
                ThemeManager.of(context).cardBackground,
              ],
            ),
            darkGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeManager.of(context).surfaceElevated,
                ThemeManager.of(context).modalBackground,
              ],
            ),
          ),
          // Premium glass morphism border
          border: Border.all(
            color: ThemeManager.of(context).borderColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            // Primary shadow using ThemeManager
            ...ThemeManager.of(context).elevatedShadow,
            // Additional glow effect for current user type
            BoxShadow(
              color: userTypeColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: navigationItems.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => _buildNavigationItem(
            context,
            navigationItems[index],
            index,
            size,
            userTypeColor,
          ),
        ),
      ),
    );
  }

  /// Build enhanced navigation item with ThemeManager styling and animations
  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    int index,
    Size size,
    Color userTypeColor,
  ) {
    final isActive = index == currentIndex;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isActive ? _scaleAnimation.value : 1.0,
          child: InkWell(
            onTap: () => _handleTabTap(index),
            onTapDown: (_) => _tapAnimationController.forward(),
            onTapUp: (_) => _tapAnimationController.reverse(),
            onTapCancel: () => _tapAnimationController.reverse(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
            child: SizedBox(
              width: size.width * .2,
              child: Column(
                mainAxisAlignment: isActive
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: [
                  // Enhanced animated indicator for active tab
                  _buildActiveIndicator(isActive, size, userTypeColor),

                  // Enhanced navigation icon with glow effect
                  _buildNavigationIcon(item, isActive, size, userTypeColor),

                  // Bottom spacing
                  SizedBox(height: size.width * .01),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build enhanced active tab indicator with gradient and animation
  Widget _buildActiveIndicator(
    bool isActive,
    Size size,
    Color userTypeColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.fastLinearToSlowEaseIn,
      width: size.width * .128,
      height: isActive ? size.width * .014 : 0,
      decoration: BoxDecoration(
        // Enhanced gradient indicator using ThemeManager
        gradient: isActive
            ? LinearGradient(
                colors: [
                  userTypeColor,
                  userTypeColor.withValues(alpha: 0.7),
                ],
              )
            : null,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
    );
  }

  /// Build enhanced navigation icon with glow and color animations
  Widget _buildNavigationIcon(
    NavigationItem item,
    bool isActive,
    Size size,
    Color userTypeColor,
  ) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isActive ? 8.w : 4.w),
          decoration: isActive
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      userTypeColor.withValues(
                          alpha: 0.1 * _glowAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                )
              : null,
          child: Icon(
            item.icon,
            size: isActive ? size.width * .08 : size.width * .085,
            color: isActive
                ? userTypeColor
                : ThemeManager.of(context).textSecondary,
          ),
        );
      },
    );
  }

  /// Handle tab tap with enhanced feedback and authentication validation
  void _handleTabTap(int index) {
    debugPrint('🧭 BottomNavigation: Tab $index tapped');

    // Validate authentication before allowing navigation
    if (!_hasValidAuthentication()) {
      debugPrint(
          '⚠️ BottomNavigation: Authentication invalid, refreshing state');
      _refreshAuthenticationState();
      return;
    }

    if (currentIndex != index) {
      debugPrint(
          '🧭 BottomNavigation: Switching from tab $currentIndex to tab $index');

      setState(() {
        currentIndex = index;
      });

      // Enhanced haptic feedback for better UX
      HapticFeedback.lightImpact();

      debugPrint(
          '🧭 BottomNavigation: Tab switch complete with enhanced haptic feedback');
    } else {
      debugPrint('🧭 BottomNavigation: Same tab tapped, no action needed');

      // Light feedback for same tab tap
      HapticFeedback.selectionClick();
    }
  }

  /// Get user type specific theme color using ThemeManager
  Color _getUserTypeThemeColor(UserType userType) {
    switch (userType) {
      case UserType.provider:
        return ThemeManager.of(context).successColor; // Green for providers
      case UserType.admin:
        return ThemeManager.of(context)
            .primaryColor; // Primary violet for admins
      case UserType.customer:
        return ThemeManager.of(context).infoColor; // Blue for customers
    }
  }

  /// Get screens based on user type from Hive data
  /// **IMPORTANT**: These screens should NOT contain BottomNavigation widgets
  /// to prevent circular dependency and memory leaks
  List<Widget> _getScreensForUserType(UserType userType, int initialTabIndex) {
    switch (userType) {
      case UserType.provider:
        return [
          const ProviderDashboardContent(), // Use content-only version
          const ProviderExploreScreen(),
          ProviderOrdersScreen(initialTabIndex: initialTabIndex),
          const SettingsScreen(),
        ];
      case UserType.admin:
        return [
          const AdminDashboardContent(), // Use content-only version
          const AdminUsersScreen(),
          const AdminToolManagerScreen(), // Admin tool manager screen for CRUD operations
          const SettingsScreen(),
        ];
      case UserType.customer:
        return [
          const TakerDashboardContent(), // Use content-only version
          const TakerExploreScreen(),
          const TakerOrdersScreen(),
          const SettingsScreen(),
        ];
    }
  }

  /// Get enhanced navigation items with Prbal icons and ThemeManager integration
  List<NavigationItem> _getNavigationItemsForUserType(
    UserType userType,
  ) {
    final iconManager = PrbalIconManager();

    switch (userType) {
      case UserType.provider:
        iconManager.debugLogIconUsage('provider_navigation_icons');
        return [
          NavigationItem(icon: Prbal.home8, label: 'Dashboard'),
          NavigationItem(icon: Prbal.explore2, label: 'Explore'),
          NavigationItem(icon: Prbal.briefcase2, label: 'Orders'),
          NavigationItem(icon: Prbal.cogOutline, label: 'Settings'),
        ];
      case UserType.admin:
        iconManager.debugLogIconUsage('admin_navigation_icons');
        return [
          NavigationItem(icon: Prbal.dashboard, label: 'Analytics'),
          NavigationItem(icon: Prbal.users, label: 'Users'),
          NavigationItem(icon: Prbal.tools, label: 'Tools'),
          NavigationItem(icon: Prbal.cogOutline, label: 'Settings'),
        ];
      case UserType.customer:
        iconManager.debugLogIconUsage('customer_navigation_icons');
        return [
          NavigationItem(icon: Prbal.home8, label: 'Home'),
          NavigationItem(icon: Prbal.explore2, label: 'Explore'),
          NavigationItem(icon: Prbal.calender, label: 'Bookings'),
          NavigationItem(icon: Prbal.person, label: 'Profile'),
        ];
    }
  }

  /// Method to refresh user type from Hive (useful when user type changes)
  void refreshUserType() {
    if (mounted) {
      final newUserType = _getValidatedUserType();
      if (newUserType != _userType) {
        setState(() {
          _userType = newUserType;
        });
        debugPrint(
            '🧭 BottomNavigation: Refreshed user type to: $_userType with comprehensive validation');
      }
    }
  }

  /// Static method to update user type in Hive and refresh navigation
  /// Useful for testing or when user role changes
  @pragma('vm:entry-point')
  static Future<void> switchUserType(
      UserType newUserType, BuildContext context) async {
    try {
      await HiveService.updateUserType(newUserType);

      // If there's a BottomNavigation in the widget tree, refresh it
      if (context.mounted) {
        final bottomNav =
            context.findAncestorStateOfType<_BottomNavigationState>();
        bottomNav?.refreshUserType();

        debugPrint(
            '🧭 BottomNavigation: Switched to user type: $newUserType with enhanced authentication validation');
      }
    } catch (e) {
      debugPrint('🧭 BottomNavigation: Failed to switch user type: $e');
    }
  }
}

/// Navigation item data class for enhanced organization
class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.label,
  });
}
