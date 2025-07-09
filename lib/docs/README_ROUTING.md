# Modular Routing System

This directory contains a modular routing system that breaks down the large router configuration into smaller, manageable chunks. The system supports **three user types** with dynamic navigation based on data stored in HiveService.

## User Types & Navigation

### 🔧 Provider (Service Provider)

- **Dashboard**: `/provider-dashboard` - Manage services and bookings
- **Navigation**: Dashboard → Explore → Orders → Settings  
- **Color**: Emerald (#10B981)

### 👑 Admin (Administrator)  

- **Dashboard**: `/admin-dashboard` - System analytics and management
- **Navigation**: Analytics → Users → Moderation → Settings
- **Color**: Violet (#8B5CF6)

### 🏠 Customer (Default)

- **Dashboard**: `/taker-dashboard` - Browse and book services  
- **Navigation**: Home → Explore → Bookings → Profile
- **Color**: Blue (#3B82F6)

## File Structure

```text
lib/init/navigation/
├── README_ROUTING.md          # This documentation
├── navigation_route.dart      # Route navigation utilities
├── navigation_routers.dart    # Main router configuration
├── router_guard.dart          # Authentication and redirect logic (Enhanced for user types)
├── router_utils.dart          # Common utilities and transitions
└── routes/
    ├── core_routes.dart           # Core app routes (splash, onboarding)
    ├── auth_routes.dart           # Authentication routes
    ├── main_navigation_routes.dart # Main navigation routes (Enhanced for user types)
    └── feature_routes.dart        # Feature routes (chat, payments, etc.)
```

## Components

### 1. Route Enum (`lib/product/enum/route_enum.dart`)

- Centralized route constants
- Organized by feature groups
- Type-safe route definitions
- Includes user-type specific dashboard routes:
  - `providerDashboard`: `/provider-dashboard`
  - `adminDashboard`: `/admin-dashboard`  
  - `takerDashboard`: `/taker-dashboard`

### 2. Router Utils (`router_utils.dart`)

- Custom page transitions
- Common utility functions
- Error page builders
- Reusable transition animations

### 3. Router Guard (`router_guard.dart`) - **Enhanced**

- **User-type specific redirects**: Automatically redirects users to appropriate dashboards
- **Permission checking**: Prevents unauthorized access to user-type specific routes
- **HiveService integration**: Uses `HiveService.getUserType()` for route decisions
- **Smart home routing**: Redirects generic `/home` to user-specific dashboard

### 4. Bottom Navigation Integration

- **Dynamic adaptation**: Reads user type from HiveService on initialization
- **Three navigation layouts**: Different icons, labels, and screens per user type
- **Automatic refresh**: Updates when user type changes in storage

### 5. Route Modules (`routes/` directory)

#### Core Routes (`core_routes.dart`)

- Splash screen
- Onboarding  
- Welcome screen

#### Authentication Routes (`auth_routes.dart`)

- OTP verification
- PIN entry
- Authentication screens

#### Main Navigation Routes (`main_navigation_routes.dart`) - **Enhanced**

- Uses `BottomNavigation` component with user-type awareness
- Supports tab-specific routing with query parameters
- Dynamic screen selection based on HiveService data

#### Feature Routes (`feature_routes.dart`) - **Enhanced**  

- User-type specific dashboard routes
- Chat functionality
- Payment screens
- Booking and service details

## Usage Examples

### Basic Navigation with User Types

```dart
// Navigate using RouterGuard helper
final dashboardRoute = RouterGuard.getDashboardRouteForUserType();
context.go(dashboardRoute);

// Check permissions before navigation
if (RouterGuard.hasPermissionForRoute('/add-service')) {
  context.push('/add-service');
}
```

### Bottom Navigation with User Types

```dart
// Automatic user type detection
BottomNavigation(initialIndex: 0)

// Switch user type programmatically  
await BottomNavigation.switchUserType('provider', context);

// Check current user type
String currentType = HiveService.getUserType();
bool isProvider = HiveService.isProvider();
```

### HiveService Integration

```dart
// User type detection
UserType userType = HiveService.getUserType(); // 'provider', 'admin', 'customer'
bool isProvider = HiveService.isProvider();
bool isAdmin = HiveService.isAdmin(); 
bool isCustomer = HiveService.isCustomer();

// UI properties
String displayName = HiveService.getUserTypeDisplayName();
Color userColor = Color(HiveService.getUserTypeColor());

// Update user type
await HiveService.updateUserType('provider');
```

## Router Guard Features

### Automatic Redirects

- **Home routing**: `/home` → user-specific dashboard
- **Wrong dashboard**: Redirects to correct dashboard for user type
- **Permission checking**: Blocks unauthorized access

### User Type Routing Logic

```dart
// Provider access
if (userType == 'provider' && route.contains('provider')) {
  // Allow access
}

// Admin access (can access all routes)
if (userType == 'admin') {
  // Full access granted
}

// Customer access (default routes)  
// Customers can access general routes but not provider/admin specific
```

## Migration Path

### Current Enhanced State

- ✅ HiveService integration complete
- ✅ Three user types fully supported
- ✅ Bottom navigation adapts dynamically
- ✅ Router guard handles user-type redirects
- ✅ Permission system implemented

### Testing User Types

```dart
// Test different user types in development
await HiveService.updateUserType('provider');
// Navigation will automatically adapt

await HiveService.updateUserType('admin');  
// Admin dashboard with full permissions

await HiveService.updateUserType('customer');
// Customer dashboard with standard access
```

## Benefits

### User Experience

- **Personalized navigation**: Each user type sees relevant options
- **Automatic routing**: Smart redirects to appropriate screens
- **Permission protection**: Prevents access to unauthorized features

### Developer Experience  

- **Type safety**: All user types handled consistently
- **Easy testing**: Switch user types programmatically
- **Centralized logic**: User type detection in one place (HiveService)

### Maintainability

- **Modular structure**: Easy to add new user types or routes
- **Clear separation**: User type logic isolated in appropriate files
- **Consistent patterns**: Same approach across all navigation features

## Troubleshooting

### Common Issues

1. **User Type Detection**: Ensure HiveService.getUserData() contains 'userType' field
2. **Route Access**: Check RouterGuard.hasPermissionForRoute() for blocked routes
3. **Navigation Updates**: Call BottomNavigation.refreshUserType() after user type changes
4. **Dashboard Redirects**: Verify user type matches expected route permissions

### Debug Mode

- Enable `debugLogDiagnostics: true` in GoRouter
- Check console for user type detection logs
- Verify HiveService.getUserType() returns expected values
