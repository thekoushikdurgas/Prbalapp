import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:prbal/services/app_services.dart';

/// Profile Picture Handler
///
/// This class provides a complete implementation for handling profile picture updates
/// including image picking, uploading, and state management.
class ProfilePictureHandler {
  /// Handle profile picture update from camera or gallery
  static Future<void> handleProfilePictureUpdate(
    BuildContext context,
    ImageSource source, {
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    final ref = ProviderScope.containerOf(context);
    // final authNotifier = ref.read(authenticationStateProvider.notifier);
    final userService = ref.read(userServiceProvider);
    final authState = ref.read(authenticationStateProvider);

    debugPrint(
        '📷 ProfilePictureHandler: ====== PROFILE PICTURE UPDATE STARTED ======');
    debugPrint('📷 ProfilePictureHandler: Image source: ${source.name}');
    debugPrint(
        '📷 ProfilePictureHandler: User authenticated: ${authState.isAuthenticated}');
    debugPrint(
        '📷 ProfilePictureHandler: Has access token: ${authState.tokens?.accessToken.isNotEmpty ?? false}');
    // Check authentication
    if (!authState.isAuthenticated ||
        authState.tokens?.accessToken.isEmpty == true) {
      final errorMessage = 'Please log in to update your profile picture';
      debugPrint('📷 ProfilePictureHandler: ❌ Authentication check failed');
      onError?.call(errorMessage);
      _showSnackBar(context, errorMessage, isError: true);
      return;
    }

    final authToken = authState.tokens!.accessToken;

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
        preferredCameraDevice:
            CameraDevice.front, // Use front camera for profile pics
      );

      if (pickedFile == null) {
        _closeLoadingDialog(context);
        return; // User cancelled image selection
      }

      debugPrint(
          '📷 ProfilePictureHandler: Image selected: ${pickedFile.path}');
      debugPrint(
          '📦 ProfilePictureHandler: File size: ${await File(pickedFile.path).length()} bytes');

      // Convert to File
      final File imageFile = File(pickedFile.path);

      // Validate file size (max 5MB)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        _closeLoadingDialog(context);
        const errorMessage =
            'Image is too large. Please select an image smaller than 5MB.';
        onError?.call(errorMessage);
        _showSnackBar(context, errorMessage, isError: true);
        return;
      }

      // Upload profile image
      debugPrint('🚀 ProfilePictureHandler: Uploading image...');
      final uploadResponse =
          await userService.uploadProfileImage(imageFile, authToken);

      // Close loading dialog
      _closeLoadingDialog(context);

      if (uploadResponse.isSuccess && uploadResponse.data != null) {
        // Extract new profile picture URL from different possible response structures
        final apiService = ref.read(apiServiceProvider);
        final newProfilePictureUrl =
            _extractProfilePictureUrl(uploadResponse.data!, apiService);

        debugPrint(
            '🎯 ProfilePictureHandler: New profile URL: $newProfilePictureUrl');

        if (newProfilePictureUrl != null && newProfilePictureUrl.isNotEmpty) {
          // Update authentication state with new profile picture
          await _updateAuthenticationState(
            ref,
            newProfilePictureUrl,
          );

          // Clean up temporary file
          try {
            if (await imageFile.exists()) {
              await imageFile.delete();
              debugPrint(
                  '🗑️ ProfilePictureHandler: Temporary file cleaned up');
            }
          } catch (e) {
            debugPrint(
                '⚠️ ProfilePictureHandler: Failed to clean up temp file: $e');
          }

          // Show success message
          const successMessage = 'Profile picture updated successfully!';
          onSuccess?.call();
          _showSnackBar(context, successMessage, isError: false);

          debugPrint(
              '✅ ProfilePictureHandler: Profile picture updated successfully');
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
      _showSnackBar(context, errorMessage, isError: true);

      debugPrint('❌ ProfilePictureHandler: Profile picture update failed: $e');
    }
  }

  /// Extract profile picture URL from API response
  static String? _extractProfilePictureUrl(
      Map<String, dynamic> responseData, dynamic apiService) {
    // Try different possible response structures
    final rawUrl =
        responseData['data']?['user']?['profile_picture'] as String? ??
            responseData['user']?['profile_picture'] as String? ??
            responseData['profile_picture'] as String? ??
            responseData['data']?['profile_picture'] as String?;

    // Convert relative URL to absolute URL if needed
    if (rawUrl != null && rawUrl.isNotEmpty) {
      return apiService.convertToAbsoluteUrl(rawUrl);
    }

    return null;
  }

  /// Update authentication state with new profile picture
  static Future<void> _updateAuthenticationState(
    ProviderContainer ref,
    String newProfilePictureUrl,
  ) async {
    debugPrint(
        '🔄 ProfilePictureHandler: ====== UPDATING AUTHENTICATION STATE ======');
    debugPrint(
        '🔄 ProfilePictureHandler: New profile picture URL: $newProfilePictureUrl');

    try {
      // Get authentication notifier
      final authNotifier = ref.read(authenticationStateProvider.notifier);
      final currentUser = authNotifier.currentUser;

      if (currentUser == null) {
        throw Exception('No current user found in authentication state');
      }

      debugPrint(
          '🔄 ProfilePictureHandler: Current user: ${currentUser.username}');
      debugPrint('🔄 ProfilePictureHandler: Updating profile picture...');

      // Create updated user data with new profile picture
      final updatedUserData = currentUser.copyWith(
        profilePicture: newProfilePictureUrl,
        updatedAt: DateTime.now(),
      );

      // Update authentication state with new user data
      await authNotifier.updateUser(updatedUserData);

      debugPrint(
          '🔄 ProfilePictureHandler: ✅ Authentication state updated successfully');
      debugPrint(
          '🔄 ProfilePictureHandler: User data saved to both auth state and Hive');
    } catch (e) {
      debugPrint(
          '🔄 ProfilePictureHandler: ❌ Failed to update authentication state: $e');
      throw Exception('Failed to update authentication state: $e');
    }
  }

  /// Show loading dialog
  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false, // Prevent back button dismissal
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2D2D2D)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Updating profile picture...',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
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

  /// Show snackbar with message
  static void _showSnackBar(BuildContext context, String message,
      {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
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
        backgroundColor:
            isError ? const Color(0xFFE53E3E) : const Color(0xFF48BB78),
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
