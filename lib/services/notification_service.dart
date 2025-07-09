import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'api_service.dart';

/// Notification type enumeration
enum NotificationType {
  booking,
  message,
  payment,
  system,
  promotion,
  reminder;

  String get value {
    switch (this) {
      case NotificationType.booking:
        return 'booking';
      case NotificationType.message:
        return 'message';
      case NotificationType.payment:
        return 'payment';
      case NotificationType.system:
        return 'system';
      case NotificationType.promotion:
        return 'promotion';
      case NotificationType.reminder:
        return 'reminder';
    }
  }

  static NotificationType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'booking':
        return NotificationType.booking;
      case 'message':
        return NotificationType.message;
      case 'payment':
        return NotificationType.payment;
      case 'system':
        return NotificationType.system;
      case 'promotion':
        return NotificationType.promotion;
      case 'reminder':
        return NotificationType.reminder;
      default:
        return NotificationType.system;
    }
  }
}

/// Notification priority enumeration
enum NotificationPriority {
  low,
  normal,
  high,
  urgent;

  String get value {
    switch (this) {
      case NotificationPriority.low:
        return 'low';
      case NotificationPriority.normal:
        return 'normal';
      case NotificationPriority.high:
        return 'high';
      case NotificationPriority.urgent:
        return 'urgent';
    }
  }

  static NotificationPriority fromString(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return NotificationPriority.low;
      case 'normal':
        return NotificationPriority.normal;
      case 'high':
        return NotificationPriority.high;
      case 'urgent':
        return NotificationPriority.urgent;
      default:
        return NotificationPriority.normal;
    }
  }
}

/// Notification status enumeration
enum NotificationStatus {
  sent,
  delivered,
  read,
  failed,
  expired;

  String get value {
    switch (this) {
      case NotificationStatus.sent:
        return 'sent';
      case NotificationStatus.delivered:
        return 'delivered';
      case NotificationStatus.read:
        return 'read';
      case NotificationStatus.failed:
        return 'failed';
      case NotificationStatus.expired:
        return 'expired';
    }
  }

  static NotificationStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return NotificationStatus.sent;
      case 'delivered':
        return NotificationStatus.delivered;
      case 'read':
        return NotificationStatus.read;
      case 'failed':
        return NotificationStatus.failed;
      case 'expired':
        return NotificationStatus.expired;
      default:
        return NotificationStatus.sent;
    }
  }
}

/// Notification delivery channel enumeration
enum DeliveryChannel {
  push,
  email,
  sms,
  inApp;

  String get value {
    switch (this) {
      case DeliveryChannel.push:
        return 'push';
      case DeliveryChannel.email:
        return 'email';
      case DeliveryChannel.sms:
        return 'sms';
      case DeliveryChannel.inApp:
        return 'in_app';
    }
  }

  static DeliveryChannel fromString(String channel) {
    switch (channel.toLowerCase()) {
      case 'push':
        return DeliveryChannel.push;
      case 'email':
        return DeliveryChannel.email;
      case 'sms':
        return DeliveryChannel.sms;
      case 'in_app':
        return DeliveryChannel.inApp;
      default:
        return DeliveryChannel.push;
    }
  }
}

/// Notification model
class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;
  final NotificationStatus status;
  final List<DeliveryChannel> channels;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? readAt;
  final DateTime? expiresAt;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;
  final List<NotificationAction>? actions;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.priority,
    required this.status,
    required this.channels,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
    this.expiresAt,
    this.data,
    this.imageUrl,
    this.actionUrl,
    this.actions,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.fromString(json['type'] as String),
      priority: NotificationPriority.fromString(json['priority'] as String),
      status: NotificationStatus.fromString(json['status'] as String),
      channels: (json['channels'] as List)
          .map((channel) => DeliveryChannel.fromString(channel as String))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
      actions: json['actions'] != null
          ? (json['actions'] as List)
              .map((action) => NotificationAction.fromJson(action))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type.value,
      'priority': priority.value,
      'status': status.value,
      'channels': channels.map((channel) => channel.value).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (readAt != null) 'read_at': readAt!.toIso8601String(),
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      if (data != null) 'data': data,
      if (imageUrl != null) 'image_url': imageUrl,
      if (actionUrl != null) 'action_url': actionUrl,
      if (actions != null)
        'actions': actions!.map((action) => action.toJson()).toList(),
    };
  }
}

/// Notification action model
class NotificationAction {
  final String id;
  final String title;
  final String action;
  final Map<String, dynamic>? data;

