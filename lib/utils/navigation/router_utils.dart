import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../icon/prbal_icons.dart';
import '../theme/theme_manager.dart';

/// Router utilities for common functionality with comprehensive ThemeManager integration
class RouterUtils {
  const RouterUtils._();

  /// Custom page transitions with theme-aware animations
  static CustomTransitionPage<dynamic> buildPageTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    bool slideFromRight = true,
  }) {
    final themeManager = ThemeManager.of(context);

    // Log theme information for debugging
    themeManager.logThemeInfo();

    debugPrint('🚀 RouterUtils: Building page transition for ${state.uri}');
    debugPrint(
        '🎨 RouterUtils: Using ${themeManager.themeManager ? 'dark' : 'light'} theme');

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// Fade transition for image viewing with theme-aware overlay
  static CustomTransitionPage<void> buildFadeTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    final themeManager = ThemeManager.of(context);

    debugPrint('🖼️ RouterUtils: Building fade transition for image viewing');
    debugPrint(
        '🎨 RouterUtils: Overlay background: ${themeManager.overlayBackground}');

    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Comprehensive error page builder showcasing all ThemeManager capabilities
  static Widget buildErrorPage(BuildContext context, GoRouterState state) {
    final themeManager = ThemeManager.of(context);

    // Comprehensive debug logging
    themeManager.logThemeInfo();
    themeManager.logGradientInfo();
    debugPrint('❌ RouterUtils: Building error page for route: ${state.uri}');
    debugPrint('❌ RouterUtils: Error details: ${state.error}');

    return Scaffold(
      // Use theme-aware background with gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: themeManager.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Error Icon Container with Glass Morphism
                Container(
                  width: 120,
                  height: 120,
                  decoration: themeManager.enhancedGlassMorphism.copyWith(
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: themeManager.elevatedShadow,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: themeManager.errorGradient,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: themeManager.primaryShadow,
                    ),
                    child: Icon(
                      Prbal.error,
                      size: 64,
                      color: themeManager.textInverted,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Main Error Title with Primary Gradient
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: themeManager.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: themeManager.primaryShadow,
                  ),
                  child: Text(
                    'Route Error',
                    style: themeManager.theme.textTheme.headlineSmall?.copyWith(
                      color: themeManager.textInverted,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // Error Details Card with Surface Gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: themeManager.surfaceGradient,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: themeManager.borderColor,
                      width: 1,
                    ),
                    boxShadow: themeManager.subtleShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: themeManager.errorColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Prbal.info4,
                              size: 16,
                              color: themeManager.textInverted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Error Details',
                            style: themeManager.theme.textTheme.titleMedium
                                ?.copyWith(
                              color: themeManager.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeManager.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: themeManager.borderSecondary),
                        ),
                        child: Text(
                          'Error: ${state.error}',
                          style:
                              themeManager.theme.textTheme.bodyMedium?.copyWith(
                            color: themeManager.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Status Indicators Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusIndicator(
                      themeManager,
                      'Route',
                      'Error',
                      themeManager.statusBusy,
                      Prbal.navigate,
                    ),
                    _buildStatusIndicator(
                      themeManager,
                      'System',
                      'Active',
                      themeManager.statusOnline,
                      Prbal.cog4,
                    ),
                    _buildStatusIndicator(
                      themeManager,
                      'Theme',
                      themeManager.themeManager ? 'Dark' : 'Light',
                      themeManager.infoColor,
                      themeManager.themeManager
                          ? Prbal.moonStroke
                          : Prbal.sunStroke,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Action Buttons with Different Gradients
                Column(
                  children: [
                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('🔄 RouterUtils: Go back button pressed');
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: themeManager.textInverted,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: themeManager.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: themeManager.primaryShadow,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Prbal.arrowLeft,
                                  size: 20,
                                  color: themeManager.textInverted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Go Back',
                                  style: themeManager.theme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: themeManager.textInverted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Secondary Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint(
                              '🏠 RouterUtils: Go to home button pressed');
                          context.go('/');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: themeManager.textPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: themeManager.borderColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeManager.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Prbal.home8,
                                size: 20,
                                color: themeManager.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Go to Home',
                                style: themeManager.theme.textTheme.labelLarge
                                    ?.copyWith(
                                  color: themeManager.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Debug Information with Neutral Gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: themeManager.neutralGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: themeManager.dividerColor),
                    boxShadow: themeManager.subtleShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: themeManager.warningColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Prbal.bug2,
                              size: 14,
                              color: themeManager.textInverted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Debug Information',
                            style: themeManager.theme.textTheme.labelMedium
                                ?.copyWith(
                              color: themeManager.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDebugRow(
                          themeManager, 'Route:', state.uri.toString()),
                      _buildDebugRow(themeManager, 'Theme Mode:',
                          themeManager.themeManager ? 'Dark' : 'Light'),
                      _buildDebugRow(themeManager, 'Primary Color:',
                          themeManager.primaryColor.toString()),
                      _buildDebugRow(themeManager, 'Background Color:',
                          themeManager.backgroundColor.toString()),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build status indicator with theme-aware styling
  static Widget _buildStatusIndicator(
    ThemeManager themeManager,
    String label,
    String value,
    Color statusColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeManager.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeManager.borderColor),
        boxShadow: themeManager.subtleShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: themeManager.theme.textTheme.labelSmall?.copyWith(
              color: themeManager.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: themeManager.theme.textTheme.labelMedium?.copyWith(
              color: themeManager.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build debug information row
  static Widget _buildDebugRow(
      ThemeManager themeManager, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              key,
              style: themeManager.theme.textTheme.bodySmall?.copyWith(
                color: themeManager.textQuaternary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: themeManager.theme.textTheme.bodySmall?.copyWith(
                color: themeManager.textTertiary,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced error page with animation showcase
  static Widget buildAnimatedErrorPage(
      BuildContext context, GoRouterState state) {
    final themeManager = ThemeManager.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeManager.backgroundGradient,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
          child: buildErrorPage(context, state),
        ),
      ),
    );
  }

  /// Glass morphism overlay for modals
  static Widget buildGlassOverlay(BuildContext context, Widget child) {
    final themeManager = ThemeManager.of(context);

    return Container(
      decoration: themeManager.glassMorphism,
      child: Container(
        decoration: BoxDecoration(
          gradient: themeManager.glassGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }

  /// Theme showcase for debugging
  static void logRouterThemeInfo(BuildContext context, String routeName) {
    final themeManager = ThemeManager.of(context);

    debugPrint('🛣️ RouterUtils Theme Info for route: $routeName');
    themeManager.logThemeInfo();
    debugPrint('🎨 Primary Color: ${themeManager.primaryColor}');
    debugPrint('🎨 Background Color: ${themeManager.backgroundColor}');
    debugPrint('🎨 Text Primary: ${themeManager.textPrimary}');
    debugPrint('🎨 Border Color: ${themeManager.borderColor}');
    debugPrint('🎨 Success Color: ${themeManager.successColor}');
    debugPrint('🎨 Error Color: ${themeManager.errorColor}');
  }
}
