import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prbal/services/service_providers.dart';
import 'package:prbal/services/authentication_notifier.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// Profile Picture Handler
///
/// This class provides a complete implementation for handling profile picture updates
/// including image picking, uploading, and state management.
class ProfilePictureHandler {
  /// Handle enhanced profile picture update from camera or gallery
  static Future<void> handleProfilePictureUpdate(
    BuildContext context,
    ImageSource source, {
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    final ref = ProviderScope.containerOf(context);
    final authState = ref.read(authenticationStateProvider);
    final userService = ref.read(userServiceProvider);
    final themeManager = ThemeManager.of(context);

    debugPrint('📷 [ProfilePicture] Starting enhanced profile picture update');
    debugPrint('📷 [ProfilePicture] Image source: ${source.name}');

    // Check authentication
    if (!authState.isAuthenticated || authState.accessToken == null) {
      final errorMessage = 'Please log in to update your profile picture';
      debugPrint('❌ [ProfilePicture] Authentication check failed');
      onError?.call(errorMessage);
      _showSnackBar(context, errorMessage, isError: true, themeManager: themeManager);
      return;
    }

    try {
      // Show loading indicator
      _showLoadingDialog(context);

      // Pick image from selected source
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85, // Compress image for faster upload
        maxWidth: 1024, // Limit image size
        maxHeight: 1024,
        preferredCameraDevice: CameraDevice.front, // Use front camera for profile pics
      );

      if (pickedFile == null) {
        _closeLoadingDialog(context);
        return; // User cancelled image selection
      }

      debugPrint('📷 ProfilePictureHandler: Image selected: ${pickedFile.path}');
      debugPrint('📦 ProfilePictureHandler: File size: ${await File(pickedFile.path).length()} bytes');

      // Convert to File
      final File imageFile = File(pickedFile.path);

      // Validate file size (max 5MB)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        _closeLoadingDialog(context);
        const errorMessage = 'Image is too large. Please select an image smaller than 5MB.';
        onError?.call(errorMessage);
        _showSnackBar(context, errorMessage, isError: true, themeManager: themeManager);
        return;
      }

      // Upload profile image
      debugPrint('🚀 ProfilePictureHandler: Uploading image...');
      final uploadResponse = await userService.uploadProfileImage(
        imageFile,
        authState.accessToken!,
      );

      // Close loading dialog
      _closeLoadingDialog(context);

      if (uploadResponse.isSuccess && uploadResponse.data != null) {
        // Extract new profile picture URL from different possible response structures
        final newProfilePictureUrl = _extractProfilePictureUrl(uploadResponse.data!);

        debugPrint('🎯 ProfilePictureHandler: New profile URL: $newProfilePictureUrl');

        if (newProfilePictureUrl != null && newProfilePictureUrl.isNotEmpty) {
          // Update authentication state with new profile picture
          await _updateAuthenticationState(
            ref,
            authState,
            newProfilePictureUrl,
          );

          // Clean up temporary file
          try {
            if (await imageFile.exists()) {
              await imageFile.delete();
              debugPrint('🗑️ ProfilePictureHandler: Temporary file cleaned up');
            }
          } catch (e) {
            debugPrint('⚠️ ProfilePictureHandler: Failed to clean up temp file: $e');
          }

          // Show success message
          const successMessage = 'Profile picture updated successfully!';
          onSuccess?.call();
          _showSnackBar(context, successMessage, isError: false, themeManager: themeManager);

          debugPrint('✅ ProfilePictureHandler: Profile picture updated successfully');
        } else {
          throw Exception('No profile picture URL received from server');
        }
      } else {
        throw Exception(uploadResponse.message);
      }
    } catch (e) {
      // Close loading dialog if still open
      _closeLoadingDialog(context);

      // Show error message
      final errorMessage = 'Failed to update profile picture: $e';
      onError?.call(errorMessage);
      _showSnackBar(context, errorMessage, isError: true, themeManager: themeManager);

      debugPrint('❌ ProfilePictureHandler: Profile picture update failed: $e');
    }
  }

  /// Extract profile picture URL from API response
  static String? _extractProfilePictureUrl(Map<String, dynamic> responseData) {
    // Try different possible response structures
    final rawUrl = responseData['data']?['user']?['profile_picture'] as String? ??
        responseData['user']?['profile_picture'] as String? ??
        responseData['profile_picture'] as String? ??
        responseData['data']?['profile_picture'] as String?;

    // Convert relative URL to absolute URL if needed
    if (rawUrl != null && rawUrl.isNotEmpty) {
      return ApiService.convertToAbsoluteUrl(rawUrl);
    }

    return null;
  }

  /// Update authentication state with new profile picture
  static Future<void> _updateAuthenticationState(
    ProviderContainer ref,
    AuthenticationState authState,
    String newProfilePictureUrl,
  ) async {
    final authNotifier = ref.read(authenticationStateProvider.notifier);

    // Create updated user data
    final updatedUserData = {
      ...authState.userData ?? {},
      'profile_picture': newProfilePictureUrl,
      'profilePicture': newProfilePictureUrl, // Both formats for compatibility
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Update authentication state
    await authNotifier.setAuthenticated(
      accessToken: authState.accessToken!,
      refreshToken: authState.refreshToken,
      userData: updatedUserData,
      userType: authState.userType!,
    );

    debugPrint('🔄 ProfilePictureHandler: Authentication state updated');
  }

  /// Show enhanced loading dialog with ThemeManager integration
  static void _showLoadingDialog(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false, // Prevent back button dismissal
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              // Enhanced gradient background
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.surfaceColor.withValues(alpha: 248),
                    themeManager.backgroundColor.withValues(alpha: 242),
                    themeManager.infoColor.withValues(alpha: 13),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.surfaceColor.withValues(alpha: 235),
                    themeManager.backgroundColor.withValues(alpha: 248),
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
                width: 1.5,
              ),
              boxShadow: themeManager.elevatedShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Enhanced loading indicator container
                Container(
                  padding: EdgeInsets.all(16.w),
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
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeManager.infoColor.withValues(alpha: 51),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeManager.infoColor),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 24.h),
                // Enhanced title
                Text(
                  'Updating Profile Picture',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.textPrimary,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                // Enhanced subtitle container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
                    'Please wait while we process your image...',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: themeManager.textSecondary,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Close loading dialog
  static void _closeLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Show enhanced snackbar with ThemeManager integration
  static void _showSnackBar(BuildContext context, String message,
      {required bool isError, required ThemeManager themeManager}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Prbal.errorOutline : Prbal.checkCircleOutline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(0xFF48BB78),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 4 : 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Handle profile picture update with permission checking
  ///
  /// This method includes permission handling for camera and gallery access.
  /// You'll need to add permission_handler package to use this:
  ///
  /// dependencies:
  ///   permission_handler: ^11.0.1
  static Future<void> handleProfilePictureUpdateWithPermissions(
    BuildContext context,
    ImageSource source, {
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    // Note: Uncomment and use this if you want permission handling
    //
    // import 'package:permission_handler/permission_handler.dart';
    //
    // // Request permissions based on source
    // Permission permission = source == ImageSource.camera
    //     ? Permission.camera
    //     : Permission.photos;
    //
    // final status = await permission.request();
    //
    // if (status.isDenied) {
    //   final permissionName = source == ImageSource.camera ? 'Camera' : 'Gallery';
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('$permissionName permission is required to update your profile picture'),
    //       action: SnackBarAction(
    //         label: 'Settings',
    //         onPressed: () => openAppSettings(),
    //       ),
    //       backgroundColor: const Color(0xFFE53E3E),
    //     ),
    //   );
    //   return;
    // }
    //
    // if (status.isPermanentlyDenied) {
    //   final permissionName = source == ImageSource.camera ? 'camera' : 'gallery';
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please enable $permissionName access in Settings to update your profile picture'),
    //       action: SnackBarAction(
    //         label: 'Settings',
    //         onPressed: () => openAppSettings(),
    //       ),
    //       backgroundColor: const Color(0xFFE53E3E),
    //       duration: const Duration(seconds: 5),
    //     ),
    //   );
    //   return;
    // }

    // Continue with the main implementation
    await handleProfilePictureUpdate(
      context,
      source,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
