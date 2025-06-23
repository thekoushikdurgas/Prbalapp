import 'package:flutter/material.dart';
import 'package:prbal/services/api_service.dart';

// ====================================================================
// AI SERVICE MODELS - Based on Prbal API AI Suggestions Endpoints
// These models correspond to the AI suggestion system that provides
// intelligent recommendations for services, bids, and messaging
//
// 🤖 API BASE ANALYSIS FROM POSTMAN COLLECTION:
// Base URL: /ai_suggestions/
// Authentication: JWT Bearer token required for most endpoints
// Response Format: {message, data, time, statusCode}
//
// 🧠 AI SYSTEM CAPABILITIES:
// 1. SERVICE RECOMMENDATIONS - Analyze user preferences and suggest relevant services
// 2. BID OPTIMIZATION - Use market data to suggest competitive bid amounts
// 3. MESSAGE GENERATION - Create personalized bid messages with tone control
// 4. FEEDBACK LEARNING - Collect user interactions for continuous ML improvement
// 5. ANALYTICS & INSIGHTS - Track suggestion performance and implementation rates
//
// 🔄 MACHINE LEARNING WORKFLOW:
// Input → AI Processing → Suggestion Generation → User Feedback → Model Improvement
// ====================================================================

/// AI Suggestion model
/// Represents an AI-generated suggestion for services, bids, or improvements
///
/// 📋 SUGGESTION TYPES SUPPORTED:
/// - bid_amount: Optimal pricing suggestions based on market analysis
/// - pricing: Service pricing optimization recommendations
/// - service_improvement: Enhancement suggestions for existing services
/// - message_template: Communication templates for different scenarios
/// - bid_message: Personalized bid messages with tone adjustment
///
/// 🔄 SUGGESTION LIFECYCLE:
/// new → viewed → implemented/rejected
///
/// API Endpoint: /ai_suggestions/suggestions/
/// Response Structure: {message, data: {results: [suggestions...]}, time, statusCode}
class AISuggestion {
  final String id;
  final String suggestionType; // bid_amount, pricing, service_improvement, etc.
  final String title;
  final String description;
  final Map<String, dynamic>?
      suggestionData; // Flexible data structure for different suggestion types
  final String status; // new, viewed, implemented, rejected
  final String userId;
  final String? serviceId; // Optional service reference
  final double? confidenceScore; // ML confidence level (0.0 - 1.0)
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? viewedAt; // When user first viewed the suggestion
  final DateTime? implementedAt; // When user acted on the suggestion

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
    debugPrint('🤖 AISuggestion.fromJson: ====== PARSING AI SUGGESTION ======');
    debugPrint('🤖 → Raw JSON keys: ${json.keys.join(', ')}');
    debugPrint('🤖 → Suggestion ID: ${json['id']}');
    debugPrint('🤖 → Suggestion Type: ${json['suggestion_type']}');
    debugPrint('🤖 → Title: "${json['title']}"');
    debugPrint('🤖 → Status: ${json['status']}');
    debugPrint('🤖 → User ID: ${json['user_id']}');
    debugPrint('🤖 → Service ID: ${json['service_id'] ?? 'NULL'}');
    debugPrint('🤖 → Confidence Score: ${json['confidence_score'] ?? 'NULL'}');
    debugPrint(
        '🤖 → Description Length: ${(json['description'] ?? '').length} chars');

    // Parse suggestion data if present
    Map<String, dynamic>? suggestionData;
    if (json['suggestion_data'] != null) {
      suggestionData = Map<String, dynamic>.from(json['suggestion_data']);
      debugPrint(
          '🤖 → Suggestion Data Keys: ${suggestionData.keys.join(', ')}');
      debugPrint('🤖 → Suggestion Data Size: ${suggestionData.length} fields');
    } else {
      debugPrint('🤖 → Suggestion Data: NULL');
    }

    // Parse timestamps and track lifecycle
    final createdAt = DateTime.parse(json['created_at'] as String);
    final updatedAt = DateTime.parse(json['updated_at'] as String);
    final viewedAt = json['viewed_at'] != null
        ? DateTime.parse(json['viewed_at'] as String)
        : null;
    final implementedAt = json['implemented_at'] != null
        ? DateTime.parse(json['implemented_at'] as String)
        : null;

    debugPrint('🤖 → Created At: ${createdAt.toIso8601String()}');
    debugPrint('🤖 → Updated At: ${updatedAt.toIso8601String()}');
    debugPrint(
        '🤖 → Viewed At: ${viewedAt?.toIso8601String() ?? 'NOT_VIEWED'}');
    debugPrint(
        '🤖 → Implemented At: ${implementedAt?.toIso8601String() ?? 'NOT_IMPLEMENTED'}');

    // Calculate suggestion age and track engagement
    final age = DateTime.now().difference(createdAt);
    debugPrint(
        '🤖 → Suggestion Age: ${age.inDays} days, ${age.inHours % 24} hours');

    if (viewedAt != null) {
      final timeToView = viewedAt.difference(createdAt);
      debugPrint('🤖 → Time to View: ${timeToView.inHours} hours');
    }

    if (implementedAt != null && viewedAt != null) {
      final timeToImplement = implementedAt.difference(viewedAt);
      debugPrint('🤖 → Time to Implement: ${timeToImplement.inHours} hours');
    }

