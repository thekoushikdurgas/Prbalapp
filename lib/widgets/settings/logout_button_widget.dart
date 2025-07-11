import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:prbal/services/api_service.dart';
//
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';

/// LogoutButtonWidget - Modern logout button with confirmation
///
/// This widget provides a beautiful logout button with:
/// - Modern card design with gradient effects
/// - Confirmation dialog with proper UX
/// - Complete logout functionality with token management
/// - Loading states and error handling
/// - Theme-aware styling for light and dark modes
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

class _LogoutButtonWidgetState extends ConsumerState<LogoutButtonWidget> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('🚪 LogoutButtonWidget: Building logout button');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    debugPrint('🚪 LogoutButtonWidget: Theme is dark: $isDark');
    debugPrint('🚪 LogoutButtonWidget: Show icon: ${widget.showIcon}');
    debugPrint('🚪 LogoutButtonWidget: Is logging out: $_isLoggingOut');

    return Container(
      margin: widget.margin ??
          EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF2D2D2D).withValues(alpha: 0.9),
                  const Color(0xFF1E1E1E).withValues(alpha: 0.95),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF8F9FA).withValues(alpha: 0.9),
                ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.9),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: _isLoggingOut ? null : () => _showLogoutConfirmation(isDark),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: _isLoggingOut
                ? _buildLoadingState(isDark)
                : _buildLogoutButton(isDark),
          ),
        ),
      ),
    );
  }

  /// Builds the logout button content
  Widget _buildLogoutButton(bool isDark) {
    debugPrint('🚪 LogoutButtonWidget: Building logout button content');

    return Row(
      children: [
        // Logout Icon
        if (widget.showIcon) ...[
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE53E3E).withValues(alpha: 0.15),
                  const Color(0xFFE53E3E).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFFE53E3E).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Prbal.signOut,
              color: const Color(0xFFE53E3E),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
        ],

        // Logout Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE53E3E),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Sign out of your account',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Arrow Icon
        Icon(
          Icons.arrow_forward_ios,
          color: const Color(0xFFE53E3E).withValues(alpha: 0.7),
          size: 16.sp,
        ),
      ],
    );
  }

  /// Builds the loading state
  Widget _buildLoadingState(bool isDark) {
    debugPrint('🚪 LogoutButtonWidget: Building loading state');

    return Row(
      children: [
        // Loading Indicator
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFFE53E3E),
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
            color: const Color(0xFFE53E3E),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  /// Shows the logout confirmation dialog
  Future<void> _showLogoutConfirmation(bool isDark) async {
    debugPrint('🚪 LogoutButtonWidget: Showing logout confirmation');

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLogoutConfirmationBottomSheet(isDark),
    );

    if (confirmed == true && mounted) {
      await _performCompleteLogout();
    }
  }

  /// Builds the logout confirmation bottom sheet
  Widget _buildLogoutConfirmationBottomSheet(bool isDark) {
    debugPrint(
        '🚪 LogoutButtonWidget: Building logout confirmation bottom sheet');

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
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
              color: isDark ? Colors.grey[600] : Colors.grey[300],
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
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFE53E3E).withValues(alpha: 0.15),
                            const Color(0xFFE53E3E).withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Prbal.signOut,
                        color: const Color(0xFFE53E3E),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
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
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
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
                            color:
                                isDark ? Colors.grey[600]! : Colors.grey[300]!,
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
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53E3E),
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

    try {
      // Show loading feedback
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
          backgroundColor: const Color(0xFFE53E3E),
        ),
      );

      final userService = UserService(ApiService());
      final accessToken = HiveService.getAuthToken();

      // Step 1: Get current user tokens for debugging
      if (accessToken.isNotEmpty) {
        debugPrint('📋 Getting user tokens...');
        final tokensResponse = await userService.getUserTokens(accessToken);
        if (tokensResponse.isSuccess && tokensResponse.data != null) {
          final tokens = tokensResponse.data!['tokens'] as List<dynamic>? ?? [];
          debugPrint('✅ Found ${tokens.length} active tokens');
        }

        // Step 2: Revoke all tokens for security
        debugPrint('🔐 Revoking all tokens...');
        final revokeResponse = await userService.revokeAllTokens(accessToken);
        if (revokeResponse.isSuccess) {
          debugPrint('✅ Successfully revoked all tokens');
        } else {
          debugPrint('⚠️ Failed to revoke tokens: ${revokeResponse.message}');
        }

        // Step 3: Perform logout to clean up server-side session
        debugPrint('🚪 Performing logout...');
        final logoutResponse = await userService.logout(accessToken);
        if (logoutResponse.isSuccess) {
          debugPrint('✅ Logout successful');
        } else {
          debugPrint('⚠️ Logout failed: ${logoutResponse.message}');
        }
      }

      // Step 4: Use authentication notifier to clear state
      debugPrint('🧹 Clearing authentication state...');
      await HiveService.setLoggedIn(false);
      await HiveService.clearUserData();
      await HiveService.removeAuthToken();
      await HiveService.removeRefreshToken();

      // Step 5: Navigate to welcome screen
      debugPrint('🏠 Navigating to welcome screen...');
      if (mounted) {
        // Clear the snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Navigate to welcome screen and clear the entire navigation stack
        NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);

        // Show success message briefly
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully signed out'),
                backgroundColor: Color(0xFF48BB78),
                duration: Duration(seconds: 2),
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

          // Show error message
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed out (with errors): ${e.toString()}'),
                  backgroundColor: const Color(0xFFED8936),
                  duration: const Duration(seconds: 3),
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
