# Prbal Messaging Service Documentation

## Overview

The Prbal Messaging Service provides a comprehensive real-time messaging solution for your Flutter application. It implements all the APIs from the Messaging Postman collection and includes WebSocket support for real-time communication.

## Features

### Core Messaging Features
- **Message Threads**: Organize conversations by type (bid, booking, general, support)
- **Real-time Messaging**: WebSocket-based live chat with typing indicators
- **Read Receipts**: Track message read status
- **Attachments**: Support for Base64 encoded file attachments
- **Unread Counters**: Track unread messages per thread and globally
- **Message Management**: Full CRUD operations on messages and threads

### Thread Types
- **Bid Threads**: Conversations related to service bids
- **Booking Threads**: Discussions about specific bookings
- **General Threads**: Open conversations between users
- **Support Threads**: Customer support communications

### Real-time Features
- **Live Chat**: WebSocket-based instant messaging
- **Typing Indicators**: Show when users are typing
- **Presence Status**: Track user online/offline status
- **Message Delivery**: Real-time message delivery and receipt

## Implementation

### 1. Service Structure

```dart
// Core service class
class MessagingService {
  final String baseUrl;
  final String apiVersion;
  final String Function() getAccessToken;
  
  // Thread Management
  Future<MessagingResponse<PaginatedResponse<MessageThread>>> listThreads({...});
  Future<MessagingResponse<MessageThread>> createThread(CreateThreadRequest request);
  Future<MessagingResponse<MessageThread>> getThread(String threadId);
  Future<MessagingResponse<MessageThread>> updateThread(String threadId, UpdateThreadRequest request);
  Future<MessagingResponse<void>> deleteThread(String threadId);
  
  // Message Management
  Future<MessagingResponse<Message>> createMessage(CreateDirectMessageRequest request);
  Future<MessagingResponse<Message>> getMessage(String messageId);
  Future<MessagingResponse<void>> markMessagesAsRead(MarkAsReadRequest request);
  Future<MessagingResponse<UnreadCountResponse>> getUnreadCount({String? threadId});
  
  // WebSocket Operations
  WebSocketChannel connectToThread(String threadId);
  void sendWebSocketMessage(WebSocketChannel channel, WebSocketMessage message);
  void sendTypingIndicator(WebSocketChannel channel, bool isTyping);
  void sendReadReceipt(WebSocketChannel channel, String messageId);
}
```

### 2. Data Models

```dart
// Thread model
class MessageThread {
  final String id;
  final ThreadType threadType;
  final List<String> participantIds;
  final String? bid;
  final String? booking;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCount;
  final Message? lastMessage;
}

// Message model
class Message {
  final String id;
  final String threadId;
  final String senderId;
  final String content;
  final String? attachment;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
}

// WebSocket message
class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
}
```

### 3. Riverpod Providers

```dart
// Service provider
final messagingServiceProvider = Provider<MessagingService>((ref) {
  return MessagingService(
    baseUrl: 'https://your-api-domain.com',
    apiVersion: 'v1',
    getAccessToken: () => ref.read(authServiceProvider).accessToken,
  );
});

// Data providers
final threadListProvider = FutureProvider.family<PaginatedResponse<MessageThread>, Map<String, dynamic>?>();
final threadProvider = FutureProvider.family<MessageThread, String>();
final messagesInThreadProvider = FutureProvider.family<List<Message>, String>();
final unreadCountProvider = FutureProvider<UnreadCountResponse>();
final messageProvider = FutureProvider.family<Message, String>();
```

## API Endpoints Reference

### Thread Management Endpoints

#### 1. List Message Threads

```http
GET /api/v1/messaging/threads/
```

**Query Parameters:**
- `thread_type`: Filter by thread type (bid, booking, general, support)
- `ordering`: Order by field (-updated_at, -created_at, updated_at, created_at)

**Usage:**

```dart
final response = await messagingService.listThreads(
  threadType: ThreadType.booking,
  ordering: MessageOrdering.updatedAtDesc,
);
```

#### 2. Create Message Thread

```http
POST /api/v1/messaging/threads/
```

**Request Body:**

```json
{
  "thread_type": "general",
  "participant_ids": ["user1", "user2"],
  "initial_message": "Hello! I'd like to discuss your service.",
  "bid": null,
  "booking": null
}
```

**Usage:**

```dart
final request = CreateThreadRequest(
  threadType: ThreadType.general,
  participantIds: ['provider123', 'customer456'],
  initialMessage: 'Hello! I have a question about your service.',
);
final response = await messagingService.createThread(request);
```

#### 3. Get Message Thread

```http
GET /api/v1/messaging/threads/{thread_id}/
```

**Usage:**

```dart
final response = await messagingService.getThread('thread_id_here');
```

#### 4. Update Message Thread

```http
PUT /api/v1/messaging/threads/{thread_id}/
PATCH /api/v1/messaging/threads/{thread_id}/
```

**Usage:**

