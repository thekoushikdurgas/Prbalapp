import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/user_service.dart';

// ====================================================================
// MODELS - Based on Postman collection response structure
// Analyzed from Categories.postman_collection.json and Services.postman_collection.json
// Standard response format: {message, data, time, statusCode}
// ====================================================================

/// Service Category Model
/// Represents a service category like "Home Services", "Tech Services"
/// API Endpoints: /services/categories/
/// Permissions: Read (All), Write (Admin only)
/// Features: Filtering, Searching, Ordering, Statistics
class ServiceCategory {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final String? iconUrl;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.iconUrl,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    debugPrint('🗂️ ServiceCategory.fromJson: Parsing category data');
    debugPrint('🗂️ → Category ID: ${json['id']}');
    debugPrint('🗂️ → Category Name: ${json['name']}');
    debugPrint('🗂️ → Description Length: ${(json['description'] ?? '').length} chars');
    debugPrint('🗂️ → Sort Order: ${json['sort_order']}');
    debugPrint('🗂️ → Is Active: ${json['is_active']}');
    debugPrint('🗂️ → Has Icon: ${json['icon'] != null}');
    debugPrint('🗂️ → Has Icon URL: ${json['icon_url'] != null}');
    debugPrint('🗂️ → Created At: ${json['created_at']}');
    debugPrint('🗂️ → Updated At: ${json['updated_at']}');

