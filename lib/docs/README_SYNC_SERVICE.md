# Sync Service Documentation

The Sync Service provides comprehensive offline functionality and data synchronization capabilities for the Prbal Flutter application. It enables users to download data for offline use and upload changes made while offline.

## Overview

The sync service implements all APIs from the Postman collection `Sync.postman_collection.json` and provides:

- **Profile Synchronization**: Download user profile for offline access
- **Service Synchronization**: Download services with filtering and caching
- **Offline Operations**: Store bids, bookings, and messages locally when offline
- **Data Upload**: Sync offline changes when connectivity is restored
- **Local Storage**: Efficient caching using Hive database

## Key Features

### 🔄 Data Synchronization

- Download user profile for offline use
- Download services with advanced filtering
- Automatic data caching and expiration handling
- Optimized sync strategies (category-based, location-based, limited sync)

### 📱 Offline Functionality

- Queue bids, bookings, and messages when offline
- Local storage of all offline operations
- Conflict resolution and error handling
- Automatic sync when connectivity returns

### 🚀 Performance Optimization

- Fast sync with limited data sets
- Efficient local storage using Hive
- Background sync capabilities
- Memory-efficient data models

## Models

### Core Sync Models

#### SyncMetadata

```dart
class SyncMetadata {
  final DateTime syncTimestamp;
  final DateTime? expiresAfter;
}
```

#### SyncUserProfile

```dart
class SyncUserProfile {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String email;
  final UserType userType;
  // ... other profile fields
}
```

#### SyncService

```dart
class SyncService {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String location;
  final SyncServiceProvider provider;
  final SyncServiceCategory category;
  // ... other service fields
}
```

### Offline Operation Models

#### OfflineBid

```dart
class OfflineBid {
  final String clientTempId;
  final String service;
  final double amount;
  final String message;
  final String duration;
  final String currency;
  final DateTime? scheduledDateTime;
}
```

#### OfflineBooking

```dart
class OfflineBooking {
  final String clientTempId;
  final String service;
  final String provider;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double amount;
  final String address;
  final String? requirements;
}
```

#### OfflineMessage

```dart
class OfflineMessage {
  final String clientTempId;
  final String thread;
  final String content;
  final String messageType;
}
```

## API Methods

### Profile Sync

#### Download User Profile

```dart
Future<ApiResponse<SyncUserProfile>> downloadUserProfile()
```

**Endpoint**: `GET /api/v1/sync/profile/`
**Purpose**: Download authenticated user's profile for offline use
**Usage**:

```dart
final response = await ref.read(syncServiceProvider.notifier).downloadUserProfile();
if (response.success) {
  final profile = response.data!;
  // Profile is automatically cached locally
}
```

### Service Sync

#### Download Services

```dart
Future<ApiResponse<SyncServicesResponse>> downloadServices({
  SyncServiceFilters? filters,
})
```

**Endpoint**: `GET /api/v1/sync/services/`
**Purpose**: Download services with optional filtering
**Filters**:

- `category`: Filter by service category ID
- `location`: Filter by location (partial match)
- `maxPrice`: Filter by maximum price
- `search`: Search in title, description, location
- `ordering`: Order by field (`created_at`, `price`, `rating`, etc.)
- `limit`: Limit number of services

**Usage**:

```dart
// Download all services
final response = await ref.read(syncServiceProvider.notifier).downloadServices();

// Download with filters
final filteredResponse = await ref.read(syncServiceProvider.notifier).downloadServices(
  filters: SyncServiceFilters(
    category: 'cleaning',
    location: 'Mumbai',
    maxPrice: 1000.0,
    ordering: '-created_at',
    limit: 50,
  ),
);
```

#### Download Services by Category

```dart
Future<ApiResponse<SyncServicesResponse>> downloadServicesByCategory(
  String categoryId, {
  String ordering = '-created_at',
})
```

**Purpose**: Download services for a specific category
**Usage**:

```dart
final response = await ref.read(syncServiceProvider.notifier)
    .downloadServicesByCategory('cleaning');
```

#### Download Services by Location

```dart
Future<ApiResponse<SyncServicesResponse>> downloadServicesByLocation(
  String location, {
  String ordering = 'price',
})
```

