import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// AI Suggestion model
class AISuggestion {
  final String id;
  final String suggestionType; // bid_amount, pricing, service_improvement, etc.
  final String title;
  final String description;
  final Map<String, dynamic>? suggestionData;
  final String status; // new, viewed, implemented, rejected
  final String userId;
  final String? serviceId;
  final double? confidenceScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? viewedAt;
  final DateTime? implementedAt;

  const AISuggestion({
    required this.id,
    required this.suggestionType,
    required this.title,
    required this.description,
    this.suggestionData,
    required this.status,
    required this.userId,
    this.serviceId,
    this.confidenceScore,
    required this.createdAt,
    required this.updatedAt,
    this.viewedAt,
    this.implementedAt,
  });

  factory AISuggestion.fromJson(Map<String, dynamic> json) {
    return AISuggestion(
      id: json['id'] as String,
      suggestionType: json['suggestion_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      suggestionData: json['suggestion_data'] as Map<String, dynamic>?,
      status: json['status'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String?,
      confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      viewedAt: json['viewed_at'] != null
          ? DateTime.parse(json['viewed_at'] as String)
          : null,
      implementedAt: json['implemented_at'] != null
          ? DateTime.parse(json['implemented_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'suggestion_type': suggestionType,
      'title': title,
      'description': description,
      'suggestion_data': suggestionData,
      'status': status,
      'user_id': userId,
      'service_id': serviceId,
      'confidence_score': confidenceScore,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'viewed_at': viewedAt?.toIso8601String(),
      'implemented_at': implementedAt?.toIso8601String(),
    };
  }
}

/// AI Feedback Log model
class AIFeedbackLog {
  final String id;
  final String? suggestionId;
  final String? bidId;
  final String userId;
  final String interactionType; // use, feedback, accept_bid, etc.
  final Map<String, dynamic> interactionData;
  final DateTime createdAt;

  const AIFeedbackLog({
    required this.id,
    this.suggestionId,
    this.bidId,
    required this.userId,
    required this.interactionType,
    required this.interactionData,
    required this.createdAt,
  });

  factory AIFeedbackLog.fromJson(Map<String, dynamic> json) {
    return AIFeedbackLog(
      id: json['id'] as String,
      suggestionId: json['suggestion'] as String?,
      bidId: json['bid'] as String?,
      userId: json['user_id'] as String,
      interactionType: json['interaction_type'] as String,
      interactionData: json['interaction_data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'suggestion': suggestionId,
      'bid': bidId,
      'user_id': userId,
      'interaction_type': interactionType,
      'interaction_data': interactionData,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Service Suggestion Request model
class ServiceSuggestionRequest {
  final Map<String, dynamic> preferences;
  final String? categoryId;
  final int maxSuggestions;

  const ServiceSuggestionRequest({
    required this.preferences,
    this.categoryId,
    this.maxSuggestions = 5,
  });

  Map<String, dynamic> toJson() {
    return {
      'preferences': preferences,
      'category_id': categoryId,
      'max_suggestions': maxSuggestions,
    };
  }
}

/// Bid Amount Suggestion Request model
class BidAmountSuggestionRequest {
  final String serviceId;

  const BidAmountSuggestionRequest({
    required this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
    };
  }
}

/// Bid Message Suggestion Request model
class BidMessageSuggestionRequest {
  final String serviceId;
  final String customerId;
  final double bidAmount;
  final String messageTone;
  final int timeframeDays;

  const BidMessageSuggestionRequest({
    required this.serviceId,
    required this.customerId,
    required this.bidAmount,
    this.messageTone = 'professional',
    this.timeframeDays = 7,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'customer_id': customerId,
      'bid_amount': bidAmount,
      'message_tone': messageTone,
      'timeframe_days': timeframeDays,
    };
  }
}

/// Message Template Suggestion Request model
class MessageTemplateSuggestionRequest {
  final String serviceId;
  final String messageType; // bid_proposal, follow_up, negotiation
  final Map<String, dynamic>? preferences;

  const MessageTemplateSuggestionRequest({
    required this.serviceId,
    required this.messageType,
    this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'message_type': messageType,
      'preferences': preferences,
    };
  }
}

/// Suggestion Feedback Request model
class SuggestionFeedbackRequest {
  final String feedback;
  final bool isUsed;
  final String status; // implemented, rejected, etc.

  const SuggestionFeedbackRequest({
    required this.feedback,
    required this.isUsed,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'feedback': feedback,
      'is_used': isUsed,
      'status': status,
    };
  }
}

/// Interaction Log Request model
class InteractionLogRequest {
  final String? suggestionId;
  final String? bidId;
  final String interactionType;
  final Map<String, dynamic> interactionData;

  const InteractionLogRequest({
    this.suggestionId,
    this.bidId,
    required this.interactionType,
    required this.interactionData,
  });

  Map<String, dynamic> toJson() {
    return {
      'suggestion': suggestionId,
      'bid': bidId,
      'interaction_type': interactionType,
      'interaction_data': interactionData,
    };
  }
}

/// AI Service for handling AI suggestions and feedback
class AIService {
  final ApiService _apiService;

  AIService(this._apiService);

  // AI Suggestions endpoints

  /// List AI suggestions for the authenticated user
  Future<ApiResponse<List<AISuggestion>>> listAISuggestions({
    String? suggestionType,
    String? status,
    bool isAdmin = false,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (suggestionType != null) {
        queryParams['suggestion_type'] = suggestionType;
      }

      if (status != null) {
        queryParams['status'] = status;
      }

      if (isAdmin) {
        queryParams['all'] = 'true';
      }

      final response = await _apiService.get(
        '/ai_suggestions/suggestions/',
        queryParameters: queryParams,
      );

      if (response.success && response.data != null) {
        final List<dynamic> suggestionsJson =
            response.data['results'] ?? response.data;
        final suggestions = suggestionsJson
            .map((json) => AISuggestion.fromJson(json as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<AISuggestion>>(
          success: true,
          data: suggestions,
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<AISuggestion>>(
        success: false,
        message: response.message ?? 'Failed to fetch AI suggestions',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<List<AISuggestion>>(
        success: false,
        message: 'Error fetching AI suggestions: $e',
      );
    }
  }

  /// Get AI suggestion details by ID
  Future<ApiResponse<AISuggestion>> getAISuggestionDetails(
      String suggestionId) async {
    try {
      final response =
          await _apiService.get('/ai_suggestions/suggestions/$suggestionId/');

      if (response.success && response.data != null) {
        final suggestion =
            AISuggestion.fromJson(response.data as Map<String, dynamic>);

        return ApiResponse<AISuggestion>(
          success: true,
          data: suggestion,
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<AISuggestion>(
        success: false,
        message: response.message ?? 'Failed to fetch AI suggestion details',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<AISuggestion>(
        success: false,
        message: 'Error fetching AI suggestion details: $e',
      );
    }
  }

  /// Provide feedback on an AI suggestion
  Future<ApiResponse<Map<String, dynamic>>> provideFeedbackOnSuggestion(
    String suggestionId,
    SuggestionFeedbackRequest feedbackRequest,
  ) async {
    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/$suggestionId/provide_feedback/',
        body: feedbackRequest.toJson(),
      );

      return ApiResponse<Map<String, dynamic>>(
        success: response.success,
        data: response.data,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error providing feedback: $e',
      );
    }
  }

  /// Generate service suggestions based on user preferences
  Future<ApiResponse<List<AISuggestion>>> generateServiceSuggestions(
    ServiceSuggestionRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/generate_service_suggestions/',
        body: request.toJson(),
      );

      if (response.success && response.data != null) {
        final List<dynamic> suggestionsJson =
            response.data['suggestions'] ?? response.data;
        final suggestions = suggestionsJson
            .map((json) => AISuggestion.fromJson(json as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<AISuggestion>>(
          success: true,
          data: suggestions,
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<AISuggestion>>(
        success: false,
        message: response.message ?? 'Failed to generate service suggestions',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<List<AISuggestion>>(
        success: false,
        message: 'Error generating service suggestions: $e',
      );
    }
  }

  /// Suggest bid amount for a service
  Future<ApiResponse<Map<String, dynamic>>> suggestBidAmount(
    BidAmountSuggestionRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/suggest_bid_amount/',
        body: request.toJson(),
      );

      return ApiResponse<Map<String, dynamic>>(
        success: response.success,
        data: response.data,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error suggesting bid amount: $e',
      );
    }
  }

  /// Suggest bid message for a service
  Future<ApiResponse<Map<String, dynamic>>> suggestBidMessage(
    BidMessageSuggestionRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/suggest_bid_message/',
        body: request.toJson(),
      );

      return ApiResponse<Map<String, dynamic>>(
        success: response.success,
        data: response.data,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error suggesting bid message: $e',
      );
    }
  }

  /// Suggest message template
  Future<ApiResponse<Map<String, dynamic>>> suggestMessageTemplate(
    MessageTemplateSuggestionRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/suggest_message/',
        body: request.toJson(),
      );

      return ApiResponse<Map<String, dynamic>>(
        success: response.success,
        data: response.data,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error suggesting message template: $e',
      );
    }
  }

  // AI Feedback Logs endpoints

  /// List feedback logs for the authenticated user
  Future<ApiResponse<List<AIFeedbackLog>>> listFeedbackLogs({
    bool isAdmin = false,
  }) async {
    try {
      final response = await _apiService.get('/ai_suggestions/feedback/');

      if (response.success && response.data != null) {
        final List<dynamic> logsJson =
            response.data['results'] ?? response.data;
        final logs = logsJson
            .map((json) => AIFeedbackLog.fromJson(json as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<AIFeedbackLog>>(
          success: true,
          data: logs,
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<List<AIFeedbackLog>>(
        success: false,
        message: response.message ?? 'Failed to fetch feedback logs',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<List<AIFeedbackLog>>(
        success: false,
        message: 'Error fetching feedback logs: $e',
      );
    }
  }

  /// Get feedback log details by ID
  Future<ApiResponse<AIFeedbackLog>> getFeedbackLogDetails(String logId) async {
    try {
      final response =
          await _apiService.get('/ai_suggestions/feedback/$logId/');

      if (response.success && response.data != null) {
        final log =
            AIFeedbackLog.fromJson(response.data as Map<String, dynamic>);

        return ApiResponse<AIFeedbackLog>(
          success: true,
          data: log,
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<AIFeedbackLog>(
        success: false,
        message: response.message ?? 'Failed to fetch feedback log details',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<AIFeedbackLog>(
        success: false,
        message: 'Error fetching feedback log details: $e',
      );
    }
  }

  /// Log an interaction with AI suggestions
  Future<ApiResponse<AIFeedbackLog>> logInteraction(
    InteractionLogRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        '/ai_suggestions/feedback/log/',
        body: request.toJson(),
      );

      if (response.success && response.data != null) {
        final log =
            AIFeedbackLog.fromJson(response.data as Map<String, dynamic>);

        return ApiResponse<AIFeedbackLog>(
          success: true,
          data: log,
          message: response.message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<AIFeedbackLog>(
        success: false,
        message: response.message ?? 'Failed to log interaction',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<AIFeedbackLog>(
        success: false,
        message: 'Error logging interaction: $e',
      );
    }
  }
}

// Riverpod providers for AI service
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final aiServiceProvider = Provider<AIService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AIService(apiService);
});

// Provider for AI suggestions
final aiSuggestionsProvider =
    FutureProvider.family<List<AISuggestion>, Map<String, String>?>(
        (ref, filters) async {
  final aiService = ref.read(aiServiceProvider);

  final response = await aiService.listAISuggestions(
    suggestionType: filters?['suggestion_type'],
    status: filters?['status'],
    isAdmin: filters?['admin'] == 'true',
  );

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch AI suggestions');
});

// Provider for AI suggestion details
final aiSuggestionDetailsProvider =
    FutureProvider.family<AISuggestion, String>((ref, suggestionId) async {
  final aiService = ref.read(aiServiceProvider);

  final response = await aiService.getAISuggestionDetails(suggestionId);

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch AI suggestion details');
});

// Provider for feedback logs
final feedbackLogsProvider =
    FutureProvider.family<List<AIFeedbackLog>, bool>((ref, isAdmin) async {
  final aiService = ref.read(aiServiceProvider);

  final response = await aiService.listFeedbackLogs(isAdmin: isAdmin);

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch feedback logs');
});

// Provider for feedback log details
final feedbackLogDetailsProvider =
    FutureProvider.family<AIFeedbackLog, String>((ref, logId) async {
  final aiService = ref.read(aiServiceProvider);

  final response = await aiService.getFeedbackLogDetails(logId);

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch feedback log details');
});
