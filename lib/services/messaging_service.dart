import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Thread type enumeration
enum ThreadType {
  customer,
  provider,
  support,
  admin;

  String get value {
    switch (this) {
      case ThreadType.customer:
        return 'customer';
      case ThreadType.provider:
        return 'provider';
      case ThreadType.support:
        return 'support';
      case ThreadType.admin:
        return 'admin';
    }
  }

  static ThreadType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'customer':
        return ThreadType.customer;
      case 'provider':
        return ThreadType.provider;
      case 'support':
        return ThreadType.support;
      case 'admin':
        return ThreadType.admin;
      default:
        return ThreadType.customer;
    }
  }
}

/// Message ordering enumeration
enum MessageOrdering {
  updatedAtAsc,
  updatedAtDesc,
  createdAtAsc,
  createdAtDesc;

  String get value {
    switch (this) {
      case MessageOrdering.updatedAtAsc:
        return 'updated_at';
      case MessageOrdering.updatedAtDesc:
        return '-updated_at';
      case MessageOrdering.createdAtAsc:
        return 'created_at';
      case MessageOrdering.createdAtDesc:
        return '-created_at';
    }
  }
}

/// WebSocket message model
class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  const WebSocketMessage({
    required this.type,
    required this.data,
    required this.timestamp,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Unread count model
class UnreadCount {
  final int totalUnread;
  final Map<String, int> threadUnread;

  const UnreadCount({
    required this.totalUnread,
    required this.threadUnread,
  });

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    return UnreadCount(
      totalUnread: json['total_unread'] as int? ?? 0,
      threadUnread: Map<String, int>.from(json['thread_unread'] ?? {}),
    );
  }
}

/// Message type enumeration
enum MessageType {
  text,
  image,
  file,
  system;

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
      default:
        return MessageType.text;
    }
  }
}

/// Message thread model
class MessageThread {
  final String id;
  final String? bookingId;
  final List<String> participantIds;
  final String? lastMessageId;
  final String? lastMessageContent;
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCounts; // userId -> unread count
  final bool isActive;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ThreadType? threadType;
  final Message? lastMessage;

  const MessageThread({
    required this.id,
    this.bookingId,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageAt,
    required this.unreadCounts,
    required this.isActive,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.threadType,
    this.lastMessage,
  });

  /// Get unread count for current user (assumes first user in unreadCounts)
  int get unreadCount {
    if (unreadCounts.isEmpty) return 0;
    return unreadCounts.values.first;
  }

