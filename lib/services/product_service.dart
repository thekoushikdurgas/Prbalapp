import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Product type enumeration
enum ProductType {
  physical,
  digital,
  service,
  packagedService;

  String get value {
    switch (this) {
      case ProductType.physical:
        return 'physical';
      case ProductType.digital:
        return 'digital';
      case ProductType.service:
        return 'service';
      case ProductType.packagedService:
        return 'packaged_service';
    }
  }

  static ProductType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'physical':
        return ProductType.physical;
      case 'digital':
        return ProductType.digital;
      case 'service':
        return ProductType.service;
      case 'packaged_service':
        return ProductType.packagedService;
      default:
        return ProductType.physical;
    }
  }
}

/// Product status enumeration
enum ProductStatus {
  active,
  inactive,
  draft,
  pendingReview,
  rejected;

  String get value {
    switch (this) {
      case ProductStatus.active:
        return 'active';
      case ProductStatus.inactive:
        return 'inactive';
      case ProductStatus.draft:
        return 'draft';
      case ProductStatus.pendingReview:
        return 'pending_review';
      case ProductStatus.rejected:
        return 'rejected';
    }
  }

  static ProductStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return ProductStatus.active;
      case 'inactive':
        return ProductStatus.inactive;
      case 'draft':
        return ProductStatus.draft;
      case 'pending_review':
        return ProductStatus.pendingReview;
      case 'rejected':
        return ProductStatus.rejected;
      default:
        return ProductStatus.draft;
    }
  }
}

