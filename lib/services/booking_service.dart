import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_service.dart';

/// Booking status enumeration
enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  disputed;

  String get value {
    switch (this) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.inProgress:
        return 'in_progress';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.disputed:
        return 'disputed';
    }
  }

  static BookingStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'in_progress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'disputed':
        return BookingStatus.disputed;
      default:
        return BookingStatus.pending;
    }
  }
}

/// User role enumeration for filtering
enum UserRole {
  provider,
  customer;

  String get value {
    switch (this) {
      case UserRole.provider:
        return 'provider';
      case UserRole.customer:
        return 'customer';
    }
  }
}

/// Cancellation reason enumeration
enum CancellationReason {
  customerRequest,
  providerUnavailable,
  weatherCondition,
  emergency,
  other;

  String get value {
    switch (this) {
      case CancellationReason.customerRequest:
        return 'customer_request';
      case CancellationReason.providerUnavailable:
        return 'provider_unavailable';
      case CancellationReason.weatherCondition:
        return 'weather_condition';
      case CancellationReason.emergency:
        return 'emergency';
      case CancellationReason.other:
        return 'other';
    }
  }
}

/// Calendar provider types
enum CalendarProvider {
  google,
  microsoft,
  apple;

  String get value {
    switch (this) {
      case CalendarProvider.google:
        return 'google';
      case CalendarProvider.microsoft:
        return 'microsoft';
      case CalendarProvider.apple:
        return 'apple';
    }
  }
}

/// Enhanced Booking model matching API structure
class Booking {
  final String id;
  final String service;
  final String? customer;
  final String? provider;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double amount;
  final String address;
  final double? latitude;
  final double? longitude;
  final String requirements;
  final String? notes;
  final BookingStatus status;
  final String? rescheduledReason;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? bidId;

