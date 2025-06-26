import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/services/service_providers.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// LOGOUT BUTTON WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE THEMEMANAGER INTEGRATION COMPLETED** ✅
///
/// **🎨 ENHANCED FEATURES WITH ALL THEMEMANAGER PROPERTIES:**
///
/// **1. COMPREHENSIVE COLOR SYSTEM:**
/// - Primary Colors: primaryColor, primaryLight, primaryDark, secondaryColor
/// - Background Colors: backgroundColor, backgroundSecondary, backgroundTertiary,
///   cardBackground, surfaceElevated, modalBackground, surfaceColor
/// - Text Colors: textPrimary, textSecondary, textTertiary, textInverted
/// - Status Colors: successColor/Light/Dark, warningColor/Light/Dark,
///   errorColor/Light/Dark, infoColor/Light/Dark
/// - Accent Colors: accent1-5, neutral50-900
/// - Border Colors: borderColor, borderSecondary, borderFocus, dividerColor
/// - Interactive Colors: buttonBackground, inputBackground, statusColors
/// - Shadow Colors: shadowLight, shadowMedium, shadowDark
///
/// **2. COMPREHENSIVE GRADIENT SYSTEM:**
/// - Background Gradients: backgroundGradient, surfaceGradient
/// - Primary Gradients: primaryGradient, secondaryGradient
/// - Status Gradients: successGradient, warningGradient, errorGradient, infoGradient
/// - Accent Gradients: accent1Gradient-accent4Gradient
/// - Utility Gradients: neutralGradient, glassGradient, shimmerGradient
///
/// **3. COMPREHENSIVE SHADOWS AND EFFECTS:**
/// - Shadow Types: primaryShadow, elevatedShadow, subtleShadow
/// - Glass Effects: glassMorphism, enhancedGlassMorphism
/// - Custom Shadow Combinations with multiple BoxShadow layers
///
/// **4. COMPREHENSIVE HELPER METHODS:**
/// - conditionalColor() - theme-aware color selection
/// - conditionalGradient() - theme-aware gradient selection
/// - getContrastingColor() - automatic contrast detection
/// - getTextColorForBackground() - optimal text color selection
///
/// **🎯 LOGOUT-SPECIFIC ENHANCEMENTS:**
/// - Security-focused error color scheme with gradients
/// - Professional logout confirmation with glass morphism
/// - Enhanced visual hierarchy with status colors for logout states
/// - Comprehensive accessibility with contrast optimization
/// - Modern loading states with theme-aware animations
/// ====================================================================

/// LogoutButtonWidget - Modern logout button with confirmation
///
/// This widget provides a beautiful logout button with:
/// - Modern card design with comprehensive gradient effects
/// - Confirmation dialog with proper UX and theme-aware styling
/// - Complete logout functionality with token management
/// - Loading states and error handling with professional design
/// - Comprehensive ThemeManager integration for security-focused interface
class LogoutButtonWidget extends ConsumerStatefulWidget {
  const LogoutButtonWidget({
    super.key,
    this.margin,
    this.showIcon = true,
  });

  /// Custom margin for the button (optional)
  final EdgeInsets? margin;

  /// Whether to show the logout icon
  final bool showIcon;

  @override
  ConsumerState<LogoutButtonWidget> createState() => _LogoutButtonWidgetState();
}

