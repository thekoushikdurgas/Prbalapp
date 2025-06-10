import 'package:go_router/go_router.dart';
import 'package:prbal/product/enum/route_enum.dart';
import 'package:prbal/view/splash/splash_screen.dart';
import 'package:prbal/view/introduction/view/introduction_screen.dart';
import 'package:prbal/view/welcome/view/welcome_screen.dart';

/// Core application routes (splash, onboarding, welcome)
class CoreRoutes {
  const CoreRoutes._();

  static List<RouteBase> routes = [
    GoRoute(
      path: RouteEnum.splash.rawValue,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteEnum.onboarding.rawValue,
      builder: (context, state) => const IntroductionScreen(),
    ),
    GoRoute(
      path: RouteEnum.welcome.rawValue,
      builder: (context, state) => const WelcomeScreen(),
    ),
  ];
}
