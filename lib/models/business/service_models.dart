import 'package:flutter/material.dart';

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
    debugPrint(
        '🗂️ → Description Length: ${(json['description'] ?? '').length} chars');
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
        createdAt:
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt:
            DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      );

      debugPrint(
          '🗂️ ServiceCategory.fromJson: Successfully parsed category "${category.name}"');
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

  @override
  String toString() {
    return 'ServiceCategory(id: $id, name: $name, isActive: $isActive)';
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
    debugPrint(
        '📁 → Description Length: ${(json['description'] ?? '').length} chars');
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
        debugPrint(
            '📁 → Category object detected: $categoryName ($categoryId)');
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
        createdAt:
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt:
            DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      );

      debugPrint(
          '📁 ServiceSubcategory.fromJson: Successfully parsed subcategory "${subcategory.name}"');
      debugPrint('📁 → Under category: ${subcategory.categoryName}');
      return subcategory;
    } catch (e, stackTrace) {
      debugPrint(
          '📁 ServiceSubcategory.fromJson: Error parsing subcategory data');
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
    debugPrint(
        '📁 → Subcategory: $name under $categoryName (${json.length} fields)');

    return json;
  }

  @override
  String toString() {
    return 'ServiceSubcategory(id: $id, name: $name, category: $categoryName)';
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
      debugPrint(
          '📁 ServiceSubcategoryRequest: Using provided sort order: $sortOrder');
    } else {
      // Auto-assign a default sort order based on timestamp
      json['sort_order'] = DateTime.now().millisecondsSinceEpoch % 1000;
      debugPrint(
          '📁 ServiceSubcategoryRequest: Auto-assigned sort order: ${json['sort_order']}');
    }

    debugPrint(
        '📁 ServiceSubcategoryRequest.toJson: Creating subcategory request');
    debugPrint('📁 → Name: $name');
    debugPrint('📁 → Category ID: $category');
    debugPrint('📁 → Description Length: ${description.length} chars');
    debugPrint('📁 → Is Active: $isActive');
    debugPrint('📁 → Final JSON: $json');

    return json;
  }
}

/// Service status enumeration
enum ServiceStatus {
  active,
  pending,
  inactive,
  rejected,
  draft;

  static ServiceStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return ServiceStatus.active;
      case 'pending':
        return ServiceStatus.pending;
      case 'inactive':
        return ServiceStatus.inactive;
      case 'rejected':
        return ServiceStatus.rejected;
      case 'draft':
        return ServiceStatus.draft;
      default:
        return ServiceStatus.pending;
    }
  }
}

/// Service urgency levels
enum ServiceUrgency {
  low,
  medium,
  high,
  urgent;

  static ServiceUrgency fromString(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'low':
        return ServiceUrgency.low;
      case 'medium':
        return ServiceUrgency.medium;
      case 'high':
        return ServiceUrgency.high;
      case 'urgent':
        return ServiceUrgency.urgent;
      default:
        return ServiceUrgency.medium;
    }
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
          (json['subcategories'] as List<dynamic>?)
                  ?.map((item) => Map<String, dynamic>.from(item)) ??
              []),
      tags: List<String>.from(json['tags'] ?? []),
      hourlyRate: (json['hourly_rate'] ?? json['price'] ?? 0.0).toDouble(),
      pricingOptions: json['pricing_options'] != null
          ? Map<String, dynamic>.from(json['pricing_options'])
          : null,
      currency: json['currency'] ?? 'INR',
      minHours: json['min_hours'],
      maxHours: json['max_hours'],
      availability: json['availability'] != null
          ? Map<String, dynamic>.from(json['availability'])
          : null,
      location: json['location'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      requiredTools: List<String>.from(json['required_tools'] ?? []),
      status: json['status'] ?? 'active',
      isFeatured: json['is_featured'] ?? false,
      serviceImages: List<Map<String, dynamic>>.from(
          (json['service_images'] as List<dynamic>?)
                  ?.map((item) => Map<String, dynamic>.from(item)) ??
              []),
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

  String get categoryName => category['name'] ?? '';
  String get providerId => provider['id'] ?? '';
  String get providerName => provider['name'] ?? provider['username'] ?? '';

  @override
  String toString() {
    return 'Service(id: $id, name: $name, provider: $providerName, status: $status)';
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
    debugPrint(
        '🔧 ServiceRequest: Parsing service request data - ${json['title']}');

    return ServiceRequest(
      id: json['id'] ?? '',
      customer: Map<String, dynamic>.from(json['customer'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: Map<String, dynamic>.from(json['category'] ?? {}),
      subcategories: List<Map<String, dynamic>>.from(
          (json['subcategories'] as List<dynamic>?)
                  ?.map((item) => Map<String, dynamic>.from(item)) ??
              []),
      budgetMin: (json['budget_min'] ?? 0.0).toDouble(),
      budgetMax: (json['budget_max'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'INR',
      urgency: json['urgency'] ?? 'medium',
      status: json['status'] ?? 'open',
      requestedDateTime: DateTime.tryParse(json['requested_date_time'] ?? '') ??
          DateTime.now(),
      location: json['location'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      requirements: json['requirements'] != null
          ? Map<String, dynamic>.from(json['requirements'])
          : null,
      requestImages: List<Map<String, dynamic>>.from(
          (json['request_images'] as List<dynamic>?)
                  ?.map((item) => Map<String, dynamic>.from(item)) ??
              []),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
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

  String get categoryName => category['name'] ?? '';
  String get customerName => customer['name'] ?? customer['username'] ?? '';
  String get customerId => customer['id'] ?? '';

  @override
  String toString() {
    return 'ServiceRequest(id: $id, title: $title, customer: $customerName, status: $status)';
  }
}