  const NotificationAction({
    required this.id,
    required this.title,
    required this.action,
    this.data,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) {
    return NotificationAction(
      id: json['id'] as String,
      title: json['title'] as String,
      action: json['action'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'action': action,
      if (data != null) 'data': data,
    };
  }
}

/// Send notification request model
class SendNotificationRequest {
  final String title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;
  final List<DeliveryChannel> channels;
  final List<String>? userIds;
  final DateTime? expiresAt;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;
  final List<NotificationAction>? actions;

  const SendNotificationRequest({
    required this.title,
    required this.body,
    this.type = NotificationType.system,
    this.priority = NotificationPriority.normal,
    this.channels = const [DeliveryChannel.push],
    this.userIds,
    this.expiresAt,
    this.data,
    this.imageUrl,
    this.actionUrl,
    this.actions,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'type': type.value,
      'priority': priority.value,
      'channels': channels.map((channel) => channel.value).toList(),
      if (userIds != null) 'user_ids': userIds,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      if (data != null) 'data': data,
      if (imageUrl != null) 'image_url': imageUrl,
      if (actionUrl != null) 'action_url': actionUrl,
      if (actions != null)
        'actions': actions!.map((action) => action.toJson()).toList(),
    };
  }
}

/// Notification preferences model
class NotificationPreferences {
  final String userId;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final Map<NotificationType, bool> typePreferences;
  final Map<NotificationPriority, bool> priorityPreferences;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final DateTime updatedAt;

  const NotificationPreferences({
    required this.userId,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.smsEnabled,
    required this.typePreferences,
    required this.priorityPreferences,
    this.quietHoursStart,
    this.quietHoursEnd,
    required this.updatedAt,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      userId: json['user_id'] as String,
      pushEnabled: json['push_enabled'] as bool,
      emailEnabled: json['email_enabled'] as bool,
      smsEnabled: json['sms_enabled'] as bool,
      typePreferences: (json['type_preferences'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(NotificationType.fromString(key), value as bool),
      ),
      priorityPreferences:
          (json['priority_preferences'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(NotificationPriority.fromString(key), value as bool),
      ),
      quietHoursStart: json['quiet_hours_start'] as String?,
      quietHoursEnd: json['quiet_hours_end'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'push_enabled': pushEnabled,
      'email_enabled': emailEnabled,
      'sms_enabled': smsEnabled,
      'type_preferences':
          typePreferences.map((key, value) => MapEntry(key.value, value)),
      'priority_preferences':
          priorityPreferences.map((key, value) => MapEntry(key.value, value)),
      if (quietHoursStart != null) 'quiet_hours_start': quietHoursStart,
      if (quietHoursEnd != null) 'quiet_hours_end': quietHoursEnd,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Notification list response model
class NotificationListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<AppNotification> results;

  const NotificationListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationListResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List)
          .map((notification) => AppNotification.fromJson(notification))
          .toList(),
    );
  }
}

/// Device token model for push notifications
class DeviceToken {
  final String token;
  final String platform; // ios, android, web
  final String? deviceId;
  final DateTime registeredAt;

  const DeviceToken({
    required this.token,
    required this.platform,
    this.deviceId,
    required this.registeredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'platform': platform,
      if (deviceId != null) 'device_id': deviceId,
      'registered_at': registeredAt.toIso8601String(),
    };
  }
}

/// Comprehensive Notification Service for Prbal app
/// Handles push notifications, in-app notifications, preferences, and delivery tracking
class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService) {
    debugPrint('🔔 NotificationService: Initializing notification service');
    debugPrint(
        '🔔 NotificationService: Service will handle push notifications, in-app notifications, and preferences');
  }

  // ====================================================================
  // NOTIFICATION MANAGEMENT
  // ====================================================================

  /// List user notifications with filtering and pagination
  /// Endpoint: GET /notifications/
  Future<ApiResponse<NotificationListResponse>> listNotifications({
    NotificationType? type,
    NotificationStatus? status,
    NotificationPriority? priority,
    bool? unreadOnly,
    String? ordering = '-created_at',
    int? limit,
    int? offset,
  }) async {
    final startTime = DateTime.now();
    debugPrint('🔔 NotificationService: Listing notifications');

    final queryParams = <String, String>{};
    if (type != null) {
      queryParams['type'] = type.value;
      debugPrint('🔔 NotificationService: Filtering by type: ${type.value}');
    }
    if (status != null) {
      queryParams['status'] = status.value;
      debugPrint(
          '🔔 NotificationService: Filtering by status: ${status.value}');
    }
    if (priority != null) {
      queryParams['priority'] = priority.value;
      debugPrint(
          '🔔 NotificationService: Filtering by priority: ${priority.value}');
    }
    if (unreadOnly == true) {
      queryParams['unread_only'] = 'true';
      debugPrint('🔔 NotificationService: Showing only unread notifications');
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering;
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }
    if (offset != null) {
      queryParams['offset'] = offset.toString();
    }

    try {
      debugPrint(
          '🔔 NotificationService: Making API call with query params: $queryParams');

      final response = await _apiService.get(
        '/notifications/',
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) => NotificationListResponse.fromJson(data),
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.success && response.data != null) {
        final notifications = response.data!.results;
        debugPrint(
            '🔔 NotificationService: Successfully retrieved ${notifications.length} notifications in ${duration}ms');

        // Count notifications by status for analytics
        final notificationsByStatus = <NotificationStatus, int>{};
        for (final notification in notifications) {
          notificationsByStatus[notification.status] =
              (notificationsByStatus[notification.status] ?? 0) + 1;
        }
        debugPrint(
            '🔔 NotificationService: Notification status breakdown: $notificationsByStatus');

        return response;
      }

      debugPrint(
          '🔔 NotificationService: Failed to fetch notifications - ${response.message}');
      return ApiResponse<NotificationListResponse>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint(
          '🔔 NotificationService: Error fetching notifications (${duration}ms): $e');
      return ApiResponse<NotificationListResponse>(
        success: false,
        message: 'Error fetching notifications: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Get notification details by ID
  /// Endpoint: GET /notifications/{id}/
  Future<ApiResponse<AppNotification>> getNotificationDetails(
      String notificationId) async {
    debugPrint(
        '🔔 NotificationService: Getting notification details for ID: $notificationId');

    try {
      final response = await _apiService.get(
        '/notifications/$notificationId/',
        fromJson: (data) => AppNotification.fromJson(data),
      );

      if (response.success && response.data != null) {
        final notification = response.data!;
        debugPrint(
            '🔔 NotificationService: Successfully retrieved notification: ${notification.title}');
        debugPrint('🔔 NotificationService: Type: ${notification.type.value}');
        debugPrint(
            '🔔 NotificationService: Priority: ${notification.priority.value}');
        debugPrint(
            '🔔 NotificationService: Status: ${notification.status.value}');

        return response;
      }

      debugPrint(
          '🔔 NotificationService: Failed to fetch notification details - ${response.message}');
      return ApiResponse<AppNotification>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint(
          '🔔 NotificationService: Error fetching notification details: $e');
      return ApiResponse<AppNotification>(
        success: false,
        message: 'Error fetching notification details: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Send a notification
  /// Endpoint: POST /notifications/send/
  Future<ApiResponse<AppNotification>> sendNotification(
      SendNotificationRequest request) async {
    debugPrint('🔔 NotificationService: Sending notification');
    debugPrint('🔔 NotificationService: Title: ${request.title}');
    debugPrint('🔔 NotificationService: Type: ${request.type.value}');
    debugPrint('🔔 NotificationService: Priority: ${request.priority.value}');
    debugPrint(
        '🔔 NotificationService: Channels: ${request.channels.map((c) => c.value).join(', ')}');

    if (request.userIds != null) {
      debugPrint(
          '🔔 NotificationService: Target users: ${request.userIds!.length}');
    }

    try {
      final response = await _apiService.post(
        '/notifications/send/',
        body: request.toJson(),
        fromJson: (data) => AppNotification.fromJson(data),
      );

      if (response.success && response.data != null) {
        final notification = response.data!;
        debugPrint(
            '🔔 NotificationService: Notification sent successfully: ${notification.id}');
        debugPrint(
            '🔔 NotificationService: Created at: ${notification.createdAt}');

        return response;
      }

      debugPrint(
          '🔔 NotificationService: Failed to send notification - ${response.message}');
      return ApiResponse<AppNotification>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🔔 NotificationService: Error sending notification: $e');
      return ApiResponse<AppNotification>(
        success: false,
        message: 'Error sending notification: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Mark notification as read
  /// Endpoint: PATCH /notifications/{id}/read/
  Future<ApiResponse<AppNotification>> markNotificationAsRead(
      String notificationId) async {
    debugPrint(
        '🔔 NotificationService: Marking notification as read: $notificationId');

    try {
      final response = await _apiService.patch(
        '/notifications/$notificationId/read/',
        body: {'read_at': DateTime.now().toIso8601String()},
        fromJson: (data) => AppNotification.fromJson(data),
      );

      if (response.success) {
        debugPrint(
            '🔔 NotificationService: Notification marked as read successfully');
      } else {
        debugPrint(
            '🔔 NotificationService: Failed to mark notification as read - ${response.message}');
      }

      return response;
    } catch (e) {
      debugPrint(
          '🔔 NotificationService: Error marking notification as read: $e');
      return ApiResponse<AppNotification>(
        success: false,
        message: 'Error marking notification as read: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Mark all notifications as read
  /// Endpoint: POST /notifications/mark-all-read/
  Future<ApiResponse<Map<String, dynamic>>> markAllNotificationsAsRead() async {
    debugPrint('🔔 NotificationService: Marking all notifications as read');

    try {
      final response = await _apiService.post(
        '/notifications/mark-all-read/',
        body: {'read_at': DateTime.now().toIso8601String()},
        fromJson: (data) => Map<String, dynamic>.from(data as Map),
      );

      if (response.success) {
        final markedCount = response.data?['marked_count'] ?? 0;
        debugPrint(
            '🔔 NotificationService: Marked $markedCount notifications as read');
      } else {
        debugPrint(
            '🔔 NotificationService: Failed to mark all notifications as read - ${response.message}');
      }

      return response;
    } catch (e) {
      debugPrint(
          '🔔 NotificationService: Error marking all notifications as read: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error marking all notifications as read: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Delete a notification
  /// Endpoint: DELETE /notifications/{id}/
  Future<ApiResponse<void>> deleteNotification(String notificationId) async {
    debugPrint(
        '🔔 NotificationService: Deleting notification: $notificationId');

    try {
      final response =
          await _apiService.delete('/notifications/$notificationId/');

      if (response.success) {
        debugPrint('🔔 NotificationService: Notification deleted successfully');
      } else {
        debugPrint(
            '🔔 NotificationService: Failed to delete notification - ${response.message}');
      }

      return ApiResponse<void>(
        success: response.success,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🔔 NotificationService: Error deleting notification: $e');
      return ApiResponse<void>(
        success: false,
        message: 'Error deleting notification: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // PUSH NOTIFICATION MANAGEMENT
  // ====================================================================

  /// Register device token for push notifications
  /// Endpoint: POST /notifications/device-tokens/
  Future<ApiResponse<Map<String, dynamic>>> registerDeviceToken(
      DeviceToken deviceToken) async {
    debugPrint('🔔 NotificationService: Registering device token');
    debugPrint('🔔 NotificationService: Platform: ${deviceToken.platform}');
    debugPrint(
        '🔔 NotificationService: Token length: ${deviceToken.token.length}');

    try {
      final response = await _apiService.post(
        '/notifications/device-tokens/',
        body: deviceToken.toJson(),
        fromJson: (data) => Map<String, dynamic>.from(data as Map),
      );

      if (response.success) {
        debugPrint(
            '🔔 NotificationService: Device token registered successfully');
      } else {
        debugPrint(
            '🔔 NotificationService: Failed to register device token - ${response.message}');
      }

      return response;
    } catch (e) {
      debugPrint('🔔 NotificationService: Error registering device token: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error registering device token: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Unregister device token
  /// Endpoint: DELETE /notifications/device-tokens/{token}/
  Future<ApiResponse<void>> unregisterDeviceToken(String token) async {
    debugPrint('🔔 NotificationService: Unregistering device token');

    try {
      final response =
          await _apiService.delete('/notifications/device-tokens/$token/');

      if (response.success) {
        debugPrint(
            '🔔 NotificationService: Device token unregistered successfully');
      } else {
        debugPrint(
            '🔔 NotificationService: Failed to unregister device token - ${response.message}');
      }

      return ApiResponse<void>(
        success: response.success,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint(
          '🔔 NotificationService: Error unregistering device token: $e');
      return ApiResponse<void>(
        success: false,
        message: 'Error unregistering device token: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // NOTIFICATION PREFERENCES
  // ====================================================================

  /// Get user notification preferences
  /// Endpoint: GET /notifications/preferences/
  Future<ApiResponse<NotificationPreferences>>
      getNotificationPreferences() async {
    debugPrint('🔔 NotificationService: Getting notification preferences');

    try {
      final response = await _apiService.get(
        '/notifications/preferences/',
        fromJson: (data) => NotificationPreferences.fromJson(data),
      );

      if (response.success && response.data != null) {
        final preferences = response.data!;
        debugPrint(
            '🔔 NotificationService: Successfully retrieved preferences');
        debugPrint(
            '🔔 NotificationService: Push enabled: ${preferences.pushEnabled}');
        debugPrint(
            '🔔 NotificationService: Email enabled: ${preferences.emailEnabled}');
        debugPrint(
            '🔔 NotificationService: SMS enabled: ${preferences.smsEnabled}');

        return response;
      }

      debugPrint(
          '🔔 NotificationService: Failed to fetch preferences - ${response.message}');
      return ApiResponse<NotificationPreferences>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🔔 NotificationService: Error fetching preferences: $e');
      return ApiResponse<NotificationPreferences>(
        success: false,
        message: 'Error fetching notification preferences: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Update user notification preferences
  /// Endpoint: PATCH /notifications/preferences/
  Future<ApiResponse<NotificationPreferences>> updateNotificationPreferences(
    Map<String, dynamic> preferences,
  ) async {
    debugPrint('🔔 NotificationService: Updating notification preferences');
    debugPrint('🔔 NotificationService: Preferences: $preferences');

    try {
      final response = await _apiService.patch(
        '/notifications/preferences/',
        body: preferences,
        fromJson: (data) => NotificationPreferences.fromJson(data),
      );

      if (response.success && response.data != null) {
        debugPrint('🔔 NotificationService: Preferences updated successfully');
        return response;
      }

      debugPrint(
          '🔔 NotificationService: Failed to update preferences - ${response.message}');
      return ApiResponse<NotificationPreferences>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🔔 NotificationService: Error updating preferences: $e');
      return ApiResponse<NotificationPreferences>(
        success: false,
        message: 'Error updating notification preferences: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // UTILITY AND HELPER METHODS
  // ====================================================================

  /// Get unread notification count
  Future<int> getUnreadNotificationCount() async {
    debugPrint('🔔 NotificationService: Getting unread notification count');

    try {
      final response = await listNotifications(unreadOnly: true, limit: 1);

      if (response.success && response.data != null) {
        final unreadCount = response.data!.count;
        debugPrint(
            '🔔 NotificationService: Unread notifications: $unreadCount');
        return unreadCount;
      }
    } catch (e) {
      debugPrint('🔔 NotificationService: Error getting unread count: $e');
    }

    return 0;
  }

  /// Get notification statistics for analytics
  Future<Map<String, dynamic>> getNotificationStatistics() async {
    debugPrint('🔔 NotificationService: Generating notification statistics');

    try {
      final notificationsResponse = await listNotifications();

      if (notificationsResponse.success && notificationsResponse.data != null) {
        final notifications = notificationsResponse.data!.results;
        final stats = {
          'total_notifications': notifications.length,
          'unread_count': notifications.where((n) => n.readAt == null).length,
          'by_type': <String, int>{},
          'by_priority': <String, int>{},
          'by_status': <String, int>{},
          'last_notification': notifications.isNotEmpty
              ? notifications
                  .map((n) => n.createdAt)
                  .reduce((a, b) => a.isAfter(b) ? a : b)
                  .toIso8601String()
              : null,
        };

        // Group by type, priority, and status
        for (final notification in notifications) {
          final type = notification.type.value;
          final priority = notification.priority.value;
          final status = notification.status.value;

          final byType = stats['by_type'] as Map<String, int>;
          byType[type] = (byType[type] ?? 0) + 1;

          final byPriority = stats['by_priority'] as Map<String, int>;
          byPriority[priority] = (byPriority[priority] ?? 0) + 1;

          final byStatus = stats['by_status'] as Map<String, int>;
          byStatus[status] = (byStatus[status] ?? 0) + 1;
        }

        debugPrint('🔔 NotificationService: Statistics generated successfully');
        debugPrint(
            '🔔 NotificationService: Total notifications: ${stats['total_notifications']}');
        debugPrint(
            '🔔 NotificationService: Unread count: ${stats['unread_count']}');

        return stats;
      }
    } catch (e) {
      debugPrint('🔔 NotificationService: Error generating statistics: $e');
    }

    return {'error': 'Failed to generate statistics'};
  }

  /// Check notification service health
  Future<Map<String, dynamic>> checkNotificationHealth() async {
    debugPrint('🔔 NotificationService: Performing health check');

    final startTime = DateTime.now();
    try {
      // Test basic functionality by fetching notification preferences
      final response = await getNotificationPreferences();
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      final healthStatus = {
        'service': 'Notifications',
        'status': response.success ? 'healthy' : 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': response.success ? null : response.message,
      };

      debugPrint('🔔 NotificationService: Health check completed');
      debugPrint('🔔 NotificationService: Status: ${healthStatus['status']}');
      debugPrint('🔔 NotificationService: Response time: ${duration}ms');

      return healthStatus;
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🔔 NotificationService: Health check failed: $e');

      return {
        'service': 'Notifications',
        'status': 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': 'Health check failed: $e',
      };
    }
  }

  /// Send booking-related notification
  Future<ApiResponse<AppNotification>> sendBookingNotification({
    required String title,
    required String body,
    required String bookingId,
    String? userId,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    debugPrint(
        '🔔 NotificationService: Sending booking notification for booking: $bookingId');

    final request = SendNotificationRequest(
      title: title,
      body: body,
      type: NotificationType.booking,
      priority: priority,
      channels: [DeliveryChannel.push, DeliveryChannel.inApp],
      userIds: userId != null ? [userId] : null,
      data: {'booking_id': bookingId, 'action': 'view_booking'},
      actionUrl: '/bookings/$bookingId',
    );

    return await sendNotification(request);
  }

  /// Send payment-related notification
  Future<ApiResponse<AppNotification>> sendPaymentNotification({
    required String title,
    required String body,
    required String paymentId,
    String? userId,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    debugPrint(
        '🔔 NotificationService: Sending payment notification for payment: $paymentId');

    final request = SendNotificationRequest(
      title: title,
      body: body,
      type: NotificationType.payment,
      priority: priority,
      channels: [
        DeliveryChannel.push,
        DeliveryChannel.email,
        DeliveryChannel.inApp
      ],
      userIds: userId != null ? [userId] : null,
      data: {'payment_id': paymentId, 'action': 'view_payment'},
      actionUrl: '/payments/$paymentId',
    );

    return await sendNotification(request);
  }

  /// Send promotional notification
  Future<ApiResponse<AppNotification>> sendPromotionalNotification({
    required String title,
    required String body,
    String? imageUrl,
    String? actionUrl,
    List<String>? targetUserIds,
  }) async {
    debugPrint('🔔 NotificationService: Sending promotional notification');

    final request = SendNotificationRequest(
      title: title,
      body: body,
      type: NotificationType.promotion,
      priority: NotificationPriority.low,
      channels: [DeliveryChannel.push, DeliveryChannel.inApp],
      userIds: targetUserIds,
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      data: {'promotion': true},
    );

    return await sendNotification(request);
  }

  /// Create notification action buttons
  List<NotificationAction> createActionButtons({
    bool includeView = true,
    bool includeReply = false,
    bool includeAccept = false,
    bool includeReject = false,
  }) {
    final actions = <NotificationAction>[];

    if (includeView) {
      actions.add(const NotificationAction(
        id: 'view',
        title: 'View',
        action: 'view_details',
      ));
    }

    if (includeReply) {
      actions.add(const NotificationAction(
        id: 'reply',
        title: 'Reply',
        action: 'quick_reply',
      ));
    }

    if (includeAccept) {
      actions.add(const NotificationAction(
        id: 'accept',
        title: 'Accept',
        action: 'accept_request',
      ));
    }

    if (includeReject) {
      actions.add(const NotificationAction(
        id: 'reject',
        title: 'Reject',
        action: 'reject_request',
      ));
    }

    return actions;
  }

  /// Get notification icon based on type and priority
  IconData getNotificationIcon(
      NotificationType type, NotificationPriority priority) {
    switch (type) {
      case NotificationType.booking:
        return Prbal.calendar9;
      case NotificationType.message:
        return Prbal.message;
      case NotificationType.payment:
        return Prbal.wallet3;
      case NotificationType.system:
        return Prbal.info;
      case NotificationType.promotion:
        return Prbal.localOffer;
      case NotificationType.reminder:
        return Prbal.alarm;
    }
  }

  /// Get notification color based on priority
  Color getNotificationColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return const Color(0xFF9E9E9E); // Grey
      case NotificationPriority.normal:
        return const Color(0xFF2196F3); // Blue
      case NotificationPriority.high:
        return const Color(0xFFFF9800); // Orange
      case NotificationPriority.urgent:
        return const Color(0xFFF44336); // Red
    }
  }
}
