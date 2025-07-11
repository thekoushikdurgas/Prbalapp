# 🚀 Prbal Services API - Complete Analysis

> **Generated from Postman Collections Analysis**  
> **Date**: 2024-01-20  
> **Collections Analyzed**: Categories, Services, Requests  
> **Total Endpoints**: 37 endpoints across 3 ViewSets

---

## 📋 **API Overview**

The Prbal Services API follows a standardized RESTful architecture with consistent response formatting:

```json
{
  "message": "Operation completed successfully",
  "data": { /* Response payload */ },
  "time": "2024-01-20T15:30:45.123Z",
  "statusCode": 200
}
```

### **🔐 Authentication & Permissions**

- **JWT Bearer Token** authentication
- **Role-based access control**: Admin, Provider, Customer
- **Permission levels**:
  - Read operations: Public/Authenticated
  - Write operations: Role-specific restrictions

---

## 🗂️ **Categories API (13 Endpoints)**

### **ServiceCategoryViewSet (7 endpoints)**

| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| `GET` | `/categories/` | Public | List categories with filtering |
| `GET` | `/categories/{id}/` | Public | Get category details |
| `POST` | `/categories/` | Admin Only | Create new category |
| `PUT` | `/categories/{id}/` | Admin Only | Update category |
| `PATCH` | `/categories/{id}/` | Admin Only | Partial update category |
| `DELETE` | `/categories/{id}/` | Admin Only | Delete category |
| `GET` | `/categories/statistics/` | Admin Only | Category statistics |

**🔍 Query Parameters:**

- `active_only`: Filter active categories
- `search`: Search in name, description
- `ordering`: Sort by name, sort_order, created_at
- `page`, `page_size`: Pagination

**📊 Response Features:**

- Pagination support
- Impact analysis on deletion
- Sort order management
- Icon URL support

### **ServiceSubCategoryViewSet (6 endpoints)**

| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| `GET` | `/subcategories/` | Public | List subcategories |
| `GET` | `/subcategories/{id}/` | Public | Get subcategory details |
| `POST` | `/subcategories/` | Admin Only | Create subcategory |
| `PUT` | `/subcategories/{id}/` | Admin Only | Update subcategory |
| `PATCH` | `/subcategories/{id}/` | Admin Only | Partial update subcategory |
| `DELETE` | `/subcategories/{id}/` | Admin Only | Delete subcategory |

**🔍 Query Parameters:**

- `category`: Filter by parent category ID
- `active_only`: Filter active subcategories
- `search`: Search in name, description, category__name
- `ordering`: Sort by name, sort_order, category__name, created_at

---

## 🛠️ **Services API (13 Endpoints)**

### **ServiceViewSet - Complete CRUD & Advanced Features**

| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| `GET` | `/services/` | Public | List services with advanced filtering |
| `POST` | `/services/` | Provider Only | Create new service |
| `GET` | `/services/{id}/` | Public | Get service details |
| `PUT` | `/services/{id}/` | Owner Only | Update service |
| `PATCH` | `/services/{id}/` | Owner Only | Partial update service |
| `DELETE` | `/services/{id}/` | Owner Only | Delete service |
| `GET` | `/services/nearby/` | Public | Find nearby services |
| `GET` | `/services/admin/` | Admin Only | Admin view of all services |
| `GET` | `/services/trending/` | Public | Get trending services |
| `GET` | `/services/matching_requests/` | Provider Only | Get matching requests |
| `GET` | `/services/by_availability/` | Public | Filter by availability |
| `GET` | `/services/{id}/matching_services/` | Public | Find matching services |
| `POST` | `/services/{id}/fulfill_request/` | Provider Only | Fulfill service request |

**🔍 Advanced Query Parameters:**

- **Location**: `latitude`, `longitude`, `radius`, `max_distance`
- **Filtering**: `category`, `subcategories`, `status`, `is_featured`, `provider`
- **Pricing**: `currency`, `budget_range`, `min_budget`
- **Availability**: `date`, `time`, `duration`, `emergency`
- **Quality**: `min_rating`, `verified_only`
- **Business**: `trending_timeframe`, `match_score_threshold`

**📊 Service Features:**

- **Geolocation**: Distance-based search with radius filtering
- **Pricing**: Hourly rates, emergency rates, package deals
- **Availability**: Schedule management, emergency availability
- **Analytics**: Trending scores, view counts, booking analytics
- **AI Matching**: Intelligent request-service matching

---

## 📋 **Service Requests API (11 Endpoints)**

### **ServiceRequestViewSet - Customer Requests & Provider Matching**

