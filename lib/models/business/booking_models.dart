import 'package:flutter/foundation.dart';

// ===== ENUMS =====

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
        debugPrint('⚠️ Unknown booking status: $status, defaulting to pending');
        return BookingStatus.pending;
    }
  }

  /// Get booking status color for UI
  String get color {
    switch (this) {
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
  String get displayText {
    switch (this) {
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

  @override
  String toString() =>
      'BookingStatus.$name(value: $value, display: $displayText)';
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

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'provider':
        return UserRole.provider;
      case 'customer':
        return UserRole.customer;
      default:
        debugPrint('⚠️ Unknown user role: $role, defaulting to customer');
        return UserRole.customer;
    }
  }

  @override
  String toString() => 'UserRole.$name(value: $value)';
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

  static CancellationReason fromString(String reason) {
    switch (reason.toLowerCase()) {
      case 'customer_request':
        return CancellationReason.customerRequest;
      case 'provider_unavailable':
        return CancellationReason.providerUnavailable;
      case 'weather_condition':
        return CancellationReason.weatherCondition;
      case 'emergency':
        return CancellationReason.emergency;
      case 'other':
        return CancellationReason.other;
      default:
        debugPrint(
            '⚠️ Unknown cancellation reason: $reason, defaulting to other');
        return CancellationReason.other;
    }
  }

  @override
  String toString() => 'CancellationReason.$name(value: $value)';
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

  static CalendarProvider fromString(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return CalendarProvider.google;
      case 'microsoft':
        return CalendarProvider.microsoft;
      case 'apple':
        return CalendarProvider.apple;
      default:
        debugPrint(
            '⚠️ Unknown calendar provider: $provider, defaulting to google');
        return CalendarProvider.google;
    }
  }

  @override
  String toString() => 'CalendarProvider.$name(value: $value)';
}

// ===== MAIN MODELS =====

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
    try {
      debugPrint('📊 Parsing Booking from JSON: ${json.keys.join(', ')}');

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
        latitude: json['latitude'] != null
            ? double.tryParse(json['latitude'].toString())
            : null,
        longitude: json['longitude'] != null
            ? double.tryParse(json['longitude'].toString())
            : null,
        requirements: json['requirements'] as String,
        notes: json['notes'] as String?,
        status: BookingStatus.fromString(json['status'] as String),
        rescheduledReason: json['rescheduled_reason'] as String?,
        cancellationReason: json['cancellation_reason'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        bidId: json['bid_id'] as String?,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing Booking from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
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

    debugPrint('📤 Booking toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Validate booking time
  bool get isValidBookingTime {
    try {
      final start = DateTime.parse(
          '${bookingDate.toIso8601String().split('T')[0]} $startTime:00');
      final end = DateTime.parse(
          '${bookingDate.toIso8601String().split('T')[0]} $endTime:00');

      return end.isAfter(start) &&
          bookingDate.isAfter(DateTime.now().subtract(const Duration(days: 1)));
    } catch (e) {
      debugPrint('❌ Invalid booking time format: $e');
      return false;
    }
  }

  /// Get formatted date string
  String get formattedDate {
    return '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
  }

  /// Get formatted time range
  String get formattedTimeRange {
    return '$startTime - $endTime';
  }

  @override
  String toString() =>
      'Booking(id: $id, service: $service, status: ${status.displayText}, date: $formattedDate, time: $formattedTimeRange)';
}

// ===== REQUEST MODELS =====

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
    final json = {
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

    debugPrint('📤 CreateBookingRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  @override
  String toString() =>
      'CreateBookingRequest(service: $service, date: $bookingDate, time: $startTime-$endTime, amount: $amount)';
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
    final json = {
      'status': status,
      if (notes != null) 'notes': notes,
    };

    debugPrint('📤 StatusUpdateRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  @override
  String toString() => 'StatusUpdateRequest(status: $status, notes: $notes)';
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
    final json = {
      'booking_date': bookingDate,
      'start_time': startTime,
      'end_time': endTime,
      'rescheduled_reason': rescheduledReason,
    };

    debugPrint('📤 RescheduleBookingRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  @override
  String toString() =>
      'RescheduleBookingRequest(date: $bookingDate, time: $startTime-$endTime, reason: $rescheduledReason)';
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
    final json = {
      'cancellation_reason': cancellationReason,
      if (notes != null) 'notes': notes,
    };

    debugPrint('📤 CancelBookingRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  @override
  String toString() =>
      'CancelBookingRequest(reason: $cancellationReason, notes: $notes)';
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
    final json = {
      'booking_id': bookingId,
      'provider': provider,
      'auth_token': authToken,
      'calendar_id': calendarId,
      'create_reminder': createReminder,
      'reminder_minutes': reminderMinutes,
    };

    debugPrint('📤 CalendarSyncRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  @override
  String toString() =>
      'CalendarSyncRequest(bookingId: $bookingId, provider: $provider, reminder: $createReminder)';
}

// ===== RESPONSE MODELS =====

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
    try {
      debugPrint(
          '📊 Parsing BookingListResponse from JSON: count=${json['count']}, results_length=${(json['results'] as List?)?.length ?? 0}');

      return BookingListResponse(
        count: json['count'] as int,
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List? ?? [])
            .map((booking) => Booking.fromJson(booking as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing BookingListResponse from JSON: $e');
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
      'results': results.map((booking) => booking.toJson()).toList(),
    };

    debugPrint(
        '📤 BookingListResponse toJson: count=$count, results_length=${results.length}');
    return json;
  }

  /// Check if there are more pages
  bool get hasNext => next != null && next!.isNotEmpty;

  /// Check if there are previous pages
  bool get hasPrevious => previous != null && previous!.isNotEmpty;

  @override
  String toString() =>
      'BookingListResponse(count: $count, results: ${results.length}, hasNext: $hasNext, hasPrevious: $hasPrevious)';
}