    final suggestion = AISuggestion(
      id: json['id'] as String,
      suggestionType: json['suggestion_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      suggestionData: suggestionData,
      status: json['status'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String?,
      confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      viewedAt: viewedAt,
      implementedAt: implementedAt,
    );

    debugPrint(
        '🤖 AISuggestion.fromJson: ✅ Successfully parsed suggestion "${suggestion.title}"');
    debugPrint(
        '🤖 → Final object confidence: ${suggestion.confidenceScore ?? 'N/A'}');
    debugPrint('🤖 → Final object status: ${suggestion.status}');
    debugPrint('🤖 =============================================');

    return suggestion;
  }

  Map<String, dynamic> toJson() {
    debugPrint('🤖 AISuggestion.toJson: Converting suggestion to JSON');
    debugPrint('🤖 → Converting: $title ($suggestionType)');

    final json = {
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

    debugPrint('🤖 AISuggestion.toJson: ✅ JSON conversion complete');
    debugPrint('🤖 → JSON size: ${json.length} fields');
    debugPrint(
        '🤖 → Non-null fields: ${json.values.where((v) => v != null).length}');

    return json;
  }
}

/// AI Feedback Log model
/// Tracks user interactions with AI suggestions for learning purposes
///
/// 📊 INTERACTION TYPES TRACKED:
/// - view: User viewed a suggestion
/// - use: User used/implemented a suggestion
/// - feedback: User provided explicit feedback
/// - accept_bid: User accepted a bid suggestion
/// - reject: User rejected a suggestion
/// - modify: User modified a suggestion before implementing
///
/// 🔄 LEARNING LOOP:
/// User Interaction → Feedback Log → ML Model Training → Improved Suggestions
///
/// API Endpoint: /ai_suggestions/feedback/
class AIFeedbackLog {
  final String id;
  final String?
      suggestionId; // Reference to the suggestion that was interacted with
  final String? bidId; // Reference to the bid if interaction was bid-related
  final String userId;
  final String interactionType; // use, feedback, accept_bid, etc.
  final Map<String, dynamic>
      interactionData; // Flexible data for different interaction types
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
    debugPrint('🤖 AIFeedbackLog.fromJson: ====== PARSING FEEDBACK LOG ======');
    debugPrint('🤖 → Raw JSON keys: ${json.keys.join(', ')}');
    debugPrint('🤖 → Log ID: ${json['id']}');
    debugPrint('🤖 → Interaction Type: ${json['interaction_type']}');
    debugPrint('🤖 → User ID: ${json['user_id']}');
    debugPrint('🤖 → Has Suggestion Reference: ${json['suggestion'] != null}');
    debugPrint('🤖 → Has Bid Reference: ${json['bid'] != null}');
    debugPrint('🤖 → Created At: ${json['created_at']}');

    // Parse interaction data and analyze its content
    final interactionData =
        Map<String, dynamic>.from(json['interaction_data'] ?? {});
    debugPrint(
        '🤖 → Interaction Data Keys: ${interactionData.keys.join(', ')}');
    debugPrint('🤖 → Interaction Data Size: ${interactionData.length} fields');

    // Log specific interaction details based on type
    final interactionType = json['interaction_type'] as String;
    switch (interactionType) {
      case 'view':
        debugPrint('🤖 → VIEW INTERACTION: User viewed suggestion');
        break;
      case 'use':
        debugPrint('🤖 → USE INTERACTION: User implemented suggestion');
        if (interactionData.containsKey('implementation_success')) {
          debugPrint(
              '🤖 → Implementation Success: ${interactionData['implementation_success']}');
        }
        break;
      case 'feedback':
        debugPrint('🤖 → FEEDBACK INTERACTION: User provided feedback');
        if (interactionData.containsKey('rating')) {
          debugPrint('🤖 → User Rating: ${interactionData['rating']}/5');
        }
        if (interactionData.containsKey('comment')) {
          debugPrint(
              '🤖 → User Comment Length: ${(interactionData['comment'] ?? '').length} chars');
        }
        break;
      case 'accept_bid':
        debugPrint('🤖 → BID ACCEPTANCE: User accepted bid suggestion');
        if (interactionData.containsKey('accepted_amount')) {
          debugPrint(
              '🤖 → Accepted Amount: \$${interactionData['accepted_amount']}');
        }
        break;
      case 'reject':
        debugPrint('🤖 → REJECTION: User rejected suggestion');
        if (interactionData.containsKey('rejection_reason')) {
          debugPrint(
              '🤖 → Rejection Reason: ${interactionData['rejection_reason']}');
        }
        break;
      default:
        debugPrint('🤖 → UNKNOWN INTERACTION TYPE: $interactionType');
    }

    final feedbackLog = AIFeedbackLog(
      id: json['id'] as String,
      suggestionId: json['suggestion'] as String?,
      bidId: json['bid'] as String?,
      userId: json['user_id'] as String,
      interactionType: interactionType,
      interactionData: interactionData,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

    debugPrint('🤖 AIFeedbackLog.fromJson: ✅ Successfully parsed feedback log');
    debugPrint('🤖 → Final interaction type: ${feedbackLog.interactionType}');
    debugPrint('🤖 ===============================================');

    return feedbackLog;
  }

  Map<String, dynamic> toJson() {
    debugPrint('🤖 AIFeedbackLog.toJson: Converting feedback log to JSON');
    debugPrint('🤖 → Converting: $interactionType interaction');
    debugPrint(
        '🤖 → Data fields to include: ${interactionData.keys.join(', ')}');

    final json = {
      'id': id,
      'suggestion': suggestionId,
      'bid': bidId,
      'user_id': userId,
      'interaction_type': interactionType,
      'interaction_data': interactionData,
      'created_at': createdAt.toIso8601String(),
    };

    debugPrint('🤖 AIFeedbackLog.toJson: ✅ JSON conversion complete');
    debugPrint('🤖 → JSON size: ${json.length} fields');

    return json;
  }
}

/// Service Suggestion Request model
/// Used to request AI-generated service recommendations
/// API Endpoint: POST /ai_suggestions/suggestions/generate_service_suggestions/
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
    final json = {
      'preferences': preferences,
      'category_id': categoryId,
      'max_suggestions': maxSuggestions,
    };

    debugPrint('🤖 ServiceSuggestionRequest.toJson: Building request');
    debugPrint('🤖 → Category ID: $categoryId');
    debugPrint('🤖 → Max Suggestions: $maxSuggestions');
    debugPrint('🤖 → Preferences Keys: ${preferences.keys.join(', ')}');

    return json;
  }
}

/// Bid Amount Suggestion Request model
/// Used to get AI-suggested bid amounts for services
/// API Endpoint: POST /ai_suggestions/suggestions/suggest_bid_amount/
class BidAmountSuggestionRequest {
  final String serviceId;

  const BidAmountSuggestionRequest({
    required this.serviceId,
  });

  Map<String, dynamic> toJson() {
    debugPrint(
        '🤖 BidAmountSuggestionRequest.toJson: Building bid amount request');
    debugPrint('🤖 → Service ID: $serviceId');

    return {
      'service_id': serviceId,
    };
  }
}

/// Bid Message Suggestion Request model
/// Used to get AI-generated bid messages with personalization
/// API Endpoint: POST /ai_suggestions/suggestions/suggest_bid_message/
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
    final json = {
      'service_id': serviceId,
      'customer_id': customerId,
      'bid_amount': bidAmount,
      'message_tone': messageTone,
      'timeframe_days': timeframeDays,
    };

    debugPrint(
        '🤖 BidMessageSuggestionRequest.toJson: Building bid message request');
    debugPrint('🤖 → Service ID: $serviceId');
    debugPrint('🤖 → Customer ID: $customerId');
    debugPrint('🤖 → Bid Amount: \$${bidAmount.toStringAsFixed(2)}');
    debugPrint('🤖 → Message Tone: $messageTone');
    debugPrint('🤖 → Timeframe: $timeframeDays days');

    return json;
  }
}

/// Message Template Suggestion Request model
/// Used to get AI-generated message templates for different scenarios
/// API Endpoint: POST /ai_suggestions/suggestions/suggest_message/
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
    final json = {
      'service_id': serviceId,
      'message_type': messageType,
      'preferences': preferences,
    };

    debugPrint(
        '🤖 MessageTemplateSuggestionRequest.toJson: Building message template request');
    debugPrint('🤖 → Service ID: $serviceId');
    debugPrint('🤖 → Message Type: $messageType');
    debugPrint('🤖 → Has Preferences: ${preferences != null}');
    if (preferences != null) {
      debugPrint('🤖 → Preference Keys: ${preferences!.keys.join(', ')}');
    }

    return json;
  }
}

