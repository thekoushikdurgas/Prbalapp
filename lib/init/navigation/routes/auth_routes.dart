import 'package:go_router/go_router.dart';
import 'package:prbal/view/auth/pin_verification_screen.dart';
import 'package:prbal/product/enum/route_enum.dart';

/// Authentication related routes
class AuthRoutes {
  const AuthRoutes._();

  static List<RouteBase> routes = [
    // PIN verification screen
    GoRoute(
      path: RouteEnum.pinEntry.rawValue,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PinVerificationScreen(
          phoneNumber: extra?['phoneNumber'] as String? ?? '',
          isNewUser: extra?['isNewUser'] as bool? ?? false,
          userData: extra?['userData'] as Map<String, dynamic>?,
        );
      },
    ),
  ];
}
