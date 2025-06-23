import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// TextLabelLargeTitle - A theme-aware text component with localization support
///
/// This widget renders text with the following features:
/// - Automatic theme-based styling using labelLarge from the current theme
/// - Built-in localization support via easy_localization
/// - Responsive text rendering that adapts to the app's current theme
///
/// Usage:
/// ```dart
/// TextLabelLargeTitle(text: 'my_text_key') // Will translate the key and apply theme styling
/// ```
class TextLabelLargeTitle extends StatelessWidget {
  /// Creates a themed text widget with localization
  ///
  /// [text] - The localization key to translate and display
  const TextLabelLargeTitle({super.key, required this.text});

  /// The text key to be translated and displayed
  final String text;

  @override
  Widget build(BuildContext context) {
    debugPrint('📝 TextLabelLargeTitle: Building themed text component');
    debugPrint('📝 TextLabelLargeTitle: Text key to translate: "$text"');

    // Get current theme for styling information
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge;

    debugPrint(
        '📝 TextLabelLargeTitle: Current theme brightness: ${theme.brightness}');
    debugPrint(
        '📝 TextLabelLargeTitle: Label style - fontSize: ${labelStyle?.fontSize}, color: ${labelStyle?.color}');

    // Translate the text key and apply theme styling
    final translatedText = text.tr();
    debugPrint('📝 TextLabelLargeTitle: Translated text: "$translatedText"');

    return Text(
      translatedText, // Apply localization translation
      style:
          labelStyle, // Use theme's labelLarge style for consistent appearance
    );
  }
}
