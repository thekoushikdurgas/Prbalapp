import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Service Category model
class ServiceCategory {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final String? iconUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    this.iconUrl,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
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

/// Service Category creation/update request
class ServiceCategoryRequest {
  final String name;
  final String description;
  final bool? isActive;
  final String? iconUrl;
  final int? sortOrder;

  const ServiceCategoryRequest({
    required this.name,
    required this.description,
    this.isActive,
    this.iconUrl,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (isActive != null) 'is_active': isActive,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (sortOrder != null) 'sort_order': sortOrder,
    };
  }
}

/// Service Category Statistics
class ServiceCategoryStatistics {
  final int totalCategories;
  final int activeCategories;
  final int inactiveCategories;
  final Map<String, int> serviceDistribution;

  const ServiceCategoryStatistics({
    required this.totalCategories,
    required this.activeCategories,
    required this.inactiveCategories,
    required this.serviceDistribution,
  });

  factory ServiceCategoryStatistics.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryStatistics(
      totalCategories: json['total_categories'] as int,
      activeCategories: json['active_categories'] as int,
      inactiveCategories: json['inactive_categories'] as int,
      serviceDistribution:
          Map<String, int>.from(json['service_distribution'] ?? {}),
    );
  }
}

/// Service Category Service class
class ServiceCategoryService {
  final ApiService _apiService;

  ServiceCategoryService(this._apiService);

  /// Get all service categories
  /// GET /api/v1/services/categories/
  Future<ApiResponse<List<ServiceCategory>>> getCategories({
    bool? activeOnly,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};
    if (activeOnly != null) queryParams['active_only'] = activeOnly.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    final response = await _apiService.get<List<ServiceCategory>>(
      '/services/categories/',
      queryParameters: queryParams,
      fromJson: (json) {
        final results = json['results'] as List?;
        if (results != null) {
          return results.map((item) => ServiceCategory.fromJson(item)).toList();
        }
        return <ServiceCategory>[];
      },
    );

    return response;
  }

  /// Get a specific service category
  /// GET /api/v1/services/categories/{categoryId}/
  Future<ApiResponse<ServiceCategory>> getCategory(String categoryId) async {
    final response = await _apiService.get<ServiceCategory>(
      '/services/categories/$categoryId/',
      fromJson: (json) => ServiceCategory.fromJson(json),
    );

    return response;
  }

  /// Create a new service category (Admin only)
  /// POST /api/v1/services/categories/
  Future<ApiResponse<ServiceCategory>> createCategory(
    ServiceCategoryRequest request,
  ) async {
    final response = await _apiService.post<ServiceCategory>(
      '/services/categories/',
      body: request.toJson(),
      fromJson: (json) => ServiceCategory.fromJson(json),
    );

    return response;
  }

  /// Update a service category (Admin only)
  /// PUT /api/v1/services/categories/{categoryId}/
  Future<ApiResponse<ServiceCategory>> updateCategory(
    String categoryId,
    ServiceCategoryRequest request,
  ) async {
    final response = await _apiService.put<ServiceCategory>(
      '/services/categories/$categoryId/',
      body: request.toJson(),
      fromJson: (json) => ServiceCategory.fromJson(json),
    );

    return response;
  }

  /// Partially update a service category (Admin only)
  /// PATCH /api/v1/services/categories/{categoryId}/
  Future<ApiResponse<ServiceCategory>> partialUpdateCategory(
    String categoryId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.patch<ServiceCategory>(
      '/services/categories/$categoryId/',
      body: updates,
      fromJson: (json) => ServiceCategory.fromJson(json),
    );

    return response;
  }

  /// Delete a service category (Admin only)
  /// DELETE /api/v1/services/categories/{categoryId}/
  Future<ApiResponse<void>> deleteCategory(String categoryId) async {
    final response = await _apiService.delete<void>(
      '/services/categories/$categoryId/',
    );

    return response;
  }

  /// Get category statistics (Admin only)
  /// GET /api/v1/services/categories/statistics/
  Future<ApiResponse<ServiceCategoryStatistics>> getCategoryStatistics() async {
    final response = await _apiService.get<ServiceCategoryStatistics>(
      '/services/categories/statistics/',
      fromJson: (json) => ServiceCategoryStatistics.fromJson(json),
    );

    return response;
  }
}

/// Provider for ServiceCategoryService
final serviceCategoryServiceProvider = Provider<ServiceCategoryService>((ref) {
  return ServiceCategoryService(ApiService());
});

/// State providers for service categories
final serviceCategoriesProvider = StateNotifierProvider<
    ServiceCategoriesNotifier, AsyncValue<List<ServiceCategory>>>((ref) {
  return ServiceCategoriesNotifier(ref.read(serviceCategoryServiceProvider));
});

/// Service Categories state notifier
class ServiceCategoriesNotifier
    extends StateNotifier<AsyncValue<List<ServiceCategory>>> {
  final ServiceCategoryService _service;

  ServiceCategoriesNotifier(this._service) : super(const AsyncValue.loading()) {
    loadCategories();
  }

  /// Load service categories
  Future<void> loadCategories({bool activeOnly = true}) async {
    state = const AsyncValue.loading();

    final response = await _service.getCategories(activeOnly: activeOnly);

    if (response.success && response.data != null) {
      state = AsyncValue.data(response.data!);
    } else {
      state = AsyncValue.error(
        response.message ?? 'Failed to load categories',
        StackTrace.current,
      );
    }
  }

  /// Create a new category
  Future<bool> createCategory(ServiceCategoryRequest request) async {
    final response = await _service.createCategory(request);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      state = AsyncValue.data([...currentState, response.data!]);
      return true;
    }

    return false;
  }

  /// Update an existing category
  Future<bool> updateCategory(
      String categoryId, ServiceCategoryRequest request) async {
    final response = await _service.updateCategory(categoryId, request);

    if (response.success && response.data != null) {
      final currentState = state.asData?.value ?? [];
      final updatedList = currentState.map((category) {
        return category.id == categoryId ? response.data! : category;
      }).toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Delete a category
  Future<bool> deleteCategory(String categoryId) async {
    final response = await _service.deleteCategory(categoryId);

    if (response.success) {
      final currentState = state.asData?.value ?? [];
      final updatedList =
          currentState.where((category) => category.id != categoryId).toList();
      state = AsyncValue.data(updatedList);
      return true;
    }

    return false;
  }

  /// Refresh categories
  Future<void> refresh() => loadCategories();
}