```dart
final request = UpdateThreadRequest(threadType: ThreadType.support);
final response = await messagingService.partialUpdateThread(threadId, request);
```

#### 5. Delete Message Thread

```http
DELETE /api/v1/messaging/threads/{thread_id}/
```

**Usage:**

```dart
final response = await messagingService.deleteThread('thread_id_here');
```

#### 6. Get Messages in Thread

```http
GET /api/v1/messaging/threads/{thread_id}/messages/
```

**Query Parameters:**
- `since`: Timestamp to get messages after (optional)

**Usage:**

```dart
final response = await messagingService.getMessagesInThread(
  'thread_id_here',
  since: DateTime.now().subtract(Duration(hours: 1)),
);
```

### Individual Message Endpoints

#### 1. List All Messages

```http
GET /api/v1/messaging/messages/
```

**Usage:**

```dart
final response = await messagingService.listAllMessages();
```

#### 2. Create Message

```http
POST /api/v1/messaging/messages/
```

**Request Body:**

```json
{
  "thread": "thread_id",
  "content": "Hello! This is a test message.",
  "attachment": null
}
```

**Usage:**

```dart
final request = CreateDirectMessageRequest(
  threadId: 'thread_id_here',
  content: 'Hello! This is my message.',
);
final response = await messagingService.createMessage(request);
```

#### 3. Get Message

```http
GET /api/v1/messaging/messages/{message_id}/
```

**Usage:**

```dart
final response = await messagingService.getMessage('message_id_here');
```

#### 4. Update Message

```http
PUT /api/v1/messaging/messages/{message_id}/
PATCH /api/v1/messaging/messages/{message_id}/
```

**Usage:**

```dart
final request = CreateMessageRequest(content: 'Updated message content');
final response = await messagingService.partialUpdateMessage(messageId, request);
```

#### 5. Delete Message

```http
DELETE /api/v1/messaging/messages/{message_id}/
```

**Usage:**

```dart
final response = await messagingService.deleteMessage('message_id_here');
```

#### 6. Mark Messages as Read

```http
POST /api/v1/messaging/messages/mark_as_read/
```

**Request Body (Specific Messages):**

```json
{
  "message_ids": ["message_id_1", "message_id_2"]
}
```

**Request Body (All in Thread):**

```json
{
  "mark_all_in_thread": true,
  "thread_id": "thread_id_here"
}
```

**Usage:**

```dart
// Mark specific messages as read
final response = await messagingService.markSpecificMessagesAsRead(['msg1', 'msg2']);

// Mark all messages in thread as read
final response = await messagingService.markAllMessagesInThreadAsRead('thread_id');
```

#### 7. Get Unread Count

```http
GET /api/v1/messaging/messages/unread_count/
```

**Query Parameters:**
- `thread_id`: Get unread count for specific thread (optional)

**Usage:**

```dart
// Total unread count
final response = await messagingService.getUnreadCount();

// Unread count for specific thread
final response = await messagingService.getUnreadCount(threadId: 'thread_id_here');
```

### Thread-Specific Message Endpoints

#### 1. List Messages in Thread

```http
GET /api/v1/messaging/{thread_id}/
```

**Usage:**

```dart
final response = await messagingService.listMessagesInThread('thread_id_here');
```

#### 2. Create Message in Thread

```http
POST /api/v1/messaging/{thread_id}/
```

**Request Body:**

```json
{
  "content": "Hello! This is a message directly in the thread.",
  "attachment": null
}
```

**Usage:**

```dart
final request = CreateMessageRequest(content: 'Hello from the thread!');
final response = await messagingService.createMessageInThread('thread_id_here', request);
```

#### 3. Create Message with Attachment

```http
POST /api/v1/messaging/{thread_id}/
```

**Request Body:**

```json
{
  "content": "Here's an attachment for you.",
  "attachment": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="
}
```

**Usage:**

```dart
final request = CreateMessageRequest(
  content: 'Here is an image attachment',
  attachment: 'data:image/png;base64,${base64EncodedImage}',
);
final response = await messagingService.createMessageInThread('thread_id_here', request);
```

### WebSocket Real-time Messaging

#### Connection URL

```
ws://your-domain.com/ws/chat/{thread_id}/
```

**Usage:**

```dart
final messagingService = ref.read(messagingServiceProvider);
final channel = messagingService.connectToThread('thread_id_here');

// Listen to messages
channel.stream.listen((data) {
  final message = WebSocketMessage.fromJson(json.decode(data));
  // Handle different message types
});
```

#### Message Types

**Send Message:**

```json
{
  "type": "message",
  "message": "Hello!"
}
```

**Typing Indicator:**

```json
{
  "type": "typing",
  "is_typing": true
}
```

**Read Receipt:**

```json
{
  "type": "read_receipt",
  "message_id": "uuid"
}
```

**Usage:**

```dart
// Send message
messagingService.sendMessageViaWebSocket(channel, 'Hello!');

// Send typing indicator
messagingService.sendTypingIndicator(channel, true);

// Send read receipt
messagingService.sendReadReceipt(channel, 'message_id');
```

