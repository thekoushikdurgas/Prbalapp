import 'package:prbal/utils/constants/onboarding/intro_constants.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// DotsDecoration - Configuration class for introduction screen page indicators
///
/// This class provides a centralized configuration for the dots that appear
/// at the bottom of introduction/onboarding screens to indicate current page
/// and allow navigation between pages.
///
/// **Features:**
/// - Customizable dot sizes for active and inactive states
/// - Consistent spacing between dots
/// - Rounded rectangle shape for active dots
/// - Uses constants from IntroConstants for maintainable configuration
///
/// **Visual Design:**
/// - Inactive dots: Small square indicators
/// - Active dot: Larger rounded rectangle indicating current page
/// - Consistent spacing for balanced appearance
///
/// **Usage:**
/// ```dart
/// IntroductionScreen(
///   dotsDecorator: DotsDecoration.decoration,
///   // ... other properties
/// )
/// ```
///
/// **Configuration Source:**
/// All visual properties are sourced from IntroConstants to maintain
/// design consistency across the app and allow easy theme updates.
class DotsDecoration {
  /// Private constructor to prevent instantiation
  /// This class is designed as a configuration provider only
  const DotsDecoration._();

  /// Static decoration configuration for introduction screen dots
  ///
  /// **Properties:**
  /// - [size]: Default size for inactive dots (from IntroConstants.dotSquare)
  /// - [activeSize]: Larger size for the active/current page dot (from IntroConstants.dotSize)
  /// - [spacing]: Horizontal spacing between dots (from IntroConstants.dotSpacing)
  /// - [activeShape]: Rounded rectangle shape for active dot (from IntroConstants.dotsBorderCircular)
  ///
  /// **Debug Information:**
  /// This decoration is applied to introduction screens to provide visual
  /// feedback about current page position and navigation progress.
  static final decoration = DotsDecorator(
    // Size configuration for inactive page indicators
    size: IntroConstants.dotSquare,

    // Larger size for active/current page indicator
    activeSize: IntroConstants.dotSize,

    // Consistent spacing between dots for balanced layout
    spacing: IntroConstants.dotSpacing,

    // Rounded rectangle shape for active dot to distinguish from inactive squares
    activeShape: RoundedRectangleBorder(
      borderRadius: IntroConstants.dotsBorderCircular,
    ),
  );

  /// Debug helper method to log decoration properties
  ///
  /// This method can be called during development to verify
  /// the current decoration configuration values.
  static void debugLogConfiguration() {
    debugPrint('🔵 DotsDecoration: Configuration details:');
    debugPrint('🔵 DotsDecoration: Inactive dot size: ${IntroConstants.dotSquare}');
    debugPrint('🔵 DotsDecoration: Active dot size: ${IntroConstants.dotSize}');
    debugPrint('🔵 DotsDecoration: Dot spacing: ${IntroConstants.dotSpacing}');
    debugPrint('🔵 DotsDecoration: Border radius: ${IntroConstants.dotsBorderCircular}');
  }
}
