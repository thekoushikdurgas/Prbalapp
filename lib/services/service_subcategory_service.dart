import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Service Subcategory model
class ServiceSubcategory {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final bool isActive;
  final String? iconUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceSubcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.isActive,
    this.iconUrl,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceSubcategory.fromJson(Map<String, dynamic> json) {
    return ServiceSubcategory(
      id: json['id'] as String,
      categoryId: json['category'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] as bool,
      iconUrl: json['icon_url'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': categoryId,
      'name': name,
      'description': description,
      'is_active': isActive,
      if (iconUrl != null) 'icon_url': iconUrl,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Service Subcategory creation/update request
class ServiceSubcategoryRequest {
  final String categoryId;
  final String name;
  final String description;
  final bool? isActive;
  final String? iconUrl;
  final int? sortOrder;

  const ServiceSubcategoryRequest({
    required this.categoryId,
    required this.name,
    required this.description,
    this.isActive,
    this.iconUrl,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': categoryId,
      'name': name,
      'description': description,
      if (isActive != null) 'is_active': isActive,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (sortOrder != null) 'sort_order': sortOrder,
    };
  }
}

/// Service Subcategory Service class
class ServiceSubcategoryService {
  final ApiService _apiService;

  ServiceSubcategoryService(this._apiService);

  /// Get all service subcategories
  /// GET /api/v1/services/subcategories/
  Future<ApiResponse<List<ServiceSubcategory>>> getSubcategories({
    String? categoryId,
    bool? activeOnly,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (categoryId != null) queryParams['category'] = categoryId;
    if (activeOnly != null) queryParams['active_only'] = activeOnly.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    final response = await _apiService.get<List<ServiceSubcategory>>(
      '/services/subcategories/',
      queryParameters: queryParams,
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results
              .map((item) => ServiceSubcategory.fromJson(item))
              .toList();
        }
        return <ServiceSubcategory>[];
      },
    );

    return response;
  }

  /// Get subcategories filtered by category
  /// GET /api/v1/services/subcategories/?category={categoryId}
  Future<ApiResponse<List<ServiceSubcategory>>> getSubcategoriesByCategory(
    String categoryId, {
    bool activeOnly = true,
  }) async {
    return getSubcategories(categoryId: categoryId, activeOnly: activeOnly);
  }

  /// Get a specific service subcategory
  /// GET /api/v1/services/subcategories/{subcategoryId}/
  Future<ApiResponse<ServiceSubcategory>> getSubcategory(
      String subcategoryId) async {
    final response = await _apiService.get<ServiceSubcategory>(
      '/services/subcategories/$subcategoryId/',
      fromJson: (json) => ServiceSubcategory.fromJson(json),
    );

    return response;
  }

  /// Create a new service subcategory (Admin only)
  /// POST /api/v1/services/subcategories/
  Future<ApiResponse<ServiceSubcategory>> createSubcategory(
    ServiceSubcategoryRequest request,
  ) async {
    final response = await _apiService.post<ServiceSubcategory>(
      '/services/subcategories/',
      body: request.toJson(),
      fromJson: (json) => ServiceSubcategory.fromJson(json),
    );

    return response;
  }

  /// Update a service subcategory (Admin only)
  /// PUT /api/v1/services/subcategories/{subcategoryId}/
  Future<ApiResponse<ServiceSubcategory>> updateSubcategory(
    String subcategoryId,
    ServiceSubcategoryRequest request,
  ) async {
    final response = await _apiService.put<ServiceSubcategory>(
      '/services/subcategories/$subcategoryId/',
      body: request.toJson(),
      fromJson: (json) => ServiceSubcategory.fromJson(json),
    );

    return response;
  }

  /// Partially update a service subcategory (Admin only)
  /// PATCH /api/v1/services/subcategories/{subcategoryId}/
  Future<ApiResponse<ServiceSubcategory>> partialUpdateSubcategory(
    String subcategoryId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.patch<ServiceSubcategory>(
      '/services/subcategories/$subcategoryId/',
      body: updates,
      fromJson: (json) => ServiceSubcategory.fromJson(json),
    );

    return response;
  }

  /// Delete a service subcategory (Admin only)
  /// DELETE /api/v1/services/subcategories/{subcategoryId}/
  Future<ApiResponse<void>> deleteSubcategory(String subcategoryId) async {
    final response = await _apiService.delete<void>(
      '/services/subcategories/$subcategoryId/',
    );

    return response;
  }
}

/// Provider for ServiceSubcategoryService
final serviceSubcategoryServiceProvider =
    Provider<ServiceSubcategoryService>((ref) {
  return ServiceSubcategoryService(ApiService());
});

/// State providers for service subcategories
final serviceSubcategoriesProvider = StateNotifierProvider.family<
    ServiceSubcategoriesNotifier,
    AsyncValue<List<ServiceSubcategory>>,
    String?>((ref, categoryId) {
  return ServiceSubcategoriesNotifier(
      ref.read(serviceSubcategoryServiceProvider), categoryId);
});

/// Service Subcategories state notifier
class ServiceSubcategoriesNotifier
    extends StateNotifier<AsyncValue<List<ServiceSubcategory>>> {
  final ServiceSubcategoryService _service;
  final String? categoryId;

  ServiceSubcategoriesNotifier(this._service, this.categoryId)
      : super(const AsyncValue.loading()) {
    loadSubcategories();
  }

  /// Load service subcategories
  Future<void> loadSubcategories({bool activeOnly = true}) async {
    state = const AsyncValue.loading();

    final response = await _service.getSubcategories(
      categoryId: categoryId,
      activeOnly: activeOnly,
    );

    if (response.success && response.data != null) {
      state = AsyncValue.data(response.data!);
    } else {
      state = AsyncValue.error(
        response.message ?? 'Failed to load subcategories',
        StackTrace.current,
      );
    }
  }

  /// Create a new subcategory
  Future<bool> createSubcategory(ServiceSubcategoryRequest request) async {
    final response = await _service.createSubcategory(request);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      state = AsyncValue.data([...currentState, response.data!]);
      return true;
    }

    return false;
  }

  /// Update an existing subcategory
  Future<bool> updateSubcategory(
      String subcategoryId, ServiceSubcategoryRequest request) async {
    final response = await _service.updateSubcategory(subcategoryId, request);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState.map((subcategory) {
        return subcategory.id == subcategoryId ? response.data! : subcategory;
      }).toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Delete a subcategory
  Future<bool> deleteSubcategory(String subcategoryId) async {
    final response = await _service.deleteSubcategory(subcategoryId);

    if (response.success) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState
          .where((subcategory) => subcategory.id != subcategoryId)
          .toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Refresh subcategories
  Future<void> refresh() => loadSubcategories();
}
