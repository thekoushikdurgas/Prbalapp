# Prbal API Collections Analysis

## Overview
Complete analysis of three Postman collections that define the Prbal services API structure:
- **Services.postman_collection.json**: 13 ServiceViewSet endpoints
- **Requests.postman_collection.json**: 11 ServiceRequestViewSet endpoints  
- **Categories.postman_collection.json**: Categories & SubCategories management

## Standard Response Format
All endpoints follow this consistent format:
```json
{
  "message": "Operation description",
  "data": { /* response data */ },
  "time": "2024-01-20T15:30:45.123Z",
  "statusCode": 200
}
```

## 1. Services API (Services.postman_collection.json)

### Service Management Endpoints (13 total)

#### Core CRUD Operations
1. **List Services** - `GET /api/services/services/`
   - Supports filtering: category, status, provider, currency
   - Search capabilities: name, description, location, tags
   - Ordering: created_at, hourly_rate, min_hours, max_hours
   - Pagination support

2. **Create Service** - `POST /api/services/services/`
   - **Permission**: Provider only
   - Required fields: name, description, category, hourly_rate
   - Optional: subcategories, pricing_options, availability, location

3. **Retrieve Service** - `GET /api/services/services/{id}/`
   - Public access for service details
   - Includes provider info, category, availability

4. **Update Service** - `PUT /api/services/services/{id}/`
   - **Permission**: Owner only
   - Full update of service details

5. **Partial Update** - `PATCH /api/services/services/{id}/`
   - **Permission**: Owner only
   - Update specific fields only

6. **Delete Service** - `DELETE /api/services/services/{id}/`
   - **Permission**: Owner only
   - Soft delete with impact analysis

#### Advanced Features
7. **Find Nearby Services** - `GET /api/services/services/nearby/`
   - Location-based search using latitude/longitude
   - Radius filtering in kilometers
   - Distance calculation and sorting

8. **Admin View** - `GET /api/services/services/admin/`
   - **Permission**: Admin only
   - Enhanced data with statistics and management info

9. **Trending Services** - `GET /api/services/services/trending/`
   - Algorithm-based trending calculation
   - Timeframe support: day, week, month
   - Scoring based on views, bookings, ratings

10. **Matching Requests** - `GET /api/services/services/matching_requests/`
    - **Permission**: Provider only
    - AI-powered request matching
    - Distance and budget compatibility

11. **Filter by Availability** - `GET /api/services/services/by_availability/`
    - Real-time availability checking
    - Date/time slot validation
    - Duration compatibility

12. **Matching Services for Request** - `GET /api/services/services/{id}/matching_services/`
    - Find compatible services for a request
    - Budget and location matching
    - Rating and urgency compatibility

13. **Fulfill Service Request** - `POST /api/services/services/{id}/fulfill_request/`
    - **Permission**: Provider only
    - Accept and fulfill customer requests
    - Proposal submission with terms

### Key Service Model Fields
```dart
class Service {
  String id, name, description, location, status, currency;
  Map<String, dynamic> provider, category;
  List<Map<String, dynamic>> subcategories, serviceImages;
  List<String> tags, requiredTools;
  double hourlyRate, latitude?, longitude?;
  int? minHours, maxHours;
  bool isFeatured;
  Map<String, dynamic>? pricingOptions, availability;
  DateTime createdAt, updatedAt;
}
```

## 2. Service Requests API (Requests.postman_collection.json)

### Request Management Endpoints (11 total)

#### Core CRUD Operations
1. **List Requests** - `GET /api/services/requests/`
   - Public listing of open requests
   - Filtering and pagination support

2. **Create Request** - `POST /api/services/requests/`
   - **Permission**: Customer only
   - Required: title, description, category, budget_min, budget_max

3. **Retrieve Request** - `GET /api/services/requests/{id}/`
   - Public access to request details
   - Includes customer info and requirements

4. **Update Request** - `PUT /api/services/requests/{id}/`
   - **Permission**: Owner only
   - Full request update

5. **Partial Update** - `PATCH /api/services/requests/{id}/`
   - **Permission**: Owner only
   - Update specific fields

6. **Delete Request** - `DELETE /api/services/requests/{id}/`
   - **Permission**: Owner only
   - Impact analysis included

#### Specialized Operations
7. **My Requests** - `GET /api/services/requests/my_requests/`
   - **Permission**: Customer only
   - Personal request management

8. **Admin View** - `GET /api/services/requests/admin/`
   - **Permission**: Admin only
   - Complete request oversight

