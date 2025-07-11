// import 'dart:async';
// import 'package:flutter/material.dart';
// // import 'package:prbal/models/auth/user_type.dart';
// import 'package:prbal/models/core/api_models.dart';
// import 'package:prbal/models/communication/notification_models.dart';
// import 'package:prbal/utils/icon/prbal_icons.dart';
// import 'package:prbal/services/api_service.dart';

// /// Comprehensive Notification Service for Prbal app
// /// Handles push notifications, in-app notifications, preferences, and delivery tracking
// class NotificationService {
//   final ApiService _apiService;

//   NotificationService(this._apiService) {
//     debugPrint('🔔 NotificationService: Initializing notification service');
//     debugPrint('🔔 NotificationService: Service will handle push notifications, in-app notifications, and preferences');
//   }

//   // ====================================================================
//   // NOTIFICATION MANAGEMENT
//   // ====================================================================

//   /// List user notifications with filtering and pagination
//   /// Endpoint: GET /notifications/
//   Future<ApiResponse<NotificationListResponse>> listNotifications({
//     NotificationType? type,
//     NotificationStatus? status,
//     NotificationPriority? priority,
//     bool? unreadOnly,
//     String? ordering = '-created_at',
//     int? limit,
//     int? offset,
//   }) async {
//     final startTime = DateTime.now();
//     debugPrint('🔔 NotificationService: Listing notifications');

//     final queryParams = <String, String>{};
//     if (type != null) {
//       queryParams['type'] = type.value;
//       debugPrint('🔔 NotificationService: Filtering by type: ${type.value}');
//     }
//     if (status != null) {
//       queryParams['status'] = status.value;
//       debugPrint('🔔 NotificationService: Filtering by status: ${status.value}');
//     }
//     if (priority != null) {
//       queryParams['priority'] = priority.value;
//       debugPrint('🔔 NotificationService: Filtering by priority: ${priority.value}');
//     }
//     if (unreadOnly == true) {
//       queryParams['unread_only'] = 'true';
//       debugPrint('🔔 NotificationService: Showing only unread notifications');
//     }
//     if (ordering != null) {
//       queryParams['ordering'] = ordering;
//     }
//     if (limit != null) {
//       queryParams['limit'] = limit.toString();
//     }
//     if (offset != null) {
//       queryParams['offset'] = offset.toString();
//     }

//     try {
//       debugPrint('🔔 NotificationService: Making API call with query params: $queryParams');

//       final response = await _apiService.get(
//         '/notifications/',
//         queryParams: queryParams.isNotEmpty ? queryParams : null,
//         fromJson: (data) => NotificationListResponse.fromJson(data),
//       );

//       final duration = DateTime.now().difference(startTime).inMilliseconds;

//       if (response.success && response.data != null) {
//         final notifications = response.data!.results;
//         debugPrint(
//             '🔔 NotificationService: Successfully retrieved ${notifications.length} notifications in ${duration}ms');

//         // Count notifications by status for analytics
//         final notificationsByStatus = <NotificationStatus, int>{};
//         for (final notification in notifications) {
//           notificationsByStatus[notification.status] = (notificationsByStatus[notification.status] ?? 0) + 1;
//         }
//         debugPrint('🔔 NotificationService: Notification status breakdown: $notificationsByStatus');

//         return response;
//       }

//       debugPrint('🔔 NotificationService: Failed to fetch notifications - ${response.message}');
//       return ApiResponse<NotificationListResponse>(
//         success: false,
//         message: response.message,
//         statusCode: response.statusCode,
//         time: DateTime.now(),
//       );
//     } catch (e) {
//       final duration = DateTime.now().difference(startTime).inMilliseconds;
//       debugPrint('🔔 NotificationService: Error fetching notifications (${duration}ms): $e');
//       return ApiResponse<NotificationListResponse>(
//         success: false,
//         message: 'Error fetching notifications: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   /// Get notification details by ID
//   /// Endpoint: GET /notifications/{id}/
//   Future<ApiResponse<AppNotification>> getNotificationDetails(String notificationId) async {
//     debugPrint('🔔 NotificationService: Getting notification details for ID: $notificationId');

