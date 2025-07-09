import 'package:flutter/material.dart';
import 'api_service.dart';

/// Message type enumeration
enum MessageType {
  text,
  image,
  file,
  system,
  notification;

  String get value {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.file:
        return 'file';
      case MessageType.system:
        return 'system';
      case MessageType.notification:
        return 'notification';
    }
  }

  static MessageType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      case 'system':
        return MessageType.system;
      case 'notification':
        return MessageType.notification;
      default:
        return MessageType.text;
    }
  }
}

/// Message status enumeration
enum MessageStatus {
  sent,
  delivered,
  read,
  failed;

  String get value {
    switch (this) {
      case MessageStatus.sent:
        return 'sent';
      case MessageStatus.delivered:
        return 'delivered';
      case MessageStatus.read:
        return 'read';
      case MessageStatus.failed:
        return 'failed';
    }
  }

  static MessageStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }
}

/// Conversation type enumeration
enum ConversationType {
  direct,
  group,
  support,
  booking;

  String get value {
    switch (this) {
      case ConversationType.direct:
        return 'direct';
      case ConversationType.group:
        return 'group';
      case ConversationType.support:
        return 'support';
      case ConversationType.booking:
        return 'booking';
    }
  }

  static ConversationType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'direct':
        return ConversationType.direct;
      case 'group':
        return ConversationType.group;
      case 'support':
        return ConversationType.support;
      case 'booking':
        return ConversationType.booking;
      default:
        return ConversationType.direct;
    }
  }
}

/// Message model
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String? receiverId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata;
  final String? replyToId;
  final List<String>? attachments;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.receiverId,
    required this.content,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
    this.metadata,
    this.replyToId,
    this.attachments,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String?,
      content: json['content'] as String,
      type: MessageType.fromString(json['type'] as String),
      status: MessageStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      replyToId: json['reply_to_id'] as String?,
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      'content': content,
      'type': type.value,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (readAt != null) 'read_at': readAt!.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (attachments != null) 'attachments': attachments,
    };
  }
}

