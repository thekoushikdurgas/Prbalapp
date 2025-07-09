import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'api_service.dart';

/// Product status enumeration
enum ProductStatus {
  draft,
  active,
  inactive,
  outOfStock,
  discontinued;

  String get value {
    switch (this) {
      case ProductStatus.draft:
        return 'draft';
      case ProductStatus.active:
        return 'active';
      case ProductStatus.inactive:
        return 'inactive';
      case ProductStatus.outOfStock:
        return 'out_of_stock';
      case ProductStatus.discontinued:
        return 'discontinued';
    }
  }

  static ProductStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return ProductStatus.draft;
      case 'active':
        return ProductStatus.active;
      case 'inactive':
        return ProductStatus.inactive;
      case 'out_of_stock':
        return ProductStatus.outOfStock;
      case 'discontinued':
        return ProductStatus.discontinued;
      default:
        return ProductStatus.draft;
    }
  }
}

/// Product type enumeration
enum ProductType {
  physical,
  digital,
  service,
  subscription;

  String get value {
    switch (this) {
      case ProductType.physical:
        return 'physical';
      case ProductType.digital:
        return 'digital';
      case ProductType.service:
        return 'service';
      case ProductType.subscription:
        return 'subscription';
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
      case 'subscription':
        return ProductType.subscription;
      default:
        return ProductType.service;
    }
  }
}

/// Product model
class Product {
  final String id;
  final String name;
  final String description;
  final String? shortDescription;
  final ProductType type;
  final ProductStatus status;
  final Map<String, dynamic> category;
  final List<Map<String, dynamic>> subcategories;
  final List<String> tags;
  final double price;
  final double? discountPrice;
  final String currency;
  final String? sku;
  final int? stockQuantity;
  final bool isUnlimited;
  final List<Map<String, dynamic>> productImages;
  final Map<String, dynamic>? specifications;
  final Map<String, dynamic>? dimensions;
  final double? weight;
  final Map<String, dynamic> provider;
  final List<Map<String, dynamic>> variants;
  final bool isFeatured;
  final bool isDigitalDelivery;
  final int minOrderQuantity;
  final int maxOrderQuantity;
  final double rating;
  final int reviewCount;
  final int salesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    this.shortDescription,
    required this.type,
    required this.status,
    required this.category,
    required this.subcategories,
    required this.tags,
    required this.price,
    this.discountPrice,
    required this.currency,
    this.sku,
    this.stockQuantity,
    required this.isUnlimited,
    required this.productImages,
    this.specifications,
    this.dimensions,
    this.weight,
    required this.provider,
    required this.variants,
    required this.isFeatured,
    required this.isDigitalDelivery,
    required this.minOrderQuantity,
    required this.maxOrderQuantity,
    required this.rating,
    required this.reviewCount,
    required this.salesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['short_description'] as String?,
      type: ProductType.fromString(json['type'] as String),
      status: ProductStatus.fromString(json['status'] as String),
      category: Map<String, dynamic>.from(json['category'] as Map),
      subcategories: List<Map<String, dynamic>>.from(
        (json['subcategories'] as List?)
                ?.map((item) => Map<String, dynamic>.from(item)) ??
            [],
      ),
      tags: List<String>.from(json['tags'] as List? ?? []),
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] as num).toDouble()
          : null,
      currency: json['currency'] as String,
      sku: json['sku'] as String?,
      stockQuantity: json['stock_quantity'] as int?,
      isUnlimited: json['is_unlimited'] as bool? ?? false,
      productImages: List<Map<String, dynamic>>.from(
        (json['product_images'] as List?)
                ?.map((item) => Map<String, dynamic>.from(item)) ??
            [],
      ),
      specifications: json['specifications'] != null
          ? Map<String, dynamic>.from(json['specifications'])
          : null,
      dimensions: json['dimensions'] != null
          ? Map<String, dynamic>.from(json['dimensions'])
          : null,
      weight: json['weight']?.toDouble(),
      provider: Map<String, dynamic>.from(json['provider'] as Map),
      variants: List<Map<String, dynamic>>.from(
        (json['variants'] as List?)
                ?.map((item) => Map<String, dynamic>.from(item)) ??
            [],
      ),
      isFeatured: json['is_featured'] as bool? ?? false,
      isDigitalDelivery: json['is_digital_delivery'] as bool? ?? false,
      minOrderQuantity: json['min_order_quantity'] as int? ?? 1,
      maxOrderQuantity: json['max_order_quantity'] as int? ?? 999,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      salesCount: json['sales_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      if (shortDescription != null) 'short_description': shortDescription,
      'type': type.value,
      'status': status.value,
      'category': category,
      'subcategories': subcategories,
      'tags': tags,
      'price': price,
      if (discountPrice != null) 'discount_price': discountPrice,
      'currency': currency,
      if (sku != null) 'sku': sku,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      'is_unlimited': isUnlimited,
      'product_images': productImages,
      if (specifications != null) 'specifications': specifications,
      if (dimensions != null) 'dimensions': dimensions,
      if (weight != null) 'weight': weight,
      'provider': provider,
      'variants': variants,
      'is_featured': isFeatured,
      'is_digital_delivery': isDigitalDelivery,
      'min_order_quantity': minOrderQuantity,
      'max_order_quantity': maxOrderQuantity,
      'rating': rating,
      'review_count': reviewCount,
      'sales_count': salesCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get effective price (discount price if available, otherwise regular price)
  double get effectivePrice => discountPrice ?? price;

  /// Check if product has discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  /// Get discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((price - discountPrice!) / price) * 100;
  }

  /// Check if product is in stock
  bool get isInStock {
    if (isUnlimited) return true;
    return stockQuantity != null && stockQuantity! > 0;
  }

  /// Check if product is available for purchase
  bool get isAvailable => status == ProductStatus.active && isInStock;
}

