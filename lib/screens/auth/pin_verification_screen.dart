import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/app_services.dart';
// import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isNewUser;
  final Map<String, dynamic>? userData;

  const PinVerificationScreen({super.key, required this.phoneNumber, this.isNewUser = false, this.userData});

  @override
  ConsumerState<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends ConsumerState<PinVerificationScreen> with TickerProviderStateMixin {
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
    _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));

    _pulseController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

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
      final authService = ref.read(authProvider.notifier);

      if (widget.isNewUser) {
        // Set PIN for new user
        await authService.setPin(pin: _pinCode, confirmPin: _pinCode);

        // Use the user type from passed userData, or default to customer
        final userType = widget.userData?['userType'] ?? 'customer';

        // For new users, save the data from phone login bottom sheet
        await HiveService.setLoggedIn(true);
        await HiveService.setPhoneNumber(widget.phoneNumber);

        // Save user data with the appropriate user type
        await HiveService.saveUserData({
          'phoneNumber': widget.phoneNumber,
          'userType': userType,
          'isNewUser': true,
          ...?widget.userData, // Spread any additional data passed
        });

        if (mounted) {
          // Navigate to appropriate dashboard based on user type
          context.go('/home');
        }
      } else {
        // Verify PIN for existing user
        final response = await authService.loginWithPhonePin(phoneNumber: widget.phoneNumber, pin: _pinCode);

        if (!response.success) {
          setState(() {
            _errorMessage = response.message ?? 'Invalid PIN';
            _isLoading = false;
          });
          _shakeAndClearPin();
          return;
        }

        // PIN verified successfully, get user type and save data
        await HiveService.setLoggedIn(true);
        await HiveService.setPhoneNumber(widget.phoneNumber);

        // Get user type from auth service
        debugPrint('🔍 Fetching user type for existing user...');
        final userTypeResponse = await authService.getUserType();
        String userType = 'customer'; // default

        if (userTypeResponse.success && userTypeResponse.data != null) {
          userType = userTypeResponse.data!.userType;
          debugPrint('✅ Successfully retrieved user type: $userType');

          // Get current user data if available
          final currentUser = authService.getCurrentUser();

          // Save user data including user type
          await HiveService.saveUserData({
            if (currentUser != null) 'userId': currentUser.id,
            if (currentUser != null) 'username': currentUser.username,
            'userType': userType,
            'phoneNumber': widget.phoneNumber,
            'isNewUser': false,
          });

          debugPrint('✅ User data saved successfully with userType: $userType');
        } else {
          debugPrint('❌ Failed to get user type, using default customer type');
          debugPrint('❌ Response: success=${userTypeResponse.success}, message=${userTypeResponse.message}');

          // If user type detection fails, save with default customer type
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
              context.go(RouteEnum.adminDashboard.rawValue); // Admin will see admin dashboard through bottom navigation
              break;
            case 'provider':
              debugPrint('🧭 Navigating to provider dashboard');
              context.go(
                RouteEnum.providerDashboard.rawValue,
              ); // Provider will see provider dashboard through bottom navigation
              break;
            case 'customer':
            case 'taker':
            default:
              debugPrint('🧭 Navigating to taker/customer dashboard');
              context.go(
                RouteEnum.takerDashboard.rawValue,
              ); // Customer/taker will see taker dashboard through bottom navigation
              break;
          }
        }
      }
    } catch (e) {
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
          icon: Icon(LineIcons.arrowLeft, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.isNewUser ? 'Set PIN' : 'Enter PIN',
          style: theme.textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
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
                            colors: [colorScheme.surfaceContainerHighest, colorScheme.surface],
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
                                        colors: [colorScheme.primary, colorScheme.primaryContainer],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.primary.withValues(alpha: 0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      widget.isNewUser ? LineIcons.lockOpen : LineIcons.lock,
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
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 16.h),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.1),
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
                          offset: Offset(_shakeAnimation.value * 10 * (1 - 2 * _shakeAnimation.value).abs(), 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              final isActive = _controllers[index].text.isNotEmpty;
                              return Container(
                                width: 65.w,
                                height: 65.h,
                                decoration: BoxDecoration(
                                  gradient: isActive
                                      ? LinearGradient(
                                          colors: [
                                            colorScheme.primary.withValues(alpha: 0.1),
                                            colorScheme.primaryContainer.withValues(alpha: 0.1),
                                          ],
                                        )
                                      : null,
                                  color: isActive ? null : colorScheme.surfaceContainerHighest,
                                  border: Border.all(
                                    color: isActive ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
                                    width: isActive ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: colorScheme.primary.withValues(alpha: 0.2),
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
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(counterText: '', border: InputBorder.none),
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

                    SizedBox(height: 32.h),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: colorScheme.error.withValues(alpha: 0.3), width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(LineIcons.exclamationTriangle, color: colorScheme.error, size: 20.sp),
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
                        gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.primaryContainer]),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.isNewUser ? LineIcons.check : LineIcons.unlock,
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
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(LineIcons.userShield, color: colorScheme.primary, size: 20.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              widget.isNewUser
                                  ? 'Your PIN will be used to secure your account'
                                  : 'Keep your PIN confidential and secure',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
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
