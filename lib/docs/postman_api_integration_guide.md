# Postman API Integration Guide

This document provides a comprehensive overview of all APIs from the `Services.postman_collection.json` file and how they have been integrated into the Prbal Flutter app services.

## 📋 Overview

The Postman collection contains APIs for:

1. **Authentication** - JWT token management
2. **Service Categories** - Category management
3. **Service Subcategories** - Subcategory management  
4. **Services** - Service CRUD operations
5. **Service Requests** - Request management

## 🔑 Authentication APIs

### JWT Token Management

- `POST /api/token/` - Get JWT access and refresh tokens
- `POST /api/token/refresh/` - Refresh access token

**Integration**: Already handled by `auth_service.dart`

## 📂 Service Categories APIs

### CRUD Operations

- `GET /api/v1/services/categories/` - List all categories
- `GET /api/v1/services/categories/{id}/` - Get specific category
- `POST /api/v1/services/categories/` - Create category (Admin)
- `PUT /api/v1/services/categories/{id}/` - Update category (Admin)
- `PATCH /api/v1/services/categories/{id}/` - Partial update (Admin)
- `DELETE /api/v1/services/categories/{id}/` - Delete category (Admin)
- `GET /api/v1/services/categories/statistics/` - Get statistics (Admin)

**Integration**: Implemented in `service_category_service.dart`

### Models

```dart
class ServiceCategory {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final String? iconUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class ServiceCategoryRequest {
  final String name;
  final String description;
  final bool? isActive;
  final String? iconUrl;
  final int? sortOrder;
}
```

### State Management

- `serviceCategoriesProvider` - StateNotifier for categories list
- `ServiceCategoriesNotifier` - Handles loading, creating, updating, deleting

## 📝 Service Subcategories APIs

### CRUD_Operations

- `GET /api/v1/services/subcategories/` - List all subcategories
- `GET /api/v1/services/subcategories/?category={id}` - Filter by category
- `GET /api/v1/services/subcategories/{id}/` - Get specific subcategory
- `POST /api/v1/services/subcategories/` - Create subcategory (Admin)
- `PUT /api/v1/services/subcategories/{id}/` - Update subcategory (Admin)
- `PATCH /api/v1/services/subcategories/{id}/` - Partial update (Admin)
- `DELETE /api/v1/services/subcategories/{id}/` - Delete subcategory (Admin)

**Integration**: Implemented in `service_subcategory_service.dart`

### Models1

```dart
class ServiceSubcategory {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final bool isActive;
  final String? iconUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### StateManagement

- `serviceSubcategoriesProvider` - Family provider for category-specific subcategories
- `ServiceSubcategoriesNotifier` - Handles subcategory operations

## 🛠️ Enhanced Services APIs

### CRUDOperations

- `GET /api/v1/services/` - List all services
- `GET /api/v1/services/?category={id}` - Filter by category
- `GET /api/v1/services/?min_price={min}&max_price={max}` - Filter by price
- `GET /api/v1/services/?provider={id}` - Filter by provider
- `GET /api/v1/services/{id}/` - Get specific service
- `POST /api/v1/services/` - Create service (Provider)
- `PUT /api/v1/services/{id}/` - Update service (Owner)
- `PATCH /api/v1/services/{id}/` - Partial update (Owner)
- `DELETE /api/v1/services/{id}/` - Delete service (Owner)

### Advanced Operations

- `GET /api/v1/services/nearby/?lat={lat}&lng={lng}&radius={radius}` - Find nearby services
- `GET /api/v1/services/admin/` - Admin view all services
- `GET /api/v1/services/trending/` - Get trending services
- `GET /api/v1/services/matching_requests/` - Get matching requests (Provider)
- `GET /api/v1/services/by_availability/?date={date}&time={time}` - Filter by availability
- `GET /api/v1/services/{requestId}/matching_services/` - Get matching services for request
- `POST /api/v1/services/{requestId}/fulfill_request/` - Fulfill request (Provider)

**Integration**: Implemented in `enhanced_service_service.dart`

### Example Usage

```dart
// Get nearby services
final nearbyServices = await enhancedServiceService.getNearbyServices(
  latitude: 12.9716,
  longitude: 77.5946,
  radius: 10.0,
);

