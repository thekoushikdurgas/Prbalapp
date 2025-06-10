import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Payment status enumeration
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
  disputed;

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
      case PaymentStatus.disputed:
        return 'disputed';
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
      case 'disputed':
        return PaymentStatus.disputed;
      default:
        return PaymentStatus.pending;
    }
  }
}

/// Payment method enumeration
enum PaymentMethod {
  creditCard,
  debitCard,
  bankTransfer,
  wallet,
  upi,
  netBanking;

  String get value {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'credit_card';
      case PaymentMethod.debitCard:
        return 'debit_card';
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
      case PaymentMethod.wallet:
        return 'wallet';
      case PaymentMethod.upi:
        return 'upi';
      case PaymentMethod.netBanking:
        return 'net_banking';
    }
  }

  static PaymentMethod fromString(String method) {
    switch (method.toLowerCase()) {
      case 'credit_card':
        return PaymentMethod.creditCard;
      case 'debit_card':
        return PaymentMethod.debitCard;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'wallet':
        return PaymentMethod.wallet;
      case 'upi':
        return PaymentMethod.upi;
      case 'net_banking':
        return PaymentMethod.netBanking;
      default:
        return PaymentMethod.creditCard;
    }
  }
}

/// Payout status enumeration
enum PayoutStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled;

  String get value {
    switch (this) {
      case PayoutStatus.pending:
        return 'pending';
      case PayoutStatus.processing:
        return 'processing';
      case PayoutStatus.completed:
        return 'completed';
      case PayoutStatus.failed:
        return 'failed';
      case PayoutStatus.cancelled:
        return 'cancelled';
    }
  }

  static PayoutStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PayoutStatus.pending;
      case 'processing':
        return PayoutStatus.processing;
      case 'completed':
        return PayoutStatus.completed;
      case 'failed':
        return PayoutStatus.failed;
      case 'cancelled':
        return PayoutStatus.cancelled;
      default:
        return PayoutStatus.pending;
    }
  }
}

/// Payment account type enumeration
enum PaymentAccountType {
  stripe,
  razorpay,
  paypal,
  paytm,
  phonepe,
  gpay;

  String get value {
    switch (this) {
      case PaymentAccountType.stripe:
        return 'stripe';
      case PaymentAccountType.razorpay:
        return 'razorpay';
      case PaymentAccountType.paypal:
        return 'paypal';
      case PaymentAccountType.paytm:
        return 'paytm';
      case PaymentAccountType.phonepe:
        return 'phonepe';
      case PaymentAccountType.gpay:
        return 'gpay';
    }
  }

  static PaymentAccountType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'stripe':
        return PaymentAccountType.stripe;
      case 'razorpay':
        return PaymentAccountType.razorpay;
      case 'paypal':
        return PaymentAccountType.paypal;
      case 'paytm':
        return PaymentAccountType.paytm;
      case 'phonepe':
        return PaymentAccountType.phonepe;
      case 'gpay':
        return PaymentAccountType.gpay;
      default:
        return PaymentAccountType.stripe;
    }
  }
}

/// Payment role enumeration
enum PaymentRole {
  payer,
  payee;

  String get value {
    switch (this) {
      case PaymentRole.payer:
        return 'payer';
      case PaymentRole.payee:
        return 'payee';
    }
  }

  static PaymentRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'payer':
        return PaymentRole.payer;
      case 'payee':
        return PaymentRole.payee;
      default:
        return PaymentRole.payer;
    }
  }
}

