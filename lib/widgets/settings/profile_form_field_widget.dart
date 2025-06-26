import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
import 'package:prbal/services/service_providers.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// **THEMEMANAGER INTEGRATED** ProfileFormFieldWidget - Reusable form field for profile editing
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (surface, input, user type gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and form field state monitoring
/// - ✨ Enhanced visual feedback with user type theming
/// - 👤 Profile-focused design with user type color integration
///
/// This widget provides a consistent form field design for profile forms with:
/// - Enhanced required field indicator with gradient styling
/// - Comprehensive theme-aware styling with automatic adaptation
/// - User type-aware focus colors and validation
/// - Enhanced multi-line support with proper theming
/// - Professional focus states and error handling
class ProfileFormFieldWidget extends ConsumerWidget with ThemeAwareMixin {
  const ProfileFormFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.required = true,
    this.validator,
    this.isEnabled = true,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final bool required;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeManager = ThemeManager.of(context);
    final authState = ref.read(authenticationStateProvider);
    final userType = authState.userData?['user_type'] ?? 'customer';
    final userTypeColor = themeManager.getUserTypeColor(userType);

    // 📊 Debug logging
    debugPrint('👤 [ProfileFormField] Building profile field: $label');
    debugPrint('🎯 [ProfileFormField] User type: $userType, Required: $required, Enabled: $isEnabled');
    debugPrint('🎨 [ProfileFormField] User type color: $userTypeColor');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced label with user type theming
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.conditionalColor(
                  lightColor: themeManager.textPrimary,
                  darkColor: themeManager.textPrimary,
                ),
                letterSpacing: 0.2,
              ),
            ),
            if (required) ...[
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  gradient: themeManager.conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        themeManager.errorColor.withValues(alpha: 26),
                        themeManager.errorColor.withValues(alpha: 13),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        themeManager.errorColor.withValues(alpha: 51),
                        themeManager.errorColor.withValues(alpha: 26),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: themeManager.errorColor.withValues(alpha: 77),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '*',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.errorColor,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),

        // Enhanced form field with comprehensive theme integration
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: themeManager.conditionalColor(
                  lightColor: themeManager.neutral200.withValues(alpha: 128),
                  darkColor: themeManager.neutral800.withValues(alpha: 77),
                ),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            enabled: isEnabled,
            style: TextStyle(
              fontSize: 16.sp,
              color: themeManager.conditionalColor(
                lightColor: themeManager.textPrimary,
                darkColor: themeManager.textPrimary,
              ),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: themeManager.conditionalColor(
                  lightColor: themeManager.textTertiary,
                  darkColor: themeManager.textTertiary,
                ),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: prefixIcon != null
                  ? Container(
                      margin: EdgeInsets.all(12.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: themeManager.conditionalGradient(
                          lightGradient: LinearGradient(
                            colors: [
                              userTypeColor.withValues(alpha: 26),
                              userTypeColor.withValues(alpha: 13),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          darkGradient: LinearGradient(
                            colors: [
                              userTypeColor.withValues(alpha: 51),
                              userTypeColor.withValues(alpha: 26),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: prefixIcon,
                    )
                  : null,
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: themeManager.conditionalColor(
                lightColor: themeManager.inputBackground,
                darkColor: themeManager.inputBackground,
              ),

              // Default border
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.borderColor,
                    darkColor: themeManager.borderColor,
                  ),
                  width: 1,
                ),
              ),

              // Enabled border
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.borderColor,
                    darkColor: themeManager.borderColor,
                  ),
                  width: 1,
                ),
              ),

              // Disabled border
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.neutral300,
                    darkColor: themeManager.neutral600,
                  ),
                  width: 1,
                ),
              ),

              // Focused border with user type color
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: userTypeColor,
                  width: 2,
                ),
              ),

              // Error border
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: themeManager.errorColor,
                  width: 1,
                ),
              ),

              // Focused error border
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: themeManager.errorColor,
                  width: 2,
                ),
              ),

              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: maxLines > 1 ? 16.h : 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
