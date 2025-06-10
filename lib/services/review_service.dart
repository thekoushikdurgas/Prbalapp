import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Review model
class Review {
  final String id;
  final String bookingId;
  final String reviewerId;
  final String revieweeId;
  final String reviewerType; // 'customer', 'provider'
  final double rating;
  final String? comment;
  final List<String>? imageUrls;
  final Map<String, dynamic>? metadata;
  final bool isVerified;
  final bool isPublic;
  final DateTime? verifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Review({
    required this.id,
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
    required this.reviewerType,
    required this.rating,
    this.comment,
    this.imageUrls,
    this.metadata,
    required this.isVerified,
    required this.isPublic,
    this.verifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      reviewerId: json['reviewer_id'] as String,
      revieweeId: json['reviewee_id'] as String,
      reviewerType: json['reviewer_type'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'])
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isVerified: json['is_verified'] as bool? ?? false,
      isPublic: json['is_public'] as bool? ?? true,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'reviewer_id': reviewerId,
      'reviewee_id': revieweeId,
      'reviewer_type': reviewerType,
      'rating': rating,
      if (comment != null) 'comment': comment,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (metadata != null) 'metadata': metadata,
      'is_verified': isVerified,
      'is_public': isPublic,
      if (verifiedAt != null) 'verified_at': verifiedAt!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Review request model
class ReviewRequest {
  final String bookingId;
  final double rating;
  final String? comment;
  final List<String>? imageUrls;
  final bool? isPublic;
  final Map<String, dynamic>? metadata;

  const ReviewRequest({
    required this.bookingId,
    required this.rating,
    this.comment,
    this.imageUrls,
    this.isPublic,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'rating': rating,
      if (comment != null) 'comment': comment,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (isPublic != null) 'is_public': isPublic,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Review summary model
class ReviewSummary {
  final String userId;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count
  final List<String> topKeywords;
  final DateTime lastReviewAt;

  const ReviewSummary({
    required this.userId,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.topKeywords,
    required this.lastReviewAt,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      userId: json['user_id'] as String,
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'] as int,
      ratingDistribution: Map<int, int>.from(json['rating_distribution'] ?? {}),
      topKeywords: List<String>.from(json['top_keywords'] ?? []),
      lastReviewAt: DateTime.parse(json['last_review_at'] as String),
    );
  }
}

/// Review service for managing reviews and ratings
class ReviewService {
  final ApiService _apiService;

  ReviewService(this._apiService);

  // === REVIEW MANAGEMENT ===

  /// Create a new review
  Future<ApiResponse<Review>> createReview(ReviewRequest request) async {
    return _apiService.post<Review>(
      '/reviews/',
      body: request.toJson(),
      fromJson: (data) => Review.fromJson(data),
    );
  }

  /// Get review by ID
  Future<ApiResponse<Review>> getReview(String reviewId) async {
    return _apiService.get<Review>(
      '/reviews/$reviewId/',
      fromJson: (data) => Review.fromJson(data),
    );
  }

  /// Update review
  Future<ApiResponse<Review>> updateReview(
    String reviewId,
    Map<String, dynamic> updates,
  ) async {
    return _apiService.patch<Review>(
      '/reviews/$reviewId/',
      body: updates,
      fromJson: (data) => Review.fromJson(data),
    );
  }

  /// Delete review
  Future<ApiResponse<Map<String, dynamic>>> deleteReview(
      String reviewId) async {
    return _apiService.delete<Map<String, dynamic>>(
      '/reviews/$reviewId/',
      fromJson: (data) => data,
    );
  }

  /// Get reviews for a specific user (provider/customer)
  Future<ApiResponse<List<Review>>> getUserReviews(
    String userId, {
    String? reviewerType,
    double? minRating,
    double? maxRating,
    bool? verifiedOnly,
    bool? publicOnly,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (reviewerType != null) queryParams['reviewer_type'] = reviewerType;
    if (minRating != null) queryParams['min_rating'] = minRating.toString();
    if (maxRating != null) queryParams['max_rating'] = maxRating.toString();
    if (verifiedOnly != null) queryParams['verified_only'] = '$verifiedOnly';
    if (publicOnly != null) queryParams['public_only'] = '$publicOnly';
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Review>>(
      '/reviews/user/$userId/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  /// Get reviews by current user (as reviewer)
  Future<ApiResponse<List<Review>>> getMyReviews({
    double? minRating,
    double? maxRating,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (minRating != null) queryParams['min_rating'] = minRating.toString();
    if (maxRating != null) queryParams['max_rating'] = maxRating.toString();
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Review>>(
      '/reviews/me/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  /// Get reviews for current user (received reviews)
  Future<ApiResponse<List<Review>>> getReviewsForMe({
    String? reviewerType,
    double? minRating,
    double? maxRating,
    bool? verifiedOnly,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (reviewerType != null) queryParams['reviewer_type'] = reviewerType;
    if (minRating != null) queryParams['min_rating'] = minRating.toString();
    if (maxRating != null) queryParams['max_rating'] = maxRating.toString();
    if (verifiedOnly != null) queryParams['verified_only'] = '$verifiedOnly';
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Review>>(
      '/reviews/for_me/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  /// Get review for specific booking
  Future<ApiResponse<Review>> getBookingReview(String bookingId) async {
    return _apiService.get<Review>(
      '/reviews/booking/$bookingId/',
      fromJson: (data) => Review.fromJson(data),
    );
  }

  // === REVIEW ANALYTICS ===

  /// Get review summary for user
  Future<ApiResponse<ReviewSummary>> getReviewSummary(String userId) async {
    return _apiService.get<ReviewSummary>(
      '/reviews/user/$userId/summary/',
      fromJson: (data) => ReviewSummary.fromJson(data),
    );
  }

  /// Get my review summary
  Future<ApiResponse<ReviewSummary>> getMyReviewSummary() async {
    return _apiService.get<ReviewSummary>(
      '/reviews/me/summary/',
      fromJson: (data) => ReviewSummary.fromJson(data),
    );
  }

  /// Get review analytics
  Future<ApiResponse<Map<String, dynamic>>> getReviewAnalytics({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy, // 'day', 'week', 'month'
  }) async {
    final queryParams = <String, String>{};
    if (userId != null) queryParams['user_id'] = userId;
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (groupBy != null) queryParams['group_by'] = groupBy;

    return _apiService.get<Map<String, dynamic>>(
      '/reviews/analytics/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }

  // === REVIEW SEARCH AND FILTER ===

  /// Search reviews
  Future<ApiResponse<List<Review>>> searchReviews({
    String? query,
    String? userId,
    String? reviewerType,
    double? minRating,
    double? maxRating,
    bool? verifiedOnly,
    bool? publicOnly,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy, // 'rating', 'created_at', 'helpful_count'
    String? sortOrder, // 'asc', 'desc'
    int? page,
    int? pageSize,
  }) async {
    return _apiService.post<List<Review>>(
      '/reviews/search/',
      body: {
        if (query != null) 'query': query,
        if (userId != null) 'user_id': userId,
        if (reviewerType != null) 'reviewer_type': reviewerType,
        if (minRating != null) 'min_rating': minRating,
        if (maxRating != null) 'max_rating': maxRating,
        if (verifiedOnly != null) 'verified_only': verifiedOnly,
        if (publicOnly != null) 'public_only': publicOnly,
        if (startDate != null)
          'start_date': startDate.toIso8601String().split('T')[0],
        if (endDate != null)
          'end_date': endDate.toIso8601String().split('T')[0],
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
        if (page != null) 'page': page,
        if (pageSize != null) 'page_size': pageSize,
      },
      fromJson: (data) => (data['results'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  /// Get top-rated providers
  Future<ApiResponse<List<Map<String, dynamic>>>> getTopRatedProviders({
    String? categoryId,
    String? location,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (location != null) queryParams['location'] = location;
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Map<String, dynamic>>>(
      '/reviews/top_rated_providers/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => List<Map<String, dynamic>>.from(data['results']),
    );
  }

  /// Get recent reviews
  Future<ApiResponse<List<Review>>> getRecentReviews({
    int? limit,
    bool? verifiedOnly,
    bool? publicOnly,
  }) async {
    final queryParams = <String, String>{};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (verifiedOnly != null) queryParams['verified_only'] = '$verifiedOnly';
    if (publicOnly != null) queryParams['public_only'] = '$publicOnly';

    return _apiService.get<List<Review>>(
      '/reviews/recent/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  // === REVIEW INTERACTIONS ===

  /// Mark review as helpful
  Future<ApiResponse<Map<String, dynamic>>> markReviewAsHelpful(
      String reviewId) async {
    return _apiService.post<Map<String, dynamic>>(
      '/reviews/$reviewId/helpful/',
      fromJson: (data) => data,
    );
  }

  /// Remove helpful mark from review
  Future<ApiResponse<Map<String, dynamic>>> removeHelpfulMark(
      String reviewId) async {
    return _apiService.delete<Map<String, dynamic>>(
      '/reviews/$reviewId/helpful/',
      fromJson: (data) => data,
    );
  }

  /// Report review
  Future<ApiResponse<Map<String, dynamic>>> reportReview(
    String reviewId, {
    required String reason,
    String? description,
  }) async {
    return _apiService.post<Map<String, dynamic>>(
      '/reviews/$reviewId/report/',
      body: {
        'reason': reason,
        if (description != null) 'description': description,
      },
      fromJson: (data) => data,
    );
  }

  /// Respond to review (Provider only)
  Future<ApiResponse<Map<String, dynamic>>> respondToReview(
    String reviewId,
    String response,
  ) async {
    return _apiService.post<Map<String, dynamic>>(
      '/reviews/$reviewId/respond/',
      body: {'response': response},
      fromJson: (data) => data,
    );
  }

  // === REVIEW REMINDERS ===

  /// Send review reminder for booking
  Future<ApiResponse<Map<String, dynamic>>> sendReviewReminder(
      String bookingId) async {
    return _apiService.post<Map<String, dynamic>>(
      '/reviews/reminders/',
      body: {'booking_id': bookingId},
      fromJson: (data) => data,
    );
  }

  /// Get pending review requests
  Future<ApiResponse<List<Map<String, dynamic>>>>
      getPendingReviewRequests() async {
    return _apiService.get<List<Map<String, dynamic>>>(
      '/reviews/pending_requests/',
      fromJson: (data) => List<Map<String, dynamic>>.from(data['results']),
    );
  }

  // === ADMIN OPERATIONS ===

  /// Admin: Get all reviews with filters
  Future<ApiResponse<List<Review>>> adminGetReviews({
    String? status, // 'published', 'flagged', 'hidden'
    String? reviewerId,
    String? revieweeId,
    double? minRating,
    double? maxRating,
    bool? hasReports,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (reviewerId != null) queryParams['reviewer_id'] = reviewerId;
    if (revieweeId != null) queryParams['reviewee_id'] = revieweeId;
    if (minRating != null) queryParams['min_rating'] = minRating.toString();
    if (maxRating != null) queryParams['max_rating'] = maxRating.toString();
    if (hasReports != null) queryParams['has_reports'] = '$hasReports';
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

    return _apiService.get<List<Review>>(
      '/admin/reviews/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  /// Admin: Moderate review
  Future<ApiResponse<Review>> adminModerateReview(
    String reviewId, {
    required String action, // 'approve', 'hide', 'delete'
    String? reason,
    String? adminNotes,
  }) async {
    return _apiService.post<Review>(
      '/admin/reviews/$reviewId/moderate/',
      body: {
        'action': action,
        if (reason != null) 'reason': reason,
        if (adminNotes != null) 'admin_notes': adminNotes,
      },
      fromJson: (data) => Review.fromJson(data),
    );
  }

  /// Admin: Verify review
  Future<ApiResponse<Review>> adminVerifyReview(
    String reviewId, {
    String? verificationNotes,
  }) async {
    return _apiService.post<Review>(
      '/admin/reviews/$reviewId/verify/',
      body: {
        if (verificationNotes != null) 'verification_notes': verificationNotes,
      },
      fromJson: (data) => Review.fromJson(data),
    );
  }

  /// Admin: Get flagged reviews
  Future<ApiResponse<List<Review>>> adminGetFlaggedReviews({
    String? flagReason,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (flagReason != null) queryParams['flag_reason'] = flagReason;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Review>>(
      '/admin/reviews/flagged/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  /// Admin: Get review reports
  Future<ApiResponse<List<Map<String, dynamic>>>> adminGetReviewReports({
    String? status, // 'pending', 'reviewed', 'resolved'
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Map<String, dynamic>>>(
      '/admin/reviews/reports/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => List<Map<String, dynamic>>.from(data['results']),
    );
  }

  /// Admin: Resolve review report
  Future<ApiResponse<Map<String, dynamic>>> adminResolveReviewReport(
    String reportId, {
    required String resolution,
    String? adminNotes,
  }) async {
    return _apiService.post<Map<String, dynamic>>(
      '/admin/reviews/reports/$reportId/resolve/',
      body: {
        'resolution': resolution,
        if (adminNotes != null) 'admin_notes': adminNotes,
      },
      fromJson: (data) => data,
    );
  }

  /// Admin: Get review analytics
  Future<ApiResponse<Map<String, dynamic>>> adminGetReviewAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
    List<String>? metrics,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (groupBy != null) queryParams['group_by'] = groupBy;
    if (metrics != null) queryParams['metrics'] = metrics.join(',');

    return _apiService.get<Map<String, dynamic>>(
      '/admin/reviews/analytics/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }
}

/// Provider for ReviewService
final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService(ApiService());
});
