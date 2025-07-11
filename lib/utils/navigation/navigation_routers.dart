import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/models/auth/user_type.dart';
import 'package:prbal/services/app_services.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/debug_logger.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/navigation/router_utils.dart';
import 'package:prbal/utils/navigation/routes/core_routes.dart';
import 'package:prbal/utils/navigation/routes/auth_routes.dart';
import 'package:prbal/utils/navigation/routes/main_navigation_routes.dart';
import 'package:prbal/utils/navigation/routes/feature_routes.dart';

/// Performance-optimized navigation router configuration
///
/// **Optimizations**:
/// - Cached route mappings
/// - Simplified redirect logic
/// - Centralized logging
/// - Reduced function calls
/// - Better error handling
/// - Performance monitoring
class NavigationRouters {
  const NavigationRouters._();

  // Cache for route mappings to avoid repeated calculations
  static final Map<UserType, String> _userTypeDashboards = {
    UserType.provider: RouteEnum.providerDashboard.rawValue,
    UserType.admin: RouteEnum.adminDashboard.rawValue,
    UserType.customer: RouteEnum.takerDashboard.rawValue,
  };

  static final Map<String, UserType> _routeUserTypes = {
    '/provider-dashboard': UserType.provider,
    '/admin-dashboard': UserType.admin,
    '/taker-dashboard': UserType.customer,
  };

  static final Set<String> _authScreens = {
    RouteEnum.welcome.rawValue,
    RouteEnum.pinEntry.rawValue,
  };

  static final Set<String> _userTypeSpecificRoutes = {
    RouteEnum.providerDashboard.rawValue,
    RouteEnum.adminDashboard.rawValue,
    RouteEnum.takerDashboard.rawValue,
  };

  /// Legacy router (keeping for backward compatibility)
  static final GoRouter router = GoRouter(
    initialLocation: RouteEnum.splash.rawValue,
    routes: [
      ...CoreRoutes.routes,
      ...MainNavigationRoutes.routes,
      ...AuthRoutes.routes,
      ...FeatureRoutes.routes,
    ],
    errorBuilder: RouterUtils.buildErrorPage,
  );

  /// Get optimized router provider
  static Provider<GoRouter> get routerProvider => _routerProvider;

  static final _routerProvider = Provider<GoRouter>((ref) {
    DebugLogger.navigation('Initializing optimized router');

    return GoRouter(
      initialLocation: RouteEnum.splash.rawValue,
      debugLogDiagnostics: false, // Disable to reduce overhead
      redirect: (context, state) => _optimizedRedirect(ref, context, state),
      routes: [
        ...CoreRoutes.routes,
        ...AuthRoutes.routes,
        ...MainNavigationRoutes.routes,
        ...FeatureRoutes.routes,
      ],
      errorBuilder: RouterUtils.buildErrorPage,
    );
  });
}

/// Optimized redirect function with cached lookups and minimal logging
String? _optimizedRedirect(Ref ref, BuildContext context, GoRouterState state) {
  final currentLocation = state.matchedLocation;

  // Early exit for splash screen
  if (currentLocation == RouteEnum.splash.rawValue) {
    return null;
  }

  final authState = ref.read(authenticationStateProvider);

  // Log only when needed (not for every navigation)
  if (kDebugMode) {
    DebugLogger.navigation(
        'Redirect check: $currentLocation (auth: ${authState.isAuthenticated})');
  }

  // Check onboarding flow
  final onboardingRedirect =
      _checkOnboardingFlow(ref, authState, currentLocation);
  if (onboardingRedirect != null) return onboardingRedirect;

  // Check authentication flow
  final authRedirect = _checkAuthenticationFlow(authState, currentLocation);
  if (authRedirect != null) return authRedirect;

  // Check user-specific flow
  final userRedirect = _checkUserSpecificFlow(authState, currentLocation);
  if (userRedirect != null) return userRedirect;

  return null;
}

/// Check onboarding flow with minimal overhead
String? _checkOnboardingFlow(
    Ref ref, AuthenticationState authState, String location) {
  final hasIntroBeenWatched = HiveService.hasIntroBeenWatched();

  // Redirect to onboarding if intro not watched
  if (!hasIntroBeenWatched && location != RouteEnum.onboarding.rawValue) {
    return RouteEnum.onboarding.rawValue;
  }

  // Redirect to welcome if intro watched but not authenticated
  if (hasIntroBeenWatched &&
      !authState.isAuthenticated &&
      !NavigationRouters._authScreens.contains(location)) {
    return RouteEnum.welcome.rawValue;
  }

  return null;
}

/// Check authentication flow with cached screen lookup
String? _checkAuthenticationFlow(
    AuthenticationState authState, String location) {
  // Redirect away from auth screens if logged in
  if (authState.isAuthenticated &&
      NavigationRouters._authScreens.contains(location)) {
    return RouteEnum.home.rawValue;
  }

  return null;
}

