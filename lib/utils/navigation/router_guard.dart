import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/services/hive_service.dart';

/// Router guard for handling redirects and authentication
class RouterGuard {
  const RouterGuard._();

  /// Main redirect function
  static String? redirect(
    BuildContext context,
    GoRouterState state,
  ) {
    // If we're on the splash screen, don't redirect
    if (state.matchedLocation == RouteEnum.splash.rawValue) {
      return null;
    }

    return _handleAuthenticationFlow(state) ?? _handleOnboardingFlow(state) ?? _handleAuthenticatedUserFlow(state);
  }

  /// Handle authentication-related redirects
  static String? _handleAuthenticationFlow(GoRouterState state) {
    final isLoggedIn = HiveService.isLoggedIn();

    // If user is logged in, redirect away from auth screens
    if (isLoggedIn && _isAuthScreen(state.matchedLocation)) {
      return RouteEnum.home.rawValue;
    }

    return null;
  }

  /// Handle onboarding flow redirects
  static String? _handleOnboardingFlow(GoRouterState state) {
    final hasIntroBeenWatched = HiveService.hasIntroBeenWatched();
    final isLoggedIn = HiveService.isLoggedIn();

    // If intro hasn't been watched, redirect to onboarding
    if (!hasIntroBeenWatched && state.matchedLocation != RouteEnum.onboarding.rawValue) {
      return RouteEnum.onboarding.rawValue;
    }

    // If intro has been watched but user is not logged in, redirect to welcome
    if (hasIntroBeenWatched && !isLoggedIn && !_isAuthScreen(state.matchedLocation)) {
      return RouteEnum.welcome.rawValue;
    }

    return null;
  }

  /// Handle authenticated user flow
  static String? _handleAuthenticatedUserFlow(GoRouterState state) {
    final isLoggedIn = HiveService.isLoggedIn();

    // Only handle redirects for logged in users
    if (!isLoggedIn) {
      return null;
    }

    // Get user type from Hive for type-specific redirects
    final UserType userType = HiveService.getUserType();

    // If user is on a generic home route, redirect to their specific dashboard
    if (state.matchedLocation == RouteEnum.home.rawValue) {
      switch (userType) {
        case UserType.provider:
          return RouteEnum.providerDashboard.rawValue;
        case UserType.admin:
          return RouteEnum.adminDashboard.rawValue;
        case UserType.customer:
          return RouteEnum.takerDashboard.rawValue;
      }
    }

    // Prevent wrong user types from accessing specific dashboards
    if (_isUserTypeSpecificRoute(state.matchedLocation)) {
      final UserType expectedUserType = _getExpectedUserTypeForRoute(state.matchedLocation);
      if (expectedUserType != userType) {
        // Redirect to correct dashboard for their user type
        switch (userType) {
          case UserType.provider:
            return RouteEnum.providerDashboard.rawValue;
          case UserType.admin:
            return RouteEnum.adminDashboard.rawValue;
          case UserType.customer:
            return RouteEnum.takerDashboard.rawValue;
        }
      }
    }

    return null;
  }

  /// Check if the current location is an authentication screen
  static bool _isAuthScreen(String location) {
    return location == RouteEnum.welcome.rawValue || location == RouteEnum.pinEntry.rawValue;
  }

  /// Check if the route is user-type specific
  static bool _isUserTypeSpecificRoute(String location) {
    return location == RouteEnum.providerDashboard.rawValue ||
        location == RouteEnum.adminDashboard.rawValue ||
        location == RouteEnum.takerDashboard.rawValue;
  }

  /// Get expected user type for a specific route
  static UserType _getExpectedUserTypeForRoute(String location) {
    switch (location) {
      case '/provider-dashboard':
        return UserType.provider;
      case '/admin-dashboard':
        return UserType.admin;
      case '/taker-dashboard':
        return UserType.customer;
      default:
        return UserType.customer;
    }
  }

  /// Check if user needs onboarding
  static bool needsOnboarding() {
    return !HiveService.hasIntroBeenWatched();
  }

  /// Check if user is fully authenticated
  static bool isFullyAuthenticated() {
    return HiveService.isLoggedIn();
  }

  /// Get appropriate dashboard route for user type
  static String getDashboardRouteForUserType() {
    final UserType userType = HiveService.getUserType();
    switch (userType) {
      case UserType.provider:
        return RouteEnum.providerDashboard.rawValue;
      case UserType.admin:
        return RouteEnum.adminDashboard.rawValue;
      case UserType.customer:
        return RouteEnum.takerDashboard.rawValue;
    }
  }

  /// Check if user has permission to access a route based on user type
  static bool hasPermissionForRoute(String route) {
    final UserType userType = HiveService.getUserType();

    // Admin users can access all routes
    if (userType == UserType.admin) {
      return true;
    }

    // Provider-specific routes
    if (route.contains('provider') || route.contains('add-service')) {
      return userType == UserType.provider;
    }

    // Admin-specific routes
    if (route.contains('admin')) {
      return userType == UserType.admin;
    }

    // Customer/taker routes are accessible by default
    return true;
  }
}
