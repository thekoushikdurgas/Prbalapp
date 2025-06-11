import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core API Services
import 'package:prbal/services/admin_service.dart';
import 'package:prbal/services/ai_service.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/services/booking_service.dart';
import 'package:prbal/services/enhanced_service_service.dart';
import 'package:prbal/services/messaging_service.dart';
import 'package:prbal/services/notification_service.dart';
import 'package:prbal/services/payment_service.dart';
import 'package:prbal/services/product_service.dart';
import 'package:prbal/services/review_service.dart';
import 'package:prbal/services/service_category_service.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/services/service_request_service.dart';
import 'package:prbal/services/service_subcategory_service.dart';
import 'package:prbal/services/health_service.dart';

export 'api_service.dart';
export 'hive_service.dart';

// Authentication & User Management
export 'auth_service.dart';

// Sync & Offline Services
export 'sync_service.dart' hide Verification;

// Business Logic Services
export 'booking_service.dart';
export 'product_service.dart';
export 'messaging_service.dart';
export 'payment_service.dart';
export 'notification_service.dart' hide unreadCountProvider;
export 'review_service.dart';

// Enhanced Service Management (From Postman APIs)
export 'service_category_service.dart';
export 'service_subcategory_service.dart';
export 'service_request_service.dart';
export 'enhanced_service_service.dart';

// Admin & Management Services
export 'admin_service.dart' hide AISuggestion;
export 'service_management_service.dart' hide Booking;

// AI Services
export 'ai_service.dart';

// Performance & Analytics
// export 'app_services.dart' hide isAuthenticatedProvider, isVerifiedProvider;
export 'performance_service.dart';

// Health & Monitoring Services
export 'health_service.dart';

/// All Services Provider - Central access point for all services
/// This provides a convenient way to access all services from a single place
class AllServices {
  // Core Services
  static final apiService = ApiService();

  // Business Services
  static final bookingService = BookingService(apiService);
  static final productService = ProductService(apiService);
  static final messagingService = MessagingService(apiService);
  static final paymentService = PaymentService(apiService);
  static final notificationService = NotificationService(apiService);
  static final reviewService = ReviewService(apiService);
  static final serviceManagementService = ServiceManagementService(apiService);

  // Enhanced Service Management (From Postman APIs)
  static final serviceCategoryService = ServiceCategoryService(apiService);
  static final serviceSubcategoryService = ServiceSubcategoryService(apiService);
  static final serviceRequestService = ServiceRequestService(apiService);
  static final enhancedServiceService = EnhancedServiceService(apiService);

  // Admin Services
  static final adminService = AdminService(apiService);

  // AI Services
  static final aiService = AIService(apiService);

  // Health & Monitoring Services
  static final healthService = HealthService();

  // Sync Services
  // Note: SyncServiceProvider is available via Riverpod provider

  /// Initialize all services
  static Future<void> initialize() async {
    // Initialize Hive storage
    try {
      await Hive.initFlutter();
      await Hive.openBox('app_cache');
      await Hive.openBox('user_preferences');
      await Hive.openBox('onboarding_cache');
      await Hive.openBox('theme_cache');
    } catch (e) {
      debugPrint('Hive initialization error: $e');
    }
    apiService.initialize();
  }

  /// Cleanup all services
  static Future<void> dispose() async {
    apiService.dispose();
    // await HiveService.close(); // Uncomment when HiveService is properly exported
  }
}

/// Service Categories for better organization
abstract class ServiceCategories {
  /// Authentication and user management services
  static const List<String> authentication = [
    'AuthService',
    'HiveService',
    'SyncService',
  ];

  /// Core business logic services
  static const List<String> business = [
    'BookingService',
    'ProductService',
    'MessagingService',
    'PaymentService',
    'ReviewService',
    'ServiceManagementService',
    'ServiceCategoryService',
    'ServiceSubcategoryService',
    'ServiceRequestService',
    'EnhancedServiceService',
  ];

  /// Communication and notifications
  static const List<String> communication = [
    'NotificationService',
    'MessagingService',
  ];

  /// Administrative and management services
  static const List<String> administration = [
    'AdminService',
    'PerformanceService',
    'AppServices',
  ];

