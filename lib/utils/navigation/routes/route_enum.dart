enum RouteEnum {
  // Core routes
  splash,
  onboarding,
  welcome,

  // Authentication routes
  pinEntry,

  // Main navigation routes
  home,
  explore,
  orders,
  settings,
  languageSelection,

  // Provider dashboard routes
  providerDashboard,
  providerExplore,
  providerOrders,
  notifications,
  profile,
  addService,
  schedule,
  messages,

  // Admin dashboard routes
  adminDashboard,
  adminUsers,
  adminActivity,
  adminToolManager,

  // Admin management routes
  adminCategoryManager,
  adminSubcategoryManager,
  adminServiceManager,

  // Taker dashboard routes
  takerDashboard,
  takerExplore,
  takerOrders,
  postRequest,

  // Additional feature routes
  payments,
  bookingDetails,
  serviceDetails,
  health,

  // Chat routes
  chat,
  directChat,
  chatList,

  // Utility routes
  fullScreenImage,

  // Legacy routes
  intro,
  setting,
}

extension RouteEnumString on RouteEnum {
  String get rawValue {
    switch (this) {
      // Core routes
      case RouteEnum.splash:
        return '/';
      case RouteEnum.onboarding:
        return '/onboarding';
      case RouteEnum.welcome:
        return '/welcome';

      // Authentication routes
      case RouteEnum.pinEntry:
        return '/pin-entry';

      // Main navigation routes
      case RouteEnum.home:
        return '/home';
      case RouteEnum.explore:
        return '/explore';
      case RouteEnum.orders:
        return '/orders';
      case RouteEnum.settings:
        return '/settings';
      case RouteEnum.languageSelection:
        return '/language-selection';

      // Provider dashboard routes
      case RouteEnum.providerDashboard:
        return '/provider-dashboard';
      case RouteEnum.providerExplore:
        return '/provider-explore';
      case RouteEnum.providerOrders:
        return '/provider-orders';
      case RouteEnum.notifications:
        return '/notifications';
      case RouteEnum.profile:
        return '/profile';
      case RouteEnum.addService:
        return '/add-service';
      case RouteEnum.schedule:
        return '/schedule';
      case RouteEnum.messages:
        return '/messages';

      // Admin dashboard routes
      case RouteEnum.adminDashboard:
        return '/admin-dashboard';
      case RouteEnum.adminUsers:
        return '/admin-users';
      case RouteEnum.adminActivity:
        return '/admin-activity';
      case RouteEnum.adminToolManager:
        return '/admin-tool-manager';

      // Admin management routes
      case RouteEnum.adminCategoryManager:
        return '/admin-category-manager';
      case RouteEnum.adminSubcategoryManager:
        return '/admin-subcategory-manager';
      case RouteEnum.adminServiceManager:
        return '/admin-service-manager';

      // Taker dashboard routes
      case RouteEnum.takerDashboard:
        return '/taker-dashboard';
      case RouteEnum.takerExplore:
        return '/taker-explore';
      case RouteEnum.takerOrders:
        return '/taker-orders';
      case RouteEnum.postRequest:
        return '/post-request';

      // Additional feature routes
      case RouteEnum.payments:
        return '/payments';
      case RouteEnum.bookingDetails:
        return '/booking-details/:id';
      case RouteEnum.serviceDetails:
        return '/service-details/:id';
      case RouteEnum.health:
        return '/health';

      // Chat routes
      case RouteEnum.chat:
        return '/chat/:chatId';
      case RouteEnum.directChat:
        return '/direct-chat/:userId';
      case RouteEnum.chatList:
        return '/chats';

      // Utility routes
      case RouteEnum.fullScreenImage:
        return '/image-view';

      // Legacy routes (keeping for backward compatibility)
      case RouteEnum.intro:
        return '/intro';
      case RouteEnum.setting:
        return '/setting';
    }
  }
}
