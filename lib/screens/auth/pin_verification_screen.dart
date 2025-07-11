import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/models/auth/app_user.dart';
import 'package:prbal/models/auth/user_type.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/services/app_services.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';

/// PIN Verification Screen for handling user authentication
///
/// **🔐 PIN VERIFICATION OVERVIEW**
/// This screen serves dual purposes with complete service layer integration:
/// 1. **NEW USERS:** PIN creation during registration process
/// 2. **EXISTING USERS:** PIN verification during login process
///
/// **🎯 CORE FEATURES:**
/// - 4-digit PIN input with real-time validation and visual feedback
/// - Comprehensive error handling with user-friendly messages
/// - Animated UI elements for professional UX (shake, pulse effects)
/// - Complete integration with UserService for authentication
/// - Proper AuthTokens handling via HiveService
/// - UserType-based navigation routing
/// - AppUser data management throughout the flow
///
/// **🔄 AUTHENTICATION FLOW:**
/// 1. User enters 4-digit PIN → Real-time validation
/// 2. App validates PIN format → Error handling if invalid
/// 3. **For NEW USERS:** Call UserService.pinRegister() with AppUser data
/// 4. **For EXISTING USERS:** Call UserService.pinLogin() with credentials
/// 5. Extract AuthTokens from API response → Save via HiveService
/// 6. Fetch complete user profile via UserService.getCurrentUserProfile()
/// 7. Save AppUser data via HiveService.saveUserData()
/// 8. Navigate to appropriate dashboard based on UserType
///
/// **🏗️ SERVICE LAYER INTEGRATION:**
/// - **UserService:** All API calls (pinRegister, pinLogin, getCurrentUserProfile)
/// - **HiveService:** Local storage (saveUserData, saveAuthTokens, setLoggedIn)
/// - **AppUser:** Complete user data model throughout the flow
/// - **AuthTokens:** Proper token management (access + refresh tokens)
/// - **UserType:** Type-safe user role management and navigation
/// - **ThemeManager:** Consistent UI theming and styling
///
/// **🐛 COMPREHENSIVE DEBUG SYSTEM:**
/// - Detailed debug logging throughout all authentication steps
/// - API request/response logging with complete data structures
/// - Local storage operations tracking with before/after states
/// - Error handling with complete stack traces and recovery steps
/// - Animation state tracking and performance monitoring
class PinVerificationScreen extends ConsumerStatefulWidget {
  /// Phone number for verification (required for API calls)
  final String phoneNumber;

  /// Flag to determine if this is a new user registration or existing user login
  final bool isNewUser;

  /// Complete user data object containing all profile information
  /// Uses AppUser model for type safety and proper data structure
  final AppUser userData;

  const PinVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.userData,
    required this.isNewUser,
  });

  @override
  ConsumerState<PinVerificationScreen> createState() =>
      _PinVerificationScreenState();
}