  /// AI and machine learning services
  static const List<String> ai = [
    'AIService',
  ];

  /// Health and monitoring services
  static const List<String> health = [
    'HealthService',
    'PerformanceService',
  ];

  /// All available services
  static const List<String> all = [
    ...authentication,
    ...business,
    ...communication,
    ...administration,
    ...ai,
    ...health,
  ];
}

/// API Endpoints Documentation
///
/// This class provides documentation for all available API endpoints
/// organized by service category
abstract class APIEndpoints {
  // === AUTHENTICATION ENDPOINTS ===
  static const Map<String, String> authentication = {
    // Registration
    'register': 'POST /api/v1/auth/register/',
    'registerCustomer': 'POST /api/v1/auth/register/customer/',
    'registerProvider': 'POST /api/v1/auth/register/provider/',
    'registerAdmin': 'POST /api/v1/auth/register/admin/',

    // Login
    'login': 'POST /api/v1/auth/login/',
    'loginCustomer': 'POST /api/v1/auth/login/customer/',
    'loginProvider': 'POST /api/v1/auth/login/provider/',
    'loginAdmin': 'POST /api/v1/auth/login/admin/',
    'searchUserByPhone': 'GET /api/v1/users/search/phone/{phone}/',

    // PIN Authentication
    'pinLogin': 'POST /api/v1/auth/pin/login/',
    'registerPin': 'POST /api/v1/auth/pin/register/',
    'registerCustomerPin': 'POST /api/v1/auth/pin/register/customer/',
    'registerProviderPin': 'POST /api/v1/auth/pin/register/provider/',
    'changePin': 'POST /api/v1/auth/pin/change/',
    'resetPin': 'POST /api/v1/auth/pin/reset/',
    'getPinStatus': 'GET /api/v1/auth/pin/status/',

    // Token Management
    'refreshToken': 'POST /api/v1/auth/token/refresh/',
    'logout': 'POST /api/v1/auth/logout/',
    'getUserTokens': 'GET /api/v1/users/me/tokens/',
    'revokeToken': 'DELETE /api/v1/users/me/tokens/{tokenId}/',
    'revokeAllTokens': 'POST /api/v1/users/me/tokens/revoke_all/',

    // User Type Detection
    'getUserType': 'GET /api/v1/auth/user-type/',
  };

  // === USER MANAGEMENT ENDPOINTS ===
  static const Map<String, String> userManagement = {
    'getCurrentUserProfile': 'GET /api/v1/users/me/',
    'updateProfile': 'PATCH /api/v1/users/me/',
    'deactivateAccount': 'POST /api/v1/users/me/deactivate/',
    'getUserProfile': 'GET /api/v1/users/{userId}/',
    'searchUsers': 'POST /api/v1/users/search/',
  };

  // === BOOKING ENDPOINTS ===
  static const Map<String, String> bookings = {
    'createBooking': 'POST /api/v1/bookings/',
    'getBooking': 'GET /api/v1/bookings/{bookingId}/',
    'updateBooking': 'PATCH /api/v1/bookings/{bookingId}/',
    'cancelBooking': 'DELETE /api/v1/bookings/{bookingId}/',
    'getMyBookings': 'GET /api/v1/bookings/me/',
    'getCustomerBookings': 'GET /api/v1/bookings/customer/',
    'getProviderBookings': 'GET /api/v1/bookings/provider/',

    // Status Updates
    'confirmBooking': 'POST /api/v1/bookings/{bookingId}/confirm/',
    'acceptBooking': 'POST /api/v1/bookings/{bookingId}/accept/',
    'startWork': 'POST /api/v1/bookings/{bookingId}/start/',
    'completeWork': 'POST /api/v1/bookings/{bookingId}/complete/',
    'approveCompletion': 'POST /api/v1/bookings/{bookingId}/approve/',
    'requestCancellation': 'POST /api/v1/bookings/{bookingId}/request_cancellation/',
    'disputeBooking': 'POST /api/v1/bookings/{bookingId}/dispute/',

    // Calendar
    'getProviderCalendar': 'GET /api/v1/calendar/provider/{providerId}/',
    'getMyCalendar': 'GET /api/v1/calendar/me/',
    'setAvailability': 'POST /api/v1/calendar/availability/',
    'blockTimeSlot': 'POST /api/v1/calendar/block/',
    'checkAvailability': 'GET /api/v1/calendar/availability/check/',
  };

