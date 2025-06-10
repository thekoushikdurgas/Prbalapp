import 'api_service.dart';

/// Service model matching API structure
class Service {
  final String id;
  final String title;
  final String description;
  final String category;
  final String providerId;
  final String providerName;
  final double price;
  final String? imageUrl;
  final bool isActive;
  final bool isFeatured;
  final double rating;
  final int reviewCount;
  final String location;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.providerId,
    required this.providerName,
    required this.price,
    this.imageUrl,
    this.isActive = true,
    this.isFeatured = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.location,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      providerId: json['provider_id'] as String,
      providerName: json['provider_name'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      location: json['location'] as String,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'provider_id': providerId,
      'provider_name': providerName,
      'price': price,
      'image_url': imageUrl,
      'is_active': isActive,
      'is_featured': isFeatured,
      'rating': rating,
      'review_count': reviewCount,
      'location': location,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Booking model matching API structure
class Booking {
  final String id;
  final String serviceId;
  final String customerId;
  final String providerId;
  final String
      status; // 'pending', 'confirmed', 'in_progress', 'completed', 'cancelled'
  final DateTime scheduledDate;
  final String customerNotes;
  final String? providerNotes;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.serviceId,
    required this.customerId,
    required this.providerId,
    required this.status,
    required this.scheduledDate,
    required this.customerNotes,
    this.providerNotes,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      customerId: json['customer_id'] as String,
      providerId: json['provider_id'] as String,
      status: json['status'] as String,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      customerNotes: json['customer_notes'] as String? ?? '',
      providerNotes: json['provider_notes'] as String?,
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'customer_id': customerId,
      'provider_id': providerId,
      'status': status,
      'scheduled_date': scheduledDate.toIso8601String(),
      'customer_notes': customerNotes,
      'provider_notes': providerNotes,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Service Management API calls
class ServiceManagementService {
  final ApiService _apiService;

  ServiceManagementService(this._apiService);

  // === SERVICE METHODS ===

  /// Get all services with optional filters
  Future<ApiResponse<List<Service>>> getServices({
    String? category,
    String? location,
    bool? isFeatured,
    String? search,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{};

    if (category != null) queryParams['category'] = category;
    if (location != null) queryParams['location'] = location;
    if (isFeatured != null) queryParams['is_featured'] = isFeatured.toString();
    if (search != null) queryParams['search'] = search;
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Service>>(
      '/services/',
      queryParameters: queryParams,
      fromJson: (data) {
        final results = data['results'] as List<dynamic>? ??
            data['services'] as List<dynamic>?;
        if (results != null) {
          return results
              .map((json) => Service.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return <Service>[];
      },
    );
  }

  /// Get service by ID
  Future<ApiResponse<Service>> getService(String serviceId) async {
    return _apiService.get<Service>(
      '/services/$serviceId/',
      fromJson: (data) =>
          Service.fromJson(data['service'] as Map<String, dynamic>),
    );
  }

  /// Create new service (for providers)
  Future<ApiResponse<Service>> createService({
    required String title,
    required String description,
    required String category,
    required double price,
    required String location,
    String? imageUrl,
    List<String>? tags,
    bool isFeatured = false,
  }) async {
    return _apiService.post<Service>(
      '/services/',
      body: {
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'location': location,
        if (imageUrl != null) 'image_url': imageUrl,
        if (tags != null) 'tags': tags,
        'is_featured': isFeatured,
      },
      fromJson: (data) =>
          Service.fromJson(data['service'] as Map<String, dynamic>),
    );
  }

  /// Update service (for providers)
  Future<ApiResponse<Service>> updateService(
    String serviceId, {
    String? title,
    String? description,
    String? category,
    double? price,
    String? location,
    String? imageUrl,
    List<String>? tags,
    bool? isActive,
    bool? isFeatured,
  }) async {
    return _apiService.patch<Service>(
      '/services/$serviceId/',
      body: {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (category != null) 'category': category,
        if (price != null) 'price': price,
        if (location != null) 'location': location,
        if (imageUrl != null) 'image_url': imageUrl,
        if (tags != null) 'tags': tags,
        if (isActive != null) 'is_active': isActive,
        if (isFeatured != null) 'is_featured': isFeatured,
      },
      fromJson: (data) =>
          Service.fromJson(data['service'] as Map<String, dynamic>),
    );
  }

  /// Delete service (for providers)
  Future<ApiResponse<Map<String, dynamic>>> deleteService(
      String serviceId) async {
    return _apiService.delete<Map<String, dynamic>>(
      '/services/$serviceId/',
      fromJson: (data) => data,
    );
  }

  /// Get provider's services
  Future<ApiResponse<List<Service>>> getProviderServices({
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Service>>(
      '/services/provider/',
      queryParameters: queryParams,
      fromJson: (data) {
        final results = data['results'] as List<dynamic>? ??
            data['services'] as List<dynamic>?;
        if (results != null) {
          return results
              .map((json) => Service.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return <Service>[];
      },
    );
  }

  // === BOOKING METHODS ===

  /// Get all bookings for current user
  Future<ApiResponse<List<Booking>>> getBookings({
    String? status,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Booking>>(
      '/bookings/',
      queryParameters: queryParams,
      fromJson: (data) {
        final results = data['results'] as List<dynamic>? ??
            data['bookings'] as List<dynamic>?;
        if (results != null) {
          return results
              .map((json) => Booking.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return <Booking>[];
      },
    );
  }

  /// Get booking by ID
  Future<ApiResponse<Booking>> getBooking(String bookingId) async {
    return _apiService.get<Booking>(
      '/bookings/$bookingId/',
      fromJson: (data) =>
          Booking.fromJson(data['booking'] as Map<String, dynamic>),
    );
  }

  /// Create new booking
  Future<ApiResponse<Booking>> createBooking({
    required String serviceId,
    required DateTime scheduledDate,
    required String customerNotes,
  }) async {
    return _apiService.post<Booking>(
      '/bookings/',
      body: {
        'service_id': serviceId,
        'scheduled_date': scheduledDate.toIso8601String(),
        'customer_notes': customerNotes,
      },
      fromJson: (data) =>
          Booking.fromJson(data['booking'] as Map<String, dynamic>),
    );
  }

  /// Update booking status (for providers)
  Future<ApiResponse<Booking>> updateBookingStatus(
    String bookingId, {
    required String status,
    String? providerNotes,
  }) async {
    return _apiService.patch<Booking>(
      '/bookings/$bookingId/status/',
      body: {
        'status': status,
        if (providerNotes != null) 'provider_notes': providerNotes,
      },
      fromJson: (data) =>
          Booking.fromJson(data['booking'] as Map<String, dynamic>),
    );
  }

  /// Reschedule booking
  Future<ApiResponse<Booking>> rescheduleBooking(
    String bookingId, {
    required DateTime newScheduledDate,
    String? reason,
  }) async {
    return _apiService.patch<Booking>(
      '/bookings/$bookingId/reschedule/',
      body: {
        'new_scheduled_date': newScheduledDate.toIso8601String(),
        if (reason != null) 'reason': reason,
      },
      fromJson: (data) =>
          Booking.fromJson(data['booking'] as Map<String, dynamic>),
    );
  }

  /// Cancel booking
  Future<ApiResponse<Booking>> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    return _apiService.patch<Booking>(
      '/bookings/$bookingId/cancel/',
      body: {
        if (reason != null) 'reason': reason,
      },
      fromJson: (data) =>
          Booking.fromJson(data['booking'] as Map<String, dynamic>),
    );
  }

  /// Get provider bookings
  Future<ApiResponse<List<Booking>>> getProviderBookings({
    String? status,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Booking>>(
      '/bookings/provider/',
      queryParameters: queryParams,
      fromJson: (data) {
        final results = data['results'] as List<dynamic>? ??
            data['bookings'] as List<dynamic>?;
        if (results != null) {
          return results
              .map((json) => Booking.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return <Booking>[];
      },
    );
  }

  // === CATEGORY METHODS ===

  /// Get service categories
  Future<ApiResponse<List<Map<String, dynamic>>>> getCategories() async {
    return _apiService.get<List<Map<String, dynamic>>>(
      '/services/categories/',
      fromJson: (data) {
        final categories = data['categories'] as List<dynamic>?;
        if (categories != null) {
          return categories.cast<Map<String, dynamic>>();
        }
        return <Map<String, dynamic>>[];
      },
    );
  }

  /// Get featured services
  Future<ApiResponse<List<Service>>> getFeaturedServices({
    int? limit,
    String? location,
  }) async {
    final queryParams = <String, String>{
      'is_featured': 'true',
    };
    if (limit != null) queryParams['limit'] = limit.toString();
    if (location != null) queryParams['location'] = location;

    return _apiService.get<List<Service>>(
      '/services/',
      queryParameters: queryParams,
      fromJson: (data) {
        final results = data['results'] as List<dynamic>? ??
            data['services'] as List<dynamic>?;
        if (results != null) {
          return results
              .map((json) => Service.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return <Service>[];
      },
    );
  }

  /// Search services
  Future<ApiResponse<List<Service>>> searchServices({
    required String query,
    String? category,
    String? location,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{
      'search': query,
    };
    if (category != null) queryParams['category'] = category;
    if (location != null) queryParams['location'] = location;
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    return _apiService.get<List<Service>>(
      '/services/search/',
      queryParameters: queryParams,
      fromJson: (data) {
        final results = data['results'] as List<dynamic>? ??
            data['services'] as List<dynamic>?;
        if (results != null) {
          return results
              .map((json) => Service.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return <Service>[];
      },
    );
  }
}
