import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Service Request model
class ServiceRequest {
  final String id;
  final String customerId;
  final String title;
  final String description;
  final String categoryId;
  final List<String> subcategoryIds;
  final double budgetMin;
  final double budgetMax;
  final String currency;
  final String urgency; // 'low', 'medium', 'high'
  final DateTime? requestedDateTime;
  final String location;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? requirements;
  final String status; // 'open', 'fulfilled', 'cancelled', 'expired'
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceRequest({
    required this.id,
    required this.customerId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.subcategoryIds,
    required this.budgetMin,
    required this.budgetMax,
    required this.currency,
    required this.urgency,
    this.requestedDateTime,
    required this.location,
    this.latitude,
    this.longitude,
    this.requirements,
    required this.status,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['category'] as String,
      subcategoryIds: List<String>.from(json['subcategories'] ?? []),
      budgetMin: (json['budget_min'] as num).toDouble(),
      budgetMax: (json['budget_max'] as num).toDouble(),
      currency: json['currency'] as String,
      urgency: json['urgency'] as String,
      requestedDateTime: json['requested_date_time'] != null
          ? DateTime.parse(json['requested_date_time'] as String)
          : null,
      location: json['location'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      requirements: json['requirements'] as Map<String, dynamic>?,
      status: json['status'] as String,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'title': title,
      'description': description,
      'category': categoryId,
      'subcategories': subcategoryIds,
      'budget_min': budgetMin,
      'budget_max': budgetMax,
      'currency': currency,
      'urgency': urgency,
      if (requestedDateTime != null)
        'requested_date_time': requestedDateTime!.toIso8601String(),
      'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (requirements != null) 'requirements': requirements,
      'status': status,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Service Request creation/update request
class ServiceRequestRequest {
  final String title;
  final String description;
  final String categoryId;
  final List<String> subcategoryIds;
  final double budgetMin;
  final double budgetMax;
  final String currency;
  final String urgency;
  final DateTime? requestedDateTime;
  final String location;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? requirements;

  const ServiceRequestRequest({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.subcategoryIds,
    required this.budgetMin,
    required this.budgetMax,
    required this.currency,
    required this.urgency,
    this.requestedDateTime,
    required this.location,
    this.latitude,
    this.longitude,
    this.requirements,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': categoryId,
      'subcategories': subcategoryIds,
      'budget_min': budgetMin,
      'budget_max': budgetMax,
      'currency': currency,
      'urgency': urgency,
      if (requestedDateTime != null)
        'requested_date_time': requestedDateTime!.toIso8601String(),
      'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (requirements != null) 'requirements': requirements,
    };
  }
}

/// Recommended Provider model
class RecommendedProvider {
  final String id;
  final String name;
  final String email;
  final double rating;
  final int reviewCount;
  final String? profileImageUrl;
  final List<String> specializations;
  final double distance; // in kilometers
  final bool isVerified;

  const RecommendedProvider({
    required this.id,
    required this.name,
    required this.email,
    required this.rating,
    required this.reviewCount,
    this.profileImageUrl,
    required this.specializations,
    required this.distance,
    required this.isVerified,
  });

  factory RecommendedProvider.fromJson(Map<String, dynamic> json) {
    return RecommendedProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      profileImageUrl: json['profile_image_url'] as String?,
      specializations: List<String>.from(json['specializations'] ?? []),
      distance: (json['distance'] as num).toDouble(),
      isVerified: json['is_verified'] as bool,
    );
  }
}

/// Service Request Service class
class ServiceRequestService {
  final ApiService _apiService;

  ServiceRequestService(this._apiService);

  /// Get all service requests
  /// GET /api/v1/service-requests/
  Future<ApiResponse<List<ServiceRequest>>> getServiceRequests({
    String? categoryId,
    String? urgency,
    String? status,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (categoryId != null) queryParams['category'] = categoryId;
    if (urgency != null) queryParams['urgency'] = urgency;
    if (status != null) queryParams['status'] = status;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    final response = await _apiService.get<List<ServiceRequest>>(
      '/service-requests/',
      queryParameters: queryParams,
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results.map((item) => ServiceRequest.fromJson(item)).toList();
        }
        return <ServiceRequest>[];
      },
    );

    return response;
  }

  /// Filter service requests by category
  /// GET /api/v1/service-requests/?category={categoryId}
  Future<ApiResponse<List<ServiceRequest>>> getServiceRequestsByCategory(
    String categoryId,
  ) async {
    return getServiceRequests(categoryId: categoryId);
  }

  /// Filter service requests by urgency
  /// GET /api/v1/service-requests/?urgency={urgency}
  Future<ApiResponse<List<ServiceRequest>>> getServiceRequestsByUrgency(
    String urgency,
  ) async {
    return getServiceRequests(urgency: urgency);
  }

  /// Get a specific service request
  /// GET /api/v1/service-requests/{requestId}/
  Future<ApiResponse<ServiceRequest>> getServiceRequest(
      String requestId) async {
    final response = await _apiService.get<ServiceRequest>(
      '/service-requests/$requestId/',
      fromJson: (json) => ServiceRequest.fromJson(json),
    );

    return response;
  }

  /// Create a new service request (Customer only)
  /// POST /api/v1/service-requests/
  Future<ApiResponse<ServiceRequest>> createServiceRequest(
    ServiceRequestRequest request,
  ) async {
    final response = await _apiService.post<ServiceRequest>(
      '/service-requests/',
      body: request.toJson(),
      fromJson: (json) => ServiceRequest.fromJson(json),
    );

    return response;
  }

  /// Update a service request (Owner only)
  /// PUT /api/v1/service-requests/{requestId}/
  Future<ApiResponse<ServiceRequest>> updateServiceRequest(
    String requestId,
    ServiceRequestRequest request,
  ) async {
    final response = await _apiService.put<ServiceRequest>(
      '/service-requests/$requestId/',
      body: request.toJson(),
      fromJson: (json) => ServiceRequest.fromJson(json),
    );

    return response;
  }

  /// Partially update a service request (Owner only)
  /// PATCH /api/v1/service-requests/{requestId}/
  Future<ApiResponse<ServiceRequest>> partialUpdateServiceRequest(
    String requestId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.patch<ServiceRequest>(
      '/service-requests/$requestId/',
      body: updates,
      fromJson: (json) => ServiceRequest.fromJson(json),
    );

    return response;
  }

  /// Delete a service request (Owner only)
  /// DELETE /api/v1/service-requests/{requestId}/
  Future<ApiResponse<void>> deleteServiceRequest(String requestId) async {
    final response = await _apiService.delete<void>(
      '/service-requests/$requestId/',
    );

    return response;
  }

  /// Get my requests (Customer only)
  /// GET /api/v1/service-requests/my_requests/
  Future<ApiResponse<List<ServiceRequest>>> getMyRequests() async {
    final response = await _apiService.get<List<ServiceRequest>>(
      '/service-requests/my_requests/',
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results.map((item) => ServiceRequest.fromJson(item)).toList();
        }
        return <ServiceRequest>[];
      },
    );

    return response;
  }

