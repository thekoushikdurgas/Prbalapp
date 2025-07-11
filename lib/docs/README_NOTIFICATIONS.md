# Prbal Notification APIs Documentation

This document provides comprehensive documentation for all notification APIs available in the Prbal application, based on the Postman collection.

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Core Notification Endpoints](#core-notification-endpoints)
4. [Provider Notifications](#provider-notifications)
5. [Customer Notifications](#customer-notifications)
6. [Admin Notifications](#admin-notifications)
7. [Real-time Notifications (WebSocket)](#real-time-notifications-websocket)
8. [Flutter Integration](#flutter-integration)
9. [Error Handling](#error-handling)
10. [Examples](#examples)

## Overview

The Prbal notification system supports multiple user types (providers, customers, admins) with role-specific notification filtering, real-time WebSocket communication, and comprehensive notification management features.

### Base URL
- **HTTP API**: `{{base_url}}/api/{{api_version}}/notifications/`
- **WebSocket**: `{{base_url_ws}}/ws/notifications/`

### Notification Types
- `bid_received` - New bid notifications for providers
- `bid_accepted` - Bid acceptance notifications for customers
- `bid_rejected` - Bid rejection notifications for customers
- `booking_created` - New booking notifications for providers
- `booking_status_updated` - Booking status updates for customers
- `payment_received` - Payment confirmation notifications for providers
- `system` - System-wide notifications
- `support` - Support/help notifications
- `general` - General purpose notifications
- `message` - Message notifications
- `review` - Review-related notifications
- `promotion` - Promotional notifications
- `reminder` - Reminder notifications

## Authentication

All API endpoints require Bearer token authentication:

```
Authorization: Bearer {{access_token}}
Content-Type: application/json
```

## Core Notification Endpoints

### 1. List User Notifications

**GET** `/api/v1/notifications/`

Retrieve notifications for the authenticated user with optional filtering.

**Query Parameters:**
- `notification_type` (string, optional) - Filter by notification type
- `is_read` (boolean, optional) - Filter by read status (true/false)
- `ordering` (string, optional) - Order by field (`created_at`, `-created_at`)
- `page` (integer, optional) - Page number for pagination
- `page_size` (integer, optional) - Number of items per page

**Response:**
```json
{
  "count": 25,
  "next": "{{base_url}}/api/v1/notifications/?page=2",
  "previous": null,
  "results": [
    {
      "id": "notification_id",
      "recipient": "user_id",
      "notification_type": "bid_received",
      "title": "New Bid Received",
      "message": "You have received a new bid for your service request.",
      "action_url": "/bids/12345",
      "is_read": false,
      "is_archived": false,
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z",
      "metadata": {}
    }
  ]
}
```

### 2. Get Notification Details

**GET** `/api/v1/notifications/{{notification_id}}/`

Retrieve details of a specific notification.

**Response:**
```json
{
  "id": "notification_id",
  "recipient": "user_id",
  "notification_type": "bid_received",
  "title": "New Bid Received",
  "message": "You have received a new bid for your service request.",
  "action_url": "/bids/12345",
  "is_read": false,
  "is_archived": false,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "metadata": {}
}
```

### 3. Get Unread Notifications Count

**GET** `/api/v1/notifications/unread_count/`

Get the count of unread notifications for the authenticated user.

**Response:**
```json
{
  "count": 5,
  "by_type": {
    "bid_received": 2,
    "booking_status_updated": 1,
    "system": 2
  }
}
```

### 4. Mark Specific Notifications as Read

**POST** `/api/v1/notifications/mark_read/`

Mark specific notifications as read by providing their IDs.

**Request Body:**
```json
{
  "notification_ids": [
    "notification_id_1",
    "notification_id_2"
  ]
}
```

**Response:**
```json
{
  "message": "Notifications marked as read successfully",
  "marked_count": 2
}
```

### 5. Mark All Notifications as Read

**POST** `/api/v1/notifications/mark_read/`

Mark all notifications as read for the authenticated user.

**Request Body:**
```json
{
  "mark_all": true
}
```

**Response:**
```json
{
  "message": "All notifications marked as read successfully",
  "marked_count": 15
}
```

### 6. Mark Single Notification as Read (PUT)

**PUT** `/api/v1/notifications/{{notification_id}}/`

Mark a single notification as read using PUT method.

**Request Body:**
```json
{
  "mark_all": false
}
```

### 7. Mark Single Notification as Read (PATCH)

**PATCH** `/api/v1/notifications/{{notification_id}}/`

Mark a single notification as read using PATCH method.

**Request Body:**
```json
{
  "mark_all": false
}
```

### 8. Delete Notification

**DELETE** `/api/v1/notifications/{{notification_id}}/`

Permanently delete a notification.

**Response:** `204 No Content`

### 9. Archive Notification

**PATCH** `/api/v1/notifications/{{notification_id}}/`

Archive a notification (soft delete).

**Request Body:**
```json
{
  "is_archived": true
}
```

## Provider Notifications

### List Provider Notifications

**GET** `/api/v1/notifications/?notification_type=bid_received,booking_created,payment_received`

Retrieve notifications specifically relevant to service providers.

**Common notification types for providers:**
- `bid_received` - New bids on their services
- `booking_created` - New bookings for their services
- `payment_received` - Payment confirmations

### Get Bid Notifications

**GET** `/api/v1/notifications/?notification_type=bid_received&is_read=false`

Get unread bid notifications for providers.

## Customer Notifications

### List Customer Notifications

**GET** `/api/v1/notifications/?notification_type=bid_accepted,bid_rejected,booking_status_updated`

Retrieve notifications specifically relevant to customers.

**Common notification types for customers:**
- `bid_accepted` - Bids accepted by providers
- `bid_rejected` - Bids rejected by providers
- `booking_status_updated` - Updates on booking status

### Get Booking Status Notifications

**GET** `/api/v1/notifications/?notification_type=booking_status_updated&is_read=false`

Get unread booking status notifications for customers.

## Admin Notifications

### Create Notification (Admin Only)

**POST** `/api/v1/notifications/`

Create a new notification (admin only).

**Request Body:**
```json
{
  "recipient": "user_id",
  "notification_type": "system",
  "title": "System Notification",
  "message": "This is a system notification for testing purposes.",
  "action_url": "/dashboard"
}
```

### List All Notifications (Admin Only)

**GET** `/api/v1/notifications/?all=true`

Retrieve all notifications across all users (admin only).

## Real-time Notifications (WebSocket)

### WebSocket Connection

**WebSocket URL:** `{{base_url_ws}}/ws/notifications/`

**Headers:**
```
Authorization: Bearer {{access_token}}
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13
```

### WebSocket Message Types

#### Authentication
Send after connection:
```json
{
  "type": "auth",
  "token": "{{access_token}}"
}
```

#### Mark Notification as Read
```json
{
  "type": "mark_read",
  "data": {
    "notification_id": "notification_id"
  }
}
```

#### Mark All Notifications as Read
```json
{
  "type": "mark_all_read",
  "data": {}
}
```

#### Get Recent Notifications
```json
{
  "type": "get_notifications",
  "data": {}
}
```

#### Archive Notification
```json
{
  "type": "archive_notification",
  "data": {
    "notification_id": "notification_id"
  }
}
```

### Receiving Real-time Updates

The WebSocket will send notifications in real-time:
```json
{
  "type": "notification",
  "data": {
    "id": "notification_id",
    "notification_type": "bid_received",
    "title": "New Bid Received",
    "message": "You have received a new bid.",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

## Flutter Integration

### Service Setup

```dart
// In your main.dart or service provider setup
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ApiService());
});
```

### Basic Usage

```dart
class NotificationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider({}));
    
    return notificationsAsync.when(
      data: (notifications) => ListView.builder(
        itemCount: notifications.results.length,
        itemBuilder: (context, index) {
          final notification = notifications.results[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.message),
            trailing: notification.isRead 
                ? null 
                : Icon(Prbal.circle, color: Colors.blue, size: 8),
            onTap: () => _markAsRead(ref, notification.id),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
  
  void _markAsRead(WidgetRef ref, String notificationId) async {
    final service = ref.read(notificationServiceProvider);
    await service.markSingleNotificationAsReadPatch(notificationId);
    ref.refresh(notificationListProvider({}));
  }
}
```

### WebSocket Integration

```dart
class RealtimeNotifications extends ConsumerStatefulWidget {
  @override
  _RealtimeNotificationsState createState() => _RealtimeNotificationsState();
}

class _RealtimeNotificationsState extends ConsumerState<RealtimeNotifications> {
  WebSocketChannel? _channel;
  
  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }
  
  void _connectWebSocket() {
    final service = ref.read(notificationServiceProvider);
    _channel = service.connectToNotificationsWebSocket(
      baseUrlWs: 'ws://your-websocket-url',
      accessToken: 'your-access-token',
    );
    
    _channel!.stream.listen((data) {
      final message = NotificationWebSocketMessage.fromJson(
        json.decode(data)
      );
      // Handle real-time notification
      _handleRealtimeNotification(message);
    });
  }
  
  void _handleRealtimeNotification(NotificationWebSocketMessage message) {
    // Update UI, show snackbar, etc.
    if (message.type == 'notification') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New notification received!')),
      );
      // Refresh notification list
      ref.refresh(notificationListProvider({}));
    }
  }
}
```

## Error Handling

### Common HTTP Status Codes

- `200 OK` - Successful request
- `201 Created` - Notification created successfully
- `204 No Content` - Successful deletion
- `400 Bad Request` - Invalid request parameters
- `401 Unauthorized` - Invalid or missing authentication
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Notification not found
- `500 Internal Server Error` - Server error

### Error Response Format

```json
{
  "error": "error_code",
  "message": "Human-readable error message",
  "details": {
    "field": ["Specific field error messages"]
  }
}
```

## Examples

### Example 1: List Unread Bid Notifications for Provider

```bash
curl -X GET "{{base_url}}/api/v1/notifications/?notification_type=bid_received&is_read=false" \
  -H "Authorization: Bearer {{provider_access_token}}" \
  -H "Content-Type: application/json"
```

### Example 2: Create System Notification (Admin)

```bash
curl -X POST "{{base_url}}/api/v1/notifications/" \
  -H "Authorization: Bearer {{admin_access_token}}" \
  -H "Content-Type: application/json" \
  -d '{
    "recipient": "user_123",
    "notification_type": "system",
    "title": "System Maintenance",
    "message": "Scheduled maintenance on Jan 20, 2024 from 2-4 AM UTC.",
    "action_url": "/maintenance"
  }'
```

### Example 3: Mark Multiple Notifications as Read

```bash
curl -X POST "{{base_url}}/api/v1/notifications/mark_read/" \
  -H "Authorization: Bearer {{access_token}}" \
  -H "Content-Type: application/json" \
  -d '{
    "notification_ids": ["notif_1", "notif_2", "notif_3"]
  }'
```

### Example 4: Get Unread Count

```bash
curl -X GET "{{base_url}}/api/v1/notifications/unread_count/" \
  -H "Authorization: Bearer {{access_token}}" \
  -H "Content-Type: application/json"
```

### Example 5: WebSocket Connection (JavaScript)

```javascript
const ws = new WebSocket('{{base_url_ws}}/ws/notifications/');

ws.onopen = function() {
  // Authenticate
  ws.send(JSON.stringify({
    type: 'auth',
    token: '{{access_token}}'
  }));
};

ws.onmessage = function(event) {
  const message = JSON.parse(event.data);
  console.log('Received:', message);
  
  if (message.type === 'notification') {
    // Handle new notification
    showNotificationToUser(message.data);
  }
};

// Mark notification as read
function markAsRead(notificationId) {
  ws.send(JSON.stringify({
    type: 'mark_read',
    data: { notification_id: notificationId }
  }));
}
```

## Rate Limiting

- Standard API calls: 100 requests per minute per user
- WebSocket connections: 1 connection per user
- Bulk operations: 10 requests per minute per user

## Best Practices

1. **Pagination**: Always use pagination for listing notifications
2. **Real-time Updates**: Use WebSocket for real-time features
3. **Filtering**: Apply appropriate filters based on user type
4. **Error Handling**: Implement proper error handling for all API calls
5. **Performance**: Cache unread counts and refresh periodically
6. **User Experience**: Show loading states and provide feedback
7. **Security**: Never expose admin endpoints to regular users
8. **Cleanup**: Regularly archive or delete old notifications

## Postman Collection Variables

Set up these variables in your Postman environment:

- `base_url` - Your API base URL (e.g., `https://api.prbal.com`)
- `base_url_ws` - Your WebSocket base URL (e.g., `wss://api.prbal.com`)
- `api_version` - API version (e.g., `v1`)
- `access_token` - User access token
- `admin_access_token` - Admin access token
- `provider_access_token` - Provider access token
- `customer_access_token` - Customer access token
- `notification_id` - Specific notification ID for testing
- `user_id` - User ID for admin operations

This comprehensive documentation covers all notification APIs available in the Prbal application. Use it as a reference for implementing notification features in your application. 