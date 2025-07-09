# Prbal Sync Service - API Implementation Documentation

This document provides a comprehensive overview of all sync-related APIs from the Postman collection and their implementation in the Flutter Prbal app.

## Overview

The Sync Service provides offline functionality by allowing users to:

- Download data for offline use
- Upload changes made while offline
- Manage cached data efficiently
- Perform various types of synchronization

## API Endpoints Implementation

### 1. Download User Profile

**API:** `GET /api/v1/sync/profile/`
**Flutter Method:** `downloadUserProfile()`
**Purpose:** Download authenticated user's profile for offline use
**Implementation:**

```dart
Future<ApiResponse<SyncUserProfile>> downloadUserProfile()
```

### 2. Download Services for Offline

**API:** `GET /api/v1/sync/services/`
**Flutter Methods:**

- `downloadServices({SyncServiceFilters? filters})`
- `downloadServicesWithFilters({...parameters})`
**Purpose:** Download available services for offline browsing with various filters
**Implementation:**

```dart
Future<ApiResponse<SyncServicesResponse>> downloadServices({SyncServiceFilters? filters})
Future<ApiResponse<SyncServicesResponse>> downloadServicesWithFilters({...})
```

### 3. Download Services by Category

**API:** `GET /api/v1/sync/services/?category={categoryId}`
**Flutter Method:** `downloadServicesByCategory(String categoryId)`
**Purpose:** Download services filtered by specific category
**Implementation:**

```dart
Future<ApiResponse<SyncServicesResponse>> downloadServicesByCategory(String categoryId, {String ordering = '-created_at'})
```

### 4. Download Services by Location

**API:** `GET /api/v1/sync/services/?location={location}`
**Flutter Method:** `downloadServicesByLocation(String location)`
**Purpose:** Download services filtered by location
**Implementation:**

```dart
Future<ApiResponse<SyncServicesResponse>> downloadServicesByLocation(String location, {String ordering = 'price'})
```

### 5. Download Limited Services (Fast Sync)

**API:** `GET /api/v1/sync/services/?limit={limit}`
**Flutter Method:** `downloadLimitedServices({int limit = 50})`
**Purpose:** Download limited number of services for fast synchronization
**Implementation:**

```dart
Future<ApiResponse<SyncServicesResponse>> downloadLimitedServices({int limit = 50, String ordering = '-created_at'})
```

### 6. Upload Offline Changes

**API:** `POST /api/v1/sync/upload/`
**Flutter Methods:**

- `uploadOfflineChanges(UploadChangesRequest request)`
- `uploadAllPendingOfflineData()`
**Purpose:** Upload all offline changes to backend
**Implementation:**

```dart
Future<ApiResponse<UploadChangesResponse>> uploadOfflineChanges(UploadChangesRequest request)
Future<ApiResponse<UploadChangesResponse>> uploadAllPendingOfflineData()
```

### 7. Upload Bids Only

**API:** `POST /api/v1/sync/upload/` (bids only)
**Flutter Method:** `uploadOfflineBids(List<OfflineBid> bids)`
**Purpose:** Upload only bids created offline
**Implementation:**

```dart
Future<ApiResponse<UploadChangesResponse>> uploadOfflineBids(List<OfflineBid> bids)
```

### 8. Upload Messages Only

**API:** `POST /api/v1/sync/upload/` (messages only)
**Flutter Method:** `uploadOfflineMessages(List<OfflineMessage> messages)`
**Purpose:** Upload only messages sent while offline
**Implementation:**

```dart
Future<ApiResponse<UploadChangesResponse>> uploadOfflineMessages(List<OfflineMessage> messages)
```

## Additional Sync Methods

### Enhanced Sync Operations

1. **Full Sync:** `performFullSync({int serviceLimit, bool includeProfile})`
   - Downloads user profile and services in one operation
   - Uploads pending offline data first
   - Returns detailed sync results

2. **Quick Sync:** `performQuickSync({int limit = 20})`
   - Fast synchronization with limited data
   - Uploads pending data then downloads fresh services

3. **Conditional Sync:** `performConditionalSync({...filters})`
   - Sync based on specific criteria
   - Supports category, location, and price filters

4. **Connectivity Restore Sync:** `syncOnConnectivityRestore()`
   - Automatically syncs when network connectivity is restored
   - Uploads pending data and refreshes cached data

### Utility Methods

1. **Get Sync Status:** `getSyncStatus()`
   - Returns comprehensive sync status information
   - Includes offline data counts and storage health

2. **Initialize:** `initialize()`
   - Loads cached services on startup
   - Sets up the sync service

3. **Clear Data:** `clearAllSyncData()`
   - Clears all cached sync data
   - Resets the service state

4. **Get Cached Profile:** `getCachedUserProfile()`
   - Retrieves cached user profile
   - Returns null if no cached profile exists

## Data Models

### Request Models

- `UploadChangesRequest`: Contains offline bids, bookings, and messages
- `SyncServiceFilters`: Filter parameters for service downloads
- `OfflineBid`: Model for bids created offline
- `OfflineBooking`: Model for bookings created offline
- `OfflineMessage`: Model for messages sent offline

### Response Models

- `SyncUserProfile`: Complete user profile information
- `SyncServicesResponse`: Services with sync metadata
- `UploadChangesResponse`: Upload results with processed items and errors
- `SyncMetadata`: Sync timestamp and expiration information

## Usage Examples

### Basic Service Download

```dart
final syncService = ref.read(syncServiceProvider.notifier);

// Download limited services for quick sync
final response = await syncService.downloadLimitedServices(limit: 20);

if (response.success) {
  debugPrint('Downloaded ${response.data?.services.length} services');
}
```

### Upload Offline Data

```dart
// Upload all pending offline data
final uploadResponse = await syncService.uploadAllPendingOfflineData();

if (uploadResponse.success) {
  final result = uploadResponse.data!;
  debugPrint('Uploaded: ${result.processedBids.length} bids, ${result.processedBookings.length} bookings');
}
```

### Full Sync Operation

```dart
final syncResults = await syncService.performFullSync(
  serviceLimit: 50,
  includeProfile: true,
);

if (syncResults['overall_success']) {
  debugPrint('Full sync completed successfully');
} else {
  debugPrint('Full sync failed: ${syncResults['error']}');
}
```

## Integration with Hive Storage

The sync service integrates seamlessly with Hive for local storage:

- `HiveService.saveSyncedServices()`: Cache downloaded services
- `HiveService.saveUserProfile()`: Cache user profile
- `HiveService.getOfflineBids()`: Retrieve offline bids
- `HiveService.clearOfflineData()`: Clear all offline data

## Error Handling

All sync methods return `ApiResponse<T>` objects that include:

- `success`: Boolean indicating operation success
- `data`: Response data (if successful)
- `message`: Error or success message
- `statusCode`: HTTP status code

## Performance Considerations

1. **Incremental Sync**: Use limited services download for better performance
2. **Background Upload**: Upload offline data when connectivity is restored
3. **Caching Strategy**: Cache frequently accessed data locally
4. **Batching**: Batch multiple offline operations in single upload

## Security

- All API calls require authentication tokens
- Offline data is stored securely using Hive encryption
- Upload operations validate data integrity
- Profile data is cached with proper access controls

This implementation provides complete coverage of all sync APIs from the Postman collection and additional enhanced functionality for better user experience.
