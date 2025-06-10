import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'auth_service.dart';
import 'hive_service.dart';
import 'service_management_service.dart';

/// Centralized service providers for the entire app
class AppServices {
  static bool _initialized = false;

  /// Initialize all app services
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize Hive storage first
      await HiveService.init();

      // Initialize API service
      ApiService().initialize();

      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize app services: $e');
    }
  }

  /// Check if services are initialized
  static bool get isInitialized => _initialized;

  /// Cleanup resources on app termination
  static Future<void> cleanup() async {
    try {
      await HiveService.close();
      ApiService().dispose();
      _initialized = false;
    } catch (e) {
      // Log error but don't throw
      debugPrint('Error during cleanup: $e');
    }
  }
}

/// Main API service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final service = ApiService();
  service.initialize();
  return service;
});

/// Service management provider
final serviceManagementProvider = Provider<ServiceManagementService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ServiceManagementService(apiService);
});

/// Combined auth provider that includes initialization
final authProvider = StateNotifierProvider<AuthService, AppUser?>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final authService = AuthService(apiService);

  // Initialize auth service when provider is created
  Future.microtask(() async {
    try {
      await authService.initialize();
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
    }
  });

  return authService;
});

/// Convenience providers for specific states

/// Authentication status provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user != null;
});

/// User verification status provider
final isVerifiedProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user?.isVerified ?? false;
});

/// User type provider
final userTypeProvider = Provider<String?>((ref) {
  final user = ref.watch(authProvider);
  return user?.userType;
});

/// Is provider check
final isProviderProvider = Provider<bool>((ref) {
  final userType = ref.watch(userTypeProvider);
  return userType == 'provider';
});

/// Is customer check
final isCustomerProvider = Provider<bool>((ref) {
  final userType = ref.watch(userTypeProvider);
  return userType == 'customer';
});

/// Is admin check
final isAdminProvider = Provider<bool>((ref) {
  final userType = ref.watch(userTypeProvider);
  return userType == 'admin';
});

/// User display name provider
final userDisplayNameProvider = Provider<String?>((ref) {
  final user = ref.watch(authProvider);
  return user?.displayName;
});

/// User balance provider
final userBalanceProvider = Provider<String?>((ref) {
  final user = ref.watch(authProvider);
  return user?.balance;
});

/// User rating provider
final userRatingProvider = Provider<double?>((ref) {
  final user = ref.watch(authProvider);
  return user?.rating;
});

/// Services provider for customers
final servicesProvider = FutureProvider.autoDispose
    .family<List<Service>, Map<String, dynamic>?>((ref, filters) async {
  final serviceManagement = ref.watch(serviceManagementProvider);

  final response = await serviceManagement.getServices(
    category: filters?['category'] as String?,
    location: filters?['location'] as String?,
    isFeatured: filters?['isFeatured'] as bool?,
    search: filters?['search'] as String?,
    page: filters?['page'] as int?,
    limit: filters?['limit'] as int?,
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load services');
  }
});

/// Featured services provider
final featuredServicesProvider = FutureProvider.autoDispose
    .family<List<Service>, String?>((ref, location) async {
  final serviceManagement = ref.watch(serviceManagementProvider);

  final response = await serviceManagement.getFeaturedServices(
    limit: 10,
    location: location,
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load featured services');
  }
});

/// User bookings provider
final userBookingsProvider = FutureProvider.autoDispose
    .family<List<Booking>, String?>((ref, status) async {
  final serviceManagement = ref.watch(serviceManagementProvider);

  final response = await serviceManagement.getBookings(
    status: status,
    limit: 50,
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load bookings');
  }
});

/// Provider bookings (for service providers)
final providerBookingsProvider = FutureProvider.autoDispose
    .family<List<Booking>, String?>((ref, status) async {
  final serviceManagement = ref.watch(serviceManagementProvider);

  final response = await serviceManagement.getProviderBookings(
    status: status,
    limit: 50,
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load provider bookings');
  }
});

/// Provider services (for service providers)
final providerServicesProvider =
    FutureProvider.autoDispose<List<Service>>((ref) async {
  final serviceManagement = ref.watch(serviceManagementProvider);

  final response = await serviceManagement.getProviderServices(
    limit: 100,
  );

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load provider services');
  }
});

/// Service categories provider
final categoriesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final serviceManagement = ref.watch(serviceManagementProvider);

  final response = await serviceManagement.getCategories();

  if (response.success && response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message ?? 'Failed to load categories');
  }
});

/// Utility providers for common operations

/// Logout provider
final logoutProvider = Provider<Future<void> Function()>((ref) {
  final authService = ref.read(authProvider.notifier);

  return () async {
    await authService.signOut();
    // Invalidate all cached providers
    ref.invalidateSelf();
    ref.invalidate(servicesProvider);
    ref.invalidate(userBookingsProvider);
    ref.invalidate(providerBookingsProvider);
    ref.invalidate(providerServicesProvider);
  };
});

/// Refresh user data provider
final refreshUserProvider =
    Provider<Future<ApiResponse<AppUser>> Function()>((ref) {
  final authService = ref.read(authProvider.notifier);

  return () async {
    final response = await authService.getCurrentUserProfile();
    if (response.success && response.data != null) {
      // Refresh dependent providers
      ref.invalidate(userBookingsProvider);
      ref.invalidate(providerBookingsProvider);
      ref.invalidate(providerServicesProvider);
    }
    return response;
  };
});

/// Error handling utility
class AppError {
  final String message;
  final String? code;
  final int? statusCode;

  AppError(this.message, {this.code, this.statusCode});

  @override
  String toString() => message;

  /// Create error from API response
  static AppError fromApiResponse(ApiResponse response) {
    return AppError(
      response.message ?? 'An error occurred',
      statusCode: response.statusCode,
    );
  }
}