  /// Admin view all requests
  /// GET /api/v1/service-requests/admin/
  Future<ApiResponse<List<ServiceRequest>>> getAllRequestsAdmin() async {
    final response = await _apiService.get<List<ServiceRequest>>(
      '/service-requests/admin/',
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results.map((item) => ServiceRequest.fromJson(item)).toList();
        }
        return <ServiceRequest>[];
      },
    );

    return response;
  }

  /// Get recommended providers for a request
  /// GET /api/v1/service-requests/{requestId}/recommended_providers/
  Future<ApiResponse<List<RecommendedProvider>>> getRecommendedProviders(
    String requestId,
  ) async {
    final response = await _apiService.get<List<RecommendedProvider>>(
      '/service-requests/$requestId/recommended_providers/',
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results
              .map((item) => RecommendedProvider.fromJson(item))
              .toList();
        }
        return <RecommendedProvider>[];
      },
    );

    return response;
  }

  /// Batch expire requests (Admin only)
  /// POST /api/v1/service-requests/batch_expire/
  Future<ApiResponse<Map<String, dynamic>>> batchExpireRequests() async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/service-requests/batch_expire/',
      body: {},
      fromJson: (json) => json,
    );

    return response;
  }

  /// Cancel a request (Owner only)
  /// POST /api/v1/service-requests/{requestId}/cancel/
  Future<ApiResponse<ServiceRequest>> cancelRequest(String requestId) async {
    final response = await _apiService.post<ServiceRequest>(
      '/service-requests/$requestId/cancel/',
      body: {},
      fromJson: (json) => ServiceRequest.fromJson(json),
    );

    return response;
  }
}