/// Create product request model
class CreateProductRequest {
  final String name;
  final String description;
  final String? shortDescription;
  final ProductType type;
  final String categoryId;
  final List<String> subcategoryIds;
  final List<String> tags;
  final double price;
  final double? discountPrice;
  final String currency;
  final String? sku;
  final int? stockQuantity;
  final bool isUnlimited;
  final Map<String, dynamic>? specifications;
  final Map<String, dynamic>? dimensions;
  final double? weight;
  final bool isFeatured;
  final bool isDigitalDelivery;
  final int minOrderQuantity;
  final int maxOrderQuantity;

  const CreateProductRequest({
    required this.name,
    required this.description,
    this.shortDescription,
    required this.type,
    required this.categoryId,
    required this.subcategoryIds,
    required this.tags,
    required this.price,
    this.discountPrice,
    this.currency = 'USD',
    this.sku,
    this.stockQuantity,
    this.isUnlimited = false,
    this.specifications,
    this.dimensions,
    this.weight,
    this.isFeatured = false,
    this.isDigitalDelivery = false,
    this.minOrderQuantity = 1,
    this.maxOrderQuantity = 999,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      if (shortDescription != null) 'short_description': shortDescription,
      'type': type.value,
      'category_id': categoryId,
      'subcategory_ids': subcategoryIds,
      'tags': tags,
      'price': price,
      if (discountPrice != null) 'discount_price': discountPrice,
      'currency': currency,
      if (sku != null) 'sku': sku,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      'is_unlimited': isUnlimited,
      if (specifications != null) 'specifications': specifications,
      if (dimensions != null) 'dimensions': dimensions,
      if (weight != null) 'weight': weight,
      'is_featured': isFeatured,
      'is_digital_delivery': isDigitalDelivery,
      'min_order_quantity': minOrderQuantity,
      'max_order_quantity': maxOrderQuantity,
    };
  }
}

