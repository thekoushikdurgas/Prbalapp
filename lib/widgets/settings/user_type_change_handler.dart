import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

// Services
import 'package:prbal/services/service_providers.dart';
import 'package:prbal/services/hive_service.dart';

// Navigation
import 'package:prbal/utils/navigation/routes/route_enum.dart';

/// **THEMEMANAGER INTEGRATED** UserTypeChangeHandler - Comprehensive user type change management
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, primary, secondary, status gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and user type change monitoring
/// - ✨ Enhanced visual feedback with animated loading indicators
/// - 👥 User type-focused design with status color integration
/// - 🛡️ Security-aware user type change flow with proper theming
///
/// This class handles all aspects of user type changes including:
/// - Enhanced fetching available user type options from API with proper theming
/// - Professional user type selection dialogs with gradient backgrounds
/// - Confirmation dialogs with reason input and enhanced styling
/// - Theme-aware API calls to change user type with loading states
/// - State updates and navigation with proper visual feedback
/// - Enhanced error handling and user feedback with status colors
class UserTypeChangeHandler {
  static Future<void> showUserTypeChangeDialog({
    required BuildContext context,
    required WidgetRef ref,
    required UserType currentUserType,
  }) async {
    debugPrint('🔄 [UserTypeChange] Showing enhanced user type change dialog');
    debugPrint('👤 [UserTypeChange] Current user type: $currentUserType');

    final themeManager = ThemeManager.of(context);

    try {
      // First, get user type change info from API
      final authToken = HiveService.getAuthToken();

      // Show enhanced loading while fetching user type change info
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              // Enhanced gradient background
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.surfaceColor.withValues(alpha: 242),
                    themeManager.backgroundColor.withValues(alpha: 230),
                    themeManager.infoColor.withValues(alpha: 13),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.surfaceColor.withValues(alpha: 230),
                    themeManager.backgroundColor.withValues(alpha: 242),
                    themeManager.infoColor.withValues(alpha: 26),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: themeManager.conditionalColor(
                  lightColor: themeManager.borderColor.withValues(alpha: 128),
                  darkColor: themeManager.borderColor.withValues(alpha: 77),
                ),
                width: 1,
              ),
              boxShadow: themeManager.elevatedShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Enhanced loading indicator
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          themeManager.infoColor.withValues(alpha: 26),
                          themeManager.infoColor.withValues(alpha: 13),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          themeManager.infoColor.withValues(alpha: 51),
                          themeManager.infoColor.withValues(alpha: 26),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: themeManager.infoColor.withValues(alpha: 77),
                      width: 1,
                    ),
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeManager.infoColor),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Loading account options...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          themeManager.infoColor.withValues(alpha: 13),
                          themeManager.infoColor.withValues(alpha: 8),
                        ],
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          themeManager.infoColor.withValues(alpha: 26),
                          themeManager.infoColor.withValues(alpha: 13),
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Please wait while we fetch options...',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: themeManager.textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Get user service and fetch change info
      final userService = ref.read(userServiceProvider);
      final changeInfoResponse = await userService.getUserTypeChangeInfo(authToken);

      // Close loading dialog
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (changeInfoResponse.isSuccess && changeInfoResponse.data != null) {
        final changeInfo = changeInfoResponse.data!;
        debugPrint('📊 [UserTypeChange] Full response data: $changeInfo');

        // Parse available changes from API response
        List<dynamic> availableChanges = [];

        // Try multiple paths to find available changes
        if (changeInfo['data']?['change_info']?['available_changes'] != null) {
          availableChanges = changeInfo['data']['change_info']['available_changes'] as List<dynamic>;
        } else if (changeInfo['data']?['available_changes'] != null) {
          availableChanges = changeInfo['data']['available_changes'] as List<dynamic>;
        } else if (changeInfo['available_changes'] != null) {
          availableChanges = changeInfo['available_changes'] as List<dynamic>;
        } else {
          availableChanges = _generateFallbackUserTypeChanges(currentUserType);
        }

        debugPrint('📋 [UserTypeChange] Available changes: ${availableChanges.length}');

        if (availableChanges.isEmpty) {
          _showInfoDialog(
            context,
            'Account Type Change Unavailable',
            'Your account type cannot be changed at this time.',
            themeManager,
          );
          return;
        }

        // Show user type selection dialog
        await _showUserTypeSelectionDialog(
          context: context,
          ref: ref,
          availableChanges: availableChanges,
          currentUserType: currentUserType,
          themeManager: themeManager,
        );
      } else {
        debugPrint('❌ [UserTypeChange] Failed to get user type change info: ${changeInfoResponse.message}');
        _showErrorSnackBar(context, 'Failed to load account type options: ${changeInfoResponse.message}', themeManager);
      }
    } catch (e) {
      debugPrint('❌ [UserTypeChange] Error in user type change dialog: $e');

      // Close loading dialog if still open
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      _showErrorSnackBar(context, 'Error loading account type options: $e', themeManager);
    }
  }

  static Future<void> _showUserTypeSelectionDialog({
    required BuildContext context,
    required WidgetRef ref,
    required List<dynamic> availableChanges,
    required UserType currentUserType,
    required ThemeManager themeManager,
  }) async {
    debugPrint('🎯 [UserTypeChange] Showing enhanced user type selection dialog');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          // Enhanced gradient background
          gradient: themeManager.conditionalGradient(
            lightGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeManager.surfaceColor.withValues(alpha: 248),
                themeManager.backgroundColor.withValues(alpha: 242),
                themeManager.primaryColor.withValues(alpha: 8),
              ],
              stops: const [0.0, 0.85, 1.0],
            ),
            darkGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeManager.surfaceColor.withValues(alpha: 235),
                themeManager.backgroundColor.withValues(alpha: 248),
                themeManager.primaryColor.withValues(alpha: 13),
              ],
              stops: const [0.0, 0.85, 1.0],
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
          border: Border(
            top: BorderSide(
              color: themeManager.conditionalColor(
                lightColor: themeManager.borderColor.withValues(alpha: 128),
                darkColor: themeManager.borderColor.withValues(alpha: 77),
              ),
              width: 1,
            ),
            left: BorderSide(
              color: themeManager.conditionalColor(
                lightColor: themeManager.borderColor.withValues(alpha: 77),
                darkColor: themeManager.borderColor.withValues(alpha: 51),
              ),
              width: 1,
            ),
            right: BorderSide(
              color: themeManager.conditionalColor(
                lightColor: themeManager.borderColor.withValues(alpha: 77),
                darkColor: themeManager.borderColor.withValues(alpha: 51),
              ),
              width: 1,
            ),
          ),
          boxShadow: themeManager.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced drag handle
            Container(
              margin: EdgeInsets.only(top: 16.h, bottom: 12.h),
              width: 48.w,
              height: 5.h,
              decoration: BoxDecoration(
                gradient: themeManager.conditionalGradient(
                  lightGradient: LinearGradient(
                    colors: [
                      themeManager.borderColor.withValues(alpha: 153),
                      themeManager.borderColor.withValues(alpha: 102),
                    ],
                  ),
                  darkGradient: LinearGradient(
                    colors: [
                      themeManager.borderColor.withValues(alpha: 179),
                      themeManager.borderColor.withValues(alpha: 128),
                    ],
                  ),
                ),
                borderRadius: BorderRadius.circular(3.r),
                boxShadow: themeManager.subtleShadow,
              ),
            ),

            // Enhanced header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: themeManager.conditionalGradient(
                        lightGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            themeManager.primaryColor.withValues(alpha: 26),
                            themeManager.primaryColor.withValues(alpha: 13),
                          ],
                        ),
                        darkGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            themeManager.primaryColor.withValues(alpha: 51),
                            themeManager.primaryColor.withValues(alpha: 26),
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: themeManager.primaryColor.withValues(alpha: 77),
                        width: 1,
                      ),
                      boxShadow: themeManager.subtleShadow,
                    ),
                    child: Icon(
                      Prbal.arrowSync,
                      color: themeManager.primaryColor,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Account Type',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: themeManager.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            gradient: themeManager.conditionalGradient(
                              lightGradient: LinearGradient(
                                colors: [
                                  themeManager.primaryColor.withValues(alpha: 13),
                                  themeManager.primaryColor.withValues(alpha: 8),
                                ],
                              ),
                              darkGradient: LinearGradient(
                                colors: [
                                  themeManager.primaryColor.withValues(alpha: 26),
                                  themeManager.primaryColor.withValues(alpha: 13),
                                ],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Select new account type',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: themeManager.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced current type info
            Container(
              margin: EdgeInsets.symmetric(horizontal: 28.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: themeManager.conditionalGradient(
                  lightGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      themeManager.getUserTypeColor(currentUserType).withValues(alpha: 26),
                      themeManager.getUserTypeColor(currentUserType).withValues(alpha: 13),
                      themeManager.getUserTypeColor(currentUserType).withValues(alpha: 8),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                  darkGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      themeManager.getUserTypeColor(currentUserType).withValues(alpha: 51),
                      themeManager.getUserTypeColor(currentUserType).withValues(alpha: 26),
                      themeManager.getUserTypeColor(currentUserType).withValues(alpha: 13),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: themeManager.getUserTypeColor(currentUserType).withValues(alpha: 102),
                  width: 1.5,
                ),
                boxShadow: themeManager.subtleShadow,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: themeManager.conditionalGradient(
                        lightGradient: LinearGradient(
                          colors: [
                            themeManager.getUserTypeColor(currentUserType).withValues(alpha: 51),
                            themeManager.getUserTypeColor(currentUserType).withValues(alpha: 26),
                          ],
                        ),
                        darkGradient: LinearGradient(
                          colors: [
                            themeManager.getUserTypeColor(currentUserType).withValues(alpha: 77),
                            themeManager.getUserTypeColor(currentUserType).withValues(alpha: 51),
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: themeManager.getUserTypeColor(currentUserType).withValues(alpha: 128),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      getUserTypeIcon(currentUserType),
                      color: themeManager.getUserTypeColor(currentUserType),
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Account',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: themeManager.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          getUserTypeDisplayName(currentUserType),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeManager.textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Enhanced available changes
            ...availableChanges.map((change) {
              final UserType targetType = change['type'];
              final displayName = change['display'] as String;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 8.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showConfirmationDialog(
                      context: context,
                      ref: ref,
                      targetType: targetType,
                      displayName: displayName,
                      themeManager: themeManager,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    splashColor: themeManager.getUserTypeColor(targetType).withValues(alpha: 26),
                    highlightColor: themeManager.getUserTypeColor(targetType).withValues(alpha: 13),
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: themeManager.conditionalGradient(
                          lightGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              themeManager.surfaceColor.withValues(alpha: 242),
                              themeManager.backgroundColor.withValues(alpha: 235),
                              themeManager.getUserTypeColor(targetType).withValues(alpha: 8),
                            ],
                            stops: const [0.0, 0.7, 1.0],
                          ),
                          darkGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              themeManager.surfaceColor.withValues(alpha: 230),
                              themeManager.backgroundColor.withValues(alpha: 242),
                              themeManager.getUserTypeColor(targetType).withValues(alpha: 13),
                            ],
                            stops: const [0.0, 0.7, 1.0],
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: themeManager.conditionalColor(
                            lightColor: themeManager.borderColor.withValues(alpha: 102),
                            darkColor: themeManager.borderColor.withValues(alpha: 77),
                          ),
                          width: 1,
                        ),
                        boxShadow: themeManager.subtleShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              gradient: themeManager.conditionalGradient(
                                lightGradient: LinearGradient(
                                  colors: [
                                    themeManager.getUserTypeColor(targetType).withValues(alpha: 26),
                                    themeManager.getUserTypeColor(targetType).withValues(alpha: 13),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                darkGradient: LinearGradient(
                                  colors: [
                                    themeManager.getUserTypeColor(targetType).withValues(alpha: 51),
                                    themeManager.getUserTypeColor(targetType).withValues(alpha: 26),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: themeManager.getUserTypeColor(targetType).withValues(alpha: 77),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              getUserTypeIcon(targetType),
                              color: themeManager.getUserTypeColor(targetType),
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: themeManager.textPrimary,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    gradient: themeManager.conditionalGradient(
                                      lightGradient: LinearGradient(
                                        colors: [
                                          themeManager.getUserTypeColor(targetType).withValues(alpha: 13),
                                          themeManager.getUserTypeColor(targetType).withValues(alpha: 8),
                                        ],
                                      ),
                                      darkGradient: LinearGradient(
                                        colors: [
                                          themeManager.getUserTypeColor(targetType).withValues(alpha: 26),
                                          themeManager.getUserTypeColor(targetType).withValues(alpha: 13),
                                        ],
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'Tap to select',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: themeManager.textSecondary,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              gradient: themeManager.conditionalGradient(
                                lightGradient: LinearGradient(
                                  colors: [
                                    themeManager.getUserTypeColor(targetType).withValues(alpha: 26),
                                    themeManager.getUserTypeColor(targetType).withValues(alpha: 13),
                                  ],
                                ),
                                darkGradient: LinearGradient(
                                  colors: [
                                    themeManager.getUserTypeColor(targetType).withValues(alpha: 51),
                                    themeManager.getUserTypeColor(targetType).withValues(alpha: 26),
                                  ],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Prbal.arrowSync,
                              color: themeManager.getUserTypeColor(targetType),
                              size: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            SizedBox(height: 40.h),
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
    required ThemeManager themeManager,
  }) async {
    debugPrint('🔄 UserTypeChangeHandler: Showing confirmation dialog for $targetType');

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
            color: themeManager.surfaceColor,
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
                        color: themeManager.getUserTypeColor(targetType).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        getUserTypeIcon(targetType),
                        color: themeManager.getUserTypeColor(targetType),
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
                          color: themeManager.textPrimary,
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
                          color: themeManager.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Tell us why you want to change your account type...',
                          filled: true,
                          fillColor: themeManager.backgroundColor,
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
                          backgroundColor: themeManager.getUserTypeColor(targetType),
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
      _showErrorSnackBar(context, 'Error showing confirmation dialog: $e', themeManager);
    }
  }

  static Future<void> _executeUserTypeChange({
    required BuildContext context,
    required WidgetRef ref,
    required UserType targetType,
    required String reason,
  }) async {
    debugPrint('🔄 UserTypeChangeHandler: Executing user type change to $targetType');

    final themeManager = ThemeManager.of(context);

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
      final userService = ref.read(userServiceProvider);
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
              content: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        gradient: themeManager.conditionalGradient(
                          lightGradient: LinearGradient(
                            colors: [
                              themeManager.successColor.withValues(alpha: 51),
                              themeManager.successColor.withValues(alpha: 26),
                            ],
                          ),
                          darkGradient: LinearGradient(
                            colors: [
                              themeManager.successColor.withValues(alpha: 77),
                              themeManager.successColor.withValues(alpha: 51),
                            ],
                          ),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Prbal.check,
                        color: themeManager.getContrastingColor(themeManager.successColor),
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Account type changed successfully!',
                        style: TextStyle(
                          color: themeManager.getContrastingColor(themeManager.successColor),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: themeManager.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              margin: EdgeInsets.all(16.w),
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
        _showErrorSnackBar(context, 'Failed to change account type: ${response.message}', themeManager);
      }
    } catch (e) {
      debugPrint('❌ Error executing user type change: $e');
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorSnackBar(context, 'Error changing account type: $e', themeManager);
    }
  }

  // Helper methods
  static List<dynamic> _generateFallbackUserTypeChanges(UserType currentUserType) {
    final allUserTypes = [
      {'type': UserType.customer, 'display': 'Customer'},
      {'type': UserType.provider, 'display': 'Service Provider'},
      {'type': UserType.admin, 'display': 'Administrator'},
    ];

    return allUserTypes.where((type) => type['type'] != currentUserType).toList();
  }

  static Future<void> _refreshUserTypeState(WidgetRef ref) async {
    // Implementation for refreshing user type state
    // This would update the authentication state and local storage
  }

  static void _showInfoDialog(BuildContext context, String title, String message, ThemeManager themeManager) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: themeManager.borderColor.withValues(alpha: 128),
            width: 1,
          ),
        ),
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  themeManager.infoColor.withValues(alpha: 13),
                  themeManager.infoColor.withValues(alpha: 8),
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  themeManager.infoColor.withValues(alpha: 26),
                  themeManager.infoColor.withValues(alpha: 13),
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: themeManager.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: themeManager.textSecondary,
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeManager.infoColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: themeManager.getContrastingColor(themeManager.infoColor),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message, ThemeManager themeManager) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  gradient: themeManager.conditionalGradient(
                    lightGradient: LinearGradient(
                      colors: [
                        themeManager.errorColor.withValues(alpha: 51),
                        themeManager.errorColor.withValues(alpha: 26),
                      ],
                    ),
                    darkGradient: LinearGradient(
                      colors: [
                        themeManager.errorColor.withValues(alpha: 77),
                        themeManager.errorColor.withValues(alpha: 51),
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Prbal.exclamationTriangle,
                  color: themeManager.getContrastingColor(themeManager.errorColor),
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: themeManager.getContrastingColor(themeManager.errorColor),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: themeManager.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
