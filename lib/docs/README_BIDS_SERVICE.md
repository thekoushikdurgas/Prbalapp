# Bids Service Implementation

This document describes the comprehensive BidsService implementation that covers all APIs from the Bids Postman collection.

## 🚀 Features Implemented

### Core Models

- **Bid**: Complete bid model with all fields including AI suggestions
- **CreateBidRequest**: For creating new bids
- **UpdateBidRequest**: For partial bid updates
- **AcceptBidRequest**: For accepting bids with booking details
- **SmartPricingResponse**: AI-powered pricing suggestions

### API Endpoints Covered

#### Basic CRUD Operations

- ✅ `GET /api/v1/bids/` - List bids with filters
- ✅ `GET /api/v1/bids/{bidId}/` - Get bid details
- ✅ `POST /api/v1/bids/` - Create bid (regular and AI-suggested)
- ✅ `PUT /api/v1/bids/{bidId}/` - Update bid completely
- ✅ `PATCH /api/v1/bids/{bidId}/` - Partial update bid
- ✅ `DELETE /api/v1/bids/{bidId}/` - Delete bid

#### Bid Actions

- ✅ `POST /api/v1/bids/{bidId}/accept/` - Accept bid (Customer)
- ✅ `POST /api/v1/bids/{bidId}/reject/` - Reject bid (Customer)

#### AI Features

- ✅ `GET /api/v1/bids/smart_price/` - Get AI smart pricing

#### Filtering & Search

- ✅ Filter by service (`?service={serviceId}`)
- ✅ Filter by provider (`?provider={providerId}`)
- ✅ Filter by status (`?status={status}`)
- ✅ Search by description (`?search={query}`)
- ✅ Sort by amount (`?ordering=amount` or `?ordering=-amount`)
- ✅ Sort by date (`?ordering=created_at` or `?ordering=-created_at`)

### Convenience Methods

#### Status-based Queries

```dart
service.getPendingBids()      // status=pending
service.getAcceptedBids()     // status=accepted
service.getRejectedBids()     // status=rejected
service.getCompletedBids()    // status=completed
service.getCancelledBids()    // status=cancelled
service.getExpiredBids()      // status=expired
```

#### Filtering Shortcuts

```dart
service.getBidsByService(serviceId)
service.getBidsByProvider(providerId)
service.getBidsByStatus(status)
service.searchBids(query)
```

#### Sorting Shortcuts

```dart
service.getBidsSortedByAmount(descending: true)
service.getBidsSortedByDate(newestFirst: true)
```

## 🔧 Usage Examples

### 1. Basic Operations

```dart
// Get bids service
final bidsService = ref.read(bidsServiceProvider);

// List all bids
final response = await bidsService.listBids();

// Create a bid
final request = CreateBidRequest(
  service: 'service-id',
  amount: 75.00,
  currency: 'INR',
  duration: '3 hours',
  message: 'I can provide excellent service',
  location: 'Bangalore, India',
);
final createResponse = await bidsService.createBid(request);
```

### 2. AI-Suggested Bid

```dart
// Get smart pricing first
final pricingResponse = await bidsService.getSmartPricing('service-id');
if (pricingResponse.success) {
  final pricing = pricingResponse.data!;
  
  // Create AI-suggested bid
  final request = CreateBidRequest(
    service: 'service-id',
    amount: pricing.optimalPrice,
    currency: 'INR',
    duration: '2.5 hours',
    message: 'AI-optimized bid based on market analysis',
    location: 'Bangalore, India',
    isAiSuggested: true,
    aiSuggestionId: 'suggestion-id',
    aiSuggestedAmount: pricing.optimalPrice,
  );
  
  final response = await bidsService.createBid(request);
}
```

### 3. Bid Management (Customer)

```dart
// Accept a bid
final acceptRequest = AcceptBidRequest(
  bookingDate: DateTime.now().add(Duration(days: 2)),
  specialInstructions: 'Please bring eco-friendly supplies',
  paymentMethod: 'online',
);
await bidsService.acceptBid('bid-id', acceptRequest);

// Reject a bid
await bidsService.rejectBid('bid-id');
```

### 4. Advanced Filtering

```dart
// Complex filtering
final response = await bidsService.listBids(
  serviceId: 'service-123',
  status: 'pending',
  ordering: '-amount', // Highest amount first
  page: 1,
  pageSize: 20,
);

// Search with pagination
final searchResponse = await bidsService.listBids(
  search: 'cleaning service',
  ordering: '-created_at',
  page: 2,
);
```

## 🎯 Riverpod Providers

### Available Providers

```dart
// Service provider
final bidsServiceProvider = Provider<BidsService>((ref) => ...);

// List providers
final bidsProvider = FutureProvider.family<List<Bid>, Map<String, String>?>(...);
final pendingBidsProvider = FutureProvider<List<Bid>>(...);
final acceptedBidsProvider = FutureProvider<List<Bid>>(...);
final myBidsProvider = FutureProvider.family<List<Bid>, String?>(...);

// Detail providers
final bidDetailsProvider = FutureProvider.family<Bid, String>(...);
final smartPricingProvider = FutureProvider.family<SmartPricingResponse, String>(...);
```

