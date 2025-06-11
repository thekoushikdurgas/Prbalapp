import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/app_services.dart';
import 'package:prbal/services/auth_service.dart';
import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';

/// PhoneLoginBottomSheet - A comprehensive phone authentication bottom sheet
///
/// This widget provides a modern, animated phone login interface with:
///
/// **Features:**
/// - Smooth slide-up and fade-in animations
/// - Phone number validation with country code selection
/// - Integration with authentication service for user lookup
/// - Social login options (Google, Apple)
/// - Responsive design with theme-aware styling
/// - Error handling with visual feedback
///
/// **Authentication Flow:**
/// 1. User enters phone number with country code
/// 2. System validates phone number format
/// 3. API call to check if user exists
/// 4. Navigation to PIN entry with user data
///
/// **State Management:**
/// - Uses Riverpod for authentication state
/// - Local state for form validation and UI interactions
/// - Animation controllers for smooth transitions
class PhoneLoginBottomSheet extends ConsumerStatefulWidget {
  const PhoneLoginBottomSheet({super.key});

  @override
  ConsumerState<PhoneLoginBottomSheet> createState() => _PhoneLoginBottomSheetState();
}

class _PhoneLoginBottomSheetState extends ConsumerState<PhoneLoginBottomSheet> with TickerProviderStateMixin {
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
    debugPrint('📱 PhoneLoginBottomSheet: Initializing phone login component');
    _initializeAnimations();
    _startAnimations();
  }

  /// Initializes animation controllers and animation objects
  ///
  /// Creates slide and fade animations for smooth bottom sheet presentation
  void _initializeAnimations() {
    debugPrint('📱 PhoneLoginBottomSheet: Setting up animation controllers');

    // Slide animation controller - controls the upward slide motion
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Fade animation controller - controls the opacity transition
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Slide animation from bottom to center
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom (off-screen)
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut, // Smooth deceleration
    ));

    // Fade animation from transparent to opaque
    _fadeAnimation = Tween<double>(
      begin: 0.0, // Start transparent
      end: 1.0, // End fully opaque
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn, // Smooth acceleration
    ));

    debugPrint('📱 PhoneLoginBottomSheet: Animation setup complete');
  }

  /// Starts the entry animations with staggered timing
  ///
  /// First slides the bottom sheet up, then fades in the content
  Future<void> _startAnimations() async {
    debugPrint('📱 PhoneLoginBottomSheet: Starting entry animations');

    // Start slide animation immediately
    _slideController.forward();

    // Wait briefly then start fade animation for staggered effect
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();

    debugPrint('📱 PhoneLoginBottomSheet: Entry animations started');
  }

  @override
  void dispose() {
    debugPrint('📱 PhoneLoginBottomSheet: Disposing resources');

    // Clean up controllers to prevent memory leaks
    _phoneController.dispose();
    _searchController.dispose();
    _slideController.dispose();
    _fadeController.dispose();

    super.dispose();
  }

  /// Validates phone number and initiates authentication flow
  ///
  /// **Process:**
  /// 1. Validates phone number format and length
  /// 2. Makes API call to check if user exists
  /// 3. Prepares user data for PIN entry screen
  /// 4. Navigates to PIN entry with appropriate data
  Future<void> _verifyPhoneNumber() async {
    debugPrint('📱 PhoneLoginBottomSheet: Starting phone number verification');
    debugPrint('📱 PhoneLoginBottomSheet: Phone number entered: $_phoneNumber');
    debugPrint('📱 PhoneLoginBottomSheet: Selected country code: $_selectedCountryCode');

    // Validate phone number format - must be at least 10 digits
    if (_phoneNumber.isEmpty || _phoneNumber.length < 10) {
      debugPrint('📱 PhoneLoginBottomSheet: Phone validation failed - invalid format');
      setState(() {
        _errorMessage = 'Please enter a valid phone number';
      });
      return;
    }

    // Provide haptic feedback for better UX
    HapticFeedback.lightImpact();
    debugPrint('📱 PhoneLoginBottomSheet: Phone validation passed, starting API call');

    // Update UI to show loading state
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get authentication service instance
      final authService = ref.read(authProvider.notifier);
      final fullPhoneNumber = _selectedCountryCode + _phoneNumber;
      debugPrint('📱 PhoneLoginBottomSheet: Full phone number: $fullPhoneNumber');

      // Check if user exists by phone number via API
      await authService.searchUserByPhone(fullPhoneNumber).then((userSearchResponse) {
        AppUser? existingUser;
        Map<String, dynamic> userData;

        debugPrint('📱 PhoneLoginBottomSheet: API response received');
        debugPrint('📱 PhoneLoginBottomSheet: API response success: ${userSearchResponse.success}');
        debugPrint('📱 PhoneLoginBottomSheet: API response message: ${userSearchResponse.message}');
        debugPrint('📱 PhoneLoginBottomSheet: API response data: ${userSearchResponse.data}');
        debugPrint('📱 PhoneLoginBottomSheet: API response data type: ${userSearchResponse.data.runtimeType}');

        if (userSearchResponse.data == null) {
          debugPrint('📱 PhoneLoginBottomSheet: New user detected - preparing default data');
          // User doesn't exist, prepare new user data with default provider type
          userData = {
            'phoneNumber': fullPhoneNumber,
            'userType': 'provider', // Default new users to provider
            'isNewUser': true,
          };
          debugPrint('📱 PhoneLoginBottomSheet: New user data prepared: $userData');
        } else {
          debugPrint('📱 PhoneLoginBottomSheet: Existing user found - processing user data');
          // User exists, use their complete data from AppUser model
          existingUser = userSearchResponse.data as AppUser;
          userData = existingUser.toJson();
          userData['isNewUser'] = false;
          // Ensure phone number is set if it was null in the user data
          userData['phone_number'] = existingUser.phoneNumber ?? fullPhoneNumber;
          debugPrint('📱 PhoneLoginBottomSheet: Existing user data: $userData');
        }

        // Update UI to hide loading state
        setState(() {
          _isLoading = false;
        });

        // Navigate to PIN entry screen with user data
        if (mounted) {
          debugPrint('📱 PhoneLoginBottomSheet: Navigating to PIN entry screen');
          context.pop(); // Close current bottom sheet
          context.push(
            RouteEnum.pinEntry.rawValue,
            extra: {
              'phoneNumber': fullPhoneNumber,
              'isNewUser': (userSearchResponse.data == null),
              'userData': userData,
              if (existingUser != null) 'userModel': existingUser, // Pass the AppUser model directly
            },
          );
          debugPrint('📱 PhoneLoginBottomSheet: Navigation to PIN entry completed');
        }
      });
    } catch (e) {
      debugPrint('📱 PhoneLoginBottomSheet: Error during phone verification: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to verify phone number. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('📱 PhoneLoginBottomSheet: Building UI components');

    // Get current theme for adaptive styling
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;

    debugPrint('📱 PhoneLoginBottomSheet: Theme mode: ${isDark ? 'dark' : 'light'}');
    debugPrint('📱 PhoneLoginBottomSheet: Screen size: ${screenSize.width}x${screenSize.height}');

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        constraints: BoxConstraints(
          // Responsive height - max 90% of screen height
          maxHeight: screenSize.height * 0.9,
        ),
        decoration: BoxDecoration(
          // Theme-aware background color
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
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
                  // Handle bar for visual feedback
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(top: 12.h),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  // Header section with title and close button
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        // Header row with close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40), // Spacer for center alignment
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            // Close button with theme-aware styling
                            GestureDetector(
                              onTap: () {
                                debugPrint('📱 PhoneLoginBottomSheet: Close button tapped');
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Icon(
                                  LineIcons.times,
                                  size: 20.sp,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8.h),

                        // Subtitle
                        Text(
                          'Enter your phone number to continue',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Phone input section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phone number label
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF374151),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Phone input field
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: _errorMessage != null
                                  ? const Color(0xFFEF4444)
                                  : (isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB)),
                              width: 1.5,
                            ),
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
                                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
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
                                          color: isDark ? Colors.white : const Color(0xFF374151),
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        LineIcons.angleDown,
                                        size: 16.sp,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                                    color: isDark ? Colors.white : const Color(0xFF374151),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '1234567890',
                                    hintStyle: TextStyle(
                                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 16.h,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    _phoneNumber = value;
                                    if (_errorMessage != null) {
                                      setState(() {
                                        _errorMessage = null;
                                      });
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
                            children: [
                              Icon(
                                LineIcons.exclamationTriangle,
                                size: 16.sp,
                                color: const Color(0xFFEF4444),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: 24.h),

                        // Continue button
                        SizedBox(
                          width: double.infinity,
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
                              disabledBackgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Divider with "or"
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDark ? Colors.grey[600] : Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark ? Colors.grey[600] : Colors.grey[300],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Social login buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildSocialButton(
                                'Google',
                                LineIcons.googleLogo,
                                Colors.red,
                                () => _handleSocialLogin('google'),
                                isDark,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildSocialButton(
                                'Apple',
                                LineIcons.apple,
                                isDark ? Colors.white : Colors.black,
                                () => _handleSocialLogin('apple'),
                                isDark,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Terms text
                        Text.rich(
                          TextSpan(
                            text: 'By continuing, you agree to our ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: const Color(0xFF3B82F6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: const Color(0xFF3B82F6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    String label,
    IconData icon,
    Color iconColor,
    VoidCallback onPressed,
    bool isDark,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white : const Color(0xFF374151),
        side: BorderSide(
          color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: iconColor,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      LineIcons.times,
                      size: 24.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Select Country',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Container(
              margin: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search countries...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                  ),
                  prefixIcon: Icon(
                    LineIcons.search,
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF374151),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

            // Country list
            Expanded(
              child: Builder(
                builder: (context) {
                  final filteredCountries = _countries.where((country) {
                    if (_searchQuery.isEmpty) return true;
                    return country['name']!.toLowerCase().contains(_searchQuery) ||
                        country['code']!.contains(_searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      final isSelected = country['code'] == _selectedCountryCode;

                      return ListTile(
                        leading: Text(
                          country['flag']!,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        title: Text(
                          country['name']!,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : const Color(0xFF374151),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country['code']!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            if (isSelected) ...[
                              SizedBox(width: 8.w),
                              Icon(
                                LineIcons.check,
                                size: 20.sp,
                                color: const Color(0xFF3B82F6),
                              ),
                            ],
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCountryCode = country['code']!;
                            _selectedCountryFlag = country['flag']!;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Comprehensive list of countries with codes and flags
  final List<Map<String, String>> _countries = [
    {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫'},
    {'name': 'Åland Islands', 'code': '+358', 'flag': '🇦🇽'},
    {'name': 'Albania', 'code': '+355', 'flag': '🇦🇱'},
    {'name': 'Algeria', 'code': '+213', 'flag': '🇩🇿'},
    {'name': 'American Samoa', 'code': '+1', 'flag': '🇦🇸'},
    {'name': 'Andorra', 'code': '+376', 'flag': '🇦🇩'},
    {'name': 'Angola', 'code': '+244', 'flag': '🇦🇴'},
    {'name': 'Anguilla', 'code': '+1', 'flag': '🇦🇮'},
    {'name': 'Antarctica', 'code': '+672', 'flag': '🇦🇶'},
    {'name': 'Antigua and Barbuda', 'code': '+1', 'flag': '🇦🇬'},
    {'name': 'Argentina', 'code': '+54', 'flag': '🇦🇷'},
    {'name': 'Armenia', 'code': '+374', 'flag': '🇦🇲'},
    {'name': 'Aruba', 'code': '+297', 'flag': '🇦🇼'},
    {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Austria', 'code': '+43', 'flag': '🇦🇹'},
    {'name': 'Azerbaijan', 'code': '+994', 'flag': '🇦🇿'},
    {'name': 'Bahamas', 'code': '+1', 'flag': '🇧🇸'},
    {'name': 'Bahrain', 'code': '+973', 'flag': '🇧🇭'},
    {'name': 'Bangladesh', 'code': '+880', 'flag': '🇧🇩'},
    {'name': 'Barbados', 'code': '+1', 'flag': '🇧🇧'},
    {'name': 'Belarus', 'code': '+375', 'flag': '🇧🇾'},
    {'name': 'Belgium', 'code': '+32', 'flag': '🇧🇪'},
    {'name': 'Belize', 'code': '+501', 'flag': '🇧🇿'},
    {'name': 'Benin', 'code': '+229', 'flag': '🇧🇯'},
    {'name': 'Bermuda', 'code': '+1', 'flag': '🇧🇲'},
    {'name': 'Bhutan', 'code': '+975', 'flag': '🇧🇹'},
    {'name': 'Bolivia', 'code': '+591', 'flag': '🇧🇴'},
    {'name': 'Bonaire, Sint Eustatius and Saba', 'code': '+599', 'flag': '🇧🇶'},
    {'name': 'Bosnia and Herzegovina', 'code': '+387', 'flag': '🇧🇦'},
    {'name': 'Botswana', 'code': '+267', 'flag': '🇧🇼'},
    {'name': 'Bouvet Island', 'code': '+47', 'flag': '🇧🇻'},
    {'name': 'Brazil', 'code': '+55', 'flag': '🇧🇷'},
    {'name': 'British Virgin Islands', 'code': '+1', 'flag': '🇻🇬'},
    {'name': 'Brunei', 'code': '+673', 'flag': '🇧🇳'},
    {'name': 'Bulgaria', 'code': '+359', 'flag': '🇧🇬'},
    {'name': 'Burkina Faso', 'code': '+226', 'flag': '🇧🇫'},
    {'name': 'Burundi', 'code': '+257', 'flag': '🇧🇮'},
    {'name': 'Cabo Verde', 'code': '+238', 'flag': '🇨🇻'},
    {'name': 'Cambodia', 'code': '+855', 'flag': '🇰🇭'},
    {'name': 'Cameroon', 'code': '+237', 'flag': '🇨🇲'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
    {'name': 'Cayman Islands', 'code': '+1', 'flag': '🇰🇾'},
    {'name': 'Central African Republic', 'code': '+236', 'flag': '🇨🇫'},
    {'name': 'Chad', 'code': '+235', 'flag': '🇹🇩'},
    {'name': 'Chile', 'code': '+56', 'flag': '🇨🇱'},
    {'name': 'China', 'code': '+86', 'flag': '🇨🇳'},
    {'name': 'Christmas Island', 'code': '+61', 'flag': '🇨🇽'},
    {'name': 'Cocos (Keeling) Islands', 'code': '+61', 'flag': '🇨🇨'},
    {'name': 'Colombia', 'code': '+57', 'flag': '🇨🇴'},
    {'name': 'Comoros', 'code': '+269', 'flag': '🇰🇲'},
    {'name': 'Congo', 'code': '+242', 'flag': '🇨🇬'},
    {'name': 'Congo (Democratic Republic)', 'code': '+243', 'flag': '🇨🇩'},
    {'name': 'Cook Islands', 'code': '+682', 'flag': '🇨🇰'},
    {'name': 'Costa Rica', 'code': '+506', 'flag': '🇨🇷'},
    {'name': 'Côte d\'Ivoire', 'code': '+225', 'flag': '🇨🇮'},
    {'name': 'Croatia', 'code': '+385', 'flag': '🇭🇷'},
    {'name': 'Cuba', 'code': '+53', 'flag': '🇨🇺'},
    {'name': 'Curaçao', 'code': '+599', 'flag': '🇨🇼'},
    {'name': 'Cyprus', 'code': '+357', 'flag': '🇨🇾'},
    {'name': 'Czech Republic', 'code': '+420', 'flag': '🇨🇿'},
    {'name': 'Denmark', 'code': '+45', 'flag': '🇩🇰'},
    {'name': 'Djibouti', 'code': '+253', 'flag': '🇩🇯'},
    {'name': 'Dominica', 'code': '+1', 'flag': '🇩🇲'},
    {'name': 'Dominican Republic', 'code': '+1', 'flag': '🇩🇴'},
    {'name': 'Ecuador', 'code': '+593', 'flag': '🇪🇨'},
    {'name': 'Egypt', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'El Salvador', 'code': '+503', 'flag': '🇸🇻'},
    {'name': 'Equatorial Guinea', 'code': '+240', 'flag': '🇬🇶'},
    {'name': 'Eritrea', 'code': '+291', 'flag': '🇪🇷'},
    {'name': 'Estonia', 'code': '+372', 'flag': '🇪🇪'},
    {'name': 'Eswatini', 'code': '+268', 'flag': '🇸🇿'},
    {'name': 'Ethiopia', 'code': '+251', 'flag': '🇪🇹'},
    {'name': 'Falkland Islands', 'code': '+500', 'flag': '🇫🇰'},
    {'name': 'Faroe Islands', 'code': '+298', 'flag': '🇫🇴'},
    {'name': 'Fiji', 'code': '+679', 'flag': '🇫🇯'},
    {'name': 'Finland', 'code': '+358', 'flag': '🇫🇮'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'French Guiana', 'code': '+594', 'flag': '🇬🇫'},
    {'name': 'French Polynesia', 'code': '+689', 'flag': '🇵🇫'},
    {'name': 'French Southern Territories', 'code': '+262', 'flag': '🇹🇫'},
    {'name': 'Gabon', 'code': '+241', 'flag': '🇬🇦'},
    {'name': 'Gambia', 'code': '+220', 'flag': '🇬🇲'},
    {'name': 'Georgia', 'code': '+995', 'flag': '🇬🇪'},
    {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭'},
    {'name': 'Gibraltar', 'code': '+350', 'flag': '🇬🇮'},
    {'name': 'Greece', 'code': '+30', 'flag': '🇬🇷'},
    {'name': 'Greenland', 'code': '+299', 'flag': '🇬🇱'},
    {'name': 'Grenada', 'code': '+1', 'flag': '🇬🇩'},
    {'name': 'Guadeloupe', 'code': '+590', 'flag': '🇬🇵'},
    {'name': 'Guam', 'code': '+1', 'flag': '🇬🇺'},
    {'name': 'Guatemala', 'code': '+502', 'flag': '🇬🇹'},
    {'name': 'Guernsey', 'code': '+44', 'flag': '🇬🇬'},
    {'name': 'Guinea', 'code': '+224', 'flag': '🇬🇳'},
    {'name': 'Guinea-Bissau', 'code': '+245', 'flag': '🇬🇼'},
    {'name': 'Guyana', 'code': '+592', 'flag': '🇬🇾'},
    {'name': 'Haiti', 'code': '+509', 'flag': '🇭🇹'},
    {'name': 'Heard Island and McDonald Islands', 'code': '+672', 'flag': '🇭🇲'},
    {'name': 'Holy See', 'code': '+379', 'flag': '🇻🇦'},
    {'name': 'Honduras', 'code': '+504', 'flag': '🇭🇳'},
    {'name': 'Hong Kong', 'code': '+852', 'flag': '🇭🇰'},
    {'name': 'Hungary', 'code': '+36', 'flag': '🇭🇺'},
    {'name': 'Iceland', 'code': '+354', 'flag': '🇮🇸'},
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'Indonesia', 'code': '+62', 'flag': '🇮🇩'},
    {'name': 'Iran', 'code': '+98', 'flag': '🇮🇷'},
    {'name': 'Iraq', 'code': '+964', 'flag': '🇮🇶'},
    {'name': 'Ireland', 'code': '+353', 'flag': '🇮🇪'},
    {'name': 'Isle of Man', 'code': '+44', 'flag': '🇮🇲'},
    {'name': 'Israel', 'code': '+972', 'flag': '🇮🇱'},
    {'name': 'Italy', 'code': '+39', 'flag': '🇮🇹'},
    {'name': 'Jamaica', 'code': '+1', 'flag': '🇯🇲'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Jersey', 'code': '+44', 'flag': '🇯🇪'},
    {'name': 'Jordan', 'code': '+962', 'flag': '🇯🇴'},
    {'name': 'Kazakhstan', 'code': '+7', 'flag': '🇰🇿'},
    {'name': 'Kenya', 'code': '+254', 'flag': '🇰🇪'},
    {'name': 'Kiribati', 'code': '+686', 'flag': '🇰🇮'},
    {'name': 'Kuwait', 'code': '+965', 'flag': '🇰🇼'},
    {'name': 'Kyrgyzstan', 'code': '+996', 'flag': '🇰🇬'},
    {'name': 'Laos', 'code': '+856', 'flag': '🇱🇦'},
    {'name': 'Latvia', 'code': '+371', 'flag': '🇱🇻'},
    {'name': 'Lebanon', 'code': '+961', 'flag': '🇱🇧'},
    {'name': 'Lesotho', 'code': '+266', 'flag': '🇱🇸'},
    {'name': 'Liberia', 'code': '+231', 'flag': '🇱🇷'},
    {'name': 'Libya', 'code': '+218', 'flag': '🇱🇾'},
    {'name': 'Liechtenstein', 'code': '+423', 'flag': '🇱🇮'},
    {'name': 'Lithuania', 'code': '+370', 'flag': '🇱🇹'},
    {'name': 'Luxembourg', 'code': '+352', 'flag': '🇱🇺'},
    {'name': 'Macao', 'code': '+853', 'flag': '🇲🇴'},
    {'name': 'Madagascar', 'code': '+261', 'flag': '🇲🇬'},
    {'name': 'Malawi', 'code': '+265', 'flag': '🇲🇼'},
    {'name': 'Malaysia', 'code': '+60', 'flag': '🇲🇾'},
    {'name': 'Maldives', 'code': '+960', 'flag': '🇲🇻'},
    {'name': 'Mali', 'code': '+223', 'flag': '🇲🇱'},
    {'name': 'Malta', 'code': '+356', 'flag': '🇲🇹'},
    {'name': 'Marshall Islands', 'code': '+692', 'flag': '🇲🇭'},
    {'name': 'Martinique', 'code': '+596', 'flag': '🇲🇶'},
    {'name': 'Mauritania', 'code': '+222', 'flag': '🇲🇷'},
    {'name': 'Mauritius', 'code': '+230', 'flag': '🇲🇺'},
    {'name': 'Mayotte', 'code': '+262', 'flag': '🇾🇹'},
    {'name': 'Mexico', 'code': '+52', 'flag': '🇲🇽'},
    {'name': 'Micronesia', 'code': '+691', 'flag': '🇫🇲'},
    {'name': 'Moldova', 'code': '+373', 'flag': '🇲🇩'},
    {'name': 'Monaco', 'code': '+377', 'flag': '🇲🇨'},
    {'name': 'Mongolia', 'code': '+976', 'flag': '🇲🇳'},
    {'name': 'Montenegro', 'code': '+382', 'flag': '🇲🇪'},
    {'name': 'Montserrat', 'code': '+1', 'flag': '🇲🇸'},
    {'name': 'Morocco', 'code': '+212', 'flag': '🇲🇦'},
    {'name': 'Mozambique', 'code': '+258', 'flag': '🇲🇿'},
    {'name': 'Myanmar', 'code': '+95', 'flag': '🇲🇲'},
    {'name': 'Namibia', 'code': '+264', 'flag': '🇳🇦'},
    {'name': 'Nauru', 'code': '+674', 'flag': '🇳🇷'},
    {'name': 'Nepal', 'code': '+977', 'flag': '🇳🇵'},
    {'name': 'Netherlands', 'code': '+31', 'flag': '🇳🇱'},
    {'name': 'New Caledonia', 'code': '+687', 'flag': '🇳🇨'},
    {'name': 'New Zealand', 'code': '+64', 'flag': '🇳🇿'},
    {'name': 'Nicaragua', 'code': '+505', 'flag': '🇳🇮'},
    {'name': 'Niger', 'code': '+227', 'flag': '🇳🇪'},
    {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
    {'name': 'Niue', 'code': '+683', 'flag': '🇳🇺'},
    {'name': 'Norfolk Island', 'code': '+672', 'flag': '🇳🇫'},
    {'name': 'North Korea', 'code': '+850', 'flag': '🇰🇵'},
    {'name': 'North Macedonia', 'code': '+389', 'flag': '🇲🇰'},
    {'name': 'Northern Mariana Islands', 'code': '+1', 'flag': '🇲🇵'},
    {'name': 'Norway', 'code': '+47', 'flag': '🇳🇴'},
    {'name': 'Oman', 'code': '+968', 'flag': '🇴🇲'},
    {'name': 'Pakistan', 'code': '+92', 'flag': '🇵🇰'},
    {'name': 'Palau', 'code': '+680', 'flag': '🇵🇼'},
    {'name': 'Palestine', 'code': '+970', 'flag': '🇵🇸'},
    {'name': 'Panama', 'code': '+507', 'flag': '🇵🇦'},
    {'name': 'Papua New Guinea', 'code': '+675', 'flag': '🇵🇬'},
    {'name': 'Paraguay', 'code': '+595', 'flag': '🇵🇾'},
    {'name': 'Peru', 'code': '+51', 'flag': '🇵🇪'},
    {'name': 'Philippines', 'code': '+63', 'flag': '🇵🇭'},
    {'name': 'Pitcairn', 'code': '+64', 'flag': '🇵🇳'},
    {'name': 'Poland', 'code': '+48', 'flag': '🇵🇱'},
    {'name': 'Portugal', 'code': '+351', 'flag': '🇵🇹'},
    {'name': 'Puerto Rico', 'code': '+1', 'flag': '🇵🇷'},
    {'name': 'Qatar', 'code': '+974', 'flag': '🇶🇦'},
    {'name': 'Réunion', 'code': '+262', 'flag': '🇷🇪'},
    {'name': 'Romania', 'code': '+40', 'flag': '🇷🇴'},
    {'name': 'Russia', 'code': '+7', 'flag': '🇷🇺'},
    {'name': 'Rwanda', 'code': '+250', 'flag': '🇷🇼'},
    {'name': 'Saint Barthélemy', 'code': '+590', 'flag': '🇧🇱'},
    {'name': 'Saint Helena', 'code': '+290', 'flag': '🇸🇭'},
    {'name': 'Saint Kitts and Nevis', 'code': '+1', 'flag': '🇰🇳'},
    {'name': 'Saint Lucia', 'code': '+1', 'flag': '🇱🇨'},
    {'name': 'Saint Martin (French part)', 'code': '+590', 'flag': '🇲🇫'},
    {'name': 'Saint Pierre and Miquelon', 'code': '+508', 'flag': '🇵🇲'},
    {'name': 'Saint Vincent and the Grenadines', 'code': '+1', 'flag': '🇻🇨'},
    {'name': 'Samoa', 'code': '+685', 'flag': '🇼🇸'},
    {'name': 'San Marino', 'code': '+378', 'flag': '🇸🇲'},
    {'name': 'São Tomé and Príncipe', 'code': '+239', 'flag': '🇸🇹'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'Senegal', 'code': '+221', 'flag': '🇸🇳'},
    {'name': 'Serbia', 'code': '+381', 'flag': '🇷🇸'},
    {'name': 'Seychelles', 'code': '+248', 'flag': '🇸🇨'},
    {'name': 'Sierra Leone', 'code': '+232', 'flag': '🇸🇱'},
    {'name': 'Singapore', 'code': '+65', 'flag': '🇸🇬'},
    {'name': 'Sint Maarten (Dutch part)', 'code': '+1', 'flag': '🇸🇽'},
    {'name': 'Slovakia', 'code': '+421', 'flag': '🇸🇰'},
    {'name': 'Slovenia', 'code': '+386', 'flag': '🇸🇮'},
    {'name': 'Solomon Islands', 'code': '+677', 'flag': '🇸🇧'},
    {'name': 'Somalia', 'code': '+252', 'flag': '🇸🇴'},
    {'name': 'South Africa', 'code': '+27', 'flag': '🇿🇦'},
    {'name': 'South Georgia and the South Sandwich Islands', 'code': '+500', 'flag': '🇬🇸'},
    {'name': 'South Korea', 'code': '+82', 'flag': '🇰🇷'},
    {'name': 'South Sudan', 'code': '+211', 'flag': '🇸🇸'},
    {'name': 'Spain', 'code': '+34', 'flag': '🇪🇸'},
    {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰'},
    {'name': 'Sudan', 'code': '+249', 'flag': '🇸🇩'},
    {'name': 'Suriname', 'code': '+597', 'flag': '🇸🇷'},
    {'name': 'Svalbard and Jan Mayen', 'code': '+47', 'flag': '🇸🇯'},
    {'name': 'Sweden', 'code': '+46', 'flag': '🇸🇪'},
    {'name': 'Switzerland', 'code': '+41', 'flag': '🇨🇭'},
    {'name': 'Syria', 'code': '+963', 'flag': '🇸🇾'},
    {'name': 'Taiwan', 'code': '+886', 'flag': '🇹🇼'},
    {'name': 'Tajikistan', 'code': '+992', 'flag': '🇹🇯'},
    {'name': 'Tanzania', 'code': '+255', 'flag': '🇹🇿'},
    {'name': 'Thailand', 'code': '+66', 'flag': '🇹🇭'},
    {'name': 'Timor-Leste', 'code': '+670', 'flag': '🇹🇱'},
    {'name': 'Togo', 'code': '+228', 'flag': '🇹🇬'},
    {'name': 'Tokelau', 'code': '+690', 'flag': '🇹🇰'},
    {'name': 'Tonga', 'code': '+676', 'flag': '🇹🇴'},
    {'name': 'Trinidad and Tobago', 'code': '+1', 'flag': '🇹🇹'},
    {'name': 'Tunisia', 'code': '+216', 'flag': '🇹🇳'},
    {'name': 'Turkey', 'code': '+90', 'flag': '🇹🇷'},
    {'name': 'Turkmenistan', 'code': '+993', 'flag': '🇹🇲'},
    {'name': 'Turks and Caicos Islands', 'code': '+1', 'flag': '🇹🇨'},
    {'name': 'Tuvalu', 'code': '+688', 'flag': '🇹🇻'},
    {'name': 'Uganda', 'code': '+256', 'flag': '🇺🇬'},
    {'name': 'Ukraine', 'code': '+380', 'flag': '🇺🇦'},
    {'name': 'United Arab Emirates', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'United States Minor Outlying Islands', 'code': '+1', 'flag': '🇺🇲'},
    {'name': 'Uruguay', 'code': '+598', 'flag': '🇺🇾'},
    {'name': 'US Virgin Islands', 'code': '+1', 'flag': '🇻🇮'},
    {'name': 'Uzbekistan', 'code': '+998', 'flag': '🇺🇿'},
    {'name': 'Vanuatu', 'code': '+678', 'flag': '🇻🇺'},
    {'name': 'Venezuela', 'code': '+58', 'flag': '🇻🇪'},
    {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'},
    {'name': 'Wallis and Futuna', 'code': '+681', 'flag': '🇼🇫'},
    {'name': 'Western Sahara', 'code': '+212', 'flag': '🇪🇭'},
    {'name': 'Yemen', 'code': '+967', 'flag': '🇾🇪'},
    {'name': 'Zambia', 'code': '+260', 'flag': '🇿🇲'},
    {'name': 'Zimbabwe', 'code': '+263', 'flag': '🇿🇼'},
  ];

  void _handleSocialLogin(String provider) {
    // Implement social login logic
    debugPrint('Social login with $provider');
  }
}
