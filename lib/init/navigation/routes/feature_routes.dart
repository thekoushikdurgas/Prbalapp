import 'package:go_router/go_router.dart';
import 'package:prbal/view/health/health_dashboard.dart';
import 'package:prbal/init/navigation/router_utils.dart';
// TODO: Add imports for feature screens when available
// import 'package:prbal/screens/main/messages_screen.dart';
// import 'package:prbal/screens/main/payments_screen.dart';
// import 'package:prbal/screens/main/booking_details_screen.dart';
// import 'package:prbal/screens/main/service_details_screen.dart';
// import 'package:prbal/screens/main/full_screen_image_screen.dart';

/// Feature routes (chat, payments, bookings, etc.)
class FeatureRoutes {
  const FeatureRoutes._();

  static List<RouteBase> routes = [
    // Health Dashboard route
    GoRoute(
      path: '/health',
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const HealthDashboard(),
      ),
    ),

    // TODO: Uncomment when feature screens are available

    // Chat routes
    // GoRoute(
    //   path: RouteEnum.chatList.rawValue,
    //   pageBuilder: (context, state) => RouterUtils.buildPageTransition(
    //     context: context,
    //     state: state,
    //     child: const MessagesScreen(),
    //   ),
    // ),

    // GoRoute(
    //   path: RouteEnum.messages.rawValue,
    //   builder: (context, state) => const MessagesScreen(),
    // ),

    // GoRoute(
    //   path: RouteEnum.chat.rawValue,
    //   pageBuilder: (context, state) {
    //     final chatId = state.pathParameters['chatId'] ?? '';
    //     final extra = state.extra as Map<String, dynamic>?;

    //     return RouterUtils.buildPageTransition(
    //       context: context,
    //       state: state,
    //       child: MessagesScreen(
    //         initialChatId: chatId,
    //         conversationName: extra?['conversationName'] as String? ?? 'Chat',
    //         avatarUrl: extra?['avatarUrl'] as String?,
    //       ),
    //     );
    //   },
    // ),

    // GoRoute(
    //   path: RouteEnum.directChat.rawValue,
    //   pageBuilder: (context, state) {
    //     final userId = state.pathParameters['userId'] ?? '';
    //     final extra = state.extra as Map<String, dynamic>?;

    //     return RouterUtils.buildPageTransition(
    //       context: context,
    //       state: state,
    //       child: MessagesScreen(
    //         initialUserId: userId,
    //         conversationName: extra?['userName'] as String? ?? 'Chat',
    //         avatarUrl: extra?['avatarUrl'] as String?,
    //         isNewConversation: true,
    //       ),
    //     );
    //   },
    // ),

    // Payment routes
    // GoRoute(
    //   path: RouteEnum.payments.rawValue,
    //   builder: (context, state) => const PaymentsScreen(),
    // ),

    // Booking routes
    // GoRoute(
    //   path: RouteEnum.bookingDetails.rawValue,
    //   builder: (context, state) {
    //     final bookingId = state.pathParameters['id'] ?? '';
    //     return BookingDetailsScreen(bookingId: bookingId);
    //   },
    // ),

    // GoRoute(
    //   path: RouteEnum.serviceDetails.rawValue,
    //   builder: (context, state) {
    //     final serviceId = state.pathParameters['id'] ?? '';
    //     return ServiceDetailsScreen(serviceId: serviceId);
    //   },
    // ),

    // Image viewing route
    // GoRoute(
    //   path: RouteEnum.fullScreenImage.rawValue,
    //   pageBuilder: (context, state) {
    //     final extra = state.extra as Map<String, dynamic>?;
    //     final imageUrl = extra?['imageUrl'] as String? ?? '';
    //     final heroTag = extra?['heroTag'] as String? ?? 'profile-picture';

    //     return RouterUtils.buildFadeTransition(
    //       context: context,
    //       state: state,
    //       child: FullScreenImageScreen(
    //         imageUrl: imageUrl,
    //         heroTag: heroTag,
    //       ),
    //     );
    //   },
    // ),
  ];
}