/// Suggestion Feedback Request model
/// Used to provide feedback on AI suggestions for improvement
/// API Endpoint: POST /ai_suggestions/suggestions/{id}/provide_feedback/
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
    final json = {
      'feedback': feedback,
      'is_used': isUsed,
      'status': status,
    };

    debugPrint(
        '🤖 SuggestionFeedbackRequest.toJson: Building feedback request');
    debugPrint('🤖 → Feedback Length: ${feedback.length} characters');
    debugPrint('🤖 → Is Used: $isUsed');
    debugPrint('🤖 → Status: $status');

    return json;
  }
}

/// Interaction Log Request model
/// Used to log user interactions with AI features for analytics
/// API Endpoint: POST /ai_suggestions/feedback/log/
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
    final json = {
      'suggestion': suggestionId,
      'bid': bidId,
      'interaction_type': interactionType,
      'interaction_data': interactionData,
    };

    debugPrint('🤖 InteractionLogRequest.toJson: Building interaction log');
    debugPrint('🤖 → Interaction Type: $interactionType');
    debugPrint('🤖 → Has Suggestion: ${suggestionId != null}');
    debugPrint('🤖 → Has Bid: ${bidId != null}');
    debugPrint('🤖 → Data Fields: ${interactionData.keys.join(', ')}');

    return json;
  }
}

/// AI Service for handling AI suggestions and feedback
/// This service provides intelligent recommendations for services, bids, and messaging
/// Based on the AI suggestions endpoints in the Prbal API
///
/// 🧠 KEY FEATURES ANALYSIS:
/// 1. SERVICE RECOMMENDATIONS: ML-powered service suggestions based on user preferences
/// 2. BID OPTIMIZATION: Market data analysis for competitive pricing
/// 3. MESSAGE GENERATION: NLP-powered message templates with tone control
/// 4. FEEDBACK LEARNING: Continuous improvement through user interaction tracking
/// 5. ANALYTICS: Performance metrics and suggestion effectiveness tracking
///
/// 🔄 AI WORKFLOW:
/// Data Collection → Feature Extraction → Model Inference → Suggestion Generation → Feedback Collection → Model Update
///
/// 📊 PERFORMANCE METRICS:
/// - Suggestion acceptance rate
/// - Implementation success rate
/// - User satisfaction scores
/// - Response time optimization
/// - Confidence score accuracy
class AIService {
  final ApiService _apiService;

  AIService(this._apiService) {
    debugPrint('🤖 AIService: ======================================');
    debugPrint('🤖 AIService: INITIALIZING AI SUGGESTION SERVICE');
    debugPrint('🤖 AIService: ======================================');
    debugPrint('🤖 AIService: 🧠 AI SERVICE ARCHITECTURE ANALYSIS:');
    debugPrint('🤖 AIService: ┌─────────────────────────────────────┐');
    debugPrint('🤖 AIService: │           AI SERVICE LAYER          │');
    debugPrint('🤖 AIService: ├─────────────────────────────────────┤');
    debugPrint('🤖 AIService: │ 🎯 SUGGESTION ENGINE               │');
    debugPrint('🤖 AIService: │   → Service recommendations        │');
    debugPrint('🤖 AIService: │   → Bid amount optimization        │');
    debugPrint('🤖 AIService: │   → Message template generation    │');
    debugPrint('🤖 AIService: │   → Personalized bid messages      │');
    debugPrint('🤖 AIService: ├─────────────────────────────────────┤');
    debugPrint('🤖 AIService: │ 📊 ANALYTICS & FEEDBACK            │');
    debugPrint('🤖 AIService: │   → User interaction tracking       │');
    debugPrint('🤖 AIService: │   → Performance metrics             │');
    debugPrint('🤖 AIService: │   → Learning feedback loops        │');
    debugPrint('🤖 AIService: │   → Confidence scoring             │');
    debugPrint('🤖 AIService: └─────────────────────────────────────┘');
    debugPrint('🤖 AIService: ');
    debugPrint('🤖 AIService: 📡 API ENDPOINT ANALYSIS FROM POSTMAN:');
    debugPrint('🤖 AIService: ========================================');
    debugPrint('🤖 AIService: 📋 SUGGESTION MANAGEMENT ENDPOINTS:');
    debugPrint('🤖   → GET /ai_suggestions/suggestions/');
    debugPrint('🤖     ↳ Query filters: suggestion_type, status, all (admin)');
    debugPrint('🤖     ↳ Pagination: Standard Django REST pagination');
    debugPrint(
        '🤖     ↳ Response: {message, data: {results: [...], count}, time, statusCode}');
    debugPrint('🤖     ↳ Authentication: JWT Bearer token required');
    debugPrint('🤖   → GET /ai_suggestions/suggestions/{id}/');
    debugPrint('🤖     ↳ Single suggestion details with full metadata');
    debugPrint(
        '🤖     ↳ Response: {message, data: suggestion_object, time, statusCode}');
    debugPrint(
        '🤖   → POST /ai_suggestions/suggestions/{id}/provide_feedback/');
    debugPrint('🤖     ↳ Submit user feedback for ML improvement');
    debugPrint('🤖     ↳ Body: {feedback, is_used, status}');
    debugPrint('🤖 AIService: ');
    debugPrint('🤖 AIService: 🧠 AI GENERATION ENDPOINTS (CORE ML):');
    debugPrint(
        '🤖   → POST /ai_suggestions/suggestions/generate_service_suggestions/');
    debugPrint('🤖     ↳ Generate personalized service recommendations');
    debugPrint('🤖     ↳ Body: {preferences, category_id, max_suggestions}');
    debugPrint('🤖     ↳ ML Model: Collaborative filtering + content-based');
    debugPrint('🤖   → POST /ai_suggestions/suggestions/suggest_bid_amount/');
    debugPrint('🤖     ↳ AI-powered bid optimization using market data');
    debugPrint('🤖     ↳ Body: {service_id}');
    debugPrint('🤖     ↳ ML Model: Price prediction neural network');
    debugPrint('🤖   → POST /ai_suggestions/suggestions/suggest_bid_message/');
    debugPrint('🤖     ↳ NLP-powered personalized bid message generation');
    debugPrint(
        '🤖     ↳ Body: {service_id, customer_id, bid_amount, message_tone, timeframe_days}');
    debugPrint(
        '🤖     ↳ ML Model: GPT-style text generation with tone control');
    debugPrint('🤖   → POST /ai_suggestions/suggestions/suggest_message/');
    debugPrint(
        '🤖     ↳ Template generation for various communication scenarios');
    debugPrint('🤖     ↳ Body: {service_id, message_type, preferences}');
    debugPrint('🤖     ↳ ML Model: Template-based NLP with personalization');
    debugPrint('🤖 AIService: ');
    debugPrint('🤖 AIService: 📊 ANALYTICS & FEEDBACK ENDPOINTS:');
    debugPrint('🤖   → GET /ai_suggestions/feedback/');
    debugPrint('🤖     ↳ Interaction logs for analytics and ML training');
    debugPrint('🤖     ↳ Filters: user, interaction_type, date_range');
    debugPrint('🤖   → GET /ai_suggestions/feedback/{id}/');
    debugPrint('🤖     ↳ Detailed feedback log with interaction metadata');
    debugPrint('🤖   → POST /ai_suggestions/feedback/log/');
    debugPrint('🤖     ↳ Log user interactions for ML model improvement');
    debugPrint(
        '🤖     ↳ Body: {suggestion, bid, interaction_type, interaction_data}');
    debugPrint('🤖     ↳ Real-time learning: Feed data back to ML models');
    debugPrint('🤖 AIService: ');
    debugPrint('🤖 AIService: 🔐 AUTHENTICATION & PERMISSIONS:');
    debugPrint('🤖   → User: Own suggestions and interactions only');
    debugPrint('🤖   → Admin: All suggestions and system-wide analytics');
    debugPrint(
        '🤖   → Provider: Service-specific suggestions and bid optimization');
    debugPrint(
        '🤖   → Customer: Request-based suggestions and recommendations');
    debugPrint('🤖 AIService: ');
    debugPrint('🤖 AIService: 📈 PERFORMANCE OPTIMIZATION:');
    debugPrint('🤖   → Response caching for frequently requested suggestions');
    debugPrint('🤖   → Batch processing for bulk suggestion generation');
    debugPrint('🤖   → Async ML model inference for improved response times');
    debugPrint('🤖   → Confidence threshold filtering for quality control');
    debugPrint('🤖 AIService: ');
    debugPrint('🤖 AIService: 🌐 API BASE CONFIGURATION:');
    debugPrint('🤖   → Base URL: ${_apiService.baseUrl}');
    debugPrint(
        '🤖   → Standard Response Format: {message, data, time, statusCode}');
    debugPrint('🤖   → Authentication: JWT Bearer token via ApiService');
    debugPrint(
        '🤖   → Error Handling: Standardized error responses with debugging');
    debugPrint('🤖 AIService: ');
    debugPrint('🤖 AIService: 🤖 ML MODEL INTEGRATION:');
    debugPrint('🤖   → Real-time inference for instant suggestions');
    debugPrint('🤖   → Continuous learning from user feedback');
    debugPrint('🤖   → Multi-model ensemble for improved accuracy');
    debugPrint('🤖   → A/B testing framework for model comparison');
    debugPrint('🤖 AIService: ========================================');
    debugPrint('🤖 AIService: ✅ AI SERVICE INITIALIZED SUCCESSFULLY');
    debugPrint(
        '🤖 AIService: Ready for intelligent suggestions and ML-powered recommendations');
  }

