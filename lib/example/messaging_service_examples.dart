// This file demonstrates how to use the Messaging Service APIs in your Flutter app
// Remove this file once you've integrated the messaging features into your actual screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:prbal/services/messaging_service.dart';

/// Request model for creating threads
class CreateThreadRequest {
  const CreateThreadRequest({
    required this.threadType,
    required this.participantIds,
    required this.initialMessage,
    this.bid,
    this.booking,
    this.metadata,
  });

  final String? bid;
  final String? booking;
  final String initialMessage;
  final Map<String, dynamic>? metadata;
  final List<String> participantIds;
  final ThreadType threadType;

  Map<String, dynamic> toJson() {
    return {
      'thread_type': threadType.value,
      'participant_ids': participantIds,
      'initial_message': initialMessage,
      if (bid != null) 'bid_id': bid,
      if (booking != null) 'booking_id': booking,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Request model for creating messages
class CreateMessageRequest {
  const CreateMessageRequest({
    required this.content,
    this.type = MessageType.text,
    this.attachmentUrls,
    this.metadata,
  });

  final List<String>? attachmentUrls;
  final String content;
  final Map<String, dynamic>? metadata;
  final MessageType type;

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'type': type.value,
      if (attachmentUrls != null) 'attachment_urls': attachmentUrls,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Comprehensive Messaging Management Screen
class DurgasMessagingScreen extends ConsumerStatefulWidget {
  const DurgasMessagingScreen({super.key});

  @override
  ConsumerState<DurgasMessagingScreen> createState() =>
      _DurgasMessagingScreenState();
}

class _DurgasMessagingScreenState extends ConsumerState<DurgasMessagingScreen>
    with SingleTickerProviderStateMixin {
  String? _activeThreadId;
  bool _isTyping = false;
  MessageOrdering _selectedOrdering = MessageOrdering.updatedAtDesc;
  ThreadType? _selectedThreadType;
  late TabController _tabController;
  // WebSocket management
  WebSocketChannel? _webSocketChannel;

  @override
  void dispose() {
    _tabController.dispose();
    _webSocketChannel?.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Widget _buildThreadsTab() {
    final filters = <String, dynamic>{
      if (_selectedThreadType != null)
        'thread_type': _selectedThreadType!.value,
      'ordering': _selectedOrdering.value,
    };

    final threadsAsync = ref.watch(threadListProvider(filters));

    return threadsAsync.when(
      data: (threadResponse) {
        if (threadResponse.success && threadResponse.data != null) {
          return _buildThreadsList(threadResponse.data!);
        } else {
          return _buildErrorWidget(
            threadResponse.message ?? 'Failed to load threads',
            () => ref.refresh(threadListProvider(filters)),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error, () {
        // ignore: unused_result
        ref.refresh(threadListProvider(filters));
      }),
    );
  }

  Widget _buildMessagesTab() {
    return FutureBuilder<List<Message>>(
      future: _loadAllMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error, () {
            setState(() {});
          });
        }
        final messages = snapshot.data ?? [];
        return _buildMessagesList(messages);
      },
    );
  }

  Widget _buildLiveChatTab() {
    if (_activeThreadId == null) {
      return const Center(
        child: Text('Select a thread to start live chat'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: _buildWebSocketMessages(),
        ),
        _buildMessageInput(),
        if (_isTyping)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Someone is typing...',
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
      ],
    );
  }

  Widget _buildAdminTab() {
    return const Center(
      child: Text('Admin messaging features coming soon...'),
    );
  }

  Widget _buildThreadsList(List<MessageThread> threads) {
    if (threads.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No threads found', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: threads.length,
      itemBuilder: (context, index) => _buildThreadCard(threads[index]),
    );
  }

  Widget _buildThreadCard(MessageThread thread) {
    final typeColor =
        _getThreadTypeColor(thread.threadType ?? ThreadType.customer);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: typeColor.withValues(alpha: 0.2),
          child: Icon(
            _getThreadTypeIcon(thread.threadType ?? ThreadType.customer),
            color: typeColor,
          ),
        ),
        title: Row(
          children: [
            Text(
              thread.threadType?.value.toUpperCase() ?? 'UNKNOWN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: typeColor,
              ),
            ),
            const Spacer(),
            if (thread.unreadCount > 0)
              Badge(
                label: Text('${thread.unreadCount}'),
                child: const SizedBox(),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Participants: ${thread.participantIds.length}'),
            if (thread.lastMessage != null)
              Text(
                'Last: ${thread.lastMessage!.content}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
            Text(
              'Updated: ${_formatDateTime(thread.updatedAt)}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
        onTap: () => _openThread(thread),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleThreadAction(value, thread),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Messages')),
            const PopupMenuItem(value: 'edit', child: Text('Edit Thread')),
            const PopupMenuItem(value: 'delete', child: Text('Delete Thread')),
            const PopupMenuItem(
                value: 'mark_read', child: Text('Mark All Read')),
            const PopupMenuItem(value: 'live_chat', child: Text('Live Chat')),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(List<Message> messages) {
    if (messages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No messages found', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) => _buildMessageCard(messages[index]),
    );
  }

  Widget _buildMessageCard(Message message) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Message #${message.id.substring(0, 8)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (!message.isRead)
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
            const SizedBox(height: 8),
            Text(message.content),
            if (message.attachment != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attachment, size: 16),
                  const SizedBox(width: 4),
                  const Text('Attachment'),
                  TextButton(
                    onPressed: () => _viewAttachment(message.attachment!),
                    child: const Text('View'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Thread: ${message.threadId.substring(0, 8)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const Spacer(),
                Text(
                  _formatDateTime(message.createdAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _editMessage(message),
                  child: const Text('Edit'),
                ),
                TextButton(
                  onPressed: () => _deleteMessage(message.id),
                  child: const Text('Delete'),
                ),
                if (!message.isRead)
                  TextButton(
                    onPressed: () => _markMessageAsRead(message.id),
                    child: const Text('Mark Read'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebSocketMessages() {
    if (_webSocketChannel == null) {
      return const Center(child: Text('No active WebSocket connection'));
    }

    return StreamBuilder(
      stream: _webSocketChannel!.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            final data = json.decode(snapshot.data as String);
            final wsMessage = WebSocketMessage.fromJson(data);
            return _buildWebSocketMessage(wsMessage);
          } catch (e) {
            return Text('Error parsing message: $e');
          }
        }
        return const Center(child: Text('Listening for messages...'));
      },
    );
  }

  Widget _buildWebSocketMessage(WebSocketMessage wsMessage) {
    switch (wsMessage.type) {
      case 'message':
        return ListTile(
          title: Text(wsMessage.data['message'] ?? ''),
          subtitle: Text('From: ${wsMessage.data['sender_id'] ?? 'Unknown'}'),
          trailing: Text(_formatDateTime(DateTime.now())),
        );
      case 'typing':
        return ListTile(
          title: Text(
            '${wsMessage.data['user_id']} ${wsMessage.data['is_typing'] ? 'is typing...' : 'stopped typing'}',
          ),
          leading: const Icon(Icons.edit),
        );
      case 'read_receipt':
        return ListTile(
          title: Text('Message read by ${wsMessage.data['user_id']}'),
          leading: const Icon(Icons.done_all),
        );
      case 'presence':
        return ListTile(
          title: Text(
            '${wsMessage.data['user_id']} is ${wsMessage.data['status']}',
          ),
          leading: Icon(
            wsMessage.data['status'] == 'online'
                ? Icons.circle
                : Icons.circle_outlined,
            color: wsMessage.data['status'] == 'online'
                ? Colors.green
                : Colors.grey,
          ),
        );
      default:
        return ListTile(
          title: Text('Unknown message type: ${wsMessage.type}'),
          subtitle: Text(wsMessage.data.toString()),
        );
    }
  }

  Widget _buildMessageInput() {
    final messageController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) => _handleTyping(text.isNotEmpty),
              onSubmitted: (text) {
                _sendWebSocketMessage(text);
                messageController.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              _sendWebSocketMessage(messageController.text);
              messageController.clear();
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
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
        title: const Text('Filter Threads'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ThreadType>(
              value: _selectedThreadType,
              decoration: const InputDecoration(labelText: 'Thread Type'),
              items: ThreadType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.value.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedThreadType = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MessageOrdering>(
              value: _selectedOrdering,
              decoration: const InputDecoration(labelText: 'Ordering'),
              items: MessageOrdering.values
                  .map((ordering) => DropdownMenuItem(
                        value: ordering,
                        child: Text(ordering.value),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedOrdering = value!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedThreadType = null;
                _selectedOrdering = MessageOrdering.updatedAtDesc;
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

  void _showCreateThreadDialog() {
    ThreadType selectedType = ThreadType.customer;
    final participantsController = TextEditingController();
    final messageController = TextEditingController();
    final bidController = TextEditingController();
    final bookingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create New Thread'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ThreadType>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Thread Type'),
                  items: ThreadType.values
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
                  controller: participantsController,
                  decoration: const InputDecoration(
                    labelText: 'Participant IDs (comma separated)',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Initial Message',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bookingController,
                  decoration:
                      const InputDecoration(labelText: 'Booking ID (optional)'),
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
                await _createThread(
                  selectedType,
                  participantsController.text,
                  messageController.text,
                  bidController.text.isEmpty ? null : bidController.text,
                  bookingController.text.isEmpty
                      ? null
                      : bookingController.text,
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

  void _handleThreadAction(String action, MessageThread thread) {
    switch (action) {
      case 'view':
        _viewThreadMessages(thread.id);
        break;
      case 'edit':
        _editThread(thread);
        break;
      case 'delete':
        _deleteThread(thread.id);
        break;
      case 'mark_read':
        _markAllMessagesInThreadAsRead(thread.id);
        break;
      case 'live_chat':
        _connectToLiveChat(thread.id);
        break;
    }
  }

  void _openThread(MessageThread thread) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final messagesAsync = ref.watch(messagesInThreadProvider(thread.id));

          return AlertDialog(
            title: Text(
                '${thread.threadType?.value.toUpperCase() ?? 'UNKNOWN'} Thread'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: messagesAsync.when(
                data: (messagesResponse) {
                  if (messagesResponse.success &&
                      messagesResponse.data != null) {
                    final messages = messagesResponse.data!;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ListTile(
                          title: Text(message.content),
                          subtitle: Text(_formatDateTime(message.createdAt)),
                          trailing: message.isRead
                              ? const Icon(Icons.done_all)
                              : const Icon(Icons.done),
                        );
                      },
                    );
                  } else {
                    return Text('Error: ${messagesResponse.message}');
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _connectToLiveChat(thread.id);
                },
                child: const Text('Live Chat'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _connectToLiveChat(String threadId) {
    try {
      _webSocketChannel?.sink.close();

      // Note: This is a placeholder - actual WebSocket connection would be implemented
      // based on your backend WebSocket URL and authentication
      setState(() {
        _activeThreadId = threadId;
      });

      // Switch to live chat tab
      _tabController.animateTo(2);

      debugPrint('Connected to live chat for thread: $threadId');
    } catch (e) {
      debugPrint('Error connecting to live chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to live chat: $e')),
      );
    }
  }

  void _handleTyping(bool isTyping) {
    if (_isTyping != isTyping && _activeThreadId != null) {
      setState(() {
        _isTyping = isTyping;
      });
      // Note: Actual typing indicator would be sent via WebSocket
    }
  }

  void _sendWebSocketMessage(String content) {
    if (content.isNotEmpty && _activeThreadId != null) {
      // Note: Actual message sending would be done via WebSocket
      debugPrint('Sending message: $content to thread: $_activeThreadId');
    }
  }

  // API Operations

  Future<List<Message>> _loadAllMessages() async {
    final messagingService = ref.read(messagingServiceProvider);
    final response = await messagingService.listAllMessages();

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.message ?? 'Failed to load messages');
    }
  }

  Future<void> _createThread(
    ThreadType type,
    String participants,
    String initialMessage,
    String? bidId,
    String? bookingId,
  ) async {
    try {
      final messagingService = ref.read(messagingServiceProvider);
      final participantIds =
          participants.split(',').map((e) => e.trim()).toList();

      final request = ThreadCreationRequest(
        participantIds: participantIds,
        initialMessage: initialMessage,
        bookingId: bookingId,
        metadata: {
          'thread_type': type.value,
          if (bidId != null) 'bid_id': bidId,
        },
      );

      final response = await messagingService.createThread(request);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thread created successfully!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to create thread')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _editThread(MessageThread thread) async {
    // Show edit thread dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Thread'),
        content: const Text('Edit thread functionality would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteThread(String threadId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Thread'),
        content: const Text('Are you sure you want to delete this thread?'),
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
        final messagingService = ref.read(messagingServiceProvider);
        final response = await messagingService.deleteThread(threadId);

        if (!mounted) return;

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thread deleted successfully!')),
          );
          setState(() {}); // Refresh the lists
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.message ?? 'Failed to delete thread')),
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

  Future<void> _markAllMessagesInThreadAsRead(String threadId) async {
    try {
      final messagingService = ref.read(messagingServiceProvider);
      final response =
          await messagingService.markAllMessagesInThreadAsRead(threadId);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All messages marked as read!')),
        );
        // Refresh the messages list
        // ignore: unused_result
        ref.refresh(messagesInThreadProvider(threadId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.message ?? 'Failed to mark messages as read')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _markMessageAsRead(String messageId) async {
    try {
      final messagingService = ref.read(messagingServiceProvider);
      final response =
          await messagingService.markSpecificMessagesAsRead([messageId]);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message marked as read!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.message ?? 'Failed to mark message as read')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _editMessage(Message message) async {
    final contentController = TextEditingController(text: message.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: contentController,
          decoration: const InputDecoration(labelText: 'Message Content'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updateMessage(message.id, contentController.text);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateMessage(String messageId, String newContent) async {
    try {
      final messagingService = ref.read(messagingServiceProvider);
      final updates = {'content': newContent};
      final response =
          await messagingService.partialUpdateMessage(messageId, updates);

      if (!mounted) return;

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message updated successfully!')),
        );
        setState(() {}); // Refresh the lists
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to update message')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteMessage(String messageId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
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
        final messagingService = ref.read(messagingServiceProvider);
        final response = await messagingService.deleteMessage(messageId);

        if (!mounted) return;

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message deleted successfully!')),
          );
          setState(() {}); // Refresh the lists
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.message ?? 'Failed to delete message')),
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

  void _viewThreadMessages(String threadId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThreadMessagesScreen(threadId: threadId),
      ),
    );
  }

  void _viewAttachment(String attachment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attachment'),
        content: attachment.startsWith('data:')
            ? const Text('Base64 encoded attachment (preview not available)')
            : Text('Attachment URL: $attachment'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Utility Methods

  Color _getThreadTypeColor(ThreadType type) {
    switch (type) {
      case ThreadType.customer:
        return Colors.blue;
      case ThreadType.provider:
        return Colors.green;
      case ThreadType.support:
        return Colors.red;
      case ThreadType.admin:
        return Colors.orange;
    }
  }

  IconData _getThreadTypeIcon(ThreadType type) {
    switch (type) {
      case ThreadType.customer:
        return Icons.person;
      case ThreadType.provider:
        return Icons.business;
      case ThreadType.support:
        return Icons.help;
      case ThreadType.admin:
        return Icons.admin_panel_settings;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.chat), text: 'Threads'),
            Tab(icon: Icon(Icons.message), text: 'Messages'),
            Tab(icon: Icon(Icons.live_help), text: 'Live Chat'),
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
                data: (unreadCount) => unreadCount.totalUnread > 0
                    ? Badge(
                        label: Text('${unreadCount.totalUnread}'),
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
          _buildThreadsTab(),
          _buildMessagesTab(),
          _buildLiveChatTab(),
          _buildAdminTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateThreadDialog,
        tooltip: 'Create New Thread',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Dedicated screen for viewing messages in a specific thread
class ThreadMessagesScreen extends ConsumerWidget {
  const ThreadMessagesScreen({super.key, required this.threadId});

  final String threadId;

  Widget _buildMessageBubble(Message message) {
    // This would typically check if the message is from the current user
    // For demo purposes, we'll alternate based on message ID
    final isMyMessage = message.id.hashCode % 2 == 0;

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMyMessage ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.content),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                if (message.isRead) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 12, color: Colors.blue),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(
      BuildContext context, WidgetRef ref, String threadId) {
    final messageController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              if (messageController.text.isNotEmpty) {
                await _sendMessage(
                    context, ref, threadId, messageController.text);
                messageController.clear();
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(BuildContext context, WidgetRef ref,
      String threadId, String content) async {
    try {
      final messagingService = ref.read(messagingServiceProvider);
      final request = MessageRequest(
        type: MessageType.text,
        content: content,
      );
      final response =
          await messagingService.createMessageInThread(threadId, request);

      if (response.success) {
        // Refresh the messages list
        // ignore: unused_result
        ref.refresh(messagesInThreadProvider(threadId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Failed to send message')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _markAllAsRead(
      BuildContext context, WidgetRef ref, String threadId) async {
    try {
      final messagingService = ref.read(messagingServiceProvider);
      final response =
          await messagingService.markAllMessagesInThreadAsRead(threadId);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All messages marked as read!')),
        );
        // Refresh the messages list
        // ignore: unused_result
        ref.refresh(messagesInThreadProvider(threadId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.message ?? 'Failed to mark messages as read')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadAsync = ref.watch(threadProvider(threadId));
    final messagesAsync = ref.watch(messagesInThreadProvider(threadId));

    return Scaffold(
      appBar: AppBar(
        title: threadAsync.when(
          data: (threadResponse) {
            if (threadResponse.success && threadResponse.data != null) {
              return Text(
                  '${threadResponse.data!.threadType?.value.toUpperCase() ?? 'UNKNOWN'} Thread');
            }
            return const Text('Thread');
          },
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Thread'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_chat_read),
            onPressed: () => _markAllAsRead(context, ref, threadId),
          ),
        ],
      ),
      body: messagesAsync.when(
        data: (messagesResponse) {
          if (messagesResponse.success && messagesResponse.data != null) {
            final messages = messagesResponse.data!;
            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            );
          } else {
            return Center(child: Text('Error: ${messagesResponse.message}'));
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: _buildMessageInput(context, ref, threadId),
    );
  }
}

/// Usage Instructions:
///
/// To integrate this messaging system into your app:
///
/// 1. Add to your router:
///    ```dart
///    '/messaging': (context) => const DurgasMessagingScreen(),
///    ```
///
/// 2. Update the messaging service configuration:
///    ```dart
///    final messagingServiceProvider = Provider<MessagingService>((ref) {
///      return MessagingService(
///        baseUrl: 'https://your-api-domain.com',
///        apiVersion: 'v1',
///        getAccessToken: () => ref.read(authServiceProvider).accessToken,
///      );
///    });
///    ```
///
/// 3. Available API methods from Postman collection:
///    - Thread Management:
///      * listThreads() - List threads with filters
///      * createThread() - Create new thread
///      * getThread() - Get single thread
///      * updateThread() / partialUpdateThread() - Update thread
///      * deleteThread() - Delete thread
///
///    - Message Management:
///      * listAllMessages() - List all messages (admin)
///      * createMessage() - Create message
///      * getMessage() - Get single message
///      * updateMessage() / partialUpdateMessage() - Update message
///      * deleteMessage() - Delete message
///      * markMessagesAsRead() - Mark messages as read
///      * getUnreadCount() - Get unread count
///
///    - Thread-specific Operations:
///      * getMessagesInThread() - Get messages in thread
///      * createMessageInThread() - Create message in thread
///
///    - WebSocket Features:
///      * connectToThread() - Connect to live chat
///      * sendWebSocketMessage() - Send real-time message
///      * sendTypingIndicator() - Send typing status
///      * sendReadReceipt() - Send read receipt
///
///    - Utility Methods:
///      * createBidThread() - Create bid-related thread
///      * createBookingThread() - Create booking-related thread
///      * createSupportThread() - Create support thread
///      * createGeneralThread() - Create general thread
///      * markAllMessagesInThreadAsRead() - Mark all in thread as read
///      * markSpecificMessagesAsRead() - Mark specific messages as read
