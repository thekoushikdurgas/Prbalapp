import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/services/hive_service.dart';

class IntroCaching {
  const IntroCaching._();

  static Future<void> init() async {
    // HiveService handles the initialization now
    // This method is kept for backward compatibility
  }

  static String initialIntro() {
    // Use HiveService instead of direct Hive access
    return HiveService.hasIntroBeenWatched()
        ? RouteEnum.welcome.rawValue
        : RouteEnum.onboarding.rawValue;
  }

  static Future<void> watchIntro() async {
    // Use HiveService for consistency
    await HiveService.setIntroWatched();
  }
}