/// Update product request model
class UpdateProductRequest {
  final String? name;
  final String? description;
  final String? shortDescription;
  final ProductType? type;
  final ProductStatus? status;
  final String? categoryId;
  final List<String>? subcategoryIds;
  final List<String>? tags;
  final double? price;
  final double? discountPrice;
  final String? currency;
  final String? sku;
  final int? stockQuantity;
  final bool? isUnlimited;
  final Map<String, dynamic>? specifications;
  final Map<String, dynamic>? dimensions;
  final double? weight;
  final bool? isFeatured;
  final bool? isDigitalDelivery;
  final int? minOrderQuantity;
  final int? maxOrderQuantity;

  const UpdateProductRequest({
    this.name,
    this.description,
    this.shortDescription,
    this.type,
    this.status,
    this.categoryId,
    this.subcategoryIds,
    this.tags,
    this.price,
    this.discountPrice,
    this.currency,
    this.sku,
    this.stockQuantity,
    this.isUnlimited,
    this.specifications,
    this.dimensions,
    this.weight,
    this.isFeatured,
    this.isDigitalDelivery,
    this.minOrderQuantity,
    this.maxOrderQuantity,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (description != null) json['description'] = description;
    if (shortDescription != null) json['short_description'] = shortDescription;
    if (type != null) json['type'] = type!.value;
    if (status != null) json['status'] = status!.value;
    if (categoryId != null) json['category_id'] = categoryId;
    if (subcategoryIds != null) json['subcategory_ids'] = subcategoryIds;
    if (tags != null) json['tags'] = tags;
    if (price != null) json['price'] = price;
    if (discountPrice != null) json['discount_price'] = discountPrice;
    if (currency != null) json['currency'] = currency;
    if (sku != null) json['sku'] = sku;
    if (stockQuantity != null) json['stock_quantity'] = stockQuantity;
    if (isUnlimited != null) json['is_unlimited'] = isUnlimited;
    if (specifications != null) json['specifications'] = specifications;
    if (dimensions != null) json['dimensions'] = dimensions;
    if (weight != null) json['weight'] = weight;
    if (isFeatured != null) json['is_featured'] = isFeatured;
    if (isDigitalDelivery != null) {
      json['is_digital_delivery'] = isDigitalDelivery;
    }
    if (minOrderQuantity != null) json['min_order_quantity'] = minOrderQuantity;
    if (maxOrderQuantity != null) json['max_order_quantity'] = maxOrderQuantity;
    return json;
  }
}

/// Product list response model
class ProductListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Product> results;

  const ProductListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }
}

/// Comprehensive Product Service for Prbal app
/// Handles product/service catalog management, inventory, pricing, and analytics
class ProductService {
  final ApiService _apiService;

  ProductService(this._apiService) {
    debugPrint('🛍️ ProductService: Initializing product service');
    debugPrint(
        '🛍️ ProductService: Service will handle products, inventory, and catalog management');
  }

  // ====================================================================
  // PRODUCT MANAGEMENT
  // ====================================================================

