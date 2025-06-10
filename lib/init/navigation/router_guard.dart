import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/product/enum/route_enum.dart';
import 'package:prbal/services/auth_service.dart' as auth;
import 'package:prbal/services/hive_service.dart';

/// Router guard for handling redirects and authentication
class RouterGuard {
  const RouterGuard._();

  /// Main redirect function
  static String? redirect(
    BuildContext context,
    GoRouterState state,
    auth.AuthService authService,
  ) {
    // If we're on the splash screen, don't redirect
    if (state.matchedLocation == RouteEnum.splash.rawValue) {
      return null;
    }

    return _handleAuthenticationFlow(state, authService) ??
        _handleOnboardingFlow(state) ??
        _handleAuthenticatedUserFlow(state, authService);
  }

  /// Handle authentication-related redirects
  static String? _handleAuthenticationFlow(
    GoRouterState state,
    auth.AuthService authService,
  ) {
    final isAuthenticated = authService.currentUser != null;
    final isLoggedIn = HiveService.isLoggedIn();

    // If user is logged in and authenticated, redirect away from auth screens
    if (isLoggedIn && isAuthenticated && _isAuthScreen(state.matchedLocation)) {
      return RouteEnum.home.rawValue;
    }

    return null;
  }

  /// Handle onboarding flow redirects
  static String? _handleOnboardingFlow(GoRouterState state) {
    final hasIntroBeenWatched = HiveService.hasIntroBeenWatched();
    final isLoggedIn = HiveService.isLoggedIn();

    // If intro hasn't been watched, redirect to onboarding
    if (!hasIntroBeenWatched &&
        state.matchedLocation != RouteEnum.onboarding.rawValue) {
      return RouteEnum.onboarding.rawValue;
    }

    // If intro has been watched but user is not logged in, redirect to welcome
    if (hasIntroBeenWatched &&
        !isLoggedIn &&
        !_isAuthScreen(state.matchedLocation)) {
      return RouteEnum.welcome.rawValue;
    }

    return null;
  }

  /// Handle authenticated user flow
  static String? _handleAuthenticatedUserFlow(
    GoRouterState state,
    auth.AuthService authService,
  ) {
    // Add any additional authenticated user redirects here
    return null;
  }

  /// Check if the current location is an authentication screen
  static bool _isAuthScreen(String location) {
    return location == RouteEnum.welcome.rawValue ||
        location == RouteEnum.pinEntry.rawValue;
  }

  /// Check if user needs onboarding
  static bool needsOnboarding() {
    return !HiveService.hasIntroBeenWatched();
  }

  /// Check if user is fully authenticated
  static bool isFullyAuthenticated(auth.AuthService authService) {
    return authService.currentUser != null && HiveService.isLoggedIn();
  }
}
