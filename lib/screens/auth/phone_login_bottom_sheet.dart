import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// PhoneLoginBottomSheet - A comprehensive phone authentication bottom sheet
///
/// **📱 PHONE AUTHENTICATION COMPONENT OVERVIEW**
/// This widget provides a modern, animated phone login interface with comprehensive
/// debug logging and state management.
///
/// **🎯 CORE FEATURES:**
/// - Smooth slide-up and fade-in animations with debug tracking
/// - Phone number validation with extensive logging
/// - Country code selection with search functionality
/// - Integration with authentication service for user lookup
/// - Social login options (Google, Apple) - placeholder implementation
/// - Responsive design with comprehensive ThemeManager integration
/// - Error handling with visual feedback and debug traces
/// - Proper authentication state management with Riverpod
///
/// **🔄 AUTHENTICATION FLOW WITH DEBUG TRACKING:**
/// 1. Widget initialization → Debug prints for state setup
/// 2. User enters phone number → Input change logging
/// 3. Country selection → Country picker interaction logging
/// 4. Phone number validation → Detailed validation debug output
/// 5. API call to search user → Complete request/response logging
/// 6. Navigate to PIN entry → Navigation data logging
/// 7. Error handling → Comprehensive error trace logging
///
/// **🏗️ ARCHITECTURE COMPONENTS:**
/// - **State Management**: Riverpod providers with debug logging
/// - **Animations**: Custom controllers with animation progress tracking
/// - **UI Components**: ThemeManager integration with theme debug info
/// - **API Integration**: UserService with comprehensive request/response logging
/// - **Local Storage**: HiveService integration with cache operation logging
/// - **Navigation**: GoRouter integration with route transition logging
///
/// **🐛 DEBUG FEATURES:**
/// - Comprehensive debug prints throughout all methods
/// - State change logging with before/after values
/// - API request/response detailed logging
/// - Error handling with stack trace information
/// - Animation progress tracking
/// - User interaction logging (taps, input changes, selections)
/// - Theme and UI state logging
/// - Performance timing for critical operations
class PhoneLoginBottomSheet extends ConsumerStatefulWidget {
  const PhoneLoginBottomSheet({super.key});

  @override
  ConsumerState<PhoneLoginBottomSheet> createState() => _PhoneLoginBottomSheetState();
}

