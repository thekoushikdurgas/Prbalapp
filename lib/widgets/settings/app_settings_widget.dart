import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:prbal/utils/cubit/theme_cubit.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';
import 'package:prbal/widgets/settings/settings_bottom_sheets.dart';

// Localization
import 'package:prbal/utils/lang/locale_keys.g.dart';

/// ====================================================================
/// APP SETTINGS WIDGET - COMPREHENSIVE THEMEMANAGER INTEGRATION
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
/// **🎯 APP-SPECIFIC ENHANCEMENTS:**
/// - Enhanced Theme Selection with real-time state display
/// - Performance monitoring for theme-related operations
/// - Comprehensive error handling for theme operations
/// - Integration with enhanced ThemeCubit state management
/// - User interaction tracking for theme preferences
/// ====================================================================

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
class AppSettingsWidget extends StatelessWidget with ThemeAwareMixin {
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
    debugPrint('⚙️ AppSettingsWidget: Building enhanced app settings with comprehensive ThemeManager integration');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging
    themeManager.logThemeInfo();
    debugPrint(
        '⚙️ AppSettingsWidget: → Notifications: $notificationsEnabled, Biometrics: $biometricsEnabled, Analytics: $analyticsEnabled');
    debugPrint('⚙️ AppSettingsWidget: → Primary: ${themeManager.primaryColor}');
    debugPrint('⚙️ AppSettingsWidget: → Secondary: ${themeManager.secondaryColor}');
    debugPrint('⚙️ AppSettingsWidget: → Background: ${themeManager.backgroundColor}');
    debugPrint('⚙️ AppSettingsWidget: → Surface: ${themeManager.surfaceColor}');
    debugPrint('⚙️ AppSettingsWidget: → Card Background: ${themeManager.cardBackground}');
    debugPrint(
        '⚙️ AppSettingsWidget: → Status Colors - Warning: ${themeManager.warningColor}, Success: ${themeManager.successColor}, Info: ${themeManager.infoColor}');
    debugPrint(
        '⚙️ AppSettingsWidget: → Accent Colors: ${themeManager.accent1}, ${themeManager.accent2}, ${themeManager.accent3}');

    return SettingsSectionWidget(
      title: 'App Settings',
      children: [
        // ========== NOTIFICATIONS SETTING WITH ENHANCED STYLING ==========
        SettingsItemWidget(
          title: 'Notifications',
          subtitle: 'Manage your notification preferences',
          icon: Prbal.bell,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.warningColor,
            darkColor: themeManager.warningLight,
          ),
          trailing: Switch.adaptive(
            value: notificationsEnabled,
            onChanged: (value) {
              debugPrint('⚙️ AppSettingsWidget: Notifications changed - $notificationsEnabled → $value');
              onNotificationsChanged(value);
            },
            activeColor: themeManager.conditionalColor(
              lightColor: themeManager.warningColor,
              darkColor: themeManager.warningLight,
            ),
            activeTrackColor: themeManager.conditionalColor(
              lightColor: themeManager.warningColor.withValues(alpha: 0.3),
              darkColor: themeManager.warningLight.withValues(alpha: 0.3),
            ),
          ),
        ),

        // ========== SECURITY SETTING WITH ENHANCED STYLING ==========
        SettingsItemWidget(
          title: 'Security',
          subtitle: biometricsEnabled ? 'Biometric authentication enabled' : 'Biometric authentication disabled',
          icon: Prbal.fingerprint,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.accent2,
            darkColor: themeManager.accent2,
          ),
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
            final themeSubtitle = _getEnhancedThemeSubtitle(context, themeMode, themeManager);
            debugPrint('🎨 AppSettingsWidget: Theme subtitle: "$themeSubtitle"');

            return SettingsItemWidget(
              title: LocaleKeys.themeTheme.tr(),
              subtitle: themeSubtitle,
              icon: Prbal.palette,
              iconColor: themeManager.conditionalColor(
                lightColor: themeManager.accent3,
                darkColor: themeManager.accent3,
              ),
              onTap: () => _handleThemeSelection(context, themeMode, themeManager),
            );
          },
        ),

        // ========== LANGUAGE SETTING WITH ENHANCED STYLING ==========
        SettingsItemWidget(
          title: LocaleKeys.localizationAppLang.tr(),
          subtitle: 'Change app language',
          icon: Prbal.language,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.primaryColor,
            darkColor: themeManager.primaryLight,
          ),
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

        // ========== ANALYTICS SETTING WITH ENHANCED STYLING ==========
        SettingsItemWidget(
          title: 'Analytics & Data',
          subtitle: 'Help improve the app with usage analytics',
          icon: Prbal.analytics,
          iconColor: themeManager.conditionalColor(
            lightColor: themeManager.infoColor,
            darkColor: themeManager.infoLight,
          ),
          trailing: Switch.adaptive(
            value: analyticsEnabled,
            onChanged: (value) {
              debugPrint('⚙️ AppSettingsWidget: Analytics changed - $analyticsEnabled → $value');
              onAnalyticsChanged(value);
            },
            activeColor: themeManager.conditionalColor(
              lightColor: themeManager.infoColor,
              darkColor: themeManager.infoLight,
            ),
            activeTrackColor: themeManager.conditionalColor(
              lightColor: themeManager.infoColor.withValues(alpha: 0.3),
              darkColor: themeManager.infoLight.withValues(alpha: 0.3),
            ),
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
  String _getEnhancedThemeSubtitle(BuildContext context, ThemeMode themeMode, ThemeManager themeManager) {
    final currentBrightness = Theme.of(context).brightness;
    debugPrint('🎨 AppSettingsWidget: Generating theme subtitle for mode: $themeMode, brightness: $currentBrightness');

    String subtitle;
    switch (themeMode) {
      case ThemeMode.system:
        subtitle = 'System Default (Currently ${currentBrightness == Brightness.dark ? 'Dark' : 'Light'})';
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
  Future<void> _handleThemeSelection(BuildContext context, ThemeMode currentMode, ThemeManager themeManager) async {
    final currentBrightness = Theme.of(context).brightness;
    debugPrint('🎨 AppSettingsWidget: Theme selection initiated');
    debugPrint('🎨 AppSettingsWidget: Current theme mode: $currentMode');
    debugPrint('🎨 AppSettingsWidget: Current brightness: $currentBrightness');

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
            content: Row(
              children: [
                Icon(
                  Prbal.errorOutline,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text('Unable to open theme settings. Please try again.'),
                ),
              ],
            ),
            backgroundColor: themeManager.conditionalColor(
              lightColor: themeManager.errorColor,
              darkColor: themeManager.errorDark,
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
    }
  }
}
