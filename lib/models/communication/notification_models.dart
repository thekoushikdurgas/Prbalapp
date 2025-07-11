import 'package:flutter/foundation.dart';

// ===== ENUMS =====

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
        debugPrint('⚠️ Unknown notification type: $type, defaulting to system');
        return NotificationType.system;
    }
  }

  /// Get notification type display text
  String get displayText {
    switch (this) {
      case NotificationType.booking:
        return 'Booking';
      case NotificationType.message:
        return 'Message';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.system:
        return 'System';
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.reminder:
        return 'Reminder';
    }
  }

  @override
  String toString() =>
      'NotificationType.$name(value: $value, display: $displayText)';
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
        debugPrint(
            '⚠️ Unknown notification priority: $priority, defaulting to normal');
        return NotificationPriority.normal;
    }
  }

  /// Get priority color for UI
  String get color {
    switch (this) {
      case NotificationPriority.low:
        return '#9E9E9E'; // Grey
      case NotificationPriority.normal:
        return '#2196F3'; // Blue
      case NotificationPriority.high:
        return '#FF9800'; // Orange
      case NotificationPriority.urgent:
        return '#F44336'; // Red
    }
  }

  /// Get priority display text
  String get displayText {
    switch (this) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  @override
  String toString() =>
      'NotificationPriority.$name(value: $value, display: $displayText, color: $color)';
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
        debugPrint(
            '⚠️ Unknown notification status: $status, defaulting to sent');
        return NotificationStatus.sent;
    }
  }

  /// Get status display text
  String get displayText {
    switch (this) {
      case NotificationStatus.sent:
        return 'Sent';
      case NotificationStatus.delivered:
        return 'Delivered';
      case NotificationStatus.read:
        return 'Read';
      case NotificationStatus.failed:
        return 'Failed';
      case NotificationStatus.expired:
        return 'Expired';
    }
  }

  @override
  String toString() =>
      'NotificationStatus.$name(value: $value, display: $displayText)';
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
        debugPrint('⚠️ Unknown delivery channel: $channel, defaulting to push');
        return DeliveryChannel.push;
    }
  }

  /// Get channel display text
  String get displayText {
    switch (this) {
      case DeliveryChannel.push:
        return 'Push Notification';
      case DeliveryChannel.email:
        return 'Email';
      case DeliveryChannel.sms:
        return 'SMS';
      case DeliveryChannel.inApp:
        return 'In-App';
    }
  }

  @override
  String toString() =>
      'DeliveryChannel.$name(value: $value, display: $displayText)';
}

// ===== MAIN MODELS =====

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
    try {
      debugPrint(
          '🔔 Parsing NotificationAction from JSON: ${json.keys.join(', ')}');

      return NotificationAction(
        id: json['id'] as String,
        title: json['title'] as String,
        action: json['action'] as String,
        data: json['data'] as Map<String, dynamic>?,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing NotificationAction from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'title': title,
      'action': action,
      if (data != null) 'data': data,
    };

    debugPrint('📤 NotificationAction toJson: ${json.keys.join(', ')}');
    return json;
  }

  @override
  String toString() =>
      'NotificationAction(id: $id, title: $title, action: $action)';
}

/// App notification model
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
    try {
      debugPrint(
          '🔔 Parsing AppNotification from JSON: ${json.keys.join(', ')}');

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
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing AppNotification from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
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

    debugPrint('📤 AppNotification toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Check if notification is read
  bool get isRead => readAt != null;

  /// Check if notification is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if notification is unread
  bool get isUnread => !isRead && !isExpired;

  /// Get formatted creation date
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formattedDate;
    }
  }

  @override
  String toString() =>
      'AppNotification(id: $id, title: $title, type: ${type.displayText}, priority: ${priority.displayText}, status: ${status.displayText})';
}