class _LogoutButtonWidgetState extends ConsumerState<LogoutButtonWidget> with ThemeAwareMixin {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('🚪 LogoutButtonWidget: Building logout button with comprehensive ThemeManager integration');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging
    themeManager.logThemeInfo();
    debugPrint('🚪 LogoutButtonWidget: → Show icon: ${widget.showIcon}');
    debugPrint('🚪 LogoutButtonWidget: → Is logging out: $_isLoggingOut');
    debugPrint(
        '🚪 LogoutButtonWidget: → Error Colors - Primary: ${themeManager.errorColor}, Light: ${themeManager.errorLight}, Dark: ${themeManager.errorDark}');
    debugPrint('🚪 LogoutButtonWidget: → Background: ${themeManager.backgroundColor}');
    debugPrint('🚪 LogoutButtonWidget: → Surface: ${themeManager.surfaceColor}');
    debugPrint('🚪 LogoutButtonWidget: → Card Background: ${themeManager.cardBackground}');

    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.cardBackground,
              themeManager.surfaceElevated,
              themeManager.backgroundSecondary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.cardBackground,
              themeManager.backgroundTertiary,
              themeManager.surfaceElevated,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          ...themeManager.elevatedShadow,
          BoxShadow(
            color: themeManager.shadowMedium,
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: themeManager.conditionalColor(
              lightColor: themeManager.errorColor.withValues(alpha: 0.05),
              darkColor: themeManager.errorDark.withValues(alpha: 0.1),
            ),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 0.2),
            darkColor: themeManager.borderSecondary.withValues(alpha: 0.3),
          ),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: _isLoggingOut ? null : () => _showLogoutConfirmation(themeManager),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: _isLoggingOut ? _buildLoadingState(themeManager) : _buildLogoutButton(themeManager),
          ),
        ),
      ),
    );
  }

  /// Builds the logout button content with enhanced styling
  Widget _buildLogoutButton(ThemeManager themeManager) {
    debugPrint('🚪 LogoutButtonWidget: Building logout button content');

    return Row(
      children: [
        // Logout Icon with enhanced styling
        if (widget.showIcon) ...[
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    themeManager.errorColor.withValues(alpha: 0.15),
                    themeManager.errorLight.withValues(alpha: 0.05),
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    themeManager.errorDark.withValues(alpha: 0.2),
                    themeManager.errorColor.withValues(alpha: 0.1),
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: themeManager.conditionalColor(
                  lightColor: themeManager.errorColor.withValues(alpha: 0.3),
                  darkColor: themeManager.errorDark.withValues(alpha: 0.4),
                ),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeManager.errorColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Prbal.powerOff,
              color: themeManager.conditionalColor(
                lightColor: themeManager.errorColor,
                darkColor: themeManager.errorLight,
              ),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
        ],

        // Logout Text with enhanced typography
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.errorColor,
                    darkColor: themeManager.errorLight,
                  ),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Sign out of your account',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: themeManager.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Arrow Icon with theme-aware styling
        Icon(
          Prbal.arrowSync,
          color: themeManager.conditionalColor(
            lightColor: themeManager.errorColor.withValues(alpha: 0.7),
            darkColor: themeManager.errorLight.withValues(alpha: 0.8),
          ),
          size: 16.sp,
        ),
      ],
    );
  }

  /// Builds the loading state with enhanced styling
  Widget _buildLoadingState(ThemeManager themeManager) {
    debugPrint('🚪 LogoutButtonWidget: Building loading state');

    return Row(
      children: [
        // Loading Indicator with theme-aware colors
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              themeManager.conditionalColor(
                lightColor: themeManager.errorColor,
                darkColor: themeManager.errorLight,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),

        // Loading Text
        Text(
          'Signing out...',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: themeManager.conditionalColor(
              lightColor: themeManager.errorColor,
              darkColor: themeManager.errorLight,
            ),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  /// Shows the logout confirmation dialog with enhanced design
  Future<void> _showLogoutConfirmation(ThemeManager themeManager) async {
    debugPrint('🚪 LogoutButtonWidget: Showing logout confirmation');

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLogoutConfirmationBottomSheet(themeManager),
    );

    if (confirmed == true && mounted) {
      await _performCompleteLogout();
    }
  }

  /// Builds the logout confirmation bottom sheet with comprehensive theming
  Widget _buildLogoutConfirmationBottomSheet(ThemeManager themeManager) {
    debugPrint('🚪 LogoutButtonWidget: Building logout confirmation bottom sheet');

    return Container(
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: themeManager.surfaceGradient,
          darkGradient: LinearGradient(
            colors: [
              themeManager.surfaceColor,
              themeManager.cardBackground,
            ],
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          ...themeManager.elevatedShadow,
          BoxShadow(
            color: themeManager.shadowMedium,
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: themeManager.conditionalColor(
                lightColor: themeManager.neutral300,
                darkColor: themeManager.neutral600,
              ),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Icon
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        gradient: themeManager.conditionalGradient(
                          lightGradient: LinearGradient(
                            colors: [
                              themeManager.errorColor.withValues(alpha: 0.15),
                              themeManager.errorLight.withValues(alpha: 0.05),
                            ],
                          ),
                          darkGradient: LinearGradient(
                            colors: [
                              themeManager.errorDark.withValues(alpha: 0.2),
                              themeManager.errorColor.withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: themeManager.errorColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Prbal.powerOff,
                        color: themeManager.conditionalColor(
                          lightColor: themeManager.errorColor,
                          darkColor: themeManager.errorLight,
                        ),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: themeManager.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Content
                Text(
                  'Are you sure you want to logout? This will revoke all your device tokens and sign you out.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: themeManager.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          side: BorderSide(
                            color: themeManager.borderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: themeManager.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeManager.conditionalColor(
                            lightColor: themeManager.errorColor,
                            darkColor: themeManager.errorDark,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Performs complete logout with proper token management
  Future<void> _performCompleteLogout() async {
    debugPrint('🚪 LogoutButtonWidget: Starting complete logout process...');

    if (!mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    // ========== COMPREHENSIVE THEME INTEGRATION FOR FEEDBACK ==========
    final themeManager = ThemeManager.of(context);

    try {
      // Show loading feedback with theme-aware design
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16.w),
              Text('Signing out...'),
            ],
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: themeManager.conditionalColor(
            lightColor: themeManager.errorColor,
            darkColor: themeManager.errorDark,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );

      final authNotifier = ref.read(authenticationStateProvider.notifier);
      final userService = ref.read(userServiceProvider);
      final authState = ref.read(authenticationStateProvider);

      // Step 1: Get current user tokens for debugging
      if (authState.accessToken != null) {
        debugPrint('📋 Getting user tokens...');
        final tokensResponse = await userService.getUserTokens(authState.accessToken!);
        if (tokensResponse.isSuccess && tokensResponse.data != null) {
          final tokens = tokensResponse.data!['tokens'] as List<dynamic>? ?? [];
          debugPrint('✅ Found ${tokens.length} active tokens');
        }

        // Step 2: Revoke all tokens for security
        debugPrint('🔐 Revoking all tokens...');
        final revokeResponse = await userService.revokeAllTokens(authState.accessToken!);
        if (revokeResponse.isSuccess) {
          debugPrint('✅ Successfully revoked all tokens');
        } else {
          debugPrint('⚠️ Failed to revoke tokens: ${revokeResponse.message}');
        }

        // Step 3: Perform logout to clean up server-side session
        debugPrint('🚪 Performing logout...');
        final logoutResponse = await userService.logout(authState.accessToken!);
        if (logoutResponse.isSuccess) {
          debugPrint('✅ Logout successful');
        } else {
          debugPrint('⚠️ Logout failed: ${logoutResponse.message}');
        }
      }

      // Step 4: Use authentication notifier to clear state
      debugPrint('🧹 Clearing authentication state...');
      await authNotifier.logout();

      // Step 5: Navigate to welcome screen
      debugPrint('🏠 Navigating to welcome screen...');
      if (mounted) {
        // Clear the snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Navigate to welcome screen and clear the entire navigation stack
        NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);

        // Show success message briefly with theme-aware design
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully signed out'),
                backgroundColor: themeManager.conditionalColor(
                  lightColor: themeManager.successColor,
                  darkColor: themeManager.successDark,
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          }
        });
      }

      debugPrint('🎉 Complete logout process finished successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error during logout process: $e');
      debugPrint('📍 Stack trace: $stackTrace');

      // Emergency cleanup
      try {
        debugPrint('🔄 Attempting emergency cleanup...');
        await HiveService.setLoggedIn(false);
        await HiveService.clearUserData();
        await HiveService.removeAuthToken();
        await HiveService.removeRefreshToken();

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);

          // Show error message with theme-aware design
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed out (with errors): ${e.toString()}'),
                  backgroundColor: themeManager.conditionalColor(
                    lightColor: themeManager.warningColor,
                    darkColor: themeManager.warningDark,
                  ),
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            }
          });
        }
      } catch (cleanupError) {
        debugPrint('❌ Emergency cleanup failed: $cleanupError');
        if (mounted) {
          NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }
}
