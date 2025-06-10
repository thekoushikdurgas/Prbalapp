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
  notifications,
  profile,
  addService,
  schedule,
  messages,

  // Taker dashboard routes
  takerDashboard,
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
  homePage,
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

      // Taker dashboard routes
      case RouteEnum.takerDashboard:
        return '/taker-dashboard';
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
      case RouteEnum.homePage:
        return '/home';
    }
  }
}
