import 'package:flutter/foundation.dart';

// ===== ENUMS =====

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
        debugPrint('⚠️ Unknown payment status: $status, defaulting to pending');
        return PaymentStatus.pending;
    }
  }

  /// Get payment status color for UI
  String get color {
    switch (this) {
      case PaymentStatus.pending:
        return '#FFC107'; // Amber
      case PaymentStatus.processing:
        return '#2196F3'; // Blue
      case PaymentStatus.completed:
        return '#4CAF50'; // Green
      case PaymentStatus.failed:
        return '#F44336'; // Red
      case PaymentStatus.cancelled:
        return '#9E9E9E'; // Grey
      case PaymentStatus.refunded:
        return '#FF9800'; // Orange
      case PaymentStatus.partialRefund:
        return '#FF5722'; // Deep Orange
    }
  }

  /// Get status display text
  String get displayText {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.cancelled:
        return 'Cancelled';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.partialRefund:
        return 'Partial Refund';
    }
  }

  @override
  String toString() =>
      'PaymentStatus.$name(value: $value, display: $displayText)';
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
        debugPrint('⚠️ Unknown payment method: $method, defaulting to card');
        return PaymentMethod.card;
    }
  }

  /// Get payment method display text
  String get displayText {
    switch (this) {
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.wallet:
        return 'Digital Wallet';
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.upi:
        return 'UPI';
    }
  }

  @override
  String toString() =>
      'PaymentMethod.$name(value: $value, display: $displayText)';
}

// ===== MAIN MODELS =====

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
    try {
      debugPrint('💳 Parsing Payment from JSON: ${json.keys.join(', ')}');

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
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing Payment from JSON: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      debugPrint('📋 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
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

    debugPrint('📤 Payment toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Get formatted amount with currency symbol
  String get formattedAmount {
    return formatCurrencyAmount(amount, currency);
  }

  /// Get formatted refunded amount
  String get formattedRefundedAmount {
    if (refundedAmount == null) return formatCurrencyAmount(0.0, currency);
    return formatCurrencyAmount(refundedAmount!, currency);
  }

  /// Get formatted creation date
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Get completion status
  bool get isCompleted => completedAt != null;

  /// Get pending amount (original - refunded)
  double get pendingAmount {
    return amount - (refundedAmount ?? 0.0);
  }

  /// Check if payment can be refunded
  bool get canBeRefunded {
    return status == PaymentStatus.completed && pendingAmount > 0;
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
      'Payment(id: $id, amount: $formattedAmount, status: ${status.displayText}, method: ${method.displayText})';
}

// ===== REQUEST MODELS =====

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
    final json = {
      'booking_id': bookingId,
      'amount': amount,
      'currency': currency,
      'method': method.value,
      if (metadata != null) 'metadata': metadata,
    };

    debugPrint('📤 CreatePaymentRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Get formatted amount
  String get formattedAmount {
    return Payment.formatCurrencyAmount(amount, currency);
  }

  @override
  String toString() =>
      'CreatePaymentRequest(bookingId: $bookingId, amount: $formattedAmount, method: ${method.displayText})';
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
    final json = {
      'amount': amount,
      'reason': reason,
      if (metadata != null) 'metadata': metadata,
    };

    debugPrint('📤 RefundRequest toJson: ${json.keys.join(', ')}');
    return json;
  }

  /// Get formatted amount with default currency
  String get formattedAmount {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  String toString() =>
      'RefundRequest(amount: $formattedAmount, reason: $reason)';
}

// ===== RESPONSE MODELS =====

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
    try {
      debugPrint(
          '💳 Parsing PaymentListResponse from JSON: count=${json['count']}, results_length=${(json['results'] as List?)?.length ?? 0}');

      return PaymentListResponse(
        count: json['count'] as int,
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List? ?? [])
            .map((payment) => Payment.fromJson(payment as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Error parsing PaymentListResponse from JSON: $e');
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
      'results': results.map((payment) => payment.toJson()).toList(),
    };

    debugPrint(
        '📤 PaymentListResponse toJson: count=$count, results_length=${results.length}');
    return json;
  }

  /// Check if there are more pages
  bool get hasNext => next != null && next!.isNotEmpty;

  /// Check if there are previous pages
  bool get hasPrevious => previous != null && previous!.isNotEmpty;

  /// Get total payment amount
  double get totalAmount {
    return results.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Get total refunded amount
  double get totalRefunded {
    return results.fold(
        0.0, (sum, payment) => sum + (payment.refundedAmount ?? 0.0));
  }

  /// Get payment statistics
  Map<String, dynamic> get statistics {
    final stats = <String, dynamic>{
      'total_payments': results.length,
      'total_amount': totalAmount,
      'total_refunded': totalRefunded,
      'by_status': <String, int>{},
      'by_method': <String, int>{},
      'success_rate': 0.0,
    };

    // Group by status and method
    for (final payment in results) {
      final status = payment.status.value;
      final method = payment.method.value;

      final byStatus = stats['by_status'] as Map<String, int>;
      byStatus[status] = (byStatus[status] ?? 0) + 1;

      final byMethod = stats['by_method'] as Map<String, int>;
      byMethod[method] = (byMethod[method] ?? 0) + 1;
    }

    // Calculate success rate
    final completedPayments =
        results.where((p) => p.status == PaymentStatus.completed).length;
    if (results.isNotEmpty) {
      stats['success_rate'] = completedPayments / results.length;
    }

    return stats;
  }

  @override
  String toString() =>
      'PaymentListResponse(count: $count, results: ${results.length}, totalAmount: \$${totalAmount.toStringAsFixed(2)}, hasNext: $hasNext)';
}