  // ====================================================================
  // AI SUGGESTIONS ENDPOINTS
  // Based on Services API structure from Postman collection
  // ====================================================================

  /// List AI suggestions for the authenticated user
  ///
  /// 🔍 ENDPOINT ANALYSIS:
  /// - GET /ai_suggestions/suggestions/
  /// - Supports advanced filtering and pagination
  /// - Returns suggestions with confidence scores and metadata
  /// - Admin users can view all suggestions with 'all=true' parameter
  ///
  /// 📊 QUERY PARAMETERS:
  /// - suggestion_type: Filter by specific suggestion types
  /// - status: Filter by suggestion status (new, viewed, implemented, rejected)
  /// - all: Admin-only parameter to view all users' suggestions
  ///
  /// 🔄 RESPONSE FLOW:
  /// Request → Authentication Check → Database Query → ML Scoring → Response Formatting
  ///
  /// Response format: {message, data: {results: [...], count: n}, time, statusCode}
  Future<ApiResponse<List<AISuggestion>>> listAISuggestions({
    String? suggestionType,
    String? status,
    bool isAdmin = false,
  }) async {
    final startTime = DateTime.now();
    debugPrint('🤖 AIService.listAISuggestions: ============================');
    debugPrint(
        '🤖 AIService.listAISuggestions: STARTING SUGGESTIONS RETRIEVAL');
    debugPrint('🤖 AIService.listAISuggestions: ============================');
    debugPrint('🤖 → 📋 REQUEST PARAMETERS ANALYSIS:');
    debugPrint(
        '🤖   → Suggestion Type Filter: ${suggestionType ?? 'ALL_TYPES'}');
    debugPrint('🤖   → Status Filter: ${status ?? 'ALL_STATUSES'}');
    debugPrint(
        '🤖   → Admin View Mode: ${isAdmin ? 'ENABLED (All Users)' : 'DISABLED (Current User Only)'}');
    debugPrint('🤖   → Request Timestamp: ${startTime.toIso8601String()}');

    try {
      // Build query parameters with detailed logging
      final queryParams = <String, String>{};
      var filterCount = 0;

      if (suggestionType != null) {
        queryParams['suggestion_type'] = suggestionType;
        filterCount++;
        debugPrint('🤖 → ✅ Adding suggestion type filter: $suggestionType');
        switch (suggestionType) {
          case 'bid_amount':
            debugPrint(
                '🤖   → Filter Focus: Bid amount optimization suggestions');
            break;
          case 'pricing':
            debugPrint('🤖   → Filter Focus: Service pricing recommendations');
            break;
          case 'service_improvement':
            debugPrint('🤖   → Filter Focus: Service enhancement suggestions');
            break;
          case 'message_template':
            debugPrint(
                '🤖   → Filter Focus: Communication template suggestions');
            break;
          default:
            debugPrint(
                '🤖   → Filter Focus: Custom suggestion type - $suggestionType');
        }
      }

      if (status != null) {
        queryParams['status'] = status;
        filterCount++;
        debugPrint('🤖 → ✅ Adding status filter: $status');
        switch (status) {
          case 'new':
            debugPrint(
                '🤖   → Filter Focus: Unviewed suggestions requiring attention');
            break;
          case 'viewed':
            debugPrint(
                '🤖   → Filter Focus: Viewed but not yet implemented suggestions');
            break;
          case 'implemented':
            debugPrint(
                '🤖   → Filter Focus: Successfully implemented suggestions');
            break;
          case 'rejected':
            debugPrint(
                '🤖   → Filter Focus: User-rejected suggestions for analysis');
            break;
          default:
            debugPrint('🤖   → Filter Focus: Custom status - $status');
        }
      }

      if (isAdmin) {
        queryParams['all'] = 'true';
        filterCount++;
        debugPrint(
            '🤖 → 🔐 ADMIN MODE ENABLED: Accessing all user suggestions');
        debugPrint(
            '🤖   → Security Check: Admin permissions required for this operation');
        debugPrint(
            '🤖   → Data Scope: System-wide suggestions across all users');
        debugPrint(
            '🤖   → Use Case: Analytics, system monitoring, ML model training');
      }

      debugPrint('🤖 → 📊 QUERY SUMMARY:');
      debugPrint('🤖   → Total Filters Applied: $filterCount');
      debugPrint('🤖   → Final Query Parameters: $queryParams');
      debugPrint('🤖   → Expected Response: Paginated list of AI suggestions');

      debugPrint('🤖 → 🌐 Making API call to: /ai_suggestions/suggestions/');
      debugPrint('🤖   → HTTP Method: GET');
      debugPrint(
          '🤖   → Authentication: JWT Bearer token (handled by ApiService)');

      final response = await _apiService.get(
        '/ai_suggestions/suggestions/',
        queryParams: queryParams,
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🤖 → ⏱️ API call completed in ${duration}ms');
      debugPrint('🤖 → 📡 Response status: ${response.statusCode}');

      if (response.success && response.data != null) {
        debugPrint(
            '🤖 → ✅ SUCCESS: Received valid response from AI suggestions API');
        debugPrint('🤖 → 📝 Response message: "${response.message}"');
        debugPrint('🤖 → 🔍 Analyzing response data structure...');

        // Parse response data - handle both paginated and direct array responses
        final List<dynamic> suggestionsJson;

        if (response.data is Map<String, dynamic>) {
          final dataMap = response.data as Map<String, dynamic>;
          suggestionsJson = dataMap['results'] ?? dataMap['suggestions'] ?? [];
          debugPrint('🤖 → 📄 PAGINATED RESPONSE DETECTED');
          debugPrint('🤖   → Total Count: ${dataMap['count'] ?? 'unknown'}');
          debugPrint('🤖   → Has Next Page: ${dataMap['next'] != null}');
          debugPrint(
              '🤖   → Has Previous Page: ${dataMap['previous'] != null}');
          debugPrint(
              '🤖   → Results in Current Page: ${suggestionsJson.length}');
        } else if (response.data is List) {
          suggestionsJson = response.data as List<dynamic>;
          debugPrint('🤖 → 📄 DIRECT ARRAY RESPONSE DETECTED');
          debugPrint('🤖   → Total Results: ${suggestionsJson.length}');
        } else {
          debugPrint(
              '🤖 → ⚠️ UNEXPECTED RESPONSE FORMAT: ${response.data.runtimeType}');
          debugPrint('🤖   → Response Data: ${response.data}');
          suggestionsJson = [];
        }

        debugPrint('🤖 → 📊 RAW DATA ANALYSIS:');
        debugPrint('🤖   → Raw suggestions count: ${suggestionsJson.length}');
        debugPrint(
            '🤖   → Memory usage: ~${(suggestionsJson.length * 100)} bytes estimated');

        // Convert to AISuggestion objects with detailed parsing
        final suggestions = <AISuggestion>[];
        var parseSuccessCount = 0;
        var parseErrorCount = 0;

        debugPrint('🤖 → 🔄 PARSING SUGGESTIONS TO DOMAIN OBJECTS...');
        for (int i = 0; i < suggestionsJson.length; i++) {
          try {
            final suggestionJson = suggestionsJson[i] as Map<String, dynamic>;
            debugPrint(
                '🤖   → Parsing suggestion ${i + 1}/${suggestionsJson.length}');

            final suggestion = AISuggestion.fromJson(suggestionJson);
            suggestions.add(suggestion);
            parseSuccessCount++;

            debugPrint(
                '🤖   → ✅ Parsed: "${suggestion.title}" (${suggestion.suggestionType})');
            debugPrint('🤖     → ID: ${suggestion.id}');
            debugPrint('🤖     → Status: ${suggestion.status}');
            debugPrint(
                '🤖     → Confidence: ${suggestion.confidenceScore ?? 'N/A'}');
          } catch (e, stackTrace) {
            parseErrorCount++;
            debugPrint('🤖   → ❌ Error parsing suggestion ${i + 1}: $e');
            debugPrint('🤖     → Raw data: ${suggestionsJson[i]}');
            debugPrint(
                '🤖     → Stack trace (first 3 lines): ${stackTrace.toString().split('\n').take(3).join('\n')}');
          }
        }

        debugPrint('🤖 → 📈 PARSING RESULTS SUMMARY:');
        debugPrint(
            '🤖   → Successfully Parsed: $parseSuccessCount suggestions');
        debugPrint('🤖   → Parse Errors: $parseErrorCount suggestions');
        debugPrint(
            '🤖   → Success Rate: ${parseSuccessCount > 0 ? ((parseSuccessCount / suggestionsJson.length) * 100).toStringAsFixed(1) : 0}%');

        if (suggestions.isNotEmpty) {
          // Analyze suggestion distribution by type
          final typeDistribution = <String, int>{};
          final statusDistribution = <String, int>{};
          final confidenceScores = <double>[];

          for (final suggestion in suggestions) {
            // Type distribution
            typeDistribution[suggestion.suggestionType] =
                (typeDistribution[suggestion.suggestionType] ?? 0) + 1;

            // Status distribution
            statusDistribution[suggestion.status] =
                (statusDistribution[suggestion.status] ?? 0) + 1;

            // Confidence scores
            if (suggestion.confidenceScore != null) {
              confidenceScores.add(suggestion.confidenceScore!);
            }
          }

          debugPrint('🤖 → 📊 SUGGESTION ANALYTICS:');
          debugPrint('🤖   → 🎯 Type Distribution:');
          for (var entry in typeDistribution.entries) {
            final percentage =
                ((entry.value / suggestions.length) * 100).toStringAsFixed(1);
            debugPrint('🤖     → ${entry.key}: ${entry.value} ($percentage%)');
          }

          debugPrint('🤖   → 📈 Status Distribution:');
          for (var entry in statusDistribution.entries) {
            final percentage =
                ((entry.value / suggestions.length) * 100).toStringAsFixed(1);
            debugPrint('🤖     → ${entry.key}: ${entry.value} ($percentage%)');
          }

          if (confidenceScores.isNotEmpty) {
            final avgConfidence = confidenceScores.reduce((a, b) => a + b) /
                confidenceScores.length;
            final minConfidence =
                confidenceScores.reduce((a, b) => a < b ? a : b);
            final maxConfidence =
                confidenceScores.reduce((a, b) => a > b ? a : b);

            debugPrint('🤖   → 🎯 Confidence Score Analysis:');
            debugPrint('🤖     → Average: ${avgConfidence.toStringAsFixed(3)}');
            debugPrint(
                '🤖     → Range: ${minConfidence.toStringAsFixed(3)} - ${maxConfidence.toStringAsFixed(3)}');
            debugPrint(
                '🤖     → Suggestions with confidence: ${confidenceScores.length}/${suggestions.length}');
          }

          // Analyze suggestion freshness
          final now = DateTime.now();
          final newSuggestions = suggestions
              .where((s) => now.difference(s.createdAt).inHours < 24)
              .length;
          final weekOldSuggestions = suggestions
              .where((s) => now.difference(s.createdAt).inDays < 7)
              .length;

          debugPrint('🤖   → ⏰ Freshness Analysis:');
          debugPrint('🤖     → New (< 24h): $newSuggestions');
          debugPrint('🤖     → Recent (< 7 days): $weekOldSuggestions');
          debugPrint('🤖     → Total: ${suggestions.length}');
        }

        debugPrint(
            '🤖 AIService.listAISuggestions: ✅ OPERATION COMPLETED SUCCESSFULLY');
        debugPrint(
            '🤖   → Final Result: ${suggestions.length} suggestions ready for use');
        debugPrint('🤖   → Total Processing Time: ${duration}ms');
        debugPrint('🤖   → API Response Code: ${response.statusCode}');

        return ApiResponse<List<AISuggestion>>(
          success: true,
          data: suggestions,
          message: response.message,
          statusCode: response.statusCode,
          time: DateTime.now(),
        );
      }

      debugPrint('🤖 AIService.listAISuggestions: ❌ API REQUEST FAILED');
      debugPrint('🤖 → Status Code: ${response.statusCode}');
      debugPrint('🤖 → Error Message: "${response.message}"');
      debugPrint('🤖 → Response Data: ${response.data}');
      debugPrint(
          '🤖 → Error Category: ${_categorizeErrorStatus(response.statusCode)}');

      return ApiResponse<List<AISuggestion>>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🤖 AIService.listAISuggestions: 💥 EXCEPTION OCCURRED');
      debugPrint('🤖 → Exception after ${duration}ms of processing');
      debugPrint('🤖 → Exception Type: ${e.runtimeType}');
      debugPrint('🤖 → Exception Message: $e');
      debugPrint('🤖 → Stack Trace (first 5 lines):');
      stackTrace.toString().split('\n').take(5).forEach((line) {
        debugPrint('🤖   $line');
      });
      debugPrint('🤖 → Recovery: Returning error response to caller');

      return ApiResponse<List<AISuggestion>>(
        success: false,
        message: 'Error fetching AI suggestions: $e',
        time: DateTime.now(),
        statusCode: 500,
      );
    }
  }

  /// Helper method to categorize HTTP error statuses for better debugging
  String _categorizeErrorStatus(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'CLIENT_ERROR - Bad Request (Invalid parameters)';
      case 401:
        return 'AUTHENTICATION_ERROR - Unauthorized (Invalid/expired token)';
      case 403:
        return 'AUTHORIZATION_ERROR - Forbidden (Insufficient permissions)';
      case 404:
        return 'NOT_FOUND_ERROR - Resource not found';
      case 429:
        return 'RATE_LIMIT_ERROR - Too many requests';
      case 500:
        return 'SERVER_ERROR - Internal server error';
      case 502:
        return 'GATEWAY_ERROR - Bad gateway';
      case 503:
        return 'SERVICE_UNAVAILABLE - Server temporarily unavailable';
      case 504:
        return 'TIMEOUT_ERROR - Gateway timeout';
      default:
        return 'UNKNOWN_ERROR - HTTP $statusCode';
    }
  }