  // === PRODUCT/SERVICE ENDPOINTS ===
  static const Map<String, String> products = {
    // Categories
    'getCategories': 'GET /api/v1/products/categories/',
    'getCategory': 'GET /api/v1/products/categories/{categoryId}/',
    'createCategory': 'POST /api/v1/products/categories/',
    'updateCategory': 'PATCH /api/v1/products/categories/{categoryId}/',
    'deleteCategory': 'DELETE /api/v1/products/categories/{categoryId}/',

    // Products
    'getProducts': 'GET /api/v1/products/',
    'getProduct': 'GET /api/v1/products/{productId}/',
    'createProduct': 'POST /api/v1/products/',
    'updateProduct': 'PATCH /api/v1/products/{productId}/',
    'deleteProduct': 'DELETE /api/v1/products/{productId}/',
    'getMyProducts': 'GET /api/v1/products/me/',
    'searchProducts': 'POST /api/v1/products/search/',
    'getFeaturedProducts': 'GET /api/v1/products/featured/',
    'getPopularProducts': 'GET /api/v1/products/popular/',
    'getProductsByProvider': 'GET /api/v1/products/provider/{providerId}/',
  };

  // === MESSAGING ENDPOINTS ===
  static const Map<String, String> messaging = {
    // Threads
    'getThreads': 'GET /api/v1/messages/threads/',
    'getThread': 'GET /api/v1/messages/threads/{threadId}/',
    'createThread': 'POST /api/v1/messages/threads/',
    'updateThread': 'PATCH /api/v1/messages/threads/{threadId}/',
    'archiveThread': 'POST /api/v1/messages/threads/{threadId}/archive/',
    'addParticipant': 'POST /api/v1/messages/threads/{threadId}/participants/',
    'removeParticipant': 'DELETE /api/v1/messages/threads/{threadId}/participants/{userId}/',

    // Messages
    'getMessages': 'GET /api/v1/messages/threads/{threadId}/messages/',
    'getMessage': 'GET /api/v1/messages/{messageId}/',
    'sendMessage': 'POST /api/v1/messages/threads/{threadId}/messages/',
    'editMessage': 'PATCH /api/v1/messages/{messageId}/',
    'deleteMessage': 'DELETE /api/v1/messages/{messageId}/',
    'markMessageAsRead': 'POST /api/v1/messages/{messageId}/read/',
    'markThreadAsRead': 'POST /api/v1/messages/threads/{threadId}/read_all/',
    'searchMessages': 'POST /api/v1/messages/search/',

    // WebSocket
    'connectRealtimeMessaging': 'GET /api/v1/messages/websocket/connect/',
    'getWebSocketInfo': 'GET /api/v1/messages/websocket/info/',
  };

  // === PAYMENT ENDPOINTS ===
  static const Map<String, String> payments = {
    // Payments
    'createPaymentIntent': 'POST /api/v1/payments/intent/',
    'processPayment': 'POST /api/v1/payments/',
    'verifyPayment': 'POST /api/v1/payments/{paymentId}/verify/',
    'getPayment': 'GET /api/v1/payments/{paymentId}/',
    'getPaymentByBooking': 'GET /api/v1/payments/booking/{bookingId}/',
    'getPaymentHistory': 'GET /api/v1/payments/history/',
    'cancelPayment': 'POST /api/v1/payments/{paymentId}/cancel/',
    'requestRefund': 'POST /api/v1/payments/{paymentId}/refund/',

    // Gateway Accounts
    'getGatewayAccounts': 'GET /api/v1/payments/gateways/',
    'addGatewayAccount': 'POST /api/v1/payments/gateways/',
    'updateGatewayAccount': 'PATCH /api/v1/payments/gateways/{accountId}/',
    'deleteGatewayAccount': 'DELETE /api/v1/payments/gateways/{accountId}/',
    'verifyGatewayAccount': 'POST /api/v1/payments/gateways/{accountId}/verify/',

    // Payouts
    'getPayoutHistory': 'GET /api/v1/payouts/',
    'getPendingPayoutAmount': 'GET /api/v1/payouts/pending/',
    'requestPayout': 'POST /api/v1/payouts/request/',
    'getPayout': 'GET /api/v1/payouts/{payoutId}/',
    'cancelPayout': 'POST /api/v1/payouts/{payoutId}/cancel/',
  };