  const Booking({
    required this.id,
    required this.service,
    this.customer,
    this.provider,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.amount,
    required this.address,
    this.latitude,
    this.longitude,
    required this.requirements,
    this.notes,
    required this.status,
    this.rescheduledReason,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.bidId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      service: json['service'] as String,
      customer: json['customer'] as String?,
      provider: json['provider'] as String?,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      amount: (json['amount'] as num).toDouble(),
      address: json['address'] as String,
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      requirements: json['requirements'] as String,
      notes: json['notes'] as String?,
      status: BookingStatus.fromString(json['status'] as String),
      rescheduledReason: json['rescheduled_reason'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      bidId: json['bid_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service,
      if (customer != null) 'customer': customer,
      if (provider != null) 'provider': provider,
      'booking_date': bookingDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'amount': amount.toString(),
      'address': address,
      if (latitude != null) 'latitude': latitude.toString(),
      if (longitude != null) 'longitude': longitude.toString(),
      'requirements': requirements,
      if (notes != null) 'notes': notes,
      'status': status.value,
      if (rescheduledReason != null) 'rescheduled_reason': rescheduledReason,
      if (cancellationReason != null) 'cancellation_reason': cancellationReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (bidId != null) 'bid_id': bidId,
    };
  }
}

/// Create booking request model
class CreateBookingRequest {
  final String service;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final double amount;
  final String address;
  final double? latitude;
  final double? longitude;
  final String requirements;
  final String? notes;
  final String? bidId;

  const CreateBookingRequest({
    required this.service,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.amount,
    required this.address,
    this.latitude,
    this.longitude,
    required this.requirements,
    this.notes,
    this.bidId,
  });

  Map<String, dynamic> toJson() {
    return {
      'service': service,
      'booking_date': bookingDate,
      'start_time': startTime,
      'end_time': endTime,
      'amount': amount.toString(),
      'address': address,
      if (latitude != null) 'latitude': latitude.toString(),
      if (longitude != null) 'longitude': longitude.toString(),
      'requirements': requirements,
      if (notes != null) 'notes': notes,
      if (bidId != null) 'bid_id': bidId,
    };
  }
}

/// Status update request model
class StatusUpdateRequest {
  final String status;
  final String? notes;

  const StatusUpdateRequest({
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Reschedule booking request model
class RescheduleBookingRequest {
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String rescheduledReason;

  const RescheduleBookingRequest({
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.rescheduledReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'booking_date': bookingDate,
      'start_time': startTime,
      'end_time': endTime,
      'rescheduled_reason': rescheduledReason,
    };
  }
}

/// Cancel booking request model
class CancelBookingRequest {
  final String cancellationReason;
  final String? notes;

  const CancelBookingRequest({
    required this.cancellationReason,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'cancellation_reason': cancellationReason,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Calendar sync request model
class CalendarSyncRequest {
  final String bookingId;
  final String provider;
  final String authToken;
  final String calendarId;
  final bool createReminder;
  final int reminderMinutes;

  const CalendarSyncRequest({
    required this.bookingId,
    required this.provider,
    required this.authToken,
    required this.calendarId,
    required this.createReminder,
    required this.reminderMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'provider': provider,
      'auth_token': authToken,
      'calendar_id': calendarId,
      'create_reminder': createReminder,
      'reminder_minutes': reminderMinutes,
    };
  }
}

/// Booking list response model
class BookingListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Booking> results;

  const BookingListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List).map((booking) => Booking.fromJson(booking)).toList(),
    );
  }
}

/// Enhanced Booking Service with all Postman collection APIs
class BookingService {
  final ApiService _apiService;

  BookingService(this._apiService);

  // ===== MAIN BOOKING OPERATIONS =====

  /// List bookings with comprehensive filtering
  Future<ApiResponse<BookingListResponse>> listBookings({
    UserRole? role,
    BookingStatus? status,
    String? service,
    String? customer,
    String? provider,
    String? search,
    String? ordering,
  }) async {
    final queryParams = <String, String>{};
    if (role != null) queryParams['role'] = role.value;
    if (status != null) queryParams['status'] = status.value;
    if (service != null) queryParams['service'] = service;
    if (customer != null) queryParams['customer'] = customer;
    if (provider != null) queryParams['provider'] = provider;
    if (search != null) queryParams['search'] = search;
    if (ordering != null) queryParams['ordering'] = ordering;

    debugPrint('🔍 Listing bookings with filters: $queryParams');

    return _apiService.get<BookingListResponse>(
      '/bookings/',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => BookingListResponse.fromJson(data),
    );
  }

  /// Create a new booking
  Future<ApiResponse<Booking>> createBooking(CreateBookingRequest request) async {
    debugPrint('📅 Creating new booking: ${request.toJson()}');

    return _apiService.post<Booking>(
      '/bookings/',
      body: request.toJson(),
      fromJson: (data) => Booking.fromJson(data),
    );
  }

  /// Create booking from bid
  Future<ApiResponse<Booking>> createBookingFromBid({
    required String bidId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    String? requirements,
  }) async {
    final body = {
      'bid_id': bidId,
      'booking_date': bookingDate,
      'start_time': startTime,
      'end_time': endTime,
      if (requirements != null) 'requirements': requirements,
    };

    debugPrint('📅 Creating booking from bid: $body');

    return _apiService.post<Booking>(
      '/bookings/',
      body: body,
      fromJson: (data) => Booking.fromJson(data),
    );
  }

  /// Retrieve a specific booking
  Future<ApiResponse<Booking>> getBooking(String bookingId) async {
    debugPrint('📋 Retrieving booking: $bookingId');

    return _apiService.get<Booking>(
      '/bookings/$bookingId/',
      fromJson: (data) => Booking.fromJson(data),
    );
  }

  /// Update booking status
  Future<ApiResponse<Booking>> updateBookingStatus(
    String bookingId,
    StatusUpdateRequest request,
  ) async {
    debugPrint('🔄 Updating booking status: $bookingId -> ${request.toJson()}');

    return _apiService.patch<Booking>(
      '/bookings/$bookingId/status/',
      body: request.toJson(),
      fromJson: (data) => Booking.fromJson(data),
    );
  }

  /// Reschedule booking
  Future<ApiResponse<Booking>> rescheduleBooking(
    String bookingId,
    RescheduleBookingRequest request,
  ) async {
    debugPrint('🕐 Rescheduling booking: $bookingId -> ${request.toJson()}');

    return _apiService.patch<Booking>(
      '/bookings/$bookingId/reschedule/',
      body: request.toJson(),
      fromJson: (data) => Booking.fromJson(data),
    );
  }

  /// Cancel booking
  Future<ApiResponse<Booking>> cancelBooking(
    String bookingId,
    CancelBookingRequest request,
  ) async {
    debugPrint('❌ Canceling booking: $bookingId -> ${request.toJson()}');

    return _apiService.post<Booking>(
      '/bookings/$bookingId/cancel/',
      body: request.toJson(),
      fromJson: (data) => Booking.fromJson(data),
    );
  }

  /// List provider bookings
  Future<ApiResponse<BookingListResponse>> listProviderBookings({
    BookingStatus? status,
    String? ordering = '-created_at',
  }) async {
    return listBookings(
      role: UserRole.provider,
      status: status,
      ordering: ordering,
    );
  }

  /// List customer bookings
  Future<ApiResponse<BookingListResponse>> listCustomerBookings({
    BookingStatus? status,
    String? ordering = '-created_at',
  }) async {
    return listBookings(
      role: UserRole.customer,
      status: status,
      ordering: ordering,
    );
  }

  /// Search bookings
  Future<ApiResponse<BookingListResponse>> searchBookings({
    required String searchTerm,
    BookingStatus? status,
    String? ordering = '-booking_date',
  }) async {
    return listBookings(
      search: searchTerm,
      status: status,
      ordering: ordering,
    );
  }

  // ===== CALENDAR INTEGRATION =====

  /// Sync booking to external calendar
  Future<ApiResponse<Map<String, dynamic>>> syncBookingToCalendar(
    CalendarSyncRequest request,
  ) async {
    debugPrint('📅 Syncing booking to calendar: ${request.toJson()}');

    return _apiService.post<Map<String, dynamic>>(
      '/bookings/calendar/',
      body: request.toJson(),
      fromJson: (data) => data,
    );
  }

  // ===== ROLE-BASED STATUS UPDATES =====

  /// Customer: Confirm booking
  Future<ApiResponse<Booking>> customerConfirmBooking(String bookingId) async {
    debugPrint('✅ Customer confirming booking: $bookingId');

    return updateBookingStatus(
      bookingId,
      const StatusUpdateRequest(
        status: 'confirmed',
        notes: 'Booking confirmed by customer',
      ),
    );
  }

  /// Provider: Start service
  Future<ApiResponse<Booking>> providerStartService(String bookingId) async {
    debugPrint('🚀 Provider starting service: $bookingId');

    return updateBookingStatus(
      bookingId,
      const StatusUpdateRequest(
        status: 'in_progress',
        notes: 'Service started by provider',
      ),
    );
  }

  /// Provider: Complete service
  Future<ApiResponse<Booking>> providerCompleteService(String bookingId) async {
    debugPrint('✅ Provider completing service: $bookingId');

    return updateBookingStatus(
      bookingId,
      const StatusUpdateRequest(
        status: 'completed',
        notes: 'Service completed successfully',
      ),
    );
  }

  /// Customer: Mark as disputed
  Future<ApiResponse<Booking>> customerMarkDisputed(String bookingId, String reason) async {
    debugPrint('⚠️ Customer marking as disputed: $bookingId');

    return updateBookingStatus(
      bookingId,
      StatusUpdateRequest(
        status: 'disputed',
        notes: reason,
      ),
    );
  }

  /// Provider: Mark as disputed
  Future<ApiResponse<Booking>> providerMarkDisputed(String bookingId, String reason) async {
    debugPrint('⚠️ Provider marking as disputed: $bookingId');

    return updateBookingStatus(
      bookingId,
      StatusUpdateRequest(
        status: 'disputed',
        notes: reason,
      ),
    );
  }

  // ===== ADMIN OPERATIONS =====

  /// Admin: List all bookings
  Future<ApiResponse<BookingListResponse>> adminListAllBookings({
    BookingStatus? status,
    String? service,
    String? ordering = '-created_at',
  }) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status.value;
    if (service != null) queryParams['service'] = service;
    if (ordering != null) queryParams['ordering'] = ordering;

    debugPrint('👤 Admin listing all bookings with filters: $queryParams');

    return _apiService.get<BookingListResponse>(
      '/bookings/',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => BookingListResponse.fromJson(data),
    );
  }

  /// Admin: List disputed bookings
  Future<ApiResponse<BookingListResponse>> adminListDisputedBookings({
    String? ordering = '-created_at',
  }) async {
    return adminListAllBookings(
      status: BookingStatus.disputed,
      ordering: ordering,
    );
  }

  /// Admin: Force status update
  Future<ApiResponse<Booking>> adminForceStatusUpdate(
    String bookingId,
    String status,
    String reason,
  ) async {
    debugPrint('🔧 Admin forcing status update: $bookingId -> $status');

    return updateBookingStatus(
      bookingId,
      StatusUpdateRequest(
        status: status,
        notes: reason,
      ),
    );
  }

  /// Admin: View booking details (same as regular getBooking)
  Future<ApiResponse<Booking>> adminViewBookingDetails(String bookingId) async {
    debugPrint('👤 Admin viewing booking details: $bookingId');

    return getBooking(bookingId);
  }

  // ===== UTILITY METHODS =====

  /// Get booking status color for UI
  static String getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return '#FFA500'; // Orange
      case BookingStatus.confirmed:
        return '#4CAF50'; // Green
      case BookingStatus.inProgress:
        return '#2196F3'; // Blue
      case BookingStatus.completed:
        return '#8BC34A'; // Light Green
      case BookingStatus.cancelled:
        return '#F44336'; // Red
      case BookingStatus.disputed:
        return '#FF5722'; // Deep Orange
    }
  }

  /// Get status display text
  static String getStatusDisplayText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.disputed:
        return 'Disputed';
    }
  }

  /// Validate booking time
  static bool isValidBookingTime(DateTime bookingDate, String startTime, String endTime) {
    try {
      final start = DateTime.parse('${bookingDate.toIso8601String().split('T')[0]} $startTime:00');
      final end = DateTime.parse('${bookingDate.toIso8601String().split('T')[0]} $endTime:00');

      return end.isAfter(start) && bookingDate.isAfter(DateTime.now().subtract(const Duration(days: 1)));
    } catch (e) {
      debugPrint('❌ Invalid booking time format: $e');
      return false;
    }
  }
}