**Purpose**: Download services for a specific location
**Usage**:

```dart
final response = await ref.read(syncServiceProvider.notifier)
    .downloadServicesByLocation('Mumbai');
```

#### Download Limited Services (Fast Sync)

```dart
Future<ApiResponse<SyncServicesResponse>> downloadLimitedServices({
  int limit = 50,
  String ordering = '-created_at',
})
```

**Purpose**: Download a limited number of services for quick sync
**Usage**:

```dart
final response = await ref.read(syncServiceProvider.notifier)
    .downloadLimitedServices(limit: 20);
```

### Upload Methods

#### Upload Offline Changes

```dart
Future<ApiResponse<UploadChangesResponse>> uploadOfflineChanges(
  UploadChangesRequest request,
)
```

**Endpoint**: `POST /api/v1/sync/upload/`
**Purpose**: Upload all offline changes in a single request
**Usage**:

```dart
final request = UploadChangesRequest(
  timestamp: DateTime.now(),
  bids: offlineBids,
  bookings: offlineBookings,
  messages: offlineMessages,
);

final response = await ref.read(syncServiceProvider.notifier)
    .uploadOfflineChanges(request);
```

#### Upload Specific Data Types

```dart
// Upload only bids
Future<ApiResponse<UploadChangesResponse>> uploadOfflineBids(List<OfflineBid> bids)

// Upload only bookings
Future<ApiResponse<UploadChangesResponse>> uploadOfflineBookings(List<OfflineBooking> bookings)

// Upload only messages
Future<ApiResponse<UploadChangesResponse>> uploadOfflineMessages(List<OfflineMessage> messages)
```

## Local Storage & Caching

### HiveService Integration

The sync service integrates with `HiveService` for local storage:

#### Sync Data Storage

```dart
// Cache user profile
await HiveService.saveUserProfile(profile.toJson());

// Cache services
await HiveService.saveSyncedServices(servicesResponse.toJson());

// Retrieve cached data
final cachedProfile = await HiveService.getUserProfile();
final cachedServices = await HiveService.getSyncedServices();
```

#### Offline Data Storage

```dart
// Store offline operations
await HiveService.saveOfflineBid(tempId, bidData);
await HiveService.saveOfflineBooking(tempId, bookingData);
await HiveService.saveOfflineMessage(tempId, messageData);

// Retrieve offline data
final offlineBids = HiveService.getOfflineBids();
final offlineBookings = HiveService.getOfflineBookings();
final offlineMessages = HiveService.getOfflineMessages();
```

#### Data Status & Cleanup

```dart
// Check for pending offline data
bool hasPending = HiveService.hasPendingOfflineData();

// Get offline data counts
Map<String, int> counts = HiveService.getOfflineDataCounts();

// Clear specific data
await HiveService.removeOfflineBid(tempId);
await HiveService.clearOfflineData();
await HiveService.clearSyncData();
```

## Usage Patterns

### 1. Initial App Sync

```dart
class SyncInitializer {
  static Future<void> performInitialSync(WidgetRef ref) async {
    final syncService = ref.read(syncServiceProvider.notifier);
    
    try {
      // Download user profile
      await syncService.downloadUserProfile();
      
      // Download limited services for quick start
      await syncService.downloadLimitedServices(limit: 50);
      
      // Check for pending offline data
      if (HiveService.hasPendingOfflineData()) {
        await _uploadPendingData(syncService);
      }
    } catch (e) {
      debugPrint('Initial sync failed: $e');
    }
  }
  
  static Future<void> _uploadPendingData(SyncServiceProvider syncService) async {
    // Upload pending offline changes
    final offlineBids = HiveService.getOfflineBids();
    final offlineBookings = HiveService.getOfflineBookings();
    final offlineMessages = HiveService.getOfflineMessages();
    
    if (offlineBids.isNotEmpty || offlineBookings.isNotEmpty || offlineMessages.isNotEmpty) {
      final request = UploadChangesRequest(
        timestamp: DateTime.now(),
        bids: offlineBids.entries.map((e) => OfflineBid.fromJson(e.value)).toList(),
        bookings: offlineBookings.entries.map((e) => OfflineBooking.fromJson(e.value)).toList(),
        messages: offlineMessages.entries.map((e) => OfflineMessage.fromJson(e.value)).toList(),
      );
      
      await syncService.uploadOfflineChanges(request);
    }
  }
}
```