  // === NOTIFICATION ENDPOINTS ===
  static const Map<String, String> notifications = {
    'getNotifications': 'GET /api/v1/notifications/',
    'getNotification': 'GET /api/v1/notifications/{notificationId}/',
    'markNotificationAsRead': 'POST /api/v1/notifications/{notificationId}/read/',
    'markAllNotificationsAsRead': 'POST /api/v1/notifications/read_all/',
    'deleteNotification': 'DELETE /api/v1/notifications/{notificationId}/',
    'getUnreadCount': 'GET /api/v1/notifications/unread_count/',
    'getNotificationSummary': 'GET /api/v1/notifications/summary/',

    // Provider/Customer specific
    'getProviderNotifications': 'GET /api/v1/notifications/provider/',
    'getCustomerNotifications': 'GET /api/v1/notifications/customer/',

    // Preferences
    'getNotificationPreferences': 'GET /api/v1/notifications/preferences/',
    'updateNotificationPreferences': 'PATCH /api/v1/notifications/preferences/',

    // Push Notifications
    'registerDevice': 'POST /api/v1/notifications/device/register/',
    'unregisterDevice': 'POST /api/v1/notifications/device/unregister/',
    'updateDeviceToken': 'POST /api/v1/notifications/device/update_token/',
    'testPushNotification': 'POST /api/v1/notifications/test_push/',

    // WebSocket
    'connectRealtimeNotifications': 'GET /api/v1/notifications/websocket/connect/',
    'subscribeToChannel': 'POST /api/v1/notifications/websocket/subscribe/',
    'unsubscribeFromChannel': 'POST /api/v1/notifications/websocket/unsubscribe/',
  };

  // === REVIEW ENDPOINTS ===
  static const Map<String, String> reviews = {
    'createReview': 'POST /api/v1/reviews/',
    'getReview': 'GET /api/v1/reviews/{reviewId}/',
    'updateReview': 'PATCH /api/v1/reviews/{reviewId}/',
    'deleteReview': 'DELETE /api/v1/reviews/{reviewId}/',
    'getUserReviews': 'GET /api/v1/reviews/user/{userId}/',
    'getMyReviews': 'GET /api/v1/reviews/me/',
    'getReviewsForMe': 'GET /api/v1/reviews/for_me/',
    'getBookingReview': 'GET /api/v1/reviews/booking/{bookingId}/',
    'getReviewSummary': 'GET /api/v1/reviews/user/{userId}/summary/',
    'getMyReviewSummary': 'GET /api/v1/reviews/me/summary/',
    'searchReviews': 'POST /api/v1/reviews/search/',
    'getTopRatedProviders': 'GET /api/v1/reviews/top_rated_providers/',
    'getRecentReviews': 'GET /api/v1/reviews/recent/',

    // Interactions
    'markReviewAsHelpful': 'POST /api/v1/reviews/{reviewId}/helpful/',
    'removeHelpfulMark': 'DELETE /api/v1/reviews/{reviewId}/helpful/',
    'reportReview': 'POST /api/v1/reviews/{reviewId}/report/',
    'respondToReview': 'POST /api/v1/reviews/{reviewId}/respond/',
  };

