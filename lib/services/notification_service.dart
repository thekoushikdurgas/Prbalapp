import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'api_service.dart';

/// Enhanced notification type enumeration matching Postman collection
enum NotificationType {
  bidReceived,
  bidAccepted,
  bidRejected,
  bookingCreated,
  bookingStatusUpdated,
  paymentReceived,
  system,
  support,
  general,
  message,
  review,
  promotion,
  reminder;

  String get value {
    switch (this) {
      case NotificationType.bidReceived:
        return 'bid_received';
      case NotificationType.bidAccepted:
        return 'bid_accepted';
      case NotificationType.bidRejected:
        return 'bid_rejected';
      case NotificationType.bookingCreated:
        return 'booking_created';
      case NotificationType.bookingStatusUpdated:
        return 'booking_status_updated';
      case NotificationType.paymentReceived:
        return 'payment_received';
      case NotificationType.system:
        return 'system';
      case NotificationType.support:
        return 'support';
      case NotificationType.general:
        return 'general';
      case NotificationType.message:
        return 'message';
      case NotificationType.review:
        return 'review';
      case NotificationType.promotion:
        return 'promotion';
      case NotificationType.reminder:
        return 'reminder';
    }
  }

  static NotificationType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'bid_received':
        return NotificationType.bidReceived;
      case 'bid_accepted':
        return NotificationType.bidAccepted;
      case 'bid_rejected':
        return NotificationType.bidRejected;
      case 'booking_created':
        return NotificationType.bookingCreated;
      case 'booking_status_updated':
        return NotificationType.bookingStatusUpdated;
      case 'payment_received':
        return NotificationType.paymentReceived;
      case 'system':
        return NotificationType.system;
      case 'support':
        return NotificationType.support;
      case 'general':
        return NotificationType.general;
      case 'message':
        return NotificationType.message;
      case 'review':
        return NotificationType.review;
      case 'promotion':
        return NotificationType.promotion;
      case 'reminder':
        return NotificationType.reminder;
      default:
        return NotificationType.system;
    }
  }
}

/// Notification ordering enumeration
enum NotificationOrdering {
  createdAt,
  negativeCreatedAt;

  String get value {
    switch (this) {
      case NotificationOrdering.createdAt:
        return 'created_at';
      case NotificationOrdering.negativeCreatedAt:
        return '-created_at';
    }
  }

  static NotificationOrdering fromString(String ordering) {
    switch (ordering) {
      case 'created_at':
        return NotificationOrdering.createdAt;
      case '-created_at':
        return NotificationOrdering.negativeCreatedAt;
      default:
        return NotificationOrdering.negativeCreatedAt;
    }
  }
}