//     try {
//       final response = await _apiService.get(
//         '/notifications/$notificationId/',
//         fromJson: (data) => AppNotification.fromJson(data),
//       );

//       if (response.success && response.data != null) {
//         final notification = response.data!;
//         debugPrint('🔔 NotificationService: Successfully retrieved notification: ${notification.title}');
//         debugPrint('🔔 NotificationService: Type: ${notification.type.value}');
//         debugPrint('🔔 NotificationService: Priority: ${notification.priority.value}');
//         debugPrint('🔔 NotificationService: Status: ${notification.status.value}');

//         return response;
//       }

//       debugPrint('🔔 NotificationService: Failed to fetch notification details - ${response.message}');
//       return ApiResponse<AppNotification>(
//         success: false,
//         message: response.message,
//         statusCode: response.statusCode,
//         time: DateTime.now(),
//       );
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error fetching notification details: $e');
//       return ApiResponse<AppNotification>(
//         success: false,
//         message: 'Error fetching notification details: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   /// Send a notification
//   /// Endpoint: POST /notifications/send/
//   Future<ApiResponse<AppNotification>> sendNotification(SendNotificationRequest request) async {
//     debugPrint('🔔 NotificationService: Sending notification');
//     debugPrint('🔔 NotificationService: Title: ${request.title}');
//     debugPrint('🔔 NotificationService: Type: ${request.type.value}');
//     debugPrint('🔔 NotificationService: Priority: ${request.priority.value}');
//     debugPrint('🔔 NotificationService: Channels: ${request.channels.map((c) => c.value).join(', ')}');

//     if (request.userIds != null) {
//       debugPrint('🔔 NotificationService: Target users: ${request.userIds!.length}');
//     }

//     try {
//       final response = await _apiService.post(
//         '/notifications/send/',
//         body: request.toJson(),
//         fromJson: (data) => AppNotification.fromJson(data),
//       );

//       if (response.success && response.data != null) {
//         final notification = response.data!;
//         debugPrint('🔔 NotificationService: Notification sent successfully: ${notification.id}');
//         debugPrint('🔔 NotificationService: Created at: ${notification.createdAt}');

//         return response;
//       }

//       debugPrint('🔔 NotificationService: Failed to send notification - ${response.message}');
//       return ApiResponse<AppNotification>(
//         success: false,
//         message: response.message,
//         statusCode: response.statusCode,
//         time: DateTime.now(),
//       );
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error sending notification: $e');
//       return ApiResponse<AppNotification>(
//         success: false,
//         message: 'Error sending notification: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   /// Mark notification as read
//   /// Endpoint: PATCH /notifications/{id}/read/
//   Future<ApiResponse<AppNotification>> markNotificationAsRead(String notificationId) async {
//     debugPrint('🔔 NotificationService: Marking notification as read: $notificationId');

//     try {
//       final response = await _apiService.patch(
//         '/notifications/$notificationId/read/',
//         body: {'read_at': DateTime.now().toIso8601String()},
//         fromJson: (data) => AppNotification.fromJson(data),
//       );

//       if (response.success) {
//         debugPrint('🔔 NotificationService: Notification marked as read successfully');
//       } else {
//         debugPrint('🔔 NotificationService: Failed to mark notification as read - ${response.message}');
//       }

//       return response;
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error marking notification as read: $e');
//       return ApiResponse<AppNotification>(
//         success: false,
//         message: 'Error marking notification as read: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   /// Mark all notifications as read
//   /// Endpoint: POST /notifications/mark-all-read/
//   Future<ApiResponse<Map<String, dynamic>>> markAllNotificationsAsRead() async {
//     debugPrint('🔔 NotificationService: Marking all notifications as read');

//     try {
//       final response = await _apiService.post(
//         '/notifications/mark-all-read/',
//         body: {'read_at': DateTime.now().toIso8601String()},
//         fromJson: (data) => Map<String, dynamic>.from(data as Map),
//       );

//       if (response.success) {
//         final markedCount = response.data?['marked_count'] ?? 0;
//         debugPrint('🔔 NotificationService: Marked $markedCount notifications as read');
//       } else {
//         debugPrint('🔔 NotificationService: Failed to mark all notifications as read - ${response.message}');
//       }

