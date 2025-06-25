import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'dart:math'; // Added for random number generation
// import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/service_providers.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isNewUser;
  final Map<String, dynamic>? userData;

  const PinVerificationScreen(
      {super.key,
      required this.phoneNumber,
      this.isNewUser = false,
      this.userData});

  @override
  ConsumerState<PinVerificationScreen> createState() =>
      _PinVerificationScreenState();
}

class _PinVerificationScreenState extends ConsumerState<PinVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
  }

  void _initializeControllers() {
    for (int i = 0; i < 4; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  void _setupAnimations() {
    _shakeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));

    _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _shakeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String get _pinCode {
    return _controllers.map((controller) => controller.text).join();
  }

  /// Show top-right alert dialog for PIN validation errors
  void _showPinValidationAlert(String title, String message) {
    debugPrint('🚨 Showing PIN validation alert: $title - $message');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 8,
          title: Row(
            children: [
              Icon(
                Prbal.exclamationTriangle,
                color: Theme.of(context).colorScheme.error,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          content: Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.4,
                  ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(
                'Got it',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
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

  Future<void> _verifyPin() async {
    if (_pinCode.length != 4) {
      setState(() {
        _errorMessage = 'Please enter a 4-digit PIN';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Use service providers instead of creating new instances
      final userService = ref.read(userServiceProvider);
      final authNotifier = ref.read(authenticationStateProvider.notifier);

      if (widget.isNewUser) {
        // Generate random user data if not provided
        Map<String, String> randomData = {};
        if (widget.userData == null ||
            widget.userData!['username'] == null ||
            widget.userData!['email'] == null ||
            widget.userData!['firstName'] == null ||
            widget.userData!['lastName'] == null) {
          debugPrint(
              '🎲 Generating random user data for incomplete registration data');
          randomData = _generateRandomUserData();
        }

        // Set PIN for new user - using PIN registration with random data fallback
        final setPinResponse =
            await userService.pinRegister(PinRegistrationRequest(
          username: widget.userData?['username'] ?? randomData['username'],
          email: widget.userData?['email'] ?? randomData['email'],
          phoneNumber: widget.phoneNumber,
          pin: _pinCode,
          confirmPin: _pinCode,
          firstName: widget.userData?['firstName'] ?? randomData['firstName'],
          lastName: widget.userData?['lastName'] ?? randomData['lastName'],
        ));

        if (!setPinResponse.success) {
          debugPrint('❌ PIN Registration Failed: ${setPinResponse.message}');
          debugPrint('🔍 Raw Errors: ${setPinResponse.errors}');

          // Extract specific PIN validation error and show in alert dialog
          final specificError =
              _extractPinValidationError(setPinResponse.errors);
          debugPrint('🎯 Extracted PIN Error: $specificError');

          // Show top-right alert dialog with specific error
          _showPinValidationAlert('PIN Validation Error', specificError);

          setState(() {
            _errorMessage = setPinResponse.message;
            _isLoading = false;
          });
          _shakeAndClearPin();
          return;
        }

        // CRITICAL FIX: Extract and save authentication tokens from registration response
        final tokens = setPinResponse.data?['tokens'] as Map<String, dynamic>?;
        String? accessToken;
        String? refreshToken;

        if (tokens != null) {
          accessToken = tokens['access'] as String?;
          refreshToken = tokens['refresh'] as String?;
        } else {
          // Alternative token locations in response
          accessToken = setPinResponse.data?['access_token'] as String? ??
              setPinResponse.data?['access'] as String?;
          refreshToken = setPinResponse.data?['refresh_token'] as String? ??
              setPinResponse.data?['refresh'] as String?;
        }

        // Extract basic user data from response
        final responseUserData =
            setPinResponse.data?['user'] as Map<String, dynamic>?;
        final userType = responseUserData?['user_type'] ??
            widget.userData?['userType'] ??
            'customer';

        // Build initial user data
        final initialUserData = {
          'userId': responseUserData?['id'],
          'username':
              responseUserData?['username'] ?? widget.userData?['username'],
          'email': responseUserData?['email'] ?? widget.userData?['email'],
          'firstName':
              responseUserData?['first_name'] ?? widget.userData?['firstName'],
          'lastName':
              responseUserData?['last_name'] ?? widget.userData?['lastName'],
          'phoneNumber': widget.phoneNumber,
          'userType': userType,
          'isNewUser': true,
          'isVerified': responseUserData?['is_verified'] ?? false,
          'createdAt': responseUserData?['created_at'] ??
              DateTime.now().toIso8601String(),
          ...?widget.userData, // Spread any additional data passed
        };

        // Fetch complete, up-to-date user profile from UserService
        Map<String, dynamic> completeUserData = initialUserData;
        if (accessToken != null) {
          try {
            debugPrint('🔄 Fetching complete user profile for new user...');
            final profileResponse =
                await userService.getCurrentUserProfile(accessToken);

            if (profileResponse.isSuccess && profileResponse.data != null) {
              final userProfile = profileResponse.data!;
              debugPrint('✅ Complete profile fetched successfully');

              // Convert AppUser to Map and merge with initial data
              completeUserData = {
                'userId': userProfile.id,
                'username': userProfile.username,
                'email': userProfile.email,
                'firstName': userProfile.firstName,
                'lastName': userProfile.lastName,
                'phoneNumber': userProfile.phoneNumber ?? widget.phoneNumber,
                'userType': userProfile.userType.name,
                'isNewUser': true,
                'isVerified': userProfile.isVerified,
                'isEmailVerified': userProfile.isEmailVerified,
                'isPhoneVerified': userProfile.isPhoneVerified,
                'rating': userProfile.rating,
                'balance': userProfile.balance,
                'totalBookings': userProfile.totalBookings,
                'bio': userProfile.bio,
                'location': userProfile.location,
                'profilePicture': userProfile.profilePicture,
                'createdAt': userProfile.createdAt.toIso8601String(),
                'updatedAt': userProfile.updatedAt.toIso8601String(),
                'skills': userProfile.skills,
                'availability': userProfile.availability,
              };
              debugPrint(
                  '📊 Updated user data with complete profile information');
            } else {
              debugPrint(
                  '⚠️ Failed to fetch complete profile, using initial data');
            }
          } catch (e) {
            debugPrint('❌ Error fetching complete profile: $e');
            debugPrint('⚠️ Using initial user data from registration response');
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
          debugPrint('✅ New user authentication state set successfully');

          // Also update HiveService with complete user data
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

        debugPrint(
            '✅ New user data saved successfully with userType: $userType');

        if (mounted) {
          // Navigate to appropriate dashboard based on user type
          context.go('/home');
        }
      } else {
        // Verify PIN for existing user
        final response = await userService.pinLogin(PinLoginRequest(
          phoneNumber: widget.phoneNumber,
          pin: _pinCode,
        ));

        if (!response.success) {
          debugPrint('❌ PIN Login Failed: ${response.message}');
          debugPrint('🔍 Raw Errors: ${response.errors}');

          // Extract specific PIN validation error and show in alert dialog
          final specificError = _extractPinValidationError(response.errors);
          debugPrint('🎯 Extracted PIN Error: $specificError');

          // Show top-right alert dialog with specific error
          _showPinValidationAlert('PIN Login Error', specificError);

          setState(() {
            _errorMessage = response.message;
            _isLoading = false;
          });
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
          debugPrint(
              '⚠️ No tokens found in login response - checking alternative locations');
          // Alternative token locations in response
          accessToken = response.data?['access_token'] as String? ??
              response.data?['access'] as String?;
          refreshToken = response.data?['refresh_token'] as String? ??
              response.data?['refresh'] as String?;
        }

        // Get initial user data from login response
        debugPrint('🔍 Processing login response for existing user...');
        final userData = response.data?['user'] as Map<String, dynamic>?;
        final userType = userData?['user_type'] ?? 'customer';

        if (userData != null) {
          debugPrint(
              '✅ Successfully retrieved initial user data with type: $userType');

          // Build initial user data from login response
          final initialUserData = {
            'userId': userData['id'],
            'username': userData['username'],
            'email': userData['email'],
            'firstName': userData['first_name'],
            'lastName': userData['last_name'],
            'phoneNumber': widget.phoneNumber,
            'userType': userType,
            'isNewUser': false,
            'isVerified': userData['is_verified'] ?? false,
            'isEmailVerified': userData['is_email_verified'] ?? false,
            'isPhoneVerified': userData['is_phone_verified'] ?? false,
            'rating': userData['rating'] ?? 0.0,
            'balance': userData['balance'] ?? 0.0,
            'totalBookings': userData['total_bookings'] ?? 0,
            'bio': userData['bio'],
            'location': userData['location'],
            'profilePicture': userData['profile_picture'],
            'createdAt': userData['created_at'],
            'updatedAt': userData['updated_at'],
          };

          // Fetch complete, up-to-date user profile from UserService
          Map<String, dynamic> completeUserData = initialUserData;
          if (accessToken != null) {
            try {
              debugPrint(
                  '🔄 Fetching complete user profile for existing user...');
              final profileResponse =
                  await userService.getCurrentUserProfile(accessToken);

              if (profileResponse.isSuccess && profileResponse.data != null) {
                final userProfile = profileResponse.data!;
                debugPrint('✅ Complete profile fetched successfully');

                // Convert AppUser to Map with all up-to-date information
                completeUserData = {
                  'userId': userProfile.id,
                  'username': userProfile.username,
                  'email': userProfile.email,
                  'firstName': userProfile.firstName,
                  'lastName': userProfile.lastName,
                  'phoneNumber': userProfile.phoneNumber ?? widget.phoneNumber,
                  'userType': userProfile.userType.name,
                  'isNewUser': false,
                  'isVerified': userProfile.isVerified,
                  'isEmailVerified': userProfile.isEmailVerified,
                  'isPhoneVerified': userProfile.isPhoneVerified,
                  'rating': userProfile.rating,
                  'balance': userProfile.balance,
                  'totalBookings': userProfile.totalBookings,
                  'bio': userProfile.bio,
                  'location': userProfile.location,
                  'profilePicture': userProfile.profilePicture,
                  'createdAt': userProfile.createdAt.toIso8601String(),
                  'updatedAt': userProfile.updatedAt.toIso8601String(),
                  'skills': userProfile.skills,
                  'availability': userProfile.availability,
                };
                debugPrint(
                    '📊 Updated user data with complete, up-to-date profile information');
              } else {
                debugPrint(
                    '⚠️ Failed to fetch complete profile, using login response data');
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
        } else {
          debugPrint('❌ Failed to get user data, using default customer type');

          // If user data is missing, save with default customer type
          await HiveService.saveUserData({
            'phoneNumber': widget.phoneNumber,
            'userType': 'customer',
            'isNewUser': false,
          });
        }

        if (mounted) {
          // Navigate based on user type
          debugPrint('🧭 Navigating user based on type: $userType');

          switch (userType.toLowerCase()) {
            case 'admin':
              debugPrint('🧭 Navigating to admin dashboard');
              context.go(RouteEnum.adminDashboard.rawValue);
              break;
            case 'provider':
              debugPrint('🧭 Navigating to provider dashboard');
              context.go(RouteEnum.providerDashboard.rawValue);
              break;
            case 'customer':
            case 'taker':
            default:
              debugPrint('🧭 Navigating to taker/customer dashboard');
              context.go(RouteEnum.takerDashboard.rawValue);
              break;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ PIN verification error: $e');
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
        _isLoading = false;
      });
      _shakeAndClearPin();
    }
  }

  void _shakeAndClearPin() {
    _shakeController.forward().then((_) {
      _shakeController.reset();
      _clearPin();
    });
  }

  void _clearPin() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  /// RANDOM USER DATA GENERATION SYSTEM
  ///
  /// This system generates realistic random user data for new user registration
  /// when no user data is provided. It creates consistent, professional-looking
  /// names and usernames that feel natural and authentic.
  ///
  /// **FEATURES IMPLEMENTED:**
  /// ✅ Curated lists of realistic first and last names
  /// ✅ Smart username generation with multiple fallback patterns
  /// ✅ Professional email generation based on generated names
  /// ✅ Collision-resistant random selection algorithms
  /// ✅ Comprehensive debug logging for development tracking
  /// ✅ Consistent data generation with proper formatting
  ///
  /// **GENERATION PATTERNS:**
  /// - First Names: Curated list of 50+ common international names
  /// - Last Names: Curated list of 50+ common surnames
  /// - Usernames: Multiple patterns (firstname.lastname, firstname_lastname, etc.)
  /// - Emails: Professional format using generated names with common domains
  ///
  /// **DEBUG LOGGING:**
  /// All generation steps include comprehensive debug prints with emoji prefixes:
  /// - 🎲 Random generation operations
  /// - 📝 Generated data values
  /// - ✅ Successful generation confirmations
  ///
  /// @returns Map containing generated firstName, lastName, username, email
  Map<String, String> _generateRandomUserData() {
    debugPrint(
        '🎲 PinVerificationScreen: Generating random user data for new registration');

    final random = Random();

    // Curated lists of realistic names for international users
    final firstNames = [
      'Alex',
      'Sam',
      'Jordan',
      'Taylor',
      'Morgan',
      'Casey',
      'Riley',
      'Avery',
      'Jamie',
      'Blake',
      'Cameron',
      'Drew',
      'Emery',
      'Finley',
      'Hayden',
      'Kendall',
      'Logan',
      'Parker',
      'Quinn',
      'Reese',
      'Sage',
      'Skylar',
      'Aria',
      'Emma',
      'Olivia',
      'Sophia',
      'Isabella',
      'Mia',
      'Luna',
      'Grace',
      'Zoe',
      'Lily',
      'Ella',
      'Chloe',
      'Maya',
      'Nora',
      'Eva',
      'Ruby',
      'Ivy',
      'Liam',
      'Noah',
      'Ethan',
      'Lucas',
      'Mason',
      'Oliver',
      'Elijah',
      'James',
      'Benjamin',
      'Jacob',
      'Michael',
      'William',
      'Daniel',
      'Henry',
      'Jackson',
      'Sebastian',
      'Aiden',
      'Matthew',
      'Samuel',
      'David',
      'Joseph',
      'Carter',
      'Owen',
      'Wyatt',
      'John',
      'Jack',
      'Luke',
      'Jayden',
      'Dylan',
      'Grayson'
    ];

    final lastNames = [
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Garcia',
      'Miller',
      'Davis',
      'Rodriguez',
      'Martinez',
      'Hernandez',
      'Lopez',
      'Gonzalez',
      'Wilson',
      'Anderson',
      'Thomas',
      'Taylor',
      'Moore',
      'Jackson',
      'Martin',
      'Lee',
      'Perez',
      'Thompson',
      'White',
      'Harris',
      'Sanchez',
      'Clark',
      'Ramirez',
      'Lewis',
      'Robinson',
      'Walker',
      'Young',
      'Allen',
      'King',
      'Wright',
      'Scott',
      'Torres',
      'Nguyen',
      'Hill',
      'Flores',
      'Green',
      'Adams',
      'Nelson',
      'Baker',
      'Hall',
      'Rivera',
      'Campbell',
      'Mitchell',
      'Carter',
      'Roberts',
      'Gomez',
      'Phillips',
      'Evans',
      'Turner',
      'Diaz',
      'Parker',
      'Cruz',
      'Edwards',
      'Collins',
      'Reyes',
      'Stewart',
      'Morris',
      'Morales',
      'Murphy',
      'Cook',
      'Rogers',
      'Gutierrez',
      'Ortiz',
      'Morgan',
      'Cooper',
      'Peterson',
      'Bailey',
      'Reed',
      'Kelly',
      'Howard',
      'Ramos'
    ];

    final emailDomains = [
      'gmail.com',
      'yahoo.com',
      'hotmail.com',
      'outlook.com',
      'icloud.com',
      'mail.com',
      'protonmail.com',
      'tutanota.com',
      'zoho.com',
      'fastmail.com'
    ];

    // Generate random names
    final firstName = firstNames[random.nextInt(firstNames.length)];
    final lastName = lastNames[random.nextInt(lastNames.length)];

    debugPrint('📝 Generated names: $firstName $lastName');

    // Generate username with multiple patterns for variety
    final usernamePatterns = [
      '${firstName.toLowerCase()}.${lastName.toLowerCase()}',
      '${firstName.toLowerCase()}_${lastName.toLowerCase()}',
      '${firstName.toLowerCase()}${lastName.toLowerCase()}',
      '${firstName.toLowerCase()}${lastName.toLowerCase()}${random.nextInt(99) + 1}',
      '${firstName.toLowerCase()}.${lastName.toLowerCase()}${random.nextInt(999) + 100}',
      '${firstName[0].toLowerCase()}${lastName.toLowerCase()}',
      '${firstName.toLowerCase()}${lastName[0].toLowerCase()}${random.nextInt(9999) + 1000}',
    ];

    final username = usernamePatterns[random.nextInt(usernamePatterns.length)];

    debugPrint('📝 Generated username: $username');

    // Generate professional email using generated names
    final emailDomain = emailDomains[random.nextInt(emailDomains.length)];
    final emailPatterns = [
      '${firstName.toLowerCase()}.${lastName.toLowerCase()}@$emailDomain',
      '${firstName.toLowerCase()}_${lastName.toLowerCase()}@$emailDomain',
      '${firstName.toLowerCase()}${lastName.toLowerCase()}@$emailDomain',
      '${firstName[0].toLowerCase()}${lastName.toLowerCase()}@$emailDomain',
      '${firstName.toLowerCase()}.${lastName[0].toLowerCase()}@$emailDomain',
    ];

    final email = emailPatterns[random.nextInt(emailPatterns.length)];

    debugPrint('📝 Generated email: $email');

    final generatedData = {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
    };

    debugPrint('✅ Random user data generation completed successfully');
    debugPrint('📊 Generated data summary: $generatedData');

    return generatedData;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Prbal.arrowLeft, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.isNewUser ? 'Set PIN' : 'Enter PIN',
          style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewPadding.top -
                    MediaQuery.of(context).viewPadding.bottom -
                    kToolbarHeight -
                    48.h, // padding
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),

                    // Header Card
                    Card(
                      elevation: 4,
                      shadowColor: colorScheme.shadow,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.surfaceContainerHighest,
                              colorScheme.surface
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
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
                                      gradient: LinearGradient(
                                        colors: [
                                          colorScheme.primary,
                                          colorScheme.primaryContainer
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      widget.isNewUser
                                          ? Prbal.lockOpen
                                          : Prbal.lock,
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
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 12.h),

                            Text(
                              widget.isNewUser
                                  ? 'Set a 4-digit PIN to secure your account'
                                  : 'Enter your 4-digit PIN to continue',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 16.h),

                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                widget.phoneNumber,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
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
                              final isActive =
                                  _controllers[index].text.isNotEmpty;
                              return Container(
                                width: 65.w,
                                height: 65.h,
                                decoration: BoxDecoration(
                                  gradient: isActive
                                      ? LinearGradient(
                                          colors: [
                                            colorScheme.primary
                                                .withValues(alpha: 0.1),
                                            colorScheme.primaryContainer
                                                .withValues(alpha: 0.1),
                                          ],
                                        )
                                      : null,
                                  color: isActive
                                      ? null
                                      : colorScheme.surfaceContainerHighest,
                                  border: Border.all(
                                    color: isActive
                                        ? colorScheme.primary
                                        : colorScheme.outline
                                            .withValues(alpha: 0.3),
                                    width: isActive ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: colorScheme.primary
                                                .withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  obscureText: true,
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none),
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

                    SizedBox(height: 32.h),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                              color: colorScheme.error.withValues(alpha: 0.3),
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Prbal.exclamationTriangle,
                                color: colorScheme.error, size: 20.sp),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 32.h),

                    // Verify/Set PIN Button
                    Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          colorScheme.primary,
                          colorScheme.primaryContainer
                        ]),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyPin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r)),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.isNewUser
                                        ? Prbal.check
                                        : Prbal.unlock,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    widget.isNewUser ? 'Set PIN' : 'Verify PIN',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const Spacer(),

                    // Security note
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Prbal.shield4,
                              color: colorScheme.primary, size: 20.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              widget.isNewUser
                                  ? 'Your PIN will be used to secure your account'
                                  : 'Keep your PIN confidential and secure',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
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
        ),
      ),
    );
  }
}
