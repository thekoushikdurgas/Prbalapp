import 'package:prbal/utils/cubit/theme_cubit.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:prbal/utils/theme/theme_caching.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Debug logging for theme system initialization
    debugPrint('🎨 MyApp: Building app with comprehensive theme system');
    debugPrint('🎨 MyApp: Initial theme mode: ${ThemeCaching.initialTheme()}');
    debugPrint('🎨 MyApp: Initial radio state: ${ThemeCaching.initialRadio()}');

    return ScreenUtilInit(
      // designSize: const Size(375, 812), // iPhone 11 Pro design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeState) {
            // Enhanced debug logging with theme state tracking
            debugPrint('🎨 MyApp: Current theme state: $themeState');
            debugPrint(
                '🎨 MyApp: Building MaterialApp with ThemeManager integration');

            // Log theme caching state
            debugPrint(
                '🎨 ThemeCaching: Current cached theme: ${ThemeCaching.initialTheme()}');

            return MaterialApp.router(
              title: 'Prbal',
              // Localization configuration
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,

              // Theme configuration with ThemeManager-compatible themes
              theme: ThemeManager.lightTheme,
              darkTheme: ThemeManager.darkTheme,
              themeMode: themeState,

              // Navigation configuration
              routerConfig: NavigationRoute.router,

              // Debug configuration
              debugShowCheckedModeBanner: false,

              // App configuration
              builder: (context, child) {
                // Initialize ThemeManager for the app context
                if (child != null) {
                  final themeManager = ThemeManager.of(context);

                  // Comprehensive theme and typography logging on app initialization
                  themeManager.logThemeInfo();
                  themeManager.logTypographyInfo();
                  debugPrint('🎨 MyApp: ThemeManager initialized successfully');
                  debugPrint(
                      '🎨 MyApp: Current brightness: ${Theme.of(context).brightness}');
                  debugPrint(
                      '🎨 MyApp: Primary color: ${themeManager.primaryColor}');
                  debugPrint(
                      '🎨 MyApp: Background color: ${themeManager.backgroundColor}');
                  debugPrint(
                      '🎨 MyApp: Text primary color: ${themeManager.textPrimary}');
                  debugPrint(
                      '🔤 MyApp: SourGummy fonts successfully integrated');
                }

                return child ?? const SizedBox.shrink();
              },
            );
          },
        );
      },
    );
  }
}