//       return response;
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error marking all notifications as read: $e');
//       return ApiResponse<Map<String, dynamic>>(
//         success: false,
//         message: 'Error marking all notifications as read: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   /// Delete a notification
//   /// Endpoint: DELETE /notifications/{id}/
//   Future<ApiResponse<void>> deleteNotification(String notificationId) async {
//     debugPrint('🔔 NotificationService: Deleting notification: $notificationId');

//     try {
//       final response = await _apiService.delete('/notifications/$notificationId/');

//       if (response.success) {
//         debugPrint('🔔 NotificationService: Notification deleted successfully');
//       } else {
//         debugPrint('🔔 NotificationService: Failed to delete notification - ${response.message}');
//       }

//       return ApiResponse<void>(
//         success: response.success,
//         message: response.message,
//         statusCode: response.statusCode,
//         time: DateTime.now(),
//       );
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error deleting notification: $e');
//       return ApiResponse<void>(
//         success: false,
//         message: 'Error deleting notification: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   // ====================================================================
//   // PUSH NOTIFICATION MANAGEMENT
//   // ====================================================================

//   /// Register device token for push notifications
//   /// Endpoint: POST /notifications/device-tokens/
//   Future<ApiResponse<Map<String, dynamic>>> registerDeviceToken(DeviceToken deviceToken) async {
//     debugPrint('🔔 NotificationService: Registering device token');
//     debugPrint('🔔 NotificationService: Platform: ${deviceToken.platform}');
//     debugPrint('🔔 NotificationService: Token length: ${deviceToken.token.length}');

//     try {
//       final response = await _apiService.post(
//         '/notifications/device-tokens/',
//         body: deviceToken.toJson(),
//         fromJson: (data) => Map<String, dynamic>.from(data as Map),
//       );

//       if (response.success) {
//         debugPrint('🔔 NotificationService: Device token registered successfully');
//       } else {
//         debugPrint('🔔 NotificationService: Failed to register device token - ${response.message}');
//       }

//       return response;
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error registering device token: $e');
//       return ApiResponse<Map<String, dynamic>>(
//         success: false,
//         message: 'Error registering device token: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   /// Unregister device token
//   /// Endpoint: DELETE /notifications/device-tokens/{token}/
//   Future<ApiResponse<void>> unregisterDeviceToken(String token) async {
//     debugPrint('🔔 NotificationService: Unregistering device token');

//     try {
//       final response = await _apiService.delete('/notifications/device-tokens/$token/');

//       if (response.success) {
//         debugPrint('🔔 NotificationService: Device token unregistered successfully');
//       } else {
//         debugPrint('🔔 NotificationService: Failed to unregister device token - ${response.message}');
//       }

//       return ApiResponse<void>(
//         success: response.success,
//         message: response.message,
//         statusCode: response.statusCode,
//         time: DateTime.now(),
//       );
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error unregistering device token: $e');
//       return ApiResponse<void>(
//         success: false,
//         message: 'Error unregistering device token: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   // ====================================================================
//   // NOTIFICATION PREFERENCES
//   // ====================================================================

//   /// Get user notification preferences
//   /// Endpoint: GET /notifications/preferences/
//   Future<ApiResponse<NotificationPreferences>> getNotificationPreferences() async {
//     debugPrint('🔔 NotificationService: Getting notification preferences');

//     try {
//       final response = await _apiService.get(
//         '/notifications/preferences/',
//         fromJson: (data) => NotificationPreferences.fromJson(data),
//       );

//       if (response.success && response.data != null) {
//         final preferences = response.data!;
//         debugPrint('🔔 NotificationService: Successfully retrieved preferences');
//         debugPrint('🔔 NotificationService: Push enabled: ${preferences.pushEnabled}');
//         debugPrint('🔔 NotificationService: Email enabled: ${preferences.emailEnabled}');
//         debugPrint('🔔 NotificationService: SMS enabled: ${preferences.smsEnabled}');

//         return response;
//       }