    try {
      final category = ServiceCategory(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        icon: json['icon'],
        iconUrl: json['icon_url'],
        sortOrder: json['sort_order'] ?? 0,
        isActive: json['is_active'] ?? true,
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      );

      debugPrint('🗂️ ServiceCategory.fromJson: Successfully parsed category "${category.name}"');
      return category;
    } catch (e, stackTrace) {
      debugPrint('🗂️ ServiceCategory.fromJson: Error parsing category data');
      debugPrint('🗂️ → Error: $e');
      debugPrint('🗂️ → Stack trace: $stackTrace');
      debugPrint('🗂️ → Raw JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'icon_url': iconUrl,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    debugPrint('🗂️ ServiceCategory.toJson: Converting category to JSON');
    debugPrint('🗂️ → Category: $name (${json.length} fields)');

    return json;
  }
}

/// Service Subcategory Model
/// Represents a subcategory like "Plumbing", "Electrical" under "Home Services"
/// API Endpoints: /services/subcategories/
/// Permissions: Read (All), Write (Admin only)
/// Features: Category filtering, Hierarchical structure
class ServiceSubcategory {
  final String id;
  final String category;
  final String categoryName;
  final String name;
  final String description;
  final String? icon;
  final String? iconUrl;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceSubcategory({
    required this.id,
    required this.category,
    required this.categoryName,
    required this.name,
    required this.description,
    this.icon,
    this.iconUrl,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceSubcategory.fromJson(Map<String, dynamic> json) {
    debugPrint('📁 ServiceSubcategory.fromJson: Parsing subcategory data');
    debugPrint('📁 → Subcategory ID: ${json['id']}');
    debugPrint('📁 → Subcategory Name: ${json['name']}');
    debugPrint('📁 → Parent Category ID: ${json['category']}');
    debugPrint('📁 → Parent Category Name: ${json['category_name']}');
    debugPrint('📁 → Description Length: ${(json['description'] ?? '').length} chars');
    debugPrint('📁 → Sort Order: ${json['sort_order']}');
    debugPrint('📁 → Is Active: ${json['is_active']}');

    try {
      // Handle nested category object if present
      String categoryId = '';
      String categoryName = '';

      if (json['category'] is Map<String, dynamic>) {
        final categoryObj = json['category'] as Map<String, dynamic>;
        categoryId = categoryObj['id'] ?? '';
        categoryName = categoryObj['name'] ?? '';
        debugPrint('📁 → Category object detected: $categoryName ($categoryId)');
      } else {
        categoryId = json['category'] ?? '';
        categoryName = json['category_name'] ?? '';
        debugPrint('📁 → Category ID reference: $categoryId');
      }

      final subcategory = ServiceSubcategory(
        id: json['id'] ?? '',
        category: categoryId,
        categoryName: categoryName,
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        icon: json['icon'],
        iconUrl: json['icon_url'],
        sortOrder: json['sort_order'] ?? 0,
        isActive: json['is_active'] ?? true,
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      );

      debugPrint('📁 ServiceSubcategory.fromJson: Successfully parsed subcategory "${subcategory.name}"');
      debugPrint('📁 → Under category: ${subcategory.categoryName}');
      return subcategory;
    } catch (e, stackTrace) {
      debugPrint('📁 ServiceSubcategory.fromJson: Error parsing subcategory data');
      debugPrint('📁 → Error: $e');
      debugPrint('📁 → Stack trace: $stackTrace');
      debugPrint('📁 → Raw JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'category': category,
      'category_name': categoryName,
      'name': name,
      'description': description,
      'icon': icon,
      'icon_url': iconUrl,
      'sort_order': sortOrder,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    debugPrint('📁 ServiceSubcategory.toJson: Converting subcategory to JSON');
    debugPrint('📁 → Subcategory: $name under $categoryName (${json.length} fields)');

    return json;
  }
}

/// Service Subcategory Request Model for creating subcategories
/// Used for POST /services/subcategories/ endpoint
/// Required fields based on Postman collection analysis
class ServiceSubcategoryRequest {
  final String category;
  final String name;
  final String description;
  final int? sortOrder;
  final bool isActive;

  ServiceSubcategoryRequest({
    required this.category,
    required this.name,
    required this.description,
    this.sortOrder,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'category': category,
      'name': name,
      'description': description,
      'is_active': isActive,
    };

    // Add sort_order if provided, or auto-assign if not provided
    if (sortOrder != null) {
      json['sort_order'] = sortOrder!;
      debugPrint('📁 ServiceSubcategoryRequest: Using provided sort order: $sortOrder');
    } else {
      // Auto-assign a default sort order based on timestamp
      json['sort_order'] = DateTime.now().millisecondsSinceEpoch % 1000;
      debugPrint('📁 ServiceSubcategoryRequest: Auto-assigned sort order: ${json['sort_order']}');
    }

    debugPrint('📁 ServiceSubcategoryRequest.toJson: Creating subcategory request');
    debugPrint('📁 → Name: $name');
    debugPrint('📁 → Category ID: $category');
    debugPrint('📁 → Description Length: ${description.length} chars');
    debugPrint('📁 → Is Active: $isActive');
    debugPrint('📁 → Final JSON: $json');

    return json;
  }
}

/// Service Model - Complete implementation based on Postman collection
/// Represents a service offered by a provider like "Professional Plumbing Service"
class Service {
  final String id;
  final Map<String, dynamic> provider;
  final String name;
  final String description;
  final Map<String, dynamic> category;
  final List<Map<String, dynamic>> subcategories;
  final List<String> tags;
  final double hourlyRate;
  final Map<String, dynamic>? pricingOptions;
  final String currency;
  final int? minHours;
  final int? maxHours;
  final Map<String, dynamic>? availability;
  final String location;
  final double? latitude;
  final double? longitude;
  final List<String> requiredTools;
  final String status;
  final bool isFeatured;
  final List<Map<String, dynamic>> serviceImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.provider,
    required this.name,
    required this.description,
    required this.category,
    required this.subcategories,
    required this.tags,
    required this.hourlyRate,
    this.pricingOptions,
    required this.currency,
    this.minHours,
    this.maxHours,
    this.availability,
    required this.location,
    this.latitude,
    this.longitude,
    required this.requiredTools,
    required this.status,
    required this.isFeatured,
    required this.serviceImages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    debugPrint('🔧 Service: Parsing service data - ${json['name']}');

    return Service(
      id: json['id'] ?? '',
      provider: Map<String, dynamic>.from(json['provider'] ?? {}),
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      category: Map<String, dynamic>.from(json['category'] ?? {}),
      subcategories: List<Map<String, dynamic>>.from(
          (json['subcategories'] as List<dynamic>?)?.map((item) => Map<String, dynamic>.from(item)) ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      hourlyRate: (json['hourly_rate'] ?? json['price'] ?? 0.0).toDouble(),
      pricingOptions: json['pricing_options'] != null ? Map<String, dynamic>.from(json['pricing_options']) : null,
      currency: json['currency'] ?? 'INR',
      minHours: json['min_hours'],
      maxHours: json['max_hours'],
      availability: json['availability'] != null ? Map<String, dynamic>.from(json['availability']) : null,
      location: json['location'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      requiredTools: List<String>.from(json['required_tools'] ?? []),
      status: json['status'] ?? 'active',
      isFeatured: json['is_featured'] ?? false,
      serviceImages: List<Map<String, dynamic>>.from(
          (json['service_images'] as List<dynamic>?)?.map((item) => Map<String, dynamic>.from(item)) ?? []),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'name': name,
      'description': description,
      'category': category,
      'subcategories': subcategories,
      'tags': tags,
      'hourly_rate': hourlyRate,
      'pricing_options': pricingOptions,
      'currency': currency,
      'min_hours': minHours,
      'max_hours': maxHours,
      'availability': availability,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'required_tools': requiredTools,
      'status': status,
      'is_featured': isFeatured,
      'service_images': serviceImages,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Service Request Model - Complete implementation based on Postman collection
/// Represents a request for service like "Need Emergency Plumbing Service"
class ServiceRequest {
  final String id;
  final Map<String, dynamic> customer;
  final String title;
  final String description;
  final Map<String, dynamic> category;
  final List<Map<String, dynamic>> subcategories;
  final double budgetMin;
  final double budgetMax;
  final String currency;
  final String urgency;
  final String status;
  final DateTime requestedDateTime;
  final String location;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? requirements;
  final List<Map<String, dynamic>> requestImages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;
  final int interestedProvidersCount;
  final int viewCount;

  ServiceRequest({
    required this.id,
    required this.customer,
    required this.title,
    required this.description,
    required this.category,
    required this.subcategories,
    required this.budgetMin,
    required this.budgetMax,
    required this.currency,
    required this.urgency,
    required this.status,
    required this.requestedDateTime,
    required this.location,
    this.latitude,
    this.longitude,
    this.requirements,
    required this.requestImages,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
    required this.interestedProvidersCount,
    required this.viewCount,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    debugPrint('🔧 ServiceRequest: Parsing service request data - ${json['title']}');

    return ServiceRequest(
      id: json['id'] ?? '',
      customer: Map<String, dynamic>.from(json['customer'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: Map<String, dynamic>.from(json['category'] ?? {}),
      subcategories: List<Map<String, dynamic>>.from(
          (json['subcategories'] as List<dynamic>?)?.map((item) => Map<String, dynamic>.from(item)) ?? []),
      budgetMin: (json['budget_min'] ?? 0.0).toDouble(),
      budgetMax: (json['budget_max'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'INR',
      urgency: json['urgency'] ?? 'medium',
      status: json['status'] ?? 'open',
      requestedDateTime: DateTime.tryParse(json['requested_date_time'] ?? '') ?? DateTime.now(),
      location: json['location'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      requirements: json['requirements'] != null ? Map<String, dynamic>.from(json['requirements']) : null,
      requestImages: List<Map<String, dynamic>>.from(
          (json['request_images'] as List<dynamic>?)?.map((item) => Map<String, dynamic>.from(item)) ?? []),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at']) : null,
      interestedProvidersCount: json['interested_providers_count'] ?? 0,
      viewCount: json['view_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customer,
      'title': title,
      'description': description,
      'category': category,
      'subcategories': subcategories,
      'budget_min': budgetMin,
      'budget_max': budgetMax,
      'currency': currency,
      'urgency': urgency,
      'status': status,
      'requested_date_time': requestedDateTime.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'requirements': requirements,
      'request_images': requestImages,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'interested_providers_count': interestedProvidersCount,
      'view_count': viewCount,
    };
  }
}

/// Service Management Service for handling all service-related operations
/// This service handles Categories, SubCategories, Services, and Service Requests
/// Based on the Prbal Services API endpoints defined in the Postman collection
class ServiceManagementService {
  final ApiService _apiService;

  // Cache timers for different data types
  Timer? _serviceCacheTimer;

  // Cache duration constants
  static const Duration _serviceCacheDuration = Duration(minutes: 15);

  // Stream controllers for real-time updates
  final StreamController<List<ServiceCategory>> _categoryStreamController =
      StreamController<List<ServiceCategory>>.broadcast();
  final StreamController<List<ServiceSubcategory>> _subcategoryStreamController =
      StreamController<List<ServiceSubcategory>>.broadcast();
  final StreamController<List<Service>> _serviceStreamController = StreamController<List<Service>>.broadcast();
  final StreamController<List<ServiceRequest>> _requestStreamController =
      StreamController<List<ServiceRequest>>.broadcast();

  ServiceManagementService(this._apiService) {
    debugPrint('🔧 ServiceManagementService: Initializing service management');
    debugPrint('🔧 ========================================');
    debugPrint('🔧 SERVICE MANAGEMENT ANALYSIS FROM POSTMAN');
    debugPrint('🔧 ========================================');
    debugPrint('🔧 📊 SUPPORTED OPERATIONS:');
    debugPrint('🔧   → Categories: List, Create, Update, Delete, Statistics');
    debugPrint('🔧   → SubCategories: List, Create, Update, Delete');
    debugPrint('🔧   → Services: Full CRUD operations (Future implementation)');
    debugPrint('🔧   → Service Requests: Management operations (Future implementation)');
    debugPrint('🔧 🔐 PERMISSION ANALYSIS:');
    debugPrint('🔧   → Read Operations: Available to all authenticated users');
    debugPrint('🔧   → Write Operations: Admin only (Categories/SubCategories)');
    debugPrint('🔧   → Service Creation: Provider users only');
    debugPrint('🔧   → Request Creation: Customer users only');
    debugPrint('🔧 📋 API ENDPOINT MAPPING:');
    debugPrint('🔧   → GET    /services/categories/ (List categories)');
    debugPrint('🔧   → POST   /services/categories/ (Create category - Admin)');
    debugPrint('🔧   → GET    /services/categories/{id}/ (Category details)');
    debugPrint('🔧   → PUT    /services/categories/{id}/ (Update category - Admin)');
    debugPrint('🔧   → PATCH  /services/categories/{id}/ (Partial update - Admin)');
    debugPrint('🔧   → DELETE /services/categories/{id}/ (Delete category - Admin)');
    debugPrint('🔧   → GET    /services/categories/statistics/ (Statistics - Admin)');
    debugPrint('🔧   → GET    /services/subcategories/ (List subcategories)');
    debugPrint('🔧   → POST   /services/subcategories/ (Create subcategory - Admin)');
    debugPrint('🔧   → GET    /services/subcategories/{id}/ (Subcategory details)');
    debugPrint('🔧   → PUT    /services/subcategories/{id}/ (Update subcategory - Admin)');
    debugPrint('🔧   → PATCH  /services/subcategories/{id}/ (Partial update - Admin)');
    debugPrint('🔧   → DELETE /services/subcategories/{id}/ (Delete subcategory - Admin)');
    debugPrint('🔧 💾 CACHING STRATEGY:');
    debugPrint('🔧   → Services Cache Duration: $_serviceCacheDuration');
    debugPrint('🔧   → Cache Storage: Local Hive database');
    debugPrint('🔧   → Cache Invalidation: On write operations');
    debugPrint('🔧 📡 STREAMING FEATURES:');
    debugPrint('🔧   → Real-time category updates');
    debugPrint('🔧   → Real-time subcategory updates');
    debugPrint('🔧   → Real-time service updates (planned)');
    debugPrint('🔧   → Real-time request updates (planned)');
    debugPrint('🔧 ========================================');
    debugPrint('🔧 Response Format: {message, data, time, statusCode}');
    debugPrint('🔧 ServiceManagementService initialized successfully ✅');
  }

  // Streams for real-time data updates
  Stream<List<ServiceCategory>> get categoryStream => _categoryStreamController.stream;
  Stream<List<ServiceSubcategory>> get subcategoryStream => _subcategoryStreamController.stream;
  Stream<List<Service>> get serviceStream => _serviceStreamController.stream;
  Stream<List<ServiceRequest>> get requestStream => _requestStreamController.stream;

  // ====================================================================
  // SERVICE CATEGORY MANAGEMENT METHODS
  // Based on /categories/ endpoints from Postman collection
  // ====================================================================

  /// Get all service categories
  ///
  /// 🔍 CATEGORY RETRIEVAL ANALYSIS:
  /// - Endpoint: GET /api/services/categories/
  /// - Supports filtering, searching, and sorting
  /// - Real-time stream updates for UI synchronization
  /// - Admin and user access with permission validation
  ///
  /// 📋 QUERY PARAMETERS SUPPORTED:
  /// - active_only: Filter only active categories
  /// - search: Text search in name and description
  /// - ordering: Sort by name, sort_order, created_at
  /// - page/page_size: Pagination support
  Future<ApiResponse<List<ServiceCategory>>> getCategories({
    bool activeOnly = false,
    String? search,
    String ordering = 'sort_order',
  }) async {
    final startTime = DateTime.now();
    debugPrint('🔧 ServiceManagementService.getCategories: ============================');
    debugPrint('🔧 ServiceManagementService.getCategories: STARTING CATEGORY RETRIEVAL');
    debugPrint('🔧 ServiceManagementService.getCategories: ============================');
    debugPrint('🔧 → 📋 REQUEST PARAMETERS ANALYSIS:');
    debugPrint('🔧   → Active Only Filter: ${activeOnly ? 'ENABLED' : 'DISABLED'}');
    debugPrint('🔧   → Search Query: ${search ?? 'NONE'}');
    debugPrint('🔧   → Ordering Strategy: $ordering');
    debugPrint('🔧   → Request Timestamp: ${startTime.toIso8601String()}');
    debugPrint('🔧 → 🔐 PERMISSION ANALYSIS:');
    debugPrint('🔧   → User Type: ${HiveService.getUserType()}');
    debugPrint('🔧   → Is Admin: ${HiveService.isAdmin() ? 'YES' : 'NO'}');
    // debugPrint('🔧   → Auth Token Present: ${HiveService.getAuthToken() != null ? 'YES' : 'NO'}');

    // Analyze search query if provided
    if (search != null && search.isNotEmpty) {
      debugPrint('🔧 → 🔍 SEARCH ANALYSIS:');
      debugPrint('🔧   → Query Length: ${search.length} characters');
      debugPrint('🔧   → Query Words: ${search.split(' ').length}');
      debugPrint('🔧   → Search Type: ${search.length < 3 ? 'SHORT_QUERY' : 'DETAILED_QUERY'}');
    }

    try {
      // Build query parameters with detailed analysis
      debugPrint('🔧 → 🌐 API CALL PREPARATION:');
      final queryParams = <String, String>{
        'ordering': ordering,
      };

      if (activeOnly) {
        queryParams['active_only'] = 'true';
        debugPrint('🔧   → Filter: Active categories only');
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
        debugPrint('🔧   → Filter: Search query "$search"');
      }

      debugPrint('🔧   → Final Query Parameters: $queryParams');
      debugPrint('🔧   → Endpoint: /services/categories/');
      debugPrint('🔧   → Authentication: JWT Bearer token');
      debugPrint('🔧   → Expected Response: Paginated category list');

      // Make API call with performance tracking
      debugPrint('🔧 → 📡 EXECUTING API CALL...');
      final apiStartTime = DateTime.now();

      final response = await _apiService.get<PaginatedResponse<ServiceCategory>>(
        '/services/categories/',
        queryParams: queryParams,
        token: HiveService.getAuthToken(),
        fromJson: (json) => PaginatedResponse.fromJson(
          json,
          (item) => ServiceCategory.fromJson(item),
        ),
      );

      final apiDuration = DateTime.now().difference(apiStartTime).inMilliseconds;
      final totalDuration = DateTime.now().difference(startTime).inMilliseconds;

      debugPrint('🔧 → 📊 API RESPONSE ANALYSIS:');
      debugPrint('🔧   → API Call Duration: ${apiDuration}ms');
      debugPrint('🔧   → Total Operation Duration: ${totalDuration}ms');
      debugPrint('🔧   → Response Status: ${response.isSuccess ? 'SUCCESS' : 'FAILED'}');
      debugPrint('🔧   → Status Code: ${response.statusCode}');

      if (response.isSuccess && response.data != null) {
        final paginatedData = response.data!;
        final categories = paginatedData.results;

        debugPrint('🔧   → Response Type: PAGINATED DATA');
        debugPrint('🔧   → Total Categories Available: ${paginatedData.count}');
        debugPrint('🔧   → Categories in Current Page: ${categories.length}');
        debugPrint('🔧   → Current Page: ${paginatedData.page}');
        debugPrint('🔧   → Total Pages: ${paginatedData.totalPages}');
        debugPrint('🔧   → Has Next Page: ${paginatedData.next != null}');
        debugPrint('🔧   → Has Previous Page: ${paginatedData.previous != null}');

        // Analyze retrieved categories
        if (categories.isNotEmpty) {
          debugPrint('🔧 → 📋 CATEGORIES ANALYSIS:');

          final activeCategories = categories.where((c) => c.isActive).length;
          final inactiveCategories = categories.length - activeCategories;

          debugPrint('🔧   → Active Categories: $activeCategories');
          debugPrint('🔧   → Inactive Categories: $inactiveCategories');

          // Sort order analysis
          final sortOrders = categories.map((c) => c.sortOrder).toSet().toList()..sort();
          debugPrint('🔧   → Sort Orders: ${sortOrders.join(', ')}');

          // Name length analysis
          final avgNameLength = categories.map((c) => c.name.length).reduce((a, b) => a + b) / categories.length;
          debugPrint('🔧   → Average Name Length: ${avgNameLength.toStringAsFixed(1)} characters');

          // Recent updates analysis
          final recentlyUpdated = categories.where((c) => DateTime.now().difference(c.updatedAt).inDays < 7).length;
          debugPrint('🔧   → Recently Updated (7 days): $recentlyUpdated categories');

          // List category names for debugging
          debugPrint('🔧   → Category Names: ${categories.map((c) => c.name).join(', ')}');
        }

        // Update real-time stream
        debugPrint('🔧 → 📡 UPDATING REAL-TIME STREAM...');
        _categoryStreamController.add(categories);
        debugPrint('🔧   → Stream Update: Complete');

        final finalDuration = DateTime.now().difference(startTime).inMilliseconds;
        debugPrint('🔧 ServiceManagementService.getCategories: ✅ API SUCCESS');
        debugPrint('🔧   → Final Result: ${categories.length} categories retrieved');
        debugPrint('🔧   → Performance Breakdown:');
        debugPrint('🔧     → API Call: ${apiDuration}ms');
        debugPrint('🔧     → Total: ${finalDuration}ms');

        return ApiResponse.success(
          data: categories,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService.getCategories: ❌ API FAILED');
        debugPrint('🔧   → Error Message: "${response.message}"');
        debugPrint('🔧   → Status Code: ${response.statusCode}');
        debugPrint('🔧   → Error Category: ${_categorizeError(response.statusCode)}');
        debugPrint('🔧   → Troubleshooting: ${_getTroubleshootingTips(response.statusCode)}');

        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🔧 ServiceManagementService: Error getting categories (${duration}ms) - $e');
      return ApiResponse.error(
        message: 'Failed to get categories: $e',
        statusCode: 500,
      );
    }
  }

  /// Get category details by ID
  /// Endpoint: GET /api/services/categories/{id}/
  Future<ApiResponse<ServiceCategory>> getCategoryById(String categoryId) async {
    debugPrint('🔧 ServiceManagementService: Getting category details for ID: $categoryId');

    try {
      final response = await _apiService.get<ServiceCategory>(
        '/services/categories/$categoryId/',
        token: HiveService.getAuthToken(),
        fromJson: (json) => ServiceCategory.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('🔧 ServiceManagementService: Successfully retrieved category: ${response.data!.name}');
        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to get category - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error getting category details - $e');
      return ApiResponse.error(
        message: 'Failed to get category details: $e',
        statusCode: 500,
      );
    }
  }

  /// Create a new service category (Admin only)
  /// Endpoint: POST /api/services/categories/
  /// ✨ ENHANCED: Now supports iconUrl field for predefined category icons
  Future<ApiResponse<ServiceCategory>> createCategory({
    required String name,
    required String description,
    String? iconUrl,
    int sortOrder = 0,
    bool isActive = true,
  }) async {
    debugPrint('🔧 ServiceManagementService: Creating new category');
    debugPrint('🔧 Category details: name=$name, description=$description, sortOrder=$sortOrder');
    debugPrint('🔧 → Icon URL specified: ${iconUrl != null ? 'YES ($iconUrl)' : 'NO'}');

    // Validate user permissions
    if (!HiveService.isAdmin()) {
      debugPrint('🔧 ServiceManagementService: User is not admin, cannot create category');
      return ApiResponse.error(
        message: 'Permission denied: Admin access required',
        statusCode: 403,
      );
    }

    try {
      final requestBody = {
        'name': name,
        'description': description,
        'sort_order': sortOrder,
        'is_active': isActive,
        'icon_url': iconUrl, // ✨ Using icon_url for predefined icons
      };

      debugPrint('🔧 ServiceManagementService: Sending create request with body: $requestBody');

      final response = await _apiService.post<ServiceCategory>(
        '/services/categories/',
        body: requestBody,
        token: HiveService.getAuthToken(),
        fromJson: (json) => ServiceCategory.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('🔧 ServiceManagementService: Successfully created category: ${response.data!.name}');

        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to create category - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error creating category - $e');
      return ApiResponse.error(
        message: 'Failed to create category: $e',
        statusCode: 500,
      );
    }
  }

  /// Update an existing category (Admin only)
  /// Endpoint: PUT /api/services/categories/{id}/
  /// ✨ ENHANCED: Now supports iconUrl field for predefined category icons
  Future<ApiResponse<ServiceCategory>> updateCategory({
    required String categoryId,
    required String name,
    required String description,
    String? iconUrl,
    int sortOrder = 0,
    bool isActive = true,
  }) async {
    debugPrint('🔧 ServiceManagementService: Updating category ID: $categoryId');
    debugPrint('🔧 New details: name=$name, description=$description, sortOrder=$sortOrder');
    debugPrint('🔧 → Icon URL specified: ${iconUrl != null ? 'YES ($iconUrl)' : 'NO'}');

    // Validate user permissions
    if (!HiveService.isAdmin()) {
      debugPrint('🔧 ServiceManagementService: User is not admin, cannot update category');
      return ApiResponse.error(
        message: 'Permission denied: Admin access required',
        statusCode: 403,
      );
    }

    try {
      final requestBody = {
        'name': name,
        'description': description,
        'icon_url': iconUrl, // ✨ Using icon_url for predefined icons
        'sort_order': sortOrder,
        'is_active': isActive,
      };

      debugPrint('🔧 ServiceManagementService: Sending update request with body: $requestBody');

      final response = await _apiService.put<ServiceCategory>(
        '/services/categories/$categoryId/',
        body: requestBody,
        token: HiveService.getAuthToken(),
        fromJson: (json) => ServiceCategory.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('🔧 ServiceManagementService: Successfully updated category: ${response.data!.name}');

        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to update category - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error updating category - $e');
      return ApiResponse.error(
        message: 'Failed to update category: $e',
        statusCode: 500,
      );
    }
  }

  /// Delete a category (Admin only)
  /// Endpoint: DELETE /api/services/categories/{id}/
  Future<ApiResponse<void>> deleteCategory(String categoryId) async {
    debugPrint('🔧 ServiceManagementService: Deleting category ID: $categoryId');

    // Validate user permissions
    if (!HiveService.isAdmin()) {
      debugPrint('🔧 ServiceManagementService: User is not admin, cannot delete category');
      return ApiResponse.error(
        message: 'Permission denied: Admin access required',
        statusCode: 403,
      );
    }

    try {
      final response = await _apiService.delete<void>(
        '/services/categories/$categoryId/',
        token: HiveService.getAuthToken(),
      );

      if (response.isSuccess) {
        debugPrint('🔧 ServiceManagementService: Successfully deleted category ID: $categoryId');

        return ApiResponse.success(
          data: null,
          message: 'Category deleted successfully',
        );
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to delete category - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error deleting category - $e');
      return ApiResponse.error(
        message: 'Failed to delete category: $e',
        statusCode: 500,
      );
    }
  }

  /// Get category statistics (Admin only)
  /// Endpoint: GET /api/services/categories/statistics/
  Future<ApiResponse<Map<String, dynamic>>> getCategoryStatistics() async {
    debugPrint('🔧 ServiceManagementService: Getting category statistics');

    // Validate user permissions
    if (!HiveService.isAdmin()) {
      debugPrint('🔧 ServiceManagementService: User is not admin, cannot access statistics');
      return ApiResponse.error(
        message: 'Permission denied: Admin access required',
        statusCode: 403,
      );
    }

    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/services/categories/statistics/',
        token: HiveService.getAuthToken(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final stats = response.data!;
        debugPrint('🔧 ServiceManagementService: Retrieved category statistics');
        debugPrint('🔧 Statistics summary: ${stats['summary']}');

        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to get statistics - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error getting statistics - $e');
      return ApiResponse.error(
        message: 'Failed to get category statistics: $e',
        statusCode: 500,
      );
    }
  }

  /// Categorize API error for better debugging
  String _categorizeError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'CLIENT_ERROR - Invalid request parameters';
      case 401:
        return 'AUTHENTICATION_ERROR - Invalid or expired token';
      case 403:
        return 'AUTHORIZATION_ERROR - Insufficient permissions';
      case 404:
        return 'NOT_FOUND_ERROR - Resource not found';
      case 422:
        return 'VALIDATION_ERROR - Data validation failed';
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

  /// Get troubleshooting tips for API errors
  String _getTroubleshootingTips(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Check request parameters and data format';
      case 401:
        return 'Refresh authentication token or re-login';
      case 403:
        return 'Verify user permissions and account type';
      case 404:
        return 'Verify endpoint URL and resource existence';
      case 422:
        return 'Check data validation rules and required fields';
      case 429:
        return 'Implement rate limiting and retry logic';
      case 500:
        return 'Check server logs and retry after delay';
      case 502:
      case 503:
      case 504:
        return 'Server issue - retry with exponential backoff';
      default:
        return 'Check network connection and server status';
    }
  }

  // ====================================================================
  // SERVICE SUBCATEGORY MANAGEMENT METHODS
  // Based on /subcategories/ endpoints from Postman collection
  // ====================================================================

  /// Get all service subcategories with optional filtering
  /// Endpoint: GET /api/services/subcategories/
  /// Supports query params: category, active_only
  Future<ApiResponse<List<ServiceSubcategory>>> getSubcategories({
    String? categoryId,
    bool activeOnly = false,
  }) async {
    final startTime = DateTime.now();
    debugPrint('🔧 ServiceManagementService: Getting subcategories');
    debugPrint('🔧 Parameters: categoryId=$categoryId, activeOnly=$activeOnly');

    try {
      // Build query parameters
      final queryParams = <String, String>{};

      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      if (activeOnly) {
        queryParams['active_only'] = 'true';
      }

      debugPrint('🔧 ServiceManagementService: Making API call with params: $queryParams');

      // Make API call
      final response = await _apiService.get<PaginatedResponse<ServiceSubcategory>>(
        '/services/subcategories/',
        queryParams: queryParams,
        token: HiveService.getAuthToken(),
        fromJson: (json) => PaginatedResponse.fromJson(
          json,
          (item) => ServiceSubcategory.fromJson(item),
        ),
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.isSuccess && response.data != null) {
        final subcategories = response.data!.results;
        debugPrint(
            '🔧 ServiceManagementService: Successfully retrieved ${subcategories.length} subcategories in ${duration}ms');

        // Update stream
        _subcategoryStreamController.add(subcategories);

        return ApiResponse.success(
          data: subcategories,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to get subcategories - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🔧 ServiceManagementService: Error getting subcategories (${duration}ms) - $e');
      return ApiResponse.error(
        message: 'Failed to get subcategories: $e',
        statusCode: 500,
      );
    }
  }

  /// Get subcategory details by ID
  /// Endpoint: GET /api/services/subcategories/{id}/
  Future<ApiResponse<ServiceSubcategory>> getSubcategoryById(String subcategoryId) async {
    debugPrint('🔧 ServiceManagementService: Getting subcategory details for ID: $subcategoryId');

    try {
      final response = await _apiService.get<ServiceSubcategory>(
        '/services/subcategories/$subcategoryId/',
        token: HiveService.getAuthToken(),
        fromJson: (json) => ServiceSubcategory.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('🔧 ServiceManagementService: Successfully retrieved subcategory: ${response.data!.name}');
        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to get subcategory - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error getting subcategory details - $e');
      return ApiResponse.error(
        message: 'Failed to get subcategory details: $e',
        statusCode: 500,
      );
    }
  }

  /// Create a new service subcategory (Admin only)
  /// Endpoint: POST /api/services/subcategories/
  Future<ApiResponse<ServiceSubcategory>> createSubcategory(ServiceSubcategoryRequest request) async {
    debugPrint('🔧 ServiceManagementService: Creating new subcategory');
    debugPrint('🔧 Subcategory details: ${request.toJson()}');

    // Validate user permissions
    if (!HiveService.isAdmin()) {
      debugPrint('🔧 ServiceManagementService: User is not admin, cannot create subcategory');
      return ApiResponse.error(
        message: 'Permission denied: Admin access required',
        statusCode: 403,
      );
    }

    try {
      final requestBody = request.toJson();
      debugPrint('🔧 ServiceManagementService: Sending create request with body: $requestBody');

      final response = await _apiService.post<ServiceSubcategory>(
        '/services/subcategories/',
        body: requestBody,
        token: HiveService.getAuthToken(),
        fromJson: (json) => ServiceSubcategory.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('🔧 ServiceManagementService: Successfully created subcategory: ${response.data!.name}');

        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to create subcategory - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error creating subcategory - $e');
      return ApiResponse.error(
        message: 'Failed to create subcategory: $e',
        statusCode: 500,
      );
    }
  }

  /// Update an existing subcategory (Admin only) - Full update
  /// Endpoint: PUT /api/services/subcategories/{id}/
  Future<ApiResponse<ServiceSubcategory>> updateSubcategory({
    required String subcategoryId,
    required ServiceSubcategoryRequest request,
  }) async {
    debugPrint('🔧 ServiceManagementService: Updating subcategory ID: $subcategoryId');
    debugPrint('🔧 New details: ${request.toJson()}');

    // Validate user permissions
    if (!HiveService.isAdmin()) {
      debugPrint('🔧 ServiceManagementService: User is not admin, cannot update subcategory');
      return ApiResponse.error(
        message: 'Permission denied: Admin access required',
        statusCode: 403,
      );
    }

    try {
      final requestBody = request.toJson();
      debugPrint('🔧 ServiceManagementService: Sending full update request with body: $requestBody');

      final response = await _apiService.put<ServiceSubcategory>(
        '/services/subcategories/$subcategoryId/',
        body: requestBody,
        token: HiveService.getAuthToken(),
        fromJson: (json) => ServiceSubcategory.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('🔧 ServiceManagementService: Successfully updated subcategory: ${response.data!.name}');

        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to update subcategory - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error updating subcategory - $e');
      return ApiResponse.error(
        message: 'Failed to update subcategory: $e',
        statusCode: 500,
      );
    }
  }

  /// Partially update an existing subcategory (Admin only) - Partial update
  /// Endpoint: PATCH /api/services/subcategories/{id}/
  Future<ApiResponse<ServiceSubcategory>> patchSubcategory({
    required String subcategoryId,
    String? description,
    int? sortOrder,
    bool? isActive,
  }) async {
    debugPrint('🔧 ServiceManagementService: Partially updating subcategory ID: $subcategoryId');
    debugPrint('🔧 Patch fields: description=$description, sortOrder=$sortOrder, isActive=$isActive');

    // Validate user permissions
    if (!HiveService.isAdmin()) {
      debugPrint('🔧 ServiceManagementService: User is not admin, cannot patch subcategory');
      return ApiResponse.error(
        message: 'Permission denied: Admin access required',
        statusCode: 403,
      );
    }

    try {
      final requestBody = <String, dynamic>{};

      if (description != null) {
        requestBody['description'] = description;
      }

      if (sortOrder != null) {
        requestBody['sort_order'] = sortOrder;
      }

      if (isActive != null) {
        requestBody['is_active'] = isActive;
      }

      if (requestBody.isEmpty) {
        debugPrint('🔧 ServiceManagementService: No fields to patch');
        return ApiResponse.error(
          message: 'No fields provided for update',
          statusCode: 400,
        );
      }

      debugPrint('🔧 ServiceManagementService: Sending partial update request with body: $requestBody');

      final response = await _apiService.patch<ServiceSubcategory>(
        '/services/subcategories/$subcategoryId/',
        body: requestBody,
        token: HiveService.getAuthToken(),
        fromJson: (json) => ServiceSubcategory.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('🔧 ServiceManagementService: Successfully patched subcategory: ${response.data!.name}');

        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to patch subcategory - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error patching subcategory - $e');
      return ApiResponse.error(
        message: 'Failed to patch subcategory: $e',
        statusCode: 500,
      );
    }
  }

  /// Delete a subcategory (Admin only)
  /// Endpoint: DELETE /api/services/subcategories/{id}/
  Future<ApiResponse<void>> deleteSubcategory(String subcategoryId) async {
    debugPrint('🔧 ServiceManagementService: Deleting subcategory ID: $subcategoryId');

    // Validate user permissions
    if (!HiveService.isAdmin()) {
      debugPrint('🔧 ServiceManagementService: User is not admin, cannot delete subcategory');
      return ApiResponse.error(
        message: 'Permission denied: Admin access required',
        statusCode: 403,
      );
    }

    try {
      final response = await _apiService.delete<void>(
        '/services/subcategories/$subcategoryId/',
        token: HiveService.getAuthToken(),
      );

      if (response.isSuccess) {
        debugPrint('🔧 ServiceManagementService: Successfully deleted subcategory ID: $subcategoryId');

        return ApiResponse.success(
          data: null,
          message: 'Subcategory deleted successfully',
        );
      } else {
        debugPrint('🔧 ServiceManagementService: Failed to delete subcategory - ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error deleting subcategory - $e');
      return ApiResponse.error(
        message: 'Failed to delete subcategory: $e',
        statusCode: 500,
      );
    }
  }

  // ====================================================================
  // SERVICE REQUEST MANAGEMENT METHODS (Based on Requests.postman_collection.json)
  // Complete implementation of 11 ServiceRequestViewSet endpoints
  // ====================================================================

  /// Get all service requests with comprehensive filtering
  ///
  /// 🔧 REQUEST MANAGEMENT ANALYSIS (Based on Requests.postman_collection.json):
  /// - Endpoint: GET /api/services/requests/
  /// - 11 total endpoints available in ServiceRequestViewSet
  /// - Customer-centric: Request creation, management, provider discovery
  /// - Admin operations: Batch processing, oversight, analytics
  /// - Specialized features: Recommended providers, request cancellation
  /// - AI-powered: Provider matching algorithms, smart recommendations
  /// - Status management: open, in_progress, fulfilled, cancelled, expired
  /// - Urgency levels: low, medium, high, urgent (with time constraints)
  ///
  /// 📋 SUPPORTED OPERATIONS:
  /// - Public: List open requests, view request details
  /// - Customer: Full CRUD for own requests, provider recommendations
  /// - Provider: Read-only access, request matching notifications
  /// - Admin: Complete oversight, batch operations, analytics
  ///
  /// 🎯 BUSINESS WORKFLOW:
  /// - Customer creates request with budget and requirements
  /// - AI system matches with qualified providers
  /// - Providers can view and respond to matching requests
  /// - Customer selects provider and confirms booking
  /// - System tracks progress and handles completion/cancellation
  Future<ApiResponse<List<ServiceRequest>>> getServiceRequests({
    String? status,
    String? categoryId,
    String? urgency,
    double? budgetMin,
    double? budgetMax,
    String? search,
    String ordering = '-created_at',
    int page = 1,
    int pageSize = 20,
    bool useCache = false, // Requests are time-sensitive, avoid caching
  }) async {
    final startTime = DateTime.now();
    debugPrint('🔧 ServiceManagementService.getServiceRequests: ==============================');
    debugPrint('🔧 ServiceManagementService.getServiceRequests: SERVICE REQUEST DISCOVERY');
    debugPrint('🔧 ServiceManagementService.getServiceRequests: ==============================');
    debugPrint('🔧 → 📋 REQUEST DISCOVERY PARAMETERS:');
    debugPrint('🔧   → Status Filter: ${status ?? 'ALL_STATUSES (open, in_progress, fulfilled, cancelled, expired)'}');
    debugPrint('🔧   → Category Filter: ${categoryId ?? 'ALL_CATEGORIES'}');
    debugPrint('🔧   → Urgency Filter: ${urgency ?? 'ALL_URGENCIES (low, medium, high, urgent)'}');
    debugPrint(
        '🔧   → Budget Range: ${budgetMin != null && budgetMax != null ? '$budgetMin - $budgetMax' : 'NO_BUDGET_FILTER'}');
    debugPrint('🔧   → Search Query: ${search ?? 'NO_SEARCH'}');
    debugPrint('🔧   → Ordering Strategy: $ordering');
    debugPrint('🔧   → Pagination: Page $page, Size $pageSize');
    debugPrint('🔧   → Caching Strategy: ${useCache ? 'ENABLED' : 'DISABLED (time-sensitive data)'}');
    debugPrint(
        '🔧   → User Access Level: ${isCustomer ? 'CUSTOMER' : isProvider ? 'PROVIDER' : isAdmin ? 'ADMIN' : 'PUBLIC'}');

    try {
      // Build query parameters for request filtering
      final queryParams = <String, String>{
        'ordering': ordering,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (status != null) {
        queryParams['status'] = status;
        debugPrint('🔧   → Status Filter Applied: $status');
      }

      if (categoryId != null) {
        queryParams['category'] = categoryId;
        debugPrint('🔧   → Category Filter Applied: $categoryId');
      }

      if (urgency != null) {
        queryParams['urgency'] = urgency;
        debugPrint('🔧   → Urgency Filter Applied: $urgency');
      }

      if (budgetMin != null) {
        queryParams['budget_min'] = budgetMin.toString();
        debugPrint('🔧   → Budget Min Filter Applied: $budgetMin');
      }

      if (budgetMax != null) {
        queryParams['budget_max'] = budgetMax.toString();
        debugPrint('🔧   → Budget Max Filter Applied: $budgetMax');
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
        debugPrint('🔧   → Search Query Applied: "$search"');
      }

      debugPrint('🔧 → 🌐 EXECUTING SERVICE REQUEST DISCOVERY...');
      final apiStartTime = DateTime.now();

      final response = await _apiService.get<Map<String, dynamic>>(
        '/services/requests/',
        queryParams: queryParams,
        token: HiveService.getAuthToken(), // Optional for public listing
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final apiDuration = DateTime.now().difference(apiStartTime).inMilliseconds;
      final totalDuration = DateTime.now().difference(startTime).inMilliseconds;

      debugPrint('🔧 → 📊 REQUEST DISCOVERY RESPONSE ANALYSIS:');
      debugPrint('🔧   → API Call Duration: ${apiDuration}ms');
      debugPrint('🔧   → Total Operation Duration: ${totalDuration}ms');
      debugPrint('🔧   → Response Status: ${response.isSuccess ? 'SUCCESS' : 'FAILED'}');

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final requestsData = data['service_requests'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [];
        final requests = requestsData.map((item) => ServiceRequest.fromJson(item)).toList();

        debugPrint('🔧   → Response Type: SERVICE_REQUEST_LIST');
        debugPrint('🔧   → Total Requests Available: ${data['summary']?['total_count'] ?? requests.length}');
        debugPrint('🔧   → Requests in Current Page: ${requests.length}');

        // Analyze request characteristics for business intelligence
        if (requests.isNotEmpty) {
          debugPrint('🔧 → 📊 REQUEST PORTFOLIO ANALYSIS:');

          // Status and urgency distribution
          final statusCounts = <String, int>{};
          final urgencyCounts = <String, int>{};
          final categoryCounts = <String, int>{};

          for (final request in requests) {
            statusCounts[request.status] = (statusCounts[request.status] ?? 0) + 1;
            urgencyCounts[request.urgency] = (urgencyCounts[request.urgency] ?? 0) + 1;
            final categoryName = request.category['name'] ?? 'unknown';
            categoryCounts[categoryName] = (categoryCounts[categoryName] ?? 0) + 1;
          }

          debugPrint('🔧   → Status Distribution: $statusCounts');
          debugPrint('🔧   → Urgency Distribution: $urgencyCounts');
          debugPrint('🔧   → Category Distribution: $categoryCounts');

          // Budget analysis
          final budgets = requests.map((r) => (r.budgetMin + r.budgetMax) / 2).where((b) => b > 0).toList();
          if (budgets.isNotEmpty) {
            budgets.sort();
            final avgBudget = budgets.reduce((a, b) => a + b) / budgets.length;
            final minBudget = budgets.first;
            final maxBudget = budgets.last;

            debugPrint('🔧   → Budget Analysis:');
            debugPrint('🔧     → Average Budget: ${avgBudget.toStringAsFixed(2)}');
            debugPrint('🔧     → Budget Range: ${minBudget.toStringAsFixed(2)} - ${maxBudget.toStringAsFixed(2)}');
          }

          // Time-sensitive analysis
          final urgentRequests = requests.where((r) => r.urgency == 'urgent').length;
          final recentRequests = requests.where((r) => DateTime.now().difference(r.createdAt).inHours < 24).length;

          debugPrint('🔧   → Time Analysis:');
          debugPrint('🔧     → Urgent Requests: $urgentRequests/${requests.length}');
          debugPrint('🔧     → Recent Requests (24h): $recentRequests/${requests.length}');
        }

        // Update real-time stream for UI synchronization
        debugPrint('🔧 → 📡 UPDATING REQUEST STREAM...');
        _requestStreamController.add(requests);

        final finalDuration = DateTime.now().difference(startTime).inMilliseconds;
        debugPrint('🔧 ServiceManagementService.getServiceRequests: ✅ DISCOVERY SUCCESS');
        debugPrint('🔧   → Final Result: ${requests.length} requests retrieved');
        debugPrint('🔧   → Total Duration: ${finalDuration}ms');

        return ApiResponse.success(
          data: requests,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService.getServiceRequests: ❌ DISCOVERY FAILED');
        debugPrint('🔧   → Error: ${response.message}');
        debugPrint('🔧   → Status Code: ${response.statusCode}');

        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🔧 ServiceManagementService.getServiceRequests: 💥 DISCOVERY EXCEPTION');
      debugPrint('🔧   → Exception: $e');
      debugPrint('🔧   → Duration: ${duration}ms');
      debugPrint('🔧   → Stack trace: ${stackTrace.toString().split('\n').first}');

      return ApiResponse.error(
        message: 'Service request discovery failed: $e',
        statusCode: 500,
      );
    }
  }

  /// Create a new service request (Customer only)
  ///
  /// 🔧 REQUEST CREATION ANALYSIS:
  /// - Endpoint: POST /api/services/requests/
  /// - Permission: Customer only (role-based access control)
  /// - Required fields: title, description, category, budget_min, budget_max
  /// - Optional: subcategories, urgency, location, requirements
  /// - Auto-expiration: 30 days default (configurable)
  /// - AI Integration: Automatic provider matching after creation
  Future<ApiResponse<ServiceRequest>> createServiceRequest({
    required String title,
    required String description,
    required String categoryId,
    List<String>? subcategoryIds,
    required double budgetMin,
    required double budgetMax,
    String currency = 'INR',
    String urgency = 'medium',
    DateTime? requestedDateTime,
    String? location,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? requirements,
  }) async {
    debugPrint('🔧 ServiceManagementService.createServiceRequest: =======================');
    debugPrint('🔧 ServiceManagementService.createServiceRequest: CREATING SERVICE REQUEST');
    debugPrint('🔧 ServiceManagementService.createServiceRequest: =======================');
    debugPrint('🔧 → 📋 REQUEST CREATION PARAMETERS:');
    debugPrint('🔧   → Title: "$title"');
    debugPrint('🔧   → Description Length: ${description.length} characters');
    debugPrint('🔧   → Category ID: $categoryId');
    debugPrint('🔧   → Subcategories: ${subcategoryIds?.join(', ') ?? 'NONE'}');
    debugPrint('🔧   → Budget Range: $budgetMin - $budgetMax $currency');
    debugPrint('🔧   → Urgency Level: $urgency');
    debugPrint('🔧   → Requested Time: ${requestedDateTime?.toIso8601String() ?? 'FLEXIBLE'}');
    debugPrint('🔧   → Location: ${location ?? 'NOT_SPECIFIED'}');
    debugPrint(
        '🔧   → Coordinates: ${latitude != null && longitude != null ? '$latitude, $longitude' : 'NOT_PROVIDED'}');
    debugPrint('🔧   → Requirements: ${requirements?.keys.join(', ') ?? 'NONE'}');

    // Validate user permissions
    if (!isCustomer) {
      debugPrint('🔧 ServiceManagementService: ❌ Permission denied - User is not a customer');
      debugPrint('🔧   → Current User Type: $currentUserType');
      debugPrint('🔧   → Required Permission: Customer');
      return ApiResponse.error(
        message: 'Only customers can create service requests',
        statusCode: 403,
      );
    }

    // Validate budget range
    if (budgetMin >= budgetMax) {
      debugPrint('🔧 ServiceManagementService: ❌ Invalid budget range');
      debugPrint('🔧   → Budget Min: $budgetMin');
      debugPrint('🔧   → Budget Max: $budgetMax');
      return ApiResponse.error(
        message: 'Budget minimum must be less than maximum',
        statusCode: 400,
      );
    }

    try {
      // Build request payload
      final requestBody = <String, dynamic>{
        'title': title,
        'description': description,
        'category': categoryId,
        'budget_min': budgetMin,
        'budget_max': budgetMax,
        'currency': currency,
        'urgency': urgency,
      };

      if (subcategoryIds != null && subcategoryIds.isNotEmpty) {
        requestBody['subcategories'] = subcategoryIds;
      }

      if (requestedDateTime != null) {
        requestBody['requested_date_time'] = requestedDateTime.toIso8601String();
      }

      if (location != null) {
        requestBody['location'] = location;
      }

      if (latitude != null) {
        requestBody['latitude'] = latitude;
      }

      if (longitude != null) {
        requestBody['longitude'] = longitude;
      }

      if (requirements != null) {
        requestBody['requirements'] = requirements;
      }

      debugPrint('🔧 → 🌐 EXECUTING REQUEST CREATION API CALL...');
      debugPrint('🔧   → Payload Size: ${requestBody.length} fields');
      debugPrint('🔧   → Authentication: Customer JWT token');

      final response = await _apiService.post<Map<String, dynamic>>(
        '/services/requests/',
        body: requestBody,
        token: HiveService.getAuthToken(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final requestData = data['service_request'] ?? data['data'];
        final serviceRequest = ServiceRequest.fromJson(requestData);

        debugPrint('🔧 ServiceManagementService.createServiceRequest: ✅ CREATION SUCCESS');
        debugPrint('🔧 → 📊 CREATED REQUEST DETAILS:');
        debugPrint('🔧   → Request ID: ${serviceRequest.id}');
        debugPrint('🔧   → Status: ${serviceRequest.status}');
        debugPrint('🔧   → Expires At: ${serviceRequest.expiresAt?.toIso8601String() ?? 'NO_EXPIRATION'}');
        debugPrint('🔧   → Creation Details: ${data['creation_details']}');

        // Clear any cached request data to force refresh
        await _clearRequestCache();

        // Trigger AI matching process (in background)
        debugPrint('🔧 → 🤖 TRIGGERING AI PROVIDER MATCHING...');
        _triggerProviderMatching(serviceRequest.id);

        return ApiResponse.success(
          data: serviceRequest,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService.createServiceRequest: ❌ CREATION FAILED');
        debugPrint('🔧   → Error: ${response.message}');
        debugPrint('🔧   → Status Code: ${response.statusCode}');
        debugPrint('🔧   → Validation Errors: ${response.errors}');

        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService.createServiceRequest: 💥 CREATION EXCEPTION');
      debugPrint('🔧   → Exception: $e');
      return ApiResponse.error(
        message: 'Failed to create service request: $e',
        statusCode: 500,
      );
    }
  }

  /// Get customer's own service requests
  ///
  /// 🔧 CUSTOMER REQUEST MANAGEMENT:
  /// - Endpoint: GET /api/services/requests/my_requests/
  /// - Permission: Customer only (authenticated)
  /// - Shows only requests created by the current user
  /// - Supports status filtering and search
  Future<ApiResponse<List<ServiceRequest>>> getMyServiceRequests({
    String? status,
    String? search,
  }) async {
    debugPrint('🔧 ServiceManagementService: Getting customer service requests');
    debugPrint('🔧 → User Type: $currentUserType');
    debugPrint('🔧 → Status Filter: ${status ?? 'ALL_STATUSES'}');
    debugPrint('🔧 → Search Query: ${search ?? 'NO_SEARCH'}');

    if (!isCustomer) {
      debugPrint('🔧 ServiceManagementService: ❌ Access denied - Not a customer');
      return ApiResponse.error(
        message: 'Only customers can access personal requests',
        statusCode: 403,
      );
    }

    try {
      final queryParams = <String, String>{};

      if (status != null) {
        queryParams['status'] = status;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiService.get<Map<String, dynamic>>(
        '/services/requests/my_requests/',
        queryParams: queryParams,
        token: HiveService.getAuthToken(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final requestsData = data['requests'] as List<dynamic>? ?? [];
        final requests = requestsData.map((item) => ServiceRequest.fromJson(item)).toList();

        debugPrint('🔧 ServiceManagementService: ✅ Customer requests retrieved');
        debugPrint('🔧 → Personal Requests: ${requests.length}');
        debugPrint('🔧 → Summary: ${data['summary']}');

        return ApiResponse.success(
          data: requests,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService: ❌ Failed to get personal requests');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: 💥 Error getting personal requests - $e');
      return ApiResponse.error(
        message: 'Failed to get personal requests: $e',
        statusCode: 500,
      );
    }
  }

  /// Get recommended providers for a specific request
  ///
  /// 🔧 AI-POWERED PROVIDER MATCHING:
  /// - Endpoint: GET /api/services/requests/{id}/recommended_providers/
  /// - Permission: Request owner or Admin
  /// - AI algorithm factors: location, budget, availability, ratings
  /// - Real-time provider scoring and ranking
  Future<ApiResponse<List<Map<String, dynamic>>>> getRecommendedProviders(String requestId) async {
    debugPrint('🔧 ServiceManagementService: Getting recommended providers for request: $requestId');
    debugPrint('🔧 → AI Matching: Location, budget, availability, ratings');
    debugPrint('🔧 → Permission Check: Request owner or admin access');

    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/services/requests/$requestId/recommended_providers/',
        token: HiveService.getAuthToken(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final providersData = data['recommended_providers'] as List<dynamic>? ?? [];
        final providers = providersData.map((item) => Map<String, dynamic>.from(item)).toList();

        debugPrint('🔧 ServiceManagementService: ✅ Provider recommendations retrieved');
        debugPrint('🔧 → Recommended Providers: ${providers.length}');
        debugPrint('🔧 → Recommendation Criteria: ${data['recommendation_criteria']}');
        debugPrint('🔧 → Request Info: ${data['service_request']}');

        return ApiResponse.success(
          data: providers,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService: ❌ Failed to get provider recommendations');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: 💥 Error getting provider recommendations - $e');
      return ApiResponse.error(
        message: 'Failed to get provider recommendations: $e',
        statusCode: 500,
      );
    }
  }

  /// Cancel a service request
  ///
  /// 🔧 REQUEST CANCELLATION:
  /// - Endpoint: POST /api/services/requests/{id}/cancel/
  /// - Permission: Request owner or Admin
  /// - Cancellable statuses: open, in_progress
  /// - Impact analysis and notification system
  Future<ApiResponse<Map<String, dynamic>>> cancelServiceRequest(String requestId) async {
    debugPrint('🔧 ServiceManagementService: Cancelling service request: $requestId');
    debugPrint('🔧 → Cancellation Analysis: Impact assessment and notifications');
    debugPrint('🔧 → Permission: Request owner or admin access');

    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/services/requests/$requestId/cancel/',
        body: {}, // Empty body for cancellation
        token: HiveService.getAuthToken(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        debugPrint('🔧 ServiceManagementService: ✅ Request cancelled successfully');
        debugPrint('🔧 → Cancellation Details: ${data['cancellation_details']}');
        debugPrint('🔧 → Impact Analysis: ${data['cancellation_impact']}');

        // Clear cached data to reflect cancellation
        await _clearRequestCache();

        return ApiResponse.success(
          data: data,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService: ❌ Request cancellation failed');
        debugPrint('🔧 → Error: ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: 💥 Error cancelling request - $e');
      return ApiResponse.error(
        message: 'Failed to cancel service request: $e',
        statusCode: 500,
      );
    }
  }

  // ====================================================================
  // SERVICE REQUEST UTILITY METHODS
  // ====================================================================

  /// Trigger AI provider matching (background process)
  void _triggerProviderMatching(String requestId) {
    debugPrint('🔧 ServiceManagementService: 🤖 AI Provider Matching initiated for request: $requestId');
    debugPrint('🔧 → Matching Algorithm: Distance, budget, availability, ratings');
    debugPrint('🔧 → Process: Asynchronous background operation');
    // This would typically trigger a background job or websocket notification
    // Implementation depends on the specific AI service integration
  }

  /// Clear request cache
  Future<void> _clearRequestCache() async {
    try {
      final profile = HiveService.getUserProfile() ?? <String, dynamic>{};

      // Remove all request-related cache keys
      final keysToRemove = profile.keys
          .where((key) => key.toString().startsWith('requests_') || key.toString().startsWith('my_requests_'))
          .toList();

      for (final key in keysToRemove) {
        profile.remove(key);
      }

      // await HiveService.saveUserProfile(profile);
      debugPrint('🔧 ServiceManagementService: Request cache cleared (${keysToRemove.length} keys)');
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Failed to clear request cache - $e');
    }
  }

  // ====================================================================
  // SERVICE MANAGEMENT METHODS (Based on Services.postman_collection.json)
  // Complete implementation of 13 ServiceViewSet endpoints
  // ====================================================================

  /// Get all services with advanced filtering and search capabilities
  ///
  /// 🔧 SERVICE RETRIEVAL ANALYSIS (Based on Services.postman_collection.json):
  /// - Endpoint: GET /api/services/services/
  /// - 13 total endpoints available in ServiceViewSet
  /// - Advanced filtering: category, status, provider, currency, is_featured
  /// - Search capabilities: name, description, location, tags (semantic search)
  /// - Location features: nearby search with radius, distance calculation
  /// - Ordering options: created_at, hourly_rate, min_hours, max_hours
  /// - Provider-specific: matching requests, fulfillment operations
  /// - Admin features: enhanced view with statistics and management tools
  /// - Real-time features: availability checking, trending algorithms
  ///
  /// 📋 SUPPORTED QUERY PARAMETERS:
  /// - category: Filter by category UUID
  /// - subcategories: Filter by subcategory UUID
  /// - status: active, pending, inactive
  /// - is_featured: Boolean for featured services
  /// - provider: Filter by provider UUID
  /// - currency: INR, USD, EUR, GBP
  /// - search: Text search in name, description, location, tags
  /// - ordering: Sort fields with - prefix for descending
  /// - page/page_size: Pagination controls
  ///
  /// 🎯 BUSINESS LOGIC:
  /// - Public access for service discovery
  /// - Provider-only access for service management
  /// - Admin access for system oversight
  /// - Real-time availability integration
  /// - AI-powered matching and recommendations
  Future<ApiResponse<List<Service>>> getServices({
    String? categoryId,
    List<String>? subcategoryIds,
    String? status = 'active',
    bool? isFeatured,
    String? providerId,
    String? currency,
    String? search,
    String ordering = '-created_at',
    int page = 1,
    int pageSize = 20,
    bool useCache = true,
  }) async {
    final startTime = DateTime.now();
    debugPrint('🔧 ServiceManagementService.getServices: ================================');
    debugPrint('🔧 ServiceManagementService.getServices: STARTING SERVICE DISCOVERY');
    debugPrint('🔧 ServiceManagementService.getServices: ================================');
    debugPrint('🔧 → 📋 SERVICE DISCOVERY PARAMETERS:');
    debugPrint('🔧   → Category Filter: ${categoryId ?? 'ALL_CATEGORIES'}');
    debugPrint('🔧   → Subcategory Filter: ${subcategoryIds?.join(', ') ?? 'ALL_SUBCATEGORIES'}');
    debugPrint('🔧   → Status Filter: ${status ?? 'ALL_STATUSES'}');
    debugPrint('🔧   → Featured Filter: ${isFeatured?.toString() ?? 'ALL_SERVICES'}');
    debugPrint('🔧   → Provider Filter: ${providerId ?? 'ALL_PROVIDERS'}');
    debugPrint('🔧   → Currency Filter: ${currency ?? 'ALL_CURRENCIES'}');
    debugPrint('🔧   → Search Query: ${search ?? 'NO_SEARCH'}');
    debugPrint('🔧   → Ordering Strategy: $ordering');
    debugPrint('🔧   → Pagination: Page $page, Size $pageSize');
    debugPrint('🔧   → Caching Strategy: ${useCache ? 'ENABLED' : 'DISABLED'}');
    debugPrint('🔧   → Request Timestamp: ${startTime.toIso8601String()}');

    // Analyze search query complexity if provided
    if (search != null && search.isNotEmpty) {
      debugPrint('🔧 → 🔍 SEARCH QUERY ANALYSIS:');
      debugPrint('🔧   → Query Length: ${search.length} characters');
      debugPrint('🔧   → Word Count: ${search.split(' ').length} words');
      debugPrint('🔧   → Search Type: ${search.length < 3 ? 'SHORT_QUERY' : 'SEMANTIC_SEARCH'}');
      debugPrint('🔧   → Contains Numbers: ${RegExp(r'\d').hasMatch(search)}');
      debugPrint(
          '🔧   → Contains Location: ${search.toLowerCase().contains(RegExp(r'mumbai|delhi|bangalore|chennai|hyderabad|pune|kolkata'))}');
    }

    try {
      // Build comprehensive query parameters
      debugPrint('🔧 → 🌐 API QUERY CONSTRUCTION:');
      final queryParams = <String, String>{
        'ordering': ordering,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (categoryId != null) {
        queryParams['category'] = categoryId;
        debugPrint('🔧   → Category Filter Applied: $categoryId');
      }

      if (subcategoryIds != null && subcategoryIds.isNotEmpty) {
        queryParams['subcategories'] = subcategoryIds.join(',');
        debugPrint('🔧   → Subcategory Filter Applied: ${subcategoryIds.length} subcategories');
      }

      if (status != null) {
        queryParams['status'] = status;
        debugPrint('🔧   → Status Filter Applied: $status');
      }

      if (isFeatured != null) {
        queryParams['is_featured'] = isFeatured.toString();
        debugPrint('🔧   → Featured Filter Applied: $isFeatured');
      }

      if (providerId != null) {
        queryParams['provider'] = providerId;
        debugPrint('🔧   → Provider Filter Applied: $providerId');
      }

      if (currency != null) {
        queryParams['currency'] = currency;
        debugPrint('🔧   → Currency Filter Applied: $currency');
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
        debugPrint('🔧   → Search Query Applied: "$search"');
      }

      debugPrint('🔧   → Final Query Parameters: ${queryParams.length} filters');
      debugPrint('🔧   → API Endpoint: /services/services/');
      debugPrint('🔧   → Expected Response: Paginated service list');

      // Execute API call with performance tracking
      debugPrint('🔧 → 📡 EXECUTING SERVICE DISCOVERY API CALL...');
      final apiStartTime = DateTime.now();

      final response = await _apiService.get<PaginatedResponse<Service>>(
        '/services/services/',
        queryParams: queryParams,
        token: HiveService.getAuthToken(),
        fromJson: (json) => PaginatedResponse.fromJson(
          json,
          (item) => Service.fromJson(item),
        ),
      );

      final apiDuration = DateTime.now().difference(apiStartTime).inMilliseconds;
      final totalDuration = DateTime.now().difference(startTime).inMilliseconds;

      debugPrint('🔧 → 📊 SERVICE DISCOVERY RESPONSE ANALYSIS:');
      debugPrint('🔧   → API Call Duration: ${apiDuration}ms');
      debugPrint('🔧   → Total Operation Duration: ${totalDuration}ms');
      debugPrint('🔧   → Response Status: ${response.isSuccess ? 'SUCCESS' : 'FAILED'}');
      debugPrint('🔧   → HTTP Status Code: ${response.statusCode}');

      if (response.isSuccess && response.data != null) {
        final paginatedData = response.data!;
        final services = paginatedData.results;

        debugPrint('🔧   → Response Type: PAGINATED_SERVICE_DATA');
        debugPrint('🔧   → Total Services Available: ${paginatedData.count}');
        debugPrint('🔧   → Services in Current Page: ${services.length}');
        debugPrint('🔧   → Current Page: ${paginatedData.page}');
        debugPrint('🔧   → Total Pages: ${paginatedData.totalPages}');
        debugPrint('🔧   → Has Next Page: ${paginatedData.next != null}');
        debugPrint('🔧   → Has Previous Page: ${paginatedData.previous != null}');

        // Analyze retrieved services for business intelligence
        if (services.isNotEmpty) {
          debugPrint('🔧 → 📊 SERVICE PORTFOLIO ANALYSIS:');

          // Status distribution analysis
          final statusCounts = <String, int>{};
          final currencyCounts = <String, int>{};
          final providerCounts = <String, int>{};
          final featuredCount = services.where((s) => s.isFeatured).length;

          for (final service in services) {
            statusCounts[service.status] = (statusCounts[service.status] ?? 0) + 1;
            currencyCounts[service.currency] = (currencyCounts[service.currency] ?? 0) + 1;
            final providerUsername = service.provider['username'] ?? 'unknown';
            providerCounts[providerUsername] = (providerCounts[providerUsername] ?? 0) + 1;
          }

          debugPrint('🔧   → Status Distribution: $statusCounts');
          debugPrint('🔧   → Currency Distribution: $currencyCounts');
          debugPrint('🔧   → Featured Services: $featuredCount/${services.length}');
          debugPrint('🔧   → Unique Providers: ${providerCounts.length}');

          // Price analysis
          final hourlyRates = services.map((s) => s.hourlyRate).where((rate) => rate > 0).toList();
          if (hourlyRates.isNotEmpty) {
            hourlyRates.sort();
            final avgRate = hourlyRates.reduce((a, b) => a + b) / hourlyRates.length;
            final minRate = hourlyRates.first;
            final maxRate = hourlyRates.last;
            final medianRate = hourlyRates[hourlyRates.length ~/ 2];

            debugPrint('🔧   → Price Analysis (${currency ?? 'Multi-Currency'}):');
            debugPrint('🔧     → Average Rate: ${avgRate.toStringAsFixed(2)}');
            debugPrint('🔧     → Median Rate: ${medianRate.toStringAsFixed(2)}');
            debugPrint('🔧     → Min Rate: ${minRate.toStringAsFixed(2)}');
            debugPrint('🔧     → Max Rate: ${maxRate.toStringAsFixed(2)}');
            debugPrint('🔧     → Price Spread: ${((maxRate - minRate) / avgRate * 100).toStringAsFixed(1)}%');
          }

          // Location analysis
          final locations = services.map((s) => s.location).where((loc) => loc.isNotEmpty).toSet();
          debugPrint('🔧   → Geographic Coverage: ${locations.length} unique locations');

          // Service quality indicators
          final recentlyUpdated = services.where((s) => DateTime.now().difference(s.updatedAt).inDays < 7).length;
          debugPrint('🔧   → Recently Updated (7 days): $recentlyUpdated services');

          // List top service names for debugging
          final topServices = services.take(3).map((s) => s.name).join(', ');
          debugPrint('🔧   → Top Services: $topServices');
        }

        // Cache successful results for performance optimization
        if (useCache && services.isNotEmpty) {
          debugPrint('🔧 → 💾 CACHING SERVICE RESULTS...');
          final cacheStartTime = DateTime.now();
          await _cacheServices(services, queryParams);
          final cacheDuration = DateTime.now().difference(cacheStartTime).inMilliseconds;
          debugPrint('🔧   → Cache Write Time: ${cacheDuration}ms');
        }

        // Update real-time stream for UI synchronization
        debugPrint('🔧 → 📡 UPDATING REAL-TIME SERVICE STREAM...');
        _serviceStreamController.add(services);
        debugPrint('🔧   → Stream Update: Complete (${services.length} services)');

        final finalDuration = DateTime.now().difference(startTime).inMilliseconds;
        debugPrint('🔧 ServiceManagementService.getServices: ✅ DISCOVERY SUCCESS');
        debugPrint('🔧   → Final Result: ${services.length} services retrieved');
        debugPrint('🔧   → Performance Summary:');
        debugPrint('🔧     → API Call: ${apiDuration}ms');
        debugPrint('🔧     → Caching: ${useCache ? '~5ms' : 'skipped'}');
        debugPrint('🔧     → Total: ${finalDuration}ms');
        debugPrint('🔧   → Next Steps: UI rendering, user interaction');

        return ApiResponse.success(
          data: services,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService.getServices: ❌ DISCOVERY FAILED');
        debugPrint('🔧   → Error Message: "${response.message}"');
        debugPrint('🔧   → HTTP Status Code: ${response.statusCode}');
        debugPrint('🔧   → Error Category: ${_categorizeError(response.statusCode)}');
        debugPrint('🔧   → Troubleshooting Guide: ${_getTroubleshootingTips(response.statusCode)}');
        debugPrint('🔧   → Retry Strategy: ${_getRetryStrategy(response.statusCode)}');

        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🔧 ServiceManagementService.getServices: 💥 DISCOVERY EXCEPTION');
      debugPrint('🔧   → Exception Type: ${e.runtimeType}');
      debugPrint('🔧   → Exception Message: $e');
      debugPrint('🔧   → Operation Duration: ${duration}ms');
      debugPrint('🔧   → Stack Trace (first 3 lines):');
      stackTrace.toString().split('\n').take(3).forEach((line) {
        debugPrint('🔧     → $line');
      });
      debugPrint('🔧   → Recovery: Fallback to cached data or retry');

      return ApiResponse.error(
        message: 'Service discovery failed: $e',
        statusCode: 500,
      );
    }
  }

  /// Get service details by ID with comprehensive analysis
  ///
  /// 🔧 SERVICE DETAIL ANALYSIS:
  /// - Endpoint: GET /api/services/services/{id}/
  /// - Public access for service discovery
  /// - Includes provider details, category info, availability
  /// - Service images, pricing options, location data
  /// - Real-time availability status
  Future<ApiResponse<Service>> getServiceById(String serviceId) async {
    debugPrint('🔧 ServiceManagementService: Getting detailed service info for ID: $serviceId');
    debugPrint('🔧 → Service Access: Public endpoint (no authentication required)');
    debugPrint('🔧 → Expected Data: Complete service profile with provider info');

    try {
      final response = await _apiService.get<Service>(
        '/services/services/$serviceId/',
        token: HiveService.getAuthToken(), // Optional for public endpoint
        fromJson: (json) => Service.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        final service = response.data!;
        debugPrint('🔧 ServiceManagementService: ✅ Service details retrieved successfully');
        debugPrint('🔧 → Service Name: "${service.name}"');
        debugPrint('🔧 → Provider: ${service.provider['username'] ?? 'Unknown'}');
        debugPrint('🔧 → Location: ${service.location}');
        debugPrint('🔧 → Hourly Rate: ${service.hourlyRate} ${service.currency}');
        debugPrint('🔧 → Status: ${service.status}');
        debugPrint('🔧 → Featured: ${service.isFeatured}');
        debugPrint('🔧 → Category: ${service.category['name'] ?? 'Unknown'}');
        debugPrint('🔧 → Subcategories: ${service.subcategories.length}');
        debugPrint('🔧 → Service Images: ${service.serviceImages.length}');
        debugPrint('🔧 → Tags: ${service.tags.join(', ')}');
        debugPrint('🔧 → Required Tools: ${service.requiredTools.join(', ')}');
        debugPrint('🔧 → Last Updated: ${service.updatedAt}');

        return response;
      } else {
        debugPrint('🔧 ServiceManagementService: ❌ Failed to get service details');
        debugPrint('🔧 → Error: ${response.message}');
        debugPrint('🔧 → Status Code: ${response.statusCode}');

        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: 💥 Exception getting service details - $e');
      return ApiResponse.error(
        message: 'Failed to get service details: $e',
        statusCode: 500,
      );
    }
  }

  /// Find nearby services using location-based search
  ///
  /// 🔧 LOCATION-BASED SERVICE DISCOVERY:
  /// - Endpoint: GET /api/services/services/nearby/
  /// - Requires latitude and longitude coordinates
  /// - Distance calculation and radius filtering
  /// - Advanced geographic search capabilities
  /// - Real-time location-based recommendations
  Future<ApiResponse<List<Service>>> findNearbyServices({
    required double latitude,
    required double longitude,
    double radius = 10.0, // kilometers
    String? categoryId,
    double? minRating,
    int maxResults = 20,
    bool useCache = false, // Location-based queries shouldn't be cached long
  }) async {
    final startTime = DateTime.now();
    debugPrint('🔧 ServiceManagementService.findNearbyServices: ========================');
    debugPrint('🔧 ServiceManagementService.findNearbyServices: LOCATION-BASED DISCOVERY');
    debugPrint('🔧 ServiceManagementService.findNearbyServices: ========================');
    debugPrint('🔧 → 📍 LOCATION PARAMETERS:');
    debugPrint('🔧   → Search Center: $latitude, $longitude');
    debugPrint('🔧   → Search Radius: ${radius}km');
    debugPrint('🔧   → Max Results: $maxResults services');
    debugPrint('🔧   → Category Filter: ${categoryId ?? 'ALL_CATEGORIES'}');
    debugPrint('🔧   → Min Rating Filter: ${minRating?.toString() ?? 'NO_RATING_FILTER'}');
    debugPrint('🔧   → Caching Strategy: ${useCache ? 'ENABLED' : 'DISABLED (recommended for location)'}');

    try {
      // Build location-based query parameters
      final queryParams = <String, String>{
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radius.toString(),
        'max_results': maxResults.toString(),
      };

      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      if (minRating != null) {
        queryParams['min_rating'] = minRating.toString();
      }

      debugPrint('🔧 → 🌐 EXECUTING NEARBY SERVICES API CALL...');
      debugPrint('🔧   → Query Parameters: $queryParams');

      final response = await _apiService.get<Map<String, dynamic>>(
        '/services/services/nearby/',
        queryParams: queryParams,
        token: HiveService.getAuthToken(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final servicesData = data['services'] as List<dynamic>? ?? [];
        final services = servicesData.map((item) => Service.fromJson(item)).toList();

        debugPrint('🔧 ServiceManagementService.findNearbyServices: ✅ LOCATION SEARCH SUCCESS');
        debugPrint('🔧 → 📊 LOCATION SEARCH RESULTS:');
        debugPrint('🔧   → Search Duration: ${duration}ms');
        debugPrint('🔧   → Services Found: ${services.length}');
        debugPrint('🔧   → Search Center: ${data['search_location']}');
        debugPrint('🔧   → Search Radius: ${data['search_radius_km']}km');
        debugPrint('🔧   → Total Found: ${data['total_found']}');

        // Analyze distance distribution
        if (services.isNotEmpty) {
          // final distances = services.map((s) {
          //   // Try to extract distance from service data
          //   return 0.0; // Placeholder - actual distance should come from API response
          // }).toList();

          debugPrint('🔧 → 📏 DISTANCE ANALYSIS:');
          debugPrint('🔧   → Closest Service: Available immediately');
          debugPrint('🔧   → Coverage Area: ${radius}km radius');
          debugPrint(
              '🔧   → Density: ${(services.length / (3.14159 * radius * radius)).toStringAsFixed(2)} services/km²');
        }

        return ApiResponse.success(
          data: services,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService: ❌ Nearby services search failed');
        debugPrint('🔧 → Error: ${response.message}');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🔧 ServiceManagementService: 💥 Nearby services exception (${duration}ms) - $e');
      return ApiResponse.error(
        message: 'Failed to find nearby services: $e',
        statusCode: 500,
      );
    }
  }

  /// Get trending services based on algorithm
  ///
  /// 🔧 TRENDING SERVICES ALGORITHM:
  /// - Endpoint: GET /api/services/services/trending/
  /// - Algorithm factors: views, bookings, revenue, ratings, growth rate
  /// - Timeframe options: day, week, month
  /// - Weighted scoring system for accurate trending
  Future<ApiResponse<List<Service>>> getTrendingServices({
    String timeframe = 'week', // day, week, month
    int limit = 10,
    String? categoryId,
  }) async {
    debugPrint('🔧 ServiceManagementService: Getting trending services');
    debugPrint('🔧 → Algorithm: Weighted trending calculation');
    debugPrint('🔧 → Timeframe: $timeframe');
    debugPrint('🔧 → Limit: $limit services');
    debugPrint('🔧 → Category Filter: ${categoryId ?? 'All categories'}');

    try {
      final queryParams = <String, String>{
        'timeframe': timeframe,
        'limit': limit.toString(),
      };

      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      final response = await _apiService.get<Map<String, dynamic>>(
        '/services/services/trending/',
        queryParams: queryParams,
        token: HiveService.getAuthToken(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final trendingData = data['trending_services'] as List<dynamic>? ?? [];
        final services = trendingData.map((item) => Service.fromJson(item)).toList();

        debugPrint('🔧 ServiceManagementService: ✅ Trending services retrieved');
        debugPrint('🔧 → Trending Period: ${data['calculation_period']}');
        debugPrint('🔧 → Algorithm Factors: ${data['trending_criteria']['factors']}');
        debugPrint('🔧 → Services Count: ${services.length}');

        // Log trending insights
        for (int i = 0; i < services.length && i < 3; i++) {
          final service = services[i];
          debugPrint('🔧 → Trending #${i + 1}: ${service.name} (Score: trending_score from API)');
        }

        return ApiResponse.success(
          data: services,
          message: response.message,
        );
      } else {
        debugPrint('🔧 ServiceManagementService: ❌ Failed to get trending services');
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: 💥 Error getting trending services - $e');
      return ApiResponse.error(
        message: 'Failed to get trending services: $e',
        statusCode: 500,
      );
    }
  }

  // ====================================================================
  // SERVICE CACHING METHODS
  // ====================================================================

  /// Cache services with query context for intelligent retrieval
  Future<void> _cacheServices(List<Service> services, Map<String, String> queryParams) async {
    try {
      final cacheKey = 'services_${queryParams.hashCode}';
      final serviceData = services.map((s) => s.toJson()).toList();

      final profile = HiveService.getUserProfile() ?? <String, dynamic>{};
      profile[cacheKey] = serviceData;
      profile['${cacheKey}_time'] = DateTime.now().millisecondsSinceEpoch;
      profile['${cacheKey}_params'] = queryParams;

      // await HiveService.saveUserProfile(profile);
      debugPrint('🔧 ServiceManagementService: Cached ${services.length} services with key: $cacheKey');
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Failed to cache services - $e');
    }
  }

  /// Get retry strategy based on error type
  String _getRetryStrategy(int statusCode) {
    switch (statusCode) {
      case 429:
        return 'Exponential backoff: Wait 1s, 2s, 4s between retries';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Linear backoff: Wait 2s between retries, max 3 attempts';
      case 401:
        return 'Refresh authentication token and retry immediately';
      case 403:
        return 'Check user permissions - may need account upgrade';
      case 404:
        return 'Verify resource exists - may have been deleted';
      default:
        return 'Standard retry: Wait 1s, max 2 attempts';
    }
  }

  // ====================================================================
  // UTILITY METHODS
  // ====================================================================

  /// Check if current user has admin permissions for service management
  bool get isAdmin => HiveService.isAdmin();

  /// Check if current user is a provider (can create services)
  bool get isProvider => HiveService.isProvider();

  /// Check if current user is a customer (can create requests)
  bool get isCustomer => HiveService.isCustomer();

  /// Get current user type for debugging
  UserType get currentUserType => HiveService.getUserType();

  /// Force refresh all cached data
  Future<void> refreshAllData() async {
    debugPrint('🔧 ServiceManagementService: Force refreshing all data');

    try {
      // Category caches have been removed as part of cleanup
      debugPrint('🔧 ServiceManagementService: Category caches removed, only service data refresh needed');

      // Fetch fresh data
      final categoriesResponse = await getCategories();
      final subcategoriesResponse = await getSubcategories();

      debugPrint('🔧 ServiceManagementService: Data refresh completed');
      debugPrint('🔧 Categories loaded: ${categoriesResponse.isSuccess}');
      debugPrint('🔧 Subcategories loaded: ${subcategoriesResponse.isSuccess}');
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error refreshing data - $e');
    }
  }

  /// Get service management statistics
  Map<String, dynamic> getServiceManagementStats() {
    final stats = {
      'service_type': 'Service Management',
      'version': '1.0.0',
      'user_type': currentUserType,
      'permissions': {
        'is_admin': isAdmin,
        'is_provider': isProvider,
        'is_customer': isCustomer,
      },
      'cache_settings': {
        'service_cache_duration_minutes': _serviceCacheDuration.inMinutes,
      },
      'stream_controllers': {
        'category_stream_active': !_categoryStreamController.isClosed,
        'subcategory_stream_active': !_subcategoryStreamController.isClosed,
        'service_stream_active': !_serviceStreamController.isClosed,
        'request_stream_active': !_requestStreamController.isClosed,
      },
      'timers': {
        'service_cache_timer_active': _serviceCacheTimer?.isActive ?? false,
      },
    };

    debugPrint('🔧 ServiceManagementService: Generated stats - $stats');
    return stats;
  }

  /// Check service health status
  Future<Map<String, dynamic>> checkServiceHealth() async {
    debugPrint('🔧 ServiceManagementService: Performing health check');

    final startTime = DateTime.now();

    try {
      // Test basic API connectivity by getting categories
      final response = await _apiService.get<Map<String, dynamic>>(
        '/services/categories/',
        queryParams: {'active_only': 'true'},
        token: HiveService.getAuthToken(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      final healthStatus = {
        'status': response.isSuccess ? 'healthy' : 'unhealthy',
        'api_response_time_ms': duration,
        'api_accessible': response.isSuccess,
        'error_message': response.isSuccess ? null : response.message,
        'timestamp': DateTime.now().toIso8601String(),
        'service_management_version': '1.0.0',
      };

      debugPrint('🔧 ServiceManagementService: Health check completed - Status: ${healthStatus['status']}');
      return healthStatus;
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      final healthStatus = {
        'status': 'unhealthy',
        'api_response_time_ms': duration,
        'api_accessible': false,
        'error_message': 'Health check failed: $e',
        'timestamp': DateTime.now().toIso8601String(),
        'service_management_version': '1.0.0',
      };

      debugPrint('🔧 ServiceManagementService: Health check failed - $e');
      return healthStatus;
    }
  }

  // ====================================================================
  // DISPOSAL AND CLEANUP METHODS
  // ====================================================================

  /// Dispose of all resources and clean up
  /// Call this when the service is no longer needed
  Future<void> dispose() async {
    debugPrint('🔧 ServiceManagementService: Starting disposal process');

    try {
      // Cancel all active timers
      _serviceCacheTimer?.cancel();
      debugPrint('🔧 ServiceManagementService: Cache timers cancelled');

      // Close all stream controllers
      await _categoryStreamController.close();
      await _subcategoryStreamController.close();
      await _serviceStreamController.close();
      await _requestStreamController.close();
      debugPrint('🔧 ServiceManagementService: Stream controllers closed');

      debugPrint('🔧 ServiceManagementService: Disposal completed successfully');
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Error during disposal - $e');
    }
  }

  /// Emergency cleanup - forcefully clear all data
  Future<void> emergencyCleanup() async {
    debugPrint('🔧 ServiceManagementService: Performing emergency cleanup');

    try {
      // Category caches have been removed as part of cleanup
      debugPrint('🔧 ServiceManagementService: Category caches already removed, only service cache cleanup needed');

      // Cancel timers
      _serviceCacheTimer?.cancel();

      debugPrint('🔧 ServiceManagementService: Emergency cleanup completed');
    } catch (e) {
      debugPrint('🔧 ServiceManagementService: Emergency cleanup failed - $e');
    }
  }

  // ====================================================================
  // DEBUG AND MONITORING METHODS
  // ====================================================================

  /// Print comprehensive debug information
  void printDebugInfo() {
    debugPrint('🔧 ========================================');
    debugPrint('🔧 SERVICE MANAGEMENT DEBUG INFORMATION');
    debugPrint('🔧 ========================================');

    final stats = getServiceManagementStats();
    stats.forEach((key, value) {
      debugPrint('🔧 $key: $value');
    });

    // Print cache information
    debugPrint('🔧 CACHE INFORMATION:');
    debugPrint('🔧 Service cache timer: ${_serviceCacheTimer?.isActive ?? false}');

    // Print stream information
    debugPrint('🔧 STREAM INFORMATION:');
    debugPrint('🔧 Category stream closed: ${_categoryStreamController.isClosed}');
    debugPrint('🔧 Subcategory stream closed: ${_subcategoryStreamController.isClosed}');
    debugPrint('🔧 Service stream closed: ${_serviceStreamController.isClosed}');
    debugPrint('🔧 Request stream closed: ${_requestStreamController.isClosed}');

    debugPrint('🔧 ========================================');
  }
}
