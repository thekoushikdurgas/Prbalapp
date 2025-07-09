# Payment Service Integration Guide

## Overview

This guide covers the complete payment service integration for the Prbal app based on the Payment Postman collection. The service handles:

- **Payment Processing**: Initiate, confirm, and manage payments
- **Payment Gateway Accounts**: Manage provider payment accounts
- **Payouts**: Handle provider earnings and payouts
- **Admin Management**: Administrative payment and payout management

## Import the Service

```dart
import 'package:prbal/services/index.dart';
```

## Service Usage Examples

### 1. Payment Processing

#### List Payments with Filters

```dart
// List all payments with filters
Future<void> listPayments() async {
  final response = await PaymentService(ApiService()).listPayments(
    status: PaymentStatus.completed,
    paymentMethod: 'credit_card',
    ordering: '-created_at',
    page: 1,
    pageSize: 20,
  );

  if (response.isSuccess) {
    final payments = response.data!;
    debugPrint('Found ${payments.length} payments');
    for (final payment in payments) {
      debugPrint('Payment ${payment.id}: ${payment.amount} ${payment.currency}');
    }
  }
}
```

#### Get Payment Details

```dart
// Get specific payment details
Future<void> getPaymentDetails(String paymentId) async {
  final response = await PaymentService(ApiService()).getPaymentDetails(paymentId);

  if (response.isSuccess) {
    final payment = response.data!;
    debugPrint('Payment Details:');
    debugPrint('ID: ${payment.id}');
    debugPrint('Amount: ${payment.amount} ${payment.currency}');
    debugPrint('Status: ${payment.status.value}');
    debugPrint('Method: ${payment.method.value}');
  }
}
```

#### Initiate Payment

```dart
// Initiate a payment for a booking
Future<void> initiatePayment(String bookingId) async {
  final request = PaymentInitiationRequest(
    bookingId: bookingId,
    paymentMethod: 'credit_card',
    savePaymentMethod: false,
  );

  final response = await PaymentService(ApiService()).initiatePayment(request);

  if (response.isSuccess) {
    final paymentData = response.data!;
    debugPrint('Payment initiated: ${paymentData['payment_id']}');
    debugPrint('Gateway URL: ${paymentData['gateway_url']}');
  }
}
```

#### Confirm Payment

```dart
// Confirm payment after gateway processing
Future<void> confirmPayment(String paymentId, String transactionId) async {
  final request = PaymentConfirmationRequest(
    paymentId: paymentId,
    transactionId: transactionId,
  );

  final response = await PaymentService(ApiService()).confirmPayment(request);

  if (response.isSuccess) {
    final payment = response.data!;
    debugPrint('Payment confirmed: ${payment.id}');
    debugPrint('Status: ${payment.status.value}');
  }
}
```

#### Get Payment History

```dart
// Get payment history with role filter
Future<void> getPaymentHistory() async {
  final response = await PaymentService(ApiService()).getPaymentHistory(
    role: PaymentRole.payer, // or PaymentRole.payee
    status: PaymentStatus.completed,
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now(),
  );

  if (response.isSuccess) {
    final payments = response.data!;
    debugPrint('Payment history: ${payments.length} transactions');
  }
}
```

### 2. Payment Gateway Accounts Management

#### List Payment Accounts

```dart
// List provider's payment accounts
Future<void> listPaymentAccounts() async {
  final response = await PaymentService(ApiService()).listPaymentAccounts();

  if (response.isSuccess) {
    final accounts = response.data!;
    debugPrint('Found ${accounts.length} payment accounts');
    for (final account in accounts) {
      debugPrint('Account: ${account.accountType.value} - ${account.accountId}');
      debugPrint('Active: ${account.isActive}, Verified: ${account.isVerified}');
    }
  }
}
```

#### Create Payment Account