class _PhoneLoginBottomSheetState extends ConsumerState<PhoneLoginBottomSheet>
    with TickerProviderStateMixin, ThemeAwareMixin {
  // Form controllers for input management
  final _phoneController = TextEditingController();
  final _searchController = TextEditingController();

  // State variables for phone login logic
  String _phoneNumber = '';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Animation controllers for smooth UI transitions
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Selected country data with default to India
  String _selectedCountryCode = '+91';
  String _selectedCountryFlag = '🇮🇳';

  @override
  void initState() {
    super.initState();
    debugPrint(' PhoneLoginBottomSheet : 🚀 PhoneLoginBottomSheet: Initializing widget state');
    debugPrint(' PhoneLoginBottomSheet : 📱 Default country: $_selectedCountryCode $_selectedCountryFlag');

    _initializeAnimations();
    _startAnimations();
    _loadCachedPhoneNumber();

    debugPrint(' PhoneLoginBottomSheet : ✅ PhoneLoginBottomSheet: Widget initialization completed');
  }

  /// Load cached phone number if available for better UX
  ///
  /// **Purpose:** Restore previously entered phone number to improve user experience
  /// **Process:**
  /// 1. Retrieve cached phone number from local storage
  /// 2. Parse country code and phone number using regex
  /// 3. Find matching country from countries list
  /// 4. Update UI state with cached values
  void _loadCachedPhoneNumber() {
    debugPrint(' PhoneLoginBottomSheet : 📞 PhoneLoginBottomSheet: Loading cached phone number');

    final cachedPhone = HiveService.getPhoneNumber();
    debugPrint(' PhoneLoginBottomSheet : 💾 Cached phone from storage: $cachedPhone');

    if (cachedPhone != null && cachedPhone.isNotEmpty) {
      debugPrint(' PhoneLoginBottomSheet : 🔍 Parsing cached phone number: $cachedPhone');

      // Extract country code and phone number using regex pattern
      final phoneRegex = RegExp(r'^(\+\d{1,2})(.*)$');
      final match = phoneRegex.firstMatch(cachedPhone);

      if (match != null) {
        final countryCode = match.group(1)!;
        final phoneNumber = match.group(2)!;

        debugPrint(' PhoneLoginBottomSheet : 🌍 Extracted country code: $countryCode');
        debugPrint(' PhoneLoginBottomSheet : 📱 Extracted phone number: $phoneNumber');

        // Find matching country from the countries list
        final country = countries.firstWhere(
          (c) => c['code'] == countryCode,
          orElse: () => {'code': '+91', 'flag': '🇮🇳'},
        );

        debugPrint(' PhoneLoginBottomSheet : 🏳️ Found country: ${country['name']} ${country['flag']}');

        setState(() {
          _selectedCountryCode = countryCode;
          _selectedCountryFlag = country['flag']!;
          _phoneNumber = phoneNumber;
          _phoneController.text = phoneNumber;
        });

        debugPrint(' PhoneLoginBottomSheet : ✅ Phone number state updated successfully');
        debugPrint(' PhoneLoginBottomSheet : 📊 Current state - Country: $countryCode, Phone: $phoneNumber');
      } else {
        debugPrint(' PhoneLoginBottomSheet : ⚠️ Failed to parse cached phone number format');
      }
    } else {
      debugPrint(' PhoneLoginBottomSheet : ℹ️ No cached phone number found, using defaults');
    }
  }

  /// Initializes animation controllers and animation objects
  ///
  /// **Purpose:** Creates smooth slide and fade animations for bottom sheet presentation
  /// **Animations Created:**
  /// - Slide animation: Bottom-to-center movement (400ms, easeOut curve)
  /// - Fade animation: Opacity transition (300ms, easeIn curve)
  /// **Performance:** Uses TickerProviderStateMixin for optimized animations
  void _initializeAnimations() {
    debugPrint(' PhoneLoginBottomSheet : 🎬 PhoneLoginBottomSheet: Initializing animations');

    // Slide animation controller - controls the upward slide motion
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    debugPrint(' PhoneLoginBottomSheet : ⬆️ Slide controller created (400ms duration)');

    // Fade animation controller - controls the opacity transition
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    debugPrint(' PhoneLoginBottomSheet : 🌟 Fade controller created (300ms duration)');

    // Slide animation from bottom to center
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom (off-screen)
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut, // Smooth deceleration
    ));
    debugPrint(' PhoneLoginBottomSheet : 📐 Slide animation configured: Offset(0,1) → Offset(0,0) with easeOut');

    // Fade animation from transparent to opaque
    _fadeAnimation = Tween<double>(
      begin: 0.0, // Start transparent
      end: 1.0, // End fully opaque
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn, // Smooth acceleration
    ));
    debugPrint(' PhoneLoginBottomSheet : 💫 Fade animation configured: 0.0 → 1.0 opacity with easeIn');
    debugPrint(' PhoneLoginBottomSheet : ✅ All animations initialized successfully');
  }

  /// Starts the entry animations with staggered timing
  ///
  /// **Purpose:** Creates smooth, layered animation entrance
  /// **Process:**
  /// 1. Start slide animation immediately
  /// 2. Wait 100ms for staggered effect
  /// 3. Start fade animation if widget is still mounted
  /// **UX Benefit:** Provides professional, polished feel to the modal
  Future<void> _startAnimations() async {
    debugPrint(' PhoneLoginBottomSheet : 🎭 PhoneLoginBottomSheet: Starting entrance animations');

    // Start slide animation immediately
    _slideController.forward();
    debugPrint(' PhoneLoginBottomSheet : ⬆️ Slide animation started');

    // Wait briefly then start fade animation for staggered effect
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint(' PhoneLoginBottomSheet : ⏰ Stagger delay completed (100ms)');

    if (mounted) {
      _fadeController.forward();
      debugPrint(' PhoneLoginBottomSheet : 🌟 Fade animation started');
      debugPrint(' PhoneLoginBottomSheet : ✅ All entrance animations running');
    } else {
      debugPrint(' PhoneLoginBottomSheet : ⚠️ Widget unmounted, skipping fade animation');
    }
  }

  @override
  void dispose() {
    debugPrint(' PhoneLoginBottomSheet : 🧹 PhoneLoginBottomSheet: Starting cleanup process');

    // Clean up controllers to prevent memory leaks
    debugPrint(' PhoneLoginBottomSheet : 📝 Disposing text controllers');
    _phoneController.dispose();
    _searchController.dispose();

    debugPrint(' PhoneLoginBottomSheet : 🎬 Disposing animation controllers');
    _slideController.dispose();
    _fadeController.dispose();

    debugPrint(' PhoneLoginBottomSheet : ✅ PhoneLoginBottomSheet: All resources cleaned up successfully');
    super.dispose();
  }

  /// Validates phone number format
  ///
  /// **Purpose:** Ensure phone number meets basic requirements before API call
  /// **Validation Rules:**
  /// - Must not be empty
  /// - Must be at least 10 digits long
  /// - Must contain only numeric digits
  /// - Must be maximum 15 digits (international standard)
  /// **Returns:** true if valid, false if invalid
  bool _isValidPhoneNumber(String phone) {
    debugPrint(' PhoneLoginBottomSheet : 🔍 PhoneLoginBottomSheet: Validating phone number');
    debugPrint(' PhoneLoginBottomSheet : 📱 Phone to validate: "$phone" (length: ${phone.length})');

    // Basic phone number validation - check length
    if (phone.isEmpty) {
      debugPrint(' PhoneLoginBottomSheet : ❌ Validation failed: Phone number is empty');
      return false;
    }

    if (phone.length < 10) {
      debugPrint(' PhoneLoginBottomSheet : ❌ Validation failed: Phone number too short (${phone.length} < 10)');
      return false;
    }

    // Check if phone contains only digits using regex
    final phoneRegex = RegExp(r'^\d{10,15}$');
    final isValidFormat = phoneRegex.hasMatch(phone);

    if (isValidFormat) {
      debugPrint(' PhoneLoginBottomSheet : ✅ Phone number validation passed');
    } else {
      debugPrint(' PhoneLoginBottomSheet : ❌ Validation failed: Phone contains non-digits or invalid length');
    }

    debugPrint(' PhoneLoginBottomSheet : 📊 Validation result: $isValidFormat');
    return isValidFormat;
  }

  /// Validates phone number and initiates authentication flow
  ///
  /// **Purpose:** Core authentication method that handles phone verification
  /// **Process:**
  /// 1. Validates phone number format and length
  /// 2. Makes API call to check if user exists
  /// 3. Prepares user data for PIN entry screen
  /// 4. Navigates to PIN entry with appropriate data
  /// 5. Caches phone number for future use
  /// **API Integration:** Uses UserService.searchUserByPhone()
  /// **Navigation:** Transitions to PIN entry screen with user context
  Future<void> _verifyPhoneNumber() async {
    debugPrint(' PhoneLoginBottomSheet : 🚀 PhoneLoginBottomSheet: Starting phone verification process');
    debugPrint(' PhoneLoginBottomSheet : 📱 Current phone number: "$_phoneNumber"');
    debugPrint(' PhoneLoginBottomSheet : 🌍 Selected country: $_selectedCountryCode $_selectedCountryFlag');

    // Step 1: Validate phone number format before API call
    if (!_isValidPhoneNumber(_phoneNumber)) {
      debugPrint(' PhoneLoginBottomSheet : ❌ Phone verification failed: Invalid phone number format');
      setState(() {
        _errorMessage = 'auth.phoneLogin.validation.invalidPhone'.tr();
      });
      debugPrint(' PhoneLoginBottomSheet : 🔄 UI updated with validation error message');
      return;
    }

    // Step 2: Provide haptic feedback for better UX
    HapticFeedback.lightImpact();
    debugPrint(' PhoneLoginBottomSheet : 📳 Haptic feedback provided to user');

    // Step 3: Update UI to show loading state
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    debugPrint(' PhoneLoginBottomSheet : ⏳ Loading state activated, error message cleared');

    try {
      // Step 4: Get UserService instance from Riverpod provider
      final userService = UserService(ApiService());
      final fullPhoneNumber = _selectedCountryCode + _phoneNumber;
      debugPrint(' PhoneLoginBottomSheet : 📞 Full phone number: $fullPhoneNumber');
      debugPrint(' PhoneLoginBottomSheet : 🔍 Searching for existing user via API...');

      // Step 5: Check if user exists by phone number via API
      final userSearchResponse = await userService.searchUserByPhone(fullPhoneNumber);
      debugPrint(' PhoneLoginBottomSheet : 📡 API call completed');
      // debugPrint(' PhoneLoginBottomSheet : 📊 API response success: ${userSearchResponse.success}');
      // debugPrint(' PhoneLoginBottomSheet : 👤 User found: ${userSearchResponse.data != null}');

      // Step 6: Process API response and prepare user data
      // final AppUser? existingUser;
      AppUser? userData;

      if (userSearchResponse.id == '') {
        debugPrint(' PhoneLoginBottomSheet : 🆕 New user detected - generating random user data');
        Map<String, String> randomData = generateRandomUserData();
        debugPrint(' PhoneLoginBottomSheet : 🎲 Generated data: $randomData');

        // User doesn't exist, prepare new user data with default provider type
        userData = AppUser(
          phoneNumber: fullPhoneNumber,
          userType: UserType.provider,
          id: '',
          firstName: randomData['firstName']!,
          lastName: randomData['lastName']!,
          username: randomData['username']!,
          email: randomData['email']!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        debugPrint(' PhoneLoginBottomSheet : ✅ New user data prepared successfully');
        debugPrint(
            ' PhoneLoginBottomSheet : 👤 New user: ${userData.firstName} ${userData.lastName} (${userData.username})');
      } else {
        debugPrint(' PhoneLoginBottomSheet : 👋 Existing user found in database');
        // User exists, use their complete data from AppUser model
        // existingUser = userSearchResponse.data;
        userData = userSearchResponse;
        debugPrint(' PhoneLoginBottomSheet : ✅ Existing user data loaded successfully');
        debugPrint(' PhoneLoginBottomSheet : 👤 User: ${userData.firstName} ${userData.lastName}');
        debugPrint(' PhoneLoginBottomSheet : 📧 Email: ${userData.email}');
        debugPrint(' PhoneLoginBottomSheet : 🏷️ User Type: ${userData.userType}');
        debugPrint(' PhoneLoginBottomSheet : ⭐ Verified: ${userData.isVerified}');
      }

      // Step 7: Cache phone number for future use
      debugPrint(' PhoneLoginBottomSheet : 💾 Caching phone number for future sessions...');
      await HiveService.setPhoneNumber(fullPhoneNumber);
      debugPrint(' PhoneLoginBottomSheet : ✅ Phone number cached successfully');

      // Step 8: Update UI to hide loading state and navigate
      if (mounted) {
        debugPrint(' PhoneLoginBottomSheet : 🔄 Widget still mounted, updating UI state');
        setState(() {
          _isLoading = false;
        });
        debugPrint(' PhoneLoginBottomSheet : ⏳ Loading state deactivated');

        // Navigate to PIN entry screen with user data
        debugPrint(' PhoneLoginBottomSheet : 🚪 Closing current bottom sheet...');
        context.pop(); // Close current bottom sheet

        debugPrint(' PhoneLoginBottomSheet : 🧭 Navigating to PIN entry screen...');
        debugPrint(' PhoneLoginBottomSheet : 📦 Navigation data:');
        debugPrint(' PhoneLoginBottomSheet :   - phoneNumber: $fullPhoneNumber');
        // debugPrint(' PhoneLoginBottomSheet :   - isNewUser: ${userSearchResponse.data == null}');
        debugPrint(' PhoneLoginBottomSheet :   - userData: ${userData.toString()}');

        // Navigate with proper data structure
        context.push(
          RouteEnum.pinEntry.rawValue,
          extra: {
            'phoneNumber': fullPhoneNumber,
            'isNewUser': (userSearchResponse.id == ''),
            'userData': userData,
          },
        );
        debugPrint(' PhoneLoginBottomSheet : ✅ Navigation completed successfully');
      } else {
        debugPrint(' PhoneLoginBottomSheet : ⚠️ Widget unmounted during API call, skipping UI update');
      }
    } catch (e) {
      debugPrint(' PhoneLoginBottomSheet : 💥 Error occurred during phone verification:');
      debugPrint(' PhoneLoginBottomSheet : ❌ Error type: ${e.runtimeType}');
      debugPrint(' PhoneLoginBottomSheet : ❌ Error message: $e');
      debugPrint(' PhoneLoginBottomSheet : 📱 Stack trace: ${StackTrace.current}');

      if (mounted) {
        debugPrint(' PhoneLoginBottomSheet : 🔄 Updating UI with error state');
        setState(() {
          _isLoading = false;
          _errorMessage = 'auth.phoneLogin.validation.networkError'.tr();
        });
        debugPrint(' PhoneLoginBottomSheet : ⚠️ Network error message displayed to user');
      } else {
        debugPrint(' PhoneLoginBottomSheet : ⚠️ Widget unmounted, cannot update error state');
      }
    }

    debugPrint(' PhoneLoginBottomSheet : 🏁 Phone verification process completed');
  }

  /// Handle social login with proper error handling
  ///
  /// **Purpose:** Placeholder implementation for future social authentication
  /// **Supported Providers:** Google, Apple (planned)
  /// **Current Status:** Simulated implementation with "Coming Soon" message
  /// **Future Implementation:** Will integrate OAuth flows for each provider
  Future<void> _handleSocialLogin(String provider) async {
    debugPrint(' PhoneLoginBottomSheet : 🔐 PhoneLoginBottomSheet: Social login initiated');
    debugPrint(' PhoneLoginBottomSheet : 📱 Provider: $provider');
    debugPrint(' PhoneLoginBottomSheet : ⚠️ Note: This is currently a placeholder implementation');

    // Provide haptic feedback for user interaction
    HapticFeedback.lightImpact();
    debugPrint(' PhoneLoginBottomSheet : 📳 Haptic feedback provided for social login tap');

    // Show loading state to user
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    debugPrint(' PhoneLoginBottomSheet : ⏳ Loading state activated for social login');
    debugPrint(' PhoneLoginBottomSheet : 🧹 Previous error messages cleared');

    try {
      debugPrint(' PhoneLoginBottomSheet : 🚀 Starting social login simulation...');
      // TODO: Implement actual social login logic
      // This is a placeholder for future implementation
      //
      // FUTURE IMPLEMENTATION PLAN:
      // 1. Google Sign-In: Use google_sign_in package
      // 2. Apple Sign-In: Use sign_in_with_apple package
      // 3. Handle OAuth token exchange
      // 4. Create/update user profile with social data
      // 5. Navigate to main app or PIN setup

      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      debugPrint(' PhoneLoginBottomSheet : ⏰ Social login simulation completed (2 second delay)');

      if (mounted) {
        debugPrint(' PhoneLoginBottomSheet : 🔄 Widget mounted, updating UI with "Coming Soon" message');
        setState(() {
          _isLoading = false;
          _errorMessage = 'auth.phoneLogin.socialLogin.comingSoon'.tr();
        });
        debugPrint(' PhoneLoginBottomSheet : ℹ️ "Coming Soon" message displayed to user');
      } else {
        debugPrint(' PhoneLoginBottomSheet : ⚠️ Widget unmounted during social login, skipping UI update');
      }
    } catch (e) {
      debugPrint(' PhoneLoginBottomSheet : 💥 Error occurred during social login simulation:');
      debugPrint(' PhoneLoginBottomSheet : ❌ Error type: ${e.runtimeType}');
      debugPrint(' PhoneLoginBottomSheet : ❌ Error message: $e');

      if (mounted) {
        debugPrint(' PhoneLoginBottomSheet : 🔄 Updating UI with social login error state');
        setState(() {
          _isLoading = false;
          _errorMessage = 'auth.phoneLogin.socialLogin.failed'.tr();
        });
        debugPrint(' PhoneLoginBottomSheet : ⚠️ Social login failure message displayed to user');
      } else {
        debugPrint(' PhoneLoginBottomSheet : ⚠️ Widget unmounted, cannot update error state');
      }
    }

    debugPrint(' PhoneLoginBottomSheet : 🏁 Social login process completed');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(' PhoneLoginBottomSheet : 🎨 PhoneLoginBottomSheet: Building UI');
    debugPrint(' PhoneLoginBottomSheet : 📊 Current state - Loading: $_isLoading, Error: ${_errorMessage != null}');
    debugPrint(' PhoneLoginBottomSheet : 📱 Current phone: "$_phoneNumber", Country: $_selectedCountryCode');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========

    final screenSize = MediaQuery.of(context).size;

    debugPrint(' PhoneLoginBottomSheet : 🎨 Theme loaded: ${ThemeManager.of(context).runtimeType}');
    debugPrint(' PhoneLoginBottomSheet : 📐 Screen size: ${screenSize.width} x ${screenSize.height}');
    debugPrint(' PhoneLoginBottomSheet : 📱 Max height: ${screenSize.height * 0.9}');

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        constraints: BoxConstraints(
          // Responsive height - max 90% of screen height
          maxHeight: screenSize.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: ThemeManager.of(context).backgroundColor,
          // // Theme-aware background with gradient
          // gradient: ThemeManager.of(context).conditionalGradient(
          //   lightGradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       ThemeManager.of(context).backgroundColor,
          //       ThemeManager.of(context).surfaceElevated,
          //       ThemeManager.of(context).cardBackground,
          //     ],
          //     stops: const [0.0, 0.6, 1.0],
          //   ),
          //   darkGradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       ThemeManager.of(context).backgroundColor,
          //       ThemeManager.of(context).backgroundSecondary,
          //       ThemeManager.of(context).surfaceElevated,
          //     ],
          //     stops: const [0.0, 0.5, 1.0],
          //   ),
          // ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(
            color: ThemeManager.of(context).conditionalColor(
              lightColor: ThemeManager.of(context).borderColor.withValues(alpha: 0.2),
              darkColor: ThemeManager.of(context).borderSecondary.withValues(alpha: 0.3),
            ),
            width: 1.5,
          ),
          // boxShadow: [
          //   ...ThemeManager.of(context).elevatedShadow,
          //   BoxShadow(
          //     color: ThemeManager.of(context).shadowDark,
          //     blurRadius: 25,
          //     offset: const Offset(0, -8),
          //   ),
          //   BoxShadow(
          //     color: ThemeManager.of(context).primaryColor.withValues(alpha: 0.05),
          //     blurRadius: 30,
          //     offset: const Offset(0, -12),
          //   ),
          // ],
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24.w,
                16.h,
                24.w,
                // Add bottom padding for keyboard
                MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.all(24.w),
                  //   child:
                  SizedBox(height: 10.h),
                  Column(
                    children: [
                      Text(
                        'auth.phoneLogin.title'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ThemeManager.of(context).textSecondary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // ),

                  // Phone input section
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  //   child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Phone input field with comprehensive ThemeManager styling
                      Container(
                        decoration: BoxDecoration(
                          gradient: ThemeManager.of(context).conditionalGradient(
                            lightGradient: LinearGradient(
                              colors: [
                                ThemeManager.of(context).inputBackground,
                                ThemeManager.of(context).surfaceElevated,
                              ],
                            ),
                            darkGradient: LinearGradient(
                              colors: [
                                ThemeManager.of(context).inputBackground,
                                ThemeManager.of(context).backgroundTertiary,
                              ],
                            ),
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _errorMessage != null
                                ? ThemeManager.of(context).errorColor
                                : ThemeManager.of(context).conditionalColor(
                                    lightColor: ThemeManager.of(context).borderColor,
                                    darkColor: ThemeManager.of(context).borderSecondary,
                                  ),
                            width: 1.5,
                          ),
                          boxShadow: _errorMessage != null
                              ? [
                                  BoxShadow(
                                    color: ThemeManager.of(context).errorColor.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [
                                  ...ThemeManager.of(context).subtleShadow,
                                ],
                        ),
                        child: Row(
                          children: [
                            // Country code selector
                            GestureDetector(
                              onTap: _showCountryPicker,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: ThemeManager.of(context).conditionalColor(
                                        lightColor: ThemeManager.of(context).borderColor,
                                        darkColor: ThemeManager.of(context).borderSecondary,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedCountryFlag,
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      _selectedCountryCode,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: ThemeManager.of(context).textPrimary,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Prbal.angleDown,
                                      size: 16.sp,
                                      color: ThemeManager.of(context).onPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Phone number input
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeManager.of(context).textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'auth.phoneLogin.phoneHint'.tr(),
                                  hintStyle: TextStyle(
                                    color: ThemeManager.of(context).textSecondary,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                onChanged: (value) {
                                  debugPrint(
                                      ' PhoneLoginBottomSheet : 📱 PhoneLoginBottomSheet: Phone number input changed');
                                  debugPrint(' PhoneLoginBottomSheet : 📝 Old value: "$_phoneNumber"');
                                  debugPrint(' PhoneLoginBottomSheet : 📝 New value: "$value"');

                                  _phoneNumber = value;
                                  debugPrint(' PhoneLoginBottomSheet : ✅ Phone number state updated');

                                  // Clear error message when user starts typing
                                  if (_errorMessage != null) {
                                    debugPrint(' PhoneLoginBottomSheet : 🧹 Clearing error message on input change');
                                    setState(() {
                                      _errorMessage = null;
                                    });
                                    debugPrint(' PhoneLoginBottomSheet : ✅ Error message cleared');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Error message
                      if (_errorMessage != null) ...[
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Prbal.exclamationTriangle,
                              size: 16.sp,
                              color: const Color(0xFFEF4444),
                            ),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFEF4444),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: 24.h),

                      // Continue button
                      SizedBox(
                        // width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyPhoneNumber,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            disabledBackgroundColor: ThemeManager.of(context).conditionalColor(
                              lightColor: ThemeManager.of(context).neutral300,
                              darkColor: ThemeManager.of(context).neutral700,
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(ThemeManager.of(context).onPrimaryColor),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'auth.phoneLogin.continue'.tr(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Prbal.chevronsRight,
                                      size: 20.sp,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Divider with "or" - ThemeManager enhanced
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: ThemeManager.of(context).conditionalColor(
                                lightColor: ThemeManager.of(context).neutral300,
                                darkColor: ThemeManager.of(context).neutral600,
                              ),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'auth.phoneLogin.or'.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ThemeManager.of(context).textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: ThemeManager.of(context).conditionalColor(
                                lightColor: ThemeManager.of(context).neutral300,
                                darkColor: ThemeManager.of(context).neutral600,
                              ),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: _buildSocialButton(
                              'auth.phoneLogin.socialLogin.google'.tr(),
                              Prbal.google11,
                              Colors.red,
                              () => _handleSocialLogin('google'),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Flexible(
                            child: _buildSocialButton(
                              'auth.phoneLogin.socialLogin.apple'.tr(),
                              Prbal.apple,
                              ThemeManager.of(context).conditionalColor(
                                lightColor: Colors.black,
                                darkColor: Colors.white,
                              ),
                              () => _handleSocialLogin('apple'),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      // Terms text with ThemeManager styling
                      Text.rich(
                        TextSpan(
                          text: 'auth.phoneLogin.terms.prefix'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ThemeManager.of(context).textSecondary,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: 'auth.phoneLogin.terms.termsOfService'.tr(),
                              style: TextStyle(
                                color: ThemeManager.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: 'auth.phoneLogin.terms.and'.tr()),
                            TextSpan(
                              text: 'auth.phoneLogin.terms.privacyPolicy'.tr(),
                              style: TextStyle(
                                color: ThemeManager.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: 'auth.phoneLogin.terms.suffix'.tr()),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // SizedBox(height: 40.h),
                    ],
                  ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build social login button with consistent styling and theme integration
  ///
  /// **Purpose:** Create reusable social login buttons (Google, Apple, etc.)
  /// **Design Features:**
  /// - Circular button with gradient background
  /// - Theme-aware colors and shadows
  /// - Consistent 60x60 sizing for balanced layout
  /// - Subtle border and elevation effects
  /// **Parameters:**
  /// - [label]: Button accessibility label (for future tooltips)
  /// - [icon]: Social platform icon (Google, Apple, etc.)
  /// - [iconColor]: Brand-specific icon color
  /// - [onPressed]: Callback function for button interaction
  /// - [themeManager]: Theme manager for consistent styling
  Widget _buildSocialButton(
    String label,
    IconData icon,
    Color iconColor,
    VoidCallback onPressed,
  ) {
    debugPrint(' PhoneLoginBottomSheet : 🔨 Building social button: $label');
    debugPrint(' PhoneLoginBottomSheet : 🎨 Icon color: $iconColor');

    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).cardBackground,
            ],
          ),
          darkGradient: LinearGradient(
            colors: [
              ThemeManager.of(context).backgroundSecondary,
              ThemeManager.of(context).surfaceElevated,
            ],
          ),
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor: ThemeManager.of(context).borderColor,
            darkColor: ThemeManager.of(context).borderSecondary,
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...ThemeManager.of(context).subtleShadow,
        ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeManager.of(context).textPrimary,
          side: BorderSide.none,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Icon(
          icon,
          size: 24.sp,
          color: iconColor,
        ),
      ),
    );
  }

  /// Show country picker with improved search and selection
  ///
  /// **Purpose:** Display modal bottom sheet with searchable country list
  /// **Features:**
  /// - Real-time search filtering by country name or code
  /// - Theme-aware design with gradients and animations
  /// - Haptic feedback on selection
  /// - Smooth animations and professional UI
  /// **UX Benefits:** Easy country selection with visual feedback
  void _showCountryPicker() {
    debugPrint(' PhoneLoginBottomSheet : 🌍 PhoneLoginBottomSheet: Opening country picker');
    debugPrint(' PhoneLoginBottomSheet : 🎯 Current selection: $_selectedCountryFlag $_selectedCountryCode');

    debugPrint(' PhoneLoginBottomSheet : 🎨 Theme loaded for country picker modal');

    // Clear search query when opening to show all countries
    debugPrint(' PhoneLoginBottomSheet : 🧹 Clearing search controller and query');
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    debugPrint(' PhoneLoginBottomSheet : ✅ Search state reset, showing all countries');

    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeManager.of(context).backgroundColor,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            gradient: ThemeManager.of(context).conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).backgroundColor,
                  ThemeManager.of(context).surfaceElevated,
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).backgroundColor,
                  ThemeManager.of(context).backgroundSecondary,
                ],
              ),
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(
              color: ThemeManager.of(context).onPrimaryColor,
              width: 1.5,
            ),
            // boxShadow: [
            //   ...ThemeManager.of(context).elevatedShadow,
            // ],
          ),
          child: Column(
            children: [
              // Drag handle with ThemeManager styling
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 12.h),
                decoration: BoxDecoration(
                  gradient: ThemeManager.of(context).conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        ThemeManager.of(context).neutral300,
                        ThemeManager.of(context).neutral400,
                      ],
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        ThemeManager.of(context).neutral600,
                        ThemeManager.of(context).neutral500,
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(2.r),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeManager.of(context).shadowLight,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),

              // Header with ThemeManager styling
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ThemeManager.of(context).conditionalColor(
                        lightColor: ThemeManager.of(context).borderColor,
                        darkColor: ThemeManager.of(context).borderSecondary,
                      ),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Provide haptic feedback
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          gradient: ThemeManager.of(context).conditionalGradient(
                            lightGradient: LinearGradient(
                              colors: [
                                ThemeManager.of(context).neutral100,
                                ThemeManager.of(context).neutral200,
                              ],
                            ),
                            darkGradient: LinearGradient(
                              colors: [
                                ThemeManager.of(context).neutral800,
                                ThemeManager.of(context).neutral700,
                              ],
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: ThemeManager.of(context).conditionalColor(
                              lightColor: ThemeManager.of(context).borderColor.withValues(alpha: 0.3),
                              darkColor: ThemeManager.of(context).borderSecondary.withValues(alpha: 0.4),
                            ),
                            width: 1,
                          ),
                          boxShadow: [
                            ...ThemeManager.of(context).subtleShadow,
                          ],
                        ),
                        child: Icon(
                          Prbal.cross,
                          size: 20.sp,
                          color: ThemeManager.of(context).conditionalColor(
                            lightColor: ThemeManager.of(context).neutral600,
                            darkColor: ThemeManager.of(context).neutral400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        'auth.phoneLogin.countryPicker.title'.tr(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: ThemeManager.of(context).textPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    // Show selected country info with ThemeManager styling
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ThemeManager.of(context).primaryColor.withValues(alpha: 0.15),
                            ThemeManager.of(context).primaryLight.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: ThemeManager.of(context).primaryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCountryFlag,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _selectedCountryCode,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: ThemeManager.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Search bar with comprehensive ThemeManager styling
              Container(
                margin: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: ThemeManager.of(context).conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        ThemeManager.of(context).inputBackground,
                        ThemeManager.of(context).surfaceElevated,
                      ],
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        ThemeManager.of(context).inputBackground,
                        ThemeManager.of(context).backgroundTertiary,
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: ThemeManager.of(context).conditionalColor(
                      lightColor: ThemeManager.of(context).borderColor,
                      darkColor: ThemeManager.of(context).borderSecondary,
                    ),
                    width: 1.5,
                  ),
                  boxShadow: [
                    ...ThemeManager.of(context).subtleShadow,
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'auth.phoneLogin.countryPicker.searchHint'.tr(),
                    hintStyle: TextStyle(
                      color: ThemeManager.of(context).textSecondary,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Prbal.search,
                      color: ThemeManager.of(context).primaryColor,
                      size: 18.sp,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setModalState(() {
                                _searchQuery = '';
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                gradient: ThemeManager.of(context).conditionalGradient(
                                  lightGradient: LinearGradient(
                                    colors: [
                                      ThemeManager.of(context).errorColor.withValues(alpha: 0.15),
                                      ThemeManager.of(context).errorLight.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  darkGradient: LinearGradient(
                                    colors: [
                                      ThemeManager.of(context).errorDark.withValues(alpha: 0.2),
                                      ThemeManager.of(context).errorColor.withValues(alpha: 0.15),
                                    ],
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: ThemeManager.of(context).conditionalColor(
                                    lightColor: ThemeManager.of(context).errorColor.withValues(alpha: 0.3),
                                    darkColor: ThemeManager.of(context).errorDark.withValues(alpha: 0.4),
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Prbal.cross,
                                color: ThemeManager.of(context).conditionalColor(
                                  lightColor: ThemeManager.of(context).errorColor,
                                  darkColor: ThemeManager.of(context).errorLight,
                                ),
                                size: 14.sp,
                              ),
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  style: TextStyle(
                    color: ThemeManager.of(context).textPrimary,
                    fontSize: 15.sp,
                  ),
                  onChanged: (value) {
                    debugPrint(' PhoneLoginBottomSheet : 🔍 Country picker: Search input changed');
                    debugPrint(' PhoneLoginBottomSheet : 📝 Search value: "$value"');

                    setModalState(() {
                      _searchQuery = value.toLowerCase();
                    });

                    debugPrint(' PhoneLoginBottomSheet : 🔎 Search query updated: "$_searchQuery"');
                    debugPrint(' PhoneLoginBottomSheet : 🌍 Filtering countries list...');
                  },
                ),
              ),

              // Country list with ThemeManager styling
              Expanded(
                child: Builder(
                  builder: (context) {
                    final filteredCountries = countries.where((country) {
                      if (_searchQuery.isEmpty) return true;
                      return country['name']!.toLowerCase().contains(_searchQuery) ||
                          country['code']!.toLowerCase().contains(_searchQuery.replaceAll('+', ''));
                    }).toList();

                    if (filteredCountries.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Prbal.search,
                              size: 48.sp,
                              color: ThemeManager.of(context).conditionalColor(
                                lightColor: ThemeManager.of(context).neutral400,
                                darkColor: ThemeManager.of(context).neutral600,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'auth.phoneLogin.countryPicker.noResults'.tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: ThemeManager.of(context).conditionalColor(
                                  lightColor: ThemeManager.of(context).neutral600,
                                  darkColor: ThemeManager.of(context).neutral400,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'auth.phoneLogin.countryPicker.searchTip'.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ThemeManager.of(context).textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredCountries.length,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        final isSelected = country['code'] == _selectedCountryCode;

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      ThemeManager.of(context).primaryColor.withValues(alpha: 0.15),
                                      ThemeManager.of(context).primaryLight.withValues(alpha: 0.1),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(8.r),
                            border: isSelected
                                ? Border.all(
                                    color: ThemeManager.of(context).primaryColor.withValues(alpha: 0.3),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                            leading: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                gradient: ThemeManager.of(context).conditionalGradient(
                                  lightGradient: LinearGradient(
                                    colors: [
                                      ThemeManager.of(context).neutral100,
                                      ThemeManager.of(context).neutral200,
                                    ],
                                  ),
                                  darkGradient: LinearGradient(
                                    colors: [
                                      ThemeManager.of(context).neutral800,
                                      ThemeManager.of(context).neutral700,
                                    ],
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: ThemeManager.of(context).conditionalColor(
                                    lightColor: ThemeManager.of(context).borderColor.withValues(alpha: 0.3),
                                    darkColor: ThemeManager.of(context).borderSecondary.withValues(alpha: 0.4),
                                  ),
                                  width: 1,
                                ),
                                boxShadow: [
                                  ...ThemeManager.of(context).subtleShadow,
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  country['flag']!,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                            title: Text(
                              country['name']!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: ThemeManager.of(context).textPrimary,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    gradient: ThemeManager.of(context).conditionalGradient(
                                      lightGradient: LinearGradient(
                                        colors: [
                                          ThemeManager.of(context).neutral200,
                                          ThemeManager.of(context).neutral300,
                                        ],
                                      ),
                                      darkGradient: LinearGradient(
                                        colors: [
                                          ThemeManager.of(context).neutral700,
                                          ThemeManager.of(context).neutral600,
                                        ],
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: ThemeManager.of(context).conditionalColor(
                                        lightColor: ThemeManager.of(context).borderColor.withValues(alpha: 0.3),
                                        darkColor: ThemeManager.of(context).borderSecondary.withValues(alpha: 0.4),
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    country['code']!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeManager.of(context).conditionalColor(
                                        lightColor: ThemeManager.of(context).neutral700,
                                        darkColor: ThemeManager.of(context).neutral300,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isSelected) ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: 24.w,
                                    height: 24.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          ThemeManager.of(context).primaryColor,
                                          ThemeManager.of(context).primaryDark,
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: ThemeManager.of(context).primaryColor.withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Prbal.check,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            onTap: () {
                              debugPrint(' PhoneLoginBottomSheet : 🌍 Country picker: Country selected');
                              debugPrint(' PhoneLoginBottomSheet : 📍 Selected country: ${country['name']}');
                              debugPrint(' PhoneLoginBottomSheet : 🏳️ Flag: ${country['flag']}');
                              debugPrint(' PhoneLoginBottomSheet : 📞 Code: ${country['code']}');

                              // Provide haptic feedback for selection
                              HapticFeedback.selectionClick();
                              debugPrint(' PhoneLoginBottomSheet : 📳 Selection haptic feedback provided');

                              debugPrint(' PhoneLoginBottomSheet : 🔄 Updating selected country state...');
                              setState(() {
                                _selectedCountryCode = country['code']!;
                                _selectedCountryFlag = country['flag']!;
                              });
                              debugPrint(' PhoneLoginBottomSheet : ✅ Country state updated successfully');
                              debugPrint(
                                  ' PhoneLoginBottomSheet : 🎯 New selection: $_selectedCountryFlag $_selectedCountryCode');

                              debugPrint(' PhoneLoginBottomSheet : 🚪 Closing country picker modal');
                              Navigator.pop(context);
                              debugPrint(' PhoneLoginBottomSheet : ✅ Country selection process completed');
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
