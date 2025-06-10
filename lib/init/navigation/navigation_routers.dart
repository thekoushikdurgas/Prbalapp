import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/product/enum/route_enum.dart';
import 'package:prbal/init/navigation/router_utils.dart';
import 'package:prbal/init/navigation/routes/core_routes.dart';
import 'package:prbal/init/navigation/routes/auth_routes.dart';
import 'package:prbal/init/navigation/routes/main_navigation_routes.dart';
import 'package:prbal/init/navigation/routes/feature_routes.dart';
import 'package:prbal/init/navigation/router_guard.dart';
import 'package:prbal/services/auth_service.dart' as auth;

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
  final authService = ref.watch(auth.authServiceProvider.notifier);

  return GoRouter(
    initialLocation: RouteEnum.splash.rawValue,
    debugLogDiagnostics: true,
    redirect: (context, state) =>
        RouterGuard.redirect(context, state, authService),
    routes: [
      ...CoreRoutes.routes,
      ...AuthRoutes.routes,
      ...MainNavigationRoutes.routes,
      ...FeatureRoutes.routes,
    ],
    errorBuilder: RouterUtils.buildErrorPage,
  );
});
