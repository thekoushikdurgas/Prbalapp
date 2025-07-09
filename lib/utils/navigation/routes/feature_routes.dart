import 'package:go_router/go_router.dart';
import 'package:prbal/screens/admin/admin_activity_screen.dart';
import 'package:prbal/screens/admin/health_dashboard.dart';
import 'package:prbal/utils/navigation/router_utils.dart';
import 'package:prbal/screens/main/messages_screen.dart';
import 'package:prbal/screens/main/payments_screen.dart';
import 'package:prbal/screens/common/booking_details_screen.dart';
import 'package:prbal/screens/main/service_details_screen.dart';
import 'package:prbal/screens/common/full_screen_image_screen.dart';
// import 'package:prbal/screens/settings/settings_screen.dart';
// import 'package:prbal/screens/provider/provider_dashboard.dart';
// import 'package:prbal/screens/provider/provider_explore_screen.dart';
// import 'package:prbal/screens/provider/provider_orders_screen.dart';
import 'package:prbal/screens/main/schedule_screen.dart';
import 'package:prbal/screens/settings/profile_screen.dart';
// import 'package:prbal/screens/admin/admin_dashboard.dart';
// import 'package:prbal/screens/admin/admin_users_screen.dart';
// import 'package:prbal/screens/taker/taker_dashboard.dart';
// import 'package:prbal/screens/taker/taker_explore_screen.dart';
// import 'package:prbal/screens/taker/taker_orders_screen.dart';
import 'package:prbal/screens/common/add_service_screen.dart';
import 'package:prbal/screens/common/post_request_screen.dart';
import 'package:prbal/screens/common/notifications_screen.dart';
import 'package:prbal/screens/common/bottom_navigation.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
// Admin management screen imports
import 'package:prbal/screens/admin/admin_category_manager_screen.dart';
import 'package:prbal/screens/admin/admin_subcategory_manager_screen.dart';
import 'package:prbal/screens/admin/admin_service_manager_screen.dart';

/// Feature routes (chat, payments, bookings, etc.)
class FeatureRoutes {
  const FeatureRoutes._();

  static List<RouteBase> routes = [
    // Health Dashboard route
    GoRoute(
      path: RouteEnum.health.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const HealthDashboard(),
      ),
    ),

    // Provider Dashboard routes
    GoRoute(
      path: RouteEnum.providerDashboard.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 0),
      ),
    ),

    // Provider Explore route
    GoRoute(
      path: RouteEnum.providerExplore.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 1),
      ),
    ),

    // Provider Orders route
    GoRoute(
      path: RouteEnum.providerOrders.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 2),
      ),
    ),

    // Admin Dashboard routes
    GoRoute(
      path: RouteEnum.adminDashboard.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 0),
      ),
    ),

    // Admin Users route
    GoRoute(
      path: RouteEnum.adminUsers.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 1),
      ),
    ),

    // Taker Dashboard routes
    GoRoute(
      path: RouteEnum.takerDashboard.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 0),
      ),
    ),

    // Taker Explore route
    GoRoute(
      path: RouteEnum.takerExplore.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 1),
      ),
    ),

    // Taker Orders route
    GoRoute(
      path: RouteEnum.takerOrders.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 2),
      ),
    ),

    // Settings route
    GoRoute(
      path: RouteEnum.settings.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const BottomNavigation(initialIndex: 3),
      ),
    ),

    // Profile route
    GoRoute(
      path: RouteEnum.profile.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const ProfileScreen(),
      ),
    ),

    // Schedule route
    GoRoute(
      path: RouteEnum.schedule.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const ScheduleScreen(),
      ),
    ),

    // Post Request route
    GoRoute(
      path: RouteEnum.postRequest.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const PostRequestScreen(),
      ),
    ),

    // Notifications route
    GoRoute(
      path: RouteEnum.notifications.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const NotificationsScreen(),
      ),
    ),

    // Add Service route (for providers)
    GoRoute(
      path: RouteEnum.addService.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const AddServiceScreen(),
      ),
    ),

    // Admin Activity route
    GoRoute(
      path: RouteEnum.adminActivity.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const AdminActivityScreen(),
      ),
    ),

    // Admin Tool Manager route
    GoRoute(
      path: RouteEnum.adminToolManager.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child:
            const BottomNavigation(initialIndex: 2), // 3rd tab for admin users
      ),
    ),

    // Admin Management routes
    GoRoute(
      path: RouteEnum.adminCategoryManager.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const AdminCategoryManagerScreen(),
      ),
    ),

    GoRoute(
      path: RouteEnum.adminSubcategoryManager.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const AdminSubcategoryManagerScreen(),
      ),
    ),

    GoRoute(
      path: RouteEnum.adminServiceManager.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const AdminServiceManagerScreen(),
      ),
    ),

    // Chat routes
    GoRoute(
      path: RouteEnum.messages.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const MessagesScreen(),
      ),
    ),

    GoRoute(
      path: RouteEnum.chat.rawValue,
      pageBuilder: (context, state) {
        final chatId = state.pathParameters['chatId'] ?? '';
        final extra = state.extra as Map<String, dynamic>?;

        return RouterUtils.buildPageTransition(
          context: context,
          state: state,
          child: MessagesScreen(
            initialChatId: chatId,
            conversationName: extra?['conversationName'] as String? ?? 'Chat',
            avatarUrl: extra?['avatarUrl'] as String?,
          ),
        );
      },
    ),

    GoRoute(
      path: RouteEnum.directChat.rawValue,
      pageBuilder: (context, state) {
        final userId = state.pathParameters['userId'] ?? '';
        final extra = state.extra as Map<String, dynamic>?;

        return RouterUtils.buildPageTransition(
          context: context,
          state: state,
          child: MessagesScreen(
            initialUserId: userId,
            conversationName: extra?['userName'] as String? ?? 'Chat',
            avatarUrl: extra?['avatarUrl'] as String?,
            isNewConversation: true,
          ),
        );
      },
    ),

    // Chat List route
    GoRoute(
      path: RouteEnum.chatList.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const MessagesScreen(),
      ),
    ),

    // Payment routes
    GoRoute(
      path: RouteEnum.payments.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const PaymentsScreen(),
      ),
    ),

    // Booking routes
    GoRoute(
      path: RouteEnum.bookingDetails.rawValue,
      pageBuilder: (context, state) {
        final bookingId = state.pathParameters['id'] ?? '';
        return RouterUtils.buildPageTransition(
          context: context,
          state: state,
          child: BookingDetailsScreen(bookingId: bookingId),
        );
      },
    ),

    GoRoute(
      path: RouteEnum.serviceDetails.rawValue,
      pageBuilder: (context, state) {
        final serviceId = state.pathParameters['id'] ?? '';
        return RouterUtils.buildPageTransition(
          context: context,
          state: state,
          child: ServiceDetailsScreen(serviceId: serviceId),
        );
      },
    ),

    // Image viewing route
    GoRoute(
      path: RouteEnum.fullScreenImage.rawValue,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final imageUrl = extra?['imageUrl'] as String? ?? '';
        final heroTag = extra?['heroTag'] as String? ?? 'profile-picture';
        final imageUrls = extra?['imageUrls'] as List<String>?;
        final initialIndex = extra?['initialIndex'] as int?;

        return RouterUtils.buildFadeTransition(
          context: context,
          state: state,
          child: FullScreenImageScreen(
            imageUrl: imageUrl,
            heroTag: heroTag,
            imageUrls: imageUrls,
            initialIndex: initialIndex,
          ),
        );
      },
    ),
  ];
}
