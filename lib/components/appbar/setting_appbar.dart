import 'package:prbal/utils/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// SettingAppbar - A localized app bar component for settings screens
///
/// This widget provides a consistent app bar for settings-related screens with:
///
/// **Features:**
/// - Automatic localization using easy_localization
/// - Theme-aware text styling using headlineSmall
/// - Implements PreferredSizeWidget for proper AppBar integration
/// - Standard toolbar height for consistent UI across screens
///
/// **Localization:**
/// - Uses LocaleKeys.settingTitle for the title text
/// - Automatically adapts to current app language
/// - Supports RTL languages through easy_localization
///
/// **Usage:**
/// ```dart
/// Scaffold(
///   appBar: SettingAppbar(),
///   body: SettingsScreenContent(),
/// )
/// ```
///
/// **Integration:**
/// This component is designed to be used with settings screens
/// and provides a standardized header appearance across all
/// settings-related interfaces in the application.
class SettingAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SettingAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ SettingAppbar: Building settings app bar');

    // Get current theme for styling information
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    debugPrint('⚙️ SettingAppbar: Current theme brightness: ${theme.brightness}');
    debugPrint('⚙️ SettingAppbar: Headline small style: ${textTheme.headlineSmall}');

    // Get localized title text
    final localizedTitle = LocaleKeys.settingTitle.tr();
    debugPrint('⚙️ SettingAppbar: Localized title: "$localizedTitle"');
    debugPrint('⚙️ SettingAppbar: Current locale: ${context.locale}');

    return AppBar(
      // Localized title with theme-appropriate styling
      title: Text(
        localizedTitle,
        style: textTheme.headlineSmall?.copyWith(
          // Ensure proper contrast in all themes
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Enable automatic leading back button for navigation
      automaticallyImplyLeading: true,
      // Center the title for better visual balance
      centerTitle: true,
      // Apply theme-based elevation and colors
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      // Add subtle shadow for depth
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
    );
  }

  /// Returns the preferred size for this app bar
  ///
  /// **Standard Height:**
  /// Uses kToolbarHeight (typically 56.0 logical pixels) which is the
  /// standard Material Design app bar height. This ensures consistency
  /// with other app bars throughout the application.
  ///
  /// **Implementation Note:**
  /// This is required by the PreferredSizeWidget interface to properly
  /// integrate with Scaffold's appBar property.
  @override
  Size get preferredSize {
    debugPrint('⚙️ SettingAppbar: Returning preferred size: ${const Size.fromHeight(kToolbarHeight)}');
    return const Size.fromHeight(kToolbarHeight);
  }
}