### 2. Offline Operation Handling

```dart
class OfflineOperationHandler {
  static Future<void> createOfflineBid({
    required String serviceId,
    required double amount,
    required String message,
    required String duration,
  }) async {
    final tempId = 'offline_bid_${DateTime.now().millisecondsSinceEpoch}';
    
    final bid = OfflineBid(
      clientTempId: tempId,
      service: serviceId,
      amount: amount,
      message: message,
      duration: duration,
    );
    
    await HiveService.saveOfflineBid(tempId, bid.toJson());
  }
  
  static Future<void> createOfflineBooking({
    required String serviceId,
    required String providerId,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required double amount,
    required String address,
  }) async {
    final tempId = 'offline_booking_${DateTime.now().millisecondsSinceEpoch}';
    
    final booking = OfflineBooking(
      clientTempId: tempId,
      service: serviceId,
      provider: providerId,
      bookingDate: bookingDate,
      startTime: startTime,
      endTime: endTime,
      amount: amount,
      address: address,
    );
    
    await HiveService.saveOfflineBooking(tempId, booking.toJson());
  }
}
```

### 3. Connectivity-Aware Sync

```dart
class ConnectivitySyncHandler {
  static Future<void> onConnectivityRestored(WidgetRef ref) async {
    final syncService = ref.read(syncServiceProvider.notifier);
    
    try {
      // Upload any pending offline data
      if (HiveService.hasPendingOfflineData()) {
        await _uploadAllPendingData(syncService);
      }
      
      // Refresh sync data if expired
      await _refreshExpiredData(syncService);
      
    } catch (e) {
      debugPrint('Connectivity sync failed: $e');
    }
  }
  
  static Future<void> _uploadAllPendingData(SyncServiceProvider syncService) async {
    final counts = HiveService.getOfflineDataCounts();
    debugPrint('Uploading pending data: $counts');
    
    // Create upload request with all pending data
    final request = UploadChangesRequest(
      timestamp: DateTime.now(),
      bids: HiveService.getOfflineBids().entries
          .map((e) => OfflineBid.fromJson(e.value)).toList(),
      bookings: HiveService.getOfflineBookings().entries
          .map((e) => OfflineBooking.fromJson(e.value)).toList(),
      messages: HiveService.getOfflineMessages().entries
          .map((e) => OfflineMessage.fromJson(e.value)).toList(),
    );
    
    final response = await syncService.uploadOfflineChanges(request);
    if (response.success) {
      debugPrint('Successfully uploaded pending data');
    }
  }
  
  static Future<void> _refreshExpiredData(SyncServiceProvider syncService) async {
    // Check if cached data is expired and refresh if needed
    final cachedServices = await HiveService.getSyncedServices();
    if (cachedServices != null) {
      final metadata = SyncMetadata.fromJson(cachedServices);
      if (syncService.isSyncDataExpired(metadata)) {
        await syncService.downloadLimitedServices();
      }
    }
  }
}
```

### 4. UI Integration with Consumer

```dart
class SyncStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncedServices = ref.watch(syncServiceProvider);
    final offlineCounts = HiveService.getOfflineDataCounts();
    
    return Column(
      children: [
        // Sync status indicator
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: syncedServices != null ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            syncedServices != null 
                ? 'Synced (${syncedServices.length} services)'
                : 'Not synced',
            style: TextStyle(color: Colors.white),
          ),
        ),
        
        // Offline data indicator
        if (offlineCounts.values.any((count) => count > 0))
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Pending: ${offlineCounts['bids']} bids, '
              '${offlineCounts['bookings']} bookings, '
              '${offlineCounts['messages']} messages',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        
        // Sync actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _performSync(ref),
              child: Text('Sync Now'),
            ),
            ElevatedButton(
              onPressed: () => _clearCache(ref),
              child: Text('Clear Cache'),
            ),
          ],
        ),
      ],
    );
  }
  
  Future<void> _performSync(WidgetRef ref) async {
    final syncService = ref.read(syncServiceProvider.notifier);
    await syncService.downloadLimitedServices();
  }
  
  Future<void> _clearCache(WidgetRef ref) async {
    final syncService = ref.read(syncServiceProvider.notifier);
    await syncService.clearAllSyncData();
  }
}
```

