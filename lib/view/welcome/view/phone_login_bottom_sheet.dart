import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/app_services.dart';
import 'package:prbal/product/enum/route_enum.dart';

class PhoneLoginBottomSheet extends ConsumerStatefulWidget {
  const PhoneLoginBottomSheet({super.key});

  @override
  ConsumerState<PhoneLoginBottomSheet> createState() =>
      _PhoneLoginBottomSheetState();
}

class _PhoneLoginBottomSheetState extends ConsumerState<PhoneLoginBottomSheet>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _phoneNumber = '';
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
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
  }

  Future<void> _startAnimations() async {
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhoneNumber() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authProvider.notifier);

      // Check if user exists by phone number
      final userSearchResponse =
          await authService.searchUserByPhone(_phoneNumber);
      final userExists = userSearchResponse.success &&
          userSearchResponse.data != null &&
          userSearchResponse.data!.isNotEmpty;

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        context.pop();
        context.push(
          RouteEnum.pinEntry.rawValue,
          extra: {
            'phoneNumber': _phoneNumber,
            'isNewUser': !userExists,
          },
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to verify phone number. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
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
                MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(top: 12.h),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        // Close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Icon(
                                  LineIcons.times,
                                  size: 20.sp,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
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
                            color: isDark
                                ? Colors.grey[400]
                                : const Color(0xFF64748B),
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
                            color:
                                isDark ? Colors.white : const Color(0xFF374151),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Phone input field
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF374151)
                                : const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: _errorMessage != null
                                  ? const Color(0xFFEF4444)
                                  : (isDark
                                      ? Colors.grey[600]!
                                      : const Color(0xFFD1D5DB)),
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
                                        color: isDark
                                            ? Colors.grey[600]!
                                            : const Color(0xFFD1D5DB),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '🇺🇸',
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        _phoneNumber,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF374151),
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        LineIcons.angleDown,
                                        size: 16.sp,
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
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
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF374151),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '1234567890',
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.grey[500]
                                          : Colors.grey[400],
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
                              disabledBackgroundColor:
                                  isDark ? Colors.grey[700] : Colors.grey[300],
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
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
                                color: isDark
                                    ? Colors.grey[600]
                                    : Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark
                                    ? Colors.grey[600]
                                    : Colors.grey[300],
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
                              color: isDark
                                  ? Colors.grey[400]
                                  : const Color(0xFF64748B),
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
    // Implement country picker logic
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: const Center(
          child: Text('Country Picker'),
        ),
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    // Implement social login logic
    debugPrint('Social login with $provider');
  }
}
