import 'package:flutter/foundation.dart';

// ===== ENUMS =====

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
        debugPrint('⚠️ Unknown product status: $status, defaulting to draft');
        return ProductStatus.draft;
    }
  }

  /// Get product status color for UI
  String get color {
    switch (this) {
      case ProductStatus.draft:
        return '#9E9E9E'; // Grey
      case ProductStatus.active:
        return '#4CAF50'; // Green
      case ProductStatus.inactive:
        return '#F44336'; // Red
      case ProductStatus.outOfStock:
        return '#FF9800'; // Orange
      case ProductStatus.discontinued:
        return '#795548'; // Brown
    }
  }

  /// Get status display text
  String get displayText {
    switch (this) {
      case ProductStatus.draft:
        return 'Draft';
      case ProductStatus.active:
        return 'Active';
      case ProductStatus.inactive:
        return 'Inactive';
      case ProductStatus.outOfStock:
        return 'Out of Stock';
      case ProductStatus.discontinued:
        return 'Discontinued';
    }
  }

  @override
  String toString() =>
      'ProductStatus.$name(value: $value, display: $displayText)';
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
        debugPrint('⚠️ Unknown product type: $type, defaulting to service');
        return ProductType.service;
    }
  }

  /// Get product type display text
  String get displayText {
    switch (this) {
      case ProductType.physical:
        return 'Physical Product';
      case ProductType.digital:
        return 'Digital Product';
      case ProductType.service:
        return 'Service';
      case ProductType.subscription:
        return 'Subscription';
    }
  }

  @override
  String toString() =>
      'ProductType.$name(value: $value, display: $displayText)';
}

// ===== MAIN MODELS =====

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
    try {
      debugPrint('🛍️ Parsing Product from JSON: ${json.keys.join(', ')}');

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
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing Product from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
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

    debugPrint('📤 Product toJson: ${json.keys.join(', ')}');
    return json;
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

  /// Get formatted price with currency symbol
  String get formattedPrice {
    return formatCurrencyAmount(price, currency);
  }

  /// Get formatted effective price
  String get formattedEffectivePrice {
    return formatCurrencyAmount(effectivePrice, currency);
  }

  /// Get formatted discount percentage
  String get formattedDiscountPercentage {
    if (!hasDiscount) return '';
    return '${discountPercentage.toStringAsFixed(0)}% OFF';
  }

  /// Get stock status text
  String get stockStatusText {
    if (isUnlimited) return 'Unlimited';
    if (stockQuantity == null) return 'Unknown';
    if (stockQuantity! <= 0) return 'Out of Stock';
    if (stockQuantity! <= 5) {
      return 'Low Stock ($stockQuantity)';
    }
    return 'In Stock ($stockQuantity)';
  }

  /// Get stock status color
  String get stockStatusColor {
    if (isUnlimited) return '#4CAF50'; // Green
    if (stockQuantity == null) return '#9E9E9E'; // Grey
    if (stockQuantity! <= 0) return '#F44336'; // Red
    if (stockQuantity! <= 5) return '#FF9800'; // Orange
    return '#4CAF50'; // Green
  }

  /// Format currency amount based on currency type
  static String formatCurrencyAmount(double amount, String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      case 'INR':
        return '₹${amount.toStringAsFixed(2)}';
      default:
        return '$currency ${amount.toStringAsFixed(2)}';
    }
  }

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: $formattedPrice, status: ${status.displayText}, type: ${type.displayText})';
}

// ===== REQUEST MODELS =====

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
    final json = {
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

    debugPrint('📤 CreateProductRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Get formatted price
  String get formattedPrice {
    return Product.formatCurrencyAmount(price, currency);
  }

  @override
  String toString() =>
      'CreateProductRequest(name: $name, price: $formattedPrice, type: ${type.displayText})';
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

    debugPrint('📤 UpdateProductRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Get formatted price if available
  String? get formattedPrice {
    if (price == null) return null;
    return Product.formatCurrencyAmount(price!, currency ?? 'USD');
  }

  @override
  String toString() =>
      'UpdateProductRequest(name: $name, price: $formattedPrice, type: ${type?.displayText}, status: ${status?.displayText})';
}

// ===== RESPONSE MODELS =====

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
    try {
      debugPrint(
          '🛍️ Parsing ProductListResponse from JSON: count=${json['count']}, results_length=${(json['results'] as List?)?.length ?? 0}');

      return ProductListResponse(
        count: json['count'] as int,
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List? ?? [])
            .map((product) => Product.fromJson(product as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing ProductListResponse from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
      'count': count,
      if (next != null) 'next': next,
      if (previous != null) 'previous': previous,
      'results': results.map((product) => product.toJson()).toList(),
    };

    debugPrint(
        '📤 ProductListResponse toJson: count=$count, results_length=${results.length}');
    return json;
  }

  /// Check if there are more pages
  bool get hasNext => next != null && next!.isNotEmpty;

  /// Check if there are previous pages
  bool get hasPrevious => previous != null && previous!.isNotEmpty;

  /// Get featured products
  List<Product> get featuredProducts =>
      results.where((p) => p.isFeatured).toList();

  /// Get active products
  List<Product> get activeProducts =>
      results.where((p) => p.status == ProductStatus.active).toList();

  /// Get out of stock products
  List<Product> get outOfStockProducts =>
      results.where((p) => !p.isInStock).toList();

  /// Get average price
  double get averagePrice {
    if (results.isEmpty) return 0.0;
    return results.fold(0.0, (sum, p) => sum + p.price) / results.length;
  }

  /// Get average rating
  double get averageRating {
    if (results.isEmpty) return 0.0;
    return results.fold(0.0, (sum, p) => sum + p.rating) / results.length;
  }

  /// Get total sales
  int get totalSales {
    return results.fold(0, (sum, p) => sum + p.salesCount);
  }

  /// Get product analytics
  Map<String, dynamic> get analytics {
    final stats = <String, dynamic>{
      'total_products': results.length,
      'active_products': activeProducts.length,
      'featured_products': featuredProducts.length,
      'out_of_stock': outOfStockProducts.length,
      'average_price': averagePrice,
      'average_rating': averageRating,
      'total_sales': totalSales,
      'by_type': <String, int>{},
      'by_status': <String, int>{},
    };

    // Group by type and status
    for (final product in results) {
      final type = product.type.value;
      final status = product.status.value;

      final byType = stats['by_type'] as Map<String, int>;
      byType[type] = (byType[type] ?? 0) + 1;

      final byStatus = stats['by_status'] as Map<String, int>;
      byStatus[status] = (byStatus[status] ?? 0) + 1;
    }

    return stats;
  }

  @override
  String toString() =>
      'ProductListResponse(count: $count, results: ${results.length}, avgPrice: \$${averagePrice.toStringAsFixed(2)}, hasNext: $hasNext)';
}
