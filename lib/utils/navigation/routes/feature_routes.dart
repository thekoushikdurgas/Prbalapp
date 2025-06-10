import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prbal/screens/auth/health_dashboard.dart';
import 'package:prbal/utils/navigation/router_utils.dart';
import 'package:prbal/screens/main/messages_screen.dart';
import 'package:prbal/screens/main/payments_screen.dart';
import 'package:prbal/screens/main/booking_details_screen.dart';
import 'package:prbal/screens/main/service_details_screen.dart';
import 'package:prbal/screens/main/full_screen_image_screen.dart';
import 'package:prbal/screens/provider/provider_dashboard.dart';
import 'package:prbal/screens/provider/schedule_screen.dart';
import 'package:prbal/screens/provider/profile_screen.dart';
import 'package:prbal/screens/admin/admin_dashboard.dart';
import 'package:prbal/screens/taker/taker_dashboard.dart';
import 'package:prbal/screens/common/add_service_screen.dart';
import 'package:prbal/screens/common/post_request_screen.dart';
import 'package:prbal/screens/common/notifications_screen.dart';
import 'package:prbal/utils/navigation/routes/enum/route_enum.dart';

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
        child: const ProviderDashboard(),
      ),
    ),

    // Admin Dashboard routes
    GoRoute(
      path: RouteEnum.adminDashboard.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const AdminDashboard(),
      ),
    ),

    // Taker Dashboard routes
    GoRoute(
      path: RouteEnum.takerDashboard.rawValue,
      pageBuilder: (context, state) => RouterUtils.buildPageTransition(
        context: context,
        state: state,
        child: const TakerDashboard(),
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

// Placeholder screen for admin activity
class AdminActivityScreen extends StatelessWidget {
  const AdminActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          'Admin Activity',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
      ),
      body: const Center(
        child: Text('Admin Activity Screen'),
      ),
    );
  }
}