/// Enhanced notification model matching the Postman collection
class AppNotification {
  final String id;
  final String recipient;
  final NotificationType notificationType;
  final String title;
  final String message;
  final String? actionUrl;
  final bool isRead;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const AppNotification({
    required this.id,
    required this.recipient,
    required this.notificationType,
    required this.title,
    required this.message,
    this.actionUrl,
    required this.isRead,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      recipient: json['recipient'] as String,
      notificationType:
          NotificationType.fromString(json['notification_type'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      actionUrl: json['action_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipient': recipient,
      'notification_type': notificationType.value,
      'title': title,
      'message': message,
      if (actionUrl != null) 'action_url': actionUrl,
      'is_read': isRead,
      'is_archived': isArchived,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Unread count response model
class UnreadCountResponse {
  final int count;
  final Map<String, int>? byType;

  const UnreadCountResponse({
    required this.count,
    this.byType,
  });

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      count: json['count'] as int,
      byType: json['by_type'] != null
          ? Map<String, int>.from(json['by_type'])
          : null,
    );
  }
}

/// Notification list response model
class NotificationListResponse {
  final List<AppNotification> results;
  final int count;
  final String? next;
  final String? previous;

  const NotificationListResponse({
    required this.results,
    required this.count,
    this.next,
    this.previous,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationListResponse(
      results: (json['results'] as List)
          .map((item) => AppNotification.fromJson(item))
          .toList(),
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );
  }
}

/// Create notification request model (for admin)
class CreateNotificationRequest {
  final String recipient;
  final NotificationType notificationType;
  final String title;
  final String message;
  final String? actionUrl;

  const CreateNotificationRequest({
    required this.recipient,
    required this.notificationType,
    required this.title,
    required this.message,
    this.actionUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'notification_type': notificationType.value,
      'title': title,
      'message': message,
      if (actionUrl != null) 'action_url': actionUrl,
    };
  }
}

/// Mark notifications as read request model
class MarkAsReadRequest {
  final List<String>? notificationIds;
  final bool? markAll;

  const MarkAsReadRequest({
    this.notificationIds,
    this.markAll,
  });

  Map<String, dynamic> toJson() {
    return {
      if (notificationIds != null) 'notification_ids': notificationIds,
      if (markAll != null) 'mark_all': markAll,
    };
  }
}

/// WebSocket message model for real-time notifications
class NotificationWebSocketMessage {
  final String type;
  final Map<String, dynamic> data;

  const NotificationWebSocketMessage({
    required this.type,
    required this.data,
  });

  factory NotificationWebSocketMessage.fromJson(Map<String, dynamic> json) {
    return NotificationWebSocketMessage(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
    };
  }
}

/// Enhanced notification service matching the Postman collection exactly
class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService);

  // === CORE NOTIFICATION ENDPOINTS ===

  /// List User Notifications
  /// GET /api/v1/notifications/
  Future<ApiResponse<NotificationListResponse>> listUserNotifications({
    NotificationType? notificationType,
    bool? isRead,
    NotificationOrdering? ordering,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (notificationType != null) {
      queryParams['notification_type'] = notificationType.value;
    }
    if (isRead != null) {
      queryParams['is_read'] = isRead.toString();
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering.value;
    }
    if (page != null) {
      queryParams['page'] = page.toString();
    }
    if (pageSize != null) {
      queryParams['page_size'] = pageSize.toString();
    }

    return _apiService.get<NotificationListResponse>(
      '/notifications/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => NotificationListResponse.fromJson(data),
    );
  }

  /// Get Notification Details
  /// GET /api/v1/notifications/{notification_id}/
  Future<ApiResponse<AppNotification>> getNotificationDetails(
      String notificationId) async {
    return _apiService.get<AppNotification>(
      '/notifications/$notificationId/',
      fromJson: (data) => AppNotification.fromJson(data),
    );
  }

  /// Get Unread Notifications Count
  /// GET /api/v1/notifications/unread_count/
  Future<ApiResponse<UnreadCountResponse>> getUnreadNotificationsCount() async {
    return _apiService.get<UnreadCountResponse>(
      '/notifications/unread_count/',
      fromJson: (data) => UnreadCountResponse.fromJson(data),
    );
  }

  /// Mark Specific Notifications as Read
  /// POST /api/v1/notifications/mark_read/
  Future<ApiResponse<Map<String, dynamic>>> markSpecificNotificationsAsRead(
      List<String> notificationIds) async {
    final request = MarkAsReadRequest(notificationIds: notificationIds);
    return _apiService.post<Map<String, dynamic>>(
      '/notifications/mark_read/',
      body: request.toJson(),
      fromJson: (data) => data,
    );
  }

  /// Mark All Notifications as Read
  /// POST /api/v1/notifications/mark_read/
  Future<ApiResponse<Map<String, dynamic>>> markAllNotificationsAsRead() async {
    final request = MarkAsReadRequest(markAll: true);
    return _apiService.post<Map<String, dynamic>>(
      '/notifications/mark_read/',
      body: request.toJson(),
      fromJson: (data) => data,
    );
  }

  /// Mark Single Notification as Read (PUT)
  /// PUT /api/v1/notifications/{notification_id}/
  Future<ApiResponse<AppNotification>> markSingleNotificationAsReadPut(
      String notificationId) async {
    return _apiService.put<AppNotification>(
      '/notifications/$notificationId/',
      body: {'mark_all': false},
      fromJson: (data) => AppNotification.fromJson(data),
    );
  }

  /// Mark Single Notification as Read (PATCH)
  /// PATCH /api/v1/notifications/{notification_id}/
  Future<ApiResponse<AppNotification>> markSingleNotificationAsReadPatch(
      String notificationId) async {
    return _apiService.patch<AppNotification>(
      '/notifications/$notificationId/',
      body: {'mark_all': false},
      fromJson: (data) => AppNotification.fromJson(data),
    );
  }

  /// Delete Notification
  /// DELETE /api/v1/notifications/{notification_id}/
  Future<ApiResponse<void>> deleteNotification(String notificationId) async {
    return _apiService.delete<void>(
      '/notifications/$notificationId/',
    );
  }

  /// Archive Notification
  /// PATCH /api/v1/notifications/{notification_id}/
  Future<ApiResponse<AppNotification>> archiveNotification(
      String notificationId) async {
    return _apiService.patch<AppNotification>(
      '/notifications/$notificationId/',
      body: {'is_archived': true},
      fromJson: (data) => AppNotification.fromJson(data),
    );
  }

  // === ADMIN NOTIFICATION ENDPOINTS ===

  /// [Admin] Create Notification
  /// POST /api/v1/notifications/
  Future<ApiResponse<AppNotification>> adminCreateNotification(
      CreateNotificationRequest request) async {
    return _apiService.post<AppNotification>(
      '/notifications/',
      body: request.toJson(),
      fromJson: (data) => AppNotification.fromJson(data),
    );
  }

  /// [Admin] List All Notifications
  /// GET /api/v1/notifications/?all=true
  Future<ApiResponse<NotificationListResponse>> adminListAllNotifications({
    NotificationType? notificationType,
    bool? isRead,
    NotificationOrdering? ordering,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{'all': 'true'};
    if (notificationType != null) {
      queryParams['notification_type'] = notificationType.value;
    }
    if (isRead != null) {
      queryParams['is_read'] = isRead.toString();
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering.value;
    }
    if (page != null) {
      queryParams['page'] = page.toString();
    }
    if (pageSize != null) {
      queryParams['page_size'] = pageSize.toString();
    }

    return _apiService.get<NotificationListResponse>(
      '/notifications/',
      queryParameters: queryParams,
      fromJson: (data) => NotificationListResponse.fromJson(data),
    );
  }

  // === PROVIDER NOTIFICATIONS ===

  /// [Provider] List My Notifications
  /// GET /api/v1/notifications/?notification_type=bid_received,booking_created,payment_received
  Future<ApiResponse<NotificationListResponse>> providerListMyNotifications({
    bool? isRead,
    NotificationOrdering? ordering,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{
      'notification_type': 'bid_received,booking_created,payment_received',
    };
    if (isRead != null) {
      queryParams['is_read'] = isRead.toString();
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering.value;
    }
    if (page != null) {
      queryParams['page'] = page.toString();
    }
    if (pageSize != null) {
      queryParams['page_size'] = pageSize.toString();
    }

    return _apiService.get<NotificationListResponse>(
      '/notifications/',
      queryParameters: queryParams,
      fromJson: (data) => NotificationListResponse.fromJson(data),
    );
  }

  /// [Provider] Get Bid Notifications
  /// GET /api/v1/notifications/?notification_type=bid_received&is_read=false
  Future<ApiResponse<NotificationListResponse>> providerGetBidNotifications({
    bool? isRead,
    NotificationOrdering? ordering,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{
      'notification_type': 'bid_received',
    };
    if (isRead != null) {
      queryParams['is_read'] = isRead.toString();
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering.value;
    }
    if (page != null) {
      queryParams['page'] = page.toString();
    }
    if (pageSize != null) {
      queryParams['page_size'] = pageSize.toString();
    }

    return _apiService.get<NotificationListResponse>(
      '/notifications/',
      queryParameters: queryParams,
      fromJson: (data) => NotificationListResponse.fromJson(data),
    );
  }

  // === CUSTOMER NOTIFICATIONS ===

  /// [Customer] List My Notifications
  /// GET /api/v1/notifications/?notification_type=bid_accepted,bid_rejected,booking_status_updated
  Future<ApiResponse<NotificationListResponse>> customerListMyNotifications({
    bool? isRead,
    NotificationOrdering? ordering,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{
      'notification_type': 'bid_accepted,bid_rejected,booking_status_updated',
    };
    if (isRead != null) {
      queryParams['is_read'] = isRead.toString();
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering.value;
    }
    if (page != null) {
      queryParams['page'] = page.toString();
    }
    if (pageSize != null) {
      queryParams['page_size'] = pageSize.toString();
    }

    return _apiService.get<NotificationListResponse>(
      '/notifications/',
      queryParameters: queryParams,
      fromJson: (data) => NotificationListResponse.fromJson(data),
    );
  }

  /// [Customer] Get Booking Status Notifications
  /// GET /api/v1/notifications/?notification_type=booking_status_updated&is_read=false
  Future<ApiResponse<NotificationListResponse>>
      customerGetBookingStatusNotifications({
    bool? isRead,
    NotificationOrdering? ordering,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{
      'notification_type': 'booking_status_updated',
    };
    if (isRead != null) {
      queryParams['is_read'] = isRead.toString();
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering.value;
    }
    if (page != null) {
      queryParams['page'] = page.toString();
    }
    if (pageSize != null) {
      queryParams['page_size'] = pageSize.toString();
    }

    return _apiService.get<NotificationListResponse>(
      '/notifications/',
      queryParameters: queryParams,
      fromJson: (data) => NotificationListResponse.fromJson(data),
    );
  }

  // === REAL-TIME NOTIFICATIONS (WebSocket) ===

  /// Connect to Notifications WebSocket
  /// WebSocket connection: ws://base_url/ws/notifications/
  WebSocketChannel connectToNotificationsWebSocket({
    required String baseUrlWs,
    required String accessToken,
  }) {
    final wsUrl = '$baseUrlWs/ws/notifications/';
    final channel = WebSocketChannel.connect(
      Uri.parse(wsUrl),
    );

    // Send authentication after connection
    channel.sink.add(json.encode({
      'type': 'auth',
      'token': accessToken,
    }));

    return channel;
  }

  /// Send WebSocket message to mark notification as read
  void sendMarkNotificationAsReadWS(
      WebSocketChannel channel, String notificationId) {
    final message = NotificationWebSocketMessage(
      type: 'mark_read',
      data: {'notification_id': notificationId},
    );
    channel.sink.add(json.encode(message.toJson()));
  }

  /// Send WebSocket message to mark all notifications as read
  void sendMarkAllNotificationsAsReadWS(WebSocketChannel channel) {
    final message = NotificationWebSocketMessage(
      type: 'mark_all_read',
      data: {},
    );
    channel.sink.add(json.encode(message.toJson()));
  }

  /// Send WebSocket message to get recent notifications
  void sendGetRecentNotificationsWS(WebSocketChannel channel) {
    final message = NotificationWebSocketMessage(
      type: 'get_notifications',
      data: {},
    );
    channel.sink.add(json.encode(message.toJson()));
  }

  /// Send WebSocket message to archive notification
  void sendArchiveNotificationWS(
      WebSocketChannel channel, String notificationId) {
    final message = NotificationWebSocketMessage(
      type: 'archive_notification',
      data: {'notification_id': notificationId},
    );
    channel.sink.add(json.encode(message.toJson()));
  }

  // === UTILITY METHODS ===

  /// Create bid-related notification (helper)
  Future<ApiResponse<AppNotification>> createBidNotification({
    required String recipient,
    required String title,
    required String message,
    String? actionUrl,
    bool isBidReceived = true,
  }) async {
    final request = CreateNotificationRequest(
      recipient: recipient,
      notificationType: isBidReceived
          ? NotificationType.bidReceived
          : NotificationType.bidAccepted,
      title: title,
      message: message,
      actionUrl: actionUrl,
    );
    return adminCreateNotification(request);
  }

  /// Create booking-related notification (helper)
  Future<ApiResponse<AppNotification>> createBookingNotification({
    required String recipient,
    required String title,
    required String message,
    String? actionUrl,
    bool isBookingCreated = true,
  }) async {
    final request = CreateNotificationRequest(
      recipient: recipient,
      notificationType: isBookingCreated
          ? NotificationType.bookingCreated
          : NotificationType.bookingStatusUpdated,
      title: title,
      message: message,
      actionUrl: actionUrl,
    );
    return adminCreateNotification(request);
  }

  /// Create system notification (helper)
  Future<ApiResponse<AppNotification>> createSystemNotification({
    required String recipient,
    required String title,
    required String message,
    String? actionUrl,
  }) async {
    final request = CreateNotificationRequest(
      recipient: recipient,
      notificationType: NotificationType.system,
      title: title,
      message: message,
      actionUrl: actionUrl,
    );
    return adminCreateNotification(request);
  }

  /// Create payment notification (helper)
  Future<ApiResponse<AppNotification>> createPaymentNotification({
    required String recipient,
    required String title,
    required String message,
    String? actionUrl,
  }) async {
    final request = CreateNotificationRequest(
      recipient: recipient,
      notificationType: NotificationType.paymentReceived,
      title: title,
      message: message,
      actionUrl: actionUrl,
    );
    return adminCreateNotification(request);
  }

  /// Get notifications by type (helper)
  Future<ApiResponse<NotificationListResponse>> getNotificationsByType(
    NotificationType type, {
    bool? isRead,
    NotificationOrdering? ordering,
    int? page,
    int? pageSize,
  }) async {
    return listUserNotifications(
      notificationType: type,
      isRead: isRead,
      ordering: ordering,
      page: page,
      pageSize: pageSize,
    );
  }

  /// Get unread notifications (helper)
  Future<ApiResponse<NotificationListResponse>> getUnreadNotifications({
    NotificationType? notificationType,
    NotificationOrdering? ordering,
    int? page,
    int? pageSize,
  }) async {
    return listUserNotifications(
      notificationType: notificationType,
      isRead: false,
      ordering: ordering,
      page: page,
      pageSize: pageSize,
    );
  }
}

/// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ApiService());
});

/// Provider for notification list
final notificationListProvider =
    FutureProvider.family<NotificationListResponse, Map<String, dynamic>?>(
        (ref, filters) async {
  final notificationService = ref.read(notificationServiceProvider);

  final response = await notificationService.listUserNotifications(
    notificationType: filters?['notificationType'] as NotificationType?,
    isRead: filters?['isRead'] as bool?,
    ordering: filters?['ordering'] as NotificationOrdering?,
    page: filters?['page'] as int?,
    pageSize: filters?['pageSize'] as int?,
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load notifications');
  }
});

/// Provider for unread count
final unreadCountProvider = FutureProvider<UnreadCountResponse>((ref) async {
  final notificationService = ref.read(notificationServiceProvider);

  final response = await notificationService.getUnreadNotificationsCount();

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load unread count');
  }
});

/// Provider for specific notification
final notificationProvider =
    FutureProvider.family<AppNotification, String>((ref, notificationId) async {
  final notificationService = ref.read(notificationServiceProvider);

  final response =
      await notificationService.getNotificationDetails(notificationId);

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load notification');
  }
});
