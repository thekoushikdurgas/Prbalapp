import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:prbal/utils/cubit/theme_cubit.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';
import 'package:prbal/widgets/settings/settings_bottom_sheets.dart';

// Theme Management
// import 'package:prbal/utils/cubit/theme_cubit.dart';

// Localization
import 'package:prbal/utils/lang/locale_keys.g.dart';

/// AppSettingsWidget - Enhanced app settings section with comprehensive theme debugging
///
/// This widget provides application-related settings options including:
/// - Notifications toggle with state tracking
/// - Security settings (biometric authentication) with status display
/// - **Enhanced Theme Selection** with real-time theme state display
/// - Language selection with current locale display
/// - Analytics toggle with privacy controls
///
/// **Enhanced Theme Features:**
/// - Real-time theme state monitoring and debugging
/// - Dynamic subtitle showing current theme mode
/// - Comprehensive error handling for theme operations
/// - Integration with enhanced ThemeCubit state management
/// - Performance monitoring for theme-related operations
///
/// **Debug Features:**
/// - Detailed debug prints for theme state changes
/// - Theme operation timing and performance tracking
/// - Error logging with context and recovery suggestions
/// - User interaction tracking for theme preferences
///
/// **Architecture:**
/// - Uses BlocBuilder for reactive theme state updates
/// - Integrates with enhanced SettingsBottomSheets
/// - Follows Material 3 design principles
/// - Implements proper error boundaries
class AppSettingsWidget extends StatelessWidget {
  const AppSettingsWidget({
    super.key,
    required this.notificationsEnabled,
    required this.biometricsEnabled,
    required this.analyticsEnabled,
    required this.onNotificationsChanged,
    required this.onSecurityTapped,
    required this.onAnalyticsChanged,
  });

  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final bool analyticsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onSecurityTapped;
  final ValueChanged<bool> onAnalyticsChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ AppSettingsWidget: Building enhanced app settings');
    debugPrint(
        '⚙️ AppSettingsWidget: Notifications: $notificationsEnabled, Biometrics: $biometricsEnabled, Analytics: $analyticsEnabled');

    // Get current theme information for debugging
    final currentTheme = Theme.of(context);
    final isDark = currentTheme.brightness == Brightness.dark;
    debugPrint('⚙️ AppSettingsWidget: Current theme brightness: ${currentTheme.brightness}');
    debugPrint(
        '⚙️ AppSettingsWidget: Theme colors - Primary: ${currentTheme.colorScheme.primary}, Surface: ${currentTheme.colorScheme.surface}');

    return SettingsSectionWidget(
      title: 'App Settings',
      children: [
        // ========== NOTIFICATIONS SETTING ==========
        SettingsItemWidget(
          title: 'Notifications',
          subtitle: 'Manage your notification preferences',
          icon: Prbal.bell,
          iconColor: const Color(0xFFED8936),
          trailing: Switch.adaptive(
            value: notificationsEnabled,
            onChanged: (value) {
              debugPrint('⚙️ AppSettingsWidget: Notifications changed - $notificationsEnabled → $value');
              onNotificationsChanged(value);
            },
            activeColor: const Color(0xFFED8936),
          ),
        ),

        // ========== SECURITY SETTING ==========
        SettingsItemWidget(
          title: 'Security',
          subtitle: biometricsEnabled ? 'Biometric authentication enabled' : 'Biometric authentication disabled',
          icon: Prbal.fingerprint,
          iconColor: const Color(0xFF9F7AEA),
          onTap: () {
            debugPrint('⚙️ AppSettingsWidget: Security settings tapped');
            try {
              onSecurityTapped();
              debugPrint('⚙️ AppSettingsWidget: ✅ Security settings opened successfully');
            } catch (error) {
              debugPrint('⚙️ AppSettingsWidget: ❌ Error opening security settings: $error');
            }
          },
        ),

        // ========== ENHANCED THEME SETTING WITH REAL-TIME STATE ==========
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            debugPrint('🎨 AppSettingsWidget: Building theme setting with current mode: $themeMode');

            // Generate dynamic subtitle based on current theme state
            final themeSubtitle = _getEnhancedThemeSubtitle(themeMode, isDark);
            debugPrint('🎨 AppSettingsWidget: Theme subtitle: "$themeSubtitle"');

            return SettingsItemWidget(
              title: LocaleKeys.themeTheme.tr(),
              subtitle: themeSubtitle,
              icon: Prbal.palette,
              iconColor: const Color(0xFF38B2AC),
              onTap: () => _handleThemeSelection(context, themeMode),
            );
          },
        ),

