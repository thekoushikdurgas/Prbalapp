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
    // Log theme information for debugging

    debugPrint('🚀 RouterUtils: Building page transition for ${state.uri}');
    debugPrint(
        '🎨 RouterUtils: Using ${ThemeManager.of(context).themeManager ? 'dark' : 'light'} theme');

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
    debugPrint('🖼️ RouterUtils: Building fade transition for image viewing');
    debugPrint(
        '🎨 RouterUtils: Overlay background: ${ThemeManager.of(context).overlayBackground}');

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
    // Comprehensive debug logging

    ThemeManager.of(context).logGradientInfo();
    debugPrint('❌ RouterUtils: Building error page for route: ${state.uri}');
    debugPrint('❌ RouterUtils: Error details: ${state.error}');

    return Scaffold(
      // Use theme-aware background with gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).backgroundGradient,
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
                  decoration:
                      ThemeManager.of(context).enhancedGlassMorphism.copyWith(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: ThemeManager.of(context).elevatedShadow,
                          ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: ThemeManager.of(context).errorGradient,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: ThemeManager.of(context).primaryShadow,
                    ),
                    child: Icon(
                      Prbal.error,
                      size: 64,
                      color: ThemeManager.of(context).textInverted,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Main Error Title with Primary Gradient
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: ThemeManager.of(context).primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: ThemeManager.of(context).primaryShadow,
                  ),
                  child: Text(
                    'Route Error',
                    style: ThemeManager.of(context)
                        .theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          color: ThemeManager.of(context).textInverted,
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
                    gradient: ThemeManager.of(context).surfaceGradient,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ThemeManager.of(context).borderColor,
                      width: 1,
                    ),
                    boxShadow: ThemeManager.of(context).subtleShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ThemeManager.of(context).errorColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Prbal.info4,
                              size: 16,
                              color: ThemeManager.of(context).textInverted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Error Details',
                            style: ThemeManager.of(context)
                                .theme
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: ThemeManager.of(context).textPrimary,
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
                          color: ThemeManager.of(context).cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: ThemeManager.of(context).borderSecondary),
                        ),
                        child: Text(
                          'Error: ${state.error}',
                          style: ThemeManager.of(context)
                              .theme
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: ThemeManager.of(context).textSecondary,
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
                      'Route',
                      'Error',
                      ThemeManager.of(context).statusBusy,
                      Prbal.navigate,
                      ThemeManager.of(context),
                    ),
                    _buildStatusIndicator(
                      'System',
                      'Active',
                      ThemeManager.of(context).statusOnline,
                      Prbal.cog4,
                      ThemeManager.of(context),
                    ),
                    _buildStatusIndicator(
                      'Theme',
                      ThemeManager.of(context).themeManager ? 'Dark' : 'Light',
                      ThemeManager.of(context).infoColor,
                      ThemeManager.of(context).themeManager
                          ? Prbal.moonStroke
                          : Prbal.sunStroke,
                      ThemeManager.of(context),
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
                          foregroundColor:
                              ThemeManager.of(context).textInverted,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: ThemeManager.of(context).primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: ThemeManager.of(context).primaryShadow,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Prbal.arrowLeft,
                                  size: 20,
                                  color: ThemeManager.of(context).textInverted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Go Back',
                                  style: ThemeManager.of(context)
                                      .theme
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: ThemeManager.of(context)
                                            .textInverted,
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
                          foregroundColor: ThemeManager.of(context).textPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: ThemeManager.of(context).borderColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeManager.of(context).surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Prbal.home8,
                                size: 20,
                                color: ThemeManager.of(context).textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Go to Home',
                                style: ThemeManager.of(context)
                                    .theme
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: ThemeManager.of(context)
                                          .textSecondary,
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
                    gradient: ThemeManager.of(context).neutralGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: ThemeManager.of(context).dividerColor),
                    boxShadow: ThemeManager.of(context).subtleShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: ThemeManager.of(context).warningColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Prbal.bug2,
                              size: 14,
                              color: ThemeManager.of(context).textInverted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Debug Information',
                            style: ThemeManager.of(context)
                                .theme
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: ThemeManager.of(context).textTertiary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDebugRow('Route:', state.uri.toString(),
                          ThemeManager.of(context)),
                      _buildDebugRow(
                          'Theme Mode:',
                          ThemeManager.of(context).themeManager
                              ? 'Dark'
                              : 'Light',
                          ThemeManager.of(context)),
                      _buildDebugRow(
                          'Primary Color:',
                          ThemeManager.of(context).primaryColor.toString(),
                          ThemeManager.of(context)),
                      _buildDebugRow(
                          'Background Color:',
                          ThemeManager.of(context).backgroundColor.toString(),
                          ThemeManager.of(context)),
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
    String label,
    String value,
    Color statusColor,
    IconData icon,
    ThemeManager themeManager,
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
      String key, String value, ThemeManager themeManager) {
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
                fontFamily: ThemeManager.fontFamilySemiExpanded,
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).backgroundGradient,
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
    return Container(
      decoration: ThemeManager.of(context).glassMorphism,
      child: Container(
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).glassGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }

  /// Theme showcase for debugging
  static void logRouterThemeInfo(BuildContext context, String routeName) {
    debugPrint('🛣️ RouterUtils Theme Info for route: $routeName');

    debugPrint('🎨 Primary Color: ${ThemeManager.of(context).primaryColor}');
    debugPrint(
        '🎨 Background Color: ${ThemeManager.of(context).backgroundColor}');
    debugPrint('🎨 Text Primary: ${ThemeManager.of(context).textPrimary}');
    debugPrint('🎨 Border Color: ${ThemeManager.of(context).borderColor}');
    debugPrint('🎨 Success Color: ${ThemeManager.of(context).successColor}');
    debugPrint('🎨 Error Color: ${ThemeManager.of(context).errorColor}');
  }
}