```dart
// Create a new payment account for provider
Future<void> createPaymentAccount() async {
  final request = PaymentAccountCreateRequest(
    accountType: PaymentAccountType.stripe,
    accountId: 'acct_1234567890',
    accountDetails: {
      'email': 'provider@example.com',
      'country': 'IN',
      'currency': 'INR',
      'business_type': 'individual',
    },
  );

  final response = await PaymentService(ApiService()).createPaymentAccount(request);

  if (response.isSuccess) {
    final account = response.data!;
    debugPrint('Account created: ${account.id}');
    debugPrint('Type: ${account.accountType.value}');
  }
}
```

#### Update Payment Account

```dart
// Update payment account details
Future<void> updatePaymentAccount(String accountId) async {
  final updates = {
    'is_active': true,
    'account_details': {
      'email': 'updated-email@example.com',
      'country': 'IN',
      'currency': 'INR',
      'updated_at': DateTime.now().toIso8601String(),
    },
  };

  final response = await PaymentService(ApiService())
      .updatePaymentAccount(accountId, updates);

  if (response.isSuccess) {
    final account = response.data!;
    debugPrint('Account updated: ${account.id}');
  }
}
```

#### Delete Payment Account

```dart
// Delete payment account
Future<void> deletePaymentAccount(String accountId) async {
  final response = await PaymentService(ApiService())
      .deletePaymentAccount(accountId);

  if (response.isSuccess) {
    debugPrint('Account deleted successfully');
  }
}
```

### 3. Payouts Management

#### List Payouts

```dart
// List provider payouts with filters
Future<void> listPayouts() async {
  final response = await PaymentService(ApiService()).listPayouts(
    status: PayoutStatus.completed,
    ordering: '-created_at',
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now(),
  );

  if (response.isSuccess) {
    final payouts = response.data!;
    debugPrint('Found ${payouts.length} payouts');
    for (final payout in payouts) {
      debugPrint('Payout ${payout.id}: ${payout.amount} ${payout.currency}');
      debugPrint('Status: ${payout.status.value}');
    }
  }
}
```

#### Request Payout

```dart
// Request a payout
Future<void> requestPayout(String paymentAccountId, double amount) async {
  final request = PayoutRequest(
    paymentAccountId: paymentAccountId,
    amount: amount,
  );

  final response = await PaymentService(ApiService()).requestPayout(request);

  if (response.isSuccess) {
    final payout = response.data!;
    debugPrint('Payout requested: ${payout.id}');
    debugPrint('Amount: ${payout.amount} ${payout.currency}');
    debugPrint('Status: ${payout.status.value}');
  }
}
```

#### Get Earnings Summary

```dart
// Get provider earnings summary
Future<void> getEarningsSummary() async {
  final response = await PaymentService(ApiService()).getEarningsSummary();

  if (response.isSuccess) {
    final earnings = response.data!;
    debugPrint('Total Earnings: ${earnings.totalEarnings}');
    debugPrint('Available Balance: ${earnings.availableBalance}');
    debugPrint('Pending Amount: ${earnings.pendingAmount}');
    debugPrint('Total Payouts: ${earnings.totalPayouts}');
    debugPrint('Average per Booking: ${earnings.averageEarningPerBooking}');
  }
}
```

### 4. Admin Payment Management

#### Admin List All Payments

```dart
// Admin: List all payments in the system
Future<void> adminListAllPayments() async {
  final response = await PaymentService(ApiService()).adminListAllPayments(
    status: PaymentStatus.pending,
    paymentMethod: 'credit_card',
    ordering: '-created_at',
    startDate: DateTime.now().subtract(const Duration(days: 7)),
  );

  if (response.isSuccess) {
    final payments = response.data!;
    debugPrint('Admin view: ${payments.length} payments');
  }
}
```

#### Admin List All Payouts

```dart
// Admin: List all payouts in the system
Future<void> adminListAllPayouts() async {
  final response = await PaymentService(ApiService()).adminListAllPayouts(
    status: PayoutStatus.pending,
    ordering: '-created_at',
  );

  if (response.isSuccess) {
    final payouts = response.data!;
    debugPrint('Admin view: ${payouts.length} payouts');
  }
}
```

