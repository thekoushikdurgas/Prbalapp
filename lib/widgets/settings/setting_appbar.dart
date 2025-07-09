import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:prbal/utils/lang/locale_keys.g.dart';

/// SettingAppbar - A localized app bar component for settings screens
///
/// This widget provides a consistent app bar for settings-related screens with:
///
/// **Features:**
/// - Automatic localization using easy_localization
/// - Theme-aware text styling using headlineSmall
/// - Implements PreferredSizeWidget for proper AppBar integration
/// - Standard toolbar height for consistent UI across screens
/// - Null-safe operations without using null assertion operators
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
    final colorScheme = theme.colorScheme;

    debugPrint(
        '⚙️ SettingAppbar: Current theme brightness: ${theme.brightness}');

    // Get headline small style with proper null handling
    final headlineSmallStyle = textTheme.headlineSmall;
    if (headlineSmallStyle != null) {
      debugPrint('⚙️ SettingAppbar: Headline small style: $headlineSmallStyle');
    } else {
      debugPrint(
          '⚙️ SettingAppbar: Headline small style is null, using fallback');
    }

    // Get localized title text
    final localizedTitle = LocaleKeys.settingTitle.tr();
    debugPrint('⚙️ SettingAppbar: Localized title: "$localizedTitle"');
    debugPrint('⚙️ SettingAppbar: Current locale: ${context.locale}');

    // Create title style with proper null safety
    final titleStyle = headlineSmallStyle != null
        ? headlineSmallStyle.copyWith(
            // Ensure proper contrast in all themes
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          )
        : TextStyle(
            // Fallback style if headlineSmall is null
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          );

    return AppBar(
      // Localized title with theme-appropriate styling
      title: Text(
        localizedTitle,
        style: titleStyle,
      ),
      // Enable automatic leading back button for navigation
      automaticallyImplyLeading: true,
      // Center the title for better visual balance
      centerTitle: true,
      // Apply theme-based elevation and colors
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      // Add subtle shadow for depth with proper null handling
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
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
    const size = Size.fromHeight(kToolbarHeight);
    debugPrint('⚙️ SettingAppbar: Returning preferred size: $size');
    return size;
  }
}