/// Conversation model
class Conversation {
  final String id;
  final String title;
  final ConversationType type;
  final List<String> participantIds;
  final String? lastMessageId;
  final Message? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCount;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  const Conversation({
    required this.id,
    required this.title,
    required this.type,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.unreadCount,
    required this.isActive,
    this.metadata,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      title: json['title'] as String,
      type: ConversationType.fromString(json['type'] as String),
      participantIds: List<String>.from(json['participant_ids']),
      lastMessageId: json['last_message_id'] as String?,
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      unreadCount: json['unread_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.value,
      'participant_ids': participantIds,
      if (lastMessageId != null) 'last_message_id': lastMessageId,
      if (lastMessage != null) 'last_message': lastMessage!.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'unread_count': unreadCount,
      'is_active': isActive,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Send message request model
class SendMessageRequest {
  final String conversationId;
  final String content;
  final MessageType type;
  final String? receiverId;
  final String? replyToId;
  final Map<String, dynamic>? metadata;

  const SendMessageRequest({
    required this.conversationId,
    required this.content,
    this.type = MessageType.text,
    this.receiverId,
    this.replyToId,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'content': content,
      'type': type.value,
      if (receiverId != null) 'receiver_id': receiverId,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Create conversation request model
class CreateConversationRequest {
  final String title;
  final ConversationType type;
  final List<String> participantIds;
  final String? initialMessage;
  final Map<String, dynamic>? metadata;

  const CreateConversationRequest({
    required this.title,
    this.type = ConversationType.direct,
    required this.participantIds,
    this.initialMessage,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.value,
      'participant_ids': participantIds,
      if (initialMessage != null) 'initial_message': initialMessage,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Message list response model
class MessageListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Message> results;

  const MessageListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory MessageListResponse.fromJson(Map<String, dynamic> json) {
    return MessageListResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }
}

/// Conversation list response model
class ConversationListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Conversation> results;

  const ConversationListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ConversationListResponse.fromJson(Map<String, dynamic> json) {
    return ConversationListResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List)
          .map((conversation) => Conversation.fromJson(conversation))
          .toList(),
    );
  }
}

/// Comprehensive Messaging Service for Prbal app
/// Handles conversations, messages, real-time updates, and multimedia messaging
class MessagingService {
  final ApiService _apiService;

  MessagingService(this._apiService) {
    debugPrint('💬 MessagingService: Initializing messaging service');
    debugPrint(
        '💬 MessagingService: Service will handle conversations, messages, and real-time updates');
  }

  // ====================================================================
  // CONVERSATION MANAGEMENT
  // ====================================================================

  /// List user conversations with filtering and pagination
  /// Endpoint: GET /messages/conversations/
  Future<ApiResponse<ConversationListResponse>> listConversations({
    ConversationType? type,
    bool? isActive,
    String? search,
    String? ordering = '-updated_at',
    int? limit,
    int? offset,
  }) async {
    final startTime = DateTime.now();
    debugPrint('💬 MessagingService: Listing conversations');

    final queryParams = <String, String>{};
    if (type != null) {
      queryParams['type'] = type.value;
      debugPrint('💬 MessagingService: Filtering by type: ${type.value}');
    }
    if (isActive != null) {
      queryParams['is_active'] = isActive.toString();
      debugPrint('💬 MessagingService: Filtering by active status: $isActive');
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
      debugPrint('💬 MessagingService: Search query: $search');
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering;
      debugPrint('💬 MessagingService: Ordering: $ordering');
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }
    if (offset != null) {
      queryParams['offset'] = offset.toString();
    }

    try {
      debugPrint(
          '💬 MessagingService: Making API call with query params: $queryParams');

      final response = await _apiService.get(
        '/messages/conversations/',
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) => ConversationListResponse.fromJson(data),
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.success && response.data != null) {
        final conversations = response.data!.results;
        debugPrint(
            '💬 MessagingService: Successfully retrieved ${conversations.length} conversations in ${duration}ms');
        debugPrint(
            '💬 MessagingService: Total unread messages: ${conversations.fold(0, (sum, conv) => sum + conv.unreadCount)}');

        return response;
      }

      debugPrint(
          '💬 MessagingService: Failed to fetch conversations - ${response.message}');
      return ApiResponse<ConversationListResponse>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint(
          '💬 MessagingService: Error fetching conversations (${duration}ms): $e');
      return ApiResponse<ConversationListResponse>(
        success: false,
        message: 'Error fetching conversations: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Get conversation details by ID
  /// Endpoint: GET /messages/conversations/{id}/
  Future<ApiResponse<Conversation>> getConversationDetails(
      String conversationId) async {
    debugPrint(
        '💬 MessagingService: Getting conversation details for ID: $conversationId');

    try {
      final response = await _apiService.get(
        '/messages/conversations/$conversationId/',
        fromJson: (data) => Conversation.fromJson(data),
      );

      if (response.success && response.data != null) {
        final conversation = response.data!;
        debugPrint(
            '💬 MessagingService: Successfully retrieved conversation: ${conversation.title}');
        debugPrint(
            '💬 MessagingService: Participants: ${conversation.participantIds.length}');
        debugPrint(
            '💬 MessagingService: Unread count: ${conversation.unreadCount}');
        debugPrint('💬 MessagingService: Type: ${conversation.type.value}');

        return response;
      }

      debugPrint(
          '💬 MessagingService: Failed to fetch conversation details - ${response.message}');
      return ApiResponse<Conversation>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint(
          '💬 MessagingService: Error fetching conversation details: $e');
      return ApiResponse<Conversation>(
        success: false,
        message: 'Error fetching conversation details: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Create a new conversation
  /// Endpoint: POST /messages/conversations/
  Future<ApiResponse<Conversation>> createConversation(
      CreateConversationRequest request) async {
    debugPrint('💬 MessagingService: Creating new conversation');
    debugPrint('💬 MessagingService: Title: ${request.title}');
    debugPrint('💬 MessagingService: Type: ${request.type.value}');
    debugPrint(
        '💬 MessagingService: Participants: ${request.participantIds.length}');

    try {
      final response = await _apiService.post(
        '/messages/conversations/',
        body: request.toJson(),
        fromJson: (data) => Conversation.fromJson(data),
      );

      if (response.success && response.data != null) {
        final conversation = response.data!;
        debugPrint(
            '💬 MessagingService: Conversation created successfully: ${conversation.id}');
        debugPrint(
            '💬 MessagingService: Created at: ${conversation.createdAt}');

        return response;
      }

      debugPrint(
          '💬 MessagingService: Failed to create conversation - ${response.message}');
      return ApiResponse<Conversation>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💬 MessagingService: Error creating conversation: $e');
      return ApiResponse<Conversation>(
        success: false,
        message: 'Error creating conversation: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Archive/deactivate a conversation
  /// Endpoint: PATCH /messages/conversations/{id}/
  Future<ApiResponse<Conversation>> archiveConversation(
      String conversationId) async {
    debugPrint('💬 MessagingService: Archiving conversation: $conversationId');

    try {
      final response = await _apiService.patch(
        '/messages/conversations/$conversationId/',
        body: {'is_active': false},
        fromJson: (data) => Conversation.fromJson(data),
      );

      if (response.success) {
        debugPrint('💬 MessagingService: Conversation archived successfully');
      } else {
        debugPrint(
            '💬 MessagingService: Failed to archive conversation - ${response.message}');
      }

      return response;
    } catch (e) {
      debugPrint('💬 MessagingService: Error archiving conversation: $e');
      return ApiResponse<Conversation>(
        success: false,
        message: 'Error archiving conversation: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // MESSAGE MANAGEMENT
  // ====================================================================

  /// List messages in a conversation with pagination
  /// Endpoint: GET /messages/conversations/{id}/messages/
  Future<ApiResponse<MessageListResponse>> listMessages(
    String conversationId, {
    String? ordering = '-created_at',
    int? limit = 50,
    int? offset,
    DateTime? since,
    DateTime? until,
  }) async {
    final startTime = DateTime.now();
    debugPrint(
        '💬 MessagingService: Listing messages for conversation: $conversationId');

    final queryParams = <String, String>{};
    if (ordering != null) {
      queryParams['ordering'] = ordering;
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }
    if (offset != null) {
      queryParams['offset'] = offset.toString();
    }
    if (since != null) {
      queryParams['since'] = since.toIso8601String();
      debugPrint(
          '💬 MessagingService: Filtering messages since: ${since.toString().substring(0, 19)}');
    }
    if (until != null) {
      queryParams['until'] = until.toIso8601String();
      debugPrint(
          '💬 MessagingService: Filtering messages until: ${until.toString().substring(0, 19)}');
    }

    try {
      debugPrint(
          '💬 MessagingService: Making API call with query params: $queryParams');

      final response = await _apiService.get(
        '/messages/conversations/$conversationId/messages/',
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) => MessageListResponse.fromJson(data),
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.success && response.data != null) {
        final messages = response.data!.results;
        debugPrint(
            '💬 MessagingService: Successfully retrieved ${messages.length} messages in ${duration}ms');

        // Count messages by type for analytics
        final messagesByType = <MessageType, int>{};
        for (final message in messages) {
          messagesByType[message.type] =
              (messagesByType[message.type] ?? 0) + 1;
        }
        debugPrint(
            '💬 MessagingService: Message types breakdown: $messagesByType');

        return response;
      }

      debugPrint(
          '💬 MessagingService: Failed to fetch messages - ${response.message}');
      return ApiResponse<MessageListResponse>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint(
          '💬 MessagingService: Error fetching messages (${duration}ms): $e');
      return ApiResponse<MessageListResponse>(
        success: false,
        message: 'Error fetching messages: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Send a new message
  /// Endpoint: POST /messages/conversations/{id}/messages/
  Future<ApiResponse<Message>> sendMessage(SendMessageRequest request) async {
    debugPrint('💬 MessagingService: Sending message');
    debugPrint(
        '💬 MessagingService: Conversation ID: ${request.conversationId}');
    debugPrint('💬 MessagingService: Message type: ${request.type.value}');
    debugPrint(
        '💬 MessagingService: Content length: ${request.content.length} chars');

    try {
      final response = await _apiService.post(
        '/messages/conversations/${request.conversationId}/messages/',
        body: request.toJson(),
        fromJson: (data) => Message.fromJson(data),
      );

      if (response.success && response.data != null) {
        final message = response.data!;
        debugPrint(
            '💬 MessagingService: Message sent successfully: ${message.id}');
        debugPrint('💬 MessagingService: Status: ${message.status.value}');
        debugPrint('💬 MessagingService: Created at: ${message.createdAt}');

        return response;
      }

      debugPrint(
          '💬 MessagingService: Failed to send message - ${response.message}');
      return ApiResponse<Message>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💬 MessagingService: Error sending message: $e');
      return ApiResponse<Message>(
        success: false,
        message: 'Error sending message: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Mark message as read
  /// Endpoint: PATCH /messages/{id}/read/
  Future<ApiResponse<Message>> markMessageAsRead(String messageId) async {
    debugPrint('💬 MessagingService: Marking message as read: $messageId');

    try {
      final response = await _apiService.patch(
        '/messages/$messageId/read/',
        body: {'read_at': DateTime.now().toIso8601String()},
        fromJson: (data) => Message.fromJson(data),
      );

      if (response.success) {
        debugPrint('💬 MessagingService: Message marked as read successfully');
      } else {
        debugPrint(
            '💬 MessagingService: Failed to mark message as read - ${response.message}');
      }

      return response;
    } catch (e) {
      debugPrint('💬 MessagingService: Error marking message as read: $e');
      return ApiResponse<Message>(
        success: false,
        message: 'Error marking message as read: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Mark all messages in conversation as read
  /// Endpoint: POST /messages/conversations/{id}/mark-all-read/
  Future<ApiResponse<Map<String, dynamic>>> markAllMessagesAsRead(
      String conversationId) async {
    debugPrint(
        '💬 MessagingService: Marking all messages as read in conversation: $conversationId');

    try {
      final response = await _apiService.post(
        '/messages/conversations/$conversationId/mark-all-read/',
        body: {'read_at': DateTime.now().toIso8601String()},
        fromJson: (data) => Map<String, dynamic>.from(data as Map),
      );

      if (response.success) {
        final markedCount = response.data?['marked_count'] ?? 0;
        debugPrint('💬 MessagingService: Marked $markedCount messages as read');
      } else {
        debugPrint(
            '💬 MessagingService: Failed to mark all messages as read - ${response.message}');
      }

      return response;
    } catch (e) {
      debugPrint('💬 MessagingService: Error marking all messages as read: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error marking all messages as read: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Delete a message
  /// Endpoint: DELETE /messages/{id}/
  Future<ApiResponse<void>> deleteMessage(String messageId) async {
    debugPrint('💬 MessagingService: Deleting message: $messageId');

    try {
      final response = await _apiService.delete('/messages/$messageId/');

      if (response.success) {
        debugPrint('💬 MessagingService: Message deleted successfully');
      } else {
        debugPrint(
            '💬 MessagingService: Failed to delete message - ${response.message}');
      }

      return ApiResponse<void>(
        success: response.success,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💬 MessagingService: Error deleting message: $e');
      return ApiResponse<void>(
        success: false,
        message: 'Error deleting message: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // SEARCH AND FILTERING
  // ====================================================================

  /// Search messages across all conversations
  /// Endpoint: GET /messages/search/
  Future<ApiResponse<MessageListResponse>> searchMessages({
    required String query,
    String? conversationId,
    MessageType? type,
    String? senderId,
    DateTime? since,
    DateTime? until,
    int? limit = 20,
  }) async {
    debugPrint('💬 MessagingService: Searching messages');
    debugPrint('💬 MessagingService: Query: "$query"');

    final queryParams = <String, String>{
      'q': query,
    };

    if (conversationId != null) {
      queryParams['conversation_id'] = conversationId;
      debugPrint(
          '💬 MessagingService: Limiting search to conversation: $conversationId');
    }
    if (type != null) {
      queryParams['type'] = type.value;
      debugPrint(
          '💬 MessagingService: Filtering by message type: ${type.value}');
    }
    if (senderId != null) {
      queryParams['sender_id'] = senderId;
      debugPrint('💬 MessagingService: Filtering by sender: $senderId');
    }
    if (since != null) {
      queryParams['since'] = since.toIso8601String();
    }
    if (until != null) {
      queryParams['until'] = until.toIso8601String();
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    try {
      final response = await _apiService.get(
        '/messages/search/',
        queryParams: queryParams,
        fromJson: (data) => MessageListResponse.fromJson(data),
      );

      if (response.success && response.data != null) {
        final messages = response.data!.results;
        debugPrint(
            '💬 MessagingService: Found ${messages.length} messages matching query');

        return response;
      }

      debugPrint(
          '💬 MessagingService: Message search failed - ${response.message}');
      return ApiResponse<MessageListResponse>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💬 MessagingService: Error searching messages: $e');
      return ApiResponse<MessageListResponse>(
        success: false,
        message: 'Error searching messages: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // UTILITY AND HELPER METHODS
  // ====================================================================

  /// Get unread message count across all conversations
  Future<int> getUnreadMessageCount() async {
    debugPrint('💬 MessagingService: Getting total unread message count');

    try {
      final response = await listConversations(isActive: true);

      if (response.success && response.data != null) {
        final totalUnread = response.data!.results
            .fold(0, (sum, conv) => sum + conv.unreadCount);
        debugPrint('💬 MessagingService: Total unread messages: $totalUnread');
        return totalUnread;
      }
    } catch (e) {
      debugPrint('💬 MessagingService: Error getting unread count: $e');
    }

    return 0;
  }

  /// Get message statistics for analytics
  Future<Map<String, dynamic>> getMessageStatistics() async {
    debugPrint('💬 MessagingService: Generating message statistics');

    try {
      final conversationsResponse = await listConversations();

      if (conversationsResponse.success && conversationsResponse.data != null) {
        final conversations = conversationsResponse.data!.results;
        final stats = {
          'total_conversations': conversations.length,
          'active_conversations': conversations.where((c) => c.isActive).length,
          'total_unread':
              conversations.fold(0, (sum, conv) => sum + conv.unreadCount),
          'conversation_types': <String, int>{},
          'last_activity': conversations.isNotEmpty
              ? conversations
                  .map((c) => c.updatedAt)
                  .reduce((a, b) => a.isAfter(b) ? a : b)
                  .toIso8601String()
              : null,
        };

        // Group by conversation type
        for (final conversation in conversations) {
          final type = conversation.type.value;
          final conversationTypes =
              stats['conversation_types'] as Map<String, int>;
          conversationTypes[type] = (conversationTypes[type] ?? 0) + 1;
        }

        debugPrint('💬 MessagingService: Statistics generated successfully');
        debugPrint(
            '💬 MessagingService: Total conversations: ${stats['total_conversations']}');
        debugPrint(
            '💬 MessagingService: Total unread: ${stats['total_unread']}');

        return stats;
      }
    } catch (e) {
      debugPrint('💬 MessagingService: Error generating statistics: $e');
    }

    return {'error': 'Failed to generate statistics'};
  }

  /// Check messaging service health
  Future<Map<String, dynamic>> checkMessagingHealth() async {
    debugPrint('💬 MessagingService: Performing health check');

    final startTime = DateTime.now();
    try {
      // Test basic functionality by fetching conversations
      final response = await listConversations(limit: 1);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      final healthStatus = {
        'service': 'Messaging',
        'status': response.success ? 'healthy' : 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': response.success ? null : response.message,
      };

      debugPrint('💬 MessagingService: Health check completed');
      debugPrint('💬 MessagingService: Status: ${healthStatus['status']}');
      debugPrint('💬 MessagingService: Response time: ${duration}ms');

      return healthStatus;
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('💬 MessagingService: Health check failed: $e');

      return {
        'service': 'Messaging',
        'status': 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': 'Health check failed: $e',
      };
    }
  }

  /// Get conversation for specific booking/service
  Future<ApiResponse<Conversation>> getBookingConversation(
      String bookingId) async {
    debugPrint(
        '💬 MessagingService: Getting conversation for booking: $bookingId');

    try {
      final response = await listConversations(
        type: ConversationType.booking,
        search: bookingId,
      );

      if (response.success &&
          response.data != null &&
          response.data!.results.isNotEmpty) {
        final conversation = response.data!.results.first;
        debugPrint(
            '💬 MessagingService: Found booking conversation: ${conversation.id}');

        return ApiResponse<Conversation>(
          success: true,
          data: conversation,
          message: 'Booking conversation found',
          statusCode: 200,
          time: DateTime.now(),
        );
      }

      debugPrint(
          '💬 MessagingService: No conversation found for booking: $bookingId');
      return ApiResponse<Conversation>(
        success: false,
        message: 'No conversation found for this booking',
        statusCode: 404,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💬 MessagingService: Error getting booking conversation: $e');
      return ApiResponse<Conversation>(
        success: false,
        message: 'Error getting booking conversation: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Send quick reply templates
  Future<ApiResponse<Message>> sendQuickReply(
    String conversationId,
    String templateType, {
    Map<String, dynamic>? variables,
  }) async {
    debugPrint(
        '💬 MessagingService: Sending quick reply template: $templateType');

    final templates = {
      'greeting': 'Hello! How can I help you today?',
      'booking_confirmed':
          'Your booking has been confirmed. We\'ll see you soon!',
      'on_my_way': 'I\'m on my way to your location.',
      'completed': 'Service completed successfully. Thank you!',
      'follow_up': 'How was your experience with our service?',
    };

    String content = templates[templateType] ?? templateType;

    // Replace variables if provided
    if (variables != null) {
      for (final entry in variables.entries) {
        content = content.replaceAll('{${entry.key}}', entry.value.toString());
      }
    }

    final request = SendMessageRequest(
      conversationId: conversationId,
      content: content,
      type: MessageType.text,
      metadata: {'template_type': templateType, 'is_quick_reply': true},
    );

    return await sendMessage(request);
  }
}
