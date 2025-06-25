import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'api_service.dart';

/// Payment status enumeration
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
  partialRefund;

  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.processing:
        return 'processing';
      case PaymentStatus.completed:
        return 'completed';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.cancelled:
        return 'cancelled';
      case PaymentStatus.refunded:
        return 'refunded';
      case PaymentStatus.partialRefund:
        return 'partial_refund';
    }
  }

  static PaymentStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'cancelled':
        return PaymentStatus.cancelled;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'partial_refund':
        return PaymentStatus.partialRefund;
      default:
        return PaymentStatus.pending;
    }
  }
}

/// Payment method enumeration
enum PaymentMethod {
  card,
  bankTransfer,
  wallet,
  cash,
  upi;

  String get value {
    switch (this) {
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
      case PaymentMethod.wallet:
        return 'wallet';
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.upi:
        return 'upi';
    }
  }

  static PaymentMethod fromString(String method) {
    switch (method.toLowerCase()) {
      case 'card':
        return PaymentMethod.card;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'wallet':
        return PaymentMethod.wallet;
      case 'cash':
        return PaymentMethod.cash;
      case 'upi':
        return PaymentMethod.upi;
      default:
        return PaymentMethod.card;
    }
  }
}

/// Payment model
class Payment {
  final String id;
  final String bookingId;
  final String? customerId;
  final String? providerId;
  final double amount;
  final double? refundedAmount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod method;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final String? transactionId;
  final Map<String, dynamic>? metadata;