class _PinVerificationScreenState extends ConsumerState<PinVerificationScreen>
    with TickerProviderStateMixin {
  // ================ STATE VARIABLES ================

  /// Text controllers for each PIN digit input field (4 controllers total)
  final List<TextEditingController> _controllers = [];

  /// Focus nodes for managing keyboard focus between PIN input fields
  final List<FocusNode> _focusNodes = [];

  /// Loading state indicator for API calls and processing
  bool _isLoading = false;

  /// Error message to display when PIN verification fails
  String? _errorMessage;

  // ================ ANIMATION CONTROLLERS ================

  /// Animation controller for shake effect when PIN is incorrect
  late AnimationController _shakeController;

  /// Animation for horizontal shake movement
  late Animation<double> _shakeAnimation;

  /// Animation controller for pulsing lock icon effect
  late AnimationController _pulseController;

  /// Animation for scaling the lock icon (breathing effect)
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // ================ INITIALIZATION DEBUGGING ================
    debugPrint('🔐 PinVerificationScreen: ====== SCREEN INITIALIZATION ======');
    debugPrint('🔐 PinVerificationScreen: Phone Number: ${widget.phoneNumber}');
    debugPrint('🔐 PinVerificationScreen: Is New User: ${widget.isNewUser}');
    debugPrint(
        '🔐 PinVerificationScreen: UserType: ${widget.userData.userType}');
    debugPrint('🔐 PinVerificationScreen: User ID: ${widget.userData.id}');
    debugPrint(
        '🔐 PinVerificationScreen: Username: ${widget.userData.username}');
    debugPrint(
        '🔐 PinVerificationScreen: Display Name: ${widget.userData.firstName} ${widget.userData.lastName}');
    debugPrint('🔐 PinVerificationScreen: Email: ${widget.userData.email}');
    debugPrint(
        '🔐 PinVerificationScreen: Service Layer Integration: UserService + HiveService + AuthTokens');

    // Initialize controllers and animations
    _initializeControllers();
    _setupAnimations();

    debugPrint(
        '🔐 PinVerificationScreen: Initialization completed successfully');
  }

  /// Initialize PIN input controllers and focus nodes
  /// Creates 4 text controllers and focus nodes for each PIN digit
  void _initializeControllers() {
    debugPrint(
        '🔐 PinVerificationScreen: ====== CONTROLLERS INITIALIZATION ======');
    debugPrint(
        '🔐 PinVerificationScreen: Creating 4 PIN input controllers and focus nodes');

    for (int i = 0; i < 4; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      debugPrint('🔐 PinVerificationScreen: Created controller ${i + 1}/4');
    }

    debugPrint(
        '🔐 PinVerificationScreen: All controllers initialized successfully');
    debugPrint(
        '🔐 PinVerificationScreen: Total controllers: ${_controllers.length}');
    debugPrint(
        '🔐 PinVerificationScreen: Total focus nodes: ${_focusNodes.length}');
  }

  /// Setup animation controllers for visual feedback
  /// - Shake animation: Triggered when PIN is incorrect
  /// - Pulse animation: Continuous breathing effect for lock icon
  void _setupAnimations() {
    debugPrint('🔐 PinVerificationScreen: ====== ANIMATIONS SETUP ======');

    // ================ SHAKE ANIMATION SETUP ================
    debugPrint(
        '🔐 PinVerificationScreen: Setting up shake animation for error feedback');
    _shakeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));

    debugPrint(
        '🔐 PinVerificationScreen: Shake animation configured (500ms duration, elastic curve)');

    // ================ PULSE ANIMATION SETUP ================
    debugPrint(
        '🔐 PinVerificationScreen: Setting up pulse animation for lock icon');
    _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Start continuous pulse animation
    _pulseController.repeat(reverse: true);
    debugPrint(
        '🔐 PinVerificationScreen: Pulse animation started (1000ms duration, scale 1.0-1.1)');

    debugPrint(
        '🔐 PinVerificationScreen: All animations setup completed successfully');
  }

  @override
  void dispose() {
    // ================ CLEANUP AND DISPOSAL ================
    debugPrint(
        '🔐 PinVerificationScreen: ====== SCREEN DISPOSAL STARTED ======');
    debugPrint(
        '🔐 PinVerificationScreen: Cleaning up resources and controllers');

    // Dispose text controllers
    debugPrint(
        '🔐 PinVerificationScreen: Disposing ${_controllers.length} text controllers');
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
      debugPrint('🔐 PinVerificationScreen: Disposed text controller $i');
    }

    // Dispose focus nodes
    debugPrint(
        '🔐 PinVerificationScreen: Disposing ${_focusNodes.length} focus nodes');
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].dispose();
      debugPrint('🔐 PinVerificationScreen: Disposed focus node $i');
    }

    // Dispose animation controllers
    debugPrint('🔐 PinVerificationScreen: Disposing animation controllers');
    _shakeController.dispose();
    debugPrint('🔐 PinVerificationScreen: Shake controller disposed');

    _pulseController.dispose();
    debugPrint('🔐 PinVerificationScreen: Pulse controller disposed');

    debugPrint(
        '🔐 PinVerificationScreen: All resources cleaned up successfully');
    debugPrint('🔐 PinVerificationScreen: Calling super.dispose()');
    super.dispose();
    debugPrint('🔐 PinVerificationScreen: Screen disposal completed');
  }

  /// Get the complete PIN code from all 4 input fields
  /// Combines text from all controllers into a single string
  String get _pinCode {
    final pin = _controllers.map((controller) => controller.text).join();
    debugPrint('🔐 PinVerificationScreen: Current PIN length: ${pin.length}/4');
    debugPrint(
        '🔐 PinVerificationScreen: PIN pattern: ${'*' * pin.length}${'-' * (4 - pin.length)}');
    return pin;
  }

  /// Show top-right alert dialog for PIN validation errors
  void _showPinValidationAlert(String title, String message) {
    debugPrint(
        '🚨 PinVerificationScreen: Showing PIN validation alert: $title - $message');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          backgroundColor: ThemeManager.of(context).surfaceColor,
          elevation: 8,
          title: Row(
            children: [
              Icon(
                Prbal.exclamationTriangle,
                color: ThemeManager.of(context).errorColor,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).errorColor,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeManager.of(context).textPrimary,
                height: 1.4,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: ThemeManager.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(
                'Got it',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: ThemeManager.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Extract specific PIN validation error from API response
  String _extractPinValidationError(Map<String, dynamic>? errors) {
    if (errors == null) return 'PIN validation failed. Please try again.';

    // Check for PIN-specific errors
    if (errors.containsKey('pin')) {
      final pinError = errors['pin'];
      if (pinError is String) {
        return pinError;
      } else if (pinError is List && pinError.isNotEmpty) {
        return pinError.first.toString();
      }
    }

    // Check for other common validation errors
    if (errors.containsKey('confirm_pin')) {
      final confirmPinError = errors['confirm_pin'];
      if (confirmPinError is String) {
        return confirmPinError;
      } else if (confirmPinError is List && confirmPinError.isNotEmpty) {
        return confirmPinError.first.toString();
      }
    }

    // If no specific PIN error found, return the first error available
    final firstErrorKey = errors.keys.first;
    final firstError = errors[firstErrorKey];
    if (firstError is String) {
      return firstError;
    } else if (firstError is List && firstError.isNotEmpty) {
      return firstError.first.toString();
    }

    return 'PIN validation failed. Please try again.';
  }

  /// Main PIN verification method with complete service layer integration
  /// Handles both new user registration and existing user login
  ///
  /// **🔄 AUTHENTICATION PROCESS FLOW:**
  /// 1. Validate PIN format (4 digits) → Local validation
  /// 2. Call appropriate UserService API (pinRegister or pinLogin)
  /// 3. Extract AuthTokens from API response → Type-safe token handling
  /// 4. Fetch complete user profile via UserService.getCurrentUserProfile()
  /// 5. Save AppUser data via HiveService.saveUserData()
  /// 6. Save AuthTokens via HiveService.saveAuthTokens()
  /// 7. Set login status via HiveService.setLoggedIn()
  /// 8. Navigate to appropriate dashboard based on UserType
  ///
  /// **🏗️ SERVICE LAYER INTEGRATION:**
  /// - **UserService:** pinRegister(), pinLogin(), getCurrentUserProfile()
  /// - **HiveService:** saveUserData(), saveAuthTokens(), setLoggedIn()
  /// - **AuthTokens:** Proper access + refresh token management
  /// - **AppUser:** Complete user data model with UserType
  /// - **Error Handling:** Comprehensive API and local storage error management
  Future<void> _verifyPin() async {
    debugPrint(
        '🔐 PinVerificationScreen: ====== PIN VERIFICATION STARTED ======');
    debugPrint(
        '🔐 PinVerificationScreen: PIN length validation: ${_pinCode.length}/4 digits');
    debugPrint(
        '🔐 PinVerificationScreen: Service Integration: UserService + HiveService + AuthTokens');

    // ================ PIN FORMAT VALIDATION ================
    if (_pinCode.length != 4) {
      debugPrint(
          '❌ PinVerificationScreen: PIN validation failed - incomplete PIN');
      debugPrint(
          '🔐 PinVerificationScreen: Expected: 4 digits, Got: ${_pinCode.length} digits');
      setState(() {
        _errorMessage = 'Please enter a 4-digit PIN';
      });
      return;
    }

    debugPrint('✅ PinVerificationScreen: PIN format validation passed');
    debugPrint(
        '🔐 PinVerificationScreen: Starting API verification process via UserService...');

    // ================ SET LOADING STATE ================
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    debugPrint('🔐 PinVerificationScreen: Loading state activated, UI updated');

    try {
      // ================ SERVICE PROVIDERS SETUP ================
      debugPrint('🔐 PinVerificationScreen: Initializing service providers');
      final ref = ProviderScope.containerOf(context);
      final userService = ref.read(userServiceProvider);
      final authNotifier = ref.read(authenticationStateProvider.notifier);
      debugPrint(
          '🔐 PinVerificationScreen: UserService and AuthNotifier initialized successfully');

      // ================ USER TYPE ROUTING ================
      if (widget.isNewUser) {
        debugPrint(
            '🔐 PinVerificationScreen: ====== NEW USER REGISTRATION FLOW ======');
        debugPrint(
            '🔐 PinVerificationScreen: Processing PIN registration for new user');
        debugPrint('🔐 PinVerificationScreen: Registration data:');
        debugPrint(
            '🔐 PinVerificationScreen: - Username: ${widget.userData.username}');
        debugPrint(
            '🔐 PinVerificationScreen: - Email: ${widget.userData.email}');
        debugPrint('🔐 PinVerificationScreen: - Phone: ${widget.phoneNumber}');
        debugPrint(
            '🔐 PinVerificationScreen: - First Name: ${widget.userData.firstName}');
        debugPrint(
            '🔐 PinVerificationScreen: - Last Name: ${widget.userData.lastName}');
        debugPrint(
            '🔐 PinVerificationScreen: - UserType: ${widget.userData.userType}');
        debugPrint(
            '🔐 PinVerificationScreen: - PIN Length: ${_pinCode.length} digits');

        // ================ PIN REGISTRATION API CALL ================
        debugPrint(
            '🔐 PinVerificationScreen: Calling UserService.pinRegister()...');
        final registrationResponse =
            await userService.pinRegister(PinRegistrationRequest(
          username: widget.userData.username,
          email: widget.userData.email,
          phoneNumber: widget.phoneNumber,
          pin: _pinCode,
          confirmPin: _pinCode,
          firstName: widget.userData.firstName,
          lastName: widget.userData.lastName,
        ));

        debugPrint(
            '🔐 PinVerificationScreen: PIN registration API call completed');
        debugPrint(
            '🔐 PinVerificationScreen: Response success: ${registrationResponse.isSuccess}');
        debugPrint(
            '🔐 PinVerificationScreen: Response message: ${registrationResponse.message}');

        // ================ REGISTRATION ERROR HANDLING ================
        if (!registrationResponse.isSuccess) {
          debugPrint('❌ PinVerificationScreen: PIN Registration Failed');
          debugPrint('🔐 PinVerificationScreen: Registration failure details:');
          debugPrint('🔐 PinVerificationScreen: - Status: FAILED');
          debugPrint(
              '🔐 PinVerificationScreen: - Message: ${registrationResponse.message}');
          debugPrint(
              '🔐 PinVerificationScreen: - Raw Errors: ${registrationResponse.errors}');
          debugPrint(
              '🔐 PinVerificationScreen: - Error Count: ${registrationResponse.errors?.keys.length ?? 0}');

          // Extract specific PIN validation error and show in alert dialog
          final specificError =
              _extractPinValidationError(registrationResponse.errors);
          debugPrint(
              '🔐 PinVerificationScreen: Extracted specific error: $specificError');

          // Show user-friendly error dialog
          debugPrint(
              '🔐 PinVerificationScreen: Displaying error dialog to user');
          _showPinValidationAlert('PIN Validation Error', specificError);

          // Update UI state
          debugPrint(
              '🔐 PinVerificationScreen: Updating UI state - removing loading, showing error');
          setState(() {
            _errorMessage = registrationResponse.message;
            _isLoading = false;
          });

          // Trigger shake animation and clear PIN
          debugPrint(
              '🔐 PinVerificationScreen: Triggering error animations and PIN reset');
          _shakeAndClearPin();
          return;
        }

        // ================ SUCCESSFUL REGISTRATION - TOKEN EXTRACTION ================
        debugPrint('✅ PinVerificationScreen: PIN Registration Successful!');
        debugPrint(
            '🔐 PinVerificationScreen: Extracting AuthTokens from response...');

        final tokensData =
            registrationResponse.data?['tokens'] as Map<String, dynamic>?;
        if (tokensData == null) {
          debugPrint(
              '❌ PinVerificationScreen: No tokens found in registration response');
          throw Exception('Authentication tokens not received from server');
        }

        debugPrint(
            '🔐 PinVerificationScreen: Tokens data found: ${tokensData.keys.toList()}');

        // Create AuthTokens object for type-safe token management
        final authTokens = AuthTokens(
          accessToken: tokensData['access'] ?? '',
          refreshToken: tokensData['refresh'] ?? '',
        );

        debugPrint('🔐 PinVerificationScreen: AuthTokens created successfully');
        debugPrint(
            '🔐 PinVerificationScreen: - Access Token Length: ${authTokens.accessToken.length} chars');
        debugPrint(
            '🔐 PinVerificationScreen: - Refresh Token Length: ${authTokens.refreshToken.length} chars');
        debugPrint(
            '🔐 PinVerificationScreen: - Access Token Preview: ${authTokens.accessToken.isNotEmpty ? '${authTokens.accessToken.substring(0, 20)}...' : 'EMPTY'}');

        // ================ USER DATA EXTRACTION FROM REGISTRATION ================
        debugPrint(
            '🔐 PinVerificationScreen: Extracting user data from registration response');
        final responseUserData =
            registrationResponse.data?['user'] as Map<String, dynamic>?;

        if (responseUserData == null) {
          debugPrint(
              '❌ PinVerificationScreen: No user data found in registration response');
          throw Exception('User data not received from server');
        }

        debugPrint(
            '🔐 PinVerificationScreen: User data keys received: ${responseUserData.keys.toList()}');

        // Build AppUser from registration response
        final registeredUser = AppUser.fromJson(responseUserData);
        debugPrint(
            '🔐 PinVerificationScreen: AppUser created from registration response');
        debugPrint('🔐 PinVerificationScreen: - User ID: ${registeredUser.id}');
        debugPrint(
            '🔐 PinVerificationScreen: - Username: ${registeredUser.username}');
        debugPrint(
            '🔐 PinVerificationScreen: - UserType: ${registeredUser.userType}');
        debugPrint(
            '🔐 PinVerificationScreen: - Email: ${registeredUser.email}');

        // Fetch complete, up-to-date user profile from UserService
        AppUser completeUserData = registeredUser;
        try {
          debugPrint(
              '🔄 PinVerificationScreen: Fetching complete user profile for new user...');
          final profileResponse =
              await userService.getCurrentUserProfile(authTokens.accessToken);

          if (profileResponse.isSuccess && profileResponse.data != null) {
            completeUserData = profileResponse.data!;
            debugPrint(
                '✅ PinVerificationScreen: Complete profile fetched successfully');
            debugPrint(
                '📊 PinVerificationScreen: Updated user data with complete profile information');
          } else {
            debugPrint(
                '⚠️ PinVerificationScreen: Failed to fetch complete profile, using registration data');
          }
        } catch (e) {
          debugPrint(
              '❌ PinVerificationScreen: Error fetching complete profile: $e');
          debugPrint(
              '⚠️ PinVerificationScreen: Using user data from registration response');
        }

        // ================ SAVE TO HIVE SERVICE ================
        debugPrint(
            '🔐 PinVerificationScreen: Saving authentication data via HiveService...');

        // Save AuthTokens via HiveService
        await HiveService.saveAuthTokens(authTokens);
        debugPrint('✅ PinVerificationScreen: AuthTokens saved via HiveService');

        // Save AppUser data via HiveService
        await HiveService.saveUserData(completeUserData);
        debugPrint(
            '✅ PinVerificationScreen: AppUser data saved via HiveService');

        // Set login status via HiveService
        await HiveService.setLoggedIn(true);
        debugPrint(
            '✅ PinVerificationScreen: Login status set to true via HiveService');

        // Use authentication notifier for app state management
        await authNotifier.setAuthenticated(
          user: completeUserData,
          tokens: authTokens,
        );
        debugPrint(
            '✅ PinVerificationScreen: Authentication state set via AuthNotifier');

        debugPrint('✅ NEW USER REGISTRATION COMPLETED SUCCESSFULLY');
        debugPrint(
            '🔐 PinVerificationScreen: UserType: ${completeUserData.userType}');

        if (mounted) {
          // Navigate to home/dashboard
          context.go('/home');
        }
      } else {
        // ================ EXISTING USER LOGIN FLOW ================
        debugPrint(
            '🔐 PinVerificationScreen: ====== EXISTING USER LOGIN FLOW ======');
        debugPrint(
            '🔐 PinVerificationScreen: Processing PIN login for existing user');
        debugPrint('🔐 PinVerificationScreen: Login data:');
        debugPrint(
            '🔐 PinVerificationScreen: - Phone Number: ${widget.phoneNumber}');
        debugPrint(
            '🔐 PinVerificationScreen: - UserType: ${widget.userData.userType}');
        debugPrint(
            '🔐 PinVerificationScreen: - PIN Length: ${_pinCode.length} digits');

        // ================ PIN LOGIN API CALL ================
        debugPrint(
            '🔐 PinVerificationScreen: Calling UserService.pinLogin()...');
        final loginResponse = await userService.pinLogin(PinLoginRequest(
          phoneNumber: widget.phoneNumber,
          pin: _pinCode,
        ));

        debugPrint('🔐 PinVerificationScreen: PIN login API call completed');
        debugPrint(
            '🔐 PinVerificationScreen: Response success: ${loginResponse.isSuccess}');
        debugPrint(
            '🔐 PinVerificationScreen: Response message: ${loginResponse.message}');

        // ================ LOGIN ERROR HANDLING ================
        if (!loginResponse.isSuccess) {
          debugPrint('❌ PinVerificationScreen: PIN Login Failed');
          debugPrint('🔐 PinVerificationScreen: Login failure details:');
          debugPrint('🔐 PinVerificationScreen: - Status: FAILED');
          debugPrint(
              '🔐 PinVerificationScreen: - Message: ${loginResponse.message}');
          debugPrint(
              '🔐 PinVerificationScreen: - Raw Errors: ${loginResponse.errors}');
          debugPrint(
              '🔐 PinVerificationScreen: - Error Count: ${loginResponse.errors?.keys.length ?? 0}');

          // Extract specific PIN validation error and show in alert dialog
          final specificError =
              _extractPinValidationError(loginResponse.errors);
          debugPrint(
              '🔐 PinVerificationScreen: Extracted specific error: $specificError');

          // Show user-friendly error dialog
          debugPrint(
              '🔐 PinVerificationScreen: Displaying error dialog to user');
          _showPinValidationAlert('PIN Login Error', specificError);

          // Update UI state
          debugPrint(
              '🔐 PinVerificationScreen: Updating UI state - removing loading, showing error');
          setState(() {
            _errorMessage = loginResponse.message;
            _isLoading = false;
          });

          // Trigger shake animation and clear PIN
          debugPrint(
              '🔐 PinVerificationScreen: Triggering error animations and PIN reset');
          _shakeAndClearPin();
          return;
        }

        // ================ SUCCESSFUL LOGIN - TOKEN EXTRACTION ================
        debugPrint('✅ PinVerificationScreen: PIN Login Successful!');
        debugPrint(
            '🔐 PinVerificationScreen: Extracting AuthTokens from login response...');

        final tokensData =
            loginResponse.data?['tokens'] as Map<String, dynamic>?;
        AuthTokens? authTokens;

        if (tokensData != null) {
          authTokens = AuthTokens(
            accessToken: tokensData['access'] ?? '',
            refreshToken: tokensData['refresh'] ?? '',
          );
          debugPrint(
              '🔐 PinVerificationScreen: AuthTokens extracted from tokens field');
        } else {
          // Alternative token locations in response
          final accessToken = loginResponse.data?['access_token'] as String? ??
              loginResponse.data?['access'] as String?;
          final refreshToken =
              loginResponse.data?['refresh_token'] as String? ??
                  loginResponse.data?['refresh'] as String?;

          if (accessToken != null) {
            authTokens = AuthTokens(
              accessToken: accessToken,
              refreshToken: refreshToken ?? '',
            );
            debugPrint(
                '🔐 PinVerificationScreen: AuthTokens extracted from alternative locations');
          }
        }

        if (authTokens == null || authTokens.accessToken.isEmpty) {
          debugPrint(
              '❌ PinVerificationScreen: No valid tokens found in login response');
          throw Exception('Authentication tokens not received from server');
        }

        debugPrint('🔐 PinVerificationScreen: AuthTokens created successfully');
        debugPrint(
            '🔐 PinVerificationScreen: - Access Token Length: ${authTokens.accessToken.length} chars');
        debugPrint(
            '🔐 PinVerificationScreen: - Refresh Token Length: ${authTokens.refreshToken.length} chars');

        // ================ USER DATA EXTRACTION FROM LOGIN ================
        debugPrint(
            '🔐 PinVerificationScreen: Extracting user data from login response...');
        final loginUserData = AppUser.fromJson(loginResponse.data?['user']);
        debugPrint(
            '🔐 PinVerificationScreen: AppUser created from login response');
        debugPrint('🔐 PinVerificationScreen: - User ID: ${loginUserData.id}');
        debugPrint(
            '🔐 PinVerificationScreen: - UserType: ${loginUserData.userType}');

        // Fetch complete, up-to-date user profile from UserService
        AppUser completeUserData = loginUserData;
        try {
          debugPrint(
              '🔄 PinVerificationScreen: Fetching complete user profile for existing user...');
          final profileResponse =
              await userService.getCurrentUserProfile(authTokens.accessToken);

          if (profileResponse.isSuccess && profileResponse.data != null) {
            completeUserData = profileResponse.data!;
            debugPrint(
                '✅ PinVerificationScreen: Complete profile fetched successfully');
            debugPrint(
                '📊 PinVerificationScreen: Updated user data with complete, up-to-date profile information');
          } else {
            debugPrint(
                '⚠️ PinVerificationScreen: Failed to fetch complete profile, using login response data');
          }
        } catch (e) {
          debugPrint(
              '❌ PinVerificationScreen: Error fetching complete profile: $e');
          debugPrint(
              '⚠️ PinVerificationScreen: Using user data from login response');
        }

        // ================ SAVE TO HIVE SERVICE ================
        debugPrint(
            '🔐 PinVerificationScreen: Saving authentication data via HiveService...');

        // Save AuthTokens via HiveService
        await HiveService.saveAuthTokens(authTokens);
        debugPrint('✅ PinVerificationScreen: AuthTokens saved via HiveService');

        // Save AppUser data via HiveService
        await HiveService.saveUserData(completeUserData);
        debugPrint(
            '✅ PinVerificationScreen: AppUser data saved via HiveService');

        // Set login status via HiveService
        await HiveService.setLoggedIn(true);
        debugPrint(
            '✅ PinVerificationScreen: Login status set to true via HiveService');

        // Use authentication notifier for app state management
        await authNotifier.setAuthenticated(
          user: completeUserData,
          tokens: authTokens,
        );
        debugPrint(
            '✅ PinVerificationScreen: Authentication state set via AuthNotifier');

        debugPrint('✅ EXISTING USER LOGIN COMPLETED SUCCESSFULLY');
        debugPrint(
            '🔐 PinVerificationScreen: UserType: ${completeUserData.userType}');

        if (mounted) {
          // Navigate based on UserType
          debugPrint(
              '🧭 PinVerificationScreen: Navigating user based on UserType: ${completeUserData.userType}');

          switch (completeUserData.userType) {
            case UserType.admin:
              debugPrint(
                  '🧭 PinVerificationScreen: Navigating to admin dashboard');
              context.go(RouteEnum.adminDashboard.rawValue);
              break;
            case UserType.provider:
              debugPrint(
                  '🧭 PinVerificationScreen: Navigating to provider dashboard');
              context.go(RouteEnum.providerDashboard.rawValue);
              break;
            case UserType.customer:
              debugPrint(
                  '🧭 PinVerificationScreen: Navigating to customer dashboard');
              context.go(RouteEnum.takerDashboard.rawValue);
              break;
          }
        }
      }
    } catch (e, stackTrace) {
      // ================ CRITICAL ERROR HANDLING ================
      debugPrint(
          '❌ PinVerificationScreen: ====== CRITICAL ERROR OCCURRED ======');
      debugPrint('🔐 PinVerificationScreen: Critical error details:');
      debugPrint('🔐 PinVerificationScreen: - Error Type: ${e.runtimeType}');
      debugPrint('🔐 PinVerificationScreen: - Error Message: $e');
      debugPrint(
          '🔐 PinVerificationScreen: - Stack Trace Preview: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      debugPrint(
          '🔐 PinVerificationScreen: - UserType: ${widget.userData.userType}');
      debugPrint(
          '🔐 PinVerificationScreen: - Is New User: ${widget.isNewUser}');
      debugPrint(
          '🔐 PinVerificationScreen: - Phone Number: ${widget.phoneNumber}');

      // Update UI with generic error message
      debugPrint(
          '🔐 PinVerificationScreen: Setting generic error message and removing loading state');
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
        _isLoading = false;
      });

      // Trigger error animations
      debugPrint(
          '🔐 PinVerificationScreen: Triggering error recovery animations');
      _shakeAndClearPin();

      debugPrint('🔐 PinVerificationScreen: Error handling completed');
    }
  }

  /// Trigger shake animation and clear PIN on error
  /// Provides visual feedback when PIN verification fails
  void _shakeAndClearPin() {
    debugPrint(
        '🔐 PinVerificationScreen: ====== ERROR ANIMATION SEQUENCE ======');
    debugPrint('🔐 PinVerificationScreen: Starting shake animation...');

    _shakeController.forward().then((_) {
      debugPrint(
          '🔐 PinVerificationScreen: Shake animation completed, resetting controller');
      _shakeController.reset();
      debugPrint('🔐 PinVerificationScreen: Clearing PIN input fields');
      _clearPin();
    });
  }

  /// Clear all PIN input fields and focus on first field
  /// Used after errors or when resetting PIN entry
  void _clearPin() {
    debugPrint('🔐 PinVerificationScreen: Clearing all PIN input controllers');

    for (int i = 0; i < _controllers.length; i++) {
      final previousText = _controllers[i].text;
      _controllers[i].clear();
      debugPrint(
          '🔐 PinVerificationScreen: Cleared controller $i (was: "${previousText.isNotEmpty ? '*' : 'empty'}")');
    }

    debugPrint(
        '🔐 PinVerificationScreen: Setting focus to first PIN input field');
    _focusNodes[0].requestFocus();
    debugPrint('🔐 PinVerificationScreen: PIN reset completed');
  }

  /// Get user type display name for UI
  String getUserTypeDisplayName(UserType userType) {
    switch (userType) {
      case UserType.admin:
        return 'Administrator';
      case UserType.provider:
        return 'Service Provider';
      case UserType.customer:
        return 'Customer';
    }
  }

  /// Get display name from AppUser data
  String getDisplayName() {
    final firstName = widget.userData.firstName;
    final lastName = widget.userData.lastName;
    final username = widget.userData.username;

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (username.isNotEmpty) {
      return username;
    }
    return 'User';
  }

  /// Get username from AppUser data
  String? _getUsername() {
    return widget.userData.username;
  }

  /// Get UserType from AppUser data
  UserType _getUserType() {
    return widget.userData.userType;
  }

  @override
  Widget build(BuildContext context) {
    // ================ UI BUILD PROCESS ================
    debugPrint('🔐 PinVerificationScreen: ====== UI BUILD STARTED ======');

    debugPrint(
        '🔐 PinVerificationScreen: Theme manager initialized successfully');

    // Log current screen state for debugging
    debugPrint('🔐 PinVerificationScreen: Current UI state:');
    debugPrint('🔐 PinVerificationScreen: - Loading: $_isLoading');
    debugPrint(
        '🔐 PinVerificationScreen: - Error Message: ${_errorMessage ?? 'none'}');
    debugPrint('🔐 PinVerificationScreen: - PIN Length: ${_pinCode.length}/4');
    debugPrint(
        '🔐 PinVerificationScreen: - UserType: ${widget.userData.userType}');
    debugPrint('🔐 PinVerificationScreen: - Display Name: ${getDisplayName()}');

    // Log theme properties being used
    debugPrint('🔐 PinVerificationScreen: Theme properties:');
    debugPrint(
        '🔐 PinVerificationScreen: - Background Color: ${ThemeManager.of(context).backgroundColor}');
    debugPrint(
        '🔐 PinVerificationScreen: - Primary Color: ${ThemeManager.of(context).primaryColor}');
    debugPrint(
        '🔐 PinVerificationScreen: - Text Primary: ${ThemeManager.of(context).textPrimary}');
    debugPrint(
        '🔐 PinVerificationScreen: - User Type Color: ${ThemeManager.of(context).getUserTypeColor(_getUserType())}');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Prbal.chevronLeft3,
            color: ThemeManager.of(context).textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),

                // Header Card
                Card(
                  elevation: 4,
                  shadowColor: ThemeManager.of(context)
                      .textTertiary
                      .withValues(alpha: 77),
                  child: Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: ThemeManager.of(context).surfaceGradient,
                    ),
                    child: Column(
                      children: [
                        // User Info Section (only show if userData is available)
                        if (!widget.isNewUser) ...[
                          SizedBox(height: 16.h),

                          // User Type Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: ThemeManager.of(context)
                                  .getUserTypeColor(_getUserType())
                                  .withValues(alpha: 26),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: ThemeManager.of(context)
                                    .getUserTypeColor(_getUserType())
                                    .withValues(alpha: 77),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  getUserTypeIcon(_getUserType()),
                                  size: 16.sp,
                                  color: ThemeManager.of(context)
                                      .getUserTypeColor(_getUserType()),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  getUserTypeDisplayName(_getUserType()),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ThemeManager.of(context)
                                        .getUserTypeColor(_getUserType()),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],

                        // New User Welcome Section
                        if (widget.isNewUser) ...[
                          // Welcome New User
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: ThemeManager.of(context)
                                  .primaryColor
                                  .withValues(alpha: 26),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ThemeManager.of(context)
                                    .primaryColor
                                    .withValues(alpha: 77),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Prbal.stars,
                                      size: 20.sp,
                                      color:
                                          ThemeManager.of(context).primaryColor,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Welcome to Prbal!',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ThemeManager.of(context)
                                            .primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Hello ${getDisplayName()},',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeManager.of(context).textPrimary,
                                  ),
                                ),
                                if (_getUsername() != null) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Username: @${_getUsername()}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: ThemeManager.of(context)
                                          .textSecondary,
                                    ),
                                  ),
                                ],
                                ...[
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        getUserTypeIcon(_getUserType()),
                                        size: 14.sp,
                                        color: ThemeManager.of(context)
                                            .getUserTypeColor(_getUserType()),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'Account Type: ${getUserTypeDisplayName(_getUserType())}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeManager.of(context)
                                              .getUserTypeColor(_getUserType()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],

                        // Lock icon with animation
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 80.w,
                                height: 80.h,
                                decoration: BoxDecoration(
                                  gradient:
                                      ThemeManager.of(context).primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  widget.isNewUser
                                      ? Prbal.lockOpen2
                                      : Prbal.lockStripes1,
                                  size: 40.sp,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 24.h),

                        Text(
                          widget.isNewUser
                              ? 'Create Your PIN'
                              : 'Enter Your PIN',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: ThemeManager.of(context).textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 12.h),

                        Text(
                          widget.isNewUser
                              ? 'Set a 4-digit PIN to secure your account'
                              : 'Enter your 4-digit PIN to continue',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ThemeManager.of(context).textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16.h),

                        // Phone Number Display
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: ThemeManager.of(context)
                                .primaryColor
                                .withValues(alpha: 26),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: ThemeManager.of(context)
                                  .primaryColor
                                  .withValues(alpha: 77),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Prbal.phone,
                                size: 16.sp,
                                color: ThemeManager.of(context).primaryColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                widget.phoneNumber,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ThemeManager.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                // PIN Input Fields with shake animation
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                          _shakeAnimation.value *
                              10 *
                              (1 - 2 * _shakeAnimation.value).abs(),
                          0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          final isActive = _controllers[index].text.isNotEmpty;
                          return Container(
                            width: 65.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                              gradient: isActive
                                  ? ThemeManager.of(context).primaryGradient
                                  : null,
                              color: isActive
                                  ? null
                                  : ThemeManager.of(context).surfaceColor,
                              border: Border.all(
                                color: isActive
                                    ? ThemeManager.of(context).primaryColor
                                    : ThemeManager.of(context).borderColor,
                                width: isActive ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              obscureText: true,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: ThemeManager.of(context).textPrimary,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 3) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else {
                                    _focusNodes[index].unfocus();
                                    _verifyPin();
                                  }
                                } else if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                                setState(() {});
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),

                if (_errorMessage != null) SizedBox(height: 32.h),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ThemeManager.of(context)
                          .errorColor
                          .withValues(alpha: 26),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: ThemeManager.of(context)
                              .errorColor
                              .withValues(alpha: 77),
                          width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Prbal.exclamationTriangle,
                          color: ThemeManager.of(context).errorColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: ThemeManager.of(context).errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 32.h),

                // Verify/Set PIN Button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 2.h),
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: ThemeManager.of(context).primaryGradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyPin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              color: ThemeManager.of(context).onPrimaryColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.isNewUser ? Prbal.check : Prbal.unlock,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                widget.isNewUser ? 'Set PIN' : 'Verify PIN',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // Security note
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 2.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(),
                  child: Row(
                    children: [
                      Icon(
                        Prbal.shield4,
                        color: ThemeManager.of(context).primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          widget.isNewUser
                              ? 'Your PIN will be used to secure your account'
                              : 'Keep your PIN confidential and secure',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ThemeManager.of(context).textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