//       debugPrint('🔔 NotificationService: Failed to fetch preferences - ${response.message}');
//       return ApiResponse<NotificationPreferences>(
//         success: false,
//         message: response.message,
//         statusCode: response.statusCode,
//         time: DateTime.now(),
//       );
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error fetching preferences: $e');
//       return ApiResponse<NotificationPreferences>(
//         success: false,
//         message: 'Error fetching notification preferences: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   /// Update user notification preferences
//   /// Endpoint: PATCH /notifications/preferences/
//   Future<ApiResponse<NotificationPreferences>> updateNotificationPreferences(
//     Map<String, dynamic> preferences,
//   ) async {
//     debugPrint('🔔 NotificationService: Updating notification preferences');
//     debugPrint('🔔 NotificationService: Preferences: $preferences');

//     try {
//       final response = await _apiService.patch(
//         '/notifications/preferences/',
//         body: preferences,
//         fromJson: (data) => NotificationPreferences.fromJson(data),
//       );

//       if (response.success && response.data != null) {
//         final updatedPreferences = response.data!;
//         debugPrint('🔔 NotificationService: Preferences updated successfully');
//         debugPrint('🔔 NotificationService: Push enabled: ${updatedPreferences.pushEnabled}');
//         debugPrint('🔔 NotificationService: Email enabled: ${updatedPreferences.emailEnabled}');
//         debugPrint('🔔 NotificationService: SMS enabled: ${updatedPreferences.smsEnabled}');

//         return response;
//       }

//       debugPrint('🔔 NotificationService: Failed to update preferences - ${response.message}');
//       return ApiResponse<NotificationPreferences>(
//         success: false,
//         message: response.message,
//         statusCode: response.statusCode,
//         time: DateTime.now(),
//       );
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error updating preferences: $e');
//       return ApiResponse<NotificationPreferences>(
//         success: false,
//         message: 'Error updating notification preferences: $e',
//         statusCode: 500,
//         time: DateTime.now(),
//       );
//     }
//   }

//   // ====================================================================
//   // NOTIFICATION ANALYTICS AND STATISTICS
//   // ====================================================================

//   /// Get unread notification count
//   /// Endpoint: GET /notifications/unread-count/
//   Future<int> getUnreadNotificationCount() async {
//     debugPrint('🔔 NotificationService: Getting unread notification count');

//     try {
//       final response = await listNotifications(
//         unreadOnly: true,
//         limit: 1, // We only need the count, not the actual notifications
//       );

//       if (response.success && response.data != null) {
//         final unreadCount = response.data!.count;
//         debugPrint('🔔 NotificationService: Unread notifications: $unreadCount');
//         return unreadCount;
//       }

//       debugPrint('🔔 NotificationService: Failed to get unread count - ${response.message}');
//       return 0;
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error getting unread count: $e');
//       return 0;
//     }
//   }

//   /// Get notification statistics
//   /// Returns various statistics about user notifications
//   Future<Map<String, dynamic>?> getNotificationStatistics() async {
//     debugPrint('🔔 NotificationService: Getting notification statistics');

//     try {
//       final response = await listNotifications(limit: 100); // Get recent notifications

//       if (response.success && response.data != null) {
//         final notifications = response.data!.results;

//         final stats = <String, dynamic>{
//           'total_notifications': notifications.length,
//           'unread_count': notifications.where((n) => n.isUnread).length,
//           'read_count': notifications.where((n) => n.isRead).length,
//           'by_type': <String, int>{},
//           'by_priority': <String, int>{},
//           'by_status': <String, int>{},
//           'last_notification': notifications.isNotEmpty
//               ? notifications.map((n) => n.createdAt).reduce((a, b) => a.isAfter(b) ? a : b).toIso8601String()
//               : null,
//         };

//         // Group by type, priority, and status
//         for (final notification in notifications) {
//           final type = notification.type.value;
//           final priority = notification.priority.value;
//           final status = notification.status.value;

//           final byType = stats['by_type'] as Map<String, int>;
//           byType[type] = (byType[type] ?? 0) + 1;

//           final byPriority = stats['by_priority'] as Map<String, int>;
//           byPriority[priority] = (byPriority[priority] ?? 0) + 1;