## Additional Utility Methods

### Cancel Payment

```dart
Future<void> cancelPayment(String paymentId) async {
  final response = await PaymentService(ApiService()).cancelPayment(
    paymentId,
    reason: 'Customer cancellation',
  );

  if (response.isSuccess) {
    debugPrint('Payment cancelled successfully');
  }
}
```

### Request Refund

```dart
Future<void> requestRefund(String paymentId) async {
  final response = await PaymentService(ApiService()).requestRefund(
    paymentId,
    amount: 500.0, // Partial refund
    reason: 'Service not delivered',
  );

  if (response.isSuccess) {
    debugPrint('Refund requested successfully');
  }
}
```

### Get Payment Analytics

```dart
Future<void> getPaymentAnalytics() async {
  final response = await PaymentService(ApiService()).getPaymentAnalytics(
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now(),
    groupBy: 'day',
    metrics: ['revenue', 'volume', 'fees'],
  );

  if (response.isSuccess) {
    final analytics = response.data!;
    debugPrint('Analytics data: $analytics');
  }
}
```

## Error Handling

Always handle errors properly when using the payment service:

```dart
Future<void> handlePaymentWithErrorHandling() async {
  try {
    final response = await PaymentService(ApiService()).listPayments();
    
    if (response.isSuccess) {
      // Handle success
      final payments = response.data!;
      debugPrint('Success: ${payments.length} payments');
    } else {
      // Handle API error
      debugPrint('API Error: ${response.message}');
      debugPrint('Status Code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or other errors
    debugPrint('Error: $e');
  }
}
```

## Model Classes

### Payment

```dart
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
  final DateTime? paymentDate;
  // ... other fields
}
```

### PaymentAccount

```dart
class PaymentAccount {
  final String id;
  final String providerId;
  final PaymentAccountType accountType;
  final String accountId;
  final bool isActive;
  final bool isVerified;
  final Map<String, dynamic> accountDetails;
  // ... other fields
}
```

### Payout

```dart
class Payout {
  final String id;
  final String providerId;
  final String paymentAccountId;
  final double amount;
  final String currency;
  final PayoutStatus status;
  final DateTime? processedAt;
  // ... other fields
}
```

## Enums

### PaymentStatus

- `pending`
- `processing`
- `completed`
- `failed`
- `cancelled`
- `refunded`
- `disputed`

### PaymentMethod

- `creditCard`
- `debitCard`
- `bankTransfer`
- `wallet`
- `upi`
- `netBanking`

### PayoutStatus

- `pending`
- `processing`
- `completed`
- `failed`
- `cancelled`

### PaymentAccountType

- `stripe`
- `razorpay`
- `paypal`
- `paytm`
- `phonepe`
- `gpay`

### PaymentRole

- `payer`
- `payee`

## Best Practices

1. **Always handle errors**: Check `response.isSuccess` before accessing data
2. **Use proper enums**: Use the provided enums instead of raw strings
3. **Implement retry logic**: For network failures
4. **Cache sensitive data**: Use secure storage for payment tokens
5. **Log appropriately**: Use `debugPrint` for development, proper logging for production
6. **Validate amounts**: Always validate payment amounts before processing
7. **Handle edge cases**: Account for network timeouts, invalid responses, etc.

## Integration with UI

Example of integrating with a Flutter widget:

```dart
class PaymentWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<ApiResponse<List<Payment>>>(
      future: PaymentService(ApiService()).listPayments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        final response = snapshot.data!;
        if (!response.isSuccess) {
          return Text('API Error: ${response.message}');
        }
        
        final payments = response.data!;
        return ListView.builder(
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final payment = payments[index];
            return ListTile(
              title: Text('Payment ${payment.id}'),
              subtitle: Text('${payment.amount} ${payment.currency}'),
              trailing: Text(payment.status.value),
            );
          },
        );
      },
    );
  }
}
```

This comprehensive guide covers all the payment APIs from your Postman collection and provides practical examples for implementation in your Flutter app.
