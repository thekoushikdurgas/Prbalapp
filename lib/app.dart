import 'package:prbal/utils/cubit/theme_cubit.dart';
import 'package:prbal/utils/navigation/navigation_routers.dart';
import 'package:prbal/utils/theme/theme_caching.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/services/app_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Debug logging for theme system initialization
    debugPrint('🎨 MyApp: Building app with comprehensive theme system');
    debugPrint('🎨 MyApp: Initial theme mode: ${ThemeCaching.initialTheme()}');
    debugPrint('🎨 MyApp: Initial radio state: ${ThemeCaching.initialRadio()}');

    // Watch authentication state for debugging and monitoring
    final authState = ref.watch(authenticationStateProvider);
    debugPrint(
        '🔐 MyApp: Authentication state - isAuthenticated: ${authState.isAuthenticated}');
    debugPrint('🔐 MyApp: User: ${authState.user?.displayName ?? 'none'}');
    debugPrint('🔐 MyApp: Has tokens: ${authState.tokens != null}');

    // Watch current user for additional debugging
    final currentUser = ref.watch(currentUserProvider);
    final userType = ref.watch(userTypeProvider);
    debugPrint('🔐 MyApp: Current user type: ${userType.name}');
    debugPrint(
        '🔐 MyApp: Current user display name: ${currentUser?.displayName ?? 'none'}');

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

              // Navigation configuration with authentication state integration
              routerConfig: ref.watch(NavigationRouters.routerProvider),

              // Debug configuration
              debugShowCheckedModeBanner: false,

              // App configuration
              builder: (context, child) {
                // Initialize ThemeManager for the app context
                if (child != null) {
                  // Comprehensive theme and typography logging on app initialization
                  ThemeManager.of(context).logThemeInfo();
                  ThemeManager.of(context).logTypographyInfo();
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
