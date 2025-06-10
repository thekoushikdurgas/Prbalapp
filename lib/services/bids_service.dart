import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/services/ai_service.dart';
import 'api_service.dart';

/// Bid model
class Bid {
  final String id;
  final String service;
  final String provider;
  final String customer;
  final double amount;
  final String currency;
  final String duration;
  final DateTime? scheduledDateTime;
  final String message;
  final String location;
  final String
      status; // pending, accepted, rejected, expired, completed, cancelled
  final Map<String, dynamic>? paymentDetails;
  final bool isAiSuggested;
  final String? aiSuggestionId;
  final double? aiSuggestedAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final DateTime? expiredAt;

  const Bid({
    required this.id,
    required this.service,
    required this.provider,
    required this.customer,
    required this.amount,
    required this.currency,
    required this.duration,
    this.scheduledDateTime,
    required this.message,
    required this.location,
    required this.status,
    this.paymentDetails,
    this.isAiSuggested = false,
    this.aiSuggestionId,
    this.aiSuggestedAmount,
    required this.createdAt,
    required this.updatedAt,
    this.acceptedAt,
    this.rejectedAt,
    this.expiredAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'] as String,
      service: json['service'] as String,
      provider: json['provider'] as String,
      customer: json['customer'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      duration: json['duration'] as String,
      scheduledDateTime: json['scheduled_date_time'] != null
          ? DateTime.parse(json['scheduled_date_time'] as String)
          : null,
      message: json['message'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      paymentDetails: json['payment_details'] as Map<String, dynamic>?,
      isAiSuggested: json['is_ai_suggested'] as bool? ?? false,
      aiSuggestionId: json['ai_suggestion_id'] as String?,
      aiSuggestedAmount: (json['ai_suggested_amount'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'] as String)
          : null,
      rejectedAt: json['rejected_at'] != null
          ? DateTime.parse(json['rejected_at'] as String)
          : null,
      expiredAt: json['expired_at'] != null
          ? DateTime.parse(json['expired_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service,
      'provider': provider,
      'customer': customer,
      'amount': amount,
      'currency': currency,
      'duration': duration,
      'scheduled_date_time': scheduledDateTime?.toIso8601String(),
      'message': message,
      'location': location,
      'status': status,
      'payment_details': paymentDetails,
      'is_ai_suggested': isAiSuggested,
      'ai_suggestion_id': aiSuggestionId,
      'ai_suggested_amount': aiSuggestedAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'rejected_at': rejectedAt?.toIso8601String(),
      'expired_at': expiredAt?.toIso8601String(),
    };
  }
}

/// Create Bid Request model
class CreateBidRequest {
  final String service;
  final double amount;
  final String currency;
  final String duration;
  final DateTime? scheduledDateTime;
  final String message;
  final String location;
  final Map<String, dynamic>? paymentDetails;
  final bool isAiSuggested;
  final String? aiSuggestionId;
  final double? aiSuggestedAmount;

  const CreateBidRequest({
    required this.service,
    required this.amount,
    this.currency = 'INR',
    required this.duration,
    this.scheduledDateTime,
    required this.message,
    required this.location,
    this.paymentDetails,
    this.isAiSuggested = false,
    this.aiSuggestionId,
    this.aiSuggestedAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'service': service,
      'amount': amount,
      'currency': currency,
      'duration': duration,
      'scheduled_date_time': scheduledDateTime?.toIso8601String(),
      'message': message,
      'location': location,
      'payment_details': paymentDetails,
      'is_ai_suggested': isAiSuggested,
      'ai_suggestion_id': aiSuggestionId,
      'ai_suggested_amount': aiSuggestedAmount,
    };
  }
}

/// Update Bid Request model
class UpdateBidRequest {
  final double? amount;
  final String? currency;
  final String? duration;
  final DateTime? scheduledDateTime;
  final String? message;
  final String? location;
  final Map<String, dynamic>? paymentDetails;

  const UpdateBidRequest({
    this.amount,
    this.currency,
    this.duration,
    this.scheduledDateTime,
    this.message,
    this.location,
    this.paymentDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (duration != null) 'duration': duration,
      if (scheduledDateTime != null)
        'scheduled_date_time': scheduledDateTime!.toIso8601String(),
      if (message != null) 'message': message,
      if (location != null) 'location': location,
      if (paymentDetails != null) 'payment_details': paymentDetails,
    };
  }
}

/// Accept Bid Request model
class AcceptBidRequest {
  final DateTime? bookingDate;
  final String? specialInstructions;
  final String? paymentMethod;

  const AcceptBidRequest({
    this.bookingDate,
    this.specialInstructions,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      if (bookingDate != null) 'booking_date': bookingDate!.toIso8601String(),
      if (specialInstructions != null)
        'special_instructions': specialInstructions,
      if (paymentMethod != null) 'payment_method': paymentMethod,
    };
  }
}

/// Smart Pricing Response model
class SmartPricingResponse {
  final double minPrice;
  final double maxPrice;
  final double optimalPrice;
  final String marketAnalysis;
  final List<String> recommendations;
  final double confidenceScore;

  const SmartPricingResponse({
    required this.minPrice,
    required this.maxPrice,
    required this.optimalPrice,
    required this.marketAnalysis,
    required this.recommendations,
    required this.confidenceScore,
  });

  factory SmartPricingResponse.fromJson(Map<String, dynamic> json) {
    return SmartPricingResponse(
      minPrice: (json['min_price'] as num).toDouble(),
      maxPrice: (json['max_price'] as num).toDouble(),
      optimalPrice: (json['optimal_price'] as num).toDouble(),
      marketAnalysis: json['market_analysis'] as String,
      recommendations: List<String>.from(json['recommendations'] as List),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_price': minPrice,
      'max_price': maxPrice,
      'optimal_price': optimalPrice,
      'market_analysis': marketAnalysis,
      'recommendations': recommendations,
      'confidence_score': confidenceScore,
    };
  }
}

/// Bids Service for handling all bid-related operations
class BidsService {
  final ApiService _apiService;

  BidsService(this._apiService);

  /// List bids with filters
  /// GET /api/v1/bids/
  Future<ApiResponse<List<Bid>>> listBids({
    String? serviceId,
    String? providerId,
    String? status,
    String? search,
    String? ordering, // amount, -amount, created_at, -created_at
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (serviceId != null) queryParams['service'] = serviceId;
      if (providerId != null) queryParams['provider'] = providerId;
      if (status != null) queryParams['status'] = status;
      if (search != null) queryParams['search'] = search;
      if (ordering != null) queryParams['ordering'] = ordering;
      if (page != null) queryParams['page'] = page.toString();
      if (pageSize != null) queryParams['page_size'] = pageSize.toString();

      final response = await _apiService.get<List<Bid>>(
        '/bids/',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (json) {
          final results = json['results'] as List?;
          if (results != null) {
            return results.map((item) => Bid.fromJson(item)).toList();
          }
          return <Bid>[];
        },
      );

      return response;
    } catch (e) {
      return ApiResponse<List<Bid>>(
        success: false,
        message: 'Error fetching bids: $e',
      );
    }
  }

  /// Get bid details by ID
  /// GET /api/v1/bids/{bidId}/
  Future<ApiResponse<Bid>> getBidDetails(String bidId) async {
    try {
      final response = await _apiService.get<Bid>(
        '/bids/$bidId/',
        fromJson: (json) => Bid.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<Bid>(
        success: false,
        message: 'Error fetching bid details: $e',
      );
    }
  }

  /// Create a new bid (Provider only)
  /// POST /api/v1/bids/
  Future<ApiResponse<Bid>> createBid(CreateBidRequest request) async {
    try {
      final response = await _apiService.post<Bid>(
        '/bids/',
        body: request.toJson(),
        fromJson: (json) => Bid.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<Bid>(
        success: false,
        message: 'Error creating bid: $e',
      );
    }
  }

  /// Update bid completely (Owner only)
  /// PUT /api/v1/bids/{bidId}/
  Future<ApiResponse<Bid>> updateBid(
    String bidId,
    CreateBidRequest request,
  ) async {
    try {
      final response = await _apiService.put<Bid>(
        '/bids/$bidId/',
        body: request.toJson(),
        fromJson: (json) => Bid.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<Bid>(
        success: false,
        message: 'Error updating bid: $e',
      );
    }
  }

  /// Partially update bid (Owner only)
  /// PATCH /api/v1/bids/{bidId}/
  Future<ApiResponse<Bid>> partialUpdateBid(
    String bidId,
    UpdateBidRequest request,
  ) async {
    try {
      final response = await _apiService.patch<Bid>(
        '/bids/$bidId/',
        body: request.toJson(),
        fromJson: (json) => Bid.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<Bid>(
        success: false,
        message: 'Error updating bid: $e',
      );
    }
  }

  /// Delete bid (Owner only)
  /// DELETE /api/v1/bids/{bidId}/
  Future<ApiResponse<void>> deleteBid(String bidId) async {
    try {
      final response = await _apiService.delete<void>('/bids/$bidId/');
      return response;
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Error deleting bid: $e',
      );
    }
  }

  /// Accept bid (Customer only)
  /// POST /api/v1/bids/{bidId}/accept/
  Future<ApiResponse<Map<String, dynamic>>> acceptBid(
    String bidId,
    AcceptBidRequest request,
  ) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/bids/$bidId/accept/',
        body: request.toJson(),
        fromJson: (data) => data,
      );

      return response;
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error accepting bid: $e',
      );
    }
  }

  /// Reject bid (Customer only)
  /// POST /api/v1/bids/{bidId}/reject/
  Future<ApiResponse<Map<String, dynamic>>> rejectBid(String bidId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/bids/$bidId/reject/',
        body: {},
        fromJson: (data) => data,
      );

      return response;
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Error rejecting bid: $e',
      );
    }
  }

  /// Get AI smart pricing for a service (Provider only)
  /// GET /api/v1/bids/smart_price/?service_id={serviceId}
  Future<ApiResponse<SmartPricingResponse>> getSmartPricing(
      String serviceId) async {
    try {
      final response = await _apiService.get<SmartPricingResponse>(
        '/bids/smart_price/',
        queryParameters: {'service_id': serviceId},
        fromJson: (json) => SmartPricingResponse.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse<SmartPricingResponse>(
        success: false,
        message: 'Error fetching smart pricing: $e',
      );
    }
  }

  // === CONVENIENCE METHODS FOR FILTERING ===

  /// Filter bids by service
  Future<ApiResponse<List<Bid>>> getBidsByService(String serviceId) async {
    return listBids(serviceId: serviceId);
  }

  /// Filter bids by provider
  Future<ApiResponse<List<Bid>>> getBidsByProvider(String providerId) async {
    return listBids(providerId: providerId);
  }

  /// Filter bids by status
  Future<ApiResponse<List<Bid>>> getBidsByStatus(String status) async {
    return listBids(status: status);
  }

  /// Search bids by description/message
  Future<ApiResponse<List<Bid>>> searchBids(String query) async {
    return listBids(search: query);
  }

  /// Sort bids by amount (ascending)
  Future<ApiResponse<List<Bid>>> getBidsSortedByAmount(
      {bool descending = false}) async {
    return listBids(ordering: descending ? '-amount' : 'amount');
  }

  /// Sort bids by date (newest first by default)
  Future<ApiResponse<List<Bid>>> getBidsSortedByDate(
      {bool newestFirst = true}) async {
    return listBids(ordering: newestFirst ? '-created_at' : 'created_at');
  }

  /// Get pending bids
  Future<ApiResponse<List<Bid>>> getPendingBids() async {
    return listBids(status: 'pending');
  }

  /// Get accepted bids
  Future<ApiResponse<List<Bid>>> getAcceptedBids() async {
    return listBids(status: 'accepted');
  }

  /// Get rejected bids
  Future<ApiResponse<List<Bid>>> getRejectedBids() async {
    return listBids(status: 'rejected');
  }

  /// Get completed bids
  Future<ApiResponse<List<Bid>>> getCompletedBids() async {
    return listBids(status: 'completed');
  }

  /// Get cancelled bids
  Future<ApiResponse<List<Bid>>> getCancelledBids() async {
    return listBids(status: 'cancelled');
  }

  /// Get expired bids
  Future<ApiResponse<List<Bid>>> getExpiredBids() async {
    return listBids(status: 'expired');
  }

  // === BULK OPERATIONS ===

  /// Get multiple bids by IDs
  Future<List<ApiResponse<Bid>>> getBidsById(List<String> bidIds) async {
    final futures = bidIds.map((id) => getBidDetails(id)).toList();
    return await Future.wait(futures);
  }

  /// Create multiple bids
  Future<List<ApiResponse<Bid>>> createBids(
      List<CreateBidRequest> requests) async {
    final futures = requests.map((request) => createBid(request)).toList();
    return await Future.wait(futures);
  }
}

// Riverpod providers for Bids service
final bidsServiceProvider = Provider<BidsService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return BidsService(apiService);
});

// Provider for bids list with filters
final bidsProvider = FutureProvider.family<List<Bid>, Map<String, String>?>(
    (ref, filters) async {
  final bidsService = ref.read(bidsServiceProvider);

  final response = await bidsService.listBids(
    serviceId: filters?['service'],
    providerId: filters?['provider'],
    status: filters?['status'],
    search: filters?['search'],
    ordering: filters?['ordering'],
    page: filters?['page'] != null ? int.tryParse(filters!['page']!) : null,
    pageSize: filters?['page_size'] != null
        ? int.tryParse(filters!['page_size']!)
        : null,
  );

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch bids');
});

// Provider for bid details
final bidDetailsProvider =
    FutureProvider.family<Bid, String>((ref, bidId) async {
  final bidsService = ref.read(bidsServiceProvider);

  final response = await bidsService.getBidDetails(bidId);

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch bid details');
});

// Provider for smart pricing
final smartPricingProvider =
    FutureProvider.family<SmartPricingResponse, String>((ref, serviceId) async {
  final bidsService = ref.read(bidsServiceProvider);

  final response = await bidsService.getSmartPricing(serviceId);

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch smart pricing');
});

// Provider for pending bids
final pendingBidsProvider = FutureProvider<List<Bid>>((ref) async {
  final bidsService = ref.read(bidsServiceProvider);

  final response = await bidsService.getPendingBids();

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch pending bids');
});

// Provider for accepted bids
final acceptedBidsProvider = FutureProvider<List<Bid>>((ref) async {
  final bidsService = ref.read(bidsServiceProvider);

  final response = await bidsService.getAcceptedBids();

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch accepted bids');
});

// Provider for user's bids (filtered by provider or customer context)
final myBidsProvider =
    FutureProvider.family<List<Bid>, String?>((ref, userType) async {
  final bidsService = ref.read(bidsServiceProvider);

  // This would be filtered based on current user context
  final response = await bidsService.listBids();

  if (response.success && response.data != null) {
    return response.data!;
  }

  throw Exception(response.message ?? 'Failed to fetch my bids');
});