  /// List products with filtering and pagination
  /// Endpoint: GET /products/
  Future<ApiResponse<ProductListResponse>> listProducts({
    ProductStatus? status,
    ProductType? type,
    String? categoryId,
    String? subcategoryId,
    String? search,
    String? providerId,
    bool? isFeatured,
    bool? inStock,
    double? minPrice,
    double? maxPrice,
    String? ordering = '-created_at',
    int? limit,
    int? offset,
  }) async {
    final startTime = DateTime.now();
    debugPrint('🛍️ ProductService: Listing products');

    final queryParams = <String, String>{};
    if (status != null) {
      queryParams['status'] = status.value;
      debugPrint('🛍️ ProductService: Filtering by status: ${status.value}');
    }
    if (type != null) {
      queryParams['type'] = type.value;
      debugPrint('🛍️ ProductService: Filtering by type: ${type.value}');
    }
    if (categoryId != null) {
      queryParams['category_id'] = categoryId;
    }
    if (subcategoryId != null) {
      queryParams['subcategory_id'] = subcategoryId;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
      debugPrint('🛍️ ProductService: Searching for: $search');
    }
    if (providerId != null) {
      queryParams['provider_id'] = providerId;
    }
    if (isFeatured != null) {
      queryParams['is_featured'] = isFeatured.toString();
    }
    if (inStock != null) {
      queryParams['in_stock'] = inStock.toString();
    }
    if (minPrice != null) {
      queryParams['min_price'] = minPrice.toString();
    }
    if (maxPrice != null) {
      queryParams['max_price'] = maxPrice.toString();
    }
    if (ordering != null) {
      queryParams['ordering'] = ordering;
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }
    if (offset != null) {
      queryParams['offset'] = offset.toString();
    }

    try {
      debugPrint(
          '🛍️ ProductService: Making API call with query params: $queryParams');

      final response = await _apiService.get(
        '/products/',
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) => ProductListResponse.fromJson(data),
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.success && response.data != null) {
        final products = response.data!.results;
        debugPrint(
            '🛍️ ProductService: Successfully retrieved ${products.length} products in ${duration}ms');

        final featuredCount = products.where((p) => p.isFeatured).length;
        final avgPrice = products.isNotEmpty
            ? products.fold(0.0, (sum, p) => sum + p.price) / products.length
            : 0.0;

        debugPrint('🛍️ ProductService: Featured products: $featuredCount');
        debugPrint(
            '🛍️ ProductService: Average price: \$${avgPrice.toStringAsFixed(2)}');

        return response;
      }

      debugPrint(
          '🛍️ ProductService: Failed to fetch products - ${response.message}');
      return ApiResponse<ProductListResponse>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint(
          '🛍️ ProductService: Error fetching products (${duration}ms): $e');
      return ApiResponse<ProductListResponse>(
        success: false,
        message: 'Error fetching products: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Get product details by ID
  /// Endpoint: GET /products/{id}/
  Future<ApiResponse<Product>> getProductDetails(String productId) async {
    debugPrint(
        '🛍️ ProductService: Getting product details for ID: $productId');

    try {
      final response = await _apiService.get(
        '/products/$productId/',
        fromJson: (data) => Product.fromJson(data),
      );

      if (response.success && response.data != null) {
        final product = response.data!;
        debugPrint(
            '🛍️ ProductService: Successfully retrieved product: ${product.name}');
        debugPrint(
            '🛍️ ProductService: Price: \$${product.price.toStringAsFixed(2)}');
        debugPrint('🛍️ ProductService: Status: ${product.status.value}');
        debugPrint('🛍️ ProductService: Type: ${product.type.value}');
        debugPrint('🛍️ ProductService: In stock: ${product.isInStock}');

        return response;
      }

      debugPrint(
          '🛍️ ProductService: Failed to fetch product details - ${response.message}');
      return ApiResponse<Product>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🛍️ ProductService: Error fetching product details: $e');
      return ApiResponse<Product>(
        success: false,
        message: 'Error fetching product details: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Create a new product
  /// Endpoint: POST /products/
  Future<ApiResponse<Product>> createProduct(
      CreateProductRequest request) async {
    debugPrint('🛍️ ProductService: Creating new product');
    debugPrint('🛍️ ProductService: Name: ${request.name}');
    debugPrint('🛍️ ProductService: Type: ${request.type.value}');
    debugPrint(
        '🛍️ ProductService: Price: \$${request.price.toStringAsFixed(2)} ${request.currency}');

    try {
      final response = await _apiService.post(
        '/products/',
        body: request.toJson(),
        fromJson: (data) => Product.fromJson(data),
      );

      if (response.success && response.data != null) {
        final product = response.data!;
        debugPrint(
            '🛍️ ProductService: Product created successfully: ${product.id}');
        debugPrint('🛍️ ProductService: Status: ${product.status.value}');
        debugPrint('🛍️ ProductService: SKU: ${product.sku ?? 'N/A'}');

        return response;
      }

      debugPrint(
          '🛍️ ProductService: Failed to create product - ${response.message}');
      return ApiResponse<Product>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🛍️ ProductService: Error creating product: $e');
      return ApiResponse<Product>(
        success: false,
        message: 'Error creating product: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Update an existing product
  /// Endpoint: PUT /products/{id}/
  Future<ApiResponse<Product>> updateProduct(
      String productId, UpdateProductRequest request) async {
    debugPrint('🛍️ ProductService: Updating product: $productId');

    try {
      final response = await _apiService.put(
        '/products/$productId/',
        body: request.toJson(),
        fromJson: (data) => Product.fromJson(data),
      );

      if (response.success && response.data != null) {
        final product = response.data!;
        debugPrint('🛍️ ProductService: Product updated successfully');
        debugPrint('🛍️ ProductService: Name: ${product.name}');
        debugPrint('🛍️ ProductService: Status: ${product.status.value}');

        return response;
      }

      debugPrint(
          '🛍️ ProductService: Failed to update product - ${response.message}');
      return ApiResponse<Product>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🛍️ ProductService: Error updating product: $e');
      return ApiResponse<Product>(
        success: false,
        message: 'Error updating product: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Delete a product
  /// Endpoint: DELETE /products/{id}/
  Future<ApiResponse<void>> deleteProduct(String productId) async {
    debugPrint('🛍️ ProductService: Deleting product: $productId');

    try {
      final response = await _apiService.delete('/products/$productId/');

      if (response.success) {
        debugPrint('🛍️ ProductService: Product deleted successfully');
      } else {
        debugPrint(
            '🛍️ ProductService: Failed to delete product - ${response.message}');
      }

      return response;
    } catch (e) {
      debugPrint('🛍️ ProductService: Error deleting product: $e');
      return ApiResponse<void>(
        success: false,
        message: 'Error deleting product: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // INVENTORY MANAGEMENT
  // ====================================================================

  /// Update product stock
  /// Endpoint: PATCH /products/{id}/stock/
  Future<ApiResponse<Product>> updateStock(String productId, int quantity,
      {String? reason}) async {
    debugPrint('🛍️ ProductService: Updating stock for product: $productId');
    debugPrint('🛍️ ProductService: New quantity: $quantity');
    debugPrint('🛍️ ProductService: Reason: ${reason ?? 'N/A'}');

    try {
      final body = {
        'stock_quantity': quantity,
        if (reason != null) 'reason': reason,
      };

      final response = await _apiService.patch(
        '/products/$productId/stock/',
        body: body,
        fromJson: (data) => Product.fromJson(data),
      );

      if (response.success && response.data != null) {
        final product = response.data!;
        debugPrint('🛍️ ProductService: Stock updated successfully');
        debugPrint(
            '🛍️ ProductService: Current stock: ${product.stockQuantity ?? 'Unlimited'}');

        return response;
      }

      debugPrint(
          '🛍️ ProductService: Failed to update stock - ${response.message}');
      return ApiResponse<Product>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🛍️ ProductService: Error updating stock: $e');
      return ApiResponse<Product>(
        success: false,
        message: 'Error updating stock: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Adjust product stock (increment/decrement)
  /// Endpoint: POST /products/{id}/stock/adjust/
  Future<ApiResponse<Product>> adjustStock(String productId, int adjustment,
      {String? reason}) async {
    debugPrint('🛍️ ProductService: Adjusting stock for product: $productId');
    debugPrint(
        '🛍️ ProductService: Adjustment: ${adjustment > 0 ? '+' : ''}$adjustment');
    debugPrint('🛍️ ProductService: Reason: ${reason ?? 'N/A'}');

    try {
      final body = {
        'adjustment': adjustment,
        if (reason != null) 'reason': reason,
      };

      final response = await _apiService.post(
        '/products/$productId/stock/adjust/',
        body: body,
        fromJson: (data) => Product.fromJson(data),
      );

      if (response.success && response.data != null) {
        final product = response.data!;
        debugPrint('🛍️ ProductService: Stock adjusted successfully');
        debugPrint(
            '🛍️ ProductService: Current stock: ${product.stockQuantity ?? 'Unlimited'}');

        return response;
      }

      debugPrint(
          '🛍️ ProductService: Failed to adjust stock - ${response.message}');
      return ApiResponse<Product>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('🛍️ ProductService: Error adjusting stock: $e');
      return ApiResponse<Product>(
        success: false,
        message: 'Error adjusting stock: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // FEATURED AND TRENDING PRODUCTS
  // ====================================================================

  /// Get featured products
  Future<ApiResponse<ProductListResponse>> getFeaturedProducts(
      {int? limit}) async {
    debugPrint('🛍️ ProductService: Getting featured products');

    return listProducts(
      isFeatured: true,
      status: ProductStatus.active,
      ordering: '-created_at',
      limit: limit ?? 10,
    );
  }

  /// Get trending products
  Future<ApiResponse<ProductListResponse>> getTrendingProducts(
      {int? limit}) async {
    debugPrint('🛍️ ProductService: Getting trending products');

    return listProducts(
      status: ProductStatus.active,
      ordering: '-sales_count',
      limit: limit ?? 10,
    );
  }

  /// Get best-selling products
  Future<ApiResponse<ProductListResponse>> getBestSellingProducts(
      {int? limit}) async {
    debugPrint('🛍️ ProductService: Getting best-selling products');

    return listProducts(
      status: ProductStatus.active,
      ordering: '-sales_count',
      limit: limit ?? 10,
    );
  }

  /// Get newest products
  Future<ApiResponse<ProductListResponse>> getNewestProducts(
      {int? limit}) async {
    debugPrint('🛍️ ProductService: Getting newest products');

    return listProducts(
      status: ProductStatus.active,
      ordering: '-created_at',
      limit: limit ?? 10,
    );
  }

  // ====================================================================
  // SEARCH AND FILTERING
  // ====================================================================

  /// Search products with advanced filters
  Future<ApiResponse<ProductListResponse>> searchProducts({
    required String query,
    ProductType? type,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStock,
    String? ordering = 'relevance',
    int? limit,
    int? offset,
  }) async {
    debugPrint('🛍️ ProductService: Searching products with query: "$query"');

    return listProducts(
      search: query,
      type: type,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      inStock: inStock,
      ordering: ordering,
      limit: limit,
      offset: offset,
    );
  }

  /// Get products by category
  Future<ApiResponse<ProductListResponse>> getProductsByCategory(
    String categoryId, {
    String? subcategoryId,
    int? limit,
  }) async {
    debugPrint(
        '🛍️ ProductService: Getting products for category: $categoryId');

    return listProducts(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      status: ProductStatus.active,
      ordering: '-created_at',
      limit: limit,
    );
  }

  /// Get products by provider
  Future<ApiResponse<ProductListResponse>> getProductsByProvider(
    String providerId, {
    ProductStatus? status,
    int? limit,
  }) async {
    debugPrint(
        '🛍️ ProductService: Getting products for provider: $providerId');

    return listProducts(
      providerId: providerId,
      status: status ?? ProductStatus.active,
      ordering: '-created_at',
      limit: limit,
    );
  }

  // ====================================================================
  // ANALYTICS AND STATISTICS
  // ====================================================================

  /// Get product analytics
  Future<Map<String, dynamic>> getProductAnalytics({String? categoryId}) async {
    debugPrint('🛍️ ProductService: Generating product analytics');

    try {
      final productsResponse = await listProducts(categoryId: categoryId);

      if (productsResponse.success && productsResponse.data != null) {
        final products = productsResponse.data!.results;
        final analytics = {
          'total_products': products.length,
          'active_products':
              products.where((p) => p.status == ProductStatus.active).length,
          'featured_products': products.where((p) => p.isFeatured).length,
          'out_of_stock': products.where((p) => !p.isInStock).length,
          'average_price': products.isNotEmpty
              ? products.fold(0.0, (sum, p) => sum + p.price) / products.length
              : 0.0,
          'average_rating': products.isNotEmpty
              ? products.fold(0.0, (sum, p) => sum + p.rating) / products.length
              : 0.0,
          'total_sales': products.fold(0, (sum, p) => sum + p.salesCount),
          'by_type': <String, int>{},
          'by_status': <String, int>{},
        };

        // Group by type and status
        for (final product in products) {
          final type = product.type.value;
          final status = product.status.value;

          final byType = analytics['by_type'] as Map<String, int>;
          byType[type] = (byType[type] ?? 0) + 1;

          final byStatus = analytics['by_status'] as Map<String, int>;
          byStatus[status] = (byStatus[status] ?? 0) + 1;
        }

        debugPrint('🛍️ ProductService: Analytics generated successfully');
        debugPrint(
            '🛍️ ProductService: Total products: ${analytics['total_products']}');
        debugPrint(
            '🛍️ ProductService: Average price: \$${(analytics['average_price'] as double).toStringAsFixed(2)}');

        return analytics;
      }
    } catch (e) {
      debugPrint('🛍️ ProductService: Error generating analytics: $e');
    }

    return {'error': 'Failed to generate analytics'};
  }

  /// Check product service health
  Future<Map<String, dynamic>> checkProductHealth() async {
    debugPrint('🛍️ ProductService: Performing health check');

    final startTime = DateTime.now();
    try {
      // Test basic functionality by fetching products
      final response = await listProducts(limit: 1);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      final healthStatus = {
        'service': 'Products',
        'status': response.success ? 'healthy' : 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': response.success ? null : response.message,
      };

      debugPrint('🛍️ ProductService: Health check completed');
      debugPrint('🛍️ ProductService: Status: ${healthStatus['status']}');
      debugPrint('🛍️ ProductService: Response time: ${duration}ms');

      return healthStatus;
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('🛍️ ProductService: Health check failed: $e');

      return {
        'service': 'Products',
        'status': 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': 'Health check failed: $e',
      };
    }
  }

  // ====================================================================
  // UTILITY AND HELPER METHODS
  // ====================================================================

  /// Get product status color for UI
  Color getProductStatusColor(ProductStatus status) {
    switch (status) {
      case ProductStatus.draft:
        return const Color(0xFF9E9E9E); // Grey
      case ProductStatus.active:
        return const Color(0xFF4CAF50); // Green
      case ProductStatus.inactive:
        return const Color(0xFFF44336); // Red
      case ProductStatus.outOfStock:
        return const Color(0xFFFF9800); // Orange
      case ProductStatus.discontinued:
        return const Color(0xFF795548); // Brown
    }
  }

  /// Get product type icon
  IconData getProductTypeIcon(ProductType type) {
    switch (type) {
      case ProductType.physical:
        return Prbal.barbell;
      case ProductType.digital:
        return Prbal.cloudDownload;
      case ProductType.service:
        return Prbal.handyman;
      case ProductType.subscription:
        return Prbal.subscriptions;
    }
  }

  /// Format currency amount
  String formatPrice(double price, String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      case 'EUR':
        return '€${price.toStringAsFixed(2)}';
      case 'GBP':
        return '£${price.toStringAsFixed(2)}';
      case 'INR':
        return '₹${price.toStringAsFixed(2)}';
      default:
        return '$currency ${price.toStringAsFixed(2)}';
    }
  }

  /// Format discount percentage
  String formatDiscountPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}% OFF';
  }

  /// Get stock status text
  String getStockStatusText(Product product) {
    if (product.isUnlimited) return 'Unlimited';
    if (product.stockQuantity == null) return 'Unknown';
    if (product.stockQuantity! <= 0) return 'Out of Stock';
    if (product.stockQuantity! <= 5) {
      return 'Low Stock (${product.stockQuantity})';
    }
    return 'In Stock (${product.stockQuantity})';
  }

  /// Get stock status color
  Color getStockStatusColor(Product product) {
    if (product.isUnlimited) return const Color(0xFF4CAF50); // Green
    if (product.stockQuantity == null) return const Color(0xFF9E9E9E); // Grey
    if (product.stockQuantity! <= 0) return const Color(0xFFF44336); // Red
    if (product.stockQuantity! <= 5) return const Color(0xFFFF9800); // Orange
    return const Color(0xFF4CAF50); // Green
  }
}
