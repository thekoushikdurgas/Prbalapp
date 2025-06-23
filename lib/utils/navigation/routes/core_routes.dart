import 'package:go_router/go_router.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/screens/init/splash_screen.dart';
import 'package:prbal/screens/init/introduction_screen.dart';
import 'package:prbal/screens/auth/welcome_screen.dart';

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
      path: RouteEnum.intro.rawValue,
      builder: (context, state) => const IntroductionScreen(),
    ),
    GoRoute(
      path: RouteEnum.welcome.rawValue,
      builder: (context, state) => const WelcomeScreen(),
    ),
  ];
}
