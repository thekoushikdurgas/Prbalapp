import 'package:go_router/go_router.dart';
import 'package:prbal/models/auth/app_user.dart';
import 'package:prbal/screens/auth/pin_verification_screen.dart';
// import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';

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
          userData: extra?['userData'] as AppUser,
        );
      },
    ),
  ];
}