  /// Get AI suggestion details by ID
  /// Endpoint: GET /ai_suggestions/suggestions/{id}/
  Future<ApiResponse<AISuggestion>> getAISuggestionDetails(
      String suggestionId) async {
    debugPrint(
        '🤖 AIService: Getting suggestion details for ID: $suggestionId');

    try {
      final response =
          await _apiService.get('/ai_suggestions/suggestions/$suggestionId/');

      if (response.success && response.data != null) {
        final suggestion =
            AISuggestion.fromJson(response.data as Map<String, dynamic>);

        debugPrint(
            '🤖 AIService: Successfully retrieved suggestion: ${suggestion.title}');
        debugPrint(
            '🤖 AIService: Suggestion type: ${suggestion.suggestionType}');
        debugPrint(
            '🤖 AIService: Confidence score: ${suggestion.confidenceScore}');
        debugPrint('🤖 AIService: Status: ${suggestion.status}');

        return ApiResponse<AISuggestion>(
          success: true,
          data: suggestion,
          message: response.message,
          statusCode: response.statusCode,
          time: DateTime.now(),
        );
      }

      debugPrint(
          '🤖 AIService: Failed to fetch suggestion details - ${response.message}');
      return ApiResponse<AISuggestion>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error fetching suggestion details: $e');
      return ApiResponse<AISuggestion>(
        success: false,
        message: 'Error fetching AI suggestion details: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  /// Provide feedback on an AI suggestion
  /// Endpoint: POST /ai_suggestions/suggestions/{id}/provide_feedback/
  Future<ApiResponse<Map<String, dynamic>>> provideFeedbackOnSuggestion(
    String suggestionId,
    SuggestionFeedbackRequest feedbackRequest,
  ) async {
    debugPrint('🤖 AIService: Providing feedback on suggestion: $suggestionId');
    debugPrint('🤖 AIService: Feedback: ${feedbackRequest.feedback}');
    debugPrint('🤖 AIService: Is used: ${feedbackRequest.isUsed}');
    debugPrint('🤖 AIService: Status: ${feedbackRequest.status}');

    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/$suggestionId/provide_feedback/',
        body: feedbackRequest.toJson(),
      );

      if (response.success) {
        debugPrint('🤖 AIService: Feedback submitted successfully');
        debugPrint('🤖 AIService: Response: ${response.data}');
      } else {
        debugPrint(
            '🤖 AIService: Failed to submit feedback - ${response.message}');
      }

      return ApiResponse<Map<String, dynamic>>(
        success: response.success,
        data: response.data,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error providing feedback: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error providing feedback: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  /// Generate service suggestions based on user preferences
  /// Endpoint: POST /ai_suggestions/suggestions/generate_service_suggestions/
  Future<ApiResponse<List<AISuggestion>>> generateServiceSuggestions(
    ServiceSuggestionRequest request,
  ) async {
    debugPrint('🤖 AIService: Generating service suggestions');
    debugPrint('🤖 AIService: Category ID: ${request.categoryId}');
    debugPrint('🤖 AIService: Max suggestions: ${request.maxSuggestions}');
    debugPrint('🤖 AIService: Preferences: ${request.preferences}');

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

        debugPrint(
            '🤖 AIService: Generated ${suggestions.length} service suggestions');
        debugPrint(
            '🤖 AIService: Average confidence: ${suggestions.map((s) => s.confidenceScore ?? 0).reduce((a, b) => a + b) / suggestions.length}');

        return ApiResponse<List<AISuggestion>>(
          success: true,
          data: suggestions,
          message: response.message,
          statusCode: response.statusCode,
          time: DateTime.now(),
        );
      }

      debugPrint(
          '🤖 AIService: Failed to generate service suggestions - ${response.message}');
      return ApiResponse<List<AISuggestion>>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error generating service suggestions: $e');
      return ApiResponse<List<AISuggestion>>(
        success: false,
        message: 'Error generating service suggestions: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  /// Suggest bid amount for a service
  /// Endpoint: POST /ai_suggestions/suggestions/suggest_bid_amount/
  Future<ApiResponse<Map<String, dynamic>>> suggestBidAmount(
    BidAmountSuggestionRequest request,
  ) async {
    debugPrint(
        '🤖 AIService: Suggesting bid amount for service: ${request.serviceId}');

    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/suggest_bid_amount/',
        body: request.toJson(),
      );

      if (response.success && response.data != null) {
        debugPrint(
            '🤖 AIService: Bid amount suggestion generated successfully');
        debugPrint(
            '🤖 AIService: Suggested amount: ${response.data?['suggested_amount']}');
        debugPrint('🤖 AIService: Confidence: ${response.data?['confidence']}');
      } else {
        debugPrint(
            '🤖 AIService: Failed to suggest bid amount - ${response.message}');
      }

      return ApiResponse<Map<String, dynamic>>(
        success: response.success,
        data: response.data,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error suggesting bid amount: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error suggesting bid amount: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  /// Suggest bid message for a service
  /// Endpoint: POST /ai_suggestions/suggestions/suggest_bid_message/
  Future<ApiResponse<Map<String, dynamic>>> suggestBidMessage(
    BidMessageSuggestionRequest request,
  ) async {
    debugPrint('🤖 AIService: Suggesting bid message');
    debugPrint('🤖 AIService: Service ID: ${request.serviceId}');
    debugPrint('🤖 AIService: Customer ID: ${request.customerId}');
    debugPrint('🤖 AIService: Bid amount: ${request.bidAmount}');
    debugPrint('🤖 AIService: Message tone: ${request.messageTone}');

    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/suggest_bid_message/',
        body: request.toJson(),
      );

      if (response.success && response.data != null) {
        debugPrint(
            '🤖 AIService: Bid message suggestion generated successfully');
        debugPrint(
            '🤖 AIService: Message length: ${response.data?['suggested_message']?.length ?? 0} chars');
      } else {
        debugPrint(
            '🤖 AIService: Failed to suggest bid message - ${response.message}');
      }

      return ApiResponse<Map<String, dynamic>>(
        success: response.success,
        data: response.data,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error suggesting bid message: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error suggesting bid message: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  /// Suggest message template
  /// Endpoint: POST /ai_suggestions/suggestions/suggest_message/
  Future<ApiResponse<Map<String, dynamic>>> suggestMessageTemplate(
    MessageTemplateSuggestionRequest request,
  ) async {
    debugPrint('🤖 AIService: Suggesting message template');
    debugPrint('🤖 AIService: Service ID: ${request.serviceId}');
    debugPrint('🤖 AIService: Message type: ${request.messageType}');

    try {
      final response = await _apiService.post(
        '/ai_suggestions/suggestions/suggest_message/',
        body: request.toJson(),
      );

      if (response.success && response.data != null) {
        debugPrint(
            '🤖 AIService: Message template suggestion generated successfully');
        debugPrint('🤖 AIService: Template type: ${request.messageType}');
      } else {
        debugPrint(
            '🤖 AIService: Failed to suggest message template - ${response.message}');
      }

      return ApiResponse<Map<String, dynamic>>(
        success: response.success,
        data: response.data,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error suggesting message template: $e');
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error suggesting message template: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  // ====================================================================
  // AI FEEDBACK LOGS ENDPOINTS
  // ====================================================================

  /// List feedback logs for the authenticated user
  /// Endpoint: GET /ai_suggestions/feedback/
  Future<ApiResponse<List<AIFeedbackLog>>> listFeedbackLogs({
    bool isAdmin = false,
  }) async {
    debugPrint('🤖 AIService: Listing feedback logs (admin: $isAdmin)');

    try {
      final response = await _apiService.get('/ai_suggestions/feedback/');

      if (response.success && response.data != null) {
        final List<dynamic> logsJson =
            response.data['results'] ?? response.data;
        final logs = logsJson
            .map((json) => AIFeedbackLog.fromJson(json as Map<String, dynamic>))
            .toList();

        debugPrint('🤖 AIService: Retrieved ${logs.length} feedback logs');
        debugPrint(
            '🤖 AIService: Interaction types found: ${logs.map((l) => l.interactionType).toSet().join(', ')}');

        return ApiResponse<List<AIFeedbackLog>>(
          success: true,
          data: logs,
          message: response.message,
          statusCode: response.statusCode,
          time: DateTime.now(),
        );
      }

      debugPrint(
          '🤖 AIService: Failed to fetch feedback logs - ${response.message}');
      return ApiResponse<List<AIFeedbackLog>>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error fetching feedback logs: $e');
      return ApiResponse<List<AIFeedbackLog>>(
        success: false,
        message: 'Error fetching feedback logs: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  /// Get feedback log details by ID
  /// Endpoint: GET /ai_suggestions/feedback/{id}/
  Future<ApiResponse<AIFeedbackLog>> getFeedbackLogDetails(String logId) async {
    debugPrint('🤖 AIService: Getting feedback log details for ID: $logId');

    try {
      final response =
          await _apiService.get('/ai_suggestions/feedback/$logId/');

      if (response.success && response.data != null) {
        final log =
            AIFeedbackLog.fromJson(response.data as Map<String, dynamic>);

        debugPrint('🤖 AIService: Successfully retrieved feedback log');
        debugPrint('🤖 AIService: Interaction type: ${log.interactionType}');
        debugPrint('🤖 AIService: Created at: ${log.createdAt}');

        return ApiResponse<AIFeedbackLog>(
          success: true,
          data: log,
          message: response.message,
          statusCode: response.statusCode,
          time: DateTime.now(),
        );
      }

      debugPrint(
          '🤖 AIService: Failed to fetch feedback log details - ${response.message}');
      return ApiResponse<AIFeedbackLog>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error fetching feedback log details: $e');
      return ApiResponse<AIFeedbackLog>(
        success: false,
        message: 'Error fetching feedback log details: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  /// Log an interaction with AI suggestions
  /// Endpoint: POST /ai_suggestions/feedback/log/
  Future<ApiResponse<AIFeedbackLog>> logInteraction(
    InteractionLogRequest request,
  ) async {
    debugPrint('🤖 AIService: Logging AI interaction');
    debugPrint('🤖 AIService: Interaction type: ${request.interactionType}');
    debugPrint('🤖 AIService: Suggestion ID: ${request.suggestionId}');
    debugPrint('🤖 AIService: Bid ID: ${request.bidId}');

    try {
      final response = await _apiService.post(
        '/ai_suggestions/feedback/log/',
        body: request.toJson(),
      );

      if (response.success && response.data != null) {
        final log =
            AIFeedbackLog.fromJson(response.data as Map<String, dynamic>);

        debugPrint('🤖 AIService: Interaction logged successfully');
        debugPrint('🤖 AIService: Log ID: ${log.id}');

        return ApiResponse<AIFeedbackLog>(
          success: true,
          data: log,
          message: response.message,
          statusCode: response.statusCode,
          time: DateTime.now(),
        );
      }

      debugPrint(
          '🤖 AIService: Failed to log interaction - ${response.message}');
      return ApiResponse<AIFeedbackLog>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🤖 AIService: Error logging interaction: $e');
      return ApiResponse<AIFeedbackLog>(
        success: false,
        message: 'Error logging interaction: $e',
        time: DateTime.now(),
        statusCode: 404,
      );
    }
  }

  // ====================================================================
  // UTILITY AND HELPER METHODS
  // ====================================================================

  /// Get suggestion statistics for analytics
  Future<Map<String, dynamic>> getSuggestionStatistics() async {
    debugPrint('🤖 AIService: Generating suggestion statistics');

    try {
      final suggestions = await listAISuggestions();

      if (suggestions.success && suggestions.data != null) {
        final data = suggestions.data!;
        final stats = {
          'total_suggestions': data.length,
          'by_type': <String, int>{},
          'by_status': <String, int>{},
          'average_confidence': 0.0,
          'implementation_rate': 0.0,
        };

        // Group by type and status
        final byType = stats['by_type'] as Map<String, int>;
        final byStatus = stats['by_status'] as Map<String, int>;

        for (final suggestion in data) {
          byType[suggestion.suggestionType] =
              (byType[suggestion.suggestionType] ?? 0) + 1;
          byStatus[suggestion.status] = (byStatus[suggestion.status] ?? 0) + 1;
        }

        // Calculate average confidence
        final confidenceScores = data
            .where((s) => s.confidenceScore != null)
            .map((s) => s.confidenceScore!)
            .toList();

        if (confidenceScores.isNotEmpty) {
          stats['average_confidence'] =
              confidenceScores.reduce((a, b) => a + b) /
                  confidenceScores.length;
        }

        // Calculate implementation rate
        final implementedCount =
            data.where((s) => s.status == 'implemented').length;
        if (data.isNotEmpty) {
          stats['implementation_rate'] = implementedCount / data.length;
        }

        debugPrint('🤖 AIService: Statistics generated successfully');
        debugPrint(
            '🤖 AIService: Total suggestions: ${stats['total_suggestions']}');
        debugPrint(
            '🤖 AIService: Average confidence: ${stats['average_confidence']}');
        debugPrint(
            '🤖 AIService: Implementation rate: ${stats['implementation_rate']}');

        return stats;
      }
    } catch (e) {
      debugPrint('🤖 AIService: Error generating statistics: $e');
    }

    return {'error': 'Failed to generate statistics'};
  }

  /// Check AI service health
  Future<Map<String, dynamic>> checkAIServiceHealth() async {
    debugPrint('🤖 AIService: Performing health check');

    final startTime = DateTime.now();
    try {
      // Test basic functionality by fetching suggestions
      final response = await listAISuggestions();
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      final healthStatus = {
        'service': 'AI Suggestions',
        'status': response.success ? 'healthy' : 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': response.success ? null : response.message,
      };

      debugPrint('🤖 AIService: Health check completed');
      debugPrint('🤖 AIService: Status: ${healthStatus['status']}');
      debugPrint('🤖 AIService: Response time: ${duration}ms');

      return healthStatus;
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🤖 AIService: Health check failed: $e');

      return {
        'service': 'AI Suggestions',
        'status': 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': 'Health check failed: $e',
      };
    }
  }
}

// ====================================================================
// RIVERPOD PROVIDERS FOR AI SERVICE
// ====================================================================

// Note: These providers will be integrated with the existing service_providers.dart
// They are commented out here to avoid conflicts with the existing provider structure

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'api_service.dart';

// /// Provider for AIService instance
// final aiServiceProvider = Provider<AIService>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return AIService(apiService);
// });

// /// Provider for AI suggestions with optional filters
// final aiSuggestionsProvider = FutureProvider.family<List<AISuggestion>, Map<String, String>?>((ref, filters) async {
//   final aiService = ref.read(aiServiceProvider);

//   final response = await aiService.listAISuggestions(
//     suggestionType: filters?['suggestion_type'],
//     status: filters?['status'],
//     isAdmin: filters?['admin'] == 'true',
//   );

//   if (response.success && response.data != null) {
//     return response.data!;
//   }

//   throw Exception(response.message ?? 'Failed to fetch AI suggestions');
// });

// /// Provider for AI suggestion details
// final aiSuggestionDetailsProvider = FutureProvider.family<AISuggestion, String>((ref, suggestionId) async {
//   final aiService = ref.read(aiServiceProvider);

//   final response = await aiService.getAISuggestionDetails(suggestionId);

//   if (response.success && response.data != null) {
//     return response.data!;
//   }

//   throw Exception(response.message ?? 'Failed to fetch AI suggestion details');
// });

// /// Provider for feedback logs
// final feedbackLogsProvider = FutureProvider.family<List<AIFeedbackLog>, bool>((ref, isAdmin) async {
//   final aiService = ref.read(aiServiceProvider);

//   final response = await aiService.listFeedbackLogs(isAdmin: isAdmin);

//   if (response.success && response.data != null) {
//     return response.data!;
//   }

//   throw Exception(response.message ?? 'Failed to fetch feedback logs');
// });

// /// Provider for feedback log details
// final feedbackLogDetailsProvider = FutureProvider.family<AIFeedbackLog, String>((ref, logId) async {
//   final aiService = ref.read(aiServiceProvider);

//   final response = await aiService.getFeedbackLogDetails(logId);

//   if (response.success && response.data != null) {
//     return response.data!;
//   }

//   throw Exception(response.message ?? 'Failed to fetch feedback log details');
// });

// /// Provider for AI service statistics
// final aiStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
//   final aiService = ref.read(aiServiceProvider);
//   return await aiService.getSuggestionStatistics();
// });

// /// Provider for AI service health check
// final aiHealthProvider = FutureProvider<Map<String, dynamic>>((ref) async {
//   final aiService = ref.read(aiServiceProvider);
//   return await aiService.checkAIServiceHealth();
// });