  factory MessageThread.fromJson(Map<String, dynamic> json) {
    return MessageThread(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String?,
      participantIds: List<String>.from(json['participant_ids'] ?? []),
      lastMessageId: json['last_message_id'] as String?,
      lastMessageContent: json['last_message_content'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      unreadCounts: Map<String, int>.from(json['unread_counts'] ?? {}),
      isActive: json['is_active'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      threadType: json['thread_type'] != null
          ? ThreadType.fromString(json['thread_type'] as String)
          : null,
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (bookingId != null) 'booking_id': bookingId,
      'participant_ids': participantIds,
      if (lastMessageId != null) 'last_message_id': lastMessageId,
      if (lastMessageContent != null)
        'last_message_content': lastMessageContent,
      if (lastMessageAt != null)
        'last_message_at': lastMessageAt!.toIso8601String(),
      'unread_counts': unreadCounts,
      'is_active': isActive,
      if (metadata != null) 'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Message model
class Message {
  final String id;
  final String threadId;
  final String senderId;
  final MessageType type;
  final String content;
  final List<String>? attachmentUrls;
  final Map<String, dynamic>? metadata;
  final bool isEdited;
  final DateTime? editedAt;
  final bool isDeleted;
  final DateTime sentAt;
  final Map<String, DateTime> readBy; // userId -> read timestamp

  const Message({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.type,
    required this.content,
    this.attachmentUrls,
    this.metadata,
    required this.isEdited,
    this.editedAt,
    required this.isDeleted,
    required this.sentAt,
    required this.readBy,
  });

  /// Check if message is read (assumes any read timestamp means it's read)
  bool get isRead => readBy.isNotEmpty;

  /// Get attachment (first attachment URL if any)
  String? get attachment =>
      attachmentUrls?.isNotEmpty == true ? attachmentUrls!.first : null;

  /// Alias for sentAt
  DateTime get createdAt => sentAt;

  factory Message.fromJson(Map<String, dynamic> json) {
    final readByData = json['read_by'] as Map<String, dynamic>? ?? {};
    final readBy = <String, DateTime>{};
    for (final entry in readByData.entries) {
      readBy[entry.key] = DateTime.parse(entry.value as String);
    }

    return Message(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      senderId: json['sender_id'] as String,
      type: MessageType.fromString(json['type'] as String),
      content: json['content'] as String,
      attachmentUrls: json['attachment_urls'] != null
          ? List<String>.from(json['attachment_urls'])
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isEdited: json['is_edited'] as bool? ?? false,
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'] as String)
          : null,
      isDeleted: json['is_deleted'] as bool? ?? false,
      sentAt: DateTime.parse(json['sent_at'] as String),
      readBy: readBy,
    );
  }

  Map<String, dynamic> toJson() {
    final readByData = <String, String>{};
    for (final entry in readBy.entries) {
      readByData[entry.key] = entry.value.toIso8601String();
    }

    return {
      'id': id,
      'thread_id': threadId,
      'sender_id': senderId,
      'type': type.value,
      'content': content,
      if (attachmentUrls != null) 'attachment_urls': attachmentUrls,
      if (metadata != null) 'metadata': metadata,
      'is_edited': isEdited,
      if (editedAt != null) 'edited_at': editedAt!.toIso8601String(),
      'is_deleted': isDeleted,
      'sent_at': sentAt.toIso8601String(),
      'read_by': readByData,
    };
  }
}

/// Message request model
class MessageRequest {
  final MessageType type;
  final String content;
  final List<String>? attachmentUrls;
  final Map<String, dynamic>? metadata;

  const MessageRequest({
    required this.type,
    required this.content,
    this.attachmentUrls,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'content': content,
      if (attachmentUrls != null) 'attachment_urls': attachmentUrls,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Thread creation request
class ThreadCreationRequest {
  final List<String> participantIds;
  final String? bookingId;
  final String? initialMessage;
  final Map<String, dynamic>? metadata;

  const ThreadCreationRequest({
    required this.participantIds,
    this.bookingId,
    this.initialMessage,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'participant_ids': participantIds,
      if (bookingId != null) 'booking_id': bookingId,
      if (initialMessage != null) 'initial_message': initialMessage,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Messaging service for handling threads and messages
class MessagingService {
  final ApiService _apiService;

  MessagingService(this._apiService);

  // === MESSAGE THREADS ===

  /// Get all message threads for current user
  Future<ApiResponse<List<MessageThread>>> getThreads({
    bool? activeOnly,
    String? bookingId,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (activeOnly != null) queryParams['active_only'] = '$activeOnly';
    if (bookingId != null) queryParams['booking_id'] = bookingId;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<MessageThread>>(
      '/messages/threads/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((thread) => MessageThread.fromJson(thread))
          .toList(),
    );
  }

  /// Get specific message thread
  Future<ApiResponse<MessageThread>> getThread(String threadId) async {
    return _apiService.get<MessageThread>(
      '/messages/threads/$threadId/',
      fromJson: (data) => MessageThread.fromJson(data),
    );
  }

  /// Create new message thread
  Future<ApiResponse<MessageThread>> createThread(
      ThreadCreationRequest request) async {
    return _apiService.post<MessageThread>(
      '/messages/threads/',
      body: request.toJson(),
      fromJson: (data) => MessageThread.fromJson(data),
    );
  }

  /// Update thread metadata
  Future<ApiResponse<MessageThread>> updateThread(
    String threadId,
    Map<String, dynamic> updates,
  ) async {
    return _apiService.patch<MessageThread>(
      '/messages/threads/$threadId/',
      body: updates,
      fromJson: (data) => MessageThread.fromJson(data),
    );
  }

  /// Archive/deactivate thread
  Future<ApiResponse<MessageThread>> archiveThread(String threadId) async {
    return _apiService.post<MessageThread>(
      '/messages/threads/$threadId/archive/',
      fromJson: (data) => MessageThread.fromJson(data),
    );
  }

  /// Add participant to thread
  Future<ApiResponse<MessageThread>> addParticipant(
    String threadId,
    String userId,
  ) async {
    return _apiService.post<MessageThread>(
      '/messages/threads/$threadId/participants/',
      body: {'user_id': userId},
      fromJson: (data) => MessageThread.fromJson(data),
    );
  }

  /// Remove participant from thread
  Future<ApiResponse<MessageThread>> removeParticipant(
    String threadId,
    String userId,
  ) async {
    return _apiService.delete<MessageThread>(
      '/messages/threads/$threadId/participants/$userId/',
      fromJson: (data) => MessageThread.fromJson(data),
    );
  }

  // === MESSAGES ===

  /// Get messages in a thread
  Future<ApiResponse<List<Message>>> getMessages(
    String threadId, {
    DateTime? before,
    DateTime? after,
    int? limit,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (before != null) queryParams['before'] = before.toIso8601String();
    if (after != null) queryParams['after'] = after.toIso8601String();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Message>>(
      '/messages/threads/$threadId/messages/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }

  /// Get specific message
  Future<ApiResponse<Message>> getMessage(String messageId) async {
    return _apiService.get<Message>(
      '/messages/$messageId/',
      fromJson: (data) => Message.fromJson(data),
    );
  }

  /// Send message to thread
  Future<ApiResponse<Message>> sendMessage(
    String threadId,
    MessageRequest request,
  ) async {
    return _apiService.post<Message>(
      '/messages/threads/$threadId/messages/',
      body: request.toJson(),
      fromJson: (data) => Message.fromJson(data),
    );
  }

  /// Edit message
  Future<ApiResponse<Message>> editMessage(
    String messageId,
    String newContent,
  ) async {
    return _apiService.patch<Message>(
      '/messages/$messageId/',
      body: {'content': newContent},
      fromJson: (data) => Message.fromJson(data),
    );
  }

  /// Delete message
  Future<ApiResponse<Message>> deleteMessage(String messageId) async {
    return _apiService.delete<Message>(
      '/messages/$messageId/',
      fromJson: (data) => Message.fromJson(data),
    );
  }

  /// Mark message as read
  Future<ApiResponse<Map<String, dynamic>>> markMessageAsRead(
      String messageId) async {
    return _apiService.post<Map<String, dynamic>>(
      '/messages/$messageId/read/',
      fromJson: (data) => data,
    );
  }

  /// Mark all messages in thread as read
  Future<ApiResponse<Map<String, dynamic>>> markThreadAsRead(
      String threadId) async {
    return _apiService.post<Map<String, dynamic>>(
      '/messages/threads/$threadId/read_all/',
      fromJson: (data) => data,
    );
  }

  // === MESSAGE SEARCH ===

  /// Search messages across all threads
  Future<ApiResponse<List<Message>>> searchMessages({
    required String query,
    String? threadId,
    MessageType? type,
    String? senderId,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? pageSize,
  }) async {
    return _apiService.post<List<Message>>(
      '/messages/search/',
      body: {
        'query': query,
        if (threadId != null) 'thread_id': threadId,
        if (type != null) 'type': type.value,
        if (senderId != null) 'sender_id': senderId,
        if (startDate != null)
          'start_date': startDate.toIso8601String().split('T')[0],
        if (endDate != null)
          'end_date': endDate.toIso8601String().split('T')[0],
        if (page != null) 'page': page,
        if (pageSize != null) 'page_size': pageSize,
      },
      fromJson: (data) => (data['results'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }

  // === FILE UPLOADS ===

  /// Upload file for messaging
  Future<ApiResponse<Map<String, dynamic>>> uploadMessageFile(
    String filePath,
    MessageType fileType,
  ) async {
    // Note: This would typically use multipart/form-data
    // Implementation depends on your file upload strategy
    return _apiService.post<Map<String, dynamic>>(
      '/messages/upload/',
      body: {
        'file_path': filePath,
        'file_type': fileType.value,
      },
      fromJson: (data) => data,
    );
  }

  /// Get upload URL for direct file upload
  Future<ApiResponse<Map<String, dynamic>>> getUploadUrl({
    required String fileName,
    required String fileType,
    required int fileSize,
  }) async {
    return _apiService.post<Map<String, dynamic>>(
      '/messages/upload_url/',
      body: {
        'file_name': fileName,
        'file_type': fileType,
        'file_size': fileSize,
      },
      fromJson: (data) => data,
    );
  }

  // === NOTIFICATIONS ===

  /// Get unread message count
  Future<ApiResponse<Map<String, dynamic>>> getUnreadCount() async {
    return _apiService.get<Map<String, dynamic>>(
      '/messages/unread_count/',
      fromJson: (data) => data,
    );
  }

  /// Get unread messages summary
  Future<ApiResponse<Map<String, dynamic>>> getUnreadSummary() async {
    return _apiService.get<Map<String, dynamic>>(
      '/messages/unread_summary/',
      fromJson: (data) => data,
    );
  }

  // === THREAD ANALYTICS ===

  /// Get thread activity statistics
  Future<ApiResponse<Map<String, dynamic>>> getThreadStats(
      String threadId) async {
    return _apiService.get<Map<String, dynamic>>(
      '/messages/threads/$threadId/stats/',
      fromJson: (data) => data,
    );
  }

  /// Get user messaging analytics
  Future<ApiResponse<Map<String, dynamic>>> getUserMessagingStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }

    return _apiService.get<Map<String, dynamic>>(
      '/messages/stats/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }

  // === ADMIN OPERATIONS ===

  /// Admin: Get all threads with filters
  Future<ApiResponse<List<MessageThread>>> adminGetThreads({
    bool? isActive,
    String? participantId,
    String? bookingId,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (isActive != null) queryParams['is_active'] = '$isActive';
    if (participantId != null) queryParams['participant_id'] = participantId;
    if (bookingId != null) queryParams['booking_id'] = bookingId;
    if (createdAfter != null) {
      queryParams['created_after'] =
          createdAfter.toIso8601String().split('T')[0];
    }
    if (createdBefore != null) {
      queryParams['created_before'] =
          createdBefore.toIso8601String().split('T')[0];
    }
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<MessageThread>>(
      '/admin/messages/threads/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((thread) => MessageThread.fromJson(thread))
          .toList(),
    );
  }

  /// Admin: Moderate message
  Future<ApiResponse<Message>> moderateMessage(
    String messageId, {
    required String action, // 'flag', 'delete', 'approve'
    String? reason,
  }) async {
    return _apiService.post<Message>(
      '/admin/messages/$messageId/moderate/',
      body: {
        'action': action,
        if (reason != null) 'reason': reason,
      },
      fromJson: (data) => Message.fromJson(data),
    );
  }

  /// Admin: Get reported messages
  Future<ApiResponse<List<Message>>> getReportedMessages({
    String? status, // 'pending', 'reviewed', 'resolved'
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Message>>(
      '/admin/messages/reported/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }

  // === REAL-TIME MESSAGING (WebSocket) ===

  /// Connect to real-time messaging (WebSocket)
  /// Note: This would typically be implemented with a WebSocket library
  Future<ApiResponse<Map<String, dynamic>>> connectRealTimeMessaging() async {
    return _apiService.get<Map<String, dynamic>>(
      '/messages/websocket/connect/',
      fromJson: (data) => data,
    );
  }

  /// Get WebSocket connection info
  Future<ApiResponse<Map<String, dynamic>>> getWebSocketInfo() async {
    return _apiService.get<Map<String, dynamic>>(
      '/messages/websocket/info/',
      fromJson: (data) => data,
    );
  }

  // === ADDITIONAL CONVENIENCE METHODS ===

  /// Connect to specific thread (for WebSocket communication)
  Future<void> connectToThread(String threadId) async {
    // Placeholder for WebSocket thread connection
    // Implementation would depend on your WebSocket strategy
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(String threadId, bool isTyping) async {
    // Placeholder for WebSocket typing indicator
    // Implementation would depend on your WebSocket strategy
  }

  /// Send message via WebSocket
  Future<void> sendMessageViaWebSocket(String threadId, String message) async {
    // Placeholder for WebSocket message sending
    // Implementation would depend on your WebSocket strategy
  }

  /// List all messages across all threads
  Future<ApiResponse<List<Message>>> listAllMessages({
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Message>>(
      '/messages/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }

  /// Delete thread
  Future<ApiResponse<Map<String, dynamic>>> deleteThread(
      String threadId) async {
    return _apiService.delete<Map<String, dynamic>>(
      '/messages/threads/$threadId/',
      fromJson: (data) => data,
    );
  }

  /// Mark all messages in thread as read
  Future<ApiResponse<Map<String, dynamic>>> markAllMessagesInThreadAsRead(
      String threadId) async {
    return markThreadAsRead(threadId);
  }

  /// Mark specific messages as read
  Future<ApiResponse<Map<String, dynamic>>> markSpecificMessagesAsRead(
      List<String> messageIds) async {
    return _apiService.post<Map<String, dynamic>>(
      '/messages/mark_read/',
      body: {'message_ids': messageIds},
      fromJson: (data) => data,
    );
  }

  /// Create message in thread
  Future<ApiResponse<Message>> createMessageInThread(
    String threadId,
    MessageRequest request,
  ) async {
    return sendMessage(threadId, request);
  }

  /// Partial update message
  Future<ApiResponse<Message>> partialUpdateMessage(
    String messageId,
    Map<String, dynamic> updates,
  ) async {
    return _apiService.patch<Message>(
      '/messages/$messageId/',
      body: updates,
      fromJson: (data) => Message.fromJson(data),
    );
  }

  /// Create thread request helper
  Map<String, dynamic> createThreadRequest({
    required List<String> participantIds,
    String? bookingId,
    String? initialMessage,
    Map<String, dynamic>? metadata,
  }) {
    return {
      'participant_ids': participantIds,
      if (bookingId != null) 'booking_id': bookingId,
      if (initialMessage != null) 'initial_message': initialMessage,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Create message request helper
  Map<String, dynamic> createMessageRequest({
    required MessageType type,
    required String content,
    List<String>? attachmentUrls,
    Map<String, dynamic>? metadata,
  }) {
    return {
      'type': type.value,
      'content': content,
      if (attachmentUrls != null) 'attachment_urls': attachmentUrls,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Provider for MessagingService
final messagingServiceProvider = Provider<MessagingService>((ref) {
  return MessagingService(ApiService());
});

/// Provider for unread count
final unreadCountProvider = FutureProvider<UnreadCount>((ref) async {
  final messagingService = ref.read(messagingServiceProvider);
  final response = await messagingService.getUnreadCount();

  if (response.success && response.data != null) {
    return UnreadCount.fromJson(response.data!);
  }

  return const UnreadCount(totalUnread: 0, threadUnread: {});
});

/// Provider for thread list with filters
final threadListProvider = FutureProvider.family<
    ApiResponse<List<MessageThread>>,
    Map<String, dynamic>>((ref, filters) async {
  final messagingService = ref.read(messagingServiceProvider);

  return await messagingService.getThreads(
    activeOnly: filters['active_only'] as bool?,
    bookingId: filters['booking_id'] as String?,
    page: filters['page'] as int?,
    pageSize: filters['page_size'] as int?,
  );
});

/// Provider for messages in a specific thread
final messagesInThreadProvider =
    FutureProvider.family<ApiResponse<List<Message>>, String>(
        (ref, threadId) async {
  final messagingService = ref.read(messagingServiceProvider);

  return await messagingService.getMessages(threadId);
});

/// Provider for a specific thread
final threadProvider =
    FutureProvider.family<ApiResponse<MessageThread>, String>(
        (ref, threadId) async {
  final messagingService = ref.read(messagingServiceProvider);

  return await messagingService.getThread(threadId);
});
