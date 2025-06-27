import 'package:go_router/go_router.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/screens/init/language_selection_screen.dart';
import 'package:prbal/screens/common/bottom_navigation.dart';

/// Main navigation routes (home, explore, orders, settings)
class MainNavigationRoutes {
  const MainNavigationRoutes._();

  static List<RouteBase> routes = [
    GoRoute(
      path: RouteEnum.home.rawValue,
      builder: (context, state) => const BottomNavigation(initialIndex: 0),
    ),
    GoRoute(
      path: RouteEnum.orders.rawValue,
      builder: (context, state) {
        // Get the tab index from query parameters, default to 0 if not provided
        final tabIndex =
            int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
        return BottomNavigation(
            initialIndex: 2, extra: {'initialTabIndex': tabIndex});
      },
    ),
    GoRoute(
      path: RouteEnum.settings.rawValue,
      builder: (context, state) => const BottomNavigation(initialIndex: 3),
    ),
    GoRoute(
      path: RouteEnum.languageSelection.rawValue,
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
  ];
}
