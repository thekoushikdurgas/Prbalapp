import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:prbal/services/api_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/navigation/router_utils.dart';
import 'package:prbal/utils/navigation/routes/core_routes.dart';
import 'package:prbal/utils/navigation/routes/auth_routes.dart';
import 'package:prbal/utils/navigation/routes/main_navigation_routes.dart';
import 'package:prbal/utils/navigation/routes/feature_routes.dart';
import 'package:prbal/utils/navigation/router_guard.dart';
// import 'package:prbal/services/user_service.dart';

/// Main router configuration combining all route modules
class NavigationRouters {
  const NavigationRouters._();

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
}

/// Provider for the new modular router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteEnum.splash.rawValue,
    debugLogDiagnostics: true,
    redirect: (context, state) => RouterGuard.redirect(context, state),
    routes: [
      ...CoreRoutes.routes,
      ...AuthRoutes.routes,
      ...MainNavigationRoutes.routes,
      ...FeatureRoutes.routes,
    ],
    errorBuilder: RouterUtils.buildErrorPage,
  );
});