## Quick Start Guide

### 1. Setup Service Provider

```dart
// Update your main.dart or provider setup
final messagingServiceProvider = Provider<MessagingService>((ref) {
  return MessagingService(
    baseUrl: 'https://your-api-domain.com',
    apiVersion: 'v1',
    getAccessToken: () => ref.read(authServiceProvider).accessToken,
  );
});
```

### 2. List Threads

```dart
class ThreadsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsAsync = ref.watch(threadListProvider(null));
    
    return threadsAsync.when(
      data: (threads) => ListView.builder(
        itemCount: threads.results.length,
        itemBuilder: (context, index) {
          final thread = threads.results[index];
          return ListTile(
            title: Text(thread.threadType.value.toUpperCase()),
            subtitle: Text('${thread.participantIds.length} participants'),
            trailing: thread.unreadCount > 0 
                ? Badge(label: Text('${thread.unreadCount}'))
                : null,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(threadId: thread.id),
              ),
            ),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 3. Create Thread

```dart
Future<void> createNewThread() async {
  final messagingService = ref.read(messagingServiceProvider);
  
  final response = await messagingService.createGeneralThread(
    participantIds: ['provider123', 'customer456'],
    initialMessage: 'Hello! I have a question about your service.',
  );
  
  if (response.success) {
    // Navigate to the new thread
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(threadId: response.data!.id),
      ),
    );
  }
}
```

### 4. Real-time Chat

```dart
class ChatScreen extends ConsumerStatefulWidget {
  final String threadId;
  
  const ChatScreen({required this.threadId});
  
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  WebSocketChannel? _channel;
  
  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }
  
  void _connectToWebSocket() {
    final messagingService = ref.read(messagingServiceProvider);
    _channel = messagingService.connectToThread(widget.threadId);
  }
  
  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesInThreadProvider(widget.threadId));
    
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  return MessageBubble(message: message);
                },
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          MessageInput(
            onSend: (text) {
              if (_channel != null) {
                final messagingService = ref.read(messagingServiceProvider);
                messagingService.sendMessageViaWebSocket(_channel!, text);
              }
            },
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
```

### 5. Utility Methods

```dart
// Create different types of threads
final bidThread = await messagingService.createBidThread(
  participantIds: ['provider123', 'customer456'],
  initialMessage: 'I'm interested in your bid',
  bidId: 'bid_123',
);

final bookingThread = await messagingService.createBookingThread(
  participantIds: ['provider123', 'customer456'],
  initialMessage: 'Question about our booking',
  bookingId: 'booking_123',
);

final supportThread = await messagingService.createSupportThread(
  participantIds: ['admin_user'],
  initialMessage: 'I need help with my account',
);

// Check unread messages
final unreadCount = await messagingService.getUnreadCount();
debugPrint('Total unread: ${unreadCount.data?.totalUnread}');

// Mark messages as read
await messagingService.markAllMessagesInThreadAsRead('thread_id');
await messagingService.markSpecificMessagesAsRead(['msg1', 'msg2']);
```

## Error Handling

All service methods return a `MessagingResponse<T>` object with the following structure:

```dart
class MessagingResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
}
```

Example error handling:

```dart
final response = await messagingService.createThread(request);

if (response.success && response.data != null) {
  // Success - use response.data
  final thread = response.data!;
  debugPrint('Created thread: ${thread.id}');
} else {
  // Error - show user-friendly message
  final errorMessage = response.message ?? 'An error occurred';
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage)),
  );
}
```

## Integration with Router

Add messaging routes to your router:

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/messaging',
      builder: (context, state) => const DurgasMessagingScreen(),
    ),
    GoRoute(
      path: '/chat/:threadId',
      builder: (context, state) => ChatScreen(
        threadId: state.pathParameters['threadId']!,
      ),
    ),
  ],
);
```

## Dependencies

Make sure to add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  http: ^1.1.0
  web_socket_channel: ^3.0.0
```

## Configuration

Update your messaging service configuration:

```dart
// In your app initialization
final messagingServiceProvider = Provider<MessagingService>((ref) {
  return MessagingService(
    baseUrl: dotenv.env['API_BASE_URL'] ?? 'https://your-api-domain.com',
    apiVersion: 'v1',
    getAccessToken: () => ref.read(authServiceProvider).accessToken,
  );
});
```

## Best Practices

1. **Connection Management**: Always close WebSocket connections when leaving chat screens
2. **Error Handling**: Implement proper error handling for all API calls
3. **State Management**: Use Riverpod providers for efficient state management
4. **Performance**: Use pagination for large message lists
5. **Offline Support**: Consider implementing local caching for messages
6. **Security**: Always validate user permissions before allowing access to threads

## Support

For any issues or questions regarding the messaging service implementation, please refer to the example files:
- `lib/services/messaging_service.dart` - Main service implementation
- `lib/example/messaging_service_examples.dart` - Complete usage examples

The service is fully compatible with the Messaging Postman collection and implements all available endpoints. 