/// Provider for ServiceRequestService
final serviceRequestServiceProvider = Provider<ServiceRequestService>((ref) {
  return ServiceRequestService(ApiService());
});

/// State providers for service requests
final serviceRequestsProvider = StateNotifierProvider<ServiceRequestsNotifier,
    AsyncValue<List<ServiceRequest>>>((ref) {
  return ServiceRequestsNotifier(ref.read(serviceRequestServiceProvider));
});

/// My Service Requests provider
final myServiceRequestsProvider = StateNotifierProvider<
    MyServiceRequestsNotifier, AsyncValue<List<ServiceRequest>>>((ref) {
  return MyServiceRequestsNotifier(ref.read(serviceRequestServiceProvider));
});

/// Service Requests state notifier
class ServiceRequestsNotifier
    extends StateNotifier<AsyncValue<List<ServiceRequest>>> {
  final ServiceRequestService _service;

  ServiceRequestsNotifier(this._service) : super(const AsyncValue.loading()) {
    loadServiceRequests();
  }

  /// Load service requests
  Future<void> loadServiceRequests({
    String? categoryId,
    String? urgency,
    String? status,
  }) async {
    state = const AsyncValue.loading();

    final response = await _service.getServiceRequests(
      categoryId: categoryId,
      urgency: urgency,
      status: status,
    );

    if (response.success && response.data != null) {
      state = AsyncValue.data(response.data!);
    } else {
      state = AsyncValue.error(
        response.message ?? 'Failed to load service requests',
        StackTrace.current,
      );
    }
  }

  /// Create a new service request
  Future<bool> createServiceRequest(ServiceRequestRequest request) async {
    final response = await _service.createServiceRequest(request);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      state = AsyncValue.data([response.data!, ...currentState]);
      return true;
    }

    return false;
  }

  /// Update an existing service request
  Future<bool> updateServiceRequest(
      String requestId, ServiceRequestRequest request) async {
    final response = await _service.updateServiceRequest(requestId, request);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState.map((serviceRequest) {
        return serviceRequest.id == requestId ? response.data! : serviceRequest;
      }).toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Cancel a service request
  Future<bool> cancelServiceRequest(String requestId) async {
    final response = await _service.cancelRequest(requestId);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState.map((serviceRequest) {
        return serviceRequest.id == requestId ? response.data! : serviceRequest;
      }).toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Delete a service request
  Future<bool> deleteServiceRequest(String requestId) async {
    final response = await _service.deleteServiceRequest(requestId);

    if (response.success) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState
          .where((serviceRequest) => serviceRequest.id != requestId)
          .toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Refresh service requests
  Future<void> refresh() => loadServiceRequests();
}

/// My Service Requests state notifier
class MyServiceRequestsNotifier
    extends StateNotifier<AsyncValue<List<ServiceRequest>>> {
  final ServiceRequestService _service;

  MyServiceRequestsNotifier(this._service) : super(const AsyncValue.loading()) {
    loadMyRequests();
  }

  /// Load my service requests
  Future<void> loadMyRequests() async {
    state = const AsyncValue.loading();

    final response = await _service.getMyRequests();

    if (response.success && response.data != null) {
      state = AsyncValue.data(response.data!);
    } else {
      state = AsyncValue.error(
        response.message ?? 'Failed to load my requests',
        StackTrace.current,
      );
    }
  }

  /// Create a new service request
  Future<bool> createServiceRequest(ServiceRequestRequest request) async {
    final response = await _service.createServiceRequest(request);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      state = AsyncValue.data([response.data!, ...currentState]);
      return true;
    }

    return false;
  }

  /// Update an existing service request
  Future<bool> updateServiceRequest(
      String requestId, ServiceRequestRequest request) async {
    final response = await _service.updateServiceRequest(requestId, request);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState.map((serviceRequest) {
        return serviceRequest.id == requestId ? response.data! : serviceRequest;
      }).toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Cancel a service request
  Future<bool> cancelServiceRequest(String requestId) async {
    final response = await _service.cancelRequest(requestId);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState.map((serviceRequest) {
        return serviceRequest.id == requestId ? response.data! : serviceRequest;
      }).toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Delete a service request
  Future<bool> deleteServiceRequest(String requestId) async {
    final response = await _service.deleteServiceRequest(requestId);

    if (response.success) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState
          .where((serviceRequest) => serviceRequest.id != requestId)
          .toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Refresh my requests
  Future<void> refresh() => loadMyRequests();
}