  const Payment({
    required this.id,
    required this.bookingId,
    this.customerId,
    this.providerId,
    required this.amount,
    this.refundedAmount,
    required this.currency,
    required this.status,
    required this.method,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.transactionId,
    this.metadata,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      customerId: json['customer_id'] as String?,
      providerId: json['provider_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      refundedAmount: json['refunded_amount'] != null
          ? (json['refunded_amount'] as num).toDouble()
          : null,
      currency: json['currency'] as String,
      status: PaymentStatus.fromString(json['status'] as String),
      method: PaymentMethod.fromString(json['method'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      transactionId: json['transaction_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      if (customerId != null) 'customer_id': customerId,
      if (providerId != null) 'provider_id': providerId,
      'amount': amount,
      if (refundedAmount != null) 'refunded_amount': refundedAmount,
      'currency': currency,
      'status': status.value,
      'method': method.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
      if (transactionId != null) 'transaction_id': transactionId,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Create payment request model
class CreatePaymentRequest {
  final String bookingId;
  final double amount;
  final String currency;
  final PaymentMethod method;
  final Map<String, dynamic>? metadata;

  const CreatePaymentRequest({
    required this.bookingId,
    required this.amount,
    this.currency = 'USD',
    required this.method,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'amount': amount,
      'currency': currency,
      'method': method.value,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Refund request model
class RefundRequest {
  final double amount;
  final String reason;
  final Map<String, dynamic>? metadata;

  const RefundRequest({
    required this.amount,
    required this.reason,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'reason': reason,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Payment list response model
class PaymentListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Payment> results;

  const PaymentListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaymentListResponse.fromJson(Map<String, dynamic> json) {
    return PaymentListResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List)
          .map((payment) => Payment.fromJson(payment))
          .toList(),
    );
  }
}

/// Comprehensive Payment Service for Prbal app
/// Handles payment processing, transaction management, refunds, and payment methods
class PaymentService {
  final ApiService _apiService;

  PaymentService(this._apiService) {
    debugPrint('💳 PaymentService: Initializing payment service');
    debugPrint(
        '💳 PaymentService: Service will handle payments, transactions, and refunds');
  }

  // ====================================================================
  // PAYMENT MANAGEMENT
  // ====================================================================

  /// List payments with filtering and pagination
  /// Endpoint: GET /payments/
  Future<ApiResponse<PaymentListResponse>> listPayments({
    PaymentStatus? status,
    PaymentMethod? method,
    String? bookingId,
    String? customerId,
    String? providerId,
    String? ordering = '-created_at',
    int? limit,
    int? offset,
  }) async {
    final startTime = DateTime.now();
    debugPrint('💳 PaymentService: Listing payments');

    final queryParams = <String, String>{};
    if (status != null) {
      queryParams['status'] = status.value;
      debugPrint('💳 PaymentService: Filtering by status: ${status.value}');
    }
    if (method != null) {
      queryParams['method'] = method.value;
      debugPrint('💳 PaymentService: Filtering by method: ${method.value}');
    }
    if (bookingId != null) {
      queryParams['booking_id'] = bookingId;
    }
    if (customerId != null) {
      queryParams['customer_id'] = customerId;
    }
    if (providerId != null) {
      queryParams['provider_id'] = providerId;
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
          '💳 PaymentService: Making API call with query params: $queryParams');

      final response = await _apiService.get(
        '/payments/',
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) => PaymentListResponse.fromJson(data),
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.success && response.data != null) {
        final payments = response.data!.results;
        debugPrint(
            '💳 PaymentService: Successfully retrieved ${payments.length} payments in ${duration}ms');

        final totalAmount =
            payments.fold(0.0, (sum, payment) => sum + payment.amount);
        debugPrint(
            '💳 PaymentService: Total payment amount: \$${totalAmount.toStringAsFixed(2)}');

        return response;
      }

      debugPrint(
          '💳 PaymentService: Failed to fetch payments - ${response.message}');
      return ApiResponse<PaymentListResponse>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint(
          '💳 PaymentService: Error fetching payments (${duration}ms): $e');
      return ApiResponse<PaymentListResponse>(
        success: false,
        message: 'Error fetching payments: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Get payment details by ID
  /// Endpoint: GET /payments/{id}/
  Future<ApiResponse<Payment>> getPaymentDetails(String paymentId) async {
    debugPrint('💳 PaymentService: Getting payment details for ID: $paymentId');

    try {
      final response = await _apiService.get(
        '/payments/$paymentId/',
        fromJson: (data) => Payment.fromJson(data),
      );

      if (response.success && response.data != null) {
        final payment = response.data!;
        debugPrint('💳 PaymentService: Successfully retrieved payment');
        debugPrint(
            '💳 PaymentService: Amount: \$${payment.amount.toStringAsFixed(2)}');
        debugPrint('💳 PaymentService: Status: ${payment.status.value}');
        debugPrint('💳 PaymentService: Method: ${payment.method.value}');

        return response;
      }

      debugPrint(
          '💳 PaymentService: Failed to fetch payment details - ${response.message}');
      return ApiResponse<Payment>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💳 PaymentService: Error fetching payment details: $e');
      return ApiResponse<Payment>(
        success: false,
        message: 'Error fetching payment details: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Create a new payment
  /// Endpoint: POST /payments/
  Future<ApiResponse<Payment>> createPayment(
      CreatePaymentRequest request) async {
    debugPrint('💳 PaymentService: Creating new payment');
    debugPrint('💳 PaymentService: Booking ID: ${request.bookingId}');
    debugPrint(
        '💳 PaymentService: Amount: \$${request.amount.toStringAsFixed(2)} ${request.currency}');
    debugPrint('💳 PaymentService: Method: ${request.method.value}');

    try {
      final response = await _apiService.post(
        '/payments/',
        body: request.toJson(),
        fromJson: (data) => Payment.fromJson(data),
      );

      if (response.success && response.data != null) {
        final payment = response.data!;
        debugPrint(
            '💳 PaymentService: Payment created successfully: ${payment.id}');
        debugPrint('💳 PaymentService: Status: ${payment.status.value}');
        debugPrint(
            '💳 PaymentService: Transaction ID: ${payment.transactionId ?? 'N/A'}');

        return response;
      }

      debugPrint(
          '💳 PaymentService: Failed to create payment - ${response.message}');
      return ApiResponse<Payment>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💳 PaymentService: Error creating payment: $e');
      return ApiResponse<Payment>(
        success: false,
        message: 'Error creating payment: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Process payment (confirm payment)
  /// Endpoint: POST /payments/{id}/process/
  Future<ApiResponse<Payment>> processPayment(String paymentId,
      {Map<String, dynamic>? paymentData}) async {
    debugPrint('💳 PaymentService: Processing payment: $paymentId');

    try {
      final response = await _apiService.post(
        '/payments/$paymentId/process/',
        body: paymentData ?? {},
        fromJson: (data) => Payment.fromJson(data),
      );

      if (response.success && response.data != null) {
        final payment = response.data!;
        debugPrint('💳 PaymentService: Payment processed successfully');
        debugPrint('💳 PaymentService: Status: ${payment.status.value}');
        debugPrint(
            '💳 PaymentService: Completed at: ${payment.completedAt ?? 'Not yet completed'}');

        return response;
      }

      debugPrint(
          '💳 PaymentService: Failed to process payment - ${response.message}');
      return ApiResponse<Payment>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💳 PaymentService: Error processing payment: $e');
      return ApiResponse<Payment>(
        success: false,
        message: 'Error processing payment: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Cancel payment
  /// Endpoint: POST /payments/{id}/cancel/
  Future<ApiResponse<Payment>> cancelPayment(
      String paymentId, String reason) async {
    debugPrint('💳 PaymentService: Cancelling payment: $paymentId');
    debugPrint('💳 PaymentService: Reason: $reason');

    try {
      final response = await _apiService.post(
        '/payments/$paymentId/cancel/',
        body: {'reason': reason},
        fromJson: (data) => Payment.fromJson(data),
      );

      if (response.success) {
        debugPrint('💳 PaymentService: Payment cancelled successfully');
      } else {
        debugPrint(
            '💳 PaymentService: Failed to cancel payment - ${response.message}');
      }

      return response;
    } catch (e) {
      debugPrint('💳 PaymentService: Error cancelling payment: $e');
      return ApiResponse<Payment>(
        success: false,
        message: 'Error cancelling payment: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Refund payment
  /// Endpoint: POST /payments/{id}/refund/
  Future<ApiResponse<Payment>> refundPayment(
      String paymentId, RefundRequest request) async {
    debugPrint('💳 PaymentService: Processing refund for payment: $paymentId');
    debugPrint(
        '💳 PaymentService: Refund amount: \$${request.amount.toStringAsFixed(2)}');
    debugPrint('💳 PaymentService: Reason: ${request.reason}');

    try {
      final response = await _apiService.post(
        '/payments/$paymentId/refund/',
        body: request.toJson(),
        fromJson: (data) => Payment.fromJson(data),
      );

      if (response.success && response.data != null) {
        final payment = response.data!;
        debugPrint('💳 PaymentService: Refund processed successfully');
        debugPrint(
            '💳 PaymentService: Refunded amount: \$${payment.refundedAmount?.toStringAsFixed(2) ?? '0.00'}');

        return response;
      }

      debugPrint(
          '💳 PaymentService: Failed to process refund - ${response.message}');
      return ApiResponse<Payment>(
        success: false,
        message: response.message,
        statusCode: response.statusCode,
        time: DateTime.now(),
      );
    } catch (e) {
      debugPrint('💳 PaymentService: Error processing refund: $e');
      return ApiResponse<Payment>(
        success: false,
        message: 'Error processing refund: $e',
        statusCode: 500,
        time: DateTime.now(),
      );
    }
  }

  // ====================================================================
  // UTILITY AND HELPER METHODS
  // ====================================================================

  /// Get payment statistics for analytics
  Future<Map<String, dynamic>> getPaymentStatistics() async {
    debugPrint('💳 PaymentService: Generating payment statistics');

    try {
      final paymentsResponse = await listPayments();

      if (paymentsResponse.success && paymentsResponse.data != null) {
        final payments = paymentsResponse.data!.results;
        final stats = {
          'total_payments': payments.length,
          'total_amount': payments.fold(0.0, (sum, p) => sum + p.amount),
          'total_refunded':
              payments.fold(0.0, (sum, p) => sum + (p.refundedAmount ?? 0.0)),
          'by_status': <String, int>{},
          'by_method': <String, int>{},
          'success_rate': 0.0,
        };

        // Group by status and method
        for (final payment in payments) {
          final status = payment.status.value;
          final method = payment.method.value;

          final byStatus = stats['by_status'] as Map<String, int>;
          byStatus[status] = (byStatus[status] ?? 0) + 1;

          final byMethod = stats['by_method'] as Map<String, int>;
          byMethod[method] = (byMethod[method] ?? 0) + 1;
        }

        // Calculate success rate
        final completedPayments =
            payments.where((p) => p.status == PaymentStatus.completed).length;
        if (payments.isNotEmpty) {
          stats['success_rate'] = completedPayments / payments.length;
        }

        debugPrint('💳 PaymentService: Statistics generated successfully');
        debugPrint(
            '💳 PaymentService: Total payments: ${stats['total_payments']}');
        debugPrint(
            '💳 PaymentService: Success rate: ${(int.parse(stats['success_rate'].toString()) * 100).toStringAsFixed(1)}%');

        return stats;
      }
    } catch (e) {
      debugPrint('💳 PaymentService: Error generating statistics: $e');
    }

    return {'error': 'Failed to generate statistics'};
  }

  /// Check payment service health
  Future<Map<String, dynamic>> checkPaymentHealth() async {
    debugPrint('💳 PaymentService: Performing health check');

    final startTime = DateTime.now();
    try {
      // Test basic functionality by fetching payments
      final response = await listPayments(limit: 1);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      final healthStatus = {
        'service': 'Payments',
        'status': response.success ? 'healthy' : 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': response.success ? null : response.message,
      };

      debugPrint('💳 PaymentService: Health check completed');
      debugPrint('💳 PaymentService: Status: ${healthStatus['status']}');
      debugPrint('💳 PaymentService: Response time: ${duration}ms');

      return healthStatus;
    } catch (e) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('💳 PaymentService: Health check failed: $e');

      return {
        'service': 'Payments',
        'status': 'unhealthy',
        'response_time_ms': duration,
        'last_check': DateTime.now().toIso8601String(),
        'error': 'Health check failed: $e',
      };
    }
  }

  /// Get payment status color for UI
  Color getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return const Color(0xFFFFC107); // Amber
      case PaymentStatus.processing:
        return const Color(0xFF2196F3); // Blue
      case PaymentStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case PaymentStatus.failed:
        return const Color(0xFFF44336); // Red
      case PaymentStatus.cancelled:
        return const Color(0xFF9E9E9E); // Grey
      case PaymentStatus.refunded:
        return const Color(0xFFFF9800); // Orange
      case PaymentStatus.partialRefund:
        return const Color(0xFFFF5722); // Deep Orange
    }
  }

  /// Get payment method icon
  IconData getPaymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return Prbal.creditCard;
      case PaymentMethod.bankTransfer:
        return Prbal.accountBalance;
      case PaymentMethod.wallet:
        return Prbal.accountBalanceWallet;
      case PaymentMethod.cash:
        return Prbal.money;
      case PaymentMethod.upi:
        return Prbal.qrCode;
    }
  }

  /// Format currency amount
  String formatAmount(double amount, String currency) {
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
}