// Get trending services
final trending = await enhancedServiceService.getTrendingServices();
```

## 📋 Service Requests APIs

### CRUDOperations1

- `GET /api/v1/service-requests/` - List all requests
- `GET /api/v1/service-requests/?category={id}` - Filter by category
- `GET /api/v1/service-requests/?urgency={level}` - Filter by urgency
- `GET /api/v1/service-requests/{id}/` - Get specific request
- `POST /api/v1/service-requests/` - Create request (Customer)
- `PUT /api/v1/service-requests/{id}/` - Update request (Owner)
- `PATCH /api/v1/service-requests/{id}/` - Partial update (Owner)
- `DELETE /api/v1/service-requests/{id}/` - Delete request (Owner)

### Customer Operations

- `GET /api/v1/service-requests/my_requests/` - Get my requests
- `GET /api/v1/service-requests/{id}/recommended_providers/` - Get recommended providers
- `POST /api/v1/service-requests/{id}/cancel/` - Cancel request

### Admin Operations

- `GET /api/v1/service-requests/admin/` - Admin view all requests
- `POST /api/v1/service-requests/batch_expire/` - Batch expire requests

**Integration**: Implemented in `service_request_service.dart`

### Models2

```dart
class ServiceRequest {
  final String id;
  final String customerId;
  final String title;
  final String description;
  final String categoryId;
  final List<String> subcategoryIds;
  final double budgetMin;
  final double budgetMax;
  final String currency;
  final String urgency; // 'low', 'medium', 'high'
  final DateTime? requestedDateTime;
  final String location;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? requirements;
  final String status; // 'open', 'fulfilled', 'cancelled', 'expired'
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### State Management1

- `serviceRequestsProvider` - StateNotifier for all service requests
- `myServiceRequestsProvider` - StateNotifier for user's own requests

## 🔄 State Management Integration

### Riverpod Providers

All services are integrated with Riverpod for state management:

```dart
// Service Category Management
final serviceCategoriesProvider = StateNotifierProvider<ServiceCategoriesNotifier, AsyncValue<List<ServiceCategory>>>;

// Service Subcategory Management  
final serviceSubcategoriesProvider = StateNotifierProvider.family<ServiceSubcategoriesNotifier, AsyncValue<List<ServiceSubcategory>>, String?>;

// Service Request Management
final serviceRequestsProvider = StateNotifierProvider<ServiceRequestsNotifier, AsyncValue<List<ServiceRequest>>>;
final myServiceRequestsProvider = StateNotifierProvider<MyServiceRequestsNotifier, AsyncValue<List<ServiceRequest>>>;

// Enhanced Service Management
final enhancedServiceServiceProvider = Provider<EnhancedServiceService>;
```

## 🚀 Usage Examples

### Service Categories

```dart
// Load categories
final categoriesNotifier = ref.read(serviceCategoriesProvider.notifier);
await categoriesNotifier.loadCategories();

// Create category
await categoriesNotifier.createCategory(ServiceCategoryRequest(
  name: 'Home Cleaning',
  description: 'Professional home cleaning services',
  isActive: true,
));
```

### Service Requests

```dart
// Create service request
final requestNotifier = ref.read(serviceRequestsProvider.notifier);
await requestNotifier.createServiceRequest(ServiceRequestRequest(
  title: 'Need Home Cleaning',
  description: 'Looking for professional cleaning service',
  categoryId: 'category_id',
  subcategoryIds: ['subcategory_id'],
  budgetMin: 500,
  budgetMax: 1000,
  currency: 'INR',
  urgency: 'medium',
  location: 'Bangalore, India',
  latitude: 12.9716,
  longitude: 77.5946,
));
```

### Enhanced Services

```dart
// Find nearby services
final enhancedService = ref.read(enhancedServiceServiceProvider);
final nearbyResponse = await enhancedService.getNearbyServices(
  latitude: 12.9716,
  longitude: 77.5946,
  radius: 10.0,
);

if (nearbyResponse.success) {
  final services = nearbyResponse.data!;
  // Use services...
}
```txt

## 📁 File Structure

```txt

lib/services/
├── api_service.dart                    # Base API service
├── service_category_service.dart       # Service categories management
├── service_subcategory_service.dart    # Service subcategories management
├── service_request_service.dart        # Service requests management
├── enhanced_service_service.dart       # Enhanced services management
├── index.dart                          # Services barrel file
└── postman_api_integration_guide.md    # This documentation
```

## 🔧 Integration Status

- ✅ **Authentication APIs** - Already integrated in `auth_service.dart`
- ✅ **Service Categories APIs** - Implemented in `service_category_service.dart`
- ✅ **Service Subcategories APIs** - Implemented in `service_subcategory_service.dart`
- ✅ **Service Requests APIs** - Implemented in `service_request_service.dart`
- ✅ **Enhanced Services APIs** - Implemented in `enhanced_service_service.dart`
- ✅ **State Management** - All services integrated with Riverpod
- ✅ **Models & DTOs** - Complete data models for all entities

## 🎯 Next Steps

1. **Testing** - Add unit tests for all new services
2. **UI Integration** - Create UI screens that use these services
3. **Error Handling** - Enhance error handling and user feedback
4. **Caching** - Add local caching for offline support
5. **Performance** - Optimize API calls and state updates

## 📚 API Reference

For complete API documentation, refer to the `APIEndpoints` class in `index.dart` which contains all endpoint URLs organized by category.