/// Product category model
class ProductCategory {
  final String id;
  final String name;
  final String description;
  final String? iconUrl;
  final String? parentId;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.parentId,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      parentId: json['parent_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
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
      if (iconUrl != null) 'icon_url': iconUrl,
      if (parentId != null) 'parent_id': parentId,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Product category creation request model
class ProductCategoryCreateRequest {
  final String name;
  final String description;
  final bool? isActive;
  final String? iconUrl;
  final String? parentId;
  final int? sortOrder;

  const ProductCategoryCreateRequest({
    required this.name,
    required this.description,
    this.isActive,
    this.iconUrl,
    this.parentId,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (isActive != null) 'is_active': isActive,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (parentId != null) 'parent_id': parentId,
      if (sortOrder != null) 'sort_order': sortOrder,
    };
  }
}

/// Product model
class Product {
  final String id;
  final String categoryId;
  final String? relatedServiceCategoryId;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final ProductType productType;
  final int? stockQuantity;
  final List<String> images;
  final List<String> features;
  final Map<String, dynamic>? specifications;
  final bool isActive;
  final bool isFeatured;
  final bool isHighlighted;
  final String sellerId;
  final double rating;
  final int reviewCount;
  final ProductStatus status;
  final String? rejectionReason;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.categoryId,
    this.relatedServiceCategoryId,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.productType,
    this.stockQuantity,
    required this.images,
    required this.features,
    this.specifications,
    required this.isActive,
    required this.isFeatured,
    required this.isHighlighted,
    required this.sellerId,
    required this.rating,
    required this.reviewCount,
    required this.status,
    this.rejectionReason,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      categoryId: json['category'] as String,
      relatedServiceCategoryId: json['related_service_category'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      productType: ProductType.fromString(json['product_type'] as String),
      stockQuantity: json['stock_quantity'] as int?,
      images: List<String>.from(json['images'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      specifications: json['specifications'] as Map<String, dynamic>?,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      isHighlighted: json['is_highlighted'] as bool? ?? false,
      sellerId: json['seller'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      status: ProductStatus.fromString(json['status'] as String? ?? 'active'),
      rejectionReason: json['rejection_reason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': categoryId,
      if (relatedServiceCategoryId != null)
        'related_service_category': relatedServiceCategoryId,
      'name': name,
      'description': description,
      'price': price,
      if (discountPrice != null) 'discount_price': discountPrice,
      'product_type': productType.value,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      'images': images,
      'features': features,
      if (specifications != null) 'specifications': specifications,
      'is_active': isActive,
      'is_featured': isFeatured,
      'is_highlighted': isHighlighted,
      'seller': sellerId,
      'rating': rating,
      'review_count': reviewCount,
      'status': status.value,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (metadata != null) 'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Product creation request model
class ProductCreateRequest {
  final String category;
  final String? relatedServiceCategory;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final ProductType productType;
  final int? stockQuantity;
  final List<String>? images;
  final List<String>? features;
  final Map<String, dynamic>? specifications;
  final bool? isActive;
  final bool? isFeatured;

  const ProductCreateRequest({
    required this.category,
    this.relatedServiceCategory,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.productType,
    this.stockQuantity,
    this.images,
    this.features,
    this.specifications,
    this.isActive,
    this.isFeatured,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      if (relatedServiceCategory != null)
        'related_service_category': relatedServiceCategory,
      'name': name,
      'description': description,
      'price': price,
      if (discountPrice != null) 'discount_price': discountPrice,
      'product_type': productType.value,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (images != null) 'images': images,
      if (features != null) 'features': features,
      if (specifications != null) 'specifications': specifications,
      if (isActive != null) 'is_active': isActive,
      if (isFeatured != null) 'is_featured': isFeatured,
    };
  }
}

/// Product service for handling products and product categories
class ProductService {
  final ApiService _apiService;

  ProductService(this._apiService);

  // === PRODUCT CATEGORIES ===

  /// List product categories with filters and pagination
  Future<ApiResponse<List<ProductCategory>>> listProductCategories({
    bool? isActive,
    String? parentId,
    String? ordering = 'sort_order',
    String? search,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (isActive != null) queryParams['is_active'] = isActive.toString();
    if (parentId != null) queryParams['parent_id'] = parentId;
    if (ordering != null) queryParams['ordering'] = ordering;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<ProductCategory>>(
      '/api/v1/products/categories/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((category) => ProductCategory.fromJson(category))
          .toList(),
    );
  }

  /// Create product category (Admin only)
  Future<ApiResponse<ProductCategory>> createProductCategory(
    ProductCategoryCreateRequest request,
  ) async {
    debugPrint('ProductService: Creating product category: ${request.name}');

    return _apiService.post<ProductCategory>(
      '/api/v1/products/categories/',
      body: request.toJson(),
      fromJson: (data) => ProductCategory.fromJson(data),
    );
  }

  /// Get product category details by ID
  Future<ApiResponse<ProductCategory>> getProductCategoryDetails(
    String categoryId,
  ) async {
    return _apiService.get<ProductCategory>(
      '/api/v1/products/categories/$categoryId/',
      fromJson: (data) => ProductCategory.fromJson(data),
    );
  }

  /// Update product category (Admin only)
  Future<ApiResponse<ProductCategory>> updateProductCategory(
    String categoryId,
    Map<String, dynamic> updates,
  ) async {
    debugPrint('ProductService: Updating product category: $categoryId');

    return _apiService.put<ProductCategory>(
      '/api/v1/products/categories/$categoryId/',
      body: updates,
      fromJson: (data) => ProductCategory.fromJson(data),
    );
  }

  /// Partially update product category (Admin only)
  Future<ApiResponse<ProductCategory>> partiallyUpdateProductCategory(
    String categoryId,
    Map<String, dynamic> updates,
  ) async {
    debugPrint(
        'ProductService: Partially updating product category: $categoryId');

    return _apiService.patch<ProductCategory>(
      '/api/v1/products/categories/$categoryId/',
      body: updates,
      fromJson: (data) => ProductCategory.fromJson(data),
    );
  }

  /// Delete product category (Admin only)
  Future<ApiResponse<Map<String, dynamic>>> deleteProductCategory(
    String categoryId,
  ) async {
    debugPrint('ProductService: Deleting product category: $categoryId');

    return _apiService.delete<Map<String, dynamic>>(
      '/api/v1/products/categories/$categoryId/',
      fromJson: (data) => data,
    );
  }

  // === PRODUCTS ===

  /// List products with filters and pagination
  Future<ApiResponse<List<Product>>> listProducts({
    String? search,
    String? category,
    bool? isFeatured,
    String? ordering,
    ProductType? productType,
    String? seller,
    ProductStatus? status,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (category != null) queryParams['category'] = category;
    if (isFeatured != null) queryParams['is_featured'] = isFeatured.toString();
    if (ordering != null) queryParams['ordering'] = ordering;
    if (productType != null) queryParams['product_type'] = productType.value;
    if (seller != null) queryParams['seller'] = seller;
    if (status != null) queryParams['status'] = status.value;
    if (minPrice != null) queryParams['min_price'] = minPrice.toString();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
    if (inStock != null) queryParams['in_stock'] = inStock.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  /// Create product (Provider only)
  Future<ApiResponse<Product>> createProduct(
    ProductCreateRequest request,
  ) async {
    debugPrint('ProductService: Creating product: ${request.name}');

    return _apiService.post<Product>(
      '/api/v1/products/',
      body: request.toJson(),
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Get product details by ID
  Future<ApiResponse<Product>> getProductDetails(String productId) async {
    return _apiService.get<Product>(
      '/api/v1/products/$productId/',
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Update product (Provider/Admin)
  Future<ApiResponse<Product>> updateProduct(
    String productId,
    Map<String, dynamic> updates,
  ) async {
    debugPrint('ProductService: Updating product: $productId');

    return _apiService.put<Product>(
      '/api/v1/products/$productId/',
      body: updates,
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Partially update product (Provider/Admin)
  Future<ApiResponse<Product>> partiallyUpdateProduct(
    String productId,
    Map<String, dynamic> updates,
  ) async {
    debugPrint('ProductService: Partially updating product: $productId');

    return _apiService.patch<Product>(
      '/api/v1/products/$productId/',
      body: updates,
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Delete product (Provider/Admin)
  Future<ApiResponse<Map<String, dynamic>>> deleteProduct(
    String productId,
  ) async {
    debugPrint('ProductService: Deleting product: $productId');

    return _apiService.delete<Map<String, dynamic>>(
      '/api/v1/products/$productId/',
      fromJson: (data) => data,
    );
  }

  // === PROVIDER SPECIFIC METHODS ===

  /// Get my products (as provider)
  Future<ApiResponse<List<Product>>> getMyProducts({
    String? category,
    ProductType? productType,
    ProductStatus? status,
    String? ordering = '-created_at',
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (category != null) queryParams['category'] = category;
    if (productType != null) queryParams['product_type'] = productType.value;
    if (status != null) queryParams['status'] = status.value;
    if (ordering != null) queryParams['ordering'] = ordering;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/my-products/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  /// Get products by seller/provider
  Future<ApiResponse<List<Product>>> getProductsBySeller(
    String sellerId, {
    String? category,
    ProductType? productType,
    bool? activeOnly = true,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (category != null) queryParams['category'] = category;
    if (productType != null) queryParams['product_type'] = productType.value;
    if (activeOnly != null) queryParams['is_active'] = activeOnly.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/',
      queryParameters: {
        'seller': sellerId,
        ...queryParams,
      },
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  // === FEATURED AND POPULAR PRODUCTS ===

  /// Get featured products
  Future<ApiResponse<List<Product>>> getFeaturedProducts({
    String? category,
    ProductType? productType,
    int? limit,
  }) async {
    final queryParams = <String, String>{};

    if (category != null) queryParams['category'] = category;
    if (productType != null) queryParams['product_type'] = productType.value;
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/',
      queryParameters: {
        'is_featured': 'true',
        ...queryParams,
      },
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  /// Get popular products (based on ratings and reviews)
  Future<ApiResponse<List<Product>>> getPopularProducts({
    String? category,
    ProductType? productType,
    String? timeframe, // 'week', 'month', 'year'
    int? limit,
  }) async {
    final queryParams = <String, String>{};

    if (category != null) queryParams['category'] = category;
    if (productType != null) queryParams['product_type'] = productType.value;
    if (timeframe != null) queryParams['timeframe'] = timeframe;
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/popular/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  // === SEARCH AND FILTERING ===

  /// Advanced product search
  Future<ApiResponse<List<Product>>> searchProducts({
    required String query,
    String? category,
    ProductType? productType,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStock,
    String? location,
    String? sortBy, // 'price', 'rating', 'created_at', 'name'
    String? sortOrder, // 'asc', 'desc'
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{
      'search': query,
    };

    if (category != null) queryParams['category'] = category;
    if (productType != null) queryParams['product_type'] = productType.value;
    if (minPrice != null) queryParams['min_price'] = minPrice.toString();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
    if (minRating != null) queryParams['min_rating'] = minRating.toString();
    if (inStock != null) queryParams['in_stock'] = inStock.toString();
    if (location != null) queryParams['location'] = location;
    if (sortBy != null) queryParams['sort_by'] = sortBy;
    if (sortOrder != null) queryParams['sort_order'] = sortOrder;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/search/',
      queryParameters: queryParams,
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  // === PRODUCT MANAGEMENT ===

  /// Toggle product active status
  Future<ApiResponse<Product>> toggleProductStatus(String productId) async {
    debugPrint('ProductService: Toggling status for product: $productId');

    return _apiService.post<Product>(
      '/api/v1/products/$productId/toggle-status/',
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Set product as featured
  Future<ApiResponse<Product>> setProductFeatured(
    String productId,
    bool featured,
  ) async {
    debugPrint('ProductService: Setting product featured status: $productId');

    return _apiService.post<Product>(
      '/api/v1/products/$productId/set-featured/',
      body: {'is_featured': featured},
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Duplicate product
  Future<ApiResponse<Product>> duplicateProduct(String productId) async {
    debugPrint('ProductService: Duplicating product: $productId');

    return _apiService.post<Product>(
      '/api/v1/products/$productId/duplicate/',
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Update product stock
  Future<ApiResponse<Product>> updateProductStock(
    String productId,
    int stockQuantity,
  ) async {
    debugPrint('ProductService: Updating stock for product: $productId');

    return _apiService.patch<Product>(
      '/api/v1/products/$productId/',
      body: {'stock_quantity': stockQuantity},
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Bulk update products
  Future<ApiResponse<List<Product>>> bulkUpdateProducts(
    List<String> productIds,
    Map<String, dynamic> updates,
  ) async {
    debugPrint('ProductService: Bulk updating ${productIds.length} products');

    return _apiService.post<List<Product>>(
      '/api/v1/products/bulk-update/',
      body: {
        'product_ids': productIds,
        'updates': updates,
      },
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  // === ANALYTICS AND REPORTS ===

  /// Get product analytics
  Future<ApiResponse<Map<String, dynamic>>> getProductAnalytics(
    String productId, {
    DateTime? startDate,
    DateTime? endDate,
    String? metrics, // 'views', 'sales', 'revenue', 'rating'
  }) async {
    final queryParams = <String, String>{};

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (metrics != null) queryParams['metrics'] = metrics;

    return _apiService.get<Map<String, dynamic>>(
      '/api/v1/products/$productId/analytics/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }

  /// Get category analytics
  Future<ApiResponse<Map<String, dynamic>>> getCategoryAnalytics(
    String categoryId, {
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
      '/api/v1/products/categories/$categoryId/analytics/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }

  /// Get sales report
  Future<ApiResponse<Map<String, dynamic>>> getSalesReport({
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy, // 'day', 'week', 'month'
    String? category,
    ProductType? productType,
  }) async {
    final queryParams = <String, String>{};

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (groupBy != null) queryParams['group_by'] = groupBy;
    if (category != null) queryParams['category'] = category;
    if (productType != null) queryParams['product_type'] = productType.value;

    return _apiService.get<Map<String, dynamic>>(
      '/api/v1/products/reports/sales/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }

  // === ADMIN SPECIFIC METHODS ===

  /// Admin: Get all products with advanced filters
  Future<ApiResponse<List<Product>>> adminListAllProducts({
    ProductStatus? status,
    String? category,
    String? seller,
    ProductType? productType,
    bool? needsReview,
    DateTime? createdAfter,
    DateTime? createdBefore,
    String? ordering = '-created_at',
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (status != null) queryParams['status'] = status.value;
    if (category != null) queryParams['category'] = category;
    if (seller != null) queryParams['seller'] = seller;
    if (productType != null) queryParams['product_type'] = productType.value;
    if (needsReview != null) {
      queryParams['needs_review'] = needsReview.toString();
    }
    if (createdAfter != null) {
      queryParams['created_after'] =
          createdAfter.toIso8601String().split('T')[0];
    }
    if (createdBefore != null) {
      queryParams['created_before'] =
          createdBefore.toIso8601String().split('T')[0];
    }
    if (ordering != null) queryParams['ordering'] = ordering;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Product>>(
      '/admin/products/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  /// Admin: Approve product
  Future<ApiResponse<Product>> adminApproveProduct(
    String productId, {
    String? adminNotes,
  }) async {
    debugPrint('ProductService: Admin approving product: $productId');

    return _apiService.post<Product>(
      '/admin/products/$productId/approve/',
      body: {
        if (adminNotes != null) 'admin_notes': adminNotes,
      },
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Admin: Reject product
  Future<ApiResponse<Product>> adminRejectProduct(
    String productId, {
    required String reason,
    String? adminNotes,
  }) async {
    debugPrint('ProductService: Admin rejecting product: $productId');

    return _apiService.post<Product>(
      '/admin/products/$productId/reject/',
      body: {
        'rejection_reason': reason,
        if (adminNotes != null) 'admin_notes': adminNotes,
      },
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Admin: Force feature product
  Future<ApiResponse<Product>> adminFeatureProduct(
    String productId,
    bool featured, {
    DateTime? featuredUntil,
  }) async {
    debugPrint('ProductService: Admin featuring product: $productId');

    return _apiService.post<Product>(
      '/admin/products/$productId/force-feature/',
      body: {
        'is_featured': featured,
        if (featuredUntil != null)
          'featured_until': featuredUntil.toIso8601String(),
      },
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Admin: Get comprehensive product analytics
  Future<ApiResponse<Map<String, dynamic>>> adminGetProductAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
    List<String>? metrics, // 'sales', 'revenue', 'views', 'rating'
    String? category,
    ProductType? productType,
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
    if (category != null) queryParams['category'] = category;
    if (productType != null) queryParams['product_type'] = productType.value;

    return _apiService.get<Map<String, dynamic>>(
      '/admin/products/analytics/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }

  // === ADDITIONAL UTILITY METHODS ===

  /// Get product recommendations for a user
  Future<ApiResponse<List<Product>>> getProductRecommendations({
    String? userId,
    String? category,
    int? limit = 10,
  }) async {
    final queryParams = <String, String>{};

    if (userId != null) queryParams['user_id'] = userId;
    if (category != null) queryParams['category'] = category;
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/recommendations/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  /// Get similar products
  Future<ApiResponse<List<Product>>> getSimilarProducts(
    String productId, {
    int? limit = 10,
  }) async {
    final queryParams = <String, String>{};

    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/$productId/similar/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  /// Get low stock products (for providers)
  Future<ApiResponse<List<Product>>> getLowStockProducts({
    int? threshold = 5,
  }) async {
    final queryParams = <String, String>{};

    if (threshold != null) queryParams['threshold'] = threshold.toString();

    return _apiService.get<List<Product>>(
      '/api/v1/products/low-stock/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }
}

/// Provider for ProductService
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(ApiService());
});
