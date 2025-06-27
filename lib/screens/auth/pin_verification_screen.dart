import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/service_providers.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';

/// PIN Verification Screen for handling user authentication
///
/// This screen serves dual purposes:
/// 1. For NEW USERS: PIN creation during registration process
/// 2. For EXISTING USERS: PIN verification during login process
///
/// Features:
/// - 4-digit PIN input with visual feedback
/// - Real-time validation and error handling
/// - Animated UI elements for better UX
/// - Comprehensive debugging and error logging
/// - Theme-aware design with gradients and shadows
/// - Automatic navigation based on user type (Admin/Provider/Customer)
///
/// Data Flow:
/// 1. User enters 4-digit PIN
/// 2. App validates PIN format (4 digits)
/// 3. For new users: Call pinRegister API
/// 4. For existing users: Call pinLogin API
/// 5. Extract authentication tokens from response
/// 6. Fetch complete user profile
/// 7. Save user data to local storage (Hive)
/// 8. Navigate to appropriate dashboard
class PinVerificationScreen extends ConsumerStatefulWidget {
  /// Phone number for verification (required for API calls)
  final String phoneNumber;

  /// Flag to determine if this is a new user registration or existing user login
  final bool isNewUser;

  /// User data object containing profile information
  final AppUser userData;

  const PinVerificationScreen({super.key, required this.phoneNumber, required this.userData, required this.isNewUser});

  @override
  ConsumerState<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends ConsumerState<PinVerificationScreen> with TickerProviderStateMixin {
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
    debugPrint('🔐 PinVerificationScreen: User Type: ${widget.userData.userType}');
    debugPrint('🔐 PinVerificationScreen: User ID: ${widget.userData.id}');
    debugPrint('🔐 PinVerificationScreen: Username: ${widget.userData.username}');
    debugPrint('🔐 PinVerificationScreen: Display Name: ${widget.userData.firstName} ${widget.userData.lastName}');
    debugPrint('🔐 PinVerificationScreen: Email: ${widget.userData.email}');

    // Initialize controllers and animations
    _initializeControllers();
    _setupAnimations();

    debugPrint('🔐 PinVerificationScreen: Initialization completed successfully');
  }

  /// Initialize PIN input controllers and focus nodes
  /// Creates 4 text controllers and focus nodes for each PIN digit
  void _initializeControllers() {
    debugPrint('🔐 PinVerificationScreen: ====== CONTROLLERS INITIALIZATION ======');
    debugPrint('🔐 PinVerificationScreen: Creating 4 PIN input controllers and focus nodes');

    for (int i = 0; i < 4; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      debugPrint('🔐 PinVerificationScreen: Created controller ${i + 1}/4');
    }

    debugPrint('🔐 PinVerificationScreen: All controllers initialized successfully');
    debugPrint('🔐 PinVerificationScreen: Total controllers: ${_controllers.length}');
    debugPrint('🔐 PinVerificationScreen: Total focus nodes: ${_focusNodes.length}');
  }