### Widget Usage

```dart
class BidsListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bidsAsync = ref.watch(bidsProvider(null));
    
    return bidsAsync.when(
      data: (bids) => ListView.builder(
        itemCount: bids.length,
        itemBuilder: (context, index) {
          final bid = bids[index];
          return ListTile(
            title: Text('${bid.amount} ${bid.currency}'),
            subtitle: Text(bid.message),
            trailing: Text(bid.status),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Filtered Lists

```dart
// Get pending bids
final pendingBids = ref.watch(pendingBidsProvider);

// Get bids with filters
final filteredBids = ref.watch(bidsProvider({
  'status': 'pending',
  'ordering': '-amount',
}));

// Get bid details
final bidDetails = ref.watch(bidDetailsProvider('bid-id'));

// Get smart pricing
final smartPricing = ref.watch(smartPricingProvider('service-id'));
```

## 🔒 Error Handling

All methods return `ApiResponse<T>` which includes:

- `success`: Boolean indicating if the operation succeeded
- `data`: The actual response data (null if error)
- `message`: Error message or success message
- `statusCode`: HTTP status code
- `errors`: Additional error details

```dart
final response = await bidsService.createBid(request);
if (response.success && response.data != null) {
  // Success
  final bid = response.data!;
  debugPrint('Bid created: ${bid.id}');
} else {
  // Error
  debugPrint('Error: ${response.message}');
  if (response.errors != null) {
    debugPrint('Details: ${response.errors}');
  }
}
```

## 🚦 Status Types

The service handles all bid statuses:

- `pending` - Waiting for customer response
- `accepted` - Customer accepted the bid
- `rejected` - Customer rejected the bid
- `expired` - Bid expired without response
- `completed` - Service completed successfully
- `cancelled` - Bid was cancelled

## 🤖 AI Integration

### Smart Pricing

```dart
final pricingResponse = await bidsService.getSmartPricing('service-id');
if (pricingResponse.success) {
  final pricing = pricingResponse.data!;
  debugPrint('Optimal price: ${pricing.optimalPrice}');
  debugPrint('Range: ${pricing.minPrice} - ${pricing.maxPrice}');
  debugPrint('Confidence: ${pricing.confidenceScore}');
  debugPrint('Analysis: ${pricing.marketAnalysis}');
}
```

### AI-Suggested Bids

Set `isAiSuggested: true` when creating bids based on AI recommendations, and include the `aiSuggestionId` and `aiSuggestedAmount` for tracking.

## 📱 Real-world Usage

### Provider Dashboard

```dart
// Show provider's bids
final myBids = ref.watch(bidsProvider({'provider': currentUserId}));

// Show pending bids for quick action
final pendingBids = ref.watch(pendingBidsProvider);
```

### Customer Dashboard

```dart
// Show bids on customer's services
final bidsOnMyServices = ref.watch(bidsProvider({'customer': currentUserId}));

// Show accepted bids (active bookings)
final activeBids = ref.watch(acceptedBidsProvider);
```

### Service Details Page

```dart
// Show all bids for a specific service
final serviceBids = ref.watch(bidsProvider({'service': serviceId}));

// Get smart pricing for the service
final smartPricing = ref.watch(smartPricingProvider(serviceId));
```

## 🔄 Bulk Operations

```dart
// Get multiple bids by IDs
final responses = await bidsService.getBidsById(['bid1', 'bid2', 'bid3']);

// Create multiple bids
final requests = [request1, request2, request3];
final responses = await bidsService.createBids(requests);
```

## 📊 Performance Tips

1. **Use Riverpod providers** for automatic caching and reactivity
2. **Implement pagination** for large lists using `page` and `pageSize`
3. **Use specific filters** to reduce data transfer
4. **Cache bid details** when possible
5. **Invalidate providers** after mutations:

   ```dart
   await bidsService.acceptBid(bidId, request);
   ref.invalidate(bidDetailsProvider(bidId));
   ref.invalidate(pendingBidsProvider);
   ```

## 🛠️ Customization

The service is designed to be extensible. You can:

1. Add custom filtering methods
2. Implement additional convenience methods
3. Add custom providers for specific use cases
4. Extend the models with additional fields

## 📝 File Structure

```txt
lib/services/
├── bids_service.dart                 # Main service implementation
├── api_service.dart                  # Base API service
└── ai_service.dart                   # AI-related services

lib/example/
└── bids_service_usage_example.dart   # Complete usage examples
```

## 🎉 Summary

This implementation provides:

- ✅ Complete API coverage from Postman collection
- ✅ Type-safe Dart models
- ✅ Comprehensive error handling
- ✅ Riverpod integration for state management
- ✅ Convenience methods for common operations
- ✅ AI features integration
- ✅ Real-world usage examples
- ✅ Performance optimizations

The service is production-ready and follows Flutter/Dart best practices for API integration and state management.
