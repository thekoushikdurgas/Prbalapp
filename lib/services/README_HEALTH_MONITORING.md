# Health Monitoring System Documentation

## Overview

The Prbal Flutter app now includes a comprehensive health monitoring system that integrates with backend health APIs to provide real-time system status monitoring. This system tracks system health, database performance, service dependencies, and Prometheus metrics.

## Architecture

### Core Components

1. **HealthService** (`lib/services/health_service.dart`)
   - Main service for health monitoring
   - Handles API communication with health endpoints
   - Provides real-time health status updates

2. **HealthStatusWidget** (`lib/components/health/health_status_widget.dart`)
   - Reusable UI component for displaying health status
   - Can be used in compact or detailed mode
   - Automatically updates health information

3. **HealthDashboard** (`lib/view/health/health_dashboard.dart`)
   - Full-screen health monitoring dashboard
   - Displays comprehensive system metrics
   - Provides detailed health analytics

## API Endpoints Integration

The system integrates with the following health monitoring APIs:

### System Health

- **Endpoint**: `GET /api/v1/health/system/`
- **Purpose**: Monitor system-level metrics
- **Returns**: System status, uptime, memory usage, CPU usage

### Database Health

- **Endpoint**: `GET /api/v1/health/database/`
- **Purpose**: Monitor database performance
- **Returns**: Database status, connection pool info, query performance

### Service Dependencies

- **Endpoint**: `GET /api/v1/health/dependencies/`
- **Purpose**: Monitor external service dependencies
- **Returns**: Overall status and individual service health

### Prometheus Metrics

- **Endpoint**: `GET /metrics/`
- **Purpose**: Collect detailed system metrics
- **Returns**: Raw Prometheus metrics data

## Features

### Real-time Monitoring

- Automatic health checks every 5 minutes
- Metrics collection every minute
- Real-time status updates via streams

### Visual Health Indicators

- Color-coded status indicators (Green/Orange/Red)
- Status icons for quick visual reference
- Progress indicators and health scores

### Comprehensive Dashboard

- System overview with overall health status
- Detailed metrics for each component
- Historical data and trends
- Raw metrics viewer

### Integration Points

- Home page health status widget
- Settings page health monitoring section
- Navigation route to full dashboard
- Performance service integration

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
final dependenciesHealth = await healthService.getDependenciesHealth();

// Collect metrics
final metrics = await healthService.collectMetrics();
```

### Navigation to Health Dashboard

```dart
NavigationRoute.goRouteNormal(RouteEnum.health.rawValue);
```

## Health Status Types

### Status Levels

- **Healthy**: All systems operational
- **Degraded**: Some issues detected, but system functional
- **Unhealthy**: Critical issues detected
- **Unknown**: Unable to determine status
- **Error**: Health check failed

### Health Metrics

- **System Metrics**: CPU usage, memory usage, uptime
- **Database Metrics**: Connection pool, query performance, failed queries
- **Service Metrics**: Response times, availability, error rates

## Configuration

### Monitoring Intervals

```dart
// Configure health check frequency
healthService.configureMonitoring(
  healthCheckInterval: Duration(minutes: 5),
  metricsInterval: Duration(minutes: 1),
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

## Integration with Performance Service

The health monitoring system is integrated with the existing `PerformanceService`:

```dart
// Performance service now includes health monitoring
await PerformanceService.instance.initializePerformanceMonitoring();

// Performance reports include health status
await PerformanceService.instance.reportPerformanceMetrics();
```

## UI Components

### Home Page Integration

- Health status card on main dashboard
- Quick access to detailed health information
- Visual indicators for system status

### Settings Integration

- Health monitoring toggle
- Configuration options
- Historical health data

### Navigation

- Dedicated health dashboard route
- Deep linking support
- Breadcrumb navigation

## Troubleshooting

### Common Issues

1. **Health Service Not Initializing**
   - Check API connectivity
   - Verify endpoint configuration
   - Review authentication tokens

2. **Metrics Not Loading**
   - Confirm Prometheus endpoint accessibility
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

## Future Enhancements

### Planned Features

- Historical health data storage
- Health alerts and notifications
- Custom health check intervals
- Export health reports
- Integration with crash reporting

### API Extensions

- Custom health metrics
- Service-specific health checks
- Real-time health streaming
- Health trend analysis

## Security Considerations

### Data Privacy

- Health data is not stored locally
- API calls use secure HTTPS
- No sensitive information in logs

### Access Control

- Health endpoints require authentication
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

## Conclusion

The health monitoring system provides comprehensive visibility into the Prbal app's backend infrastructure, enabling proactive monitoring and quick issue resolution. The system is designed to be lightweight, efficient, and user-friendly while providing detailed technical information when needed.

For more information or support, refer to the individual service and component documentation files.
