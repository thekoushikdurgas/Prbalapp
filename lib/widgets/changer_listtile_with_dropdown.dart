import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

/// ChangerListtileWithDropdown - A reusable list tile that opens a dialog
///
/// This widget creates a clickable list tile that, when tapped, displays
/// a modal dialog with custom content. It's designed for settings screens
/// or any interface where users need to select options from a dropdown-like dialog.
///
/// **Features:**
/// - Reusable list tile component with consistent styling
/// - Customizable icon, title, and dialog content
/// - Theme-aware text styling
/// - Modal dialog presentation with custom content
/// - Inkwell tap effects for better user feedback
///
/// **Use Cases:**
/// - Theme selection dropdowns
/// - Language selection
/// - Preference changes
/// - Option selection menus
///
/// **Parameters:**
/// - [icon]: Leading icon for the list tile
/// - [title]: Main text displayed on the list tile
/// - [alertTitle]: Title text shown in the dialog
/// - [child]: Custom widget content displayed in the dialog
///
/// **Usage:**
/// ```dart
/// ChangerListtileWithDropdown(
///   icon: Icon(Prbal.palette),
///   title: 'Theme',
///   alertTitle: 'Select Theme',
///   child: ThemeChangeDropdown(),
/// )
/// ```
class ChangerListtileWithDropdown extends StatelessWidget {
  /// Creates a list tile that opens a dialog when tapped
  ///
  /// All parameters are required to ensure proper functionality:
  /// - [icon]: Visual indicator for the setting/option
  /// - [title]: Clear description of what the tile controls
  /// - [alertTitle]: Dialog header that explains the selection
  /// - [child]: The actual selection interface (dropdown, radio buttons, etc.)
  const ChangerListtileWithDropdown({
    super.key,
    required this.icon,
    required this.title,
    required this.alertTitle,
    required this.child,
  });

  /// Leading icon displayed on the left side of the list tile
  final Icon icon;

  /// Main title text shown on the list tile
  final String title;

  /// Title text displayed at the top of the dialog
  final String alertTitle;

  /// Custom widget content shown inside the dialog
  final Widget child;

  @override
  Widget build(BuildContext context) {
    debugPrint('🔧 ChangerListtileWithDropdown: Building list tile for "$title"');

    // Get current theme for adaptive styling
    final theme = Theme.of(context);
    debugPrint('🔧 ChangerListtileWithDropdown: Current theme brightness: ${theme.brightness}');

    return InkWell(
      onTap: () {
        debugPrint('🔧 ChangerListtileWithDropdown: List tile tapped - opening dialog');
        debugPrint('🔧 ChangerListtileWithDropdown: Dialog title: "$alertTitle"');
        _showDialog(context);
      },
      // Customize the splash and highlight colors for better UX
      splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8.0), // Rounded corners for modern look
      child: ListTile(
        // Leading icon with theme-aware color
        leading: IconTheme(
          data: theme.iconTheme.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          child: icon,
        ),
        // Title with theme-appropriate text style
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Trailing arrow to indicate clickable action
        trailing: Icon(
          Prbal.arrowSync,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  /// Shows a modal dialog with the provided child widget
  ///
  /// **Dialog Configuration:**
  /// - Modal presentation (blocks interaction with background)
  /// - Custom title styling with theme awareness
  /// - Centered title for better visual hierarchy
  /// - Scrollable content area for complex child widgets
  ///
  /// **Returns:**
  /// Future that completes when the dialog is dismissed
  Future<dynamic> _showDialog(BuildContext context) {
    debugPrint('🔧 ChangerListtileWithDropdown: Displaying dialog');

    // Get current theme for dialog styling
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    debugPrint('🔧 ChangerListtileWithDropdown: Dialog theme mode: ${isDark ? 'dark' : 'light'}');

    return showDialog(
      context: context,
      // Allow dismissal by tapping outside the dialog
      barrierDismissible: true,
      builder: (context) {
        debugPrint('🔧 ChangerListtileWithDropdown: Building dialog content');

        return AlertDialog(
          // Dialog styling with theme awareness
          backgroundColor: theme.dialogTheme.backgroundColor,
          surfaceTintColor: theme.colorScheme.surfaceTint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          // Title with center alignment and theme styling
          title: Text(
            alertTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Content area with the provided child widget
          content: SingleChildScrollView(
            child: child,
          ),
          // Content padding for better spacing
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
        );
      },
    ).then((result) {
      debugPrint('🔧 ChangerListtileWithDropdown: Dialog dismissed with result: $result');
      return result;
    });
  }
}
