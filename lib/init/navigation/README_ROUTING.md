# Modular Routing System

This directory contains a modular routing system that breaks down the large router configuration into smaller, manageable chunks.

## File Structure

```text

lib/init/navigation/
├── README_ROUTING.md          # This documentation
├── navigation_route.dart      # Route navigation utilities
├── navigation_routers.dart    # Main router configuration
├── router_guard.dart          # Authentication and redirect logic
├── router_utils.dart          # Common utilities and transitions
└── routes/
    ├── core_routes.dart           # Core app routes (splash, onboarding)
    ├── auth_routes.dart           # Authentication routes
    ├── main_navigation_routes.dart # Main navigation routes
    └── feature_routes.dart        # Feature routes (chat, payments, etc.)
```

## Components

### 1. Route Enum (`lib/product/enum/route_enum.dart`)

- Centralized route constants
- Organized by feature groups
- Type-safe route definitions
- Includes both new and legacy routes for backward compatibility

### 2. Router Utils (`router_utils.dart`)

- Custom page transitions
- Common utility functions
- Error page builders
- Reusable transition animations

### 3. Router Guard (`router_guard.dart`)

- Authentication flow management
- Redirect logic separation
- Onboarding flow handling
- Clean, testable authentication checks

### 4. Route Modules (`routes/` directory)

#### Core Routes (`core_routes.dart`)

- Splash screen
- Onboarding
- Welcome screen

#### Authentication Routes (`auth_routes.dart`)

- OTP verification
- PIN entry
- Authentication screens

#### Main Navigation Routes (`main_navigation_routes.dart`)

- Home
- Explore
- Orders
- Settings
- Language selection

#### Feature Routes (`feature_routes.dart`)

- Chat functionality
- Payment screens
- Booking details
- Service details
- Image viewing

### 5. Main Router (`navigation_routers.dart`)

- Combines all route modules
- Provides both legacy and new router configurations
- Uses Provider pattern for dependency injection

## Usage durgass

### Basic Navigation

```dart
// Using the existing navigation utilities
NavigationRoute.goRouteNormal(RouteEnum.home.rawValue);
NavigationRoute.goRouteClear(RouteEnum.welcome.rawValue);
```

### Provider-based Router (Future Implementation)

```dart
// In your app widget
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
```

### Adding New Routes

1. Add route constant to `RouteEnum`
2. Add route to appropriate route module
3. Import necessary screens
4. Update router configuration if needed

## Migration Path

### Current State

- Legacy router in `navigation_routers.dart` works with existing screens
- New modular structure ready for implementation
- TODO comments mark areas needing screen imports

### Next Steps

1. Import all required screen widgets
2. Uncomment route configurations
3. Import and configure services (AuthService, HiveService)
4. Enable router guard functionality
5. Switch to provider-based router
6. Test all navigation flows

## Benefits

### Maintainability

- Separated concerns
- Smaller, focused files
- Easy to locate specific routes
- Clear dependencies

### Scalability

- Easy to add new route modules
- Modular structure supports team development
- Clear patterns for new features

### Testing

- Individual route modules can be tested
- Router guard logic is isolated
- Utilities are reusable and testable

### Performance

- Lazy loading of route configurations
- Efficient navigation with proper transitions
- Clean state management

## Best Practices

### Route Organization

- Group related routes together
- Use descriptive module names
- Keep route builders simple
- Extract complex logic to separate functions

### Error Handling

- Consistent error page design
- Proper error logging
- User-friendly error messages
- Fallback routes for edge cases

### Navigation Patterns

- Use type-safe route constants
- Consistent parameter passing
- Proper use of route extras
- Clean navigation history management

## Troubleshooting

### Common Issues

1. **Import Errors**: Ensure all screen imports are correct
2. **Route Conflicts**: Check for duplicate route paths
3. **Missing Services**: Ensure all dependencies are available
4. **Navigation Failures**: Verify route parameters and state

### Debug Mode

- Enable `debugLogDiagnostics: true` in GoRouter
- Use Flutter Inspector for navigation debugging
- Check console for route matching logs