//           final byStatus = stats['by_status'] as Map<String, int>;
//           byStatus[status] = (byStatus[status] ?? 0) + 1;
//         }

//         debugPrint('🔔 NotificationService: Statistics generated successfully');
//         debugPrint('🔔 NotificationService: Total notifications: ${stats['total_notifications']}');
//         debugPrint('🔔 NotificationService: Unread count: ${stats['unread_count']}');

//         return stats;
//       }

//       debugPrint('🔔 NotificationService: Failed to get statistics - ${response.message}');
//       return null;
//     } catch (e) {
//       debugPrint('🔔 NotificationService: Error getting statistics: $e');
//       return null;
//     }
//   }

//   // ====================================================================
//   // NOTIFICATION HELPERS AND UTILITIES
//   // ====================================================================

//   /// Send booking-related notification
//   Future<ApiResponse<AppNotification>> sendBookingNotification({
//     required String title,
//     required String body,
//     required String bookingId,
//     String? userId,
//     NotificationPriority priority = NotificationPriority.normal,
//   }) async {
//     debugPrint('🔔 NotificationService: Sending booking notification for booking: $bookingId');

//     final request = SendNotificationRequest(
//       title: title,
//       body: body,
//       type: NotificationType.booking,
//       priority: priority,
//       channels: [DeliveryChannel.push, DeliveryChannel.inApp],
//       userIds: userId != null ? [userId] : null,
//       data: {'booking_id': bookingId, 'action': 'view_booking'},
//     );

//     return sendNotification(request);
//   }

//   /// Send payment-related notification
//   Future<ApiResponse<AppNotification>> sendPaymentNotification({
//     required String title,
//     required String body,
//     required String paymentId,
//     String? userId,
//     NotificationPriority priority = NotificationPriority.high,
//   }) async {
//     debugPrint('🔔 NotificationService: Sending payment notification for payment: $paymentId');

//     final request = SendNotificationRequest(
//       title: title,
//       body: body,
//       type: NotificationType.payment,
//       priority: priority,
//       channels: [DeliveryChannel.push, DeliveryChannel.email, DeliveryChannel.inApp],
//       userIds: userId != null ? [userId] : null,
//       data: {'payment_id': paymentId, 'action': 'view_payment'},
//     );

//     return sendNotification(request);
//   }

//   /// Send promotional notification
//   Future<ApiResponse<AppNotification>> sendPromotionalNotification({
//     required String title,
//     required String body,
//     String? imageUrl,
//     String? actionUrl,
//     List<String>? targetUserIds,
//     NotificationPriority priority = NotificationPriority.low,
//   }) async {
//     debugPrint('🔔 NotificationService: Sending promotional notification');

//     final request = SendNotificationRequest(
//       title: title,
//       body: body,
//       type: NotificationType.promotion,
//       priority: priority,
//       channels: [DeliveryChannel.push, DeliveryChannel.email, DeliveryChannel.inApp],
//       userIds: targetUserIds,
//       imageUrl: imageUrl,
//       actionUrl: actionUrl,
//       data: {'action': 'view_promotion'},
//     );

//     return sendNotification(request);
//   }

//   /// Get notification icon based on type and priority
//   IconData getNotificationIcon(NotificationType type, NotificationPriority priority) {
//     switch (type) {
//       case NotificationType.booking:
//         return Prbal.calendar;
//       case NotificationType.message:
//         return Prbal.message;
//       case NotificationType.payment:
//         return Prbal.creditCard;
//       case NotificationType.system:
//         return priority == NotificationPriority.urgent ? Prbal.exclamationTriangle : Prbal.info;
//       case NotificationType.promotion:
//         return Prbal.tag;
//       case NotificationType.reminder:
//         return Prbal.bell;
//     }
//   }

//   /// Get notification color based on type and priority
//   Color getNotificationColor(NotificationType type, NotificationPriority priority) {
//     switch (priority) {
//       case NotificationPriority.urgent:
//         return Colors.red;
//       case NotificationPriority.high:
//         return Colors.orange;
//       case NotificationPriority.normal:
//         return Colors.blue;
//       case NotificationPriority.low:
//         return Colors.grey;
//     }
//   }
// }