/// Provider for BookingService
final bookingServiceProvider = Provider<BookingService>((ref) {
  final apiService = ApiService();
  return BookingService(apiService);
});

/// Provider for booking list with filters
final bookingListProvider = FutureProvider.family<BookingListResponse, Map<String, dynamic>?>((ref, filters) async {
  final bookingService = ref.read(bookingServiceProvider);

  final response = await bookingService.listBookings(
    role: filters?['role'] != null ? UserRole.values.firstWhere((e) => e.value == filters!['role']) : null,
    status: filters?['status'] != null ? BookingStatus.values.firstWhere((e) => e.value == filters!['status']) : null,
    service: filters?['service'],
    customer: filters?['customer'],
    provider: filters?['provider'],
    search: filters?['search'],
    ordering: filters?['ordering'],
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
});

/// Provider for single booking
final bookingProvider = FutureProvider.family<Booking, String>((ref, bookingId) async {
  final bookingService = ref.read(bookingServiceProvider);

  final response = await bookingService.getBooking(bookingId);

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
});

/// Provider for provider bookings
final providerBookingsProvider =
    FutureProvider.family<BookingListResponse, Map<String, dynamic>?>((ref, filters) async {
  final bookingService = ref.read(bookingServiceProvider);

  final response = await bookingService.listProviderBookings(
    status: filters?['status'] != null ? BookingStatus.values.firstWhere((e) => e.value == filters!['status']) : null,
    ordering: filters?['ordering'] ?? '-created_at',
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
});

/// Provider for customer bookings
final customerBookingsProvider =
    FutureProvider.family<BookingListResponse, Map<String, dynamic>?>((ref, filters) async {
  final bookingService = ref.read(bookingServiceProvider);

  final response = await bookingService.listCustomerBookings(
    status: filters?['status'] != null ? BookingStatus.values.firstWhere((e) => e.value == filters!['status']) : null,
    ordering: filters?['ordering'] ?? '-created_at',
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
});