## Error Handling

The sync service provides comprehensive error handling:

```dart
// Check response status
final response = await syncService.downloadServices();
if (response.success) {
  // Handle success
  final services = response.data!.services;
  debugPrint('Downloaded ${services.length} services');
} else {
  // Handle error
  debugPrint('Sync failed: ${response.message}');
  if (response.errors != null) {
    debugPrint('Errors: ${response.errors}');
  }
}

// Upload response includes detailed error information
final uploadResponse = await syncService.uploadOfflineChanges(request);
if (uploadResponse.success) {
  final result = uploadResponse.data!;
  debugPrint('Processed: ${result.processedBids.length} bids');
  
  // Handle any errors in the batch
  for (final error in result.errors) {
    debugPrint('Failed to process ${error.clientTempId}: ${error.error}');
  }
} else {
  debugPrint('Upload failed: ${uploadResponse.message}');
}
```

## Best Practices

### 1. Sync Strategy

- Use `downloadLimitedServices()` for initial app load
- Use category/location-specific sync for targeted data
- Implement periodic background sync
- Check data expiration before using cached data

### 2. Offline Operations

- Always use unique `clientTempId` for offline operations
- Store offline data immediately when operations fail
- Provide user feedback about offline status
- Handle upload conflicts gracefully

### 3. Performance

- Limit sync data size for better performance
- Use appropriate ordering for relevant data first
- Clear expired cache data regularly
- Monitor local storage usage

### 4. Error Handling

- Always check `ApiResponse.success` before using data
- Provide user-friendly error messages
- Implement retry logic for failed syncs
- Log errors for debugging

### 5. UI/UX

- Show sync status to users
- Indicate when operating offline
- Provide manual sync options
- Show pending upload counts

## Troubleshooting

### Common Issues

1. **Sync Service not initializing**
   - Ensure HiveService is initialized before SyncService
   - Check if all required Hive boxes are opened

2. **Offline data not persisting**
   - Verify HiveService.saveOffline* methods are called
   - Check if Hive boxes are properly initialized

3. **Upload failures**
   - Verify network connectivity
   - Check authentication tokens are valid
   - Ensure data format matches API expectations

4. **Memory issues with large sync data**
   - Use `downloadLimitedServices()` instead of full sync
   - Implement pagination for large datasets
   - Clear old cache data regularly

### Debug Information

```dart
// Get comprehensive debug info
void debugSyncService() {
  debugPrint('Hive Debug Info: ${HiveService.getDebugInfo()}');
  debugPrint('Offline Data Counts: ${HiveService.getOfflineDataCounts()}');
  debugPrint('Has Pending Data: ${HiveService.hasPendingOfflineData()}');
  debugPrint('Storage Healthy: ${HiveService.isStorageHealthy()}');
}
```

## API Reference Summary

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `downloadUserProfile()` | `GET /sync/profile/` | Download user profile for offline |
| `downloadServices()` | `GET /sync/services/` | Download services with filters |
| `downloadServicesByCategory()` | `GET /sync/services/?category=` | Download category-specific services |
| `downloadServicesByLocation()` | `GET /sync/services/?location=` | Download location-specific services |
| `downloadLimitedServices()` | `GET /sync/services/?limit=` | Download limited services (fast sync) |
| `uploadOfflineChanges()` | `POST /sync/upload/` | Upload all offline changes |
| `uploadOfflineBids()` | `POST /sync/upload/` | Upload only offline bids |
| `uploadOfflineBookings()` | `POST /sync/upload/` | Upload only offline bookings |
| `uploadOfflineMessages()` | `POST /sync/upload/` | Upload only offline messages |

This sync service provides a complete offline-first experience for the Prbal application, ensuring users can continue using the app even without internet connectivity and seamlessly sync their data when connectivity is restored.