  // === AI SUGGESTION ENDPOINTS ===
  static const Map<String, String> aiSuggestions = {
    // AI Suggestions
    'listAISuggestions': 'GET /api/v1/ai_suggestions/suggestions/',
    'filterSuggestionsByType': 'GET /api/v1/ai_suggestions/suggestions/?suggestion_type={type}',
    'filterSuggestionsByStatus': 'GET /api/v1/ai_suggestions/suggestions/?status={status}',
    'getAISuggestionDetails': 'GET /api/v1/ai_suggestions/suggestions/{suggestionId}/',
    'adminViewAllSuggestions': 'GET /api/v1/ai_suggestions/suggestions/?all=true',
    'provideFeedbackOnSuggestion': 'POST /api/v1/ai_suggestions/suggestions/{suggestionId}/provide_feedback/',
    'generateServiceSuggestions': 'POST /api/v1/ai_suggestions/suggestions/generate_service_suggestions/',
    'suggestBidAmount': 'POST /api/v1/ai_suggestions/suggestions/suggest_bid_amount/',
    'suggestBidMessage': 'POST /api/v1/ai_suggestions/suggestions/suggest_bid_message/',
    'suggestMessageTemplate': 'POST /api/v1/ai_suggestions/suggestions/suggest_message/',

    // AI Feedback Logs
    'listFeedbackLogs': 'GET /api/v1/ai_suggestions/feedback/',
    'getFeedbackLogDetails': 'GET /api/v1/ai_suggestions/feedback/{logId}/',
    'logInteraction': 'POST /api/v1/ai_suggestions/feedback/log/',
    'logBidInteraction': 'POST /api/v1/ai_suggestions/feedback/log/',
    'logFeedbackOnly': 'POST /api/v1/ai_suggestions/feedback/log/',
    'adminViewAllFeedbackLogs': 'GET /api/v1/ai_suggestions/feedback/',
  };

  // === ADMIN ENDPOINTS ===
  static const Map<String, String> admin = {
    // Analytics
    'getPlatformAnalytics': 'GET /api/v1/analytics/platform/',
    'getUserAnalytics': 'GET /api/v1/analytics/users/',
    'getRevenueAnalytics': 'GET /api/v1/analytics/revenue/',
    'generateCustomReport': 'POST /api/v1/analytics/reports/generate/',

    // User Management
    'getAllUsers': 'GET /api/v1/admin/users/',
    'suspendUser': 'POST /api/v1/admin/users/{userId}/suspend/',
    'unsuspendUser': 'POST /api/v1/admin/users/{userId}/unsuspend/',
    'verifyUser': 'POST /api/v1/admin/users/{userId}/verify/',

    // Service Management
    'getAllServices': 'GET /api/v1/admin/services/',
    'approveService': 'POST /api/v1/admin/services/{serviceId}/approve/',
    'rejectService': 'POST /api/v1/admin/services/{serviceId}/reject/',
    'featureService': 'POST /api/v1/admin/services/{serviceId}/feature/',

    // Health Checks
    'getSystemHealth': 'GET /api/v1/health/',
    'getDatabaseHealth': 'GET /api/v1/health/db/',

    // Sync Operations
    'triggerFullSync': 'POST /api/v1/sync/full/',
    'triggerUserSync': 'POST /api/v1/sync/users/{userId}/',
    'triggerPaymentSync': 'POST /api/v1/sync/payments/',
    'getSyncStatus': 'GET /api/v1/sync/status/',
    'getSyncHistory': 'GET /api/v1/sync/history/',

    // Verifications
    'getVerificationRequests': 'GET /api/v1/verifications/',
    'submitVerification': 'POST /api/v1/verifications/',
    'processVerification': 'POST /api/v1/verifications/{verificationId}/process/',

    // Bids
    'getAllBids': 'GET /api/v1/bids/',
    'createBid': 'POST /api/v1/bids/',
    'updateBid': 'PATCH /api/v1/bids/{bidId}/',
    'acceptBid': 'POST /api/v1/bids/{bidId}/accept/',
    'rejectBid': 'POST /api/v1/bids/{bidId}/reject/',
    'withdrawBid': 'POST /api/v1/bids/{bidId}/withdraw/',

    // System Configuration
    'getSystemConfig': 'GET /api/v1/admin/config/',
    'updateSystemConfig': 'PATCH /api/v1/admin/config/',
    'getFeatureFlags': 'GET /api/v1/admin/features/',
    'updateFeatureFlag': 'PATCH /api/v1/admin/features/',

    // Audit Logs
    'getAuditLogs': 'GET /api/v1/admin/audit_logs/',
    'exportAuditLogs': 'POST /api/v1/admin/audit_logs/export/',
  };

  /// Get all endpoints as a single map
  static Map<String, String> get allEndpoints => {
        ...authentication,
        ...userManagement,
        ...bookings,
        ...products,
        ...messaging,
        ...payments,
        ...notifications,
        ...reviews,
        ...aiSuggestions,
        ...admin,
      };
}
