import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/models/auth/user_type.dart';

import 'package:prbal/services/api_service.dart';

// Services

import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/user_service.dart';

// Navigation
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// UserTypeChangeHandler - Comprehensive user type change management
///
/// This class handles all aspects of user type changes including:
/// - Fetching available user type options from API
/// - Displaying user type selection dialogs
/// - Confirmation dialogs with reason input
/// - API calls to change user type
/// - State updates and navigation
/// - Error handling and user feedback
class UserTypeChangeHandler {
  static Future<void> showUserTypeChangeDialog({
    required BuildContext context,
    required WidgetRef ref,
    required UserType currentUserType,
  }) async {
    debugPrint('🔄 UserTypeChangeHandler: Showing user type change dialog');
    debugPrint('🔄 Current user type: $currentUserType');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    try {
      // First, get user type change info from API
      final authToken = HiveService.getAuthToken();

      // Show loading while fetching user type change info
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF667EEA),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Loading account options...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Get user service and fetch change info
      final userService = UserService(ApiService());
      final changeInfoResponse =
          await userService.getUserTypeChangeInfo(authToken);

      // Close loading dialog
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (changeInfoResponse.isSuccess && changeInfoResponse.data != null) {
        final changeInfo = changeInfoResponse.data!;
        debugPrint('🔄 Full response data: $changeInfo');

        // Parse available changes from API response
        List<dynamic> availableChanges = [];

        // Try multiple paths to find available changes
        if (changeInfo['data']?['change_info']?['available_changes'] != null) {
          availableChanges = changeInfo['data']['change_info']
              ['available_changes'] as List<dynamic>;
        } else if (changeInfo['data']?['available_changes'] != null) {
          availableChanges =
              changeInfo['data']['available_changes'] as List<dynamic>;
        } else if (changeInfo['available_changes'] != null) {
          availableChanges = changeInfo['available_changes'] as List<dynamic>;
        } else {
          availableChanges = _generateFallbackUserTypeChanges(currentUserType);
        }

        debugPrint('🔄 Available changes: ${availableChanges.length}');

        if (availableChanges.isEmpty) {
          _showInfoDialog(
            context,
            'Account Type Change Unavailable',
            'Your account type cannot be changed at this time.',
            isDark,
          );
          return;
        }

        // Show user type selection dialog
        await _showUserTypeSelectionDialog(
          context: context,
          ref: ref,
          availableChanges: availableChanges,
          currentUserType: currentUserType,
          isDark: isDark,
        );
      } else {
        debugPrint(
            '❌ Failed to get user type change info: ${changeInfoResponse.message}');
        _showErrorSnackBar(context,
            'Failed to load account type options: ${changeInfoResponse.message}');
      }
    } catch (e) {
      debugPrint('❌ Error in user type change dialog: $e');

      // Close loading dialog if still open
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      _showErrorSnackBar(context, 'Error loading account type options: $e');
    }
  }

  static Future<void> _showUserTypeSelectionDialog({
    required BuildContext context,
    required WidgetRef ref,
    required List<dynamic> availableChanges,
    required UserType currentUserType,
    required bool isDark,
  }) async {
    debugPrint('🔄 UserTypeChangeHandler: Showing user type selection dialog');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.swap_horiz,
                      color: const Color(0xFF667EEA),
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      'Change Account Type',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Current type info
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: ThemeManager.of(context)
                    .getUserTypeColor(currentUserType)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ThemeManager.of(context)
                      .getUserTypeColor(currentUserType)
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    getUserTypeIcon(currentUserType),
                    color: ThemeManager.of(context)
                        .getUserTypeColor(currentUserType),
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Current: ${getUserTypeDisplayName(currentUserType)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Available changes
            ...availableChanges.map((change) {
              final targetType = change['type'] as UserType;
              final displayName = change['display'] as String;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showConfirmationDialog(
                      context: context,
                      ref: ref,
                      targetType: targetType,
                      displayName: displayName,
                      isDark: isDark,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: ThemeManager.of(context)
                                  .getUserTypeColor(targetType)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              getUserTypeIcon(targetType),
                              color: ThemeManager.of(context)
                                  .getUserTypeColor(targetType),
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              displayName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: ThemeManager.of(context)
                                .getUserTypeColor(targetType),
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  static Future<void> _showConfirmationDialog({
    required BuildContext context,
    required WidgetRef ref,
    required UserType targetType,
    required String displayName,
    required bool isDark,
  }) async {
    debugPrint(
        '🔄 UserTypeChangeHandler: Showing confirmation dialog for $targetType');

    // Close current bottom sheet
    Navigator.of(context).pop();

    final reasonController = TextEditingController();

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: ThemeManager.of(context)
                            .getUserTypeColor(targetType)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        getUserTypeIcon(targetType),
                        color: ThemeManager.of(context)
                            .getUserTypeColor(targetType),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        'Change to $displayName',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reason input
                      Text(
                        'Reason for change (optional):',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Tell us why you want to change your account type...',
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final reason = reasonController.text.trim();
                          Navigator.of(context).pop();
                          await _executeUserTypeChange(
                            context: context,
                            ref: ref,
                            targetType: targetType,
                            reason: reason,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeManager.of(context)
                              .getUserTypeColor(targetType),
                        ),
                        child: Text('Change Type'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).whenComplete(() {
        reasonController.dispose();
      });
    } catch (e) {
      reasonController.dispose();
      _showErrorSnackBar(context, 'Error showing confirmation dialog: $e');
    }
  }

  static Future<void> _executeUserTypeChange({
    required BuildContext context,
    required WidgetRef ref,
    required UserType targetType,
    required String reason,
  }) async {
    debugPrint(
        '🔄 UserTypeChangeHandler: Executing user type change to $targetType');

    try {
      final authToken = HiveService.getAuthToken();

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Prepare request
      final request = <String, dynamic>{
        'to': targetType,
        if (reason.isNotEmpty) 'reason': reason,
      };

      // Call API
      final userService = UserService(ApiService());
      final response = await userService.changeUserType(request, authToken);

      // Close loading dialog
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (response.isSuccess) {
        debugPrint('✅ User type changed successfully');

        // Update authentication state
        await _refreshUserTypeState(ref);

        if (context.mounted) {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account type changed successfully!'),
              backgroundColor: const Color(0xFF48BB78),
            ),
          );

          // Navigate to splash screen
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              context.go(RouteEnum.splash.rawValue);
            }
          });
        }
      } else {
        _showErrorSnackBar(
            context, 'Failed to change account type: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ Error executing user type change: $e');
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorSnackBar(context, 'Error changing account type: $e');
    }
  }

  // Helper methods
  static List<dynamic> _generateFallbackUserTypeChanges(
      UserType currentUserType) {
    final allUserTypes = [
      {'type': 'customer', 'display': 'Customer'},
      {'type': 'provider', 'display': 'Service Provider'},
      {'type': 'admin', 'display': 'Administrator'},
    ];

    return allUserTypes
        .where((type) => type['type'] != currentUserType.name)
        .toList();
  }

  static Future<void> _refreshUserTypeState(WidgetRef ref) async {
    // Implementation for refreshing user type state
    // This would update the authentication state and local storage
  }

  static void _showInfoDialog(
      BuildContext context, String title, String message, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE53E3E),
      ),
    );
  }
}