/// Payment model
class Payment {
  final String id;
  final String bookingId;
  final String customerId;
  final String providerId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod method;
  final String? transactionId;
  final String? gatewayPaymentId;
  final Map<String, dynamic>? gatewayResponse;
  final double? platformFee;
  final double? providerAmount;
  final DateTime? paymentDate;
  final DateTime? processingAt;
  final DateTime? completedAt;
  final String? failureReason;
  final String? notes;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.providerId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    this.transactionId,
    this.gatewayPaymentId,
    this.gatewayResponse,
    this.platformFee,
    this.providerAmount,
    this.paymentDate,
    this.processingAt,
    this.completedAt,
    this.failureReason,
    this.notes,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      customerId: json['customer_id'] as String,
      providerId: json['provider_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      status: PaymentStatus.fromString(json['status'] as String),
      method: PaymentMethod.fromString(json['payment_method'] as String),
      transactionId: json['transaction_id'] as String?,
      gatewayPaymentId: json['gateway_payment_id'] as String?,
      gatewayResponse: json['gateway_response'] as Map<String, dynamic>?,
      platformFee: (json['platform_fee'] as num?)?.toDouble(),
      providerAmount: (json['provider_amount'] as num?)?.toDouble(),
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'] as String)
          : null,
      processingAt: json['processing_at'] != null
          ? DateTime.parse(json['processing_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      failureReason: json['failure_reason'] as String?,
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'customer_id': customerId,
      'provider_id': providerId,
      'amount': amount,
      'currency': currency,
      'status': status.value,
      'payment_method': method.value,
      if (transactionId != null) 'transaction_id': transactionId,
      if (gatewayPaymentId != null) 'gateway_payment_id': gatewayPaymentId,
      if (gatewayResponse != null) 'gateway_response': gatewayResponse,
      if (platformFee != null) 'platform_fee': platformFee,
      if (providerAmount != null) 'provider_amount': providerAmount,
      if (paymentDate != null) 'payment_date': paymentDate!.toIso8601String(),
      if (processingAt != null)
        'processing_at': processingAt!.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
      if (failureReason != null) 'failure_reason': failureReason,
      if (notes != null) 'notes': notes,
      if (metadata != null) 'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Payment initiation request model
class PaymentInitiationRequest {
  final String bookingId;
  final String paymentMethod;
  final bool savePaymentMethod;

  const PaymentInitiationRequest({
    required this.bookingId,
    required this.paymentMethod,
    this.savePaymentMethod = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'payment_method': paymentMethod,
      'save_payment_method': savePaymentMethod,
    };
  }
}

/// Payment confirmation request model
class PaymentConfirmationRequest {
  final String paymentId;
  final String transactionId;

  const PaymentConfirmationRequest({
    required this.paymentId,
    required this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'transaction_id': transactionId,
    };
  }
}

/// Payment account model
class PaymentAccount {
  final String id;
  final String providerId;
  final PaymentAccountType accountType;
  final String accountId;
  final bool isActive;
  final bool isVerified;
  final Map<String, dynamic> accountDetails;
  final DateTime? verifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentAccount({
    required this.id,
    required this.providerId,
    required this.accountType,
    required this.accountId,
    required this.isActive,
    required this.isVerified,
    required this.accountDetails,
    this.verifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentAccount.fromJson(Map<String, dynamic> json) {
    return PaymentAccount(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      accountType:
          PaymentAccountType.fromString(json['account_type'] as String),
      accountId: json['account_id'] as String,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      accountDetails: json['account_details'] as Map<String, dynamic>? ?? {},
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'account_type': accountType.value,
      'account_id': accountId,
      'is_active': isActive,
      'is_verified': isVerified,
      'account_details': accountDetails,
      if (verifiedAt != null) 'verified_at': verifiedAt!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Payment account creation request model
class PaymentAccountCreateRequest {
  final PaymentAccountType accountType;
  final String accountId;
  final Map<String, dynamic> accountDetails;

  const PaymentAccountCreateRequest({
    required this.accountType,
    required this.accountId,
    required this.accountDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_type': accountType.value,
      'account_id': accountId,
      'account_details': accountDetails,
    };
  }
}

/// Payout model
class Payout {
  final String id;
  final String providerId;
  final String paymentAccountId;
  final double amount;
  final String currency;
  final PayoutStatus status;
  final String? gatewayPayoutId;
  final DateTime? processedAt;
  final DateTime? completedAt;
  final String? failureReason;
  final String? notes;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payout({
    required this.id,
    required this.providerId,
    required this.paymentAccountId,
    required this.amount,
    required this.currency,
    required this.status,
    this.gatewayPayoutId,
    this.processedAt,
    this.completedAt,
    this.failureReason,
    this.notes,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      paymentAccountId: json['payment_account_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      status: PayoutStatus.fromString(json['status'] as String),
      gatewayPayoutId: json['gateway_payout_id'] as String?,
      processedAt: json['processed_at'] != null
          ? DateTime.parse(json['processed_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      failureReason: json['failure_reason'] as String?,
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'payment_account_id': paymentAccountId,
      'amount': amount,
      'currency': currency,
      'status': status.value,
      if (gatewayPayoutId != null) 'gateway_payout_id': gatewayPayoutId,
      if (processedAt != null) 'processed_at': processedAt!.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
      if (failureReason != null) 'failure_reason': failureReason,
      if (notes != null) 'notes': notes,
      if (metadata != null) 'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Payout request model
class PayoutRequest {
  final String paymentAccountId;
  final double amount;

  const PayoutRequest({
    required this.paymentAccountId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'payment_account_id': paymentAccountId,
      'amount': amount,
    };
  }
}

/// Earnings summary model
class EarningsSummary {
  final double totalEarnings;
  final double availableBalance;
  final double pendingAmount;
  final double totalPayouts;
  final int totalBookings;
  final double averageEarningPerBooking;
  final Map<String, dynamic>? breakdown;

  const EarningsSummary({
    required this.totalEarnings,
    required this.availableBalance,
    required this.pendingAmount,
    required this.totalPayouts,
    required this.totalBookings,
    required this.averageEarningPerBooking,
    this.breakdown,
  });

  factory EarningsSummary.fromJson(Map<String, dynamic> json) {
    return EarningsSummary(
      totalEarnings: (json['total_earnings'] as num).toDouble(),
      availableBalance: (json['available_balance'] as num).toDouble(),
      pendingAmount: (json['pending_amount'] as num).toDouble(),
      totalPayouts: (json['total_payouts'] as num).toDouble(),
      totalBookings: json['total_bookings'] as int,
      averageEarningPerBooking:
          (json['average_earning_per_booking'] as num).toDouble(),
      breakdown: json['breakdown'] as Map<String, dynamic>?,
    );
  }
}

/// Payment service for handling payments, payment accounts, and payouts
class PaymentService {
  final ApiService _apiService;

  PaymentService(this._apiService);

  // === PAYMENT PROCESSING ===

  /// List payments with filters and pagination
  Future<ApiResponse<List<Payment>>> listPayments({
    PaymentStatus? status,
    String? paymentMethod,
    String? bookingId,
    String? ordering = '-created_at',
    String? search,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (status != null) queryParams['status'] = status.value;
    if (paymentMethod != null) queryParams['payment_method'] = paymentMethod;
    if (bookingId != null) queryParams['booking'] = bookingId;
    if (ordering != null) queryParams['ordering'] = ordering;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Payment>>(
      '/api/v1/payments/payments/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((payment) => Payment.fromJson(payment))
          .toList(),
    );
  }

  /// Get payment details by ID
  Future<ApiResponse<Payment>> getPaymentDetails(String paymentId) async {
    return _apiService.get<Payment>(
      '/api/v1/payments/payments/$paymentId/',
      fromJson: (data) => Payment.fromJson(data),
    );
  }

  /// Initiate payment
  Future<ApiResponse<Map<String, dynamic>>> initiatePayment(
    PaymentInitiationRequest request,
  ) async {
    debugPrint(
        'PaymentService: Initiating payment for booking: ${request.bookingId}');

    return _apiService.post<Map<String, dynamic>>(
      '/api/v1/payments/payments/initiate/',
      body: request.toJson(),
      fromJson: (data) => data,
    );
  }

  /// Confirm payment
  Future<ApiResponse<Payment>> confirmPayment(
    PaymentConfirmationRequest request,
  ) async {
    debugPrint('PaymentService: Confirming payment: ${request.paymentId}');

    return _apiService.post<Payment>(
      '/api/v1/payments/payments/confirm/',
      body: request.toJson(),
      fromJson: (data) => Payment.fromJson(data),
    );
  }

  /// Get payment history with role filter
  Future<ApiResponse<List<Payment>>> getPaymentHistory({
    PaymentRole? role,
    PaymentStatus? status,
    String? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (role != null) queryParams['role'] = role.value;
    if (status != null) queryParams['status'] = status.value;
    if (paymentMethod != null) queryParams['payment_method'] = paymentMethod;
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Payment>>(
      '/api/v1/payments/payments/history/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((payment) => Payment.fromJson(payment))
          .toList(),
    );
  }

  // === PAYMENT GATEWAY ACCOUNTS ===

  /// List payment accounts for current provider
  Future<ApiResponse<List<PaymentAccount>>> listPaymentAccounts() async {
    return _apiService.get<List<PaymentAccount>>(
      '/api/v1/payments/accounts/',
      fromJson: (data) => (data['results'] as List)
          .map((account) => PaymentAccount.fromJson(account))
          .toList(),
    );
  }

  /// Create payment account
  Future<ApiResponse<PaymentAccount>> createPaymentAccount(
    PaymentAccountCreateRequest request,
  ) async {
    debugPrint(
        'PaymentService: Creating payment account of type: ${request.accountType.value}');

    return _apiService.post<PaymentAccount>(
      '/api/v1/payments/accounts/',
      body: request.toJson(),
      fromJson: (data) => PaymentAccount.fromJson(data),
    );
  }

  /// Get payment account details
  Future<ApiResponse<PaymentAccount>> getPaymentAccountDetails(
    String accountId,
  ) async {
    return _apiService.get<PaymentAccount>(
      '/api/v1/payments/accounts/$accountId/',
      fromJson: (data) => PaymentAccount.fromJson(data),
    );
  }

  /// Update payment account
  Future<ApiResponse<PaymentAccount>> updatePaymentAccount(
    String accountId,
    Map<String, dynamic> updates,
  ) async {
    debugPrint('PaymentService: Updating payment account: $accountId');

    return _apiService.put<PaymentAccount>(
      '/api/v1/payments/accounts/$accountId/',
      body: updates,
      fromJson: (data) => PaymentAccount.fromJson(data),
    );
  }

  /// Delete payment account
  Future<ApiResponse<Map<String, dynamic>>> deletePaymentAccount(
    String accountId,
  ) async {
    debugPrint('PaymentService: Deleting payment account: $accountId');

    return _apiService.delete<Map<String, dynamic>>(
      '/api/v1/payments/accounts/$accountId/',
      fromJson: (data) => data,
    );
  }

  // === PAYOUTS ===

  /// List payouts with filters
  Future<ApiResponse<List<Payout>>> listPayouts({
    PayoutStatus? status,
    String? ordering = '-created_at',
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (status != null) queryParams['status'] = status.value;
    if (ordering != null) queryParams['ordering'] = ordering;
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Payout>>(
      '/api/v1/payments/payouts/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((payout) => Payout.fromJson(payout))
          .toList(),
    );
  }

  /// Get payout details
  Future<ApiResponse<Payout>> getPayoutDetails(String payoutId) async {
    return _apiService.get<Payout>(
      '/api/v1/payments/payouts/$payoutId/',
      fromJson: (data) => Payout.fromJson(data),
    );
  }

  /// Request payout
  Future<ApiResponse<Payout>> requestPayout(PayoutRequest request) async {
    debugPrint(
        'PaymentService: Requesting payout of amount: ${request.amount}');

    return _apiService.post<Payout>(
      '/api/v1/payments/payouts/request/',
      body: request.toJson(),
      fromJson: (data) => Payout.fromJson(data),
    );
  }

  /// Get earnings summary
  Future<ApiResponse<EarningsSummary>> getEarningsSummary() async {
    return _apiService.get<EarningsSummary>(
      '/api/v1/payments/payouts/earnings/',
      fromJson: (data) => EarningsSummary.fromJson(data),
    );
  }

  // === ADMIN PAYMENT MANAGEMENT ===

  /// Admin: List all payments with filters
  Future<ApiResponse<List<Payment>>> adminListAllPayments({
    PaymentStatus? status,
    String? paymentMethod,
    String? customerId,
    String? providerId,
    String? ordering = '-created_at',
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (status != null) queryParams['status'] = status.value;
    if (paymentMethod != null) queryParams['payment_method'] = paymentMethod;
    if (customerId != null) queryParams['customer_id'] = customerId;
    if (providerId != null) queryParams['provider_id'] = providerId;
    if (ordering != null) queryParams['ordering'] = ordering;
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Payment>>(
      '/api/v1/payments/payments/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((payment) => Payment.fromJson(payment))
          .toList(),
    );
  }

  /// Admin: List all payouts with filters
  Future<ApiResponse<List<Payout>>> adminListAllPayouts({
    PayoutStatus? status,
    String? providerId,
    String? ordering = '-created_at',
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, String>{};

    if (status != null) queryParams['status'] = status.value;
    if (providerId != null) queryParams['provider_id'] = providerId;
    if (ordering != null) queryParams['ordering'] = ordering;
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
    }
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return _apiService.get<List<Payout>>(
      '/api/v1/payments/payouts/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => (data['results'] as List)
          .map((payout) => Payout.fromJson(payout))
          .toList(),
    );
  }

  // === ADDITIONAL UTILITY METHODS ===

  /// Cancel payment
  Future<ApiResponse<Payment>> cancelPayment(
    String paymentId, {
    String? reason,
  }) async {
    debugPrint('PaymentService: Cancelling payment: $paymentId');

    return _apiService.post<Payment>(
      '/api/v1/payments/payments/$paymentId/cancel/',
      body: {
        if (reason != null) 'reason': reason,
      },
      fromJson: (data) => Payment.fromJson(data),
    );
  }

  /// Request refund
  Future<ApiResponse<Payment>> requestRefund(
    String paymentId, {
    double? amount,
    String? reason,
  }) async {
    debugPrint('PaymentService: Requesting refund for payment: $paymentId');

    return _apiService.post<Payment>(
      '/api/v1/payments/payments/$paymentId/refund/',
      body: {
        if (amount != null) 'amount': amount,
        if (reason != null) 'reason': reason,
      },
      fromJson: (data) => Payment.fromJson(data),
    );
  }

  /// Get payment analytics
  Future<ApiResponse<Map<String, dynamic>>> getPaymentAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy, // 'day', 'week', 'month'
    List<String>? metrics, // 'revenue', 'volume', 'fees', etc.
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

    return _apiService.get<Map<String, dynamic>>(
      '/api/v1/payments/analytics/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }

  /// Get available payment methods
  Future<ApiResponse<List<Map<String, dynamic>>>>
      getAvailablePaymentMethods() async {
    return _apiService.get<List<Map<String, dynamic>>>(
      '/api/v1/payments/methods/available/',
      fromJson: (data) => List<Map<String, dynamic>>.from(data['methods']),
    );
  }

  /// Get saved payment methods for user
  Future<ApiResponse<List<Map<String, dynamic>>>>
      getSavedPaymentMethods() async {
    return _apiService.get<List<Map<String, dynamic>>>(
      '/api/v1/payments/methods/saved/',
      fromJson: (data) => List<Map<String, dynamic>>.from(data['methods']),
    );
  }

  /// Save payment method
  Future<ApiResponse<Map<String, dynamic>>> savePaymentMethod(
    Map<String, dynamic> paymentMethodData,
  ) async {
    debugPrint('PaymentService: Saving payment method');

    return _apiService.post<Map<String, dynamic>>(
      '/api/v1/payments/methods/save/',
      body: paymentMethodData,
      fromJson: (data) => data,
    );
  }

  /// Delete saved payment method
  Future<ApiResponse<Map<String, dynamic>>> deleteSavedPaymentMethod(
    String methodId,
  ) async {
    debugPrint('PaymentService: Deleting saved payment method: $methodId');

    return _apiService.delete<Map<String, dynamic>>(
      '/api/v1/payments/methods/$methodId/',
      fromJson: (data) => data,
    );
  }

  // === ADMIN SPECIFIC METHODS ===

  /// Admin: Process refund with admin notes
  Future<ApiResponse<Payment>> adminProcessRefund(
    String paymentId, {
    double? amount,
    String? reason,
    String? adminNotes,
  }) async {
    debugPrint(
        'PaymentService: Admin processing refund for payment: $paymentId');

    return _apiService.post<Payment>(
      '/admin/payments/$paymentId/refund/',
      body: {
        if (amount != null) 'amount': amount,
        if (reason != null) 'reason': reason,
        if (adminNotes != null) 'admin_notes': adminNotes,
      },
      fromJson: (data) => Payment.fromJson(data),
    );
  }

  /// Admin: Approve payout
  Future<ApiResponse<Payout>> adminApprovePayout(
    String payoutId, {
    String? adminNotes,
  }) async {
    debugPrint('PaymentService: Admin approving payout: $payoutId');

    return _apiService.post<Payout>(
      '/admin/payouts/$payoutId/approve/',
      body: {
        if (adminNotes != null) 'admin_notes': adminNotes,
      },
      fromJson: (data) => Payout.fromJson(data),
    );
  }

  /// Admin: Reject payout
  Future<ApiResponse<Payout>> adminRejectPayout(
    String payoutId, {
    required String reason,
    String? adminNotes,
  }) async {
    debugPrint('PaymentService: Admin rejecting payout: $payoutId');

    return _apiService.post<Payout>(
      '/admin/payouts/$payoutId/reject/',
      body: {
        'rejection_reason': reason,
        if (adminNotes != null) 'admin_notes': adminNotes,
      },
      fromJson: (data) => Payout.fromJson(data),
    );
  }

  /// Admin: Get comprehensive payment analytics
  Future<ApiResponse<Map<String, dynamic>>> adminGetPaymentAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
    List<String>? metrics, // 'revenue', 'volume', 'fees', etc.
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

    return _apiService.get<Map<String, dynamic>>(
      '/admin/payments/analytics/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (data) => data,
    );
  }
}

/// Provider for PaymentService
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(ApiService());
});