        // ========== LANGUAGE SETTING ==========
        SettingsItemWidget(
          title: LocaleKeys.localizationAppLang.tr(),
          subtitle: 'Change app language',
          icon: Prbal.language,
          iconColor: const Color(0xFF667EEA),
          onTap: () {
            debugPrint('⚙️ AppSettingsWidget: Language settings tapped');
            try {
              SettingsBottomSheets.showLanguageBottomSheet(context);
              debugPrint('⚙️ AppSettingsWidget: ✅ Language settings opened successfully');
            } catch (error) {
              debugPrint('⚙️ AppSettingsWidget: ❌ Error opening language settings: $error');
            }
          },
        ),

        // ========== ANALYTICS SETTING ==========
        SettingsItemWidget(
          title: 'Analytics & Data',
          subtitle: 'Help improve the app with usage analytics',
          icon: Icons.analytics,
          iconColor: const Color(0xFF4299E1),
          trailing: Switch.adaptive(
            value: analyticsEnabled,
            onChanged: (value) {
              debugPrint('⚙️ AppSettingsWidget: Analytics changed - $analyticsEnabled → $value');
              onAnalyticsChanged(value);
            },
            activeColor: const Color(0xFF4299E1),
          ),
        ),
      ],
    );
  }

  /// Generates enhanced theme subtitle with current state information
  ///
  /// This method provides real-time feedback about the current theme state:
  /// - Shows the active theme mode (Light, Dark, System)
  /// - Indicates if system theme is being followed
  /// - Provides context about automatic theme switching
  ///
  /// **Enhanced Features:**
  /// - Real-time state reflection
  /// - User-friendly descriptions
  /// - System theme detection
  /// - Accessibility-friendly text
  String _getEnhancedThemeSubtitle(ThemeMode themeMode, bool isDark) {
    debugPrint('🎨 AppSettingsWidget: Generating theme subtitle for mode: $themeMode, isDark: $isDark');

    String subtitle;
    switch (themeMode) {
      case ThemeMode.system:
        subtitle = 'System Default (Currently ${isDark ? 'Dark' : 'Light'})';
        break;
      case ThemeMode.light:
        subtitle = 'Light Theme Selected';
        break;
      case ThemeMode.dark:
        subtitle = 'Dark Theme Selected';
        break;
    }

    debugPrint('🎨 AppSettingsWidget: Generated subtitle: "$subtitle"');
    return subtitle;
  }

  /// Handles theme selection with comprehensive debugging and error handling
  ///
  /// This method provides enhanced theme selection with:
  /// - Performance timing for theme operations
  /// - Comprehensive error handling and recovery
  /// - User feedback for successful operations
  /// - Context-aware debugging information
  ///
  /// **Enhanced Features:**
  /// - Operation timing and performance monitoring
  /// - Error context and recovery suggestions
  /// - Success confirmation and user feedback
  /// - Integration with enhanced theme debugging
  Future<void> _handleThemeSelection(BuildContext context, ThemeMode currentMode) async {
    debugPrint('🎨 AppSettingsWidget: Theme selection initiated');
    debugPrint('🎨 AppSettingsWidget: Current theme mode: $currentMode');

    final stopwatch = Stopwatch()..start();

    try {
      debugPrint('🎨 AppSettingsWidget: Opening theme selection bottom sheet...');

      // Open enhanced theme selection bottom sheet
      await SettingsBottomSheets.showThemeBottomSheet(context);

      stopwatch.stop();
      debugPrint('🎨 AppSettingsWidget: ✅ Theme selection completed successfully');
      debugPrint('🎨 AppSettingsWidget: ⏱️ Operation completed in ${stopwatch.elapsedMilliseconds}ms');

      // Log final theme state after selection
      if (context.mounted) {
        final newThemeMode = context.read<ThemeCubit>().state;
        debugPrint('🎨 AppSettingsWidget: Final theme state: $newThemeMode');

        if (newThemeMode != currentMode) {
          debugPrint('🎨 AppSettingsWidget: 🔄 Theme changed: $currentMode → $newThemeMode');
        } else {
          debugPrint('🎨 AppSettingsWidget: 📍 Theme unchanged: $currentMode');
        }
      }
    } catch (error, stackTrace) {
      stopwatch.stop();
      debugPrint('🎨 AppSettingsWidget: ❌ Error in theme selection: $error');
      debugPrint('🎨 AppSettingsWidget: 📍 Error occurred after ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('🎨 AppSettingsWidget: 🔍 Stack trace: $stackTrace');

      // Show user-friendly error feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open theme settings. Please try again.'),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