| Method | Endpoint | Permission | Description |
|--------|----------|------------|-------------|
| `GET` | `/requests/` | Public | List open service requests |
| `POST` | `/requests/` | Customer Only | Create service request |
| `GET` | `/requests/{id}/` | Public | Get request details |
| `PUT` | `/requests/{id}/` | Owner Only | Update request |
| `PATCH` | `/requests/{id}/` | Owner Only | Partial update request |
| `DELETE` | `/requests/{id}/` | Owner Only | Delete request |
| `GET` | `/requests/my_requests/` | Customer Only | Customer's requests |
| `GET` | `/requests/admin/` | Admin Only | Admin view of all requests |
| `GET` | `/requests/{id}/recommended_providers/` | Owner/Admin | Get recommended providers |
| `POST` | `/requests/batch_expire/` | Admin Only | Batch expire requests |
| `POST` | `/requests/{id}/cancel/` | Owner/Admin | Cancel request |

**🔍 Request Query Parameters:**

- **Status**: `open`, `in_progress`, `fulfilled`, `cancelled`, `expired`
- **Priority**: `low`, `medium`, `high`, `urgent`
- **Budget**: `budget_min`, `budget_max`, `currency`
- **Location**: Geographic filtering
- **Timing**: `requested_date_time`, `expires_at`

**🤖 AI-Powered Features:**

- **Provider Matching**: Algorithm-based provider recommendations
- **Urgency Analysis**: Priority-based sorting and matching
- **Budget Optimization**: Price-compatible service suggestions
- **Geographic Intelligence**: Location-aware provider matching

---

## 🏗️ **Data Models**

### **Category Model**

```json
{
  "id": "uuid",
  "name": "string",
  "description": "string", 
  "icon": "string (optional)",
  "icon_url": "string",
  "sort_order": "integer",
  "is_active": "boolean",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### **Service Model**

```json
{
  "id": "uuid",
  "provider": {
    "id": "uuid",
    "username": "string",
    "first_name": "string", 
    "last_name": "string",
    "rating": "float",
    "total_reviews": "integer",
    "verified": "boolean"
  },
  "name": "string",
  "description": "string",
  "category": "uuid",
  "subcategories": ["uuid"],
  "hourly_rate": "decimal",
  "pricing_options": {
    "emergency_rate": "decimal",
    "weekend_rate": "decimal",
    "package_deals": {}
  },
  "currency": "string",
  "location": "string",
  "latitude": "float",
  "longitude": "float",
  "availability": {},
  "status": "active|pending|inactive",
  "is_featured": "boolean",
  "tags": ["string"]
}
```

### **Service Request Model**

```json
{
  "id": "uuid",
  "customer": {
    "id": "uuid",
    "username": "string",
    "first_name": "string",
    "last_name": "string"
  },
  "title": "string",
  "description": "string", 
  "category": "uuid",
  "budget_min": "decimal",
  "budget_max": "decimal",
  "urgency": "low|medium|high|urgent",
  "status": "open|in_progress|fulfilled|cancelled|expired",
  "location": "string",
  "requested_date_time": "datetime",
  "expires_at": "datetime"
}
```

---

## 🚀 **Implementation Recommendations**

### **Flutter Service Architecture**

1. **ServiceManagementService**: Main service for all API operations
2. **Caching Strategy**: Categories (cache), Services (selective), Requests (no cache)
3. **Real-time Updates**: Stream controllers for live data synchronization
4. **Error Handling**: Standardized error parsing and user-friendly messages
5. **Performance**: Pagination, lazy loading, and efficient memory management

### **Key Implementation Features**

- **Geolocation Integration**: Flutter location services with distance calculations
- **AI-Powered Matching**: Implement recommendation algorithms
- **Real-time Updates**: WebSocket or polling for live request updates
- **Offline Capability**: Hive caching for essential data
- **Performance Monitoring**: Track API response times and user interactions

### **Security Considerations**

- **Token Management**: Automatic JWT refresh with secure storage
- **Role-based UI**: Dynamic interface based on user permissions
- **Data Validation**: Client-side validation matching API requirements
- **Error Sanitization**: Secure error messages without sensitive data exposure

---

## 📊 **Business Intelligence Features**

### **Analytics Capabilities**

- **Service Performance**: Views, bookings, revenue tracking
- **Provider Analytics**: Rating trends, request fulfillment rates
- **Customer Insights**: Request patterns, budget analysis
- **Market Intelligence**: Category popularity, pricing trends
- **Geographic Analysis**: Service density, coverage maps

### **Admin Dashboard Metrics**

- **Service Statistics**: Total services, status distribution
- **Request Analytics**: Open requests, fulfillment rates
- **Provider Performance**: Top providers, verification status
- **Revenue Tracking**: Transaction volumes, fee calculations
- **System Health**: API performance, error rates

---

*This analysis provides the foundation for implementing a comprehensive Flutter service layer that fully leverages the Prbal Services API capabilities.*
