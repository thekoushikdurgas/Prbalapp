// This file demonstrates how to use the Enhanced Notification Service APIs in your Flutter app
// Remove this file once you've integrated the notification features into your actual screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:prbal/services/notification_service.dart';

/// Comprehensive Notification Management Screen
class DurgasNotificationScreen extends ConsumerStatefulWidget {
  const DurgasNotificationScreen({super.key});

  @override
  ConsumerState<DurgasNotificationScreen> createState() =>
      _DurgasNotificationScreenState();
}

class _DurgasNotificationScreenState
    extends ConsumerState<DurgasNotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  NotificationType? _selectedNotificationType;
  NotificationOrdering _selectedOrdering =
      NotificationOrdering.negativeCreatedAt;
  bool? _selectedReadStatus;

  // WebSocket management
  WebSocketChannel? _webSocketChannel;
  bool _isConnected = false;
  final List<NotificationWebSocketMessage> _realtimeMessages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _webSocketChannel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.notifications), text: 'All'),
            Tab(icon: Icon(Icons.business), text: 'Provider'),
            Tab(icon: Icon(Icons.person), text: 'Customer'),
            Tab(icon: Icon(Icons.live_help), text: 'Real-time'),
            Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          Consumer(
            builder: (context, ref, child) {
              final unreadAsync = ref.watch(unreadCountProvider);
              return unreadAsync.when(
                data: (unreadCount) => unreadCount.count > 0
                    ? Badge(
                        label: Text('${unreadCount.count}'),
                        child: const Icon(Icons.notifications),
                      )
                    : const Icon(Icons.notifications_none),
                loading: () => const Icon(Icons.notifications_none),
                error: (_, __) => const Icon(Icons.notifications_none),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllNotificationsTab(),
          _buildProviderNotificationsTab(),
          _buildCustomerNotificationsTab(),
          _buildRealtimeNotificationsTab(),
          _buildAdminNotificationsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateNotificationDialog,
        tooltip: 'Create Notification (Admin)',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAllNotificationsTab() {
    final filters = <String, dynamic>{
      if (_selectedNotificationType != null)
        'notificationType': _selectedNotificationType,
      'ordering': _selectedOrdering,
      if (_selectedReadStatus != null) 'isRead': _selectedReadStatus,
    };

    final notificationsAsync = ref.watch(notificationListProvider(filters));

    return notificationsAsync.when(
      data: (notificationResponse) =>
          _buildNotificationsList(notificationResponse.results),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error, () {
        // ignore: unused_result
        ref.refresh(notificationListProvider(filters));
      }),
    );
  }

  Widget _buildProviderNotificationsTab() {
    return FutureBuilder<List<AppNotification>>(
      future: _loadProviderNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error, () {
            setState(() {});
          });
        }
        final notifications = snapshot.data ?? [];
        return _buildNotificationsList(notifications);
      },
    );
  }

  Widget _buildCustomerNotificationsTab() {
    return FutureBuilder<List<AppNotification>>(
      future: _loadCustomerNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error, () {
            setState(() {});
          });
        }
        final notifications = snapshot.data ?? [];
        return _buildNotificationsList(notifications);
      },
    );
  }

  Widget _buildRealtimeNotificationsTab() {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _isConnected ? Icons.wifi : Icons.wifi_off,
                      color: _isConnected ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isConnected ? 'Connected' : 'Disconnected',
                      style: TextStyle(
                        color: _isConnected ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _isConnected
                          ? _disconnectWebSocket
                          : _connectWebSocket,
                      child: Text(_isConnected ? 'Disconnect' : 'Connect'),
                    ),
                  ],
                ),
                if (_isConnected) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _sendGetRecentNotifications,
                        child: const Text('Get Recent'),
                      ),
                      ElevatedButton(
                        onPressed: _sendMarkAllAsRead,
                        child: const Text('Mark All Read'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        Expanded(
          child: _buildRealtimeMessagesList(),
        ),
      ],
    );
  }

  Widget _buildAdminNotificationsTab() {
    return FutureBuilder<List<AppNotification>>(
      future: _loadAllNotificationsAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error, () {
            setState(() {});
          });
        }
        final notifications = snapshot.data ?? [];
        return _buildNotificationsList(notifications, showAdminActions: true);
      },
    );
  }

  Widget _buildNotificationsList(List<AppNotification> notifications,
      {bool showAdminActions = false}) {
    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No notifications found', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) =>
          _buildNotificationCard(notifications[index], showAdminActions),
    );
  }

  Widget _buildNotificationCard(
      AppNotification notification, bool showAdminActions) {
    final typeColor = _getNotificationTypeColor(notification.notificationType);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: typeColor.withValues(alpha: 0.2),
          child: Icon(
            _getNotificationTypeIcon(notification.notificationType),
            color: typeColor,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight:
                      notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  notification.notificationType.value.toUpperCase(),
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDateTime(notification.createdAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            if (notification.isArchived)
              const Text(
                'ARCHIVED',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        onTap: () => _viewNotificationDetails(notification),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleNotificationAction(value, notification),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Details')),
            if (!notification.isRead) ...[
              const PopupMenuItem(
                  value: 'mark_read_put', child: Text('Mark Read (PUT)')),
              const PopupMenuItem(
                  value: 'mark_read_patch', child: Text('Mark Read (PATCH)')),
            ],
            if (!notification.isArchived)
              const PopupMenuItem(value: 'archive', child: Text('Archive')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
            if (showAdminActions) ...[
              const PopupMenuItem(
                  value: 'admin_view', child: Text('Admin View')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRealtimeMessagesList() {
    if (_realtimeMessages.isEmpty) {
      return const Center(
        child: Text(
            'No real-time messages yet. Connect to start receiving updates.'),
      );
    }

    return ListView.builder(
      reverse: true,
      itemCount: _realtimeMessages.length,
      itemBuilder: (context, index) {
        final message = _realtimeMessages[_realtimeMessages.length - 1 - index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('Type: ${message.type}'),
            subtitle: Text(message.data.toString()),
            trailing: Text(_formatDateTime(DateTime.now())),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(Object? error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Event Handlers

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<NotificationType>(
              value: _selectedNotificationType,
              decoration: const InputDecoration(labelText: 'Notification Type'),
              items: NotificationType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.value.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedNotificationType = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<NotificationOrdering>(
              value: _selectedOrdering,
              decoration: const InputDecoration(labelText: 'Ordering'),
              items: NotificationOrdering.values
                  .map((ordering) => DropdownMenuItem(
                        value: ordering,
                        child: Text(ordering.value),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedOrdering = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<bool>(
              value: _selectedReadStatus,
              decoration: const InputDecoration(labelText: 'Read Status'),
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: true, child: Text('Read')),
                DropdownMenuItem(value: false, child: Text('Unread')),
              ],
              onChanged: (value) => setState(() => _selectedReadStatus = value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedNotificationType = null;
                _selectedOrdering = NotificationOrdering.negativeCreatedAt;
                _selectedReadStatus = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showCreateNotificationDialog() {
    NotificationType selectedType = NotificationType.system;
    final recipientController = TextEditingController();
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final actionUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create Notification (Admin)'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: recipientController,
                  decoration: const InputDecoration(
                    labelText: 'Recipient User ID',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<NotificationType>(
                  value: selectedType,
                  decoration:
                      const InputDecoration(labelText: 'Notification Type'),
                  items: NotificationType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.value.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedType = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: actionUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Action URL (Optional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _createNotification(
                  recipientController.text,
                  selectedType,
                  titleController.text,
                  messageController.text,
                  actionUrlController.text.isEmpty
                      ? null
                      : actionUrlController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationAction(String action, AppNotification notification) {
    switch (action) {
      case 'view':
        _viewNotificationDetails(notification);
        break;
      case 'mark_read_put':
        _markNotificationAsReadPut(notification.id);
        break;
      case 'mark_read_patch':
        _markNotificationAsReadPatch(notification.id);
        break;
      case 'archive':
        _archiveNotification(notification.id);
        break;
      case 'delete':
        _deleteNotification(notification.id);
        break;
      case 'admin_view':
        _viewNotificationAdminDetails(notification);
        break;
    }
  }

  void _viewNotificationDetails(AppNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type: ${notification.notificationType.value}'),
              const SizedBox(height: 8),
              Text('Message: ${notification.message}'),
              const SizedBox(height: 8),
              Text('Recipient: ${notification.recipient}'),
              const SizedBox(height: 8),
              Text('Read: ${notification.isRead ? "Yes" : "No"}'),
              const SizedBox(height: 8),
              Text('Archived: ${notification.isArchived ? "Yes" : "No"}'),
              const SizedBox(height: 8),
              Text('Created: ${_formatDateTime(notification.createdAt)}'),
              if (notification.actionUrl != null) ...[
                const SizedBox(height: 8),
                Text('Action URL: ${notification.actionUrl}'),
              ],
              if (notification.metadata != null) ...[
                const SizedBox(height: 8),
                Text('Metadata: ${notification.metadata}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewNotificationAdminDetails(AppNotification notification) {
    // Show additional admin-specific details
    _viewNotificationDetails(notification);
  }

  // WebSocket Methods

  void _connectWebSocket() {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      _webSocketChannel = notificationService.connectToNotificationsWebSocket(
        baseUrlWs: 'ws://localhost:8000', // Replace with your WebSocket URL
        accessToken: 'your_access_token', // Replace with actual token
      );

      _webSocketChannel!.stream.listen(
        (data) {
          try {
            final jsonData = json.decode(data as String);
            final message = NotificationWebSocketMessage.fromJson(jsonData);
            setState(() {
              _realtimeMessages.add(message);
              _isConnected = true;
            });
            debugPrint('WebSocket message received: ${message.type}');
          } catch (e) {
            debugPrint('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          setState(() {
            _isConnected = false;
          });
          debugPrint('WebSocket error: $error');
        },
        onDone: () {
          setState(() {
            _isConnected = false;
          });
          debugPrint('WebSocket connection closed');
        },
      );

      setState(() {
        _isConnected = true;
      });

      debugPrint('WebSocket connected');
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to WebSocket: $e')),
      );
    }
  }

  void _disconnectWebSocket() {
    _webSocketChannel?.sink.close();
    setState(() {
      _isConnected = false;
    });
    debugPrint('WebSocket disconnected');
  }

  void _sendGetRecentNotifications() {
    if (_webSocketChannel != null) {
      final notificationService = ref.read(notificationServiceProvider);
      notificationService.sendGetRecentNotificationsWS(_webSocketChannel!);
    }
  }

  void _sendMarkAllAsRead() {
    if (_webSocketChannel != null) {
      final notificationService = ref.read(notificationServiceProvider);
      notificationService.sendMarkAllNotificationsAsReadWS(_webSocketChannel!);
    }
  }

  // ignore: unused_element
  void _sendMarkNotificationAsRead(String notificationId) {
    if (_webSocketChannel != null) {
      final notificationService = ref.read(notificationServiceProvider);
      notificationService.sendMarkNotificationAsReadWS(
          _webSocketChannel!, notificationId);
    }
  }

  // ignore: unused_element
  void _sendArchiveNotification(String notificationId) {
    if (_webSocketChannel != null) {
      final notificationService = ref.read(notificationServiceProvider);
      notificationService.sendArchiveNotificationWS(
          _webSocketChannel!, notificationId);
    }
  }

  // API Operations

  Future<List<AppNotification>> _loadProviderNotifications() async {
    final notificationService = ref.read(notificationServiceProvider);
    final response = await notificationService.providerListMyNotifications();

    if (response.success && response.data != null) {
      return response.data!.results;
    } else {
      throw Exception(
          response.message ?? 'Failed to load provider notifications');
    }
  }

  Future<List<AppNotification>> _loadCustomerNotifications() async {
    final notificationService = ref.read(notificationServiceProvider);
    final response = await notificationService.customerListMyNotifications();

    if (response.success && response.data != null) {
      return response.data!.results;
    } else {
      throw Exception(
          response.message ?? 'Failed to load customer notifications');
    }
  }

  Future<List<AppNotification>> _loadAllNotificationsAdmin() async {
    final notificationService = ref.read(notificationServiceProvider);
    final response = await notificationService.adminListAllNotifications();

    if (response.success && response.data != null) {
      return response.data!.results;
    } else {
      throw Exception(response.message ?? 'Failed to load admin notifications');
    }
  }

  Future<void> _createNotification(
    String recipient,
    NotificationType type,
    String title,
    String message,
    String? actionUrl,
  ) async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final request = CreateNotificationRequest(
        recipient: recipient,
        notificationType: type,
        title: title,
        message: message,
        actionUrl: actionUrl,
      );

      final response =
          await notificationService.adminCreateNotification(request);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification created successfully!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.message ?? 'Failed to create notification')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _markNotificationAsReadPut(String notificationId) async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final response = await notificationService
          .markSingleNotificationAsReadPut(notificationId);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification marked as read (PUT)!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response.message ?? 'Failed to mark notification as read')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _markNotificationAsReadPatch(String notificationId) async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final response = await notificationService
          .markSingleNotificationAsReadPatch(notificationId);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification marked as read (PATCH)!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response.message ?? 'Failed to mark notification as read')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _archiveNotification(String notificationId) async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final response =
          await notificationService.archiveNotification(notificationId);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification archived successfully!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.message ?? 'Failed to archive notification')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content:
            const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final notificationService = ref.read(notificationServiceProvider);
        final response =
            await notificationService.deleteNotification(notificationId);

        if (!mounted) return;

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification deleted successfully!')),
          );
          setState(() {}); // Refresh the lists
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(response.message ?? 'Failed to delete notification')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // ignore: unused_element
  Future<void> _markAllNotificationsAsRead() async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final response = await notificationService.markAllNotificationsAsRead();

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ??
                  'Failed to mark all notifications as read')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // ignore: unused_element
  Future<void> _markSpecificNotificationsAsRead(
      List<String> notificationIds) async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final response = await notificationService
          .markSpecificNotificationsAsRead(notificationIds);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Selected notifications marked as read!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  response.message ?? 'Failed to mark notifications as read')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Utility Methods

  Color _getNotificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.bidReceived:
      case NotificationType.bidAccepted:
      case NotificationType.bidRejected:
        return Colors.orange;
      case NotificationType.bookingCreated:
      case NotificationType.bookingStatusUpdated:
        return Colors.green;
      case NotificationType.paymentReceived:
        return Colors.blue;
      case NotificationType.system:
        return Colors.purple;
      case NotificationType.support:
        return Colors.red;
      case NotificationType.general:
        return Colors.grey;
      case NotificationType.message:
        return Colors.teal;
      case NotificationType.review:
        return Colors.amber;
      case NotificationType.promotion:
        return Colors.pink;
      case NotificationType.reminder:
        return Colors.indigo;
    }
  }

  IconData _getNotificationTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.bidReceived:
      case NotificationType.bidAccepted:
      case NotificationType.bidRejected:
        return Icons.local_offer;
      case NotificationType.bookingCreated:
      case NotificationType.bookingStatusUpdated:
        return Icons.event;
      case NotificationType.paymentReceived:
        return Icons.payment;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.support:
        return Icons.help;
      case NotificationType.general:
        return Icons.info;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.review:
        return Icons.star;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.reminder:
        return Icons.alarm;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Usage Instructions:
///
/// To integrate this notification system into your app:
///
/// 1. Add to your router:
///    ```dart
///    '/notifications': (context) => const DurgasNotificationScreen(),
///    ```
///
/// 2. Configure the notification service with your API base URL:
///    ```dart
///    final notificationServiceProvider = Provider<NotificationService>((ref) {
///      return NotificationService(
///        ApiService()..initialize(), // Make sure ApiService is configured
///      );
///    });
///    ```
///
/// 3. Available API methods from Postman collection:
///
///    **Core Endpoints:**
///    - listUserNotifications() - List user notifications with filters
///    - getNotificationDetails() - Get specific notification
///    - getUnreadNotificationsCount() - Get unread count
///    - markSpecificNotificationsAsRead() - Mark specific notifications as read
///    - markAllNotificationsAsRead() - Mark all notifications as read
///    - markSingleNotificationAsReadPut() - Mark single notification as read (PUT)
///    - markSingleNotificationAsReadPatch() - Mark single notification as read (PATCH)
///    - deleteNotification() - Delete notification
///    - archiveNotification() - Archive notification
///
///    **Admin Endpoints:**
///    - adminCreateNotification() - Create notification (admin only)
///    - adminListAllNotifications() - List all notifications (admin only)
///
///    **Provider Endpoints:**
///    - providerListMyNotifications() - List provider-specific notifications
///    - providerGetBidNotifications() - Get bid notifications for providers
///
///    **Customer Endpoints:**
///    - customerListMyNotifications() - List customer-specific notifications
///    - customerGetBookingStatusNotifications() - Get booking status notifications
///
///    **WebSocket Features:**
///    - connectToNotificationsWebSocket() - Connect to real-time notifications
///    - sendMarkNotificationAsReadWS() - Mark notification as read via WebSocket
///    - sendMarkAllNotificationsAsReadWS() - Mark all notifications as read via WebSocket
///    - sendGetRecentNotificationsWS() - Get recent notifications via WebSocket
///    - sendArchiveNotificationWS() - Archive notification via WebSocket
///
///    **Utility Methods:**
///    - createBidNotification() - Helper for bid-related notifications
///    - createBookingNotification() - Helper for booking-related notifications
///    - createSystemNotification() - Helper for system notifications
///    - createPaymentNotification() - Helper for payment notifications
///    - getNotificationsByType() - Helper to get notifications by type
///    - getUnreadNotifications() - Helper to get unread notifications
///
/// 4. Notification Types Available:
///    - bid_received, bid_accepted, bid_rejected
///    - booking_created, booking_status_updated
///    - payment_received
///    - system, support, general
///    - message, review, promotion, reminder
///
/// 5. WebSocket Connection:
///    - Replace 'ws://localhost:8000' with your WebSocket URL
///    - Replace 'your_access_token' with actual authentication token
///    - Handle authentication and error cases as needed
///
/// 6. Provider Integration:
///    Use the provided Riverpod providers:
///    - notificationListProvider(filters) - For notification lists
///    - unreadCountProvider - For unread count
///    - notificationProvider(id) - For specific notification details