  /// Setup animation controllers for visual feedback
  /// - Shake animation: Triggered when PIN is incorrect
  /// - Pulse animation: Continuous breathing effect for lock icon
  void _setupAnimations() {
    debugPrint('🔐 PinVerificationScreen: ====== ANIMATIONS SETUP ======');

    // ================ SHAKE ANIMATION SETUP ================
    debugPrint('🔐 PinVerificationScreen: Setting up shake animation for error feedback');
    _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));

    debugPrint('🔐 PinVerificationScreen: Shake animation configured (500ms duration, elastic curve)');

    // ================ PULSE ANIMATION SETUP ================
    debugPrint('🔐 PinVerificationScreen: Setting up pulse animation for lock icon');
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Start continuous pulse animation
    _pulseController.repeat(reverse: true);
    debugPrint('🔐 PinVerificationScreen: Pulse animation started (1000ms duration, scale 1.0-1.1)');

    debugPrint('🔐 PinVerificationScreen: All animations setup completed successfully');
  }

  @override
  void dispose() {
    // ================ CLEANUP AND DISPOSAL ================
    debugPrint('🔐 PinVerificationScreen: ====== SCREEN DISPOSAL STARTED ======');
    debugPrint('🔐 PinVerificationScreen: Cleaning up resources and controllers');

    // Dispose text controllers
    debugPrint('🔐 PinVerificationScreen: Disposing ${_controllers.length} text controllers');
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
      debugPrint('🔐 PinVerificationScreen: Disposed text controller $i');
    }

    // Dispose focus nodes
    debugPrint('🔐 PinVerificationScreen: Disposing ${_focusNodes.length} focus nodes');
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

    debugPrint('🔐 PinVerificationScreen: All resources cleaned up successfully');
    debugPrint('🔐 PinVerificationScreen: Calling super.dispose()');
    super.dispose();
    debugPrint('🔐 PinVerificationScreen: Screen disposal completed');
  }

  /// Get the complete PIN code from all 4 input fields
  /// Combines text from all controllers into a single string
  String get _pinCode {
    final pin = _controllers.map((controller) => controller.text).join();
    debugPrint('🔐 PinVerificationScreen: Current PIN length: ${pin.length}/4');
    debugPrint('🔐 PinVerificationScreen: PIN pattern: ${'*' * pin.length}${'-' * (4 - pin.length)}');
    return pin;
  }

  /// Show top-right alert dialog for PIN validation errors
  void _showPinValidationAlert(String title, String message) {
    final themeManager = ThemeManager.of(context);
    debugPrint('🚨 PinVerificationScreen: Showing PIN validation alert: $title - $message');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          backgroundColor: themeManager.surfaceColor,
          elevation: 8,
          title: Row(
            children: [
              Icon(
                Prbal.exclamationTriangle,
                color: themeManager.errorColor,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.errorColor,
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
                color: themeManager.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: themeManager.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(
                'Got it',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: themeManager.primaryColor,
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

  /// Main PIN verification method
  /// Handles both new user registration and existing user login
  ///
  /// Process Flow:
  /// 1. Validate PIN format (4 digits)
  /// 2. Call appropriate API (registration or login)
  /// 3. Extract authentication tokens
  /// 4. Fetch complete user profile
  /// 5. Save data locally
  /// 6. Navigate to dashboard
  Future<void> _verifyPin() async {
    debugPrint('🔐 PinVerificationScreen: ====== PIN VERIFICATION STARTED ======');
    debugPrint('🔐 PinVerificationScreen: PIN length validation: ${_pinCode.length}/4 digits');

    // ================ PIN FORMAT VALIDATION ================
    if (_pinCode.length != 4) {
      debugPrint('❌ PinVerificationScreen: PIN validation failed - incomplete PIN');
      debugPrint('🔐 PinVerificationScreen: Expected: 4 digits, Got: ${_pinCode.length} digits');
      setState(() {
        _errorMessage = 'Please enter a 4-digit PIN';
      });
      return;
    }

    debugPrint('✅ PinVerificationScreen: PIN format validation passed');
    debugPrint('🔐 PinVerificationScreen: Starting API verification process...');

    // ================ SET LOADING STATE ================
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    debugPrint('🔐 PinVerificationScreen: Loading state activated, UI updated');

    try {
      // ================ SERVICE PROVIDERS SETUP ================
      debugPrint('🔐 PinVerificationScreen: Initializing service providers');
      final userService = ref.read(userServiceProvider);
      final authNotifier = ref.read(authenticationStateProvider.notifier);
      debugPrint('🔐 PinVerificationScreen: Service providers initialized successfully');

      // ================ USER TYPE ROUTING ================
      if (widget.isNewUser) {
        debugPrint('🔐 PinVerificationScreen: ====== NEW USER REGISTRATION FLOW ======');
        debugPrint('🔐 PinVerificationScreen: Processing PIN registration for new user');
        debugPrint('🔐 PinVerificationScreen: Registration data:');
        debugPrint('🔐 PinVerificationScreen: - Username: ${widget.userData.username}');
        debugPrint('🔐 PinVerificationScreen: - Email: ${widget.userData.email}');
        debugPrint('🔐 PinVerificationScreen: - Phone: ${widget.phoneNumber}');
        debugPrint('🔐 PinVerificationScreen: - First Name: ${widget.userData.firstName}');
        debugPrint('🔐 PinVerificationScreen: - Last Name: ${widget.userData.lastName}');
        debugPrint('🔐 PinVerificationScreen: - PIN Length: ${_pinCode.length} digits');

        // ================ PIN REGISTRATION API CALL ================
        debugPrint('🔐 PinVerificationScreen: Calling pinRegister API...');
        final setPinResponse = await userService.pinRegister(PinRegistrationRequest(
          username: widget.userData.username,
          email: widget.userData.email,
          phoneNumber: widget.phoneNumber,
          pin: _pinCode,
          confirmPin: _pinCode,
          firstName: widget.userData.firstName,
          lastName: widget.userData.lastName,
        ));

        debugPrint('🔐 PinVerificationScreen: PIN registration API call completed');
        debugPrint('🔐 PinVerificationScreen: Response success: ${setPinResponse.success}');
        debugPrint('🔐 PinVerificationScreen: Response message: ${setPinResponse.message}');

        // ================ REGISTRATION ERROR HANDLING ================
        if (!setPinResponse.success) {
          debugPrint('❌ PinVerificationScreen: PIN Registration Failed');
          debugPrint('🔐 PinVerificationScreen: Registration failure details:');
          debugPrint('🔐 PinVerificationScreen: - Status: FAILED');
          debugPrint('🔐 PinVerificationScreen: - Message: ${setPinResponse.message}');
          debugPrint('🔐 PinVerificationScreen: - Raw Errors: ${setPinResponse.errors}');
          debugPrint('🔐 PinVerificationScreen: - Error Count: ${setPinResponse.errors?.keys.length ?? 0}');

          // Extract specific PIN validation error and show in alert dialog
          final specificError = _extractPinValidationError(setPinResponse.errors);
          debugPrint('🔐 PinVerificationScreen: Extracted specific error: $specificError');

          // Show user-friendly error dialog
          debugPrint('🔐 PinVerificationScreen: Displaying error dialog to user');
          _showPinValidationAlert('PIN Validation Error', specificError);

          // Update UI state
          debugPrint('🔐 PinVerificationScreen: Updating UI state - removing loading, showing error');
          setState(() {
            _errorMessage = setPinResponse.message;
            _isLoading = false;
          });

          // Trigger shake animation and clear PIN
          debugPrint('🔐 PinVerificationScreen: Triggering error animations and PIN reset');
          _shakeAndClearPin();
          return;
        }

        // ================ SUCCESSFUL REGISTRATION - TOKEN EXTRACTION ================
        debugPrint('✅ PinVerificationScreen: PIN Registration Successful!');
        debugPrint('🔐 PinVerificationScreen: Extracting authentication tokens from response');

        final tokens = setPinResponse.data?['tokens'] as Map<String, dynamic>?;
        if (tokens == null) {
          debugPrint('❌ PinVerificationScreen: No tokens found in registration response');
          throw Exception('Authentication tokens not received from server');
        }

        debugPrint('🔐 PinVerificationScreen: Tokens object found: ${tokens.keys.toList()}');

        String accessToken;
        String refreshToken;

        accessToken = tokens['access'] ?? '';
        refreshToken = tokens['refresh'] ?? '';

        debugPrint('🔐 PinVerificationScreen: Token extraction results:');
        debugPrint('🔐 PinVerificationScreen: - Access Token Length: ${accessToken.length} chars');
        debugPrint('🔐 PinVerificationScreen: - Refresh Token Length: ${refreshToken.length} chars');
        debugPrint(
            '🔐 PinVerificationScreen: - Access Token Preview: ${accessToken.isNotEmpty ? '${accessToken.substring(0, 20)}...' : 'EMPTY'}');
        debugPrint(
            '🔐 PinVerificationScreen: - Refresh Token Preview: ${refreshToken.isNotEmpty ? '${refreshToken.substring(0, 20)}...' : 'EMPTY'}');

        // ================ USER DATA EXTRACTION FROM REGISTRATION ================
        debugPrint('🔐 PinVerificationScreen: Extracting user data from registration response');
        final responseUserData = setPinResponse.data?['user'] as Map<String, dynamic>?;

        if (responseUserData == null) {
          debugPrint('❌ PinVerificationScreen: No user data found in registration response');
          throw Exception('User data not received from server');
        }

        debugPrint('🔐 PinVerificationScreen: User data keys received: ${responseUserData.keys.toList()}');

        final UserType userType = _parseUserType(responseUserData['user_type']) ?? widget.userData.userType;
        debugPrint('🔐 PinVerificationScreen: User type determination:');
        debugPrint('🔐 PinVerificationScreen: - Response user_type: ${responseUserData['user_type']}');
        debugPrint('🔐 PinVerificationScreen: - Widget userData userType: ${widget.userData.userType}');
        debugPrint('🔐 PinVerificationScreen: - Final determined userType: $userType');

        // Build initial user data
        final initialUserData = AppUser(
          id: responseUserData['id'],
          username: responseUserData['username'] ?? widget.userData.username,
          email: responseUserData['email'] ?? widget.userData.email,
          firstName: responseUserData['first_name'] ?? widget.userData.firstName,
          lastName: responseUserData['last_name'] ?? widget.userData.lastName,
          phoneNumber: widget.phoneNumber,
          userType: userType,
          isVerified: responseUserData['is_verified'] ?? false,
          createdAt: responseUserData['created_at'] ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Fetch complete, up-to-date user profile from UserService
        AppUser completeUserData = initialUserData;
        try {
          debugPrint('🔄 Fetching complete user profile for new user...');
          final profileResponse = await userService.getCurrentUserProfile(accessToken);

          if (profileResponse.isSuccess && profileResponse.data != null) {
            final userProfile = profileResponse.data!;
            debugPrint('✅ Complete profile fetched successfully');

            // Convert AppUser to Map and merge with initial data
            completeUserData = AppUser(
              id: userProfile.id,
              username: userProfile.username,
              email: userProfile.email,
              firstName: userProfile.firstName,
              lastName: userProfile.lastName,
              phoneNumber: userProfile.phoneNumber ?? widget.phoneNumber,
              userType: userProfile.userType,
              isVerified: userProfile.isVerified,
              isEmailVerified: userProfile.isEmailVerified,
              isPhoneVerified: userProfile.isPhoneVerified,
              rating: userProfile.rating,
              balance: userProfile.balance,
              totalBookings: userProfile.totalBookings,
              bio: userProfile.bio,
              location: userProfile.location,
              profilePicture: userProfile.profilePicture,
              createdAt: userProfile.createdAt,
              updatedAt: userProfile.updatedAt,
              skills: userProfile.skills,
              availability: userProfile.availability,
            );
            debugPrint('📊 Updated user data with complete profile information');
          } else {
            debugPrint('⚠️ Failed to fetch complete profile, using initial data');
          }
        } catch (e) {
          debugPrint('❌ Error fetching complete profile: $e');
          debugPrint('⚠️ Using initial user data from registration response');
        }

        // Use authentication provider to manage state
        await authNotifier.setAuthenticated(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userData: completeUserData,
          userType: userType,
        );
        debugPrint('✅ New user authentication state set successfully');

        // Also update HiveService with complete user data
        await HiveService.saveUserData(completeUserData);
        await HiveService.saveUserProfile(completeUserData);
        debugPrint('💾 Complete user data saved to HiveService');

        debugPrint('✅ New user data saved successfully with userType: $userType');

        if (mounted) {
          // Navigate to appropriate dashboard based on user type
          context.go('/home');
        }
      } else {
        // ================ EXISTING USER LOGIN FLOW ================
        debugPrint('🔐 PinVerificationScreen: ====== EXISTING USER LOGIN FLOW ======');
        debugPrint('🔐 PinVerificationScreen: Processing PIN login for existing user');
        debugPrint('🔐 PinVerificationScreen: Login data:');
        debugPrint('🔐 PinVerificationScreen: - Phone Number: ${widget.phoneNumber}');
        debugPrint('🔐 PinVerificationScreen: - PIN Length: ${_pinCode.length} digits');

        // ================ PIN LOGIN API CALL ================
        debugPrint('🔐 PinVerificationScreen: Calling pinLogin API...');
        final response = await userService.pinLogin(PinLoginRequest(
          phoneNumber: widget.phoneNumber,
          pin: _pinCode,
        ));

        debugPrint('🔐 PinVerificationScreen: PIN login API call completed');
        debugPrint('🔐 PinVerificationScreen: Response success: ${response.success}');
        debugPrint('🔐 PinVerificationScreen: Response message: ${response.message}');

        // ================ LOGIN ERROR HANDLING ================
        if (!response.success) {
          debugPrint('❌ PinVerificationScreen: PIN Login Failed');
          debugPrint('🔐 PinVerificationScreen: Login failure details:');
          debugPrint('🔐 PinVerificationScreen: - Status: FAILED');
          debugPrint('🔐 PinVerificationScreen: - Message: ${response.message}');
          debugPrint('🔐 PinVerificationScreen: - Raw Errors: ${response.errors}');
          debugPrint('🔐 PinVerificationScreen: - Error Count: ${response.errors?.keys.length ?? 0}');

          // Extract specific PIN validation error and show in alert dialog
          final specificError = _extractPinValidationError(response.errors);
          debugPrint('🔐 PinVerificationScreen: Extracted specific error: $specificError');

          // Show user-friendly error dialog
          debugPrint('🔐 PinVerificationScreen: Displaying error dialog to user');
          _showPinValidationAlert('PIN Login Error', specificError);

          // Update UI state
          debugPrint('🔐 PinVerificationScreen: Updating UI state - removing loading, showing error');
          setState(() {
            _errorMessage = response.message;
            _isLoading = false;
          });

          // Trigger shake animation and clear PIN
          debugPrint('🔐 PinVerificationScreen: Triggering error animations and PIN reset');
          _shakeAndClearPin();
          return;
        }

        // CRITICAL FIX: Extract and save authentication tokens from login response
        final tokens = response.data?['tokens'] as Map<String, dynamic>?;
        String? accessToken;
        String? refreshToken;

        if (tokens != null) {
          accessToken = tokens['access'] as String?;
          refreshToken = tokens['refresh'] as String?;
        } else {
          debugPrint('⚠️ No tokens found in login response - checking alternative locations');
          // Alternative token locations in response
          accessToken = response.data?['access_token'] as String? ?? response.data?['access'] as String?;
          refreshToken = response.data?['refresh_token'] as String? ?? response.data?['refresh'] as String?;
        }

        // Get initial user data from login response
        debugPrint('🔍 Processing login response for existing user...');
        final AppUser userData = AppUser.fromJson(response.data?['user']);
        final userType = userData.userType;

        debugPrint('✅ Successfully retrieved initial user data with type: $userType');

        // Build initial user data from login response
        final initialUserData = AppUser(
          id: userData.id,
          username: userData.username,
          email: userData.email,
          firstName: userData.firstName,
          lastName: userData.lastName,
          phoneNumber: widget.phoneNumber,
          userType: userType,
          isVerified: userData.isVerified,
          isEmailVerified: userData.isEmailVerified,
          isPhoneVerified: userData.isPhoneVerified,
          rating: userData.rating,
          balance: userData.balance,
          totalBookings: userData.totalBookings,
          bio: userData.bio,
          location: userData.location,
          profilePicture: userData.profilePicture,
          createdAt: userData.createdAt,
          updatedAt: userData.updatedAt,
        );

        // Fetch complete, up-to-date user profile from UserService
        AppUser completeUserData = initialUserData;
        if (accessToken != null) {
          try {
            debugPrint('🔄 Fetching complete user profile for existing user...');
            final profileResponse = await userService.getCurrentUserProfile(accessToken);

            if (profileResponse.isSuccess && profileResponse.data != null) {
              final userProfile = profileResponse.data!;
              debugPrint('✅ Complete profile fetched successfully');

              // Convert AppUser to Map with all up-to-date information
              completeUserData = AppUser(
                id: userProfile.id,
                username: userProfile.username,
                email: userProfile.email,
                firstName: userProfile.firstName,
                lastName: userProfile.lastName,
                phoneNumber: userProfile.phoneNumber ?? widget.phoneNumber,
                userType: userProfile.userType,
                isVerified: userProfile.isVerified,
                isEmailVerified: userProfile.isEmailVerified,
                isPhoneVerified: userProfile.isPhoneVerified,
                rating: userProfile.rating,
                balance: userProfile.balance,
                totalBookings: userProfile.totalBookings,
                bio: userProfile.bio,
                location: userProfile.location,
                profilePicture: userProfile.profilePicture,
                createdAt: userProfile.createdAt,
                updatedAt: userProfile.updatedAt,
                skills: userProfile.skills,
                availability: userProfile.availability,
              );
              debugPrint('📊 Updated user data with complete, up-to-date profile information');
            } else {
              debugPrint('⚠️ Failed to fetch complete profile, using login response data');
            }
          } catch (e) {
            debugPrint('❌ Error fetching complete profile: $e');
            debugPrint('⚠️ Using user data from login response');
          }
        }

        // Use authentication provider to manage state
        if (accessToken != null) {
          await authNotifier.setAuthenticated(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userData: completeUserData,
            userType: userType,
          );
          debugPrint('✅ Existing user authentication state set successfully');

          // Also update HiveService with complete, up-to-date user data
          await HiveService.saveUserData(completeUserData);
          await HiveService.saveUserProfile(completeUserData);
          debugPrint('💾 Complete user data saved to HiveService');
        } else {
          // Fallback to manual HiveService if no tokens
          debugPrint('⚠️ No tokens found, using manual state management');
          await HiveService.setLoggedIn(true);
          await HiveService.setPhoneNumber(widget.phoneNumber);
          await HiveService.saveUserData(completeUserData);
        }

        debugPrint('✅ User data saved successfully with userType: $userType');

        if (mounted) {
          // Navigate based on user type
          debugPrint('🧭 Navigating user based on type: $userType');

          switch (userType) {
            case UserType.admin:
              debugPrint('🧭 Navigating to admin dashboard');
              context.go(RouteEnum.adminDashboard.rawValue);
              break;
            case UserType.provider:
              debugPrint('🧭 Navigating to provider dashboard');
              context.go(RouteEnum.providerDashboard.rawValue);
              break;
            case UserType.customer:
              debugPrint('🧭 Navigating to taker/customer dashboard');
              context.go(RouteEnum.takerDashboard.rawValue);
              break;
          }
        }
      }
    } catch (e, stackTrace) {
      // ================ CRITICAL ERROR HANDLING ================
      debugPrint('❌ PinVerificationScreen: ====== CRITICAL ERROR OCCURRED ======');
      debugPrint('🔐 PinVerificationScreen: Critical error details:');
      debugPrint('🔐 PinVerificationScreen: - Error Type: ${e.runtimeType}');
      debugPrint('🔐 PinVerificationScreen: - Error Message: $e');
      debugPrint(
          '🔐 PinVerificationScreen: - Stack Trace Preview: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      debugPrint('🔐 PinVerificationScreen: - User Type: ${widget.userData.userType}');
      debugPrint('🔐 PinVerificationScreen: - Is New User: ${widget.isNewUser}');
      debugPrint('🔐 PinVerificationScreen: - Phone Number: ${widget.phoneNumber}');

      // Update UI with generic error message
      debugPrint('🔐 PinVerificationScreen: Setting generic error message and removing loading state');
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
        _isLoading = false;
      });

      // Trigger error animations
      debugPrint('🔐 PinVerificationScreen: Triggering error recovery animations');
      _shakeAndClearPin();

      debugPrint('🔐 PinVerificationScreen: Error handling completed');
    }
  }

  /// Trigger shake animation and clear PIN on error
  /// Provides visual feedback when PIN verification fails
  void _shakeAndClearPin() {
    debugPrint('🔐 PinVerificationScreen: ====== ERROR ANIMATION SEQUENCE ======');
    debugPrint('🔐 PinVerificationScreen: Starting shake animation...');

    _shakeController.forward().then((_) {
      debugPrint('🔐 PinVerificationScreen: Shake animation completed, resetting controller');
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
      debugPrint('🔐 PinVerificationScreen: Cleared controller $i (was: "${previousText.isNotEmpty ? '*' : 'empty'}")');
    }

    debugPrint('🔐 PinVerificationScreen: Setting focus to first PIN input field');
    _focusNodes[0].requestFocus();
    debugPrint('🔐 PinVerificationScreen: PIN reset completed');
  }

  /// Get user type display name
  String _getUserTypeDisplayName(UserType userType) {
    switch (userType) {
      case UserType.admin:
        return 'Administrator';
      case UserType.provider:
        return 'Service Provider';
      case UserType.customer:
        return 'Customer';
    }
  }

  /// Get display name from user data
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

  /// Get username from user data
  String? _getUsername() {
    return widget.userData.username;
  }

  /// Get user type from user data
  UserType _getUserType() {
    return widget.userData.userType;
  }

  /// Parse user type string from API response to UserType enum
  /// Handles various string formats and provides fallback
  UserType? _parseUserType(dynamic userTypeValue) {
    debugPrint('🔐 PinVerificationScreen: Parsing user type: $userTypeValue (${userTypeValue.runtimeType})');

    if (userTypeValue == null) {
      debugPrint('🔐 PinVerificationScreen: User type is null, returning null');
      return null;
    }

    final userTypeString = userTypeValue.toString().toLowerCase().trim();
    debugPrint('🔐 PinVerificationScreen: Normalized user type string: "$userTypeString"');

    switch (userTypeString) {
      case 'admin':
      case 'administrator':
        debugPrint('🔐 PinVerificationScreen: Parsed as ADMIN');
        return UserType.admin;
      case 'provider':
      case 'service_provider':
      case 'serviceprovider':
        debugPrint('🔐 PinVerificationScreen: Parsed as PROVIDER');
        return UserType.provider;
      case 'customer':
      case 'taker':
      case 'user':
      case 'client':
        debugPrint('🔐 PinVerificationScreen: Parsed as CUSTOMER');
        return UserType.customer;
      default:
        debugPrint('❌ PinVerificationScreen: Unknown user type "$userTypeString", returning null');
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ================ UI BUILD PROCESS ================
    debugPrint('🔐 PinVerificationScreen: ====== UI BUILD STARTED ======');

    final themeManager = ThemeManager.of(context);
    debugPrint('🔐 PinVerificationScreen: Theme manager initialized successfully');

    // Log current screen state for debugging
    debugPrint('🔐 PinVerificationScreen: Current UI state:');
    debugPrint('🔐 PinVerificationScreen: - Loading: $_isLoading');
    debugPrint('🔐 PinVerificationScreen: - Error Message: ${_errorMessage ?? 'none'}');
    debugPrint('🔐 PinVerificationScreen: - PIN Length: ${_pinCode.length}/4');
    debugPrint('🔐 PinVerificationScreen: - User Type: ${widget.userData.userType}');
    debugPrint('🔐 PinVerificationScreen: - Display Name: ${getDisplayName()}');

    // Log theme properties being used
    debugPrint('🔐 PinVerificationScreen: Theme properties:');
    debugPrint('🔐 PinVerificationScreen: - Background Color: ${themeManager.backgroundColor}');
    debugPrint('🔐 PinVerificationScreen: - Primary Color: ${themeManager.primaryColor}');
    debugPrint('🔐 PinVerificationScreen: - Text Primary: ${themeManager.textPrimary}');
    debugPrint('🔐 PinVerificationScreen: - User Type Color: ${themeManager.getUserTypeColor(_getUserType())}');

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Prbal.chevronLeft3,
            color: themeManager.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child:
                // IntrinsicHeight(
                //   child:
                Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),

                // Header Card
                Card(
                  elevation: 4,
                  shadowColor: themeManager.textTertiary.withValues(alpha: 77),
                  child: Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: themeManager.surfaceGradient,
                    ),
                    child: Column(
                      children: [
                        // User Info Section (only show if userData is available)
                        if (!widget.isNewUser) ...[
                          // // User Avatar and Name
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     // User Avatar
                          //     Container(
                          //       width: 50.w,
                          //       height: 50.h,
                          //       decoration: BoxDecoration(
                          //         gradient: LinearGradient(
                          //           colors: [
                          //             themeManager.getUserTypeColor(
                          //               _getUserType(),
                          //             ),
                          //             themeManager.getUserTypeColor(_getUserType()).withValues(alpha: 179),
                          //           ],
                          //         ),
                          //         shape: BoxShape.circle,
                          //       ),
                          //       child: Icon(
                          //         Prbal.user,
                          //         size: 24.sp,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //     SizedBox(width: 16.w),
                          //     // User Name and Type
                          //     Expanded(
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             getDisplayName(),
                          //             style: TextStyle(
                          //               fontSize: 18.sp,
                          //               fontWeight: FontWeight.w600,
                          //               color: themeManager.textPrimary,
                          //             ),
                          //             maxLines: 1,
                          //             overflow: TextOverflow.ellipsis,
                          //           ),
                          //           if (_getUsername() != null) ...[
                          //             SizedBox(height: 2.h),
                          //             Text(
                          //               '@${_getUsername()}',
                          //               style: TextStyle(
                          //                 fontSize: 14.sp,
                          //                 color: themeManager.textSecondary,
                          //               ),
                          //               maxLines: 1,
                          //               overflow: TextOverflow.ellipsis,
                          //             ),
                          //           ],
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          SizedBox(height: 16.h),

                          // User Type Badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: themeManager.getUserTypeColor(_getUserType()).withValues(alpha: 26),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: themeManager.getUserTypeColor(_getUserType()).withValues(alpha: 77),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  getUserTypeIcon(_getUserType()),
                                  size: 16.sp,
                                  color: themeManager.getUserTypeColor(_getUserType()),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  _getUserTypeDisplayName(_getUserType()),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: themeManager.getUserTypeColor(_getUserType()),
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
                              color: themeManager.primaryColor.withValues(alpha: 26),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: themeManager.primaryColor.withValues(alpha: 77),
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
                                      color: themeManager.primaryColor,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Welcome to Prbal!',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: themeManager.primaryColor,
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
                                    color: themeManager.textPrimary,
                                  ),
                                ),
                                if (_getUsername() != null) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Username: @${_getUsername()}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: themeManager.textSecondary,
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
                                        color: themeManager.getUserTypeColor(_getUserType()),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'Account Type: ${_getUserTypeDisplayName(_getUserType())}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: themeManager.getUserTypeColor(_getUserType()),
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
                                  gradient: themeManager.primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  widget.isNewUser ? Prbal.lockOpen2 : Prbal.lockStripes1,
                                  size: 40.sp,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 24.h),

                        Text(
                          widget.isNewUser ? 'Create Your PIN' : 'Enter Your PIN',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: themeManager.textPrimary,
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
                            color: themeManager.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16.h),

                        // Phone Number Display
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: themeManager.primaryColor.withValues(alpha: 26),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: themeManager.primaryColor.withValues(alpha: 77),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Prbal.phone,
                                size: 16.sp,
                                color: themeManager.primaryColor,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                widget.phoneNumber,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: themeManager.primaryColor,
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
                      offset: Offset(_shakeAnimation.value * 10 * (1 - 2 * _shakeAnimation.value).abs(), 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          final isActive = _controllers[index].text.isNotEmpty;
                          return Container(
                            width: 65.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                              gradient: isActive ? themeManager.primaryGradient : null,
                              color: isActive ? null : themeManager.surfaceColor,
                              border: Border.all(
                                color: isActive ? themeManager.primaryColor : themeManager.borderColor,
                                width: isActive ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                              // boxShadow: isActive ? themeManager.primaryShadow : null,
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
                                color: themeManager.textPrimary,
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
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    // width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: themeManager.errorColor.withValues(alpha: 26),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: themeManager.errorColor.withValues(alpha: 77), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Prbal.exclamationTriangle,
                          color: themeManager.errorColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: themeManager.errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 32.h),

                // Verify/Set PIN Button
                Container(
                  // width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 2.h),
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: themeManager.primaryGradient,
                    borderRadius: BorderRadius.circular(10.r),
                    // boxShadow: themeManager.primaryShadow,
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyPin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: CircularProgressIndicator(
                              color: themeManager.onPrimaryColor,
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

                // const Spacer(),

                // Security note
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 2.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                      // color: themeManager.surfaceColor.withValues(alpha: 128),
                      // borderRadius: BorderRadius.circular(12.r),
                      // border: Border.all(color: themeManager.borderColor.withValues(alpha: 51), width: 1),
                      ),
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Prbal.shield4,
                        color: themeManager.primaryColor,
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
                            color: themeManager.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
            // ),
          ),
        ),
        // ),
      ),
    );
  }
}
