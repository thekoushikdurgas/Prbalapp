import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/models/auth/app_user.dart';

// Services
import 'package:prbal/services/hive_service.dart';
// import 'package:prbal/services/user_service.dart';

/// Utility class for managing user preferences and settings
class PreferencesManager {
  /// Saves notification preference
  static Future<void> saveNotificationPreference({
    required bool enabled,
    required BuildContext context,
  }) async {
    debugPrint(
        '⚙️ PreferencesManager: Saving notification preference: $enabled');

    try {
      AppUser userData = HiveService.getUserData();
      userData = userData.copyWith(notificationsEnabled: enabled);
      HiveService.saveUserData(userData).then((value) {
        if (context.mounted) {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  enabled ? 'Notifications enabled' : 'Notifications disabled'),
              backgroundColor:
                  enabled ? const Color(0xFF48BB78) : const Color(0xFFED8936),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              margin: EdgeInsets.all(16.w),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint(
          '❌ PreferencesManager: Failed to save notification preference: $e');
    }
  }

  /// Saves analytics preference
  static Future<void> saveAnalyticsPreference({
    required bool enabled,
    required BuildContext context,
  }) async {
    debugPrint('⚙️ PreferencesManager: Saving analytics preference: $enabled');

    try {
      AppUser userData = HiveService.getUserData();
      userData = userData.copyWith(analyticsEnabled: enabled);
      HiveService.saveUserData(userData).then((value) {
        if (context.mounted) {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(enabled ? 'Analytics enabled' : 'Analytics disabled'),
              backgroundColor: const Color(0xFF4299E1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              margin: EdgeInsets.all(16.w),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint(
          '❌ PreferencesManager: Failed to save analytics preference: $e');
    }
  }

  /// Saves biometric preference
  static Future<void> saveBiometricPreference({
    required bool enabled,
    required BuildContext context,
  }) async {
    debugPrint('⚙️ PreferencesManager: Saving biometric preference: $enabled');

    try {
      AppUser userData = HiveService.getUserData();
      userData = userData.copyWith(biometricsEnabled: enabled);
      await HiveService.saveUserData(userData);

      if (context.mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(enabled
                ? 'Biometric authentication enabled'
                : 'Biometric authentication disabled'),
            backgroundColor: const Color(0xFF9F7AEA),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );
      }
    } catch (e) {
      debugPrint(
          '❌ PreferencesManager: Failed to save biometric preference: $e');
    }
  }

  /// Loads user preferences from local storage
  static Future<Map<String, bool>> loadUserPreferences() async {
    debugPrint('⚙️ PreferencesManager: Loading user preferences');

    try {
      final userData = HiveService.getUserData();
      return {
        'notifications_enabled': userData.notificationsEnabled,
        'biometrics_enabled': userData.biometricsEnabled,
        'analytics_enabled': userData.analyticsEnabled,
      };
    } catch (e) {
      debugPrint('❌ PreferencesManager: Error loading user preferences: $e');
      // Return default values on error
      return {
        'notifications_enabled': true,
        'biometrics_enabled': false,
        'analytics_enabled': true,
      };
    }
  }
}
