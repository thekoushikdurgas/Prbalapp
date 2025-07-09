# Health Monitoring System Documentation

## Overview

The Prbal Flutter app includes a simplified health monitoring system that integrates with backend health APIs to provide real-time system status monitoring. This system tracks basic system health and database connectivity using two simple endpoints.

## Architecture

### Core Components

1. **HealthService** (`lib/services/health_service.dart`)
   - Main service for health monitoring
   - Handles API communication with health endpoints
   - Provides real-time health status updates

2. **HealthStatusWidget** (`lib/components/health_status_widget.dart`)
   - Reusable UI component for displaying health status
   - Can be used in compact or detailed mode
   - Automatically updates health information

3. **HealthDashboard** (`lib/screens/auth/health_dashboard.dart`)
   - Full-screen health monitoring dashboard
   - Displays comprehensive system status
   - Provides health overview and analytics

## API Endpoints Integration

The system integrates with the following simplified health monitoring APIs:

### System Health

- **Endpoint**: `GET /health/`
- **Purpose**: Monitor overall system health
- **Expected Response**:

  ```json
  {
    "status": "healthy",
    "version": "1.0.0"
  }
  ```

### Database Health

- **Endpoint**: `GET /health/db/`
- **Purpose**: Monitor database connectivity
- **Expected Response**:

  ```json
  {
    "status": "database_connected"
  }
  ```

## Health Status Types

### Status Levels

- **Healthy**: All systems operational
- **Unhealthy**: Critical issues detected
- **Unknown**: Unable to determine status

### Health Models

#### SystemHealth

- **status**: System health status ("healthy" or other)
- **version**: Application version (e.g., "1.0.0")
- **timestamp**: When the check was performed

#### DatabaseHealth

- **status**: Database connection status ("database_connected" or other)
- **timestamp**: When the check was performed

#### ApplicationHealth

- **system**: SystemHealth instance
- **database**: DatabaseHealth instance
- **overallStatus**: Computed overall health status
- **lastUpdate**: When the health check was last performed

## Features

### Real-time Monitoring

- Automatic health checks every 5 minutes
- Real-time status updates via streams
- Instant UI updates when status changes

### Visual Health Indicators

- Color-coded status indicators (Green/Red/Grey)
- Status icons for quick visual reference
- Clean, modern UI components

### Comprehensive Dashboard

- System overview with overall health status
- Individual component status display
- Refresh functionality for manual updates
- Version information display

### Integration Points

- Home page health status widget
- Settings page health monitoring section
- Navigation route to full dashboard
- Admin service integration

## Usage

### Basic Health Status Display

```dart
// Compact status indicator
HealthStatusWidget(
  isCompact: true,
  showDetails: false,
)

// Detailed status card
HealthStatusWidget(
  showDetails: true,
)
```

### Programmatic Health Checks

```dart
final healthService = HealthService();
await healthService.initialize();

// Get overall health status
final healthCheck = await healthService.performHealthCheck();

// Get specific component health
final systemHealth = await healthService.getSystemHealth();
final databaseHealth = await healthService.getDatabaseHealth();
```

### Navigation to Health Dashboard

```dart
NavigationRoute.goRouteNormal(RouteEnum.health.rawValue);
```

## Configuration

### Monitoring Intervals

```dart
// Configure health check frequency
healthService.configureMonitoring(
  healthCheckInterval: Duration(minutes: 5),
);
```

### API Configuration

Health endpoints are configured in `ApiConfig`:

- Base URL: Configured per environment
- Timeout: 30 seconds for health checks
- Headers: Standard JSON API headers

## Performance Considerations

### Caching

- Health data is cached between checks
- UI updates only when status changes
- Efficient memory usage with stream controllers

### Error Handling

- Graceful degradation when APIs are unavailable
- Retry logic for failed health checks
- User-friendly error messages

### Background Processing

- Health checks run in background
- Non-blocking UI updates
- Automatic cleanup of resources

## UI Components

### Home Page Integration

- Health status card on main dashboard
- Quick access to detailed health information
- Visual indicators for system status

### Settings Integration

- Health monitoring toggle
- Configuration options
- Navigation to full dashboard

### Dashboard Features

- Overall system status indicator
- Individual component status cards
- Manual refresh functionality
- Clean, responsive design

## Health Check Logic

### Overall Status Determination

The overall health status is determined by:

- If either system or database is unhealthy → Overall: Unhealthy
- If either system or database is unknown → Overall: Unknown
- If both are healthy → Overall: Healthy

### Color Coding

- **Green** (`#4CAF50`): Healthy status
- **Red** (`#F44336`): Unhealthy status
- **Grey** (`#9E9E9E`): Unknown status

## Troubleshooting

### Common Issues

1. **Health Service Not Initializing**
   - Check API connectivity
   - Verify endpoint configuration
   - Review authentication tokens

2. **Health Checks Failing**
   - Confirm endpoint accessibility
   - Check network permissions
   - Verify API response format

3. **UI Not Updating**
   - Ensure widget is properly mounted
   - Check stream subscriptions
   - Verify state management

### Debug Information

Enable debug mode to see detailed health monitoring logs:

```dart
// Health service provides detailed debug output
debugPrint('🏥 Health Service: Status updates');
```

## API Response Validation

The system validates API responses to ensure they match expected formats:

### System Health Response Validation

- Must contain `status` field
- Must contain `version` field
- Status should be "healthy" for optimal operation

### Database Health Response Validation

- Must contain `status` field
- Status should be "database_connected" for optimal operation

## Security Considerations

### Data Privacy

- Health data is not stored locally
- API calls use secure HTTPS
- No sensitive information in logs

### Access Control

- Health endpoints may require authentication
- Role-based access to detailed metrics
- Audit logging for health data access

## Testing

### Unit Tests

- Health service API integration
- Status calculation logic
- Error handling scenarios

### Widget Tests

- Health status widget rendering
- User interaction handling
- State management testing

### Integration Tests

- End-to-end health monitoring flow
- API connectivity testing
- Performance impact assessment

## Future Enhancements

### Planned Features

- Historical health data storage
- Health alerts and notifications
- Custom health check intervals
- Export health reports

### API Extensions

- Additional health metrics
- Service-specific health checks
- Real-time health streaming
- Health trend analysis

## Conclusion

The simplified health monitoring system provides essential visibility into the Prbal app's backend infrastructure while maintaining a clean, efficient implementation. The system focuses on the most critical health indicators: overall system status and database connectivity, providing reliable monitoring without unnecessary complexity.

For more information or support, refer to the individual service and component documentation files.