9. **Recommended Providers** - `GET /api/services/requests/{id}/recommended_providers/`
   - **Permission**: Owner or Admin
   - AI-powered provider matching

10. **Batch Expire** - `POST /api/services/requests/batch_expire/`
    - **Permission**: Admin only
    - Bulk operations for expired requests

11. **Cancel Request** - `POST /api/services/requests/{id}/cancel/`
    - **Permission**: Owner or Admin
    - Request cancellation with impact analysis

### Key ServiceRequest Model Fields
```dart
class ServiceRequest {
  String id, title, description, location, currency, urgency, status;
  Map<String, dynamic> customer, category;
  List<Map<String, dynamic>> subcategories, requestImages;
  double budgetMin, budgetMax, latitude?, longitude?;
  DateTime requestedDateTime, createdAt, updatedAt, expiresAt?;
  Map<String, dynamic>? requirements;
  int interestedProvidersCount, viewCount;
}
```

## 3. Categories API (Categories.postman_collection.json)

### Category Management (6 endpoints)
1. **List Categories** - `GET /api/services/categories/`
2. **Create Category** - `POST /api/services/categories/` (Admin only)
3. **Get Category** - `GET /api/services/categories/{id}/`
4. **Update Category** - `PUT /api/services/categories/{id}/` (Admin only)
5. **Partial Update** - `PATCH /api/services/categories/{id}/` (Admin only)
6. **Delete Category** - `DELETE /api/services/categories/{id}/` (Admin only)
7. **Statistics** - `GET /api/services/categories/statistics/` (Admin only)

### SubCategory Management (6 endpoints)
1. **List SubCategories** - `GET /api/services/subcategories/`
2. **Create SubCategory** - `POST /api/services/subcategories/` (Admin only)
3. **Get SubCategory** - `GET /api/services/subcategories/{id}/`
4. **Update SubCategory** - `PUT /api/services/subcategories/{id}/` (Admin only)
5. **Partial Update** - `PATCH /api/services/subcategories/{id}/` (Admin only)
6. **Delete SubCategory** - `DELETE /api/services/subcategories/{id}/` (Admin only)

## Permission Matrix

| User Type | Categories | SubCategories | Services | Requests |
|-----------|------------|---------------|----------|----------|
| **Anonymous** | Read only | Read only | Read only | Read only |
| **Customer** | Read only | Read only | Read only | Full CRUD (own) |
| **Provider** | Read only | Read only | Full CRUD (own) | Read only |
| **Admin** | Full CRUD | Full CRUD | Full access | Full access |

## API Patterns Identified

### Filtering Patterns
- `active_only=true` - Filter active items
- `search=query` - Text search in relevant fields
- `ordering=field` - Sort by field (use `-` for descending)
- `category=uuid` - Filter by category
- `status=value` - Filter by status

### Location Patterns
- `latitude` & `longitude` - Geographic coordinates
- `radius` - Search radius in kilometers
- `max_distance` - Maximum distance filter

### Pagination Patterns
- `page=1` - Page number
- `page_size=10` - Items per page
- Response includes `count`, `next`, `previous`

### Response Patterns
- Consistent `{message, data, time, statusCode}` format
- Detailed error messages with validation info
- Impact analysis for destructive operations
- Performance timing information

## Implementation Priorities

### High Priority (Core Functionality)
1. ✅ Categories management (already implemented)
2. ✅ SubCategories management (already implemented)
3. 🔄 Services management (partial - needs completion)
4. 🔄 Service Requests management (missing)

### Medium Priority (Enhanced Features)
1. 📍 Location-based service discovery
2. 🔍 Advanced search and filtering
3. 📈 Trending and recommendation algorithms
4. 📊 Admin statistics and analytics

### Low Priority (Optimization)
1. 💾 Advanced caching strategies
2. 📡 Real-time updates via WebSocket
3. 🔄 Background sync and offline support
4. 📱 Push notifications integration

## Security Considerations

### Authentication Requirements
- JWT Bearer token for authenticated endpoints
- Role-based access control (RBAC)
- Owner-only access for sensitive operations

### Data Validation
- Input sanitization and validation
- Business rule enforcement
- Rate limiting considerations

### Privacy Protection
- Customer data protection
- Location data handling
- Service provider verification

## Performance Optimizations

### Caching Strategy
- Categories: 30-minute cache (stable data)
- Services: 15-minute cache (dynamic data)
- Requests: Real-time (time-sensitive)

### API Efficiency
- Pagination for large datasets
- Field selection for mobile optimization
- Compression for response data
- CDN for static assets (icons, images) 