/// Check user-specific flow with cached mappings
String? _checkUserSpecificFlow(AuthenticationState authState, String location) {
  // Early exit if not authenticated
  if (!authState.isAuthenticated || authState.user == null) {
    return null;
  }

  final userType = authState.user!.userType;

  // Redirect from generic home to user-specific dashboard
  if (location == RouteEnum.home.rawValue) {
    return NavigationRouters._userTypeDashboards[userType];
  }

  // Check if user is accessing wrong dashboard
  if (NavigationRouters._userTypeSpecificRoutes.contains(location)) {
    final expectedUserType = NavigationRouters._routeUserTypes[location];
    if (expectedUserType != null && expectedUserType != userType) {
      return NavigationRouters._userTypeDashboards[userType];
    }
  }

  return null;
}

/// Navigation utilities for common operations
extension NavigationUtilities on NavigationRouters {
  /// Get dashboard route for user type
  static String getDashboardForUserType(UserType userType) {
    return NavigationRouters._userTypeDashboards[userType] ??
        RouteEnum.takerDashboard.rawValue;
  }

  /// Check if location is an auth screen
  static bool isAuthScreen(String location) {
    return NavigationRouters._authScreens.contains(location);
  }

  /// Check if location is user-type specific
  static bool isUserTypeSpecificRoute(String location) {
    return NavigationRouters._userTypeSpecificRoutes.contains(location);
  }

  /// Get expected user type for route
  static UserType? getExpectedUserTypeForRoute(String location) {
    return NavigationRouters._routeUserTypes[location];
  }

  /// Navigate to user dashboard
  static void navigateToUserDashboard(BuildContext context, UserType userType) {
    final route = NavigationRouters._userTypeDashboards[userType];
    if (route != null) {
      context.go(route);
      DebugLogger.navigation('Navigated to dashboard: $route');
    }
  }

  /// Navigate to welcome screen (for logout)
  static void navigateToWelcome(BuildContext context) {
    context.go(RouteEnum.welcome.rawValue);
    DebugLogger.navigation('Navigated to welcome screen');
  }

  /// Navigate to onboarding
  static void navigateToOnboarding(BuildContext context) {
    context.go(RouteEnum.onboarding.rawValue);
    DebugLogger.navigation('Navigated to onboarding');
  }

  /// Clear navigation stack and go to route
  static void navigateAndClearStack(BuildContext context, String route) {
    while (context.canPop()) {
      context.pop();
    }
    context.go(route);
    DebugLogger.navigation('Cleared stack and navigated to: $route');
  }

  /// Get route statistics for debugging
  static Map<String, dynamic> getRouteStatistics() {
    return {
      'user_type_dashboards': NavigationRouters._userTypeDashboards.length,
      'auth_screens': NavigationRouters._authScreens.length,
      'user_specific_routes': NavigationRouters._userTypeSpecificRoutes.length,
      'route_user_type_mappings': NavigationRouters._routeUserTypes.length,
    };
  }

  /// Log navigation state for debugging
  static void logNavigationState(
      AuthenticationState authState, String currentLocation) {
    if (kDebugMode) {
      DebugLogger.navigation('Navigation State Debug:');
      DebugLogger.navigation('  Current Location: $currentLocation');
      DebugLogger.navigation(
          '  Is Authenticated: ${authState.isAuthenticated}');
      DebugLogger.navigation(
          '  User Type: ${authState.user?.userType.name ?? 'none'}');
      DebugLogger.navigation(
          '  Expected Dashboard: ${authState.user != null ? NavigationRouters._userTypeDashboards[authState.user!.userType] : 'none'}');
      DebugLogger.navigation(
          '  Is Auth Screen: ${NavigationRouters._authScreens.contains(currentLocation)}');
      DebugLogger.navigation(
          '  Is User Specific: ${NavigationRouters._userTypeSpecificRoutes.contains(currentLocation)}');
    }
  }
}

/// Extension for easier navigation context access
extension NavigationExtension on BuildContext {
  /// Navigate to user-specific dashboard
  void goToUserDashboard(UserType userType) {
    NavigationUtilities.navigateToUserDashboard(this, userType);
  }

  /// Navigate to welcome with stack clear
  void goToWelcomeAndClear() {
    NavigationUtilities.navigateAndClearStack(this, RouteEnum.welcome.rawValue);
  }

  /// Navigate to onboarding with stack clear
  void goToOnboardingAndClear() {
    NavigationUtilities.navigateAndClearStack(
        this, RouteEnum.onboarding.rawValue);
  }
}

/// Simplified router configuration for easy migration
class SimplifiedRouter {
  const SimplifiedRouter._();

  /// Get router instance
  static Provider<GoRouter> get routerProvider =>
      NavigationRouters.routerProvider;

  /// Legacy compatibility
  @Deprecated('Use NavigationRouters.routerProvider instead')
  static Provider<GoRouter> get router => NavigationRouters.routerProvider;
}