// ===== REQUEST MODELS =====

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
    final json = {
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

    debugPrint('📤 SendNotificationRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  @override
  String toString() =>
      'SendNotificationRequest(title: $title, type: ${type.displayText}, priority: ${priority.displayText}, channels: ${channels.length})';
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
    try {
      debugPrint(
          '🔔 Parsing NotificationPreferences from JSON: ${json.keys.join(', ')}');

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
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing NotificationPreferences from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
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

    debugPrint('📤 NotificationPreferences toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Check if specific notification type is enabled
  bool isTypeEnabled(NotificationType type) {
    return typePreferences[type] ?? true;
  }

  /// Check if specific priority is enabled
  bool isPriorityEnabled(NotificationPriority priority) {
    return priorityPreferences[priority] ?? true;
  }

  /// Check if in quiet hours
  bool get isInQuietHours {
    if (quietHoursStart == null || quietHoursEnd == null) return false;

    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return currentTime.compareTo(quietHoursStart!) >= 0 &&
        currentTime.compareTo(quietHoursEnd!) <= 0;
  }

  @override
  String toString() =>
      'NotificationPreferences(userId: $userId, push: $pushEnabled, email: $emailEnabled, sms: $smsEnabled)';
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

  factory DeviceToken.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('🔔 Parsing DeviceToken from JSON: ${json.keys.join(', ')}');

      return DeviceToken(
        token: json['token'] as String,
        platform: json['platform'] as String,
        deviceId: json['device_id'] as String?,
        registeredAt: DateTime.parse(json['registered_at'] as String),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing DeviceToken from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
      'token': token,
      'platform': platform,
      if (deviceId != null) 'device_id': deviceId,
      'registered_at': registeredAt.toIso8601String(),
    };

    debugPrint('📤 DeviceToken toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Check if token is for iOS
  bool get isIOS => platform.toLowerCase() == 'ios';

  /// Check if token is for Android
  bool get isAndroid => platform.toLowerCase() == 'android';

  /// Check if token is for Web
  bool get isWeb => platform.toLowerCase() == 'web';

  @override
  String toString() =>
      'DeviceToken(platform: $platform, deviceId: $deviceId, registeredAt: ${registeredAt.toIso8601String()})';
}

// ===== RESPONSE MODELS =====

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
    try {
      debugPrint(
          '🔔 Parsing NotificationListResponse from JSON: count=${json['count']}, results_length=${(json['results'] as List?)?.length ?? 0}');

      return NotificationListResponse(
        count: json['count'] as int,
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List? ?? [])
            .map((notification) =>
                AppNotification.fromJson(notification as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing NotificationListResponse from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
      'count': count,
      if (next != null) 'next': next,
      if (previous != null) 'previous': previous,
      'results': results.map((notification) => notification.toJson()).toList(),
    };

    debugPrint(
        '📤 NotificationListResponse toJson: count=$count, results_length=${results.length}');
    return json;
  }

  /// Check if there are more pages
  bool get hasNext => next != null && next!.isNotEmpty;

  /// Check if there are previous pages
  bool get hasPrevious => previous != null && previous!.isNotEmpty;

  /// Get unread notifications
  List<AppNotification> get unreadNotifications =>
      results.where((n) => n.isUnread).toList();

  /// Get read notifications
  List<AppNotification> get readNotifications =>
      results.where((n) => n.isRead).toList();

  /// Get notifications by type
  List<AppNotification> getNotificationsByType(NotificationType type) {
    return results.where((n) => n.type == type).toList();
  }

  /// Get notifications by priority
  List<AppNotification> getNotificationsByPriority(
      NotificationPriority priority) {
    return results.where((n) => n.priority == priority).toList();
  }

  /// Get unread count
  int get unreadCount => unreadNotifications.length;

  /// Get notification statistics
  Map<String, dynamic> get statistics {
    final stats = <String, dynamic>{
      'total_notifications': results.length,
      'unread_count': unreadCount,
      'read_count': readNotifications.length,
      'by_type': <String, int>{},
      'by_priority': <String, int>{},
      'by_status': <String, int>{},
    };

    // Group by type, priority, and status
    for (final notification in results) {
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

    return stats;
  }

  @override
  String toString() =>
      'NotificationListResponse(count: $count, results: ${results.length}, unread: $unreadCount, hasNext: $hasNext)';
}
